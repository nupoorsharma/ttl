/*
    * Name: LeadTriggerTest Class
    * Created On: November 23, 2015
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the LeadTrigger and LeadTriggerHandler.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 23-11-15 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
private class LeadTriggerTest {

    /** Test lead insertion **/
    static testMethod void insertLead() {
    List<user> u = TestDataFactory.createUsers();
	System.runAs(u[1])
    {System.debug('Current User: ' + UserInfo.getUserName());
    } 
        Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        insert testacc;
        //This account will be populated on Lead lookup field: Account__c
        List<Lead> insertlist = new List<lead>();
        //Stores all leads to be inserted.

        //Generate some leads with an associated account.
        
            Lead l = new lead();
            l.Lead_Type__c = 'Sharing Request';
            l.Region__c='North';
            l.Circle__c='Delhi';
            l.Status = 'New';
            l.email = 'abc1' +'@lead.com';
            l.MobilePhone = '9978986751';
            l.lastname = 'Lead from Dev 1';
            l.company = 'abcsjsdfh';
            l.account__c = testacc.id;
            //l.Convert_Lead__c = true;
            insertlist.add(l);
        
         //Generate a lead with an associated account and Type = 'existing'
         lead l2 = new lead();
            l2.lead_Type__c = 'Sharing Request';
            l2.Region__c='North';
            l2.Circle__c='Delhi';
            l2.Status = 'New';
            l2.email = 'abc1' +'@lead.com';
            l2.MobilePhone = '9978986751';
            l2.lastname = 'l2ead from Dev 1';
            l2.company = 'abcsjsdfh';
            l2.account__c = testacc.id;
            l2.Convert_lead__c = true;
            insert l2;
        
        
        
        lead l4 = new lead();
            l4.lead_Type__c = 'Sharing Request';
            l4.Region__c='North';
            l4.Circle__c='Delhi';
            l4.Status = 'New';
            l4.email = 'abc1' +'@lead.com';
            l4.MobilePhone = '9978986751';
            l4.lastname = 'l4ead from Dev 1';
            l4.company = 'Test Account';            
            l4.Convert_lead__c = true;
            insert l4;

        //Generate some leads with no account.
        
            Lead x = new lead();
            x.Lead_Type__c = 'New';
            x.Region__c='North';
            x.Circle__c='Delhi';
            x.Status = 'New';
            x.email = 'abc2' +'@lead.com';
            x.MobilePhone = '9878986752';
            x.lastname = 'Lead from Dev 2';
            x.company = 'abcsjdghdfgdfj';
            //l.Convert_Lead__c = true;
            insertlist.add(x);
        
        Lead y = new lead();
            y.Lead_Type__c = 'New';
            y.Region__c='North';
            y.Circle__c='Delhi';
            y.Status = 'New';
            y.email = 'abc2' +'@lead.com';
            y.MobilePhone = '9878986752';
            y.lastname = 'Lead from Dev 2';
            y.company = 'abcsjdghdfgdfj';
            //l.Convert_Lead__c = true;
            insertlist.add(y);

       

        insert insertlist;
        
        
        List<Id> generatedLeadID = new List<ID>();
        for (lead ld : insertlist)
        {	ld.Convert_Lead__c = true;
            generatedLeadID.add(ld.id);            
        }
        insertlist[2].lead_Type__c = 'Sharing Request';
        insertlist[2].company = 'Test Account';
		update insertlist;
        //Get all inserted leads.
        List<Lead> generatedLeads = new List<Lead>([Select Id, LastName, isConverted from Lead where Id in :generatedLeadID ]);
        for (lead lv : generatedLeads ) {
            //Validate that the leads have been converted by our trigger.
            //System.assertEquals(lv.isConverted, true);
            System.Debug('Lead :: lastNAme: \t' + lv.LAstName + '\t IsConverted : \t' + lv.isConverted);
        }
		
        Lead z = new lead();
            z.Lead_Type__c = 'New';
            z.Region__c='North';
            z.Circle__c='Delhi';
            z.Status = 'New';
            z.email = 'abc2' +'@lead.com';
            z.MobilePhone = '9878986752';
            z.lastname = 'Lead from Dev 2';
            z.company = 'My Duplicate Company';
            z.Convert_Lead__c = true;
            insert z;
        Test.startTest();
                
       System.runAs(u[0])
    {System.debug('Current User: ' + UserInfo.getUserName());
    
     lead l3 = new lead();
            l3.lead_Type__c = 'Existing';
            l3.Region__c='North';
            l3.Circle__c='Delhi';
            l3.Status = 'New';
            l3.email = 'abc1' +'@lead.com';
            l3.MobilePhone = '9978986751';
            l3.lastname = 'l3ead from Dev 1';
            l3.company = 'abcsjsdfh';
            l3.account__c = testacc.id;
            l3.Convert_lead__c = true;
            insert l3;
     
     lead l6 = new lead();
            l6.lead_Type__c = 'Existing';
            l6.Region__c='North';
            l6.Circle__c='Delhi';
            l6.Status = 'New';
            l6.email = 'abc1' +'@lead.com';
            l6.MobilePhone = '9978986751';
            l6.lastname = 'l6ead from Dev 1';
            l6.company = 'abcsjsdfh';
            l6.account__c = testacc.id;
            //l6.Convert_lead__c = true;
            insert l6;
     l6.ownerId = u[2].Id;
     update l6;
     l6.Convert_lead__c = true;
     update l6;
    }
    Test.stopTest();
    }


    /** Test lead update 
    static testMethod void updateLead() {
        Account testacc = new Account(Name = 'Test Account for update');
        insert testacc;
        //This account will be populated on Lead lookup field: Account__c

        List<Lead> insertlist = new List<lead>();
        //Stores all leads to be inserted.

        //Generate some leads with an associated account.
        for (integer i = 21; i < 26; i++) {
            Lead l = new lead();
            l.lastname = 'Lead from Dev ' + i;
            l.company = 'abc ' + i;
            l.account__c = testacc.id;
            insertlist.add(l);
        }
        //Generate some leads with no account.
        for (integer i = 26; i < 31; i++) {
            Lead l = new lead();
            l.lastname = 'Lead from Dev ' + i;
            l.company = 'abc ' + i;
            insertlist.add(l);
        }
        insert insertlist;
        List<Id> generatedLeadID = new List<ID>();
        for (lead l : insertlist)
            generatedLeadID.add(l.id);
        List<Lead> updatelist = [Select Id, Convert_Lead__c, isConverted from Lead where Id in :generatedLeadID  ];
        //Update these leads with Convert_Lead__c checkbox true
        for (lead l : updatelist)
            l.Convert_Lead__c = true;
        Test.startTest();

        update updatelist;
        //Get the Updated Leads
        List<Lead> updatedLeads = new List<Lead>([Select Id, LastName, Convert_Lead__c, isConverted from Lead where Id in :generatedLeadID]);
        for (lead l : updatedLeads ) {
            //Validate that all leads have been converted by our trigger
            System.assertEquals(l.isConverted, true);
            System.Debug('Lead :: lastNAme: \t' + l.LAstName + '\t IsConverted : \t' + l.isConverted);

        }

        Test.stopTest();
    }**/
}