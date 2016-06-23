/*
    * Name: MassEditFeasibilityDropsController Class
    * Created On: March 19, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Extension for Visualforce Page MassEditFeasibilityDrops
    *              Called From: "Mass Edit Drops" button on Feasibility__c.
    *              Purpose : Allows user to mass edit all Drop__c records related to a Feasibility__c.                            
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 19-03-16 |Initial version of Class  |
    * |------------------------------------------------------------|
*/
public without sharing class MassEditFeasibilityDropsController {
    //The list that will be rendered on the page.
    public List<Drop__c> DropList{get;set;}
    //PageBlockTable is rendered based on this variable.
    public Boolean show{get;set;}
    
    public MassEditFeasibilityDropsController(ApexPages.StandardController controller)
    {
    System.Debug('VisualForce Page MassEditFeasibilityDrops :: ' + ApexPages.CurrentPage().getURL());
    DropList=new List<Drop__c>([Select Id, Name, Circle__c, City__c, Pincode_New__c, Address_Line1__c, Address_Line2__c, Address_Line3__c
                               from Drop__c where Feasibility__c = :ApexPages.CurrentPage().getparameters().get('id') and Auto_Created__c=false]);
    show = (DropList.size()>0 ? true : false);
    }
    
    //Saves all updates on the Drop__c records and redirects to the parent Feasibility__c record.
    public PageReference updateDrops()
    {
        try
        {
            update DropList;
        }
         catch(Exception ex)
            {System.Debug('An Exception has occurred. ' +ex);
             ApexPages.addMessages(ex);
            }
        //If any Errors occur up, stay on the same page, otherwise redirect page.
        if (ApexPages.hasMessages()) 
          //Refresh the page to show any errors.
          return null;
        else
          return new PageReference('/'+ApexPages.CurrentPage().getparameters().get('id'));  
    }
}