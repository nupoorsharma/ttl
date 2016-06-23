/*
    * Name: EmpowerTransactionTriggerHandler Class
    * Created On: May 7, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the EmpowerTransactionTrigger, EmpowerTransactionTriggerHandler is called before insert, after update. 
    *            =>It is used to update status on Account/Opportunity in case
    *              status is updated as "SUCCESS" for the below Method Names: 
    *              NONVERIFIED ----------------------------- Account
    *              LOGO_VERFIFCATION_STATUS ---------------- Account
    *              CREATESOID ------------------------------ Opportunity
                 =>It is used to update the NV_Transaction_Created__c on Account to true for a NONVERIFIED Transaction.
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 28-01-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/
public without sharing class EmpowerTransactionTriggerHandler {
    /*
     * executeAfterUpdate()
     ******PURPOSE: It is used to update status on Account/Opportunity in case
     *              status is updated as "SUCCESS" for the below Method Names: 
     *              NONVERIFIED ----------------------------- Account
     *              LOGO_VERFIFCATION_STATUS ---------------- Account
     *              CREATESOID ------------------------------ Opportunity
     */
    public static void executeAfterUpdate(List<EMPOWER_TRANSACTION__c> newList, Map<Id, EMPOWER_TRANSACTION__c> mapOld)
    {
        System.Debug('EmpowerTransactionTriggerHandler -------------- executeAfterUpdate()');
        Map<Id, SObject> SObject_Map = new Map<Id, SObject>();
        
        for(EMPOWER_TRANSACTION__c newObj : newList)
        {
            if(newObj.Empower_status__c == 'SUCCESS')
            {
                if(newObj.Empower_Method_Name__c == 'NONVERIFIED' && String.isNotBlank(newObj.Account__c))
                {
                    //Create a new Account object if it is not found in the SObject_Map
                    //and update the NV_Created_in_Empower__c field to true
                     Account acc;
                    if(SObject_Map.containsKey(newObj.Account__c))
                        acc =  (Account) SObject_Map.get(newObj.Account__c);
                    else
                    { acc = new Account();
                      acc.id = newObj.Account__c;
                    }
                        acc.NV_Created_in_Empower__c = true;
                        SObject_Map.put(newObj.Account__c, acc);
                }
                else if(newObj.Empower_Method_Name__c == 'LOGO_VERFIFCATION_STATUS' && String.isNotBlank(newObj.Account__c) )
                {
                    //Create a new Account object if it is not found in the SObject_Map
                    //and update the Verified_Acc_Created_in_Empower__c field to true
                     Account acc;
                    if(SObject_Map.containsKey(newObj.Account__c))
                        acc =  (Account) SObject_Map.get(newObj.Account__c);
                    else
                    { acc = new Account();
                      acc.id = newObj.Account__c;
                    }
                        acc.Verified_Acc_Created_in_Empower__c = true;
                        SObject_Map.put(newObj.Account__c, acc);
                }
                else if(newObj.Empower_Method_Name__c == 'CREATESOID' && String.isNotBlank(newObj.Opportunity__c) )
                {
                    //Create a new Opportunity object if it is not found in the SObject_Map
                    //and update the SOID_Created_in_Empower__c field to true
                    Opportunity opp;
                    if(SObject_Map.containsKey(newObj.Opportunity__c))
                        opp =  (Opportunity) SObject_Map.get(newObj.Opportunity__c);
                    else
                    { opp = new Opportunity();
                      opp.id = newObj.Opportunity__c;
                    }
                        opp.SOID_Created_in_Empower__c = true;
                        SObject_Map.put(newObj.Opportunity__c, opp);
                }
            }
         }
        
        if(SObject_Map.size() > 0)
        {
         List<Account> Update_ACC_List = new List<Account>();
         List<Opportunity> Update_OPP_List = new List<Opportunity>();
         for(Id ObjectID : SObject_Map.keySet() )
         {
             if( String.ValueOf(ObjectID).startsWithIgnoreCase(Opportunity.sobjecttype.getDescribe().getKeyPrefix()) )
                 Update_OPP_List.add( (Opportunity) SObject_Map.get(ObjectID));
             else
                 Update_ACC_List.add( (Account) SObject_Map.get(ObjectID));
         }
         System.Debug(LoggingLevel.DEBUG, '#EmpowerTransactionTriggerHandler#  Size of Update Opportunity List: '+Update_OPP_List.size());
         System.Debug(LoggingLevel.DEBUG, '#EmpowerTransactionTriggerHandler#  Size of Update Account List: '+Update_ACC_List.size());
         update Update_OPP_List;
         update Update_ACC_List;
        }
            
    }
    
    /*
     * executeBeforeInsert()
     * Purpose - Update the NV_Transaction_Created__c checkbox to true when a NONVERIFIED Transaction is Created.
     */
    public static void executeBeforeInsert(List<EMPOWER_TRANSACTION__c> newList)
    {
        System.Debug('EmpowerTransactionTriggerHandler -------------- executeBeforeInsert()');
        List<Account> AccountUpdateList = new List<Account>();
        Set<ID> AccountUpdateSET = new SET<ID>();
        for(EMPOWER_TRANSACTION__c newObj: newList)
        {
            if(newObj.Empower_Method_Name__c == 'NONVERIFIED' && String.isNotBlank(newObj.Account__c) && (AccountUpdateSET.contains(newObj.Account__c)==false))
            {
                Account updateAcc = new Account();
                updateAcc.id = newObj.Account__c;
                updateAcc.NV_Transaction_Created__c = true;
                AccountUpdateSET.add(newObj.Account__c);
                AccountUpdateList.add( updateAcc );
            }
        }
        
        update AccountUpdateList;
    }

}