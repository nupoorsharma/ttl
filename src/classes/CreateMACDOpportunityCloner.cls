/*
 * Name        : CreateMACDOpportunityCloner
 * Description : CreateMACDOpportunityCloner class is used to as controller class for
 *               creating MACD type Opportunity with all related Details
 * Author      : Rahul Mohan (Compro Technologies)
 * Created On  : 6 April 2016
 */
/*
* Change Log History:
* |---------------------------------------------------------------|
* | Version | Changes By | Date   | Description                   |
* |---------------------------------------------------------------|
* |   0.1   | Rahul      | 06-04-16 |Initial version of Class     |
* |   0.2   | Anant      | 01-06-16 |New version of class with    |
* |                                 |VF page related logic        |
* |---------------------------------------------------------------|  
*/
public without sharing class CreateMACDOpportunityCloner{
    public class CustomException extends Exception{}
    
    public String CircuitDelId {get; set;}
    public List<SME_OrderValueBackUpdation__c> circuitDelList;
    public List<Product_Flavor_Type__c> prodSettingList;
    public Set<String> availableTypeSet;
    public String type {get; set;}
    public List<ID> idList {get; set;}
    public Set<ID> opptyOrigIdSet;
    public Set<String> prodNmSet;
    public Set<String> flavorIdSet;
    public Boolean isError;
    public Map<String, ID> FANRecordTypesMap;
    public Map<ID,ID> fanRecordTypeIDMap;   // Map of fan Record Id with its Record Type ID
    public static ID opptyRT;
    public String opptyProdName;
    public Map<String,Feasibility_RecordType_Mapping__mdt> keyMetaRecordMap; //Map of 'Product Name~type~isGC' with metadata Record

    // Constructor for initializing Page referred components
    public CreateMACDOpportunityCloner() {
        isError = false;
        fanRecordTypeIDMap= new Map<ID,ID>();
        keyMetaRecordMap= new Map<String,Feasibility_RecordType_Mapping__mdt>();
        opptyOrigIdSet = new Set<ID>();
        prodNmSet = new Set<String>();
        flavorIdSet = new Set<String>();
        idList = ApexPages.currentPage().getParameters().get('id').split('~');
        prodSettingList = Product_Flavor_Type__c.getAll().values();
        CircuitDelId = ApexPages.currentPage().getParameters().get('id');
        circuitDelList = [SELECT id, Name, Opportunity_Product_Name__c, OpportunityID__c, OpportunityID__r.Green_Channel_Opportunity__c, Feasibility__c, Feasibility__r.Flavor__c, FAN_number__c  FROM SME_OrderValueBackUpdation__c WHERE Id IN :idList];
        validateCircuits();
    }
    
    //Validating the circuits selected
    public void validateCircuits() {
        for (SME_OrderValueBackUpdation__c circuit : circuitDelList) {
            prodNmSet.add(Circuit.Opportunity_Product_Name__c);
            flavorIdSet.add(circuit.Feasibility__r.Flavor__c);
            
            if (String.ISBLANK(circuit.OpportunityID__c) ) {
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Opportunity associated with ' + circuit.Name + ' circuit/del'));
            }
            if (String.ISBLANK(circuit.FAN_number__c)) {
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no FAN associated with ' + circuit.Name + ' circuit/del'));
            }
            if (String.isBlank(circuit.Opportunity_Product_Name__c)) {
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no Product associated with ' + circuit.Name + ' circuit/del'));
            }
        }
        if (flavorIdSet.size() > 1 || prodNmSet.size() > 1) {
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All Circuit/dels should belong to same Product and Flavor'));
        }
    }

    // This method create MACD Type Oppty with Feasibility as per FanNo defined on the Circuit/Del record
    public PageReference CreateMACDOpptyWithFan() {
        System.debug('CreateMACDOpptyWithFan');
        Savepoint sp = Database.setSavepoint();
        try {

            if (isError) {
                PageReference pageRef = new PageReference('/apex/Create_MACDOpportunity?id=' + CircuitDelId );
                return pageRef;
            }


            Map<ID, ID> g2 = new Map<ID, ID>();
            Map<Boolean, List<ID>> gcFanMap= new Map<Boolean, List<ID>>();
            List<ID> fanIdList = new List<ID>();
            for (SME_OrderValueBackUpdation__c circuit : circuitDelList) {

                opptyOrigIdSet.add(circuit.OpportunityID__c);
                g2.put(circuit.Feasibility__c, circuit.Id);
                if(gcFanMap.get(circuit.OpportunityID__r.Green_Channel_Opportunity__c)!=NULL){
                    fanIdList = gcFanMap.get(circuit.OpportunityID__r.Green_Channel_Opportunity__c);
                    fanIdList.add(circuit.Feasibility__c);
                     gcFanMap.put(circuit.OpportunityID__r.Green_Channel_Opportunity__c, fanIdList);
                }
                else{
                    fanIdList = new List<ID>();
                    fanIdList.add(circuit.Feasibility__c);
                     gcFanMap.put(circuit.OpportunityID__r.Green_Channel_Opportunity__c, fanIdList);     
                }
               
            }
             opptyProdName = circuitDelList[0].Opportunity_Product_Name__c;
            // Calling this method to get the feasibilty recordtype id Map
            fanRecordTypeIDMap = getFeasibilityRecordType(opptyProdName, type, gcFanMap,'Feasibility');
            /*
            List<String> prodName = circuitDelList[0].Opportunity_Product_Name__c.split(' ');
            String productName = prodName[0];
            for (Integer i = 1; i < prodName.size(); i++) {
                productName = productName + '_' + prodName[i];
            }
            String opptyRTName = productName + '_' + type;
            */
           // String opptyRTName=Label.Opportunity_MACD_Record_Type_ID;
           // opptyRT=ID.valueOF(Label.Opportunity_MACD_Record_Type_ID);
           
            opptyRT = getOpptyRecordType('TTL_MACD_Opportunity');
            
            Map<ID, ID> ExistingAndCloned = new Map<ID, ID>();
            List<Opportunity> opportunityNewList;
            ID fanRecordTyID;

            Map<ID, String> g1 = new Map<ID, String>();
            opportunityNewList = cloneMACDOpportunity(opptyOrigIdSet, true, opptyRT, 'Identified'); 
            //Map Existing Opportunityy Id to Cloned Opportunity Id to reparent child related Objects.
            for (Opportunity opp : opportunityNewList) {
                ExistingAndCloned.put( opp.Cloned_From__c , opp.Id );
            }
            System.Debug(LoggingLevel.DEBUG , 'Cloning Products...........');
            // Clone Product from Old Oppty to newly created Oppty
            List<ID> g3 = new List<ID>();
            for (Id opptyId : opptyOrigIdSet)
                g3.add(opptyId);
            cloneMACDOpportunityProduct(g3, ExistingAndCloned);
            
            //Feasibility needs not to be cloned for 'Rate Revision' and 'Addendum'
            if( !type.equalsIgnoreCase('RateRevision') && !type.equalsIgnoreCase('Addendum') 
               && !type.equalsIgnoreCase('Agreement Renewal with RateRevision')  &&  !type.equalsIgnoreCase('Agreement Renewal') )
            {
                List<Feasibility__c> newfanLst = cloneFeasibility(ExistingAndCloned, g2 , fanRecordTypeIDMap);
                //insert fan
                if (newfanLst.size() > 0) {
                    insert newfanLst;
                }
    
                //Creating a Map of ID's of ExistingFAN and Cloned FAN
                Map<ID, ID> existingAndClonedFan = new Map<ID, ID>();
                for (Feasibility__c f : newfanLst) {
                    existingAndClonedFan.put(f.Cloned_From__c, f.Id);
                }
                List<Drop__c> newDropList = cloneDrops(existingAndClonedFan);
    
                if (newDroplist.size() > 0)
                    insert newDroplist;
            }
            else if( type.equalsIgnoreCase('RateRevision') || type.equalsIgnoreCase('Addendum') 
                    || type.equalsIgnoreCase('Agreement Renewal with RateRevision')
                    || type.equalsIgnoreCase('Agreement Renewal'))
            {
                //Clone BC
                //Clone FAN BC
                //Clone CPE
                cloneBC(g2, ExistingAndCloned) ;
                
            }
            System.Debug('Opportunity New List ID : '+opportunityNewList.size());
            // Redirect Call to Newly Created Oppty
            PageReference pg = rediredtToNewOppty(opportunityNewList[0].Id);
            return pg;
        } catch (exception e) {
            System.Debug('Exception : '+e);
            System.Debug('Exception : '+e.getStackTraceString());
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }

    }
     
     // Purpose : This method make clone of Current Circuit/Del referred Opportunity details
     public List<Opportunity> cloneMACDOpportunity(Set<ID> opptyOrigIdSet, Boolean byPassFieldExclusion, ID opptyRecordTyId, String OptyStageName) {
         String key;
        Opportunity opportunityNew = new Opportunity();
        List<Opportunity> opportunityOriginalList = new List<Opportunity>();
        List<Opportunity> opportunityNewList = new List<Opportunity>();

        Schema.DescribeSObjectResult opportunitySObjectType = Opportunity.SObjectType.getDescribe();
        Schema.DescribeFieldResult fieldResult;
        Savepoint sp = Database.setSavepoint();
        //SET<ID> keys = OpportunityToCloneIdFanMap.keySet();
        String whereClause = 'Id IN : opptyOrigIdSet';
        try {
            String query = OpportunityCloner.getCreatableFieldsSOQL('Opportunity', whereClause, byPassFieldExclusion);
            opportunityOriginalList = (List<Opportunity>)Database.query(query);
            for (Opportunity opportunityOriginal : opportunityOriginalList) {
                opportunityNew = opportunityOriginal.clone(false, true, false, false);
                OpportunityNew.Cloned_From__C = opportunityOriginal.ID;
                OpportunityNew.StageName = OptyStageName ;
                OpportunityNew.Probability = 10 ;
                OpportunityNew.SOID_Created_in_Empower__c=False;
                OpportunityNew.Block_SOID__c=False;
                OpportunityNew.Execute_Create_SOID__c=False;
                OpportunityNew.RecordTypeID = opptyRecordTyId ;
                key=opptyProdName+'~'+type+'~'+opportunityOriginal.Green_Channel_Opportunity__c;
                if(keyMetaRecordMap.get(key)!=null)
                {
                 
                opportunityNew.type=keyMetaRecordMap.get(key).Opportunity_Type__c;
                opportunityNew.MACD_Type__c=keyMetaRecordMap.get(key).MACD_Type__c;
                opportunityNew.BC_MACD_Type__c = keyMetaRecordMap.get(key).BC_MacD_Type__c ;
                opportunityNew.MACD_Scenario__c = keyMetaRecordMap.get(key).MACD_Scenario__c ;
                }
                opportunityNew.pricebook2id=null;
                if (OpportunityNew.CloseDate < System.today())
                    OpportunityNew.CloseDate = System.today();
                opportunityNewList.add(opportunityNew);
            }
            if (opportunityNewList.size() > 0)
                insert opportunityNewList;
        
        } catch (exception ex) {
            system.debug(ex.getMessage());
            Database.rollback(sp);
        }
        return opportunityNewList;
    }

    /* Changed by Nupoor
     * cloneMACDOpportunityProduct()
     * Purpose -- Add Opportunity Products for the Cloned Opportunities , 
     *            but from the "MacD All Products" PriceBook (Is_MacD_PriceBook = true)
     */
    public void cloneMACDOpportunityProduct(List<ID> oldOpptyIDSet, Map<ID, ID> ExistingAndCloned) {
        //OpportunityCloner.cloneOpportunityProduct(oldOpptyIDSet , ExistingAndCloned);
        /* All Products to be added with PBE under MACD PriceBook */
        PriceBook2 MACDPriceBook = [Select Id from PriceBook2 where Is_MACD_PriceBook__c=true Limit 1];
        if( MACDPriceBook != null )
        {
            String whereClause = 'opportunityID IN :oldOpptyIDSet ';
            String query = OpportunityCloner.getCreatableFieldsSOQL('OpportunityLineItem', whereClause, FALSE); 
            query = query.replace(' FROM OpportunityLineItem', ',Product2ID FROM OpportunityLineItem') ;
            List<OpportunityLineItem> OriginalProducts =(List<OpportunityLineItem>)Database.query(query);
            Set<ID> ProductSet = new Set<ID>();
            for(OpportunityLineItem OldOLI : OriginalProducts)
            { ProductSet.add( OldOLI.Product2ID );
            }
            List<PriceBookEntry> PBEList = [SELECT Id, product2ID, PriceBook2Id from PriceBookEntry where PriceBook2Id = :MACDPriceBook.id and Product2ID IN :ProductSet];
            MAP<ID, ID> Product2_PBE_Map = new MAP<ID, ID>();
            for( PriceBookEntry PBE : PBEList)
                Product2_PBE_Map.put( PBE.product2ID , PBE.Id );
            
            OpportunityLineItem newProduct = new OpportunityLineItem();
            List<OpportunityLineItem> ClonedProducts = new List<OpportunityLineItem>();
            for(OpportunityLineItem oppProduct : OriginalProducts)
            {
                newProduct = oppProduct.clone(false,true,false,false);
                if( (ExistingAndCloned.get(newProduct.OpportunityId) != null) && (Product2_PBE_Map.get(oppProduct.product2id)!=null ) )
                {
                    newProduct.OpportunityId = ExistingAndCloned.get(newProduct.OpportunityId) ;
                    newProduct.TotalPrice=null;
                    newProduct.PricebookEntryId = Product2_PBE_Map.get(oppProduct.product2id) ;
                    ClonedProducts.add(newProduct);
                }
            }
            if(ClonedProducts.size() > 0)
                try{  
                    insert ClonedProducts;
                    }
            catch(Exception e)
                 { System.Debug(LoggingLevel.ERROR ,'########## Products Exception : ' +e);
                    CustomException exptn = new CustomException();
                    exptn.setMessage('System failed to clone the Opportunity Product.');
                    throw exptn;
                 }
        }
    }
    
    
    // Purpose : This method make clone of Current Circuit/Del referred Opportunity related Feasibility 
    public static List<Feasibility__c> cloneFeasibility(Map<ID, ID> ExistingAndCloned, Map<ID, ID> FanNo_CircuitID_Map, Map<ID, ID> fanRecordTypeIDMap) {
       FanDefaultValues fanDefault=new FanDefaultValues();
        Set<ID> keySet = FanNo_CircuitID_Map.keySet();
        String whereClause = 'ID IN : keySet';
        String query =  OpportunityCloner.getCreatableFieldsSOQL('Feasibility__c', whereClause, false);
        query = query.Replace('FROM Feasibility__c', ',Media_A_AMT__c,Media_B_AMT__c,Network_Type_A_AMT__c,Network_Type_B_AMT__c FROM Feasibility__c');
        List<Feasibility__c> lst_fan = (List<Feasibility__c>)Database.query(query);
        List<Feasibility__c> newfanLst = new List<Feasibility__c>();
        for (Feasibility__c fan : lst_fan) {
            Feasibility__c f =  fan.clone(false, true, false, false);
            f.Opportunity__c = ExistingAndCloned.get(fan.Opportunity__c);
            f.FAN_Number__c = '';
            f.Add_to_BC__c = False;
            f.Feasibility_Status__c = NULL;
            f.Approval_Status__c = '';
            f.Approval_Submitted_Date__c = NULL;
            f.Last_Approval_Date__c = NULL;
            f.FAN_Number__c = '';
            f.Feasibility_AMT_Status_2__c = '';
            f.Resubmit_to_AMT__c = False;
            f.Return_to_AMT_Reason__c = '';
            f.Submit_to_AMT__c = False;
            f.Cloned_From__c = fan.Id;
            System.Debug('#### recordType On FAN : '+fanRecordTypeIDMap.get(fan.Id));
            f.RecordTypeID = fanRecordTypeIDMap.get(fan.Id);
            f.Circuit_Del__c = FanNo_CircuitID_Map.get(fan.id);
            f.MACD_Reference_FAN__c = fan.Id;
            //Added on 11-Jun-2016: MACD FAN's should never have Mulit-Media as Yes. Parent FAN should also be blank.
             if ( f.Is_Multimedia_FAN__c == 'Y')
             {
                f.Is_Multimedia_FAN__c = 'N';
                f.Parent_Feasibility__c = null;
            }

            //Added on 16-Jun-2016: The Media Type and Network Type should be updated as AMT Update on the original FAN
            if (String.IsNotblank(fan.Media_A_AMT__c))
                f.Preferred_Media_A_End__c = fan.Media_A_AMT__c;
            
            if (String.IsNotblank(fan.Media_B_AMT__c)) 
                f.Preferred_Media_B_End__c =  fan.Media_B_AMT__c;
            
            if (String.IsNotblank(fan.Network_Type_A_AMT__c)) 
                f.Network_Type__c = fan.Network_Type_A_AMT__c;
            
            if (String.IsNotblank(fan.Network_Type_B_AMT__c)) 
                f.Point_B_Network_Type__c = fan.Network_Type_B_AMT__c;


            f=fanDefault.setDefaults(f);
            if(String.ISNOtBlank(f.Opportunity__c))
            newfanLst.add(f);
        }
        return newfanLst;
    }

    /*  Purpose : This Part will Clone the Drop__C records under Cloned Feasibility records*/
    public List<Drop__c> cloneDrops(Map<ID, ID> existingAndClonedFanMap) {
        List<Drop__c> ClonedDrops = new List<Drop__c>();
        Drop__c newDrop = new Drop__c();
        Set<ID> keySet = existingAndClonedFanMap.keySet();
        String whereClause3 = 'Feasibility__c IN :keySet';
        String query3 = OpportunityCloner.getCreatableFieldsSOQL('Drop__c', whereClause3, FALSe);
        List<Drop__c> OriginalDrops = (List<Drop__c>)Database.query(query3);
        for (Drop__c d : OriginalDrops) {
            newDrop = d.clone(false, true, false, false);
            if ( existingAndClonedFanMap.get(d.Feasibility__c) != null )
                newDrop.Feasibility__c = existingAndClonedFanMap.get(d.Feasibility__c);
            ClonedDrops.add( newDrop ) ;
        }
        return clonedDrops;
    }
    
    /*
     * CloneBC()
     * Purpose : Clones BC , FAN BC and CPE Details for MacD Scenarios - Renewal and Addendum
     *           FANBC will have the same FAN as found on the Circuit
     */
    public void CloneBC(Map<ID, ID> FAN_Circuit_Map, Map<ID, ID> ExistingAndCloned) 
    {
        try{
            //Set of Cloned Opportunities
            Set<ID> Opportunity_ID_Set = new Set<ID>();
            for(ID opportunityID : ExistingAndCloned.keySet())
                Opportunity_ID_Set.add(ExistingAndCloned.get(opportunityID));
            //Get the SOID values for the Cloned Opporetunities
            Map<ID, Opportunity> Opportunity_Map = new Map<ID, Opportunity>([Select ID, SOID__c from Opportunity where ID IN :Opportunity_ID_Set]);
            //Get the List of to-be-cloned FAN BC records with Feasibility and Opportunity as mentioned on the circuit
            List<FAN_BC__c> ToBeCloned_FAN_BC = [Select ID, Business_Case__c, Feasibility__c 
                                                 from FAN_BC__c 
                                                 where Feasibility__c IN :FAN_Circuit_Map.keySet() and Business_Case__r.Opportunity__c IN :ExistingAndCloned.keyset()];
            //Collect the set of Parent BC Records which need to be cloned
            Set<ID> ToBeCloned_BC = new Set<ID>();
            for(FAN_BC__c obj : ToBeCloned_FAN_BC)
              ToBeCloned_BC.add(obj.Business_Case__c);
            
             /* *** **    Clone  BC    ** *** */
             String whereClause = 'Id IN :ToBeCloned_BC ';
             String query = OpportunityCloner.getCreatableFieldsSOQL('Business_Case__c', whereClause, false);
             List<Business_Case__C> BCList = Database.query(query);
            //This list of BC will be inserted
            List<Business_CAse__c> CloneBCList = new List<Business_case__C>();
            for(Business_Case__c bc : BCList)
            {
                Business_Case__c BCaseNew = new Business_Case__c();
                BCaseNew.Key__c = Opportunity_Map.get(ExistingAndCloned.get(bc.Opportunity__c)).SOID__c;
                BCaseNew.Opportunity__c = ExistingAndCloned.get(bc.Opportunity__c) ;
                BCaseNew.Product__c = bc.Product__c ;
                BCaseNew.Variant__c = bc.Variant__c ;
                BCaseNew.Source_of_Sale__c = bc.Source_of_Sale__c ;
                BCaseNew.Payment_Terms__c = bc.Payment_Terms__c ;
                BCaseNew.Billing_Cycle__c = bc.Billing_Cycle__c ;
                BCaseNew.AdvanceArrears__c = bc.AdvanceArrears__c ;
                BCaseNew.One_Time_Acquisition_Cost__c = bc.One_Time_Acquisition_Cost__c ;
                BCaseNew.Link_Contract_Period__c = bc.Link_Contract_Period__c ;
                BCaseNew.Effective_Date__c = bc.Effective_Date__c ;
                BCaseNew.Business_Case__c = bc.id ;
                BCaseNew.Sponsored_CPE_Required__c = bc.Sponsored_CPE_Required__c ;
                BCaseNew.RecordTypeId = bc.RecordTypeId ;
                CloneBCList.add(BCaseNew);
            }
            insert CloneBCList;
            Map<ID, ID> ExistingandClonedBC = new Map<ID, ID>();
            for(Business_Case__c BCaseNew : CloneBCList)
               ExistingandClonedBC.put(BCaseNew.Business_Case__c, BCaseNew.id);
            
            
            /* *** ** Clone FAN BC ** *** */
            MAP<ID, Business_CAse__c> BC_MAP = new  Map<ID, Business_Case__c>([Select ID, Product__r.FAN_Category__c from Business_CAse__c where id in :CloneBCList]);
            String whereClause2 = 'ID IN :ToBeCloned_FAN_BC';
            String query2 = OpportunityCloner.getCreatableFieldsSOQL('FAN_BC__c', whereClause2, false);
            List<FAN_BC__c> FANBCList = Database.query(query2);
            List<FAN_BC__c> CloneFANBCList = new List<FAN_BC__c>();
            for(FAN_BC__C fanbc : FANBCList)
            {
                FAN_BC__c New_fanbc = fanbc.clone(false, true, false, false) ;
                New_fanbc.Business_Case__c = ExistingandClonedBC.get(fanbc.Business_Case__c) ;
                New_fanbc.Fan_BC__c = fanbc.id;
                New_fanbc.Circuit_Del__c = (FAN_Circuit_Map.get(New_fanbc.Feasibility__c)!=Null ? FAN_Circuit_Map.get(New_fanbc.Feasibility__c) : null );
                if(  BC_MAP.get(New_fanbc.Business_Case__c).Product__r.FAN_CAtegory__c != 'NPLC')
                {  //System.Debug('Setting Non NPLC'); 
                   New_fanbc.One_Time_Charges_from_Customer_in_Rs__c  = 0;
                   New_fanbc.OTC_Discount__c = 0;
                   New_fanbc.Installation_And_Testing_Charges__c = 0; 
                }
                else if(  BC_MAP.get(New_fanbc.Business_Case__c).Product__r.FAN_CAtegory__c == 'NPLC' )
                {
                    New_fanbc.One_Time_Charges_from_Customer_Point_A__c = 0;
                    New_fanbc.One_Time_Charges_from_Customer_Point_B__c = 0;
                    New_fanbc.OTC_Discount_Point_A__c =0;
                    New_fanbc.OTC_Discount_B_in__c =0;
                    New_fanbc.Installation_Testing_Charges_Point_A__c = 0;
                    New_fanbc.Installation_And_Testing_Charges_B__c = 0;
                }
                CloneFANBCList.add( New_fanbc ) ;
            }
            insert CloneFANBCList;
            Map<ID, ID> ExistingandClonedFANBC = new Map<ID, ID>();
            for( FAN_BC__C New_fanbc : CloneFANBCList)
                ExistingandClonedFANBC.put(New_fanbc.Fan_BC__c, New_fanbc.id);
            
            
            /* *** ** Clone CPE ** *** */
            String whereClause3 = 'Fan_BC__c IN :ToBeCloned_FAN_BC ';
            String query3 = OpportunityCloner.getCreatableFieldsSOQL('CPE_Details__c', whereClause3, false);
            List<CPE_Details__c> CPEDetailsList = Database.query(query3);
            List<CPE_Details__c> CloneCPEList = new List<CPE_Details__c>();
            for( CPE_Details__c cpe : CPEDetailsList)
            {
                CPE_Details__c New_CPE = cpe.clone(false, true, false, false) ;
                New_CPE.Fan_BC__c = ExistingandClonedFANBC.get(cpe.Fan_BC__c);
                CloneCPEList.add(New_CPE);
            }
            insert CloneCPEList;
        }
        catch(Exception e)
        {
            System.Debug(LoggingLevel.ERROR , '############ Exception from Clone BC');
            System.Debug(e);
            System.Debug(e.getStackTraceString());
            CustomException exptn = new CustomException();
            exptn.setMessage('System failed to clone Business Case.');
            throw exptn;
        }
    }
    


    /* Purpose : Query Circuit/Del referred Opportunity RecordType */
    public ID getOpptyRecordType(String rtName) {
        RecordType rt = [SELECT Id, RecordType.DeveloperName FROM RecordType WHERE RecordType.DeveloperName = :rtName and SObjectType = 'Opportunity' LIMIT 1];
        return rt.id;
    }

    //This method returns the Set of Type that belongs to that product and flavor (Added By Anant)
    public Set<String> getType() {
        availableTypeSet = new Set<String>();
        String product = circuitDelList[0].Opportunity_Product_Name__c;
        String flavor = circuitDelList[0].Feasibility__r.Flavor__c;
        for (Product_Flavor_Type__c p : prodSettingList) {
            if (p.Product__c.equalsIgnoreCase(product) && p.Flavor__c.equalsIgnoreCase(flavor) && !String.isBlank(p.Type__c))
                availableTypeSet.add(p.Type__c);
        }
        return availableTypeSet;
    }
    
    // Method generating listOption    (Added By Anant)
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for (String s : getType()) {
            options.add(new SelectOption(s, s));
        }
        return options;
    }

    public PageReference back() {
        PageReference circuitPage;
        circuitPage = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
        circuitPage.setRedirect(true);
        return circuitPage;
    }

    public PageReference rediredtToNewOppty(ID opptyID) {
        PageReference OpptyPage;
        OpptyPage = new PageReference('/' + opptyID);
        OpptyPage.setRedirect(true);
        return OpptyPage;
    }

    /* This method is Creating two maps: fanRecordTypeIDMap, keyMetaRecordMap
    fanRecordTypeIDMap: Map of fanRecordId with its Record Type
    keyMetaRecordMap: Map of key with metadataRecord where key = productName+'~'+type+'~'+metaRecord.Is_GC__c
    
     This Method returns the Map of oldFanId with new RecordType Id 
     */
     public Map<ID, ID> getFeasibilityRecordType(String productName, String type, Map<Boolean, List<ID>> gcFanMap, String Obj){
        initializeRecordTypeMap();
         System.Debug('#### productName: '+productName) ;
        String key;
        try{
           
        List<Feasibility_RecordType_Mapping__mdt> metaRecordList = [Select Id, Product_Name__c, Opportunity_Type__c, Feasibility_RecordType__c, BC_RecordType__c, FAN_BC_RecordType__c, AV_CV_Record_Type__c, Is_GC__c,
                                                                    BC_MacD_Type__c, MACD_Type__c, MACD_Scenario__c
                                                          from Feasibility_RecordType_Mapping__mdt  
                                                          where Product_Name__c = :productName and MACD_Scenario__c LIKE :type and Is_GC__c IN :gcFanMap.keySet() 
                                                          ];
        System.Debug(LoggingLevel.ERROR, '###### metaRecordList :'+ metaRecordList);
        for(Feasibility_RecordType_Mapping__mdt metaRecord: metaRecordList){
            key=productName+'~'+type+'~'+metaRecord.Is_GC__c;
                keyMetaRecordMap.put(key, metaRecord);

            if( Obj == 'Feasibility' && String.IsNotblank(MetaRecord.Feasibility_RecordType__c) 
            && FANRecordTypesMap.get(MetaRecord.Feasibility_RecordType__c.toLowerCase()) != null 
               && gcFanMap != NULL && gcFanMap.get(metaRecord.Is_GC__c) !=NULL)
            {
              for(ID fId: gcFanMap.get(metaRecord.Is_GC__c)){
                fanRecordTypeIDMap.put(fId, FANRecordTypesMap.get(metaRecord.Feasibility_RecordType__c.toLowerCase()));
              }
            }
            System.Debug('######## FANRecordTypeMAp : '+ fanRecordTypeIDMap) ;
        }
        }
        catch(Exception e)
        {
            System.Debug(e);
        }
        return fanRecordTypeIDMap;
    }

    //Initialize the RecordType Map for FAN
    public void initializeRecordTypeMap()
    {    
        FANRecordTypesMap = new Map<String,ID>();
        //Populate the Maps with Developer Name of recordtype as key and recordtypeid as value.
        List<RecordType> AllRecordtypes = [Select Id, DeveloperName , SobjectType, IsActive 
                                           from RecordType 
                                           where SobjectType IN ('Feasibility__c')] ;
      
        for(RecordType r : AllRecordtypes)
        {
            if(r.SobjectType == 'Feasibility__c')
                FANRecordTypesMap.put(r.DeveloperName.toLowerCase() , r.Id);
           
        }
    }
}