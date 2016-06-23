/*
 * Name        : BusinessCaseTriggerHandler
 * Description : This class create AV/CV and PO record when BusinessCase is Approved
* 				 It creates a dummy FAN BC record when product BC Category is - {EPABX, Wireless Voice, 3G Dongle}
				 It submit the BC to Empower.
 * Author      : Abhishek Tyagi (Compro Technologies)
 * Created On  : 19 May 2016
 */
public without sharing class BusinessCaseTriggerHandler {
Map<Id,List<Fan_BC__c>> mapOfOpptyFan;
    
    public BusinessCaseTriggerHandler(){
        mapOfOpptyFan =new Map<Id,List<Fan_BC__c>>();
    }
    
    /*
     * createPORecords()
     * Purpose: Creates a Purchase Order for a Business Case Record if 
     *          PO_Process_Applicable__c is checked on the Product.
     *          => Called from Generate PO
     */
    public static List<Purchase_Order__c> createPORecords(List<Business_case__c> bcList){
        Map<Id,business_case__c> bcMap = new Map<id,Business_case__c>([select id,opportunity__c,Product__r.PO_Process_Applicable__c, product__c
                                                                      from Business_case__c where
                                                                      id In :BcList]);
                                                                      
                                                                     
		List<Purchase_Order__c> poList = new List<Purchase_Order__c>();
        for(Business_case__c bc :bcList){
            if(bcMap.containsKey(bc.id) && bcMap.get(bc.Id).Product__r.PO_Process_Applicable__c){
                Purchase_Order__c po = new Purchase_Order__c();
            	po.Tariff__c= bc.id;
            	po.Opportunity__c= bc.opportunity__c;
            	po.Product__c= bc.product__c;
           		poList.add(po);
            }
            
        }
        
        if(poList.size()> 0)
			insert poList;        
        return poList;
    }
    
   
    /*
     * createAV_CVRecords()
     * Purpose: Creates AVCV records per FAN BC for a Business Case Record if 
     *          AVCV_Process_Applicable__c is checked on the Product
     *          and AVCV RecordType is found.
     *          => Called from Generate PO
     */
    public static List<AV_CV__c> createAV_CVRecords(List<Business_Case__c> bc)
    {
        
       System.debug('--------------createAV_CVRecords() ------------');
       List<AV_CV__c> avcv_lst=new List<AV_CV__c>();
        
        // Query all related Fan BC records for associated Approved Business Cases 
       List<Fan_BC__c> fan=[SELECT Id ,Business_Case__c, Feasibility__c, Business_case__r.Product__c, Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c,
                                    Business_Case__r.Opportunity__c, Business_case__r.Product__r.AVCV_Process_Applicable__c,
                            		Business_case__r.Product__r.Name, Business_Case__r.Opportunity__r.Type, Business_Case__r.Opportunity__r.Green_Channel_Opportunity__c,
                                    Feasibility__r.Opportunity__r.MACD_Type__c, Business_Case__r.Opportunity__r.BC_MACD_Type__c, Business_Case__r.Opportunity__r.MACD_Scenario__c,
                                    Feasibility__R.Circuit_Del__r.AV_CV__r.NLD_CAF_No__c, Feasibility__R.Circuit_Del__r.AV_CV__r.Parent_CAF_No__c , 
                                    Feasibility__R.Circuit_Del__r.AV_CV__r.Point_B_CAF_No__c , Feasibility__R.Circuit_Del__r.AV_CV__r.Point_CAF_No__c,
                                    Circuit_Del__r.AV_CV__r.NLD_CAF_No__c, Circuit_Del__r.AV_CV__r.Parent_CAF_No__c , 
                                    Circuit_Del__r.AV_CV__r.Point_B_CAF_No__c , Circuit_Del__r.AV_CV__r.Point_CAF_No__c
                            FROM Fan_BC__c 
                            WHERE Business_Case__c IN:bc];
        
       List<Purchase_Order__c> poList = new List<Purchase_order__c>([select id, Tariff__c from Purchase_order__c where Tariff__c In :bc]);
        System.debug('poList-------'+poList);
       Map<id,Purchase_Order__c> bcPOMap = new map<id,Purchase_Order__c>();
        for(Purchase_order__c po : poList){
            bcPOMap.put(po.Tariff__c,po);
        }
        
        System.debug('bcPoMap------'+bcPOMap);
        
        RaiseFeasibilityController.initializeRecordTypeMap();
        for(Fan_BC__c f:fan)
        {
            system.debug('fanbc-------'+f);
            if(f.Business_case__r.Product__r.AVCV_Process_Applicable__c)
            {
                System.debug('Inside if----- to process');
                AV_CV__c avcv =  new AV_CV__c(FAN_No__c = f.Feasibility__c,
                                        Opportunity__c=f.Business_Case__r.Opportunity__c,
                                        Product__c = f.Business_case__r.Product__c,
                                        Tariff__c = f.Business_Case__c);
                
                //Populate CAF Number Fields in case of MACD Scenarios(Other than RATEREVISION and ADDENDUM).
                if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c 
                    && f.Feasibility__r != Null && String.IsNotBlank(f.Feasibility__r.Opportunity__r.MACD_Type__c)
                    && f.Feasibility__R.Circuit_Del__r != Null && f.Feasibility__R.Circuit_Del__r.AV_CV__r != Null
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'RATEREVISION'
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'AGGREMENTRENEWAL'
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'ADDENDUM'
                    && !f.Feasibility__r.Opportunity__r.MACD_Type__c.equalsIgnoreCase('Upgrade Channel')
                    && !f.Feasibility__r.Opportunity__r.MACD_Type__c.equalsIgnoreCase('Downgrade Channel')
                   )
                {
                    avcv.NLD_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.NLD_CAF_No__c ;
                    avcv.NLD_CAF_Status__c = 'Valid' ;
                    avcv.Parent_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Parent_CAF_No__c ;
                    avcv.Parent_CAF_Status__c = 'Valid' ;
                    avcv.Point_B_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Point_B_CAF_No__c ;
                    avcv.POINT_B_CAF_Status__c = 'Valid' ;
                    avcv.Point_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Point_CAF_No__c ;
                    avcv.POINT_CAF_Status__c = 'Valid' ;
                }
                //Append -1 for Upgrade/Downgrade Channel
                else if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c 
                    && f.Feasibility__r != Null && String.IsNotBlank(f.Feasibility__r.Opportunity__r.MACD_Type__c)
                    && f.Feasibility__R.Circuit_Del__r != Null && f.Feasibility__R.Circuit_Del__r.AV_CV__r != Null
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'RATEREVISION'
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'AGGREMENTRENEWAL'
                    && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'ADDENDUM'
                    && f.Feasibility__r.Opportunity__r.MACD_Type__c.equalsIgnoreCase('Upgrade Channel')
                    && f.Feasibility__r.Opportunity__r.MACD_Type__c.equalsIgnoreCase('Downgrade Channel')
                   )
                {
                    avcv.NLD_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.NLD_CAF_No__c + '-1' ;
                    avcv.NLD_CAF_Status__c = 'Valid' ;
                    avcv.Parent_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Parent_CAF_No__c + '-1';
                    avcv.Parent_CAF_Status__c = 'Valid' ;
                    avcv.Point_B_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Point_B_CAF_No__c + '-1' ;
                    avcv.POINT_B_CAF_Status__c = 'Valid' ;
                    avcv.Point_CAF_No__c = f.Feasibility__R.Circuit_Del__r.AV_CV__r.Point_CAF_No__c + '-1';
                    avcv.POINT_CAF_Status__c = 'Valid' ;
                }
                //Get Caf Numbers from Circuit/Del on FAN BC for RateRevision or ADDENDUM
                else if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c 
                        && f.Circuit_Del__c != Null
                        && (f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'RATEREVISION'
                            || f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'AGGREMENTRENEWAL'
                            || f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'ADDENDUM')
                       )
                {
                    avcv.NLD_CAF_No__c = f.Circuit_Del__r.AV_CV__r.NLD_CAF_No__c ;
                    avcv.NLD_CAF_Status__c = 'Valid' ;
                    avcv.Parent_CAF_No__c = f.Circuit_Del__r.AV_CV__r.Parent_CAF_No__c ;
                    avcv.Parent_CAF_Status__c = 'Valid' ;
                    avcv.Point_B_CAF_No__c = f.Circuit_Del__r.AV_CV__r.Point_B_CAF_No__c ;
                    avcv.POINT_B_CAF_Status__c = 'Valid' ;
                    avcv.Point_CAF_No__c = f.Circuit_Del__r.AV_CV__r.Point_CAF_No__c ;
                    avcv.POINT_CAF_Status__c = 'Valid' ;
                }
                
                
                if(bcPOMap.containsKey(f.Business_Case__c))
                    avcv.purchase_order__c = bcPOMap.get(f.Business_Case__c).Id;
                
                //Get RecordTypeID
                if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c == false )
             	  	avcv.RecordTypeId = RaiseFeasibilityController.getRecordType(f.Business_case__r.Product__r.Name, f.Business_Case__r.Opportunity__r.Type ,f.Business_Case__r.Opportunity__r.Green_Channel_Opportunity__c, 'AVCV');
                else if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c
                         && f.Feasibility__r != Null
                         && String.isNotBlank(f.Feasibility__r.Opportunity__r.MACD_Type__c)
                         && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'RATEREVISION'
                         && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'AGGREMENTRENEWAL'
                         && f.Business_Case__r.Opportunity__r.BC_MACD_Type__c != 'ADDENDUM'
                        )
             	  	avcv.RecordTypeId = RaiseFeasibilityController.getRecordTypeMacD(f.Business_case__r.Product__r.Name, f.Feasibility__r.Opportunity__r.MACD_Type__c ,f.Business_Case__r.Opportunity__r.Green_Channel_Opportunity__c, 'AVCV');
                else if( f.Business_Case__r.Opportunity__r.Is_MacD_Opportunity__c
                         && String.isNotBlank(f.Business_Case__r.Opportunity__r.MACD_Scenario__c)
                         && String.isNotBlank(f.Business_Case__r.Opportunity__r.BC_MACD_Type__c)
                         && (f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'RATEREVISION'
                            || f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'AGGREMENTRENEWAL'
                            || f.Business_Case__r.Opportunity__r.BC_MACD_Type__c == 'ADDENDUM')
                       )
             	  	avcv.RecordTypeId = RaiseFeasibilityController.getRecordTypeMacD(f.Business_case__r.Product__r.Name, f.Business_Case__r.Opportunity__r.MACD_Scenario__c ,f.Business_Case__r.Opportunity__r.Green_Channel_Opportunity__c, 'AVCV');

                System.debug('avcv.RecordTypeId '+ avcv.RecordTypeId);
                if(avcv.RecordTypeId!= null)
                	avcv_lst.add(avcv);
                else
                    System.debug(LoggingLevel.Error, 'Record type missing');
            }
            
        }
        
        System.debug('AVCV size'+ avcv_lst.size());
        System.debug('List----------'+avcv_lst);
        // Insert records of AC/CV
        if(avcv_lst.size()>0){
            insert avcv_lst;
        }
        return avcv_lst;
    }
    
    
    /*
     * createDropCAF()
     * Applicable for : NPLC - L2MC
     * Purpose: For each Drop__c listed against the Feasibility on AV_CV__c
     *           a.) If the Drop Circle matched Point A or Point B circle on Feasibility, 
     *               Point A/B CAF number should be picked from AV_CV__c. Drop CAF is not required.
     *           b.) If the Drop Circle is other than Point A/B Circle on Feasibility,
     *               One Drop CAF per circle is required. All Drops from the same circle will use the same CAF number.
     *           c.) External Id on Drop CAF : AVCV Id ~ Circle.
     */
    public static void createDropCAF(List<AV_CV__c> AVCV_List, Boolean IsMAcD)
    {
        Map<String, Drop_CAF__c> DropCAF_Map = new Map<String, Drop_CAF__c>();
        //For New Opportunities.
        if(IsMAcD==false)
        {
            SET<ID> FAN_ID_Set = new SET<ID>();
            //FAN_AVCV_MAP :: [Key = Fan Id ; Value = AVCV Id]
            MAP<ID, ID> FAN_AVCV_MAP = new MAP<ID, ID>();
            List<Feasibility__c> FAN_List = new List<Feasibility__c>();
            for(AV_CV__c avcv : AVCV_List)
                if(String.IsNotBlank(avcv.FAN_No__c))
            		{FAN_ID_Set.add(avcv.FAN_No__c);
                     FAN_AVCV_MAP.put(avcv.FAN_No__c, avcv.id) ;
                    }
            //get the Details for these Feasibility Records along with the list of drop records.
            if( !FAN_ID_Set.IsEmpty() )
                FAN_List = [Select Id, Flavor__c, Circle__c, Circle_B__c,  
                            (Select Id, Name, Drop_Id__c, Circle__c from Drops__r order by Name) 
                            from Feasibility__c
                            where ID IN :FAN_ID_Set];
            
          for( Feasibility__c fan : FAN_List)  
          {
              if( fan.Flavor__c=='L2MC' )
              {
                  List<Drop__c> Drop_List = fan.Drops__r ;
                  for(Drop__c drop : Drop_List)
                  {
                      if( (drop.Circle__c <> fan.Circle__c) && (drop.Circle__c <> fan.Circle_B__c) )
                      {
                          Drop_CAF__c dropCAF = new Drop_CAF__c();
                          dropCAF.Circle__c = drop.Circle__c ;
                          dropCAF.CAF_AVCV__c = FAN_AVCV_MAP.get( fan.ID ) ;
                          dropCAF.External_ID__c = FAN_AVCV_MAP.get( fan.ID ) + '~' + drop.Circle__c ;
                          DropCAF_Map.put( dropCAF.External_ID__c , dropCAF ) ;
                      }
                          
                  }
              }
          }
        }
        if( !DropCAF_Map.isEmpty() )
        {
         List<Drop_CAF__c> DropCAF_List = new List<Drop_CAF__c>() ;
         DropCAF_List.addAll(DropCAF_Map.values());
         upsert DropCAF_List External_ID__c ;
        }
         
        
    }
    
     public static void submitBC(List<Business_case__c> newList, Map<Id, Business_case__c> oldMap, Boolean isUpdate){
        
        System.debug('BusinessCaseTriggerHandler-------- submitBC method');
        List<Business_case__c> BCList = new List<Business_case__c>();
        for(Business_case__c bc : newList){
            if(bc.submit_BC__c && bc.submit_BC__c != oldMap.get(bc.id).submit_BC__c)
                BCList.add(bc);
        }
        
        if(BCList.size()> 0)
            GenerateEmpowerRest.execute(BCList);
        
    }
    
    public static void createDummyFANBC(List<Business_case__c> bcNewList){
        List<Fan_bc__c> fanBCList = new List<Fan_bc__c>();
              
        Map<id,Business_case__c> bcMap = new Map<id,Business_case__c>(
        	[select id, product__r.name, product__r.bc_category__c, Opportunity__r.Name, Opportunity__r.Type, Opportunity__r.Green_Channel_Opportunity__c,Tarid__c from Business_case__c where id in :bcNewList]
        );
        
        RaiseFeasibilityController.initializeRecordTypeMap();
        
        for(Business_case__c bc : bcNewList){
            System.debug('bc'+bc);
            System.debug('-----------dummy fan BC--------------');
            if(bcMap.containsKey(bc.id)){
                Business_case__c bcase = bcMap.get(bc.Id);
                System.debug('bc Tarid' + bc.Tarid__c);
                String category = bcase.Product__r.bc_category__c;
                System.debug('BC Product---'+ category);
                if(category == '3GDongle' || category == 'EPABX' || category == 'WireLessVoice' || category == 'GSM'){
                    System.debug('Inside if');
                    System.debug('bc.Auto_Tarid__c'+ bc.Auto_Tarid__c);
                    Fan_bc__c fanbc = new FAN_bc__c(business_case__c= bc.id,External_ID__c=bc.Auto_Tarid__c+'~');
              //      fanbc.recordTypeId = Schema.SObjectType.Fan_bc__c.getRecordTypeInfosByName().get('FAN BC - Wireless Voice').getRecordTypeId();
                      fanbc.RecordTypeId = RaiseFeasibilityController.getRecordType(bcase.product__r.name, bcase.Opportunity__r.Type, bcase.Opportunity__r.Green_Channel_Opportunity__c, 'FAN BC') ;
                    System.debug('recordTypeId'+ fanbc.recordTypeId);
                    
                    if(fanbc.RecordTypeId != null)
                    	fanBCList.add(fanbc);
                    else
                        System.debug('Record type missing');
                }
            }
        }
        
        insert fanBCList;
        
        
    }
    
    
}