@isTest
public class PurchaseOrderInterfaceTest {
    testmethod public static void testcase() {
        EmpowerTransactionTest.CreateConfig();
        prepareTestData();
        RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='PurchaseOrder',name ='PurchaseOrder' , Endpoint__c = 'https://bdjgfd', Active__c = true);
        insert rec;
        
        PurchaseOrderInterface.endpoint = rec;
        PurchaseOrderInterface.initializeJSOn_Field_Map();
        
        PO_Team__c POMem = new PO_Team__c(Name='xyz', Type__c='Program Manager', User_Id__c='xyz');
        insert POMem;

        Purchase_Order__c av= new Purchase_Order__c(Opportunity__c = Opp1.id, Program_Manager1__c = POmem.id, Approval_Status__c='Approved');
        insert av;
        Purchase_Order__c po= new Purchase_Order__c(Opportunity__c = Opp1.id, Program_Manager1__c = POmem.id);
        insert po;
        RecursionControl.POrunAfter = true;
        po.Approval_Status__c='Approved';
        po.Resubmit_to_Empower__c= true;
        update po;
        
        System.debug('po-------'+po);
        AV_CV__c avcv = new AV_CV__c(Opportunity__c = Opp1.id,Purchase_Order__c = av.id);
        insert avcv;
        
        PurchaseOrderInterface.executeQuery(new List<sObject>{av});
        PurchaseOrderInterface.CreateJSON(PurchaseOrderInterface.executeQuery(new List<sObject>{av}));
        
    }
    
    // AVCV Parent PO "Valid Status check" update [on 06/06/2016]
    testmethod public static void testcase2(){
        EmpowerTransactionTest.CreateConfig();
        prepareTestData();
        RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='PurchaseOrder',name ='PurchaseOrder' , Endpoint__c = 'https://bdjgfd', Active__c = true);
        insert rec;
        
        PurchaseOrderInterface.endpoint = rec;
        PurchaseOrderInterface.initializeJSOn_Field_Map();
        
        PO_Team__c POMem = new PO_Team__c(Name='xyz', Type__c='Program Manager', User_Id__c='xyz');
        insert POMem;

        Purchase_Order__c av= new Purchase_Order__c(Opportunity__c = Opp1.id, Program_Manager1__c = POmem.id, Approval_Status__c='Approved');
        insert av;
        Purchase_Order__c po= new Purchase_Order__c(Opportunity__c = Opp1.id, Program_Manager1__c = POmem.id);
        insert po;  
        RecursionControl.POrunAfter = true;
        
        RecordType rdTy_DLC = [SELECT id,RecordType.DeveloperName
                           FROM RecordType WHERE SObjectType='AV_CV__c' and RecordType.DeveloperName='DLC' LIMIT 1];
        
        RecordType rdTy_Voice = [SELECT id,RecordType.DeveloperName
                           FROM RecordType WHERE SObjectType='AV_CV__c' and RecordType.DeveloperName='Voice' LIMIT 1];
        
        AV_CV__c avcv1 = new AV_CV__c(Opportunity__c = Opp1.id,Purchase_Order__c = av.id,RecordTypeID=rdTy_DLC.ID);
        insert avcv1;
        AV_CV__c avcv2 = new AV_CV__c(Opportunity__c = Opp1.id,Purchase_Order__c = po.id,RecordTypeID=rdTy_Voice.ID);
        insert avcv2;
        
        avcv1.POINT_CAF_Status__c='InValid';
        avcv2.POINT_CAF_Status__c='Valid';
        RecursionControl.AVCVrunAfter = true;
        
        update avcv1;
        update avcv2;
        
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
             
       		  Opp1.StageName= 'Verbal Agreement';
              
      		  update Opp1;
            }
    }
}