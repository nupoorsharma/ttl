/*
    * Name: OpportunityTeamMemberTriggerHandler
    * Created On: March 4, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Trigger to
    *               a.) Prevent the creation of OpportunityTeamMember when the expert_role__c on user
    *			       does not match the TeamMemberRole if TeamMemberRole is in {Business Development/Domain Expert/Solution Architect}
    *               #Error Meassage in Custom Label : Opportunity_Team_Member_Role
    *			    b.) Throw an error at a deletion attempt for an autocreated OpportunityTeamMember. 
    *               #Error Message in Custom Label : You_cannot_delete_OTM
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 24-01-15 |Initial version of Trigger|
    * |------------------------------------------------------------|  
*/
public without sharing class OpportunityTeamMemberTriggerHandler {
    
    /*
     * execute() --- Called before insert, before delete.
     *               => Before Insert : Allow adding Team Members with the role Business Development/Solution Architect/Domain Expert
     *                                  only if Expert_Role__c on that User matches the Team Member Role
     *               => Before Delete : Block deletion of autocreated team members.
     */
    public static void execute(List<OpportunityTeamMember> newList, Map<Id, OpportunityTeamMember> oldMap, 
                               List<OpportunityTeamMember> oldList, Boolean IsInsert, Boolean IsDelete)
    {System.Debug('OpportunityTeamMemberTriggerHandler ----- Execute()');
        if(IsInsert)
        {//System.Debug('Isinsert');
         List<Id> userId = new List<Id>();
         for(OpportunityTeamMember otm : newList)
             userid.add(otm.userId);
         //Query the Expert Role on User    
         Map<Id, User> UserMap = new Map<Id, User>([Select Id, Expert_Role__c from User where Id in :userid]);
         //System.Debug(UserMap);
           for(OpportunityTeamMember otm : newList)
           { //System.Debug('User.ExpertRole: '+ UserMap.get(otm.UserId).Expert_Role__c);
            if(otm.Autocreated__c==false 
               && (otm.TeamMemberRole=='Business Development' || otm.TeamMemberRole=='Domain Expert' || otm.TeamMemberRole=='Solution Architect') 
               && UserMap.get(otm.UserId)!=null
               && otm.TeamMemberRole != UserMap.get(otm.UserId).Expert_Role__c )
               otm.addError(System.Label.Opportunity_Team_Member_Role);
            }    
        }
     
         if(IsDelete)
         {
             for(OpportunityTeamMember otm : oldList)
             {	//OTMDel__c is a Hierarchy Custom setting
                 OTMDel__c CS = OTMDel__c.getInstance(UserInfo.getUserId());
				 //System.Debug(cs.Allow_Deletion__c);
                 if( otm.Autocreated__c == true && cs.Allow_Deletion__c == false)
                     otm.addError(System.Label.You_cannot_delete_OTM);
             }
         }

    }

}