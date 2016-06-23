/*
    * Name: BuildingQueryTriggerHandler Class
    * Created On: December 21, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the BuildingQueryTrigger, BuildingQueryTriggerHandler is called after insert, after update. 
    *              Purpose: Initiates the BuildingQuery Interface
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 21-12-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/

public without sharing class BuildingQueryTriggerHandler {
    
    /*
     * execute()
     * Purpose - Initiates the records for BuildingQuery Interface where Submit_to_AMT__c is canged to true.
     */
    public static void execute(List<Building_Query__c> newlist, Map<Id, Building_Query__c> mapOld, Boolean IsInsert, Boolean IsUpdate)
    {
        System.Debug('BuildingQueryTriggerHandler------ Execute()');
        //This list will be processed to create the JSON string for BuildingQuery Interface.
        List<Building_Query__c> ListForInterface = new List<Building_Query__c>();
        for(Building_Query__c NewObj : newlist)
         if( (isInsert && NewObj.Submit_to_AMT__c) || 
            (isUpdate && NewObj.Submit_to_AMT__c && NewObj.Submit_to_AMT__c!= mapold.get(NewObj.Id).Submit_to_AMT__c)
            )
            ListForInterface.add(NewObj);
        if( ListForInterface.size() > 0 )
             GenerateEmpowerREST.execute(ListForInterface);
    }
}