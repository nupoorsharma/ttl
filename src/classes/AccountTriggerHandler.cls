/*
    * Name: AccountTriggerHandler Class
    * Created On: May 21, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the  AccountTrigger, AccountTriggerHandler is called after insert, after update. 
    *              => It is used to initiate Empower Transaction for NONVERIFIED, COMPANYTRANSFER,
    *                 Logo Verification Status and Logo Details Update Interface.
    *              => Called after insert to create the Default Company. 
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 21-05-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/
public class AccountTriggerHandler {
    
    /*
     * execute()
     * Propose: Initiates the following Interfaces;
     *          NONVERIFIED
     *          LOGO_VERFIFCATION_STATUS
     *          LOGO_UPDATE
     *          COMPANYTRANSFER
     */     
    public static void executeAfterUpdate(List<Account> newList, Map<Id, Account> mapOld)
     {
         System.Debug('AccountTriggerHandler :: executeAfterUpdate()') ;
         List<Company__c> CompanyList = [Select Id, Name, Account__c, Id__c, Default__c 
                                         from Company__c where Default__c=true and Account__c in :newList] ;
        GenerateEmpowerTransactions.execute(CompanyList, null, 'Company__c'); //For NONVERIFIED
        GenerateEmpowerTransactions.execute( newList , mapOld, 'ACCOUNT');
        GenerateEmpowerTransactions.execute( CompanyList , mapOld, 'Company__c');
       
     }
    
    /*
     * executeafterinsert()
     * Propose: Create the Default Company for this account which will be used for all Integrations.
     */ 
    public static void executeAfterInsert(List<Account> newList)
    {
        System.Debug('AccountTriggerHandler :: executeAfterInsert()');
        //This List of Default Companies will be inserted in the end.
        List<Company__C> CompanyList = new List<Company__c>();
        for(Account newObj : newList)
        {
            Company__c DefaultCompany = new Company__c();
            DefaultCompany.Name =  newObj.Name;
            DefaultCompany.Default__C = true;
            DefaultCompany.Account__c = newObj.ID;
            CompanyList.Add(DefaultCompany);
        }
        
        insert CompanyList;
    }

}