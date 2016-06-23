/*
    * Name: OpportunityTriggerTest Class
    * Created On: Jaunuary 25, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the OpportunityTrigger, OpportunityTriggerHandler, 
    *               OpportunityLineItemTrigger and OpportunityLineItemTriggerHandler.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 25-01-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
public class OpportunityTriggerTest {
   
    static testMethod void TestOpportunity()
    {
        List<user> u = TestDataFactory.createUsers();
        u[0].ManagerId = u[2].Id;
        update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
            //Create Empower Config records
             EmpowerTransactionTest.createConfig();
        Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
        testacc.NV_Created_in_Empower__c=true;
        insert testacc;
        
         Account testacc2 = new Account(Name = 'Test Account 2');
        testacc2.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc2.Type = 'Other'; 
        testacc2.Logo_Segment__c = 'B2B' ;
        testacc2.NV_Created_in_Empower__c=true;
        insert testacc2;
             
        Pricebook2 price = new Pricebook2(Name='DIE', Logo_Segment__c = 'B2B', User_Segment__c = 'B2B', IsActive=true);
        insert price;
        
             
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
        Opp1.SOID_Created_in_Empower__c = true ;
        insert Opp1;
             
        Opportunity opp2 = new Opportunity();
        opp2.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
        opp2.Name = 'Opty 2';
        opp2.AccountId = testacc2.Id;
        opp2.CloseDate = System.Today().addMonths(1);
        opp2.StageName = 'Identified' ;
        opp2.Win_Reason__c = 'Fresh Requirement' ;
        opp2.Channel_Type__c = 'Direct' ;
        Opp2.SOID_Created_in_Empower__c = true ;
        insert opp2;
        update Opp2;
        
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
        
        ClusterHead_SA_Mapping__c SA = new ClusterHead_SA_Mapping__c();
        SA.cluster_Head__c = u[2].Id ;
        SA.Active__c = true ;
        SA.Solution_Architect__c = u[1].Id ;
        insert SA;
        
        BD_Mapping__c BD = new BD_Mapping__c();
        BD.Active__c = True;
        BD.BD_Category__c = 'Enterprise Voice' ;
        BD.Region__c = 'North' ;
        BD.Business_Development__c = u[2].Id ;
        insert BD;
        
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

       PricebookEntry pbe = new PricebookEntry(unitprice=0.00,Product2Id=p.Id,Pricebook2Id=price.Id, IsActive = true);
       insert pbe ;
        
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
       
        opp1.StageName = 'Qualified';
        update opp1;
        
        
        opp1.AccountId = testacc2.Id;
        update opp1;
             
             String ext =  opp1.Id + '~' + u[2].id;
        OpportunityTeamMember otmOld = [Select id from OpportunityTeamMember where OpportunityId= :opp1.Id and key__c= :ext] ;
             try{
             delete otmOld;
             }
             catch(exception ex) {}
             
        OpportunityTeamMember otm = new OpportunityTeamMember();
           otm.OpportunityId =   opp2.Id;
           otm.UserId = u[2].id;
           otm.TeamMemberRole = 'Business Development';
           otm.AutoCreated__c = false;
           otm.Key__c = opp2.Id + '~' + u[2].id;
             
             try{
                 insert otm;
             }
             catch(Exception ex)
             {}
         delete oppContact;
             try{opp1.StageName = 'Qualified';
                 update opp1;
                }
             catch(Exception e)
             {   Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.Atleast_one_Contact_Role_on_opportunity) ? true : false;
                 System.AssertEquals(expectedExceptionThrown, true);            
             }
             
             
            }
        
    }
        
        
        
        
        /*
        static testMethod void AssignCompanyToOpportunity(){ 
        Account testacc = new Account(Name = 'Test Account');
        insert testacc;
        //This account will be populated on Opportunity lookup field: Account
        //Get the required Company__c
        Company__c CompanyForAccount = [Select Id, Account__c, Default__c from Company__c where Account__c = :testacc.id and Default__c=true];
        List<Opportunity> insertlist = new List<Opportunity>();
        //Stores all Opportunities to be inserted.

        //Generate some Opportunities with an associated account.
        for (integer i = 0; i < 10; i++) {
            Opportunity opp = new Opportunity();
            opp.AccountId = testacc.id;
            opp.StageName='Prospecting';
            opp.CloseDate = System.Today();
            opp.Name = 'Test Opp '+i;
            insertlist.add(opp);
        }

       
        Test.startTest();

        insert insertlist;
        List<ID> generatedOpportunityID = new List<ID>();
        for (Opportunity l : insertlist)
            generatedOpportunityID.add(l.id);

        //Get all inserted Opportunities
        List<Opportunity> generatedOpportunities = new List<Opportunity>([Select Id, Name, AccountId, Company__c from Opportunity where Id in :generatedOpportunityID ]);
        
        for (Opportunity o : generatedOpportunities ) {
            //Validate that the Opportunities have the required Company__c.
            System.Debug('Opportunity :: Name: \t' + o.Name + '\t Company__c : \t' + o.Company__c);
            System.assertEquals(o.Company__c, CompanyForAccount.id );

        }
        
        //Generate a new account to update Opportunities.
         Account testaccUpdate = new Account(Name = 'Test Account for update');
        insert testaccUpdate;
        //This account will be populated on Opportunity lookup field: Account
        //Get the Company for Updated Account
      Company__c CompanyForAccountUpdate = [Select Id, Account__c, Default__c from Company__c where Account__c = :testaccUpdate.id and Default__c=true];
        //Update AccountId on all Opportunities
       for(Opportunity OpportunitytoUpdate : generatedOpportunities )
       {
           OpportunitytoUpdate.Accountid=testaccUpdate.id;
       } 
        update generatedOpportunities ;
        //Get the Updated Opportunities
        
        List<Opportunity> updatedOpportunities = new List<Opportunity>([Select Id, Name, AccountId, Company__c from Opportunity where Id in :generatedOpportunityID ]);

        for (Opportunity o : updatedOpportunities ) {
            //Validate that the Opportunities have the required Company__c.
            System.assertEquals(o.Company__c, CompanyForAccountUpdate.id );
            System.Debug('Opportunity :: Name: \t' + o.Name + '\t Company__c : \t' + o.Company__c);
        }
        
        
        Test.stopTest();
    }

    */
   
}