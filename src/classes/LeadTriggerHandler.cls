/*
    * Name: LeadTriggerHandler Class
    * Created On: November 23, 2015
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the LeadTrigger, LeadTriggerHandler is used to 
    *               a. After :: Convert a lead when Convert_Lead__c checkbox is checked. Lead is associated to an existing account via Account__c lookup field. 
    *                            Assign Opportunity/Contact Owner as Account Owner for Lead_Type__c "Existing"
    *               b. Before :: Associate a lead with an Account by finding an exact match for AccountName given in Company field when Lead_Type__c is Sharing Request.
    *                            If no Exact Match is found, the trigger throws an error from the label Lead_Sharing_Request_Error.
    *                            Also, If the Lead Owner has changed, update the Previous Owner Lookup field.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 23-11-15 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

public without sharing class LeadTriggerHandler{
    public class CustomException extends Exception{}
    /*
     * createLeadConvert(ID leadID, String ConvertStatus)
     *  Purpose -- Return a Database.LeadConvert object without adding AccountID
     */
    public static Database.LeadConvert createLeadConvert(ID leadID, String ConvertStatus)
    {
        Database.LeadConvert lc = new Database.LeadConvert();
         lc.setLeadId(leadID);
         lc.setConvertedStatus(ConvertStatus);
         System.Debug(LoggingLevel.FINE, 'Lead has NO Account Id');
         System.Debug(LoggingLevel.FINE, 'Account Id of the converted lead :: ' + lc.getAccountId());
        return lc;
        
    }
    
    /*
     * createLeadConvert(ID leadID, ID AccountID, String ConvertStatus)
     *  Purpose -- Return a Database.LeadConvert object after adding AccountID
     */
    public static Database.LeadConvert createLeadConvert(ID leadID, ID AccountID, String ConvertStatus)
    {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadID);
        lc.setAccountId(AccountID);
        lc.setConvertedStatus(ConvertStatus);
        System.Debug(LoggingLevel.FINE, 'Lead has an Account Id');
        System.Debug(LoggingLevel.FINE, 'Account Id of the converted lead :: ' + lc.getAccountId());
        return lc;
    }
    
    /*
     * createLeadConvert(ID leadID, ID AccountID, String ConvertStatus)
     *  Purpose -- Return a Database.LeadConvert object after adding AccountID and OwnerID
     */
    public static Database.LeadConvert createLeadConvert(ID leadID, ID AccountID, ID OwnerID, String ConvertStatus)
    {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadID);
        lc.setAccountId(AccountID);
        lc.setOwnerId(OwnerID);
        lc.setConvertedStatus(ConvertStatus);
        System.Debug(LoggingLevel.FINE, 'Lead has an Account Id and Owner Id [Existing Account]');
        System.Debug(LoggingLevel.FINE, 'Account Id of the converted lead :: ' + lc.getAccountId() + 'Owner Id :: '+ lc.getOwnerId());
        return lc;
    }
    
   
   /*
    * eXecuteAfter() Purpose -- Convert Lead if the Checkbox Convert_Lead__c is true.
    *                        -- Assign Owner ID for Opportunity/Contact for Lead_Type__c "Existing"
    */
    public static void executeAfter(List<Lead> newlist, Map<Id, Lead> mapOld, boolean isInsert, boolean isUpdate)
    //The logic to convert a lead when Convert_Lead__c is checked and associate it to an account via the Account__c field.
    {
       
        //Get Masterlabel of Lead Status which is converted.
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        //List to store all leads which are required to be converted.
        List<Database.LeadConvert> ConvertList = new List<Database.LeadConvert>();
        //Collect all Account__c on new leads
        List<ID> AccountID = new List<ID>();
        for(lead newLead : newList)
            if( !String.IsEmpty(newLead.Account__c) )
                AccountID.add(newLead.Account__c) ;
        //Map Account Id to Account Object. Used to pass Owner ID for newly created Opportunities on Existing Accounts.
        Map<ID, Account> AccountOwnerMap = new Map<ID, Account>([Select Id, OwnerId, Owner.User_Category__c from Account where ID in :AccountID]);
        
        
        if(isInsert)
        {
        for (Lead l : newlist) {
            if ((l.Convert_Lead__c == true) && !L.isConverted) 
            {
                if (!String.isEmpty(l.Account__c)) 
                //Associate a lead to an existing account when Account__c is populated.
                {
                    //Let the Opportunity Owner be the Lead Owner for Sharing Request.
                    if(l.Lead_Type__c != 'Existing')
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, convertStatus.MasterLabel ) );
                    else if(l.Lead_Type__c == 'Existing' && AccountOwnerMap.get(l.Account__c).Owner.User_Category__c != 'Governance' )
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, AccountOwnerMap.get(l.Account__c).OwnerId , convertStatus.MasterLabel ) );
                    else if(l.Lead_Type__c == 'Existing' && AccountOwnerMap.get(l.Account__c).Owner.User_Category__c == 'Governance' )
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, convertStatus.MasterLabel ) );
                } 
                else 
                //Create a new account when Account__c is blank.
                {
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , convertStatus.MasterLabel ) );
                }
            }

        }
        }
        if(isUpdate)
        {        
        for (Lead l : newlist) {
            if ((l.Convert_Lead__c != mapOld.get(l.Id).Convert_Lead__c) && (l.Convert_Lead__c == true) && !L.isConverted) 
            {
                if (!String.isEmpty(l.Account__c)) 
                //Associate a lead to an existing account when Account__c is populated.
                { 
                 //Let the Opportunity Owner be the Lead Owner for Sharing Request.
                 if(l.Lead_Type__c == 'Sharing Request')
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, convertStatus.MasterLabel ) );
                 else if(l.Lead_Type__c == 'Existing' && AccountOwnerMap.get(l.Account__c).Owner.User_Category__c != 'Governance' )
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, AccountOwnerMap.get(l.Account__c).OwnerId , convertStatus.MasterLabel ) );
                 else if(l.Lead_Type__c == 'Existing' && AccountOwnerMap.get(l.Account__c).Owner.User_Category__c == 'Governance' )
                    ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , l.Account__c, convertStatus.MasterLabel ) );
                } 
                else 
                //Create a new account when Account__c is blank.
                {
                 ConvertList.add( LeadTriggerHandler.createLeadConvert(l.id , convertStatus.MasterLabel ) );
                }
            }
        }
        }
        
        //Convert Leads if the size of ConvertList is greater than 0.
        if (Convertlist.size() > 0) {
            System.Debug(LoggingLevel.Debug, 'Converting all Leads');
            //Convert all leads in ConvertList
                Database.LeadConvertResult[] lcr = Database.convertLead(ConvertList);
                for (Database.LeadConvertResult res : lcr) {
                    System.Debug(LoggingLevel.DEBUG,'IS Success: ' + res.isSuccess());
                    System.Debug(LoggingLevel.DEBUG,'Errors :' + res.getErrors());
                    //System.assert(res.isSuccess());
                    if (res.isSuccess()) {
                        System.Debug( LoggingLevel.Debug, 'Lead Successfully Converted with Account Id :: ' + res.accountId);
                    }
                }
         }
    }
   
    /*
     * excuteBefore() Purpose -- Find an Account based on Lead Company if Lead_Type__c is Sharing Request.
     *                        -- Throw an error if no exact match is found. Error message is in custom label - Lead_Sharing_Request_Error.
     *                        -- If the Lead Owner has changed, update the Previous Owner Lookup field.
     */
   public static void executeBefore(List<Lead> newlist, Map<Id, Lead> mapOld, boolean isInsert, boolean isUpdate)
   {
        //Stores the Company Names to query Accounts.
        List<String> LogoNames = new List<String>();
        //List of Accounts corresponding to Company Names
        List<Account> AccountList = new List<Account>(); 
        //Account Name Mapped to its ID
        Map<String, ID> AccountMap = new Map<String, Id>();
        //Loop over the new Leads to get all Lead Companies when Lead_Type__c is Sharing Request and no Account__c is populated.
        for( Lead newlead : newlist)
        {
            if( newlead.Lead_Type__c == 'Sharing Request' &&  String.IsEmpty(newlead.Account__c) )
              LogoNames.add( newlead.Company );  
        }
       //Query Account to find an exact match for Lead Companies.
        AccountList = [Select ID, Name from Account where name in :LogoNames];
       //Map Account Name with its ID.
        for(Account a: AccountList)
            AccountMap.put( a.Name.ToLowerCase(), a.id);
        System.Debug(LoggingLevel.FINE,  'Account Map: '+ AccountMap);
       
       //**************** Add Account__c based on Lead Company, throw an error if no Exact match is found. ************//
        if(isInsert)
        {
            for (Lead l : newlist) 
            {
                System.Debug(LoggingLevel.FINE, 'LeadTriggerHandler--ExecuteBefore() :: A Lead has been Inserted: \t' + l.LastName);
                //Populate Account__c if Lead Type is Sharing Request and Account__c is Empty.
                if(l.Lead_Type__c == 'Sharing Request' &&  String.IsEmpty(l.Account__c))
                {
                    //If an Exact Match is found, populate Account__c
                    if( !String.IsEmpty( AccountMap.get(l.Company.ToLowerCase()) ) )
                    {
                        l.Account__c = AccountMap.get(l.Company.ToLowerCase());
                        System.Debug(LoggingLevel.FINE, 'Adding Account__C based on Company as : '+AccountMap.get(l.Company) );
                    }
                    //Throw an error if no Exact Match is found.
                    else
                        l.addError(System.Label.Lead_Sharing_Request_Error);
                }
            }
        }
       //**************** Add Account__c based on Lead Company, throw an error if no Exact match is found. ************//
       //************** If the Lead Owner has changed, update the Previous Owner Lookup field ************************//
       if(isUpdate)
        {        
            for (Lead l : newlist) 
            {
                System.Debug(LoggingLevel.FINE, 'LeadTriggerHandler--ExecuteBefore() :: A Lead has been Updated: \t' + l.LastName); 
                //Populate Account__c if Lead Type is Sharing Request and Account__c is Empty and Lead Type has been changed.
                 if(l.Lead_Type__c == 'Sharing Request' &&  String.IsEmpty(l.Account__c) && (l.Lead_Type__c != mapOld.get(l.Id).Lead_Type__c))
                {
                    //If an Exact Match is found, populate Account__c
                    if( !String.IsEmpty( AccountMap.get(l.Company.ToLowerCase()) ) )
                    {   System.Debug(LoggingLevel.FINE, 'Adding Account__C based on Company as : '+AccountMap.get(l.Company) );
                        l.Account__c = AccountMap.get(l.Company.ToLowerCase());
                    }
                    //Throw an error if no Exact Match is found.
                    else
                        l.addError(System.Label.Lead_Sharing_Request_Error);
                }

                //If the Lead Owner has changed, update the Previous Owner Lookup field
                if (l.OwnerId != mapOld.get(l.Id).OwnerId)
                    l.Previous_Owner__c = mapOld.get(l.id).OwnerId;
            }
        }
       
   }

    /*
     *  execute() Purpose -- Call executeBefore() or executeAfter() based on Trigger.isAfter/Trigger.isBefore
     */
    public static void execute(List<Lead> newlist, Map<Id, Lead> mapOld, boolean isInsert, boolean isUpdate, boolean isBefore, boolean isAfter)
     {
          System.Debug('LeadTrigger Handler---Execute()');
         if(isBefore)
             LeadTriggerHandler.executeBefore(newlist,mapold,isInsert,isUpdate);
         else if(isAfter)
             LeadTriggerHandler.executeAfter(newlist,mapold,isInsert,isUpdate);
         
         //Call Empower Interface for SEND SMS
         if(isInsert && isAfter)
             GenerateEmpowerTransactions.execute( newList , mapOld, 'LEAD');

     }


   
    

}