/**
 * Test class for AttachmentPlus
 * Provides testing for:
 * 1. AttachmentRuleExtensio class
 * 2. AttachmentUploadController class
 * Created by: rohit6301@gmail.com , sachdev.ayush@gmail.com   
 * Created on: 4 June 13
 */
@isTest
private class TestAttachmentPlus
{
    static testMethod void myTest()
    {     
        PageReference pageRef = Page.AttachmentPlusAdmin;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.standardController(new attachment_rule__c());
        
        AttachmentRuleExtension controller = new AttachmentRuleExtension(sc);

        controller.rule.Name='Test Rule';
        
        controller.getObjectSelectList();
        
        controller.rule.object_name__c = 'No_Such_Class';
        controller.getCheckSelectList();
        controller.getUserFieldList();
        controller.getDateFieldList();
        
        controller.rule.object_name__c = 'attachment';
        controller.getCheckSelectList();
        controller.getUserFieldList();
        controller.getDateFieldList();
        
        controller.rule.object_name__c = 'attachment_rule__c';
        controller.getCheckSelectList();
        controller.getUserFieldList();
        controller.getDateFieldList();
        
        controller.rule.Default_Name_Prefix__c = '';

        controller.save();
        
        Test.setCurrentPage(pageRef);
        
        AttachmentRuleExtension MyController = new AttachmentRuleExtension(sc);
        
        ApexPages.currentPage().getParameters().put('id', controller.rule.Id);
        MyController.rule.name='$#!+';
        
        MyController.save();
        
        
        
        Attachment_Rule__c objAttachmentRule = new Attachment_Rule__c(Name='Test Account');
        insert objAttachmentRule;
       
        Attachment_Rule__c rule = new Attachment_Rule__c();
        rule.Name = 'Document';
        rule.Object_Name__c='Attachment_Rule__c';
        rule.Default_Name_Prefix__c='TestMe';
        rule.Field_received__c='Uploaded_Check_Test__c';
        rule.Uploader_info_field__c='Uploaded_By_Test__c';
        rule.Uploaded_date_field__c='Uploaded_Date_Check__c';
        rule.Max_file_size__c=3;
        insert rule;
       
        pageRef = Page.AttachmentUpload;
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', objAttachmentRule.Id);
       
        AttachmentUploadController controller2 = new AttachmentUploadController();
        controller2.fileList.size();
        controller2.redirect();
       
        Attachment attach = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.Body=bodyBlob;
        attach.Name='MyFile.txt';
       
        controller2.ruleselection='Document';   
        controller2.filesize=2*1024*1024;
        controller2.Orgname='MyFile.txt';
       
        System.assertequals(controller2.attachment,new Attachment());
       
        controller2.attachment = attach;
       
        controller2.upload();
       
        controller2.cancel();       
       
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', objAttachmentRule.Id);
       
        Attachment attach2 = new Attachment();
        attach2.Body=bodyBlob;
        attach2.Name='MyFile.txt';
       
        controller2.attachment = attach2;
        controller2.filesize=1;
        controller2.ruleselection='Test Rule';

        controller2.upload();
       
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', objAttachmentRule.Id);
       
        controller2.filesize=null;
       
        attach.body=Blob.valueOf('test');
        
        controller2.attachment = attach;
        
        controller2.upload();
     
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', objAttachmentRule.Id);
       
        attach.body=null;
        
        controller2.attachment = attach;
        controller2.filesize=(Integer)(0.5*1024*1024);

        controller2.upload();

        Test.setCurrentPage(pageRef);
       
        pageRef = Page.AttachmentUpload;
        Test.setCurrentPage(pageRef);
        
        AttachmentUploadController controller3 = new AttachmentUploadController();
        
        controller3.redirect();                 
        
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', null);
        
        AttachmentUploadController controller4 = new AttachmentUploadController();
        controller4.fileList.size();
        controller4.cancel();
        

        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('id', objAttachmentRule.Id);
        
        AttachmentUploadController controller5 = new AttachmentUploadController();
        controller5.fileList.size();
           
        Attachment attach3 = new Attachment();
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach3.Body=bodyBlob1;
        attach3.Name='xyz.txt';
       
        controller5.ruleselection='Document';   
        controller5.filesize=2*1024*1024;
        controller5.Orgname='abc.txt';
       
        controller5.attachment = attach3;
        ApexPages.currentPage().getParameters().put('id', null);
        controller5.upload();
    }

}