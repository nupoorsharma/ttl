public with sharing class ProductAsPDFController {
    Opportunity oppty;
    
    public Opportunity getOppty(){
        return oppty;
    } 
    public void setOppty(Opportunity o){
        oppty=o;
    }
    public OpportunityLineItem getProduct(){
        List<OpportunityLineItem> items = [select id,name,Product2.name,Product2.National_Presence__c,Product2.Network_Architecture__c,
                                           Product2.Key_Features__c,Product2.Terms_and_Conditions__c,Product2.valid_till__c,
                                           One_Time_Charges__c,Annual_Recurring_Charges__c,Hardware_Charges__c,Manage_Service_Rentals__c
                                           from OpportunityLineItem where 
                                           OpportunityId =: oppty.Id];
        
        if(!items.isEmpty())
        {
           System.debug('Name--' + items[0].Product2.Name);
           return items[0];
        }
        
        else return null;
  
    }
    
    public OpportunityContactRole getContacts(){
        List<OpportunityContactRole> contacts = [select id,Contact.name from OpportunityContactRole where OpportunityId =: oppty.Id order By isPrimary desc];
        if(!contacts.isEmpty()) return contacts[0];
        else return null;
    }
     
    
    
    
    
    
    
}