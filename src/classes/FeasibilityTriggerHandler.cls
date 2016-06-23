/*
    * Name: FeasibilityTriggerHandler Class
    * Created On: January 27, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the FeasibilityTrigger, FeasibilityTriggerHandler is called for:: 
    *              => execute() - Submit/Resubmit Feasibility via FeasibilityInterface.
    *                           - Call SSP Account Interface to get ssp account number for the associated Company__c
    *              => executeAfterUpdate() - Add to BC logic
    *              => executeBeforeUpdate() - Check the Restricted__c Checkbox if any field which is not present in the FieldSet 'EditSet' is changed.
    *              => RunValidations() - Validation [Checks that all Feasibilities under an SOID have the same Product Variant, Flavor, Nimble Type and Class of Service Variant]
    *              => deleteChildFeasibility() - Delete Child Link FANs at resubmission of Parent FAN.
    *              => createChildFeasibility() - Method used to create child feasibility object
    *              => addDrops() - Autocreation of Drops.
    * 
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 27-01-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
    * |   0.2   | Vaibhaw    | 09-04-2016 | Added Clonning Code       |
    * |---------------------------------------------------------------| 
    * |   0.3   | Nupoor     | 19-04-2016 | SSP Account Validation    |
    * |---------------------------------------------------------------| 
*/
public without sharing class FeasibilityTriggerHandler {
    
    
    /*
     *  execute() Purpose : Submit/Resubmit Feasibility via FeasibilityInterface.
     *                    : Call SSP Account Interface to get ssp account number for the associated Company__c
     */
    public static void execute(List<Feasibility__c> newlist, Map<Id, Feasibility__c> mapOld, 
                               Boolean IsInsert, Boolean IsUpdate, Boolean IsBefore, Boolean IsAfter)
    {
        System.Debug('FeasibilityTriggerHandler------ Execute()');
        //Search for the records to be sent via FeasibilityInterface callout in after insert/update scenarios
        //This list will be processed to create the JSON string for Feasibility Interface.
        
        List<Feasibility__c> ListForInterface = new List<Feasibility__c>();
        List<Feasibility__c> ListForSSPAccountInterface = new List<Feasibility__c>();
        for(Feasibility__c NewObj : newlist)
        { if(   (isInsert && NewObj.Submit_to_AMT__c) 
            || (isUpdate && NewObj.Submit_to_AMT__c && NewObj.Submit_to_AMT__c!= mapold.get(NewObj.Id).Submit_to_AMT__c) 
            || (isUpdate && NewObj.Submit_to_AMT__c && NewObj.Resubmit_to_AMT__c && NewObj.Resubmit_to_AMT__c != mapold.get(NewObj.Id).Resubmit_to_AMT__c )
            )
            ListForInterface.add(NewObj);
         //Get the records which need to call the SSP Account Interface
          if( NewObj.Is_Single_Invoice_Required__c == 'Y' && String.IsBlank( NewObj.SSP_Account_Integration__c) )
              ListForSSPAccountInterface.add( NewObj ) ;
        }
        
        if( ListForInterface.size() > 0 )
             GenerateEmpowerREST.execute(ListForInterface);
        if( ListForSSPAccountInterface.size() > 0)
            GenerateEmpowerREST.executeSSP(ListForSSPAccountInterface);
        
        
    }
    
    /*
     * executeAfterUpdate()
     * Purpose : Add To BC logic. Upsert BC [key__c as External ID] with appropriate RecordTypeId.
     *           BC Fields to be Populated: Key__c(SOID), Opportunity__c, Product__c
     *           Add a FAN-BC record for each Feasibility where Add to BC is checked.
     *           BC RecordTypeId is fetched from Custom Metadata Type - Feasibility_RecordType_Mapping__mdt
     *           => key = ProductName ~ OpportunityType
     *           If no RecordTypeId is found, throw an error that is fetched from the label 
     *           => "BC_Scenario_specific_RecordType_is_unavailable"
     *           => IF Number of Links is more then 1, Auto Add to BC all the Child Feasibility
     *           => BC Drop record creation
     */
    public static void executeAfterUpdate(List<feasibility__c> newList, Map<ID, Feasibility__c> oldMap, Map<ID, Feasibility__c> newMap)
    {
        System.Debug('FeasibilityTriggerHandler------ executeAfterUpdate()') ;
        //The list of FAN_BC__c  records which will be inserted.
        List<Fan_BC__c> FAN_BC_List = new List<Fan_BC__c>();
        //The list of Business_Case__c records which will be upserted with key__c
        List<Business_Case__c> BC_List = new List<Business_Case__c>();
        //The Set to mantain uniqueness in upsert for BC_List
        Set<String> BC_Key_set = new SET<String>();
        //List of Feasbility to be added to BC Object
        List<Id> feasibilityToBeAddedToBC = new List<Id>();
        Map<Id, FAN_BC__c> FanBCMap = new Map<Id, FAN_BC__c>();
        
        //Initialize the RecordType Maps to access later in code for BC RecordType
        RaiseFeasibilityController.initializeRecordTypeMap();
        
        Set<id> MultiMediaListParent = new Set<Id>();
        List<id> MultiMediaListChild = new List<Id>();
        List<Id> selectedMultiMediaFAN = new List<Id>();

        List<Id> linkRelatedFAN = new List<Id>();
        
        for(Feasibility__c newObj : [Select Id, Product_Variant__c, Add_to_BC__c, Opportunity__c, Opportunity__r.SOID__c, Opportunity__r.Type, Opportunity__r.MACD_Type__c, Opportunity__r.Green_Channel_Opportunity__c, Product__r.Name, Flavor__c,  Is_Multimedia_FAN__c, Parent_Feasibility__c, Number_of_Links_required__c from Feasibility__c where ID IN :newList])
        {
            if( newObj.Add_to_BC__c && (newObj.Add_to_BC__c != oldMap.get(newObj.id).Add_to_BC__c) )
            {
               feasibilityToBeAddedToBC.add(newObj.Id); 
               
               if(newObj.Is_Multimedia_FAN__c=='Y'){
                   if(newObj.Parent_Feasibility__c <> null){
                     MultiMediaListParent.add(newObj.Parent_Feasibility__c);
                   }else{
                     MultiMediaListChild.add(newObj.Id);
                   }
                   selectedMultiMediaFAN.add(newObj.Id);
               }
               
              //IF Number of Links is more then 1, Auto Add to BC all the Child Feasibility 
              if(newObj.Number_of_Links_required__c > 1){
                  linkRelatedFAN.add(newObj.Id);
              }
               
               //Create BC if it is not already created for this Opportunity ID
               if( BC_Key_set.contains( newObj.Opportunity__r.SOID__c ) == false)
               {
                   Business_Case__c BC = new Business_Case__c();
                   BC.Key__c = newObj.Opportunity__r.SOID__c ;
                   BC.Opportunity__c = newObj.Opportunity__c ;
                   BC.Product__c = newObj.Product__c ;
                   BC.Variant__c = newObj.Product_Variant__c ;
                   
                   if(String.IsBlank(newObj.Opportunity__r.MACD_Type__c) )
                    BC.RecordtypeId = RaiseFeasibilityController.getRecordType( newObj.Product__r.Name, 
                                                                               newObj.Opportunity__r.Type, 
                                                                               newObj.Opportunity__r.Green_Channel_Opportunity__c,
                                                                               'Business Case') ;
                   else
                    BC.RecordtypeId = RaiseFeasibilityController.getRecordTypeMacD( newObj.Product__r.Name, 
                                                                                   newObj.Opportunity__r.MACD_Type__c, 
                                                                                   newObj.Opportunity__r.Green_Channel_Opportunity__c,
                                                                                   'Business Case') ; 
                   if( String.IsBlank(BC.RecordtypeId) )
                      newMap.get(newObj.Id).addError(System.Label.BC_Scenario_specific_RecordType_is_unavailable);
                   else
                   { 
                       BC_Key_set.add( newObj.Opportunity__r.SOID__c ) ;
                       BC_List.add( BC ) ;
                   }
               }
                //Create FAN_BC record for each FAN where Add_to_BC__c is checked.
                Business_Case__c BCref = new Business_Case__c( key__c = newObj.Opportunity__r.SOID__c );
                FAN_BC__c new_FAN_BC = new FAN_BC__c();
                new_FAN_BC.Business_Case__r = BCref ;
                new_FAN_BC.Feasibility__c = newObj.Id;
                if(newObj.Flavor__c=='L2MC'){
                    new_FAN_BC.L2MC_Discount__c = 0;
                }
                if(String.IsBlank(newObj.Opportunity__r.MACD_Type__c) )
                 new_FAN_BC.RecordtypeId = RaiseFeasibilityController.getRecordType( newObj.Product__r.Name, 
                                                                               newObj.Opportunity__r.Type, 
                                                                               newObj.Opportunity__r.Green_Channel_Opportunity__c,
                                                                               'FAN BC') ;
                else
                 new_FAN_BC.RecordtypeId = RaiseFeasibilityController.getRecordTypeMacD( newObj.Product__r.Name, 
                                                                               newObj.Opportunity__r.MACD_Type__c, 
                                                                               newObj.Opportunity__r.Green_Channel_Opportunity__c,
                                                                               'FAN BC') ;
                  if( String.IsBlank(new_FAN_BC.RecordtypeId) )
                      newMap.get(newObj.Id).addError(System.Label.FAN_BC_Scenario_specific_RecordType_is_unavailable);
                  else
                      FAN_BC_List.add( new_FAN_BC ) ;
                 
                 FanBCMap.put(newObj.Id, new_FAN_BC);     
            }
        }
                        
        Schema.SObjectField f = Business_Case__c.Fields.Key__c;
        Database.UpsertResult[] ur = Database.upsert( BC_List , f , false);
        Database.SaveResult[] sr = Database.insert( FAN_BC_List, false);
        System.Debug('BC Result : '+ur);
        System.Debug('BC Result : '+sr);
        //BC Drop record creation
        List<BC_Drop__c> dropsForBCList = new List<BC_Drop__c>();
        
        for(Drop__c dropsForBC : [Select id, Drop_Id__c, Feasibility__c, Feasibility__r.Opportunity__r.SOID__c from Drop__c where Feasibility__c in : feasibilityToBeAddedToBC]){
            BC_Drop__c drop = new BC_Drop__c();
            drop.Drop_Id__c = dropsForBC.Drop_Id__c;
            drop.Drop__c = dropsForBC.Id;
            drop.FAN_BC__c = ((FAN_BC__c)FanBCMap.get(dropsForBC.Feasibility__c)).Id;
            
            dropsForBCList.add(drop);
        }
        
        Database.SaveResult[] dropBCInsertResult = Database.insert( dropsForBCList, false);
        
        List<Feasibility__C> feasbilityList = [Select id, FAN_Status__c from Feasibility__c where 
                                                (Parent_Feasibility__c in :MultiMediaListParent and id in : MultiMediaListParent)
                                                 and id not in :selectedMultiMediaFAN];
        
        for(Feasibility__c objFeasibility  : feasbilityList){
           objFeasibility.FAN_Status__c = 'Dropped';
        }
        update feasbilityList;
        
        feasbilityList = [Select id, FAN_Status__c from Feasibility__c where 
                                                Parent_Feasibility__c in :MultiMediaListChild];
        
        for(Feasibility__c objFeasibility  : feasbilityList){
           objFeasibility.FAN_Status__c = 'Dropped';
        }
        update feasbilityList;
        
        //Update the Link FAN
        if(linkRelatedFAN.size()>0){
            List<Feasibility__c> linkFeasibility = [select id, Add_To_BC__c from Feasibility__c where id in:linkRelatedFAN];
            for(Feasibility__c objFeasibility : linkFeasibility ){
                objFeasibility.Add_To_BC__c = true;
            }
            
            update linkFeasibility;
        }
    }
    
    
    /*
     * executeBeforeUpdate()
     * Purpose : Check the Restricted__c Checkbox if any field which is not present in the FieldSet 'EditSet' is changed.
     */
    public static void executeBeforeUpdate(List<feasibility__c> newList, Map<ID, Feasibility__c> oldMap)
    {
         System.Debug('FeasibilityTriggerHandler------ executeBeforeUpdate()');
        //Check the Restricted__c Checkbox if any field which is not present in the FieldSet 'EditSet' is changed.
        Set<String> fieldsToEdit = new Set<String>();
        Set<String> RestrictedFields = new Set<String>();
        //Get all fields in the FieldSet Edit Set
        for (Schema.FieldSetMember f : SObjectType.Feasibility__c.FieldSets.EditSet.getFields()) 
                fieldsToEdit.add(f.getFieldPath().toLowerCase());
            //System.debug('EditSet: '+fieldsToEdit);   
        
        //Get all Fields for Feasibility__c
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get('feasibility__c').getDescribe().Fields.getMap();
        //All fields - fields in edit Set = Restricted Fields 
        for(Schema.SObjectField f : fMap.values() )
        { Schema.DescribeFieldResult fd = f.getDescribe();
             if (fd.isCreateable() && !fd.isUnique() && !fieldsToEdit.contains(fd.getNAme().toLowerCase()) )
                RestrictedFields.add( fd.getNAme().toLowerCase() );
        }
           //System.debug(RestrictedFields);
          
        //If data in any of the restricted fields is changed then check the Restricted__c checkbox
        if(RestrictedFields.size()>0)
        for(Feasibility__c FAN : newList)
        {
            for(String fieldName : RestrictedFields)
              if( FAN.get( fieldName ) != oldMap.get(FAN.Id).get( fieldName ) )
                FAN.Restricted__c = true;
        }
    }
    
    
    
   /*
     * RunValidations()
     * Purpose : Checks that all Feasibilities under an SOID have the same 
     *           =>Product Variant
     *               Else throws an error from the Custom Label Feasibility_Product_Variant_Check
     *           =>Flavor
     *               Else throws an error from the Custom Label Feasibility_Flavor_Check
     *           =>Class of Service Variant
     *               Else throws an error from the Custom Label Feasibility_COS_Variant_Check
     *           =>Nimble Type
     *               Else throws an error from the Custom Label Feasibility_Nimble_Type_Check 
     */
    public static void RunValidations(List<feasibility__c> newList)
    {
       System.Debug('FeasibilityTriggerHandler------ ProductVariantCheck()') ;
        //Apply Check only for users where By_Pass_validations__C is unchecked.
       if( [select id, By_Pass_Validations__c from User where id = :UserInfo.getUserId()].By_Pass_Validations__c != true )
       {
       Set<ID> Set_Of_Opportunity_IDs = new Set<ID>();
       for(Feasibility__c newObj : newList)
          Set_Of_Opportunity_IDs.add(newObj.Opportunity__c);
        Map<ID, Opportunity> OpportunityMap = new MAp<ID, Opportunity>([Select ID, (Select Id, Flavor__c, Product_Variant__C, Nimble_Type__c, Class_Of_Service_Variant__c 
                                                                                    from Feasibilities__r 
                                                                                    where (Product_Variant__C!=null or Flavor__c!=null or Nimble_Type__c!=null or Class_Of_Service_Variant__c !=null)) 
                                                                        from Opportunity 
                                                                        where Id IN :Set_Of_Opportunity_IDs order by LastModifiedDate]);
         for(Feasibility__c newObj : newList)
         {
             String Variant = newObj.Product_Variant__c;
             String Flavor = newObj.Flavor__c;
             String CosVariant = newObj.Class_Of_Service_Variant__c;
             String NimbleType = newObj.Nimble_Type__c;
             String Error = null;
             Boolean flag = false;
             List<Feasibility__c> Feasibility_List = new List<Feasibility__c>(OpportunityMap.get(newObj.Opportunity__c).Feasibilities__r);
             if( Feasibility_List.size() > 0  )
             {
                 
                 for(Feasibility__c f : Feasibility_List)
                 {  
                  if(f.id != newObj.id) 
                  {
                    if( String.IsNotBlank(f.Product_Variant__c) && String.IsNotBlank(Variant) && (f.Product_Variant__c != Variant))
                       { flag = true;
                         Error = System.Label.Feasibility_Product_Variant_Check + '\n';
                       }
                    if( String.IsNotBlank(f.Flavor__c) && String.IsNotBlank(Flavor) && (f.Flavor__c != Flavor))
                      { flag = true;
                        Error = ( String.isBlank(Error) ? System.Label.Feasibility_Flavor_Check : (Error + System.Label.Feasibility_Flavor_Check)) + '\n';
                      }
                    if( String.IsNotBlank(f.Class_Of_Service_Variant__c) && String.IsNotBlank(CosVariant) && (f.Class_Of_Service_Variant__c != CosVariant))
                      { flag = true;
                        Error = (String.isBlank(Error) ? System.Label.Feasibility_COS_Variant_Check : (Error + System.Label.Feasibility_COS_Variant_Check)) + '\n';
                      }
                    if( String.IsNotBlank(f.Nimble_Type__c) && String.IsNotBlank(NimbleType) && (f.Nimble_Type__c != NimbleType))
                      { flag = true;
                        Error = (String.isBlank(Error) ? System.Label.Feasibility_Nimble_Type_Check : (Error + System.Label.Feasibility_Nimble_Type_Check)) + '\n';
                      }
                    if(flag == true)
                         break;
                    }
                  }
                    if(flag == true)
                    newObj.addError(Error);
              }
                
          }
        }
       
    }
    
    /* deleteChildFeasibility()
     * Purpose: Delete all child FANs when 
     *            (Resubmit to AMT is changed to true 
     *            and Number of Links > 1
     *            and Feasibility_AMT_Status_2__c = 'CLOSED' or 'FAN Closed'
     *            and Parent_Feasibility__c = null)
     */
    public static void deleteChildFeasibility(List<Feasibility__c> newlist, Map<Id, Feasibility__c> mapOld)
    { System.Debug('FeasibilityTriggerHandler------ deleteChildFeasibility()') ;
     
        List<Feasibility__c> DeleteChildFeasibilityList = new List<Feasibility__c>();
        for(Feasibility__c f : [Select Id, Number_of_Links_required__c, Parent_Feasibility__c, Resubmit_to_AMT__c, Feasibility_AMT_Status_2__c, (Select Id from Feasibilities2__r) From Feasibility__c where Id IN :newList])
        {
            if( (f.Resubmit_to_AMT__c==true) && (f.Resubmit_to_AMT__c != mapOld.get(f.Id).Resubmit_to_AMT__c) 
               && f.Number_of_Links_required__c != null && f.Number_of_Links_required__c>1
               && String.isBlank(f.Parent_Feasibility__c)
               && String.IsNotBlank(f.Feasibility_AMT_Status_2__c)
               && (f.Feasibility_AMT_Status_2__c.equalsIgnoreCase('CLOSED') || f.Feasibility_AMT_Status_2__c.equalsIgnoreCase('Fan CLOSED')) )
            {
                for(Feasibility__c child : f.Feasibilities2__r)
                  DeleteChildFeasibilityList.add(child);
            }
        }
        delete DeleteChildFeasibilityList;
    }
    
    
    /* Added By Vaibhaw */
    /* Description : Method used to create child feasibility object */
    public static void createChildFeasibility(List<Feasibility__c> newlist, Map<Id, Feasibility__c> mapOld, Boolean IsInsert, Boolean IsUpdate, Boolean IsBefore, Boolean IsAfter) {
        if(!(IsAfter && IsUpdate)) return; //Dont' Process Before Trigger & Insert Trigger
        
        List<Feasibility__c> ToBeClonedList = new List<Feasibility__c>();
        List<Drop__c> ToBeClonedDropList = new List<Drop__c>();
        List<Id> ToBeClonedListId = new List<Id>();
        Map<Id,List<Drop__c>> DropForFeasibilityMap = new Map<Id,List<Drop__c>>(); //Feasibility__c.id --> Drop__c List
        List<Feasibility__c> clonedList = new List<Feasibility__c>();
        List<Drop__c> clonedDropList = new List<Drop__c>();
        for(Feasibility__c fs : newlist) {
            if(entryCriteria(fs,mapOld)) {
                ToBeClonedListId.add(fs.Id);
            }
        }
        if(ToBeClonedListId.size()==0) return; //No Feasibility to Clone. Return Now.
        String query = OpportunityCloner.getCreatableFieldsSOQL('Feasibility__c','Id IN :ToBeClonedListId',false);
        ToBeClonedList = Database.query(query);
        
        for(Feasibility__c fs : ToBeClonedList) {
                    clonedList.addAll(cloneFeasibility(fs));
            
        }
        
        insert clonedList;
        
        //Clone Drops
        query = OpportunityCloner.getCreatableFieldsSOQL('Drop__c','Feasibility__c IN :ToBeClonedListId',false);
        ToBeClonedDropList = Database.query(query);
        
        if(ToBeClonedDropList.size()>0) {
            for(Drop__c drop : ToBeClonedDropList) {
                List<Drop__c> tempDropList;
                if(DropForFeasibilityMap.containsKey(drop.Feasibility__c)) {
                    tempDropList = DropForFeasibilityMap.get(drop.Feasibility__c);
                } else {
                    tempDropList = new List<Drop__c>();
                }
                tempDropList.add(drop);
                DropForFeasibilityMap.put(drop.Feasibility__c, tempDropList);
            }
            for(Feasibility__c fs : clonedList) {
                if(DropForFeasibilityMap.containsKey(fs.Parent_Feasibility__c))
                {
                    clonedDropList.addAll(cloneDropForFeasibility(DropForFeasibilityMap.get(fs.Parent_Feasibility__c),fs.id)); //cloneDropForFeasibility(From List of Drop, For Feasibility Id)
                }
            }
            if(clonedDropList.size() > 0)
                insert clonedDropList;
        }
        //Create Integration record for child FAN
        GenerateEmpowerREST.execute(clonedList);
    }
    public static Boolean entryCriteria(Feasibility__c fs,Map<Id,Feasibility__c> mapOld) {
        /* Entry Criteria to Check if Fesibility can be cloned or not.*/
        Boolean result = true;
        //Condition 1 : Status must be Accepted
        result = result && String.IsNotBlank(fs.Feasibility_AMT_Status_2__c) && (mapOld.get(fs.id).Feasibility_AMT_Status_2__c != fs.Feasibility_AMT_Status_2__c) && (fs.Feasibility_AMT_Status_2__c.equalsIgnoreCase('CLOSED') || fs.Feasibility_AMT_Status_2__c.equalsIgnoreCase('Fan CLOSED') );
        //Condition 2 : No. Of Link must be Greater than 1
        result = result && (fs.Number_of_Links_required__c != null && fs.Number_of_Links_required__c > 1);
        //Condition 3 : Parent Feasibility must be blank
        result = result && (fs.Parent_Feasibility__c == null);
        return result;
    }
    public static List<Feasibility__c> cloneFeasibility(Feasibility__c fs) {
        List<Feasibility__c> clonedList = new List<Feasibility__c>();
        Feasibility__c temp;
        Integer Number_Of_clone = (Integer)fs.Number_of_Links_required__c - 1;
        while(Number_of_clone>0) {
            temp = fs.clone(false,true,false,false);
            temp.id = null;
            temp.FAN_Number__c = null;
            temp.Parent_Feasibility__c = fs.id;
            temp.Number_of_Links_required__c = 1;
            temp.Fan_Status__c = 'CLOSED' ;
            clonedList.add(temp);
            Number_of_clone--;
        }
        return clonedList;
    }
    public static List<Drop__c> cloneDropForFeasibility(List<Drop__c> src,Id dest) {
        List<Drop__c> dropList = new List<Drop__c>();
        for(Drop__c drop : src) {
            Drop__c clonedDrop = drop.clone(false,true,false,false);
            clonedDrop.Feasibility__c = dest;
            dropList.add(clonedDrop);
        }
        return dropList;
    }

    /*Add Drops*/
    public static void addDrops(List<Feasibility__c> newlist, Map<Id, Feasibility__c> mapOld, Boolean IsInsert, Boolean IsUpdate, Boolean IsBefore, Boolean IsAfter){
        if(IsAfter) {
            List<Feasibility__c> fsList = new List<Feasibility__c>();
            List<Drop__c> dropList = new List<Drop__c>();
            //Add Feasibility__c to fsList
             List<Drop__c> l2mcdropList = new List<Drop__c>();
            //List of L2mc drops.
            //L2mc drop recordType Id
            RecordType r = [Select Id, DeveloperName , SobjectType, IsActive 
                                           from RecordType 
                                           where SobjectType ='Drop__c' and DeveloperName = 'L2MC_Drop'];
            for(Feasibility__c fs : newList) 
            {
                if( fs.Parent_Feasibility__c==null && fs.Number_of_Drops__c != null)
                {  if( (IsInsert) || (IsUpdate && mapOld.get(fs.id).Number_of_Drops__c == null)
                     )
                     {
                        fsList.add(fs);
                     }
                    Integer x = Integer.ValueOf(fs.Number_of_Drops__c);
                    if(fs.L2MC_Type__c == 'Standard' || fs.L2MC_Type__c == 'Premium')
                     {//Add Drop for Point B in case L2MC Type is Standard
                        Drop__c PointBDrop = new Drop__c();
                        PointBDrop.Feasibility__c = fs.id;
                        PointBDrop.Name = String.ValueOf(++x);
                        PointBDrop.Circle__c = (String.IsNotBlank(fs.Circle_B__c) ? fs.Circle_B__c : fs.Billing_Circle__c );
                        PointBDrop.Address_Line1__c = fs.Address_1_B__c ;
                        PointBDrop.Address_Line2__c = fs.Address_2_B__c ;
                        PointBDrop.Address_Line3__c = fs.Address_3_B__c ;
                        PointBDrop.City__c = fs.City_B__c ;
                        PointBDrop.Pincode_New__c = fs.Pincode_B_new__c ;
                        PointBDrop.Auto_Created__c = true;
                        PointBDrop.External_id__c = fs.Name+'~'+'PointB';
                        PointBDrop.RecordTypeId = r.Id ;
                        l2mcdropList.add(PointBDrop);
                     }
                    if(fs.L2MC_Type__c == 'Premium')
                    {
                        //Add Drop for Point A in case L2MC Type is Premium
                        Drop__c PointADrop = new Drop__c();
                        PointADrop.Feasibility__c = fs.id;
                        PointADrop.Name = String.ValueOf(++x);
                        PointADrop.Circle__c = (String.IsNotBlank(fs.Circle__c) ? fs.Circle__c : fs.Billing_Circle__c );
                        PointADrop.Address_Line1__c = fs.Address_1__c;
                        PointADrop.Address_Line2__c = fs.Address_2__c;
                        PointADrop.Address_Line3__c = fs.Address_3__c;
                        PointADrop.City__c = fs.City__c;
                        PointADrop.Pincode_New__c = fs.Pincode_New__c;
                        PointADrop.Auto_Created__c = true;
                        PointADrop.External_id__c = fs.Name+'~'+'PointA';
                        PointADrop.RecordTypeId = r.Id ;
                        l2mcdropList.add(PointADrop);
                    }
                 }
             }
            
            upsert l2mcdropList External_id__c;
            
            //If Number of Feasibility is greater than 0, prepare List of Drop__c
            if(fsList.size()>0) 
            {
                for(Feasibility__c fs : [Select Id, Number_of_Drops__c, Billing_Circle__c, Product__r.Fan_Category__c
                                         From Feasibility__c
                                         where Id IN :fsList]) 
                {
                    for(Integer i=0;i<Integer.valueOf(fs.Number_of_Drops__c);i++) {
                        Drop__c temp = new Drop__c();
                        temp.Feasibility__c = fs.id;
                        temp.Name = String.ValueOf(i+1);
                        //Populate Circle only for DLC
                        if(fs.Product__r != Null && fs.Product__r.Fan_Category__C.equalsIgnoreCase('DLC'))
                           temp.Circle__c = fs.Billing_Circle__c ;
                        dropList.add(temp);
                    }
                }
                
                if(dropList.size()>0) {
                    insert dropList;
                }
            }
        }        
    }
    
    /*
     *  executeBeforeInsert() Purpose : Make all System Fields Blank
     *  Add_to_BC__c
     *  FAN_Status__c
     *  Feasibility_Status__c
     *  Approval_Status__c
     *  Approval_Submitted_Date__c
     *  Last_Approval_Date__c
     *  FAN_Number__c
     *  Feasibility_AMT_Status_2__c
     *  Resubmit_to_AMT__c
     *  Return_to_AMT_Reason__c
     *                    
     */
    public static void executeBeforeInsert(List<Feasibility__c> newlist)
    {
        System.Debug('FeasibilityTriggerHandler------ executeBeforeInsert()');
        for(Feasibility__c newObj : newlist)
        {
            if(newObj.isClone())
            {
                System.Debug('Clone Found!!');
                newObj.Add_to_BC__c = false;
                newObj.FAN_Status__c = null;
                newObj.Feasibility_Status__c = null;
                newObj.Approval_Status__c = 'Not Submitted';
                newObj.Approval_Submitted_Date__c = null;
                newObj.Last_Approval_Date__c = null;
                newObj.FAN_Number__c = null;
                newObj.Feasibility_AMT_Status_2__c = null;
                newObj.Resubmit_to_AMT__c = false;
                newObj.Return_to_AMT_Reason__c = null;
            }
        }
    }
}