public without sharing class LeadAccountDuplicateChkController{
    
    public Id leadId {get;set;}
    public boolean renderPage {get; set;}
    public List<DuplicateRecordItem> DuplicateRecordItemList{get;set;}
    public Set<Id> DRS_set{get;set;}
    public List<Account> DuplicateAccountList{get;set;}
    public List<Lead> DuplicateLeadList{get;set;}
    public boolean LeadlistRender{get;set;}
    public boolean AccountlistRender{get;set;}
    
    public LeadAccountDuplicateChkController(ApexPages.StandardController controller) {
        
        leadId = controller.getRecord().Id;
        renderPage= true;
        LeadlistRender=true;
        AccountlistRender=true;
        DRS_set=new Set<Id>();
        DuplicateRecordItemList=new List<DuplicateRecordItem>();
        DuplicateAccountList=new List<Account>();
        DuplicateLeadList=new List<Lead>();
        
        for(DuplicateRecordItem dri:[SELECT Id,Record.Name,RecordId,DuplicateRecordSet.Name,DuplicateRecordSetId,CreatedDate,Name 
                                     FROM DuplicateRecordItem]){
                                         if(dri.RecordId==leadid){
                                             DRS_set.add(dri.DuplicateRecordSetId);
                                         }
                                     }   
        
        /* DuplicateRule Lead_LeadToAccountRules=[SELECT Id,CreatedDate,DeveloperName,MasterLabel,NamespacePrefix,SobjectType 
                                                  FROM DuplicateRule 
                                                  WHERE DeveloperName='Lead_Duplicate_Rule' 
                                                  OR DeveloperName='Lead_to_account_Duplicate_Rule'
                                                  LIMIT 2];*/
                                                            
        getDuprecords();
        
    }
    
    public void getDuprecords(){
        
        Set<Id> LeadSet=new Set<Id>();
        Set<Id> AccountSet=new Set<Id>();
        
        /*DuplicateRecordItemList=[SELECT Id,Record.Name,RecordId,DuplicateRecordSet.Name,DuplicateRecordSetId,CreatedDate,Name 
                                    FROM DuplicateRecordItem WHERE DuplicateRecordSetId IN:DRS_set
                                  ];*/
        
        for(DuplicateRecordItem DRI:[SELECT Id,Record.Name,RecordId,DuplicateRecordSet.Name,DuplicateRecordSetId,CreatedDate,Name 
                                     FROM DuplicateRecordItem WHERE DuplicateRecordSetId IN:DRS_set]){
                                         String str=String.valueof(DRI.RecordId);
                                         if(str.startsWith('001')){
                                             AccountSet.add(DRI.RecordId);
                                         }else{
                                             LeadSet.add(DRI.RecordId);  
                                         }
                                     }
        LeadSet.remove(leadId);
        for(Account acc:[SELECT id,Name,Owner.FirstName,Owner.LastName,CreatedDate, Logo_Id__c, Logo_Segment__c, Logo_Status__c FROM Account WHERE Id IN:AccountSet]){
            DuplicateAccountList.add(acc);
        }
        
        for(Lead TempLead:[SELECT id,Name,Owner.FirstName,Owner.LastName,CreatedDate, Status, Product_Interest__c, Company, Lead_No__c FROM Lead WHERE Id IN:LeadSet]){
            DuplicateLeadList.add(TempLead);
        }
        
        if (DuplicateAccountList.IsEmpty()&& DuplicateLeadList.IsEmpty()) {
            renderPage = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'There are no Potential Duplicate Records!'));
        } else{
            if(DuplicateAccountList.IsEmpty()){
               renderPage = true;
               LeadlistRender=true;
               AccountlistRender=false;
            }else if(DuplicateLeadList.IsEmpty()){
                   renderPage = true;
                   LeadlistRender=false;
                   AccountlistRender=true;
                 }else{
                       renderPage = true;
                       LeadlistRender=true;
                       AccountlistRender=true;
                      }
            
        }
        
    }
    
    public List<Account> getAccountRecords(){
        return DuplicateAccountList;
    }
    
    
    public List<Lead> getLeadRecords(){
        return DuplicateLeadList;
    }
}