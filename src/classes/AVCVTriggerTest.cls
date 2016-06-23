@isTest(seeAllData = false)
public class AVCVTriggerTest {
    static Opportunity Opp1;
    static testMethod void TestAVCV()
    {
        
        EmpowerTransactionTest.CreateConfig();
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
        
         RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='AVCV',name ='AVCV' , Endpoint__c = '', Active__c = true, Auth_Key__c='123');
        insert rec;
             
         RESTEndpointURL__c res = new RESTEndpointURL__c(Interface_Name__c='ePos',name ='ePos' , Endpoint__c = '', Active__c = true, Auth_Key__c='123');
         insert res;
        
        RecordType rdTy_DLC = [SELECT id,RecordType.DeveloperName
                           FROM RecordType WHERE SObjectType='AV_CV__c' and RecordType.DeveloperName='DLC' LIMIT 1];
        
        AV_CV__c avcv = new AV_CV__c(RecordTypeid=rdTy_DLC.id);
        avcv.Opportunity__c = Opp1.id;
        avcv.NLD_CAF_No__c = 'av';
        avcv.Parent_CAF_No__c = 'cv';
        avcv.Point_B_CAF_No__c  = 'PointB' ;
        avcv.Point_CAF_No__c = 'xyz';
        avcv.POINT_CAF_Status__c='Valid';
        insert avcv;
       
        RecursionControl.AVCVrunAfter=true;
        avcv.AMT_Comment__c = 'hi' ;
        avcv.Sales_Comment__c = 'hey' ;
        avcv.Submit_to_AV_CV_Team__c = false ;
        avcv.Revert_to_AMT__c = true ;
        avcv.NLD_CAF_No__c = 'xav';
        avcv.Parent_CAF_No__c = 'xcv';
        avcv.Point_B_CAF_No__c  = 'xPointB' ;
        avcv.Point_CAF_No__c = 'zxyz';
        update avcv ;
        
       }
        
    }
}