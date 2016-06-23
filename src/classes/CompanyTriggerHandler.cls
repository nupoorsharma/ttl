/*
    * Name: CompanyTriggerHandler Class
    * Created On: January 28, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the CompanyTrigger, CompanyTriggerHandler is called after insert,after update, before delete. 
    *              It is used to initiate Empower Transaction for NONVERIFIED, LOGOCHANGE and NVACCDELETION Interfaces.
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 28-01-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/

public without sharing class CompanyTriggerHandler {
    
     public static void execute(List<Company__C> newList, Map<Id, Company__C> mapOld, 
                                Boolean IsInsert, Boolean IsUpdate, Boolean IsDelete, 
                                List<Company__c> oldList)
     {System.Debug('CompanyTriggerHandler :: execute()') ;
         if(IsInsert)
         GenerateEmpowerTransactions.execute(newList, null, 'Company__c');
         if(IsUpdate)
		 GenerateEmpowerTransactions.execute(newList, mapOld, 'Company__c');
         if(IsDelete)
         GenerateEmpowerTransactions.execute(newList, mapOld, 'Company__c');
     }

}