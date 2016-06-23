/*
    * Name: MultimediaTriggerTest Class
    * Created On: April 11, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the MultimediaTrigger
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 11-04-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/
@isTest(seeAllData = false)
public without sharing class MultimediaTriggerTest {
    
     static testMethod void TestMultimediaTrigger()
    {
        List<user> u = TestDataFactory.createUsers();
        u[0].ManagerId = u[2].Id;
        update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
             
             EmpowerTransactionTest.CreateConfig();
             Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
        testacc.Market_Segment__c = 'SME A - COCP';
        testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
        testacc.Sub_Segment__c = 'SME A';
        testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
        insert testacc;
             
             Opportunity Opp1 = new Opportunity();
        Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
        Opp1.Name = 'Opty 1';
        Opp1.AccountId = testacc.Id;
        Opp1.CloseDate = System.Today().addMonths(1);
        Opp1.StageName = 'Identified' ;
        Opp1.Win_Reason__c = 'Fresh Requirement' ;
        Opp1.Channel_Type__c = 'Direct' ;
        Opp1.Lead_No__c = 'abc123' ;
        Opp1.Type = 'New';
        Opp1.SOID_Created_in_Empower__c=true;
        Opp1.Block_SOID__c = false;
        //Opp1.Company__c= c1.id;
        Opp1.Lead_Owner_User_Segment__c = 'B2B';
        insert Opp1;
             
             Contact c = new Contact();
        c.LastName = 'Random Contact';
        c.AccountId = testacc.id ;
        c.Role__c = 'IT' ;
        c.Business_Function__c = 'Finance';
        c.Email = 'contact@random.com' ;
        c.MobilePhone = '9899075612' ;
        insert c;
        
        OpportunityContactRole oppContact = new OpportunityContactRole() ;
        oppContact.OpportunityId = Opp1.id;
        oppContact.ContactId = c.Id;
        OppContact.Role = 'Decision Maker';
        insert oppContact;  
             
        Product2 p = new Product2();
        p.Name = 'DLC' ;
        p.fan_category__c = 'Wireline Voice' ;
        p.IsActive = true ;
        p.Domain_Expert__c = u[0].Id ;
        p.Product_Type__c = 'Non-Standard' ;
        p.Product_Group__c = 'MS' ;
        p.Family = 'Solutions' ;
        p.TTL_TCL__c = 'TTL' ;
        p.BD_Category__c = 'Enterprise Voice' ;
        insert p;
             
        PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=p.Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
        insert pbe1 ;
             
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe1.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
             
        opp1.StageName = 'Qualified';
        update opp1;
             
             Feasibility__c F3 = new Feasibility__c();
          //F3.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('FAN').getRecordTypeId() ;
          F3.Opportunity__c = Opp1.Id;
          F3.Contact_Mobile__c = '9955446622';
           F3.Product__C = p.id;
          //F3.Feasibility__c = F1.Id;
          insert F3 ;
             
             Drop__c d1 = new Drop__c();
             d1.Feasibility__c = F3.id;
             d1.Name ='1';
             d1.Circle__c = F3.Billing_Circle__c ;
             insert d1;
             
             F3.Number_of_Links_required__c =1;
             update F3;
             Multimedia__c m1 =new Multimedia__c();
             m1.Feasibility__c = F3.id;
             m1.Media_A__c = 'Copper';
             m1.Media_B__c = '';
             insert m1;
             
             m1.Create_Multi_Media_FAN__c = true;
             update m1;

            }
    }

}