/*
    * Name: OpportunityTriggerHandler Class
    * Created On: November 24, 2015
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the OpportunityTrigger, OpportunityTriggerHandler is used to
    *               a.) Assign a Company to an Opportunity. A Company is associated to an existing account via Account__c lookup field.
    *               b.) Assign a PriceBook2 to an Opportunity. PriceBook2Id is based on the combination of Logo_Segment__c(Account) and User_Segment__c(Owner).
    *               c.) If the stage is not identified/lost, the opportunity should have atleast one ContactRole otherwise an error is thrown.
    *                   Error message is in Custom Label - Atleast_one_Contact_Role_on_opportunity
    *               d.) Trigger Empower transaction creation for CREATESOID, UPDATESOID, BLOCK/UNBLOCK SOID Interfaces
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 24-11-15 |Initial version of Class  |
    * |------------------------------------------------------------|
    * |   0.2   | Nupoor     | 26-11-15 |Add Company               |
    * |------------------------------------------------------------|
    * |   0.3   | Nupoor     | 27-11-15 |Add Pricebook             |
    * |------------------------------------------------------------|
    * |   0.4   | Nupoor     | 11-12-15 |Atleast 1 ContactRole     |
    * |------------------------------------------------------------|
*/

public without sharing class OpportunityTriggerHandler {

  /*
   * executeAfter() is called after insert/update.
   * Functionality: Validate that an opportunity with stage other than lost/Identified should have atleast one ContactRole.
   */
  public static void executeAfter(List<Opportunity> newList, Map<Id, Opportunity> mapOld, boolean isInsert, boolean isUpdate) 
  {
    System.Debug('Inside ExecuteAfter() of OpportunityTriggerHandler');

    if (isUpdate) 
    {
      /********* If the stage is not identified/lost, the opportunity should have atleast one ContactRole. ***********/
      
      //Collect the Number of OpportunityContactRoles corresponding to each opportunity.
      List<AggregateResult> ContactRoles = new List<AggregateResult>([select count(id) NumberOfContacts, OpportunityID 
                                                                      from OpportunityContactRole
                                                                      where OpportunityId in :newList
                                                                      group by OpportunityID ]);
      MAP<String, Integer> ContactRolesMap = new Map<String,Integer>();
      //Map the opportunityId as key and total number of OpportunityContactRoles as value.
      for(AggregateResult AR : ContactRoles )
      {
          ContactRolesMap.put(String.ValueOf(AR.get('OpportunityID')) , Integer.ValueOf(AR.get('NumberOfContacts')));
      }
      
      /*********** Validate that an Opportunity has atleast one OpportunityContactRole if the stage is not Identified/Lost *******/
   
      for (Opportunity newOpp : newList)
      { 
          //For any stage other than Identified/Lost always have atleast one OpportunityContactRole
          if( (newOpp.Probability > 10) && (ContactRolesMap.get(newOpp.Id) == null) )
          {
              //Throw an error if no OpportunityContactRole is present
              newOpp.addError(System.Label.Atleast_one_Contact_Role_on_opportunity);
          }
      }

    }
  }
    
    
  /*
   * executeBefore() is called before insert/update.
   * Functionality: Used to add the Default Company Id and PriceBook2Id based on account & owner.
   *                Used to add Opportunity Team Members as child Opportunity_Loss_Approval__c records if Request_for_Lost_Dropped__c is true.
   */
  public static void executeBefore(List<Opportunity> newList, Map<Id, Opportunity> mapOld, boolean isInsert, boolean isUpdate ) {
    System.Debug('Inside ExecuteBefore() of OpportunityTriggerHandler');
      
  
    //Collect all AccountIDs to query  Company__c
    List<ID> AccountID = new List<ID>();
    //Collect all PriceBook2 Keys to query pricebook2
    List<String> PriceBookKeyList = new List<String>();
    //Create a Map to store AccountId as key and Company__c as value.
    Map<Id, Company__c> CompanyMap = new Map<Id, Company__c>();
    //Create a Map to store PriceBook Key__c as Key and PriceBook2 as value.
    Map<String, PriceBook2> PriceBookMap = new Map<String, PriceBook2>();

    for (Opportunity o : newList) 
    {
      AccountID.add(o.AccountId);

       //Query PriceBook2 based on these keys.
      if( isInsert &&  !String.IsEmpty(o.Lead_No__c) )
       PriceBookKeyList.add( o.Lead_Owner_User_Segment__c+'~'+o.PriceBook_Segment__c.substringAfter('~') );

      else if (!String.IsEmpty(o.PriceBook_Segment__c))         
        PriceBookKeyList.add(o.PriceBook_Segment__c);
    }


    //Only the Default Company (where default__c = true) needs to be queried.
    List<Company__c> CompanyList = new List<Company__c>([Select Id, Name, Account__c, Default__c, ID__c, Key__c
                                                        from Company__c
                                                        where Account__c in :AccountID and Default__c = true]);


    for (Company__c CompanyObject : CompanyList ) 
    {//Map Account Id with Company Object.
      CompanyMap.put(CompanyObject.Account__c, CompanyObject);
    }
    if(isInsert)
    {
        //Get the PriceBooks which have the required keys and are Active
         List<PriceBook2> PriceBookList = new List<PriceBook2>([Select Id, Name, key__C, IsActive
                                                                from PriceBook2
                                                                where Key__c in :PriceBookKeyList and IsActive = true]);
    
         //System.Debug(PriceBookList)  ;
        for (PriceBook2 p : PriceBookList) {           
          //Map PriceBook2 Key__c to PriceBook2 object.
          PriceBookMap.put(p.Key__c , p);
        }
        //System.Debug('---------- PriceBook Map ---------');
        //System.Debug(PriceBookMap);
    }
      
    /************************************** Add Company Id ***************************************/
    /************************************* Add PriceBook2Id **************************************/
    if (isInsert) 
    {
      for (Opportunity newOpp : newList) 
      {
        //Get the Company corresponding to Opportunity's AccountId
        if (CompanyMap.get(newOpp.AccountId) != null) 
        {
          //Associate the Default Company to an Opportunity
          System.Debug('Inserting Company Id: ' + CompanyMap.get(newOpp.AccountId).Id);
          newOpp.Company__c = CompanyMap.get(newOpp.AccountId).Id;
        }

        //Add PriceBook2Id - this should only run for Opportunities where MACD_Type__c is blank.
        if( isInsert && (newOpp.Is_MACD_Opportunity__c==false)  &&  !String.IsEmpty(newOpp.Lead_No__c) && (PriceBookMap.get( newOpp.Lead_Owner_User_Segment__c+'~'+newOpp.PriceBook_Segment__c.substringAfter('~') ) != null))
        {
            System.Debug('Adding PriceBook : ' + PriceBookMap.get( newOpp.Lead_Owner_User_Segment__c+'~'+newOpp.PriceBook_Segment__c.substringAfter('~') ).Id);
          newOpp.PriceBook2Id = PriceBookMap.get( newOpp.Lead_Owner_User_Segment__c+'~'+newOpp.PriceBook_Segment__c.substringAfter('~') ).Id;
        }
        else 
        {
          if((newOpp.Is_MACD_Opportunity__c==false) && PriceBookMap.get(newOpp.PriceBook_Segment__c) != null)
        {
          newOpp.PriceBook2Id = PriceBookMap.get(newOpp.PriceBook_Segment__c).Id;
         System.Debug('Adding PriceBook : ' + PriceBookMap.get(newOpp.PriceBook_Segment__c).Id);}
        } 
          
          
      }
    } 
      /************************************** Update Company Id ***************************************/  
      /******************** Add Child Opportunity_Loss_Approval__c records ****************************/
      else if (isUpdate) 
      {
      for (Opportunity newOpp : newList) 
      {
        //Check if Opportunity's Account Id has been changed
        if ( (newOpp.AccountId != mapOld.get(newOpp.Id).AccountId) ) 
        {
          //Update the Default Company on Opportunity for the new Account Id.
          if (CompanyMap.get(newOpp.AccountId) != null) 
          {
            System.Debug('Updating Company Id: ' + CompanyMap.get(newOpp.AccountId).Id);
            newOpp.Company__c = CompanyMap.get(newOpp.AccountId).Id;
          }
        }
       }
      }
  }

  /*
   * execute()
   * Purpose: Execute() calls executeBefore() if it is called in a Before trigger and executeAfter() if it is called in an After trigger.
   *          Triggers the records for Empower Transaction Creation for the Interfaces: CREATESOID, UPDATESOID, BLOCK/UNBLOCK SOID
   */

  public static void execute(List<Opportunity> newList, Map<Id, Opportunity> mapOld, boolean isInsert, boolean isUpdate , boolean isBefore , boolean isAfter)
  //Execute() calls executeBefore() if it is called in a Before trigger and executeAfter() if it is called in an After trigger.
  {
    System.Debug('Inside Execute() of OpportunityTriggerHandler');


    if (isBefore)
      OpportunityTriggerHandler.executeBefore(newList, mapOld, isInsert, isUpdate);
    if (isAfter)
      OpportunityTriggerHandler.executeAfter(newList, mapOld, isInsert, isUpdate);
      
   

    /* Code added by Himanshu */
    /* Purpose: For Empower Transaction Integration handling of CREATESOID, UPDATESOID, BLOCK/UNBLOCK SOID Interfaces. */
    if(isAfter && isUpdate)
      {
        //Flag to determine if "GenerateEmpowerTransactions.execute()" needs to be called
        Boolean Flag=false;
          for(Opportunity opp : newList)
              if(opp.Probability >= 30)
                Flag = true;
        if(Flag)
        {
          //Trigger the records for Empower Transaction Creation for the Interfaces: CREATESOID, UPDATESOID, BLOCK/UNBLOCK SOID
          GenerateEmpowerTransactions.execute(newList, mapOld, 'OPPORTUNITY');
          List<OpportunityLineItem> OLILIST = [Select Id, OpportunityID from OpportunityLineItem where OpportunityId in :newList];
          GenerateEmpowerTransactions.execute(OLILIST, mapOld, 'OpportunityLineItem');     
        }
      }

  }
}