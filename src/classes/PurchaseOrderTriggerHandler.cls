/*
    * Name: PurchaseOrderTriggerHandler
    * Created On: 6 April 2016
    * Author: Abhishek Tyagi (Compro Technologies)
    * Description: Initiates the Purchase Order Interface.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Abhishek   | 06-04-16 |Initial version of Trigger|
    * |------------------------------------------------------------|     
*/
public without sharing class PurchaseOrderTriggerHandler {
    
    /*
     * execute()
     * Purpose - Sends the PO records for Purchase Order interface when Approval Status is changed to "Approved"
     *           or Resubmit_to_Empower__c is changed to true.
     */
    public static void execute(List<Purchase_Order__c> newlist, Map<Id, Purchase_Order__c> mapOld, 
                               Boolean IsInsert, Boolean IsUpdate, Boolean IsBefore, Boolean IsAfter)
                                   
    {
        System.Debug('PurchaseOrderTriggerHandler------ Execute()');
        //Search for the records to be sent via PurchaseOrderInterface callout in after insert/update scenarios
       	//This list will be processed to create the JSON string for Purchase Order Interface.
        List<Purchase_Order__c> ListForInterface = new List<Purchase_Order__c>();
        
        for(Purchase_Order__c NewObj : newlist)
        if(   (isInsert && NewObj.Approval_Status__c == 'Approved') 
            || (isUpdate && NewObj.Approval_Status__c == 'Approved' && NewObj.Approval_Status__c != mapold.get(NewObj.Id).Approval_Status__c) 
            || (isUpdate && NewObj.Approval_Status__c == 'Approved' && NewObj.Resubmit_to_Empower__c && NewObj.Resubmit_to_Empower__c != mapold.get(NewObj.Id).Resubmit_to_Empower__c )
            )
            ListForInterface.add(NewObj);
        
         if( ListForInterface.size() > 0 )
             GenerateEmpowerREST.execute(ListForInterface);
    }                           
                               

}