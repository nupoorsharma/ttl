@isTest
public class AVCVInterfaceTest {
    testmethod public static void testcase() {
        EmpowerTransactionTest.CreateConfig();
        prepareTestData();
        RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='Feasibility',name ='Feasibility' , Endpoint__c = '', Active__c = true);
        insert rec;
        
        AVCVInterface.endpoint = rec;
        AVCVInterface.initializeJSOn_Field_Map();
        
        AV_CV__c av= new AV_CV__c(Opportunity__c = Opp1.id);
        av.CAF_No__c = 'abc';
        av.Parent_CAF_No__c = 'xyz';
        av.NLD_CAF_No__c = 'pqr' ;
        av.Point_B_CAF_No__c = 'mno'; 
        av.Point_CAF_No__c = 'ghi';
        av.CAF_Date__c = System.Today();
        insert av;
        
        AVCVInterface.executeQuery(new List<sObject>{av});
        AVCVInterface.CreateJSON(new List<sObject>{av});
        Map<Id, AV_CV__c> oldmap = new Map<Id, AV_CV__c>();
        oldmap.put(av.id, av);
        av.CAF_No__c = 'omg';
        av.Parent_CAF_No__c = 'omg';
        av.NLD_CAF_No__c = 'omg' ;
        av.Point_B_CAF_No__c = 'omg'; 
        av.Point_CAF_No__c = 'omg';
        update av;
        EPOSInterface.checkAllCAFNoChangeOnBeforeUpdate(new List<sObject>{av}, oldMap);
        EPOSInterface.checkAllCAFNoChangeOnAfterUpdate(new List<sObject>{av}, oldMap);
    }
    
    static Opportunity Opp1;
    static void prepareTestData() {
        List<user> u = TestDataFactory.createUsers();
        u[0].ManagerId = u[2].Id;
        update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());

         Account testacc = new Account(Name = 'Test Account');
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
            insert Opp1;
           
          Contact c = new Contact();
            c.LastName = 'Random Contact';
            c.AccountId = testacc.id ;
            c.Role__c = 'IT' ;
            c.Business_Function__c = 'Finance';
            c.Email = 'contact@random.com' ;
            c.MobilePhone = '9899075612' ;
            insert c;
             
          OpportunityContactRole oppContact1 = new OpportunityContactRole() ;
            oppContact1.OpportunityId = Opp1.id;
            oppContact1.ContactId = c.Id;
            OppContact1.Role = 'Decision Maker';
            insert oppContact1;
             
          Product2 P1 = new Product2();
            P1.Name = 'DLC';
            P1.Bc_category__c = 'DLC';
            p1.AVCV_Process_Applicable__c = true;
            p1.PO_Process_Applicable__c= true;
             insert p1;
             
            PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=p1.Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
             	insert pbe1;
             
             OpportunityLineItem OppLine1 = new OpportunityLineItem();
            OppLine1.OpportunityID = opp1.Id ;
            OppLine1.PriceBookEntryId = pbe1.id ;
            OppLine1.Solution_Type__c = 'Complex' ;
            OppLine1.Quantity = 10 ;
             insert OppLine1;
             
       		  Opp1.StageName= 'Short-Listed';
              
      		  update Opp1;
             
             
            }
    }
}