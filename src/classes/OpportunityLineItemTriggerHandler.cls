/*
    * Name: OpportunityLineItemTriggerHandler Class
    * Created On: November 24, 2015
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the OpportunityLineItemTrigger, OpportunityLineItemTriggerHandler is used to
    *              a.) Add Opportunity Team Members with the role 'Business Development' and access level -'Edit'
    *              b.) Add Opportunity Team Members with the role 'Domain Expert' and access level 'Read'. These members should auto-follow the opportunity on Chatter.
    *              c.) Add the Solution Architects as Opportunity Team Members with 'Edit' access level; Based upon the Cluster Head(Manager) associated to Opportunity Owner.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 24-11-15 |Initial version of Class  |
    * |------------------------------------------------------------|    

*/

public without sharing class OpportunityLineItemTriggerHandler{
    
       
    /*
     * createTeamMember() is used to create an Opportunity Team Member object with the specified opp Id, user Id and team member role.
     */
    public OpportunityTeamMember createTeamMember(ID OpportunityID, ID UserID, String TeamMemberRole )
     {
         OpportunityTeamMember TeamMember = new OpportunityTeamMember();
           TeamMember.OpportunityId =   OpportunityID ;
           TeamMember.UserId = UserID;
           TeamMember.TeamMemberRole = TeamMemberRole;
           TeamMember.AutoCreated__c = true;
           TeamMember.Key__c = OpportunityID + '~' + UserID;
           return TeamMember;
     }

   /*
    *execute() is used to add the user Domain_Expert__c on Product2 as an Opportunity Team Member.
    *Business_Development__c Users (from BD_Mapping__c) are added with the role 'Business Development' and access level 'Edit'.
    *Domain_Expert__c (from Product2) is added with the role 'Domain Expert' and access level 'Read'. This user should auto-follow the opportunity.
    *Used to add Solution Architects to Opportunity Team with 'Edit' access level (from ClusterHead-SA Mapping).
    */
    

  public static void execute(List<OpportunityLineItem> newList)
  //Execute() contains the logic to associate a Company to an Opporrunity based on Opportunity's AccountId.
  {
    
    //Collects the Opportunity Id on new OpportunityLineItems, used to query OpportunityShare.
    List<ID> OpportunityID = new List<ID>();
    //Stores the UserId on Opportunity Team Member  with 'Business Development' or 'Solution Architect' role so that their access level can be changed to 'Edit'
    Map<ID, String> UserAccessLevel = new Map<ID , String>();
    //Stores the list of Opportunity Team Members to be added to the opportunity team.
    List<OpportunityTeamMember> TeamList = new List<OpportunityTeamMember>();
    //Stores the list of EntitySubscription objects to make 'Domain Experts' auto-follow the Opportunity on Chatter.
    List<EntitySubscription> FollowList = new List<EntitySubscription>();
     //Collects the Id on all OpportunityLineItems in Trigger.new
    List<ID> OLI_ID = new List<ID>();
      //Collects the Keys to query BD_Mapping__c
    List<String> BD_Key = new List<String>();
      //Maps a key to the corresponding list of BD Users
    Map<String, LIST<ID>> BDMap = new Map<String, LIST<ID>>();
       //Collect the OwnerID on opportunities to query Cluster Heads.
    List<ID> OpportunityOwnerID = new List<ID>();
      //Map to store owner Id and cluster head id
    Map<ID, ID> OpportunityOwnerMap = new Map<ID, ID>();
    //Stores a list of Solution architect IDs corresponding to a Cluster Head Id
    Map<Id, List<ID>> ClusterHeadSAMap = new Map<Id, List<ID>>();

    for(OpportunityLineItem obj : newList)
        {
         OpportunityID.add(obj.OpportunityId); 
         OLI_ID.add(obj.Id);
        }
   //Collect the details of those Opportunity Line Items which have an Active Product.
  List<OpportunityLineItem> OLIExtended = new List<OpportunityLineItem>([Select Id, Solution_Type__c, Product2Id, Product2.Name, Product2.IsActive, Product2.Product_Group__c, Product2.BD_Category__c, Product2.Domain_Expert__c, Product2.Domain_Expert__r.IsActive , Product2.Product_Type__c, Opportunity.Name, Opportunity.OwnerID, Opportunity.Owner.Region__C 
                                                                           from OpportunityLineItem 
                                                                           where ID in :OLI_ID and Product2.IsActive=true ]);
   
   //Collect the Keys (BD Category~Owner Region) to query BD Mapping
  for(OpportunityLineItem OLI: OLIExtended)
  {
      if( !String.IsEmpty(OLI.Product2.BD_Category__c) && !String.IsEmpty( OLI.Opportunity.Owner.Region__C ) )
         BD_Key.Add( OLI.Product2.BD_Category__c+'~'+OLI.Opportunity.Owner.Region__C) ;
      OpportunityOwnerID.add(OLI.Opportunity.OwnerId);
  }
      
      //Get the Opportunity Owners' Managers if the Manager is Active
    List<User> OpportunityOwnerList = new List<User>([Select Id, Name, IsActive, ManagerId ,  Manager.IsActive
                                                        from User
                                                        where ID in :OpportunityOwnerID and IsActive = true and Manager.IsActive = true]);


     
    //Collect the ID of Cluster Heads(Managers) to query ClusterHead_SA_Mapping records.
    List<ID> ClusterHeadList = new List<ID>();
    for (User u : OpportunityOwnerList) {
        //Map Opportunity owner Id as key and Owner's ManagerId as value.
      OpportunityOwnerMap.put( u.Id, u.ManagerId);
      if ( !String.IsEmpty(u.ManagerId) )
        ClusterHeadList.add(u.ManagerId);
    }

    //Collect all records from ClusterHead_SA_Mapping__c object where Cluster Head ID is from our ClusterHeadList
    List<ClusterHead_SA_Mapping__c> SolutionArchitectList = new List<ClusterHead_SA_Mapping__c>([Select Id, Name, key__c, cluster_Head__c , solution_architect__c , solution_architect__r.IsActive, active__c
                                                                                                from ClusterHead_SA_Mapping__c
                                                                                               where active__c = true and solution_architect__r.IsActive = true and cluster_Head__c in :ClusterHeadList]);
   System.Debug(LoggingLevel.DEBUG, 'SolutionArchitectList' + SolutionArchitectList);
   System.Debug(LoggingLevel.DEBUG, 'ClusterHeadList'+ClusterHeadList); 
  //Map the Manager Id as key and List of Active Solution Architects as value. This list has to be added as Opportunity Team.
    for ( ID CH : ClusterHeadList) {
      //List to store the Solution Architects listed against a Cluster Head(Manager)
      List<ID> SAList = new List<ID>();
      for (ClusterHead_SA_Mapping__c map1 : SolutionArchitectList) {
        if (map1.cluster_Head__c == CH) {
          SAList.add(map1.solution_architect__c );
        }
      }
      //If the list of Solution Architects contains some IDs, populate entry in the Map
      if ( SAList.size() > 0 )
        ClusterHeadSAMap.put(ch, SAList);
    }
	/*
    System.debug('=== ClusterHead - Solution Architect Map Ultimately =====');
    // keySet() returns a Set we can iterate through
    for (Id id1 : ClusterHeadSAMap.keySet()) {
      System.debug('=== ' + id1 + '===' + ClusterHeadSAMap.get(id1));
    }*/
      
      //Collect all Active BD_Mapping__c records which have a Key from BD_Key
      List<BD_Mapping__c> BDList = new List<BD_Mapping__c>([Select Id, Active__c, Region__c, BD_Category__c, Business_Development__c, Business_Development__r.IsActive, key__c
                                                           from BD_Mapping__c
                                                           where key__c in :BD_Key and Active__c=true]);
      //Map Key for BD Mapping as key and List of BD User IDs as value.
      for(String key : BD_Key)
      { //List to contain all Business Development users listed against a key(BD Category~Owner Region).
        List<ID> BDUsers = new List<ID>();
          for(BD_Mapping__c BDM : BDList)
          {
             if(BDM.Key__c == key)
                 //Add a User ID only if the user is active.
             if( !String.IsEmpty(BDM.Business_Development__c) && (BDM.Business_Development__r.IsActive == true) )
                  BDUsers.add(BDM.Business_Development__c);
           
          }
       //Add key and List of BD Users as the value.
       if( BDUsers.size()>0 )
          BDMap.put(key , BDUsers );
       
      }
      
     for(OpportunityLineItem OLI: OLIExtended)
     {        
          //If there is a Business Development User available on  (BD Category~Owner Region) that user is Active
          // and Product_Type__c on Product2 is "Non Standard", add the list of BD Users as Opportunity Team Members.
         if(OLI.Product2.Product_Type__c == 'Non-Standard') 
         {    
             if( !String.IsEmpty(OLI.Product2.BD_Category__C) && !String.IsEmpty( OLI.Opportunity.Owner.Region__C )  )
              {
                  //If some BD users are found for the given Key, Add them as Opportunity Team Members.
                  if( BDMap.get(OLI.Product2.BD_Category__c+'~'+OLI.Opportunity.Owner.Region__C) != null )
                  {  LIST<ID> BD_ID = BDMap.get(OLI.Product2.BD_Category__c+'~'+OLI.Opportunity.Owner.Region__C);
                       for(ID BusinessDevID : BD_ID )
                       {
                          //---------> System.Debug('Business Developer');
                           TeamList.add( new OpportunityLineItemTriggerHandler().createTeamMember( OLI.OpportunityId,
                                                                                                       BusinessDevID,
                                                                                           'Business Development') );
                          //The Access Level of these users should be reset to "Edit"
                           UserAccessLevel.put( BusinessDevID, 'Edit');
                       }
                  }
              }
         }
         
         //If there is a Domain_Expert__c User populated on the Product2 and that user is Active
         if( !String.IsEmpty(OLI.Product2.Domain_Expert__c) && (OLI.Product2.Domain_Expert__r.IsActive = true) )
         {
          //---------> System.Debug('Domain Expert');
         //Add the Domain_Expert__c user to the opportunity team.
         TeamList.add( new OpportunityLineItemTriggerHandler().createTeamMember( OLI.OpportunityId,
                                                                                   OLI.Product2.Domain_Expert__c,
                                                                                   'Domain Expert') );
         //Make the 'Domain expert' follow the opportunity.
         EntitySubscription follow = new EntitySubscription();
         follow.parentId = OLI.OpportunityId ;
         follow.subscriberid = OLI.Product2.Domain_Expert__c;   
         FollowList.add(follow);   
         }
         
		  //If there is an Active ClusterHead-SA Mapping for this opportunity's owner
          //and Solution_Type__c on OLI is "Complex", add the list of SA Users as Opportunity Team Members.         
         if(OLI.Solution_Type__c == 'Complex')
         {  //If there is a ManagerId populated on Opportunity Owner
            if ( OpportunityOwnerMap.get(OLI.Opportunity.OwnerId) != null ) 
            {//ClusterHead is the Manager
              ID ClusterHead = OpportunityOwnerMap.get(OLI.Opportunity.OwnerId);
                //If some active Solution Architects are found corresponding to the Manager, add them as Opportunity Team members
              if ( ClusterHeadSAMap.get(ClusterHead) != null ) 
              { //List of IDs of active Solution Architects.
                List<ID> SAList = ClusterHeadSAMap.get(ClusterHead);
                for (ID SAID : SAList) {
                  //Add Solution Architect to be inserted as an opportunity Team Member
                  TeamList.add( new OpportunityLineItemTriggerHandler().createTeamMember( OLI.OpportunityId,
                                                                                                       SAID,
                                                                                           'Solution Architect') );
                 //The Access Level of these users should be reset to "Edit"
                 UserAccessLevel.put( SAID, 'Edit');
                }
              }
            }
         }
         
     }
    
   try{
        //Add the Team Members present in the list TeamList
       if( TeamList.size() > 0)
       Database.UpsertResult[] upsertResult = Database.upsert(TeamList, OpportunityTeamMember.Fields.Key__c, false); 
       //Make the Domain Expert Users follow the Opportunity.
       if( FollowList.size() > 0)
       Database.SaveResult[] savList = Database.insert(FollowList, false);

       }
   catch (DmlException e) 
        {System.Debug(LoggingLevel.ERROR, 'Error has occured!');
         System.Debug(LoggingLevel.ERROR, e.getMessage());
        }
    //Adjust the access level on opportunity team members with the role 'Business development' to 'Edit'.
    if( UserAccessLevel.size() > 0 )
    {   //Query Opportunity Share for Opportunity Team Members
        List<OpportunityShare> shares = [select Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause
                                       from OpportunityShare where RowCause='Team' and OpportunityId in :OpportunityID];
        // set team members access
        for (OpportunityShare share : shares) 
        {   //If the user requires "Edit" access, reset the OpportunityAccessLevel on OpportunityShare
            if( UserAccessLevel.get(share.UserOrGroupId) != null)
            share.OpportunityAccessLevel = 'Edit';
        }
        update shares;
    }
      
  }
    
}