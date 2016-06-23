/*
    * Name: FeasibilityStatusTriggerHandler Class
    * Created On: March 25, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the FeasibilityStatusTrigger, FeasibilityStatusTriggerHandler is called before and after insert
    *              a.) Before Insert :: Populate Master detail Field Feasibility__c on Feasibility Status
    *              b.) After Insert :: Populate the Feasibility_Status__C lookup on parent Feasibility record.
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 25-03-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/
public without sharing class FeasibilityStatusTriggerHandler {
   
    /*
     * populateFeasibilityID()
     * Purpose : Populate Master detail Field Feasibility__c on Feasibility Status
     */
    public static void populateFeasibilityID(List<feasibility_status__c> newList)
    {
        System.Debug('FeasibilityStatusTriggerHandler---populateFeasibilityID()') ;
        Set<String> fanNumberSet = new Set<String>();
        for(Feasibility_Status__c obj : newList){
            String FanNumber = obj.FAN_Number__c;
            fanNumberSet.add(obj.FAN_Number__c);
        }
        
        Map<String,Feasibility__c> fanMap = new Map<String,Feasibility__c>();
        for(Feasibility__c f : [select id, fan_number__c from feasibility__c where fan_number__c in :fanNumberSet]){
            fanMap.put(f.FAN_Number__c,f);
        }
        for(Feasibility_Status__c obj : newList){
            if(fanMap.containsKey(obj.FAN_Number__c)){
                obj.Feasibility__c = fanMap.get(obj.FAN_Number__c).Id;
            }
        }
        
    }
    
    /*
     * executeAfterInsert()
     * Purpose: Populate the Feasibility_Status__C lookup on parent Feasibility record.
     */
    public static void executeAfterInsert( List<Feasibility_Status__C> newList )
    {
        System.Debug('FeasibilityStatusTriggerHandler---executeAfterInsert()') ;
        
        //The list of Feasibilities on which Feasibility_Status__C lookup has to be populated.
        List<Feasibility__C> Feasibility_List = new List<Feasibility__C>();
        for(Feasibility_Status__C FS : newList)
        {
            if( String.IsNotBlank( FS.Feasibility__c ) )
            {
                Feasibility__C FAN = new Feasibility__c( Id = FS.Feasibility__c , Feasibility_Status__c = Fs.Id );
                Feasibility_List.add( FAN );
            }
        }
        update Feasibility_List;
    }

}