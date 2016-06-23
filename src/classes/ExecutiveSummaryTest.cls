/*
    * Name: ExecutiveSummaryTest Class
    * Created On: January 25, 2016.
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the ExecutiveSummaryController class.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 25-01-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
private class ExecutiveSummaryTest {

    /** Test lead insertion **/
    static testMethod void TestExecutiveSummary() {
    List<user> u = TestDataFactory.createUsers();
	System.runAs(u[1])
    {System.debug('Current User: ' + UserInfo.getUserName());
     
     Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
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
     
    	List<Telecom_Spend__c> TS = new List<Telecom_Spend__c>();
        Telecom_Spend__c T1 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'TTL', Product__C =p.id, Annual_Spend__c = 100000);
        TS.add(T1);
        Telecom_Spend__c T2 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'Aircel', Product__C =p.id, Annual_Spend__c = 200000);
        TS.add(T2);
        Telecom_Spend__c T3 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'Reliance', Product__C =p.id, Annual_Spend__c = 200000);
        TS.add(T3);
        Telecom_Spend__c T4 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'Airtel', Product__C =p.id, Annual_Spend__c = 200000);
        TS.add(T4);
        Telecom_Spend__c T5 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'Mno', Product__C =p.id, Annual_Spend__c = 200000);
        TS.add(T5);
        Telecom_Spend__c T6 = new Telecom_Spend__c( Logo__C = testacc.Id, Operator__c = 'Xyz', Product__C =p.id, Annual_Spend__c = 200000);
        TS.add(T6);
        insert TS;
     
     Billing_Account_Status__c x = new Billing_Account_Status__c(Account__c= testacc.id, Amount__c = 400000 , Billing_Date__c = System.Today().addMonths(-2),
                                                                Invoice_Number__c='xyz', Month__c=12, Calendar_Year__c=5);
     insert x;
     SME_OrderValueBackUpdation__c y = new SME_OrderValueBackUpdation__c(Account__c = testacc.id, Del_Activation_date__c = System.Today().addMonths(-2));
     insert y;
     
     
        PageReference pageRef = Page.ExecutiveSummary;
        Test.setCurrentPage(pageRef);
     
     ApexPages.standardController stdcontroller = new ApexPages.standardController(testacc);
      
        ExecutiveSummaryController controller = new ExecutiveSummaryController(stdcontroller); 
		//ApexPages.currentPage().getParameters().put('id', testacc.id);
		
		testacc.NumberOfEmployees = 99;
        testacc.AnnualRevenue = 10000000;
        update testacc;
        controller = new ExecutiveSummaryController(stdcontroller); 
     
     testacc.NumberOfEmployees = 109;
        testacc.AnnualRevenue = 120000000;
        update testacc;
        controller = new ExecutiveSummaryController(stdcontroller);
     testacc.NumberOfEmployees = 509;
        testacc.AnnualRevenue = 1020000000;
        update testacc;
        controller = new ExecutiveSummaryController(stdcontroller);
     testacc.NumberOfEmployees = 5009;
        testacc.AnnualRevenue = 502000000;
        update testacc;
        controller = new ExecutiveSummaryController(stdcontroller);
     


    } 
    }
}