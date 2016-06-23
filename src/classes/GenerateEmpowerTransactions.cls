/*
 * Name        : GenerateEmpowerTransactions
 * Description : Generic class used for generating the Empower Transactions records using the
                 Empower Transaction Config object.
 * Author      : Himanshu Maheshwari (Compro Technologies)
 * Created On  : 24 Nov 2015
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Himanshu        | 24/11/2015 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 *  | 0.2     | Nupoor          | 03/03/2016 | Interface Development          |
 *  |-------------------------------------------------------------------------|
 */
public without sharing class GenerateEmpowerTransactions{
    public static Map<String, Empower_Transaction_Config__c> empTransCngfMap = new Map<String, Empower_Transaction_Config__c>();    //Map of Method Name with corresponding Emp Tx Config record.
    public static Set<String> criteriaFldSet = new Set<String>();
    public static Boolean flag = FALSE;
    public static Map <String, List <String>> methodFieldsNameMap;
    public static List <EMPOWER_TRANSACTION__c> empTranList;
    public static Map<Id, User> OldCompanyOwner;
    public static Map<Id, Account> OldCompanyAccount;
    public static Map<Id, User> LeadOwner;
    public static Map<Id, OpportunityContactRole> ContactMap;
   
    //Method to get Map of Method Name with corresponding List of API names of the field of Sobject.
    public static Map <String, List <String>> loadConfig(String sObjct){
        Map <String, List <String>> fieldsNameMap = new Map <String, list <String>>();
        List <String> fieldsNameList;
        criteriaFldSet.removeAll(criteriaFldSet);
        //Query Empower Transaction Config.
        for(Empower_Transaction_Config__c eTxCnfg : [SELECT Id, Empower_Parameters_Config__c, Empower_Method_Name__c, Criteria_Fields__c, Fixed_Values__c, Status__c FROM Empower_Transaction_Config__c 
                                                              WHERE Related_Object__c =: sObjct]){
            fieldsNameList = new List <String>();    
            if(eTxCnfg.Empower_Parameters_Config__c != NULL){
                for(String fld : eTxCnfg.Empower_Parameters_Config__c.split(':')){
                    if(fld.substringBefore('^^') != ' ' && fld.substringBefore('^^').contains('old~') == false)
                    fieldsNameList.add(fld.substringBefore('^^'));
                    //Marking flag as TRUE if parent fields are in config.
                    if(fld.substringBefore('^^').contains('.'))
                        flag = TRUE;
                }
                fieldsNameList.remove(0);
                fieldsNameMap.put(eTxCnfg.Empower_Method_Name__c, fieldsNameList);
            }

            //Generating Set of criteria fields.
            if(eTxCnfg.Criteria_Fields__c != NULL){
                for(String str : eTxCnfg.Criteria_Fields__c.split(',')){
                    //System.debug('Criteria Field : :   '+ str);
                    criteriaFldSet.add(str);   
                    //Marking flag as TRUE if any criteria feild is present. 
                    flag = TRUE;
                }
            }

            empTransCngfMap.put(eTxCnfg.Empower_Method_Name__c, eTxCnfg);
        }

        System.debug('Criteria field Set ::::::::' + criteriaFldSet);
        System.debug('Map is ::::::::' + fieldsNameMap);
        return fieldsNameMap;
    }

    //Generate the Empower Transaction records.
    public static EMPOWER_TRANSACTION__c generateTxRecords(sObject sObj, String methodName, String sObjctName){
       
        String empVal = empTransCngfMap.get(methodName).Fixed_Values__c;
        MAp<String,String> FixedValuesMap = new MAp<String,String>();
        if(!String.IsEmpty(empVal))
        {  System.Debug(empVal);
            String[] fixedvalues = empVal.split('\\^\\^');
            for(String fv : fixedvalues)
                FixedValuesMap.put( fv.substringBefore(':') + ': ', fv );
        }
        System.Debug(FixedValuesMap);
        //Creating Empower Transaction records.
        EMPOWER_TRANSACTION__c empTran = new EMPOWER_TRANSACTION__c();
        empTran.Empower_Method_Name__c = methodName;
        empTran.Related_Object_Id__c = (Id)sObj.get('Id');
        empTran.Related_Object__c = sObjctName;
        //Record will be inserted only if Status__c on config record is True
        empTran.Insert_Transaction__c = empTransCngfMap.get(methodName).Status__c ;
        
        String empParam = empTransCngfMap.get(methodName).Empower_Parameters_Config__c;
        for(String str : methodFieldsNameMap.get(methodName))
               {   //System.debug('generateTxn :: '+str);
                   if(str.contains('.'))
                   {Integer found=0;
                    String[] spillName = str.split('\\.');
                    if(str.countMatches('.')==3 && 
                       sObj.getSObject(spillName[0])!= null && 
                       sObj.getSObject(spillName[0]).getSobject(spillName[1])!=null && 
                       sObj.getSObject(spillName[0]).getSobject(spillName[1]).getSobject(spillName[2])!=null )
                    {empParam = empParam.replace(':'+str+'^^', ':'+String.valueOf(sObj.getSObject(spillName[0]).getSobject(spillName[1]).getSobject(spillName[2]).get(spillName[3]))+'^^');
                     found=1;
                    }
                    else if(str.countMatches('.')==2 && 
                            sObj.getSObject(spillName[0])!= null && 
                            sObj.getSObject(spillName[0]).getSobject(spillName[1])!=null)
                    {empParam = empParam.replace(':'+str+'^^', ':'+String.valueOf(sObj.getSObject(spillName[0]).getSobject(spillName[1]).get(spillName[2]))+'^^');
                     found=1;
                    }
                     else if(str.countMatches('.')==1 && 
                            sObj.getSObject(spillName[0])!=null)
                     {empParam = empParam.replace(':'+str+'^^', ':'+String.valueOf(sObj.getSObject(spillName[0]).get(spillName[1]))+'^^');
                       found=1;
                     }
                    else if(found==0)
                    {//System.Debug('Setting null for :: '+str);
                        empParam = empParam.replace(':'+str+'^^', ':null^^');
                    }
                   }
                else
                 empParam = empParam.replace(':'+str+'^^', ':'+String.valueOf(sObj.get(str))+'^^');
               }
        
               for(String key : FixedValuesMap.keySet())
                   if( empParam.contains(key) )
                      empParam = empParam.replace('^^'+key, '^^'+FixedValuesMap.get(Key));
             empParam = empParam.replace(':true^^', ':YES^^');
             empParam = empParam.replace(':false^^', ':NO^^');
               empTran.Empower_Parameters__c = empParam.removeEnd('^^');
               System.debug('params ::::::::' + empParam);
        
    /* 
        //Map to get sObject field data type.
        Map<String, Schema.sObjectField> ftype = Schema.getGlobalDescribe().get(sObjctName).getDescribe().fields.getMap();
        for(String str : methodFieldsNameMap.get(methodName)){
            //Geting field data type.
           // String fieldType ;
           
            if(ftype.get(str) != Null)
            fieldType = String.valueOf(ftype.get(str).getDescribe().getType());
            if(fieldType == 'DATE'){
                Datetime dte = Datetime.newInstance(Date.valueOf(sObj.get(str)).year(), Date.valueOf(sObj.get(str)).month(), Date.valueOf(sObj.get(str)).day());
                empParam = empParam.replace(':'+str, ':'+ dte.format('yyyy-MM-dd'));
            } else{
                empParam = empParam.replace(':'+str, ':'+String.valueOf(sObj.get(str)));
            }
           
        }
        System.debug('params ::::::::' + empParam);
        empTran.Empower_Parameters__c = empParam;
        */
        return empTran;
    }

    //Main method
    public static void execute(List<sObject> newsObjList, Map<Id, sObject> oldsObjMap, String sObjName){
        empTranList = new List <EMPOWER_TRANSACTION__c>();
        Map<String, List<Id>> methodNameMap = new Map<String, List<Id>>();
        List <sObject> sObjList = new List <sObject>();
        
        //Calling loadConfig to get Config records.
        methodFieldsNameMap = loadConfig(sObjName);
        Set <String> fieldsNameSet = new Set <String>();
    System.Debug('Flag : '+ flag + 'NewSObj List '+ newsObjList);
        //If Flag is TRUE generate Query else use Trigger.New 
        if(flag){
            //Emmpower Parameters fields
            for(List<String> strList : methodFieldsNameMap.values()){
                for(String str : strList){
                    fieldsNameSet.add(str.trim().ToLowerCase());
                }
            }

            //Criteria fields
            for(String str : criteriaFldSet){
                fieldsNameSet.add(str.trim().ToLowerCase());                
            }
          fieldsNameSet.remove('id');
            //Generating the query.
            String query = 'SELECT Id';
            for(String fieldsName : fieldsNameSet){
                query = query + ', ' + fieldsName;
            }

            query = query + ' FROM ' + sObjName + ' WHERE Id IN: newsObjList'; 
            System.debug('Query ::::::::::::' + query);
            if(newsObjList!=null)
             sObjList = Database.query(query);
            
        }else{
            sObjList = newsObjList;
        }
        
        //Local lists to identify if additional queries are required.
        List<ID> OldOwner = new List<ID>() ;
        List<ID> OldAccount = new List<ID>() ;
        List<ID> LeadOwnerID = new List<ID>() ;
       
        //Query the Old Owner Idm_Id__c for COMPANYTRANSFER interface
         for(Sobject sObj : sObjList)
         {
             if(sObjName == 'Company__c' && oldsObjMap!=null)
             {  
                 if(oldsObjMap.get((Id)sObj.get('Id'))!=null)
                 {
                     Company__c com = (Company__c)sObj ;
                     Company__c oldCom = (Company__c)oldsObjMap.get((Id)sObj.get('Id')) ;
                     if(com.Account__C != oldCom.Account__c)
                           OldAccount.add(oldCom.Account__c) ;
                 }
                
             }
             else if(sObjName == 'ACCOUNT' && oldsObjMap!=null)
             {
                 
                 if(oldsObjMap.get((Id)sObj.get('Id'))!=null)
                 {
                     Account newAcc = (Account)sObj ;
                     Account acc = (Account)oldsObjMap.get((Id)sObj.get('Id') );
                     if( newAcc.OwnerId != acc.OwnerId )
                                        OldOwner.add(acc.OwnerId) ;
                                                           
                 }
             }
             else if(sObjName == 'LEAD')
             { LeadOwnerID.add((ID)sObj.get('ownerId'));
             }
         }
        if(OldOwner.size() > 0)                                           
              OldCompanyOwner = new Map<Id, User>([Select Id, IDM_Id__c from User where ID in :OldOwner]);
              System.Debug('OldAccountOwner ::' + OldCompanyOwner) ;
        if(OldAccount.size() > 0)
              OldCompanyAccount = new Map<Id, Account>([Select Id, Name, Logo_Id__c, Owner.IDM_Id__c from Account where Id in :OldAccount ]);
            System.Debug('OldCompanyAccount ::' + OldCompanyAccount) ;
        if( LeadOwnerID.size() > 0 )
              LeadOwner = new Map<Id, User>([Select Id, Phone, Circle__c from User where Id in :LeadOwnerID]);
            System.Debug('LeadOwner ::' + LeadOwner) ;
        
        //Initialize the Contact Map to Populate contact details on CREATESOID
        if(sObjName == 'OpportunityLineItem')
             {
                 ContactMap = new Map<Id, OpportunityContactRole>();
                 for(OpportunityContactRole optyContact : [Select Id, Contact.Name, Contact.FirstName, Contact.MobilePhone, Contact.LastName, Contact.email, Contact.Phone, OpportunityId, IsPrimary 
                                                           from OpportunityContactRole 
                                                           where OpportunityId in :oldsObjMap.keyset() order by IsPrimary ASC])
                 {
                     ContactMap.put( optyContact.OpportunityID , optyContact);
                 }
                 
             }

        //Loop for creating Empower Transactions.
        for(Sobject sObj : sObjList){
            sObject oldsObj = null;
            if(oldsObjMap!=null)
             oldsObj = oldsObjMap.get((Id)sObj.get('Id'));
            
            if(sObjName == 'Company__c'){    
                if(oldsObj == null && oldsObjMap == null)
                { NONVERIFIED((Company__c)sObj, (Company__c)oldsObj);
                  AccountVerificationStatus((Company__c)sObj, (Account)oldsObj);
                }
                LOGOCHANGE((Company__c)sObj, (Company__c)oldsObj);
                
                if( oldsObjMap!= null && oldsObjMap.get((Id)sObj.get('Account__c'))!=null) 
                {SObject AccObj = oldsObjMap.get((Id)sObj.get('Account__c')) ;
                 System.Debug('Old Account for Company: '+AccObj);
                  AccountVerificationStatus((Company__c)sObj, (Account)AccObj);
                  AccountDetailsUpdate((Company__c)sObj, (Account)AccObj);
                }
               
                //COMPANYSHAREREVOKE((Account)sObj, (Account)oldsObj);              
               
            }
            else if(sObjName == 'ACCOUNT'){
                COMPANYTRANSFER((ACCOUNT)sObj, (Account)oldsObj);
                //COMPANYCREATION((Account)sObj);
                //done
                
            }
            else if(sObjName == 'OpportunityLineItem'){
             if( oldsObjMap!= null && oldsObjMap.get((Id)sObj.get('OpportunityId'))!=null) 
                {SObject oldOpp = oldsObjMap.get((Id)sObj.get('OpportunityId')) ;
                 System.Debug('Old Opportunity for OpportunityLineItem: '+oldOpp);
                 //System.Debug('Olala : '+sObj.getSObject('Opportunity').get('Execute_Create_SOID__c'));
                 //System.Debug('Olala 2: '+oldOpp.get('Execute_Create_SOID__c'));
                  CREATESOID((OpportunityLineItem)sObj, (Opportunity)oldOpp);
                }
            }
            else if(sObjName == 'OPPORTUNITY'){     
               
               UPDATESOID((Opportunity)sObj, (Opportunity)oldsObj);
               BLOCKSOID((Opportunity)sObj, (Opportunity)oldsObj);
                //UNBLOCKSOID((Opportunity)sObj, (Opportunity)oldsObj);
                //SOIDTRANSFER((Opportunity)sObj, (Opportunity)oldsObj);
                //done
            } else if(sObjName == 'LEAD'){
                SENDSMS((Lead)sObj);
            } /*else if(sObjName == 'PRODUCT2'){
                //CREATENDATEPROD((Product)sObj, (Product)oldsObj);
            }     */  
        }
        //Applicable only for NVACCDELETION
        if( newsObjList==null && oldsObjMap!=null )
        { 
          List<Id> oldAccId = new List<ID>();
            for(ID key : oldsObjMap.keySet())
                {  Company__c x = (Company__c)oldsObjMap.get(key);
                    oldAccId.add( x.Account__c );
                }
            //Query Logo Status on Account for the company. 
      Map<ID, Account> OldAcc = new Map<ID, Account>([Select Id, Logo_Status__c from Account where id in :oldAccId]);
            for(ID key : oldsObjMap.keySet())
            { Company__c x = (Company__c)oldsObjMap.get(key);
             //Create Empower only if the Account Status is non-verified.   
             if( OldAcc.get( x.Account__c ) != null 
                   && OldAcc.get(x.Account__c ).Logo_Status__c == 'Non-Verified' )
               NVACCDELETION((Company__c)oldsObjMap.get(key));  
            }
        }
    
        System.debug('Empower Transaction List ::::::::::::::::' + empTranList);
        if(empTranList.size() > 0)
            insert empTranList;
    }

    /************** Start - Opportunity Method ***************/
    public static void CREATESOID(OpportunityLineItem opp, Opportunity oldOpp){
        System.Debug('oldOpp: SOID '+oldOpp.Execute_Create_SOID__c + 'new: SOID '+opp.Opportunity.Execute_Create_SOID__c) ;
        if(oldOpp!=null && oldOpp.Execute_Create_SOID__c == false &&
           opp.Opportunity.Execute_Create_SOID__c == true )
        {System.Debug( 'CREATESOID EMPOWER FOR :: '+ opp.OpportunityId );
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(opp, 'CREATESOID', 'OpportunityLineItem');
            if(empTx != NULL)
            {  if( ContactMap.get(oldOpp.Id) != null)
              {
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CONTACTNAME: ^^' , 'CONTACTNAME:'+ContactMap.get(oldOpp.Id).Contact.Name+'^^');
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CONTACTNUMBER: ^^' , 'CONTACTNUMBER:'+ContactMap.get(oldOpp.Id).Contact.MobilePhone+'^^');
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CUSTFIRSTNAME: ^^' , 'CUSTFIRSTNAME:'+ContactMap.get(oldOpp.Id).Contact.FirstName+'^^');
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CUSTLASTNAME: ^^' , 'CUSTLASTNAME:'+ContactMap.get(oldOpp.Id).Contact.LastName+'^^');
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CUSTEMAIL: ^^' , 'CUSTEMAIL:'+ContactMap.get(oldOpp.Id).Contact.Email+'^^');
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CUSTPHONE: ^^' , 'CUSTPHONE:'+ContactMap.get(oldOpp.Id).Contact.MobilePhone+'^^');
                }
             
               if(opp.Opportunity.Channel_Type__c == 'Channel')
                {
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('DEALER_CODE:'+opp.Opportunity.Owner.Sales_Code__c+'^^' , 'DEALER_CODE:'+opp.Opportunity.Account.Channel_Partner_Code__c+'^^');
                }
			 
         Datetime dte = Datetime.newInstance(Date.valueOf(opp.Opportunity.CloseDate).year(), Date.valueOf(opp.Opportunity.CloseDate).month(), Date.valueOf(opp.Opportunity.CloseDate).day());
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('CLOSE_DATE:'+String.ValueOf(opp.getSObject('Opportunity').get('CloseDate'))+'^^' , 'CLOSE_DATE:'+dte.format('yyyy-MM-dd')+'^^');
                empTx.Opportunity__c = opp.OpportunityId;
                if(empTx.Insert_Transaction__c == true)
                empTranList.add(empTx);
            }
        }
    }

    public static void UPDATESOID(Opportunity sObj , Opportunity oldOpp){
        if(oldOpp!=null && sObj.Execute_Create_SOID__c==true && oldOpp.Execute_Create_SOID__c ==true &&
           (sObj.OwnerId != oldOpp.OwnerId || sObj.StageName != oldOpp.StageName || sObj.CloseDate != oldOpp.CloseDate ||
            sObj.TotalOpportunityQuantity != oldOpp.TotalOpportunityQuantity || sObj.Probability != oldOpp.Probability || 
            sObj.No_of_Locations__c != oldOpp.No_of_Locations__c || sObj.Amount != oldOpp.Amount) )
        { System.Debug( 'UPDATESOID EMPOWER FOR :: '+ sObj.Id );
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'UPDATESOID', 'OPPORTUNITY');
       
            if(empTx != NULL)
             {    if( sObj.OwnerId != oldOpp.OwnerId )
                 empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace( '^^OWNERCHANGE_YN: ^^OWNER_ID: ^^', '^^OWNERCHANGE_YN:Y^^OWNER_ID:' + sObj.Owner.IDM_Id__c + '^^' ) ;
         
              Datetime dte = Datetime.newInstance(Date.valueOf(sObj.CloseDate).year(), Date.valueOf(sObj.CloseDate).month(), Date.valueOf(sObj.CloseDate).day());
              empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('EXPECTED_CLOSE_DATE:'+String.ValueOf(sObj.get('CloseDate'))+'^^' , 'EXPECTED_CLOSE_DATE:'+dte.format('yyyy-MM-dd')+'^^');
              empTx.Opportunity__c = sObj.Id ;
              if(empTx.Insert_Transaction__c == true)
              empTranList.add(empTx);
             }
        }
    }

    public static void BLOCKSOID(Opportunity sObj , Opportunity oldOpp){
        if(oldOpp!=null && sObj.Block_SOID__c != oldOpp.Block_SOID__c)
        { EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'BLOCKSOID / UNBLOCKSOID', 'OPPORTUNITY');
            if(empTx != NULL)
            { if(sObj.Block_SOID__c)
            {
                 empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^FLAG: ','^^FLAG:BLOCK');
                 empTx.Empower_Method_Name__c = 'BLOCKSOID' ;
            }
             else
             {
                 empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^FLAG: ','^^FLAG:UNBLOCK');
                 empTx.Empower_Method_Name__c = 'UNBLOCKSOID' ;
             }
             empTx.Opportunity__c = sObj.Id ;
             if(empTx.Insert_Transaction__c == true)
                empTranList.add(empTx);
            }
        }
    }
   
    /* NOT USED
    public static void UNBLOCKSOID(sObject sObj){
      //  if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'UNBLOCKSOID', 'OPPORTUNITY');
            if(empTx != NULL)
                empTranList.add(empTx);
    }
	*/
    
    /* NOT USED
    public static void SOIDTRANSFER(Opportunity sObj, Opportunity oldObj){
        //if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'SOIDTRANSFER', 'OPPORTUNITY');
        //We have a problem here.
          empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('old~Owner.IDM_Id__c^^', String.ValueOf(oldObj.Owner.IDM_Id__c)+'^^') ;
            if(empTx != NULL)
                empTranList.add(empTx);
    }  
	*/
    
    /************** End - Opportunity Method ***************/

    /************** Start - Account Method ***************/
    public static void NONVERIFIED(Company__c sObj, Company__c oldSobj){
       if(oldSobj==null 
          && (sObj.getSObject('Account__r') != null)
          && (sObj.getSObject('Account__r').get('Logo_Status__c') != null)
          && (sObj.getSObject('Account__r').get('Logo_Status__c') == 'Non-Verified') 
          && (sObj.getSObject('Account__r').get('NV_Created_in_Empower__c') == false)
          && (sObj.getSObject('Account__r').get('NV_Transaction_Created__c') == false)
          && (sObj.getSObject('Account__r').get('Sub_Segment__c') != null)
          )
       {
       System.Debug( 'NONVERIFIED EMPOWER FOR :: '+ sObj.getSObject('Account__r').get('Name') );
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'NONVERIFIED', 'Company__c');
            if(empTx != NULL)
            {  empTx.Account__c = sObj.Account__r.Id ;
              if(empTx.Insert_Transaction__c == true)
               empTranList.add(empTx);
            }
       }
    }
    
    public static void AccountVerificationStatus(Company__c sObj, Account oldObj){
       if( 
           (oldObj!=null && oldObj.Logo_Status__c != 'Verified' &&
             sObj.getSObject('Account__r').get('Logo_Status__c') == 'Verified') )
       {
       System.Debug( 'AccountVerificationStatus EMPOWER FOR :: '+ sObj.getSObject('Account__r').get('Name') );
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'LOGO_VERFIFCATION_STATUS', 'Company__c');
            if(empTx != NULL)
            { empTx.Account__c = sObj.Account__c ;
              Datetime dte = Datetime.newInstance(Date.valueOf(sObj.Account__r.CreatedDate).year(), Date.valueOf(sObj.Account__r.CreatedDate).month(), Date.valueOf(sObj.Account__r.CreatedDate).day());
              empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('Logo_creation_date: ^^' , 'Logo_creation_date:'+dte.format('yyyy-MM-dd')+'^^');
              if(empTx.Insert_Transaction__c == true)
              empTranList.add(empTx);
            }
       }
    }
    
    public static void AccountDetailsUpdate(Company__c sObj, Account oldObj){
        
       if(oldObj!=null && oldObj.Logo_Status__c == 'Verified' && 
          sObj.getSObject('Account__r').get('Logo_Status__c') == 'Verified' &&
            (sObj.Account__r.Name != oldObj.Name || sObj.Account__r.Id != oldObj.Id || sObj.Account__r.Logo_Id__c != oldObj.Logo_Id__c ||
              sObj.Account__r.Sub_Segment__c != oldObj.Sub_Segment__c ||
              sObj.Account__r.Industry != oldObj.Industry ||
              sObj.Account__r.TCL_Segment__c != oldObj.TCL_Segment__c ||
              sObj.Account__r.OwnerId != oldObj.OwnerId ||
              sObj.Account__r.PAN_No__c != oldObj.PAN_No__c ||
              sObj.Account__r.BillingStreet != oldObj.BillingStreet ||
              sObj.Account__r.BillingCity != oldObj.BillingCity ||
              sObj.Account__r.BillingPostalCode != oldObj.BillingPostalCode ||
              sObj.Account__r.RPT_Flag__c != oldObj.RPT_Flag__c ||
              sObj.Account__r.GTM_Type__c != oldObj.GTM_Type__c ||
              sObj.Account__r.Payment_Terms__c != oldObj.Payment_Terms__c ||
              sObj.Account__r.Advance_Arrears__c != oldObj.Advance_Arrears__c ||
              sObj.Account__r.Bill_Dispatch_Location_Integration__c != oldObj.Bill_Dispatch_Location_Integration__c
             )
         )
       {
       System.Debug( 'AccountDetailsUpdate EMPOWER FOR :: '+ sObj.getSObject('Account__r').get('Name') );
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'LOGO_UPDATE', 'Company__c');
            if(empTx != NULL)
            { empTx.Account__c = sObj.Account__c ;
              Datetime dte = Datetime.newInstance(Date.valueOf(sObj.Account__r.CreatedDate).year(), Date.valueOf(sObj.Account__r.CreatedDate).month(), Date.valueOf(sObj.Account__r.CreatedDate).day());
              empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('Logo_creation_date: ^^' , 'Logo_creation_date:'+dte.format('yyyy-MM-dd')+'^^');
              if(empTx.Insert_Transaction__c == true)
              empTranList.add(empTx);
            }
       }
    }
    
    //NOT IMPLEMENTED
    /*
    public static void COMPANYCREATION(Account sObj){
        //if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'COMPANYCREATION', 'ACCOUNT');
            if(empTx != NULL)
                empTranList.add(empTx);
    }
	*/
    
     public static void NVACCDELETION(Company__c sObj){
         EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'NVACCDELETION', 'Company__c');
            if(empTx != NULL)
              if(empTx.Insert_Transaction__c == true)
                empTranList.add(empTx);
        
    }

    public static void COMPANYTRANSFER(Account sObj, Account oldObj){
        if( oldObj!=null && sObj.OwnerId != oldObj.OwnerId && sObj.Logo_Status__c == 'Verified')
        {EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'COMPANYTRANSFER', 'ACCOUNT');
            if(empTx != NULL)
            { if(OldCompanyOwner.get(oldObj.OwnerId)!=null)
                empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^OLDOWNER:old~Owner.IDM_Id__c', '^^OLDOWNER:'+String.ValueOf(OldCompanyOwner.get(oldObj.OwnerId).IDM_Id__c));
                empTx.Account__c = sObj.Id;
              if(empTx.Insert_Transaction__c == true)
               empTranList.add(empTx);
            }
        }
    }

    /*
    //NOT IMPLEMENTED
    public static void COMPANYSHAREREVOKE(sObject sObj){
        //if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'COMPANYSHAREREVOKE', 'ACCOUNT');
            if(empTx != NULL)
                empTranList.add(empTx);
    }
	*/

    

    public static void LOGOCHANGE(Company__c sObj, Company__c oldObj){        
        if(oldObj!=null && sObj.Account__c != oldObj.Account__c)
        {EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'LOGOCHANGE', 'Company__c');
            if(empTx != NULL)
            {   if( OldCompanyAccount.get(oldObj.Account__c) != null )
              {empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^OLD_OWNER:old~Account__r.Owner.IDM_ID__c', '^^OLD_OWNER:'+String.ValueOf(OldCompanyAccount.get(oldObj.Account__c).Owner.IDM_Id__c) );
                 empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^OLDLOGOID:old~Account__r.Logo_Id__c', '^^OLDLOGOID:' + String.ValueOf(OldCompanyAccount.get(oldObj.Account__c).Logo_Id__c)) ;
                 empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^OLDLOGONAME:old~Account__r.Name', '^^OLDLOGONAME:' + String.ValueOf( OldCompanyAccount.get(oldObj.Account__c).Name ) );
                }
              if(empTx.Insert_Transaction__c == true)
                empTranList.add(empTx);
            }
        }
    }

    
	/*
    public static void NVACCDELETION(sObject sObj){
        //if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'NVACCDELETION', 'ACCOUNT');
            if(empTx != NULL)
                empTranList.add(empTx);
    }  
	*/
    /************** End - Account Method ***************/

    /************** Start - Lead Method ***************/
    public static void SENDSMS(Lead sObj){
        if(sObj.Owner.Phone != null )
        { EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'SENDSMS', 'LEAD');
            if(empTx != NULL)
            {  String company, shortcode, cir;
               if(String.IsEmpty(sObj.Account__c))
                    company = sObj.Company;
               else
                    company = sObj.Account__r.Name ;
                String msg = 'New Lead Customer Name '+company+',PRODUCT'+'  '+String.ValueOf(sObj.Product_Interest__c)+',CONTACT No '+sObj.MobilePhone+',ALTERNATE CONTACT No '+sObj.Phone ;
                if(LeadOwner.get(sObj.OwnerId)!=null)
                { shortcode = (LeadOwner.get(sObj.OwnerId).Circle__c=='Delhi' ? 'INDCOM':'DOCOMO');
                  cir = (LeadOwner.get(sObj.OwnerId).Circle__c!=null ? LeadOwner.get(sObj.OwnerId).Circle__c : 'NA');
                }
             empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^MSG: ', '^^MSG:'+msg);
             empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^CIRC_DESC: ', '^^CIRC_DESC:'+cir);
             empTx.Empower_Parameters__c = empTx.Empower_Parameters__c.replace('^^SHORTCODE: ', '^^SHORTCODE:'+shortcode);
             if(empTx.Insert_Transaction__c == true)
             empTranList.add(empTx);
            }
        }
    }    
    /************** End - Lead Method ***************/

    /************** Start - Product Method ***************/
    /*
    //NOT IMPLEMENTED
    public static void CREATENDATEPROD(sObject sObj){
        //if(/*..Condition for method CreateSoid..)
            EMPOWER_TRANSACTION__c empTx = generateTxRecords(sObj, 'CREATENDATEPROD', 'PRODUCT2');
            if(empTx != NULL)
                empTranList.add(empTx);
    }    
    */
    /************** End - Product Method **************/
}