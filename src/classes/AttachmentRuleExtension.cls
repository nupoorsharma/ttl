/**
 * This Class is used to Manage Creation of Attachment Upload rules to Salesforce Objects in a customized manner.
 * The key Functions performed by the class are:
 * 1: Create a new record for Attachment Rule Custom Object
 * 2: Get values to populate the corresponding Visual Force Page (AttachmentUploadAdmin)
 * 
 * Created by: rohit6301@gmail.com , sachdev.ayush@gmail.com   
 * Created on: 4 June 13
 */
public with sharing class AttachmentRuleExtension {

    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();        //Map of all Objects in the ORG
    public attachment_rule__c rule{get; set;}                               //Object to store values for record
    public List<SelectOption> ErrorOptions;                                 //Displayed when no options available

    /**
     * Overrides standard controller save funtion
     * @exception Catches any exception during upsert
     * @return On success, reference to record
     * @return On failure, stays on the same page     
     */

    public pageReference save()
    {
        try {
        
            upsert rule;
            
            PageReference pageRef = new PageReference('/'+rule.id);
            pageRef.setredirect(true);
            return pageRef;
        }
        catch(Exception e) {
        
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sorry, the rule could not be saved'));
           return null;
        } 
    }
    /**
     * Constructor for the class
     * @param controller Standard Controller from VF Page
     * @return Constructor does not return
     */ 
    public AttachmentRuleExtension(ApexPages.StandardController controller){
    
        rule = (Attachment_rule__c)controller.getRecord();
        if(rule.id!=null)
            rule = [select id,Name, Object_Name__c, Field_received__c, Uploader_Info_Field__c, Uploaded_Date_Field__c, Default_Name_Prefix__c, Append_Date__c, Max_File_Size__c, Guidelines_for_attachment__c from Attachment_Rule__c where id=:rule.id];
            
        if(rule.id==null)
        {
       // if(rule.Append_date__c==null)
            rule.Append_date__c = true;
        //if(rule.Object_name__c==null)
            rule.Object_name__c = getObjectSelectList().get(0).getValue();
        }
        
        ErrorOptions = new List<SelectOption>();
        ErrorOptions.add(new SelectOption('','No Fields Available',true));
    }
    
    /**
     * Getter method for ObjectSelectList used in VF Page
     * @return List of SelectOption containing all objects in ORG
     */
    public List<SelectOption> getObjectSelectList(){
       
        Set<String> gdk = gd.keyset();
        List<SelectOption> options = new List<SelectOption>();
        
        /*                                                        //Standard Objects that support attachments
                                                                  //All custom objects support attachments, related
                                                                  //lists can be activated through page layout
        options.add(new SelectOption('account','Account'));
        options.add(new SelectOption('asset','Asset'));
        options.add(new SelectOption('campaign','Campaign'));
        options.add(new SelectOption('case','Case'));
        options.add(new SelectOption('contact','Contact'));
        options.add(new SelectOption('contract','Contract'));
        options.add(new SelectOption('event','Event'));
        options.add(new SelectOption('lead','Lead'));
        options.add(new SelectOption('opportunity','Opportunity'));
        options.add(new SelectOption('product2','Product2'));
        options.add(new SelectOption('solution','Solution'));
        options.add(new SelectOption('task','Task'));
        */

        for(String s : gdk){
            
            //if(s.endsWith('__c'))                                //Condition to check for custom objects
            {
                Schema.SObjectType o = gd.get(s);              
                options.add(new SelectOption(s,o.getDescribe().getLabel()));
            }
        }
        
        options.sort();

        return options;
    }
    /**
     * Getter method for CheckSelectList used in VF Page
     * @exception If rule.Object_name__c has an object name that cannot be modified e.g. AccountHistory
     * @return List of SelectOption containing custom 'Checkbox' fields of object name in rule.Object_name__c
     */
    public List<SelectOption> getCheckSelectList(){
    
        try{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select From Available Fields'));
            
            Schema.SObjectType ctype = gd.get(rule.Object_name__c);  
            Map<String, Schema.SobjectField> objectFields = ctype.getDescribe().fields.getMap();

            for(String s: objectFields.keySet()){
            
                Schema.DescribeFieldResult F = objectFields.get(s).getDescribe();
        
                Schema.DisplayType D = F.getType();
        
                if(D==Schema.DisplayType.Boolean && s.endsWith('__c')){
                
                    options.add(new SelectOption(s,f.getLabel()));
                 }
            }
        
            if(options.size() > 1){
            
                options.sort();
                return options;
            }
            else
                return ErrorOptions;
        }
        catch(Exception e){
        
            return ErrorOptions;
        }
    }

    /**
     * Getter method for UserList used in VF Page
     * @exception If rule.Object_name__c has an object name that cannot be modified e.g. AccountHistory
     * @return List of SelectOption containing custom 'User LookUp' fields of object name in rule.Object_name__c
     */
    public List<SelectOption> getUserFieldList(){
    
        try{
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Select From Available Fields'));
        
        Schema.SObjectType ctype = gd.get(rule.Object_name__c);  
        Map<String, Schema.SobjectField> objectFields = ctype.getDescribe().fields.getMap();
        
        List<Schema.SObjectType> UserLookUp = new List<Schema.SObjectType>();
        UserLookUp.add(gd.get('User'));
        
        for(String s: objectFields.keySet()){
        
            Schema.DescribeFieldResult F = objectFields.get(s).getDescribe();
            Schema.DisplayType D = F.getType();
        
            if(D==Schema.DisplayType.Reference && s.endsWith('__c') && F.getReferenceTo()==UserLookUp){
            
                options.add(new SelectOption(s,f.getLabel()));
            }
        }
        
        if(options.size() > 1){
        
            options.sort();
            return options;
        }
        else
            return ErrorOptions;
        }
        catch(Exception e){
        
                return ErrorOptions;
        }    
    }

    /**
     * Getter method for DateFieldList used in VF Page
     * @exception If rule.Object_name__c has an object name that cannot be modified e.g. AccountHistory
     * @return List of SelectOption containing custom 'Date' fields of object name in rule.Object_name__c
     */
    public List<SelectOption> getDateFieldList(){
    
        try{
        
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select From Available Fields'));

            Schema.SObjectType ctype = gd.get(rule.Object_name__c);  
            Map<String, Schema.SobjectField> objectFields = ctype.getDescribe().fields.getMap();
  
            for(String s: objectFields.keySet()){
            
                Schema.DescribeFieldResult F = objectFields.get(s).getDescribe();
                Schema.DisplayType D = F.getType();
        
                if(D==Schema.DisplayType.Date && s.endsWith('__c')){
                
                    options.add(new SelectOption(s,f.getLabel()));
                }
            }
            
            if(options.size() > 1){
        
                options.sort();
                return options;
            }
            else
                return ErrorOptions;
        }
        catch(Exception e){
            return ErrorOptions;
        }
    }
}