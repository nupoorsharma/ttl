/*
    * Name: OpportunityClonerTest Class
    * Created On: March 25, 2016.
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the CloneOpportunity VF and OpportunityCloner class.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 25-03-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
private class OpportunityClonerTest {

    /** Test lead insertion **/
    static testMethod void TestOpportunityCloner() {
    List<user> u = TestDataFactory.createUsers();
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
        testacc.Logo_Status__c = 'Non-Verified';        
        insert testacc;
     
     
     Contact c = new Contact();
        c.LastName = 'Random Contact';
        c.AccountId = testacc.id ;
        c.Role__c = 'Chief Financial Officer' ;
        c.Business_Function__c = 'Finance';
        c.Email = 'contact@random.com' ;
        c.MobilePhone = '9899075612' ;
        insert c;
     
     Product2 p = new Product2();
        p.Name = 'Photon' ;
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
     
     Opportunity Opp1 = new Opportunity();
        Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
        Opp1.Name = 'Opty 1';
        Opp1.AccountId = testacc.Id;
        Opp1.CloseDate = System.Today().addMonths(1);
        Opp1.StageName = 'Identified' ;
        Opp1.Win_Reason__c = 'Fresh Requirement' ;
        Opp1.Channel_Type__c = 'Direct' ;
        Opp1.Lead_No__c = 'abc123' ;
        Opp1.Lead_Owner_User_Segment__c = 'B2B';
        Opp1.SOID_Created_in_Empower__c=true;
        insert Opp1;
      
        
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe1.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
     
      OpportunityContactRole oppContact = new OpportunityContactRole() ;
        oppContact.OpportunityId = Opp1.id;
        oppContact.ContactId = c.Id;
        OppContact.Role = 'Decision Maker';
        insert oppContact;
     
     Opp1.StageName = 'Qualified';
     update Opp1;
     
     Feasibility__c F1 = new Feasibility__c();
          //F1.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('DLC-New').getRecordTypeId() ;
          F1.Opportunity__c = Opp1.Id;
          F1.Contact_Mobile__c = '9955446622';
          F1.Submit_to_AMT__c = true;
          F1.Product__C = p.id;
          insert F1 ; 
     
     Feasibility_Status__C fs1 = new Feasibility_Status__C();
             fs1.Feasibility__C = F1.id ;
             //fs1.Status__C = 'Feasible' ;
             insert fs1;
      F1.Feasibility_Status__c = fs1.id;
     update F1;
     Drop__c d = new Drop__c();
     d.Feasibility__c= F1.id;
     insert d;
     
        List<ID> opp = new List<ID>(); 
        opp.add(Opp1.id);
        List<Opportunity> xyz = OpportunityCloner.cloneOpportunity(opp,False);
        System.Debug(xyz);
     OpportunityCloner.cloneSingular(String.ValueOf(Opp1.id), 'false');
     
     
     /*SME_OrderValueBackUpdation__c sme = new SME_OrderValueBackUpdation__c();
     sme.OpportunityID__c = Opp1.id;*/
     

    } 
    }
}