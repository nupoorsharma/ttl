@isTest
public class BuildingQueryInterfaceTest {
    testmethod public static void testcase() {
        RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='Feasibility',name ='Feasibility' , Endpoint__c = '', Active__c = true);
        insert rec;
        
        BuildingQueryInterface.endpoint = rec;
        BuildingQueryInterface.initializeJSOn_Field_Map();
        
        Building_Query__c bq = new Building_Query__c();
        insert bq;
        
        BuildingQueryInterface.executeQuery(new List<sObject>{bq});
        BuildingQueryInterface.CreateJSON(new List<sObject>{bq});
        
    }
}