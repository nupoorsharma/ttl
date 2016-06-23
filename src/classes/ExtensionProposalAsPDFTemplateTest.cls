@isTest
public class ExtensionProposalAsPDFTemplateTest {
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
    
   @isTest
    static void prepareData(){
        List<user> u = TestDataFactory.createUsers();
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
                EmpowerTransactionTest.CreateConfig();
             
            testacc = new Account(Name = 'Test Account');
             System.debug('testacc---'+testacc);
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
            OppContact1.IsPrimary= true;
            opptyConList.add(OppContact1);
             
             
            OpportunityContactRole oppContact2 = new OpportunityContactRole() ;
            oppContact2.OpportunityId = Opp2.id;
            oppContact2.ContactId = c.Id;
            OppContact2.Role = 'Decision Maker';
            OppContact2.IsPrimary= true;
            opptyConList.add(OppContact2);
             
            OpportunityContactRole oppContact3 = new OpportunityContactRole() ;
            oppContact3.OpportunityId = Opp3.id;
            oppContact3.ContactId = c.Id;
            OppContact3.Role = 'Decision Maker';
            OppContact3.IsPrimary= true;
            opptyConList.add(OppContact3);
             
            insert opptyConList;
             
            StaticResource s = [select id from StaticResource where name = 'DocomoLogo'];
            
            ProductList = new List<Product2>();
            Product2 P1 = new Product2();
            P1.Name = 'DLC';
            P1.Bc_category__c = 'DLC';
          //  p1.Document_ID__c = s.Id;
            ProductList.add(P1);
             
            Product2 p2 = new Product2();
            p2.Name= 'Wireline voice';
            p2.BC_Category__c= 'Wireline'; 
            p2.Document_ID__c = s.Id;
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
             
            PDFGlobalVariables__c var = new PDFGlobalVariables__c(Name='Default', EmailTemplateID__c= '12345');
            insert var;
             
            PageReference pageRef = Page.ProposalAsPDFTemplate;
            pageRef.getParameters().put('id',opp1.Id);
            Test.setCurrentPageReference(pageref);
        
            ApexPages.standardController stdcontroller = new ApexPages.standardController(Opp1);
            ExtensionProposalAsPDFTemplate controller = new  ExtensionProposalAsPDFTemplate(stdcontroller);
            controller.sendEmail();
            controller.cancel();
             
            PageReference pageRef2 = Page.ProposalAsPDFTemplate;
            pageRef2.getParameters().put('id',opp2.Id);
            Test.setCurrentPageReference(pageref2);
           
            ApexPages.standardController stdcontroller2 = new ApexPages.standardController(Opp2);
            ExtensionProposalAsPDFTemplate controller2 = new ExtensionProposalAsPDFTemplate(stdcontroller2);
            controller2.sendEmail();
             
            }
        
    }
    
  /*  testmethod public static void testcase(){
        
        String url = '/apex/ProposalAsPDF?id='+Opp1.Id;
        PageReference pageref = new PageReference(url);
        Test.setCurrentPageReference(pageref);
        
        ApexPages.standardController stdcontroller = new ApexPages.standardController(Opp1);
         ExtensionProposalAsPDFTemplate controller = new  ExtensionProposalAsPDFTemplate(stdcontroller);
        
        
        
    }*/
    
    
    

}