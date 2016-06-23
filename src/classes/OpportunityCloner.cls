/*
    * Name: OpportunityCloner Class
    * Created On: January 27, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from VF Page CloneOpportunity
    *              Capable of handling a list of Opportunity IDs; 
    * 			   CloneSingular method is used to clone a single Opportunity.
    *              Purpose : Used to clone an opportunity along with the 
    * 							Opportunity Products, 
    * 						    Opportunity Contact Roles, 
    * 							Opportunity Team Members
    * 							and Opportunity Shares.
    *						 The Feasibility records with no BC on them are reparented 
	*					     to the cloned Opportunity.                          
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 27-01-16 |Initial version of Class  |
    * |------------------------------------------------------------|
*/
global without sharing  class OpportunityCloner {
    public class CustomException extends Exception{}
    public static List<Opportunity> cloneOpportunity(List<ID> OpportunityToCloneIdSet, Boolean byPassFieldExclusion) 
    {

        Opportunity opportunityNew = new Opportunity();
        List<Opportunity> opportunityOriginalList = new List<Opportunity>();
        List<Opportunity> opportunityNewList = new List<Opportunity>();

        Schema.DescribeSObjectResult opportunitySObjectType = Opportunity.SObjectType.getDescribe();

        Schema.DescribeFieldResult fieldResult;
        Savepoint sp = Database.setSavepoint();

        String whereClause = 'Id IN :OpportunityToCloneIdSet ';
        system.debug('WhereClause: ' + whereClause);

        try {
            String query = getCreatableFieldsSOQL('Opportunity', whereClause, byPassFieldExclusion);            
            system.debug('Opportunity query: ' + query);

            opportunityOriginalList = (List<Opportunity>)Database.query(query);
            for(Opportunity opportunityOriginal : opportunityOriginalList)
            {

                opportunityNew = opportunityOriginal.clone(false,true,false,false);
                OpportunityNew.Cloned_From__C = opportunityOriginal.ID;
                OpportunityNew.StageName = 'Identified' ;
                OpportunityNew.Probability = 10 ;
                if(OpportunityNew.CloseDate < System.today())
                    OpportunityNew.CloseDate = System.today();
                opportunityNewList.add(opportunityNew); 
                
            }

            if(opportunityNewList.size() > 0)
             insert opportunityNewList;
           System.Debug('opportunityNewList' + opportunityNewList)   ; 
            
            Map<ID,ID> ExistingAndCloned = new Map<ID, ID>();
            //Map Existing Opportunityy Id to Cloned Opportunity Id to reparent child related Objects.
            for(Opportunity opp : opportunityNewList)
                ExistingAndCloned.put( opp.Cloned_From__c , opp.Id );
            
           OpportunityCloner.cloneOpportunityContactRole(OpportunityToCloneIdSet , ExistingAndCloned);
           OpportunityCloner.cloneOpportunityProduct(OpportunityToCloneIdSet , ExistingAndCloned);
           OpportunityCloner.cloneOpportunityTeamMember(OpportunityToCloneIdSet , ExistingAndCloned);
           OpportunityCloner.cloneOpportunityShare(OpportunityToCloneIdSet , ExistingAndCloned);
           OpportunityCloner.cloneFeasibility(OpportunityToCloneIdSet , ExistingAndCloned);

        } catch (exception ex) {
            system.debug(ex.getMessage());
            Database.rollback(sp);
            CustomException exptn = new CustomException();
            exptn.setMessage(ex.getMessage());
            throw exptn;
        }

        return opportunityNewList;
    }


    public static String getCreatableFieldsSOQL(String objectName, String whereClause, Boolean byPassFieldExclusion) {

        //Fetch the fields that will not be copied from the original object
        Set<String> fieldsToExclude = new Set<String>();

        //if byPassFieldExclusion = FALSE, exclude fields according to the Field Set
        if (!byPassFieldExclusion) {
            for (Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.CloneSet.getFields()) {
                fieldsToExclude.add(f.getFieldPath());
            }
        }
       
        Schema.DescribeFieldResult tempResult;
        String selects = '';
        if (whereClause == null || whereClause == '') { return null; }
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        List<string> selectFields = new List<string>();
        if (fMap != null) {
            for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable() && !fd.isUnique()) { // field is creatable
                    if (!fieldsToExclude.contains(fd.getName())) {
                        selectFields.add(fd.getName());
                    }
                }
            }
        }

        system.debug('Fields to clone: ' + selectFields);
        if (!selectFields.isEmpty()) {
            for (string s : selectFields) {
                selects += s + ',';
            }
            if (selects.endsWith(',')) {selects = selects.substring(0, selects.lastIndexOf(','));}
        }

        String query = 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        return query;
    }
    
    public static void cloneOpportunityContactRole(List<ID> OpportunityToCloneIdSet, Map<ID,ID> ExistingAndCloned)
    {
        //Clone opportunityContactRoles
          
         String whereClause = 'opportunityID IN :OpportunityToCloneIdSet';
       
            String query = getCreatableFieldsSOQL('OpportunityContactRole', whereClause, TRUE);            
            system.debug('OpportunityConatcts query: ' + query);
            List<OpportunityContactRole> OriginalContactRoles =(List<OpportunityContactRole>)Database.query(query);
            System.Debug(OriginalContactRoles);
            OpportunityContactRole newContactRole = new OpportunityContactRole();
            List<OpportunityContactRole> ClonedContactRoles = new List<OpportunityContactRole>();
            for(OpportunityContactRole oppContact : OriginalContactRoles)
            {
                newContactRole = oppContact.clone(false,true,false,false);
                if( ExistingAndCloned.get(newContactRole.OpportunityId) != null )
                {
                    newContactRole.OpportunityId = ExistingAndCloned.get(newContactRole.OpportunityId) ;
                    ClonedContactRoles.add(newContactRole);
                }
            }
            if(ClonedContactRoles.size() > 0)
                insert ClonedContactRoles;
        
    }
   
    public static void cloneOpportunityProduct(List<ID> OpportunityToCloneIdSet, Map<ID,ID> ExistingAndCloned)
    {
        //Clone opportunityProducts
          
         String whereClause = 'opportunityID IN :OpportunityToCloneIdSet ';
       
            String query = getCreatableFieldsSOQL('OpportunityLineItem', whereClause, FALSE);            
            system.debug('OpportunityProducts query: ' + query);
            List<OpportunityLineItem> OriginalProducts =(List<OpportunityLineItem>)Database.query(query);
            System.Debug(OriginalProducts);
            OpportunityLineItem newProduct = new OpportunityLineItem();
            List<OpportunityLineItem> ClonedProducts = new List<OpportunityLineItem>();
            for(OpportunityLineItem oppProduct : OriginalProducts)
            {
                newProduct = oppProduct.clone(false,true,false,false);
                if( ExistingAndCloned.get(newProduct.OpportunityId) != null )
                {
                    newProduct.OpportunityId = ExistingAndCloned.get(newProduct.OpportunityId) ;
                    newProduct.TotalPrice=null;
                    ClonedProducts.add(newProduct);
                }
            }
        
            if(ClonedProducts.size() > 0)
                insert ClonedProducts;
        
    }
    
    public static void cloneOpportunityTeamMember(List<ID> OpportunityToCloneIdSet, Map<ID,ID> ExistingAndCloned)
    {
        //Clone opportunityTeamMembers
         
         String whereClause = 'opportunityID IN :OpportunityToCloneIdSet ';
       
            String query = getCreatableFieldsSOQL('OpportunityTeamMember', whereClause, TRUE);            
            system.debug('OpportunityTeamMember query: ' + query);
            List<OpportunityTeamMember> OriginalTeamMembers =(List<OpportunityTeamMember>)Database.query(query);
            System.Debug(OriginalTeamMembers);
            OpportunityTeamMember newTeamMember = new OpportunityTeamMember();
            List<OpportunityTeamMember> ClonedTeamMembers = new List<OpportunityTeamMember>();
            for(OpportunityTeamMember oppTeamMember : OriginalTeamMembers)
            {
                newTeamMember = oppTeamMember.clone(false,true,false,false);
                if( ExistingAndCloned.get(newTeamMember.OpportunityId) != null )
                {
                    newTeamMember.OpportunityId = ExistingAndCloned.get(newTeamMember.OpportunityId) ;
                    ClonedTeamMembers.add(newTeamMember);
                }
            }
            if(ClonedTeamMembers.size() > 0)
                Database.SaveResult[] clonedList = Database.insert(ClonedTeamMembers,false);
        
    }
    
    public static void cloneOpportunityShare(List<ID> OpportunityToCloneIdSet, Map<ID,ID> ExistingAndCloned)
    {
        //Clone opportunityShare
         
         String whereClause = 'opportunityID IN :OpportunityToCloneIdSet ';
       
            String query = getCreatableFieldsSOQL('OpportunityShare', whereClause, TRUE);            
            system.debug('OpportunityShares query: ' + query);
            List<OpportunityShare> OriginalShares =(List<OpportunityShare>)Database.query(query);
            System.Debug(OriginalShares);
            OpportunityShare newShare = new OpportunityShare();
            List<OpportunityShare> ClonedShares = new List<OpportunityShare>();
            for(OpportunityShare oppShare : OriginalShares)
            {
                newShare = oppShare.clone(false,true,false,false);
                if( ExistingAndCloned.get(newShare.OpportunityId) != null && newShare.OpportunityAccessLevel != 'All')
                {
                    newShare.OpportunityId = ExistingAndCloned.get(newShare.OpportunityId) ;
                    newShare.RowCause=null;
                    ClonedShares.add(newShare);
                }
            }
        System.Debug('Cloning the Opportunity Shares :: '+ClonedShares);
            if(ClonedShares.size() > 0)
                Database.SaveResult[] srList = Database.insert(ClonedShares, false);//Database method to insert the records in List
    }
    
    public static void cloneFeasibility(List<ID> OpportunityToCloneIdSet, Map<ID,ID> ExistingAndCloned)
    {
        //Clones Feasibility, Feasibility Status and Drops.
          
         String whereClause = 'Opportunity__c IN :OpportunityToCloneIdSet and Add_to_Bc__c = false and Feasibility_Status__c != null';
       
            String query = getCreatableFieldsSOQL('Feasibility__c', whereClause, FALSe);            
            system.debug('Feasibility__c query: ' + query);
            List<Feasibility__c> OriginalFeasibility =(List<Feasibility__c>)Database.query(query);
            System.Debug(OriginalFeasibility);
            List<ID> Feasibility_Status_ID_List = new List<ID>();
            List<Feasibility__c> ClonedFeasibility = new List<Feasibility__c>();
            Feasibility__c newFeasibility = new Feasibility__c();
            for(Feasibility__c fan : OriginalFeasibility)
            {
                newFeasibility = fan.clone(false,true,false,false);
                if( ExistingAndCloned.get(fan.Opportunity__C) != null )
                {
                    newFeasibility.Opportunity__c = ExistingAndCloned.get(fan.Opportunity__c) ;
                    newFeasibility.Cloned_From__c = fan.Id ;
                    ClonedFeasibility.add(newFeasibility);
                    Feasibility_Status_ID_List.add(fan.Feasibility_Status__c);
                }
            }
            if(ClonedFeasibility.size() > 0)
            {  insert ClonedFeasibility;
                Map<ID,ID> ExistingAndClonedFeasibility = new Map<ID, ID>();
                for(Feasibility__c f : ClonedFeasibility)
                        ExistingAndClonedFeasibility.put( f.Cloned_From__c , f.Id );
        
        
        /*This Part will Clone the Feasibility_Status__c records which were accepted*/
             List<Feasibility_Status__c> ClonedFeasibilityStatus = new List<Feasibility_Status__c>();
             Feasibility_Status__c newFeasibilityStatus = new Feasibility_Status__c();
            String whereClause2 = 'Id IN :Feasibility_Status_ID_List';
            String query2 = getCreatableFieldsSOQL('Feasibility_Status__c', whereClause2, FALSe);            
            system.debug('Feasibility_Status__c query: ' + query2);
            List<Feasibility_Status__c> OriginalFeasibilityStatus =(List<Feasibility_Status__c>)Database.query(query2);
            for(Feasibility_Status__c FS : OriginalFeasibilityStatus)
            { 
                newFeasibilityStatus = FS.clone(false,true,false,false);
                if( ExistingAndClonedFeasibility.get(FS.Feasibility__c) != null )
                  newFeasibilityStatus.Feasibility__c = ExistingAndClonedFeasibility.get(FS.Feasibility__c);
                if( ExistingAndCloned.get(FS.Sfdc_Oppactual_Id__c) != null  )
             	  newFeasibilityStatus.Sfdc_Oppactual_Id__c = ExistingAndCloned.get(FS.Sfdc_Oppactual_Id__c) ;
                newFeasibilityStatus.Cloned_From__c = FS.Id;
                ClonedFeasibilityStatus.add( newFeasibilityStatus );
                
            }
                   
        insert ClonedFeasibilityStatus;
             /*This Part will update the Accepted Feasibility Status on Cloned Feasibility Records.*/
             Map<ID,ID> ExistingAndClonedFeasibilityStatus = new Map<ID, ID>();
                for(Feasibility_Status__c f : ClonedFeasibilityStatus)
                        ExistingAndClonedFeasibilityStatus.put( f.Cloned_From__c , f.Id );
             for(Feasibility__c updateFAN: ClonedFeasibility)
                 if( ExistingAndClonedFeasibilityStatus.get( updateFAN.Feasibility_Status__c ) != null )
                    updateFAN.Feasibility_Status__c = ExistingAndClonedFeasibilityStatus.get( updateFAN.Feasibility_Status__c ) ;
        update ClonedFeasibility;
             
             /*This Part will Clone the Drop__C records under Cloned Feasibility records*/
             List<Drop__c> ClonedDrops = new List<Drop__c>();
             Drop__c newDrop = new Drop__c();
             String whereClause3 = 'Feasibility__c IN :OriginalFeasibility';
             String query3 = getCreatableFieldsSOQL('Drop__c', whereClause3, FALSe);            
             system.debug('Drop__c query: ' + query3);
             List<Drop__c> OriginalDrops =(List<Drop__c>)Database.query(query3);
             for(Drop__c d : OriginalDrops)
             { 
                newDrop = d.clone(false,true,false,false);
                if( ExistingAndClonedFeasibility.get(d.Feasibility__c) != null )
                  newDrop.Feasibility__c = ExistingAndClonedFeasibility.get(d.Feasibility__c);
                ClonedDrops.add( newDrop ) ;
                
             }
       insert ClonedDrops;
             
          }
    }

    WebService static String getBaseURL() {
        return System.URL.getSalesforceBaseURL().getHost();
    }
    
    /*
     * cloneSingular() 
     * a==> ID of the opportunity to be cloned.
     * b==> byPassFieldExclusion (true/false).
     * Called from VF Clone Opportunity to clone a single opportunity
     * Returns the Id of the Cloned Opportunity.
     */
    WebService static String cloneSingular(String a, string b) {
        System.Debug('a: '+a+'\nb:'+b);
        List<ID> x = new List<ID>();
        x.add(a);
        List<Opportunity> OppList = cloneOpportunity(x, Boolean.valueOf(b));
        return OppList[0].id;
    }
}