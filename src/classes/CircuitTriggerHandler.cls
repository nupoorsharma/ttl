/*
    * Name: CircuitTriggerHandler Class
    * Created On: April 21, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the CircuitTrigger before insert. 
    *              Purpose: Populate Lookups for Account, opportunity and Feasibility from external IDs
    *                       provided as Logo_Id__c, extra_Test2__c and FAN_Number__c.
    * Change Log History:
    * |---------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description              |
    * |---------------------------------------------------------------|
    * |   0.1   | Nupoor     | 21-04-2016 | Initial version of Class  |
    * |---------------------------------------------------------------|    
*/
public without sharing class CircuitTriggerHandler {
    
    public static void executeBeforeInsert( List<SME_OrderValueBackUpdation__c> newlist )
    {
        
        System.Debug('CircuitTriggerHandler----------- executeBeforeInsert()');
        
        Set<String> LOGO_ID_SET = new Set<String>();
        Set<String> SOID_SET = new Set<String>();
        
        for(SME_OrderValueBackUpdation__c newObj : newList)
        {
            if( String.IsNotBlank( newObj.Logo_ID__c ) )
                LOGO_ID_SET.add( newObj.Logo_ID__c ) ;
            if( String.IsNotBlank( newObj.ExtraText2__c ) )
                SOID_SET.add( newObj.ExtraText2__c ) ;
        }
        
        List<Account> ACCOUNT_List = [Select Id, Logo_Id__c from Account where Logo_Id__c IN :LOGO_ID_SET] ;
        List<Opportunity> OPPORTUNITY_List = [Select Id, SOID__c from Opportunity where SOID__c IN :SOID_SET] ;
        
        //Populate LOGO_ID_Map with logo Id on account as key and Account Id as value.
        Map<String, ID> LOGO_ID_Map = new Map<String, ID>();
        for(Account ac : ACCOUNT_List)
            LOGO_ID_Map.put(ac.Logo_Id__c , ac.Id);
        
        //Populate SOID_Map with SOID on Opportunity as key and Opportunity Id as value.
        Map<String, ID> SOID_Map = new Map<String, ID>();
        for(Opportunity opp : OPPORTUNITY_List)
            SOID_Map.put(opp.SOID__c , opp.Id);
        
        for(SME_OrderValueBackUpdation__c circuit : newList)
        {
            if( LOGO_ID_Map.get( circuit.Logo_ID__c ) != null )
                circuit.Account__c = LOGO_ID_Map.get( circuit.Logo_ID__c );
            if( SOID_Map.get( circuit.ExtraText2__c ) != null )
                 circuit.OpportunityID__c = SOID_Map.get( circuit.ExtraText2__c );
            if( String.isNotBlank( circuit.FAN_number__c ) )
            {
                Feasibility__c FAN = new Feasibility__c( FAN_Number__C = circuit.FAN_number__c.trim() );
                circuit.Feasibility__r = FAN ;
            }
        }
       
    }
    
    /*Coded by Vaibhaw*/
    public static void executeBefore( List<SME_OrderValueBackUpdation__c> newlist, Map<Id, SME_OrderValueBackUpdation__c> oldMap, Boolean IsInsert, Boolean IsUpdate )
    {
        
        List<String> FanNumberList = new List<String>();
        for(SME_OrderValueBackUpdation__c smb : newlist) 
        {
            if(smb.FAN_Number__c != null) {
                FanNumberList.add(smb.FAN_Number__c);
            }
        } 
        List<Feasibility__c> fsList;
        fsList = Database.query('Select Id, Fan_Number__c, (SELECT Id FROM AV_CV__r ORDER BY LastModifiedDate DESC LIMIT 1) FROM Feasibility__c WHERE FAN_NUMBER__C IN :FanNumberList');
        if(fsList.size()>0) 
        {
            Map<String,Feasibility__c> fsMap = new Map<String,Feasibility__c>();
            for(Feasibility__c fs:fsList) {
                fsMap.put(fs.Fan_Number__c,fs);
            }
            for(SME_OrderValueBackUpdation__c smb : newlist) 
            {
                if(isInsert) 
                {
                    if(smb.FAN_number__c != null) {
                        if(fsMap.containsKey(smb.FAN_number__c)) {
                           smb.Feasibility__c = fsMap.get(smb.FAN_number__c).id;
                           if(fsMap.get(smb.Fan_number__c).Av_Cv__r.size()>0) {
                               smb.AV_CV__c = fsMap.get(smb.Fan_number__c).AV_CV__r[0].id;
                           }
                        }
                    }
                } 
                else if (isUpdate) 
                {
                    if(smb.FAN_Number__c != oldMap.get(smb.id).FAN_Number__c) {
                        if(fsMap.containsKey(smb.FAN_number__c)) {
                           smb.Feasibility__c = fsMap.get(smb.FAN_number__c).id;
                           if(fsMap.get(smb.Fan_number__c).Av_Cv__r.size()>0) {
                               smb.AV_CV__c = fsMap.get(smb.Fan_number__c).Av_Cv__r[0].id;
                           }
                        }
                    }
                }
            }
        }
    }

}