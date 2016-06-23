@isTest
public class CreateMACDOpportunityClonerTest {
     public static testMethod void testOpptyClone() {
        Account acct = new Account(Name = 'Test Acct');
        insert acct;
        
        PriceBook2 pe = new PriceBook2(Name = 'Test PriceBook', isActive = True);
        insert pe;
        Product2 p = new Product2(Name = 'WIFI Hotspot', Product_Group__c = 'GSM 3G', Family = 'Wireless Data', Product_Type__c = 'Standard', Product_Categorization__c = 'Wireless Data', isActive = True, TTL_TCL__c = 'TTL' );
        insert p;
        Opportunity oppty = new Opportunity(Name = 'Test Oppty', AccountId = acct.Id, ISP_Non_ISP__c = 'ISP', Product__c=p.ID, Type = 'New', CloseDate = System.today() + 5, StageName = 'Identified', Win_Reason__c = 'Fresh Requirement', Channel_Type__c = 'Direct');
        insert oppty;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        PriceBookEntry pEntry = new PriceBookEntry(Product2ID = p.Id, PriceBook2Id = pe.Id, IsActive = True, UnitPrice = 10);
        insert pEntry;

        OpportunityLineItem oli=new OpportunityLineItem(OpportunityID=oppty.Id, PricebookEntryId=pEntry.Id, Solution_Type__c='Simple', Quantity=1);
        insert oli;
        Feasibility__c f = new Feasibility__c(Opportunity__c = oppty.Id, Flavor__c = 'Normal', Hotspot_type__c = 'PMS', Hotspot_Name__c = 'Airtel', Cyber_Butler_Required__c = 'No', Type_of_Authentication__c = 'Local', Do_You_Want_To_AutoClose_The_FAN__c = 'N', Remarks__c = 'Test', Product__c = p.Id);
        insert f;

        SME_OrderValueBackUpdation__c circuit = new SME_OrderValueBackUpdation__c(Account__c = acct.Id, OpportunityID__c = oppty.ID, FAN_number__c='F12345', Feasibility__c = f.Id);
        insert circuit;
        Product_Flavor_Type__c pF = new Product_Flavor_Type__c(Name = 'WIFI Hotspot - Upgrade', Product__c = 'WIFI Hotspot', Flavor__c = 'Normal', Type__c = 'Upgrade');
        insert pF;
        PageReference pageRef = Page.Create_MACDOpportunity;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', circuit.ID+'~'+circuit.ID);
        CreateMACDOpportunityCloner cMAC = new CreateMACDOpportunityCloner();
        cMAC.type='Upgrade';
        PageReference pgRef=cMAC.CreateMACDOpptyWithFan();
        cMAC.getType();
        cMAC.getItems();
        cMAC.back();
    }
    public static testMethod void testValidateCircuit(){
        Account acct = new Account(Name = 'Test Acct');
        insert acct;
        
        PriceBook2 pe = new PriceBook2(Name = 'Test PriceBook', isActive = True);
        insert pe;
        Product2 p = new Product2(Name = 'WIFI Hotspot', Product_Group__c = 'GSM 3G', Family = 'Wireless Data', Product_Type__c = 'Standard', Product_Categorization__c = 'Wireless Data', isActive = True, TTL_TCL__c = 'TTL' );
        insert p;
        Opportunity oppty = new Opportunity(Name = 'Test Oppty', AccountId = acct.Id, ISP_Non_ISP__c = 'ISP', Type = 'New', CloseDate = System.today() - 5, StageName = 'Identified', Win_Reason__c = 'Fresh Requirement', Channel_Type__c = 'Direct');
        insert oppty;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        PriceBookEntry pEntry = new PriceBookEntry(Product2ID = p.Id, PriceBook2Id = pe.Id, IsActive = True, UnitPrice = 10);
        insert pEntry;

        OpportunityLineItem oli=new OpportunityLineItem(OpportunityID=oppty.Id, PricebookEntryId=pEntry.Id, Solution_Type__c='Simple', Quantity=1);
        insert oli;
        Feasibility__c f = new Feasibility__c(Opportunity__c = oppty.Id, Flavor__c = 'Normal', Hotspot_type__c = 'PMS', Hotspot_Name__c = 'Airtel', Cyber_Butler_Required__c = 'No', Type_of_Authentication__c = 'Local', Do_You_Want_To_AutoClose_The_FAN__c = 'N', Remarks__c = 'Test', Product__c = p.Id);
        insert f;

        SME_OrderValueBackUpdation__c circuit = new SME_OrderValueBackUpdation__c(Account__c = acct.Id, Feasibility__c = f.Id);
        insert circuit;
        Product_Flavor_Type__c pF = new Product_Flavor_Type__c(Name = 'WIFI Hotspot - Upgrade', Product__c = 'WIFI Hotspot', Flavor__c = 'Normal', Type__c = 'Upgrade');
        insert pF;
        PageReference pageRef = Page.Create_MACDOpportunity;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', circuit.ID+'~'+circuit.ID);
        CreateMACDOpportunityCloner cMAC = new CreateMACDOpportunityCloner();
        cMAC.type='Upgrade';
        PageReference pgRef=cMAC.CreateMACDOpptyWithFan();
        cMAC.getType();
        cMAC.getItems();
        cMAC.back();
    }
}