@isTest
public class TestDataFactory {

  /*  public static testMethod void testRunAs() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
    }    */      
   @isTest 
   public static List<User> createUsers()
   {
       List<User> users = new List<User>();       
       Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       Profile p2 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User admin = new User(Alias = 'admin', Email='admin@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='admin', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_IN', ProfileId = p1.Id, By_Pass_Validations__c = true,
                            TimeZoneSidKey='Asia/Colombo', UserName='admin2122@testorg.com',
                            IsActive=True,
                            User_Category__c = 'Governance',
                            User_Segment__c = 'B2B',
                            Region__C= 'North',
                            Circle__c= 'Delhi');
       User business = new User(Alias = 'business', Email='business@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='business', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_IN', ProfileId = p1.Id, 
                            TimeZoneSidKey='Asia/Colombo', UserName='business2122@testorg.com',
                            IsActive=True,
                            User_Category__c = 'Sales',
                            User_Segment__c = 'B2B',
                            Region__C= 'North',
                            Circle__c= 'Delhi');
       User gov = new User(Alias = 'gov', Email='gov@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='admin', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_IN', ProfileId = p1.Id, 
                            TimeZoneSidKey='Asia/Colombo', UserName='gov2122@testorg.com',
                            IsActive=True,
                            User_Category__c = 'Governance',
                            User_Segment__c = 'B2B',
                            Region__C= 'Corporate',
                            Circle__c= 'Corporate');
       users.add(admin);
       users.add(business);
       users.add(gov);
       Insert Users;
       
        disableRules__c settings = disableRules__c.getOrgDefaults();
        settings.Disable_Validation_Rules__c = true;
        settings.Trigger_Objects__c = 'Account, Company__c, Lead, Opportunity, Contact, Feasibility__c, Business_Case__c, Purchase_Order__c, AV_CV__c, Drop__c, FAN_BC__c, Multimedia__c' ;
        upsert settings disableRules__c.Id;
       
       return Users;
   }
    
   @isTest(seeAllData = true)
    static void TestLeadAccountDuplicateChkController() 
    {
        List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
         
         Lead x = new lead();
                x.Lead_Type__c = 'New';
                x.Region__c='North';
                x.Circle__c='Delhi';
                x.Status = 'New';
                x.email = 'abc2' +'@lead.com';
                x.MobilePhone = '9878986752';
                x.lastname = 'XyzAbcMno';
                x.company = 'XyzAbcMno';
                //l.Convert_Lead__c = true;
                insert x;
         PageReference pageRef1 = Page.LeadAccountDuplicateCheck;
         Test.setCurrentPage(pageRef1);
         
         ApexPages.standardController stdcontroller1 = new ApexPages.standardController(x);
          
         LeadAccountDuplicateChkController controller1 = new LeadAccountDuplicateChkController(stdcontroller1);
         
         DuplicateRule DR = [SELECT Id, DeveloperName
                                from DuplicateRule 
                             where DeveloperName='Lead_Company_Name_Duplicate_Rule' Limit 1] ;
         
         DuplicateRecordSet DRS = [SELECT Id, DuplicateRuleID from DuplicateRecordSet 
                                  where DuplicateRuleID = :DR.Id Limit 1] ;
         
         DuplicateRecordItem DRI = new DuplicateRecordItem();
         DRI.RecordId = x.Id ;
         DRI.DuplicateRecordSetId = DRS.Id;
         insert DRI;
         
         PageReference pageRef = Page.LeadAccountDuplicateCheck;
         Test.setCurrentPage(pageRef);
         
         ApexPages.standardController stdcontroller = new ApexPages.standardController(x);
          
         LeadAccountDuplicateChkController controller = new LeadAccountDuplicateChkController(stdcontroller);
         
        
        } 
    }
    
   
    
    @isTest
    public static void ProductAsPDFControllerTest() {
        List<user> u = TestDataFactory.createUsers();
        u[0].ManagerId = u[2].Id;
        update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());

        Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
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
        
        ProductAsPDFController pap = new ProductAsPDFController();
        pap.setOppty(Opp1);
        pap.getOppty();
        pap.getContacts();
        
        OpportunityContactRole oppContact = new OpportunityContactRole() ;
        oppContact.OpportunityId = Opp1.id;
        oppContact.ContactId = c.Id;
        OppContact.Role = 'Decision Maker';
        insert oppContact;
        
        pap.getContacts();
        
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
    
        PricebookEntry pbe = new PricebookEntry(unitprice=0.00,Product2Id=p.Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
        insert pbe ;
        
        pap.getProduct();
        
        
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
        
        pap.getProduct();
        
        }
    }
}