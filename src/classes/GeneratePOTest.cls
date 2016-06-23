/*
    * Name: GeneratePOTest Class
    * Created On: June 4, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the VF Controller - GeneratePOController
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 06-04-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
public without sharing class GeneratePOTest {
    
    static testMethod void TestGeneratePO()
    {
        List<user> u = TestDataFactory.createUsers();
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
             Test.startTest();
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
            testacc.Logo_Status__c = 'Verified';
            insert testacc;
             
            Opportunity Opp1= new Opportunity();
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
        p.PO_Process_Applicable__c=true;
        p.AVCV_Process_Applicable__c =true;
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
             
        Business_Case__c bc1 = new Business_Case__c(Opportunity__c = opp1.id, product__c= p.id, Approval_Status__c='Approved');
        insert bc1;
             
        Fan_BC__c fb1 = new Fan_BC__c(Business_Case__c = bc1.id, External_ID__c='abc', record_edited__c= true);
        insert fb1;
             
             p.PO_Process_Applicable__c=false;
             update p;
             
             PageReference pageRef3 = Page.GeneratePO;
             Test.setCurrentPage(pageRef3);
             ApexPages.standardController stdcontrollerDrop3 = new ApexPages.standardController(bc1);
             ApexPages.currentPage().getParameters().put('id', bc1.id);
             GeneratePOController controllerX3 = new GeneratePOController(stdcontrollerDrop3);
             controllerX3.Redirect();
             
             p.PO_Process_Applicable__c=true;
             p.AVCV_Process_Applicable__c =false;
             update p;
             
             PageReference pageRef4 = Page.GeneratePO;
             Test.setCurrentPage(pageRef4);
             ApexPages.standardController stdcontrollerDrop4 = new ApexPages.standardController(bc1);
             ApexPages.currentPage().getParameters().put('id', bc1.id);
             GeneratePOController controllerX4 = new GeneratePOController(stdcontrollerDrop4);
             controllerX4.Redirect();
             
             p.AVCV_Process_Applicable__c =true;
             p.PO_Process_Applicable__c=true;
             update p;
             
             PageReference pageRef = Page.GeneratePO;
             Test.setCurrentPage(pageRef);
             ApexPages.standardController stdcontrollerDrop = new ApexPages.standardController(bc1);
             ApexPages.currentPage().getParameters().put('id', bc1.id);
             GeneratePOController controllerX = new GeneratePOController(stdcontrollerDrop);
             controllerX.Redirect();
             
             PageReference pageRef2 = Page.GeneratePO;
             Test.setCurrentPage(pageRef2);
             ApexPages.standardController stdcontrollerDrop2 = new ApexPages.standardController(bc1);
             ApexPages.currentPage().getParameters().put('id', bc1.id);
             GeneratePOController controllerX2 = new GeneratePOController(stdcontrollerDrop2);
             controllerX2.Redirect();
             
            
             
             Test.stopTest();
            }
    }
}