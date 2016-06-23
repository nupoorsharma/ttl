/*
    * Name: DropCAFTriggerHandler Class
    * Created On: June 17, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: executeBefore() -- Sets the status to "Needs Validation" if required.
    *              executeAfter()  -- Sends the Drop CAF records for ePOS Interface if required.
    * Change Log History:
    * |--------------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description                   |
    * |--------------------------------------------------------------------|
    * |   0.1   | Nupoor     | 21-12-2016 | Initial version of Class       |
    * |--------------------------------------------------------------------|    
*/
public without sharing class DropCAFTriggerHandler {
    /*
     * executeBefore()
     * Purpose :: Sets the status on Drop CAF record to "Needs Validation"
     *            if it is required to be sent for ePos Interface.
     *              >>> At Insert, If CAF Number is not "Valid"
     *              >>> At Update, If CAF Number is Changed
     *              >>> At Update, If Retry is changed to Checked
     */
    public static void executeBefore(List<Drop_CAF__c> newList, Map<ID, Drop_CAF__c> oldMap, Boolean IsInsert, Boolean IsUpdate)
    {
        for(Drop_CAF__c newObj : newList)
        {
            if( IsInsert && String.IsNotBlank(newObj.CAF_Number__c) && newObj.CAF_Status__c!='Valid')
                newObj.CAF_Status__c = 'Needs Validation';
            else if( IsUpdate && String.IsNotBlank(newObj.CAF_Number__c) 
                    && ( (newObj.CAF_Number__c != oldMap.get(newObj.Id).CAF_Number__c)
                         || (newObj.Retry__c && (newObj.Retry__c != oldMap.get(newObj.Id).Retry__c)))
                   )
                newObj.CAF_Status__c = 'Needs Validation';
        }
    }
    
    /*
     * executeAfter()
     * Purpose :: Sends the Drop CAF records for ePos Interface (CAF Validation)
     *            when:
     *                >>> At Insert, If CAF Number is not "Valid"
     *                >>> At Update, If CAF Number is Changed
     *                >>> At Update, If Retry is changed to Checked
     */
    public static void executeAfter(List<Drop_CAF__c> newList, Map<ID, Drop_CAF__c> oldMap, Boolean IsInsert, Boolean IsUpdate)
    {
        List<Drop_CAF__c> ListForInterface = new List<Drop_CAF__C>();
        for(Drop_CAF__c newObj : newList)
        {
            if( IsInsert && String.IsNotBlank(newObj.CAF_Number__c) && newObj.CAF_Status__c!='Valid')
                ListForInterface.add(newObj) ;
            else if( IsUpdate && String.IsNotBlank(newObj.CAF_Number__c) 
                    && ( (newObj.CAF_Number__c != oldMap.get(newObj.Id).CAF_Number__c)
                         || (newObj.Retry__c && (newObj.Retry__c != oldMap.get(newObj.Id).Retry__c)))
                   )
                ListForInterface.add(newObj) ;
        }
        
        if( !ListForInterface.IsEmpty() )
             GenerateEmpowerREST.execute(ListForInterface);
             //The logic to generate JSON & Empower_REST__c object is contained in GenerateEmpowerREST
    }
}