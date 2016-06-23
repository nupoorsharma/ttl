/*
    * Name: RaiseFeasibilityController Class
    * Created On: March 19, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Extension for Visualforce Page RaiseFeasibility
    *              Called From: Links on OLI, Salesforce1 Action from Mobile Devices.
    *              Purpose : Insertion of a Feasibility__c record with the scenario specific record type
    *                        and other details.
    *                        Redirection to the edit page of the newly created Feasibility__c record.
    *                        If no recordtype is found, an exception is thrown. The error message is picked from
    *                        the custom label FAN_Scenario_specific_RecordType_is_unavailable.                          
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 19-03-16 |Initial version of Class  |
    * |------------------------------------------------------------|
*/
public without sharing class RaiseFeasibilityController {
//The Feasibility__c record which needs to be inserted.
public Feasibility__c myFeasibility{get;set;}
//The Business Case__C record which needs to be upserted.
public Business_Case__c myBusinessCase{get;set;}
//The AV_CV__c record which needs to be inserted.
public AV_CV__c myAVCV{get;set;}

    //The OpportunityLineItem from which this page is called.
    OpportunityLineItem oli;
    //The Type parameter on page
    @TestVisible
    String type{get;set;}
    //Used to throw an exception when scenario specific recordtype for Feasibility is not found.
    public class CustomException extends Exception{}
    //The ID of newly ceated Feasibility/Business Case
    public String RecordID{get;set;}
    public String errorMsg{get;set;}
    
public RaiseFeasibilityController(ApexPages.StandardController controller)
    {
    System.Debug('RaiseFeasibilityController :: ' + ApexPages.CurrentPage().getURL());
    //Query the OLI to get all the extended details.
    
    //Initialize the Map for accessing Feasibibility record type ID.
    RaiseFeasibilityController.initializeRecordTypeMap();
    System.Debug('Current URL : '+ ApexPages.CurrentPage().getURL()  ); 
    String query = 'Select Id, OpportunityId, Opportunity.SOID__c, Opportunity.ISP_Non_ISP__c, Product2Id, Product2.Name, Opportunity.Type, Opportunity.Green_Channel_Opportunity__c from OpportunityLineItem where id = \'' + ApexPages.CurrentPage().getparameters().get('Id') + '\'' ;
    oli= Database.query(query);
    RecordID = '';
    errorMsg = '';
    type = '';   
    // If Type parameter on the page = "FAN" , Create a Feasibility Record    
    //Initialize the Feasibility__c record with the available details.
    if( ApexPages.CurrentPage().getURL().containsIgnoreCase('RaiseFANtype') ) 
    {
        System.Debug('Feasibility Logic');
        type = 'FAN' ;
        myFeasibility=new Feasibility__c();
        myFeasibility.RecordTypeId = RaiseFeasibilityController.getRecordType( oli.Product2.Name, oli.Opportunity.Type, oli.Opportunity.Green_Channel_Opportunity__c, 'Feasibility') ;
        myFeasibility.Opportunity__c = oli.OpportunityId;
        myFeasibility.OLI_ID__c = oli.id;
        myFeasibility.Product__c = oli.Product2Id;
        myFeasibility.Customer_Type__c = oli.Opportunity.ISP_Non_ISP__c ;
    }
    else if( ApexPages.CurrentPage().getURL().containsIgnoreCase('RaiseBCtype'))
    {
        System.Debug('Business Code Logic');
        type = 'BC' ;
        myBusinessCase = new Business_Case__c();
        myBusinessCase.Key__c = oli.Opportunity.SOID__c ;
        myBusinessCase.Opportunity__c = oli.OpportunityId ;
        myBusinessCase.Product__c = oli.Product2Id ;
        myBusinessCase.RecordtypeId = RaiseFeasibilityController.getRecordType( oli.Product2.Name, oli.Opportunity.Type, oli.Opportunity.Green_Channel_Opportunity__c, 'Business Case') ;
        //System.Debug('#BC RC ID : '+myBusinessCase.RecordtypeId);
		
    }
    else if( ApexPages.CurrentPage().getURL().containsIgnoreCase('RaiseAVCVtype'))
    {
        System.Debug('AVCV Logic');
        type = 'AVCV' ;
        RecordType rt = [SELECT Id, RecordType.DeveloperName FROM RecordType WHERE RecordType.DeveloperName Like 'Voice' and SObjectType = 'AV_CV__c' LIMIT 1];
        myAVCV = new AV_CV__c();
        myAVCV.Opportunity__c = oli.OpportunityId ;
        myAVCV.Product__c = oli.Product2Id ;
        myAVCV.RecordtypeId = rt.ID ;
		
    }
    }
    
    //This method inserts the Feasibility__c record and redirects to its edit page if there are no errors.
    public void Redirect()
    { System.debug('Inside Raise FeasibilityController ----------- Redirect()');
        try
        { //System.Debug('RecordtypeId : '+ myFeasibility.Recordtypeid);
            //Throw an exception if RecordTypeId is not set.
            //For Feasibility [type="FAN"]
           if( type == 'FAN')
           {System.debug('Into FAN');

            if(String.isBlank(myFeasibility.Recordtypeid))
            {
            System.Debug('Feasibility RecordtypeId NOT FOUND for the Opportunity ::'+ myFeasibility.Opportunity__c);
            //CustomException exptn = new CustomException();
            //exptn.setMessage(System.Label.FAN_Scenario_specific_RecordType_is_unavailable);
            //throw exptn;
            errorMsg = System.Label.FAN_Scenario_specific_RecordType_is_unavailable;
            }
            else
            {
              insert myFeasibility;
              RecordID = myFeasibility.Id;
              System.Debug('ID of Newly created Feasibility ======> '+myFeasibility.Id); 
            }
           }
            System.Debug('Post Feasibility check');
          //For Business Case [type="BC"]
          if( type == 'BC')
          {System.debug('Into BC   '); 
           //System.Debug('#BC RC ID : '+myBusinessCase.RecordtypeId);
              if( String.isBlank(myBusinessCase.Recordtypeid))
               {System.debug('Pre BC Logic');
                System.Debug('Business Case RecordtypeId NOT FOUND for the Opportunity ::'+ myBusinessCase.Opportunity__c);
                //CustomException exptn = new CustomException();
                //exptn.setMessage(System.Label.BC_Scenario_specific_RecordType_is_unavailable);
                //throw exptn; 
                errorMsg = System.Label.BC_Scenario_specific_RecordType_is_unavailable;
               }
          	else
              {upsert myBusinessCase Business_Case__c.Fields.Key__c;
               RecordID = myBusinessCase.Id;
               System.Debug('ID of Newly created Business Case ======> '+myBusinessCase.Id); 
              } 
           }
          //For AV_CV__c [type="AVCV"]
          if( type == 'AVCV')
          {System.debug('Into AVCV-->'); 
           //System.Debug('#AVCV RC ID : '+myAVCV.RecordtypeId);
              if( String.isBlank(myAVCV.Recordtypeid))
               {System.debug('Pre AVCV Logic');
                System.Debug('AVCV RecordtypeId NOT FOUND for the Opportunity ::'+ myAVCV.Opportunity__c);
                //CustomException exptn = new CustomException();
                //exptn.setMessage(System.Label.BC_Scenario_specific_RecordType_is_unavailable);
                //throw exptn; 
                errorMsg = 'AVCV Specific recordtype is unavailable';
               }
          	else
              {insert myAVCV;
               RecordID = myAVCV.Id;
               System.Debug('ID of Newly created AVCV ======> '+myAVCV.Id); 
              } 
           }
        }
         catch(Exception ex)
            {//System.Debug('An Exception has occurred. ' +ex);
             //ApexPages.addMessages(ex);
             errorMsg = ex.getMessage();
            }
        
        /* /If any Errors occur up, stay on the same page, otherwise redirect to Feasibility Edit page.
        if (ApexPages.hasMessages()) 
         return null;
        else
        { if(type == 'FAN')
            return new PageReference('/'+ myFeasibility.id +'/e?retURL=%2F'+myFeasibility.Id);  
         else
            return new PageReference('/'+ myBusinessCase.id +'/e?retURL=%2F'+myBusinessCase.Id);  
        }
		*/
    }
    
    public static Map<String,ID> FANRecordTypeMap {get;set;}
    public static Map<String, ID> BCRecordTypeMap {get;set;}
    public static Map<String, ID> FANBCRecordTypeMap {get;set;}
    public static Map<String, ID> AVCVRecordTypeMap {get;set;}
    
    /*
     * getRecordType() 
     * ProductName - Name of the product on OpportunityLineItem.
     * OpportunityType - Type on Opportunity.
     * IsGC - Green_Channel_Opportunity__c on Opportunity.
     * Obj- Feasibility / Business Case
     * Purpose: Queries the Feasibility_RecordType_Mapping__mdt Object and returns a matched
     *          RecordTypeID for Feasibility/ Business Case based on the key(ProductName~OpportunityType).
     * Called From : RaiseFeasibilityController Constructor and FeasibilityStatusTriggerHandler.
     * Consideration : Call after RaiseFeasibilityController.initializeRecordTypeMap();
     */
    public static ID getRecordType(String ProductName, String OpportunityType, Boolean IsGc, String Obj)
    {
        System.Debug('Input Values for getRecordType() : \n ProductName: '+ProductName+'\n OpportunityType: '+OpportunityType+'\n IsGc: '+IsGc+'\n Obj: '+Obj);
        ID returnVal = null;
        try{
            //If no matching metarecord is found, null value is returned.
        Feasibility_RecordType_Mapping__mdt MetaRecord = [Select Id, Product_Name__c, Opportunity_Type__c, Feasibility_RecordType__c, BC_RecordType__c, FAN_BC_RecordType__c, AV_CV_Record_Type__c, Is_GC__c 
                                                          from Feasibility_RecordType_Mapping__mdt  
                                                          where MacD_Scenario__c = null and Product_Name__c = :ProductName and Opportunity_Type__c = :OpportunityType and Is_GC__c = :IsGc 
                                                          Limit 1];
        //System.debug('Feasibility_RecordType_Mapping__mdt: '+MetaRecord);
        //Return the feasibility recordtypeid if it is found in the metarecord and the FANRecordTypeMap map.
        if( Obj == 'Feasibility' && MetaRecord!=null && String.IsNotblank(MetaRecord.Feasibility_RecordType__c) 
            && FANRecordTypeMap.get(MetaRecord.Feasibility_RecordType__c.toLowerCase()) != null)
              returnVal = FANRecordTypeMap.get(MetaRecord.Feasibility_RecordType__c.toLowerCase());
        //Return the business case recordtypeid if it is found in the metarecord and the BCRecordTypeMap map.
        else if(Obj == 'Business Case' && MetaRecord!=null && String.IsNotblank(MetaRecord.BC_RecordType__c) 
                && BCRecordTypeMap.get(MetaRecord.BC_RecordType__c.toLowerCase()) != null)
                  returnVal = BCRecordTypeMap.get(MetaRecord.BC_RecordType__c.toLowerCase()) ;
        else if(Obj == 'FAN BC' && MetaRecord!=null && String.IsNotblank(MetaRecord.FAN_BC_RecordType__c) 
                && FANBCRecordTypeMap.get(MetaRecord.FAN_BC_RecordType__c.toLowerCase()) != null)
                  returnVal = FANBCRecordTypeMap.get(MetaRecord.FAN_BC_RecordType__c.toLowerCase()) ;
        else if(Obj == 'AVCV' && MetaRecord!=null && String.IsNotblank(MetaRecord.AV_CV_Record_Type__c) 
                && AVCVRecordTypeMap.get(MetaRecord.AV_CV_Record_Type__c.toLowerCase()) != null)
                  returnVal = AVCVRecordTypeMap.get(MetaRecord.AV_CV_Record_Type__c.toLowerCase()) ;
        }
        catch(Exception e)
        {
            System.Debug('### Execption from : RaiseFeasibilityController.getRecordType()');
            System.Debug(e);
        }
        System.debug('RecordType Sent From RaiseFeasibilityController.getRecordType()----> '+ returnVal);
        return returnVal;
    }
    
    /*
     * getRecordTypeMacD() 
     * ProductName - Name of the product on OpportunityLineItem.
     * MAcDType - MAcD_Type__c on Opportunity.
     * IsGC - Green_Channel_Opportunity__c on Opportunity.
     * Obj- Feasibility / Business Case / AVCV / FAN BC
     * Purpose: Queries the Feasibility_RecordType_Mapping__mdt Object and returns a matched
     *          RecordTypeID for Feasibility/ Business Case based on the key(ProductName~OpportunityMACDType~ISGC).
     * Called From : RaiseFeasibilityController Constructor and FeasibilityStatusTriggerHandler.
     * Consideration : Call after RaiseFeasibilityController.initializeRecordTypeMap();
     */
    public static ID getRecordTypeMacD(String ProductName, String MAcDType, Boolean IsGc, String Obj)
    {
        System.Debug('Input Values for getRecordTypeMacD() : \n ProductName: '+ProductName+'\n MAcDType: '+MAcDType+'\n IsGc: '+IsGc+'\n Obj: '+Obj);
        ID returnVal = null;
        try{
            //If no matching metarecord is found, null value is returned.
        Feasibility_RecordType_Mapping__mdt MetaRecord = [Select Id, Product_Name__c, Opportunity_Type__c, Feasibility_RecordType__c, BC_RecordType__c, FAN_BC_RecordType__c, AV_CV_Record_Type__c, Is_GC__c 
                                                          from Feasibility_RecordType_Mapping__mdt  
                                                          where MacD_Scenario__c LIKE :MAcDType and Product_Name__c = :ProductName and Is_GC__c = :IsGc 
                                                          Limit 1];
        //System.debug('Feasibility_RecordType_Mapping__mdt: '+MetaRecord);
        //Return the feasibility recordtypeid if it is found in the metarecord and the FANRecordTypeMap map.
        if( Obj == 'Feasibility' && MetaRecord!=null && String.IsNotblank(MetaRecord.Feasibility_RecordType__c) 
            && FANRecordTypeMap.get(MetaRecord.Feasibility_RecordType__c.toLowerCase()) != null)
              returnVal = FANRecordTypeMap.get(MetaRecord.Feasibility_RecordType__c.toLowerCase());
        //Return the business case recordtypeid if it is found in the metarecord and the BCRecordTypeMap map.
        else if(Obj == 'Business Case' && MetaRecord!=null && String.IsNotblank(MetaRecord.BC_RecordType__c) 
                && BCRecordTypeMap.get(MetaRecord.BC_RecordType__c.toLowerCase()) != null)
                  returnVal = BCRecordTypeMap.get(MetaRecord.BC_RecordType__c.toLowerCase()) ;
        else if(Obj == 'FAN BC' && MetaRecord!=null && String.IsNotblank(MetaRecord.FAN_BC_RecordType__c) 
                && FANBCRecordTypeMap.get(MetaRecord.FAN_BC_RecordType__c.toLowerCase()) != null)
                  returnVal = FANBCRecordTypeMap.get(MetaRecord.FAN_BC_RecordType__c.toLowerCase()) ;
        else if(Obj == 'AVCV' && MetaRecord!=null && String.IsNotblank(MetaRecord.AV_CV_Record_Type__c) 
                && AVCVRecordTypeMap.get(MetaRecord.AV_CV_Record_Type__c.toLowerCase()) != null)
                  returnVal = AVCVRecordTypeMap.get(MetaRecord.AV_CV_Record_Type__c.toLowerCase()) ;
        }
        catch(Exception e)
        {
            System.Debug('### Execption from : RaiseFeasibilityController.getRecordTypeMacD()');
            System.Debug(e);
        }
        System.debug('RecordType Sent From RaiseFeasibilityController.getRecordTypeMacD()----> '+ returnVal);
        return returnVal;
    }
    
    /*
     * initializeRecordTypeMap()
     * Purpose: Generates the FANRecordTypeMap :: Feasibility Record Type Developer Name as key and RecordTypeId as value.
     *          Generates the BCRecordTypeMap :: Business Case Record Type Developer Name as key and RecordTypeId as value.
     * Called From : RaiseFeasibilityController Constructor and FeasibilityStatusTriggerHandler.
     */
    public static void initializeRecordTypeMap()
    {
        FANRecordTypeMap = new Map<String,ID>();
        BCRecordTypeMap = new Map<String,ID>();
        FANBCRecordTypeMap = new Map<String,ID>();
        AVCVRecordTypeMap = new Map<String,ID>();
        //Populate the Maps with Developer Name of recordtype as key and recordtypeid as value.
        List<RecordType> AllRecordtypes = [Select Id, DeveloperName , SobjectType, IsActive 
                                           from RecordType 
                                           where SobjectType IN ('Feasibility__c', 'Business_case__c', 'Fan_BC__c', 'AV_CV__c')] ;
        //System.Debug(AllRecordtypes);
        for(RecordType r : AllRecordtypes)
        {
            if(r.SobjectType == 'Feasibility__c')
                FANRecordTypeMap.put(r.DeveloperName.toLowerCase() , r.Id);
            else if(r.SobjectType == 'Business_case__C')
                BCRecordTypeMap.put(r.DeveloperName.toLowerCase() , r.Id);
            else if(r.SobjectType == 'Fan_BC__c')
                FANBCRecordTypeMap.put(r.DeveloperName.toLowerCase() , r.Id);
            else if(r.SObjectType == 'AV_CV__c')
                AVCVRecordTypeMap.put(r.DeveloperName.toLowerCase() , r.Id);
        }
        //system.debug(FANRecordTypeMap);
        //System.Debug(BCRecordTypeMap);
    }

        
}