@isTest
public class BusinessClassInterfaceTest {
    static Opportunity Opp1;
    static Opportunity opp2;
    static Opportunity opp3;
    static Account testacc;
    static Company__C c1;
    static Product2 p;
    Static Feasibility__C F;
    static List<Product2> ProductList;
    static List<Opportunity> oppList;
    static List<OpportunityContactRole> opptyConList;
    
    
    @isTest(seeAllData = false)
    static void prepareTestData() {
        
       List<user> u = TestDataFactory.createUsers();
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
				EmpowerTransactionTest.CreateConfig();
             
			testacc = new Account(Name = 'Test Account');
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
                 

            oppList = new List<Opportunity>();
             
            Opp1= new Opportunity();
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
             
            oppList.add(opp1);
             
            Opp2= new Opportunity();
            Opp2.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
            Opp2.Name = 'Opty 1';
            Opp2.AccountId = testacc.Id;
            Opp2.CloseDate = System.Today().addMonths(1);
            Opp2.StageName = 'Identified' ;
            Opp2.Win_Reason__c = 'Fresh Requirement' ;
            Opp2.Channel_Type__c = 'Direct' ;
            Opp2.Lead_No__c = 'abc123' ;
            Opp2.Type = 'New';
            Opp2.SOID_Created_in_Empower__c=true;
            Opp2.Block_SOID__c = false;
            //Opp1.Company__c= c1.id;
            Opp2.Lead_Owner_User_Segment__c = 'B2B';
             
            oppList.add(opp2);
             
            Opp3 = new Opportunity();
            Opp3.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
            Opp3.Name = 'Opty 1';
            Opp3.AccountId = testacc.Id;
            Opp3.CloseDate = System.Today().addMonths(1);
            Opp3.StageName = 'Identified' ;
            Opp3.Win_Reason__c = 'Fresh Requirement' ;
            Opp3.Channel_Type__c = 'Direct' ;
            Opp3.Lead_No__c = 'abc123' ;
            Opp3.Type = 'New';
            Opp3.SOID_Created_in_Empower__c=true;
            Opp3.Block_SOID__c = false;
            //Opp1.Company__c= c1.id;
            Opp3.Lead_Owner_User_Segment__c = 'B2B';
             
            oppList.add(opp3);
             
            insert oppList;
                 
                 
            Contact c = new Contact();
            c.LastName = 'Random Contact';
            c.AccountId = testacc.id ;
            c.Role__c = 'IT' ;
            c.Business_Function__c = 'Finance';
            c.Email = 'contact@random.com' ;
            c.MobilePhone = '9899075612' ;
            insert c;
            
             opptyConList = new List<OpportunityContactRole>();
             
            OpportunityContactRole oppContact1 = new OpportunityContactRole() ;
            oppContact1.OpportunityId = Opp1.id;
            oppContact1.ContactId = c.Id;
            OppContact1.Role = 'Decision Maker';
            opptyConList.add(OppContact1);
             
             
            OpportunityContactRole oppContact2 = new OpportunityContactRole() ;
            oppContact2.OpportunityId = Opp2.id;
            oppContact2.ContactId = c.Id;
            OppContact2.Role = 'Decision Maker';
            opptyConList.add(OppContact2);
             
            OpportunityContactRole oppContact3 = new OpportunityContactRole() ;
            oppContact3.OpportunityId = Opp3.id;
            oppContact3.ContactId = c.Id;
            OppContact3.Role = 'Decision Maker';
            opptyConList.add(OppContact3);
             
            insert opptyConList;
             
            ProductList = new List<Product2>();
            Product2 P1 = new Product2();
            P1.Name = 'DLC';
            P1.Bc_category__c = 'DLC';
            p1.AVCV_Process_Applicable__c = true;
            p1.PO_Process_Applicable__c= true;
            ProductList.add(P1);
             
            Product2 p2 = new Product2();
            p2.Name= 'Wireline voice';
            p2.BC_Category__c= 'Wireline'; 
            ProductList.add(p2);
             
            Product2 p3 = new Product2();
            p3.Name = '3G Dongle';
            p3.BC_Category__c = '3GDongle';
            ProductList.add(p3);

            Insert ProductList;
             
             List<PricebookEntry> peList = new List<PricebookEntry>();
              PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=ProductList[0].Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
             	peList.add(pbe1);
              PricebookEntry pbe2 = new PricebookEntry(unitprice=0.00,Product2Id=ProductList[1].Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
             	peList.add(pbe2); 
             PricebookEntry pbe3 = new PricebookEntry(unitprice=0.00,Product2Id=ProductList[2].Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
                peList.add(pbe3);
             
             insert peList ;
          
            List<OpportunityLineItem> lineItemList = new  List<OpportunityLineItem>();
             
            OpportunityLineItem OppLine1 = new OpportunityLineItem();
            OppLine1.OpportunityID = opp1.Id ;
            OppLine1.PriceBookEntryId = peList[0].id ;
            OppLine1.Solution_Type__c = 'Complex' ;
            OppLine1.Quantity = 10 ;
             
             lineItemList.add(OppLine1);
             
            OpportunityLineItem OppLine2 = new OpportunityLineItem();
            OppLine2.OpportunityID = opp2.Id ;
            OppLine2.PriceBookEntryId = pbe2.Id ;
            OppLine2.Solution_Type__c = 'Complex' ;
            OppLine2.Quantity = 10 ;
             
             lineItemList.add(OppLine2);
             
            OpportunityLineItem OppLine3 = new OpportunityLineItem();
            OppLine3.OpportunityID = opp3.Id ;
            OppLine3.PriceBookEntryId = pbe3.Id ;
            OppLine3.Solution_Type__c = 'Complex' ;
            OppLine3.Quantity = 10 ;
             
             lineItemList.add(OppLine3);
             
            insert lineItemList; 
             
             List<Opportunity> updateStageList = new List<Opportunity>();
             
             opp1.StageName = 'Verbal Agreement';
             updateStageList.add(opp1);
              opp2.StageName = 'Qualified';
             updateStageList.add(opp2);
              opp3.StageName = 'Qualified';
             updateStageList.add(opp3);
             
            update updateStageList;

             
             
            }
    }
    
    
    testmethod public static void testcase() {
        System.debug('Inside BC Test class test method, before data prepare...');
        prepareTestData();
        System.debug('Inside BC Test class test method, after data prepare...');
        
        List<Business_case__c> bcList = new List<Business_case__c>();
        
        Business_Case__c bc1 = new Business_Case__c(Opportunity__c = oppList[0].id, product__c= productList[0].id);
        bcList.add(bc1);
         Business_Case__c bc2 = new Business_Case__c(Opportunity__c = oppList[1].id, product__c= productList[1].id);
        bcList.add(bc2);
         Business_Case__c bc3 = new Business_Case__c(Opportunity__c = oppList[2].id, product__c= productList[2].id);
        bcList.add(bc3);
        
        insert bcList;
        
        System.debug('bcList-------------'+bcList);
        
        List<Fan_BC__c> fbList = new List<Fan_BC__c>();
        
        Fan_BC__c fb1 = new Fan_BC__c(Business_Case__c = bcList[0].id, External_ID__c='abc', record_edited__c= true);
        fbList.add(fb1);
        
        Fan_BC__c fb2 = new Fan_BC__c(Business_Case__c = bcList[1].id,External_ID__c='pqr', record_edited__c= true);
        fbList.add(fb2);
           
        Database.insert(fbList); 
        
        System.debug('fblist----------'+fbList);
        
        Cpe_details__c cpe = new Cpe_details__c(fan_bc__c = fb1.Id, Is_CPE_Required__c='No');
        insert cpe;
          
        
        RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='BusinessCase',name ='BusinessCase' , Endpoint__c = 'http://bc', Active__c = true, Immediate_execution__c = true);
        insert rec;
        
        BusinessCaseInterface.Endpoint = rec;
 
        RecursionControl.BCrunAfter = true;
        
        List<Business_case__c> updateBCList = new List<Business_case__c>();
        for(Business_case__c bc: bcList){
            System.debug('bc------'+bc);
            bc.submit_bc__c = true;
            bc.Approval_Status__c = 'Approved';
            updateBCList.add(bc);
                            
        }
        
        update updateBCList;
        System.debug('updateBCList----------'+updateBCList);
        
        
        RecursionControl.POrunOnceBefore();
        RecursionControl.POrunOnceBefore();
        RecursionControl.POrunOnceAfter();
        RecursionControl.POrunOnceAfter();
        RecursionControl.BQrunOnce();
        RecursionControl.BQrunOnce();
        RecursionControl.AVCVrunOnceAfter();
        RecursionControl.AVCVrunOnceAfter();
        RecursionControl.AVCVrunOnceBefore();
        RecursionControl.AVCVrunOnceBefore();
        RecursionControl.FeasibilityrunOnceAfter();
        RecursionControl.FeasibilityrunOnceAfter();
        RecursionControl.FeasibilityrunOnceBefore();
         RecursionControl.FeasibilityrunOnceBefore();
       
        

    }
}