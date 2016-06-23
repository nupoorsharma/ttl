public with sharing class ExtensionProposalAsPDFTemplate {
    
   public String emailTemplate{get;set;}
   public ID opptyID{get;set;}
   public ID docID{get;set;}
   public boolean flag{get;set;}
   public Opportunity o;
   public Id contactID;
   public String ContactName;
   public List<OpportunityContactRole> contactRole = new List<OpportunityContactRole>();
   public List<OpportunityLineItem>  oliList = new List<OpportunityLineItem>();
 
    public ExtensionProposalAsPDFTemplate(ApexPages.StandardController controller) {
        PDFGlobalVariables__c var = PDFGlobalVariables__c.getInstance('Default');
        emailTemplate = var.EmailTemplateID__c;
        opptyId = ApexPages.currentPage().getParameters().get('id');
        o = [select version_number__c, Proposal_Modified_On__c, stageName  from Opportunity where id= :opptyId];

         if(o.StageName.equals('Short-listed') || o.StageName.equals('Verbal Agreement') || o.StageName.equals('Qualified'))
             flag = true;
         else{
             flag = false;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Cannot send Proposal at this stage.'));
         }

      oliList = [Select id, Product2Id, Product2.Document_ID__c from OpportunityLineItem where OpportunityId = :ApexPages.currentPage().getParameters().get('id')];
      if(oliList.size() > 0){
          OpportunityLineItem oli = oliList[0];
          if(oli.Product2.Document_ID__c != null)
              docID=oli.Product2.Document_ID__c ;
       }
      
      contactRole = [select id,Contact.name, Contact.Id from OpportunityContactRole where OpportunityId =: opptyId order By isPrimary desc LIMIT 1];
      System.debug('contactRole----'+contactRole);
      
      if(contactRole.size() > 0){
          contactId = contactRole[0].Contact.id;
          ContactName = contactRole[0].Contact.name;
          }
       
      
    }
    
    public PageReference sendEmail(){
    
      //  Integer version;
        if(o.version_number__c == null){
            o.version_number__c = 1;
        //    version = 1;
         }
        else
            o.version_number__c += 1;
            
        //    version = (Integer)o.version_number__c;
            o.Proposal_Modified_By__c = UserInfo.getUserId();
            o.Proposal_Modified_On__c = System.now();
        
        update o;
        
/*        string pdfURL= '/apex/ProposalAsPDF?id='+opptyId;
        System.debug('pdfURL------'+pdfURL);
        PageReference pdf = new PageReference(pdfURL);
        System.debug('PageRef ------ ' + pdf.getUrl());
        Blob pdfBody;
         try {
            pdfBody = pdf.getContent();
        //   pdfBody = pdf.Body;
          }catch (Exception e){
             pdfBody = Blob.valueOf('Unable to create pdf');
         }
        System.debug('Here I am : '+ pdfBody.toString());         
         Attachment a = new Attachment();
         a.ContentType = 'application/pdf';
         a.body = pdfBody;
         System.debug('Body--------------'+a.body);
         a.name = 'Proposal_V'+ version+ '.pdf';
         a.ParentId = opptyId;
         try{
             insert a;
             System.debug(a);
           }catch(Exception e){
               System.debug('Exception----'+e);
           }

*/
        
        if(docID==null && contactId!=null){
                return new PageReference('/_ui/core/email/author/EmailAuthor?&p3_lkid=' + ApexPages.currentPage().getParameters().get('id') +'&retURL=%2F' + ApexPages.currentPage().getParameters().get('id')+ '&new_template=1&template_id=' + emailTemplate+ '&p2_lkid='+contactId+ '&ContactName='+ContactName); 
        }else if(docId!= null && contactId==null){
                 return new PageReference('/_ui/core/email/author/EmailAuthor?&p3_lkid=' + ApexPages.currentPage().getParameters().get('id') +'&retURL=%2F' + ApexPages.currentPage().getParameters().get('id')+ '&doc_id='+docID+'&new_template=1&template_id=' + emailTemplate);   
        }else if(docId==null && contactId== null){
                 return new PageReference('/_ui/core/email/author/EmailAuthor?&p3_lkid=' + ApexPages.currentPage().getParameters().get('id') +'&retURL=%2F' + ApexPages.currentPage().getParameters().get('id')+ '&new_template=1&template_id=' + emailTemplate);
        }
        else{
            return new PageReference('/_ui/core/email/author/EmailAuthor?&p3_lkid=' + ApexPages.currentPage().getParameters().get('id') +'&retURL=%2F' + ApexPages.currentPage().getParameters().get('id')+ '&doc_id='+docID+'&new_template=1&template_id=' + emailTemplate+ '&p2_lkid='+contactId+ '&ContactName='+ContactName);        
        }
    

    }
    
    public PageReference cancel(){
        return new PageReference('/'+opptyId);
    }
}