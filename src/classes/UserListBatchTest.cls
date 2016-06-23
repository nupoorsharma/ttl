/*
    * Name: UserListBatchTest Class
    * Created On: May 30, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the class UserListBatch
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 30-05-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/
@isTest(seeAllData = false)
public class UserListBatchTest {

    
    @isTest(seeAllData = false)  
    static void TestUserListBatch1() 
    {
         List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
         Test.startTest();
         PO_Team__c PO = new PO_Team__C(name = 'abc');
         insert PO;
         RESTEndpointURL__c UserListSetting = new RESTEndpointURL__c(Endpoint__c = 'https://USERLIST',
                                                                    Auth_Key__c = 'USERLIST',
                                                                    Interface_Name__c = 'UserList',
                                                                    Name = 'UserList',
                                                                    Active__c=true);
          insert UserListSetting;
          ID batchprocessid = Database.ExecuteBatch(new UserListBatch());
         System.schedule('UserList Integration', '0 20 12,13,14 * * ?', new USERLISTScheduler());

          Test.stopTest();
        }
    }
    
    @isTest(seeAllData = false)  
    static void TestUserListBatch2() 
    {
         List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
         Test.startTest();
         RESTEndpointURL__c UserListSetting = new RESTEndpointURL__c(Endpoint__c = 'https://CalloutException',
                                                                    Auth_Key__c = 'USERLIST',
                                                                    Interface_Name__c = 'UserList',
                                                                    Name = 'UserList',
                                                                    Active__c=true);
         insert UserListSetting;
         Database.ExecuteBatch(new UserListBatch());
         Test.stopTest();

        }
    }
    
    @isTest(seeAllData = false)  
    static void TestUserListBatch3() 
    {
         List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
         Test.startTest();
         RESTEndpointURL__c UserListSetting = new RESTEndpointURL__c(Endpoint__c = 'https://JSONE',
                                                                    Auth_Key__c = 'USERLIST',
                                                                    Interface_Name__c = 'UserList',
                                                                    Name = 'UserList',
                                                                    Active__c=true);
         insert UserListSetting;
         Database.ExecuteBatch(new UserListBatch());
         Test.stopTest();

        }
    }
    
    @isTest(seeAllData = false)  
    static void TestUserListBatch4() 
    {
         List<user> u = TestDataFactory.createUsers();
        System.runAs(u[1])
        {System.debug('Current User: ' + UserInfo.getUserName());
         Test.startTest();
         RESTEndpointURL__c UserListSetting = new RESTEndpointURL__c(Endpoint__c = 'https://Failure',
                                                                    Auth_Key__c = 'USERLIST',
                                                                    Interface_Name__c = 'UserList',
                                                                    Name = 'UserList',
                                                                    Active__c=true);
         insert UserListSetting;
         Database.ExecuteBatch(new UserListBatch());
         Test.stopTest();

        }
    }
}