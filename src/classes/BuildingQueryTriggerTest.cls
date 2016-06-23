/*
    * Name: BuildingQueryTriggerTest Class
    * Created On: January 25, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the BuildingQueryTrigger and BuildingQueryTriggerHandler.
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 25-01-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
public class BuildingQueryTriggerTest {
    
    static testMethod void TestBuilding() 
    {
    List<user> u = TestDataFactory.createUsers();
    System.runAs(u[0])
        {System.debug('Current User: ' + UserInfo.getUserName());
        } 
    
        
            RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='BuildingQuery',name ='BuildingQuery' , Endpoint__c = 'https://najgk.in', Active__c = true, Auth_Key__c='123', iMMEDIATE_eXECUTION__C=TRUE);
             insert rec;
        
        Building_Master__c BM = new Building_Master__c();
        BM.Name = 'Master Building';
        BM.Circle__c = 'Delhi';
        BM.Address__c = 'abc abc1 abc2 abc 3';
        BM.Region__c = 'North';
        BM.Status__c = 'Near-Net';
        insert BM;
        
        Building_Query__c b2 = new Building_Query__c();
        b2.Type_of_Request__c = 'Existing Building';
        b2.Existing_Building__c = BM.id;   
        b2.Submit_to_AMT__c = true;
        insert b2;
        
        
        
    }

}