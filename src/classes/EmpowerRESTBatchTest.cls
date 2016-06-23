@isTest(seeAllData = false)
public class EmpowerRESTBatchTest {

    
    @isTest(seeAllData = false)  
    static void TestEmpowerRESTBatch() 
    {
         List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
        
                EmpowerTransactionTest.CreateConfig();

         Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
        testacc.NV_Created_in_Empower__c=true;
        insert testacc;
             
        Company__C c1 = new Company__C(SSp_Account__c = 'lalala', account__c = testacc.id, default__c=false);
        insert c1;
             
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

         Av_CV__C obj1=new Av_CV__C();
         obj1.CAF_No__c = 'abcabc';
         obj1.Opportunity__c = opp1.id;
         insert obj1;
         
          Av_CV__C obj2=new Av_CV__C();
         obj2.CAF_No__c = 'abcabc';
         obj2.Opportunity__c = opp1.id;
         insert obj2;

         Empower_Rest__c[] E1= new list<Empower_Rest__c>();
         for(integer i = 0 ; i<13; i++)
         {
             Empower_REST__C e = new Empower_REST__c(Endpoint__c = 'https://GeneralSuccess',JSON__C = '{"woohoo":"woohoo"}', Status__c='New', Retrial_Count__c=0);
             E1.add(e);

         }
         E1[0].Endpoint__c = 'https://CalloutException';
         E1[1].Endpoint__c = 'https://GeneralFailure';
         E1[2].Endpoint__c = 'https://CAFSuccess';
         E1[2].Av_CV__C = obj1.id ;
         E1[2].User_Input_1__c = obj1.CAF_No__c ;
         E1[2].User_Input_2__c = 'CAF_No__c' ;
         E1[2].User_Input_3__c = 'CAF_No_Status__c' ;
         E1[3].Endpoint__c = 'https://CAFFailure'; 
         E1[3].User_Input_1__c = 'xyz' ;
         E1[3].User_Input_2__c = 'CAF_No__c' ;
         E1[3].User_Input_3__c = 'CAF_No_Status__c' ;
         E1[4].Endpoint__c = 'https://CAFSuccess';
         E1[4].Av_CV__C = obj1.id ;
         E1[4].User_Input_1__c = obj1.CAF_No__c ;
         E1[4].User_Input_2__c = 'CAF_No__c' ;
         E1[4].User_Input_3__c = 'CAF_No_Status__c' ;
         E1[5].Endpoint__c = 'https://CAFFailure'; 
         E1[5].User_Input_1__c = obj1.CAF_No__c  ;
         E1[5].Av_CV__C = obj1.id ;
         E1[5].User_Input_2__c = 'CAF_No__c' ;
         E1[5].User_Input_3__c = 'CAF_No_Status__c' ;
         E1[6].Endpoint__c = 'https://CAFFailure'; 
         E1[6].User_Input_1__c = obj2.CAF_No__c  ;
         E1[6].Av_CV__C = obj2.id ;
         E1[6].User_Input_2__c = 'CAF_No__c' ;
         E1[6].User_Input_3__c = 'CAF_No_Status__c' ;
         E1[8].Endpoint__c = 'https://JSONE' ;
         E1[7].Endpoint__c = 'https://GeneralSuccess';
         E1[9].Endpoint__c = 'https://SSP' ;
         E1[9].User_Input_4__c = 'SSP' ;
         E1[9].Company__c = c1.id ;
         E1[10].Endpoint__c = 'https://BCSuccess' ;
         E1[11].Endpoint__C = 'https://BCFailure' ;
         E1[12].Endpoint__c = 'https://CAF403Failure'; 
         E1[12].User_Input_1__c = obj1.CAF_No__c  ;
         E1[12].Av_CV__C = obj1.id ;
         E1[12].User_Input_2__c = 'CAF_No__c' ;
         E1[12].User_Input_3__c = 'CAF_No_Status__c' ;
         insert E1 ;
        
         Test.startTest(); 
         /*
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'https://GeneralSuccess', 'success');
        multimock.setStaticResource(
            'https://GeneralFailure', 'failure');
        multimock.setStaticResource(
            'https://CAFSuccess', 'success');
        multimock.setStaticResource(
            'https://CAFFailure', 'failure');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        */
         EmpowerRESTBatch EmpowerRESTBatchObject = new EmpowerRESTBatch();
         Database.ExecuteBatch(EmpowerRESTBatchObject);
         List<ID> mylist = new List<ID>();
         mylist.add(E1[1].Id);
         ExecuteCallouts.ExecuteFuture( mylist  );
       Test.stopTest();
        }
    }
    
    
}