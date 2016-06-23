/** This Class is used to Manage Attachment uploading to Salesforce Objects in customized manner.
 * The key Functions performed by the class are:
 * 1: Upload the Attachment to the selected Object.
 * 2: Apply the Attachment upload Rules as specified for the Object e.g. mark the Object that the Attachment has been received
 * 
 * Created by: harmandeep.singh@comprotechnologies.com
 * Created On: 06 June 11
 * Last modified by: rohit6301@gmail.com , sachdev.ayush@gmail.com   
 * Last modified on: 27 May 13
 */
 
public with sharing class AttachmentUploadController{
 
    List<Attachment_Rule__c> attachmentRule = null;        //List of all the attachment rules for a particular object
    String objectId = null;                                //Storing the id of record that called the page
    String objectName = null;                              //Storing the object of the record that called the page
    public String ruleselection {get; set;}                //Storing the selected rule from VF page
    public String Orgname {get; set;}                      //Storing the original name of the attachment
    String extension = null;                               //Storing the extension of the file being uploaded
    public Integer filesize {get; set;}                    //Storing the size of the file being uploaded
    public String guide{get; set;}                         //Storing the rule name and the related guideline
    public String firstDisplay{get; set;}                  //Guideline to be displayed for the first rule selected
    public boolean invalidID{get; set;}                    //Set to true when an illegal approach is detected
         
    public Attachment attachment{                          //Object of attachment being attached
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    /** If a the ID is missing or malformed, sets InvalidID to true and display an error
     * Invoked from VF page as an action on page load.
     */
    public void redirect(){
    
        invalidID = false;
        String id = ApexPages.CurrentPage().getParameters().get('id');
        
        if(id==''||id==null){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sorry, Illegal approach to page'));
        invalidID = true;
        }
    List<SelectOption> temp = fileList;
    }
    
    /** FileList stores the list of all the attachment rules that have been made on current object.
     * Getter method is used to display the list on the VF page.
     */
    public List<SelectOption> fileList{
        get{
            guide = '[{';
            List<SelectOption> options = new List<SelectOption>();
            objectId = ApexPages.CurrentPage().getParameters().get('id'); 
            
            try{
                ID oID = (ID)objectId;
               
                objectName = oId.getSObjectType().getDescribe().getName();
                if(objectName.contains('Attachment_plus__'))
                {
                    objectName = objectName.substringafter('Attachment_plus__');
                }

                attachmentRule = [select Name, Object_Name__c, Field_received__c, Uploader_Info_Field__c, Uploaded_Date_Field__c, Default_Name_Prefix__c, Append_Date__c, Max_File_Size__c, Guidelines_for_attachment__c from Attachment_Rule__c where Object_Name__c=:objectName order by Name asc];
                Integer attachmentRuleSize = attachmentRule.size();
                Integer attachmentRuleCounter = 0;
                
                for(Attachment_Rule__c rule : attachmentRule){
                    options.add(new SelectOption(rule.Name,rule.Name));

                    if(attachmentRuleCounter == attachmentRuleSize - 1)
                    {
                       guide+='"ap__'+rule.Name.replaceAll(' ','_')+'":"'+rule.Guidelines_for_attachment__c+'"';

                    }
                    else
                    {
                        guide+='"ap__'+rule.Name.replaceAll(' ','_')+'":"'+rule.Guidelines_for_attachment__c+'", ';
                    }
                    
                    attachmentRuleCounter ++;

                }
                
                guide+='}]';
                
                firstDisplay = attachmentRule[0].Guidelines_for_attachment__c;
                if(firstDisplay == '' || firstDisplay == null)
                    firstDisplay = 'No Guidelines Available';

                return options;
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Object ID'));
                options.add(new SelectOption('','Invalid Object ID'));
                firstDisplay = 'Invalid Object ID';
                guide='[{"ap__":"Invalid Object ID"]}';
                invalidID = true;
                return options;
            }
        }
        set;       
    }

    /** Cancel method is invoked by clicking the Cancel button on VF page.
     * On legal approach, it redirects the user back to the record from which the VF page was invoked.
     * @return PageReference to the record.
     * On illegal approach, it redirects the user to the home page.
     * @return User's home page.
     */
    public PageReference cancel(){
        
        if(invalidID){
     
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setredirect(true);
            return pageRef;
        }
        else{
            
            PageReference objectPage = new PageReference('/'+ApexPages.CurrentPage().getParameters().get('id'));
            return objectPage;
        }
    }
    
    /** Upload method is invoked by clicking the Upload button on VF page.
     * It checks the attachment object and inserts the attachment or displays the appropriate error.
     * @return PageReference to the record if uploaded successfully.
     * @errorMessage "Please select a file!" if no file is selected.
     * @errorMessage "Attachment exceeds maximum attachment size limit" if file exceeds the maximum file size specified in rule.
     * @exception "Error uploading attachment" if there is any error in uploading attachment.
     */
    public PageReference upload(){

        Attachment_Rule__c rule = null;
        
        for(Attachment_Rule__c rule1: attachmentRule){
            if(rule1.Object_Name__c.equalsIgnoreCase(objectName) &&  rule1.Name.equalsIgnoreCase(ruleselection)){
            rule = rule1;
            }
        }
        
        if(attachment.body == null){
            String msg ='Please select a file!';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,msg));
            return null; 
        }

        if((filesize==null)||(filesize > (rule.Max_File_Size__c*1024*1024))){
            attachment.body=null;
            String msg ='Attachment exceeds maximum attachment size limit of: '+rule.Max_File_Size__c+' MB';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,msg));
            return null;
        }

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ApexPages.CurrentPage().getParameters().get('id');
        attachment.IsPrivate = false;

        extension= '.' + Orgname.substringAfterLast('.');
        Orgname = Orgname.substringBeforeLast('.');
        if(rule.Default_Name_Prefix__c!=''&&rule.Default_Name_Prefix__c!=null)
        attachment.Name = rule.Default_Name_Prefix__c;
        else
        attachment.Name = Orgname;

        if(rule.Append_Date__c)
        attachment.Name += ' - ('+String.valueof(Date.today()) +')';
        
        attachment.Name += extension;

        try {
            insert attachment;
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } 
        finally {
            attachment.body=null;
            attachment = new Attachment();
        }
        
        String qryString = 'select id ';

        if(rule.Field_received__c!=''&&rule.Field_received__c!=null)
        qryString += ', ' + rule.Field_received__c;
        
        if(rule.Uploader_Info_Field__c!=''&&rule.Uploader_Info_Field__c!=null)
        qryString += ', ' + rule.Uploader_Info_Field__c;
        
        if(rule.Uploaded_Date_Field__c!=''&&rule.Uploaded_Date_Field__c!=null)
        qryString += ', ' + rule.Uploaded_Date_Field__c;
        
        qryString += ' from '+objectName+' where id=\''+objectId+'\'';

        List<Sobject> queryResult = Database.query(qryString);
        if(queryResult.size()==1){
            Sobject object1 = queryResult.get(0);
            
            if(rule.Field_received__c!=''&&rule.Field_received__c!=null)
            object1.put(rule.Field_received__c, TRUE);
            
            if(rule.Uploader_Info_Field__c!=''&&rule.Uploader_Info_Field__c!=null)
            object1.put(rule.Uploader_Info_Field__c, UserInfo.getUserId());
            
            if(rule.Uploaded_Date_Field__c!=''&&rule.Uploaded_Date_Field__c!=null)
            object1.put(rule.Uploaded_Date_Field__c, System.today());
            
            update object1;
        }

        PageReference objectPage = new PageReference('/'+ApexPages.CurrentPage().getParameters().get('id'));
        return objectPage;
    }
}