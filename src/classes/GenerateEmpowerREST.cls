/*
 * Name        : GenerateEmpowerREST
 * Description : Generic class used for generating the Empower REST records
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 2 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class GenerateEmpowerREST {
    
    /*
     * execute(List<Business_case__c> sObjList)
     * ---> This method is called for Business case Interface
     *
     */
    
     public static void execute(List<Business_case__c> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- execute() for Business Case');
        //Get the Interface Details for BuildingQuery Interface.
        BusinessCaseInterface.Endpoint = GenerateEmpowerREST.getEndpoint('BusinessCase');
        //Continue the execution only if the Interface is Active.
        if(BusinessCaseInterface.Endpoint.Active__c)
        {
            //Setup the JSON_Field_Map for this interface.
            //BuildingQueryInterface.initializeJSON_Field_Map();
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = BusinessCaseInterface.CreateJSON(BusinessCaseInterface.executeQuery(sObjList));
            System.debug('empRESTList----'+empRESTList.size());
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , BusinessCaseInterface.Endpoint.Immediate_Execution__c) ;
        }
    }
    
    
    /*
     * execute(List<Building_Query__c> sObjList)
     * ---> This method is called for Building Query Interface
     */
    public static void execute(List<Building_Query__c> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- execute() for Building Query');
        //Get the Interface Details for BuildingQuery Interface.
        BuildingQueryInterface.Endpoint = GenerateEmpowerREST.getEndpoint('BuildingQuery');
        //Continue the execution only if the Interface is Active.
        if(BuildingQueryInterface.Endpoint.Active__c)
        {
            //Setup the JSON_Field_Map for this interface.
            BuildingQueryInterface.initializeJSON_Field_Map();
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = BuildingQueryInterface.CreateJSON(BuildingQueryInterface.executeQuery(sObjList));
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , BuildingQueryInterface.Endpoint.Immediate_Execution__c) ;
        }
    }
    
    
    /*
     * execute(List<Feasibility__C> sObjList)
     * ---> This method is called for Feasibility Interface
     */
    public static void execute(List<Feasibility__C> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- execute() for Feasibility');
         //Get the Interface Details for Feasibility Interface.
        FeasibilityInterface.Endpoint = GenerateEmpowerREST.getEndpoint('Feasibility');
        //Continue the execution only if the Interface is Active.
        if(FeasibilityInterface.Endpoint.Active__c)
        {
            //Setup the JSON_Field_Map for this interface.
            FeasibilityInterface.initializeJSON_Field_Map();
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = FeasibilityInterface.CreateJSON(FeasibilityInterface.executeQuery(sObjList));
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , FeasibilityInterface.Endpoint.Immediate_Execution__c) ;
        }
       
    }
    
    /*
     * executeSSP(List<Feasibility__C> sObjList)
     * ---> This method is called for SSP Account Interface
     */
    public static void executeSSP(List<Feasibility__C> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- executeSSP() for Feasibility');
         //Get the Interface Details for Feasibility Interface.
        SSPAccountInterface.Endpoint = GenerateEmpowerREST.getEndpoint('SSPAccount');
        //Continue the execution only if the Interface is Active.
        if(SSPAccountInterface.Endpoint.Active__c)
        {
            //Setup the JSON_Field_Map for this interface.
            SSPAccountInterface.initializeJSON_Field_Map();
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = SSPAccountInterface.CreateJSON(SSPAccountInterface.executeQuery(sObjList));
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , SSPAccountInterface.Endpoint.Immediate_Execution__c) ;
        }
       
    }
    
    
    /*
     * execute(List<Purchase_Order__c> sObjList)
     * ---> This method is called for Purchaseorder Interface
     */
    public static void execute(List<Purchase_Order__c> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- execute() for Purchase Order');
        //Get the Interface Details for BuildingQuery Interface.
        PurchaseOrderInterface.Endpoint = GenerateEmpowerREST.getEndpoint('PurchaseOrder');
        System.debug('PurchaseOrderInterface.Endpoint----'+ PurchaseOrderInterface.Endpoint);
        //Continue the execution only if the Interface is Active.
        if(PurchaseOrderInterface.Endpoint.Active__c)
        {
            System.debug('Inside if--- '+PurchaseOrderInterface.Endpoint.Active__c);
            //Setup the JSON_Field_Map for this interface.
        //  BuildingQueryInterface.initializeJSON_Field_Map();
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = PurchaseOrderInterface.CreateJSON(PurchaseOrderInterface.executeQuery(sObjList));
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , PurchaseOrderInterface.Endpoint.Immediate_Execution__c) ;
        }
    }
    
    
    /*
     * getFieldValue(SObject sObj, String FieldName)
     * ---> Accepts an SObject and the API name queried for that SObject and returns the value if found.
     *      A blank value is returned if the value in that field is null.
     */
    public static String getFieldValue(SObject sObj, String FieldName)
    {  //System.Debug(sObj + '  FieldName :: '+ FieldName);
        //returnVal : The value that will be returned from this function.
        String returnVal;
        //Get the value from the Relationship field  of SObject
        if(FieldName.contains('.'))
             {Integer found=0;
              //Spill the API Name separated by '.'
              String[] spillName = FieldName.split('\\.');
                    if(FieldName.countMatches('.')==3 && 
                       sObj.getSObject(spillName[0])!= null && 
                       sObj.getSObject(spillName[0]).getSobject(spillName[1])!=null && 
                       sObj.getSObject(spillName[0]).getSobject(spillName[1]).getSobject(spillName[2])!=null )
                    { returnVal = String.valueOf(sObj.getSObject(spillName[0]).getSobject(spillName[1]).getSobject(spillName[2]).get(spillName[3]));
                      found=1;
                    }
                    else if(FieldName.countMatches('.')==2 && 
                            sObj.getSObject(spillName[0])!= null && 
                            sObj.getSObject(spillName[0]).getSobject(spillName[1])!=null)
                    {returnVal = String.valueOf(sObj.getSObject(spillName[0]).getSobject(spillName[1]).get(spillName[2]));
                     found=1;
                    }
                     else if(FieldName.countMatches('.')==1 && 
                            sObj.getSObject(spillName[0])!=null)
                     {returnVal =  String.valueOf(sObj.getSObject(spillName[0]).get(spillName[1]));
                      found=1;
                     }
                    else if(found==0)
                    {//System.Debug('Setting null for :: '+str);
                        returnVal = null;
                    }
              }
          else
             //If the Field directly belongs to the SObject
             returnVal = String.valueOf(sObj.get(FieldName));
        
        return (returnVal==null? '' : returnVal);
    }
    
    /*
     * getEndpoint(String InterfaceName)
     * ---> Accepts the Interface Name and returns the custom setting record found for it.
     */
    public static RESTEndpointURL__c getEndpoint(String InterfaceName)
        { RESTEndpointURL__c endpoint = new RESTEndpointURL__c();
         //All Interface Details are stored as a Custom Setting RESTEndpointURL__c
          List<RESTEndpointURL__c> EndPointList = RESTEndpointURL__c.getall().values();
         //Catch the custom setting where Interface_Name__c  matches the Interface Name parameter
          for(RESTEndpointURL__c  EP: EndPointList)
            if( EP.Interface_Name__c.toLowerCase() == InterfaceName.toLowerCase() )
              endpoint = EP;
          System.Debug('Endpoint : ' + endpoint);
         return endpoint;
        }
    
    /*
     * InsertEmpREST(List<Empower_REST__c> empRESTList)
     * ---> Accepts the List of Empower_REST__c records and upserts them based on the key__c value.
     */
    public static void InsertEmpREST(List<Empower_REST__c> empRESTList, Boolean ImmediateExecution)
    {  System.Debug('Empower REST List Size -----> '+empRESTList.size() );
        //System.Debug('Empower REST List  -----> '+empRESTList );
        if(ImmediateExecution)
        {
            if(empRESTList.size() > 100)
             upsert empRESTList key__c;
            else if (empRESTList.size() > 0 && empRESTList.size() <=100 && ImmediateExecution)
            {   List<ID> RecordIDs = new List<ID>();
                //Set the status of these records to In Progress 
                for(Empower_REST__c e : empRESTList)
                    e.Status__c = 'In Progress' ;
                upsert empRESTList key__c; 
                //Now collect record IDs
                for(Empower_REST__c e : empRESTList)
                    RecordIDs.add(e.Id);
               ExecuteCallouts.ExecuteFuture( RecordIDs );
            }
        }
       
        else
            upsert empRESTList key__c; 
    }
    
    /*
     * execute(List<AV_CV__c> sObjList)
     * ---> This method is called for AVCV Interface
     */
     public static void execute(List<AV_CV__c> sObjList)
     {
        // AVCVInterface.Endpoint='hahah';AVCV
         AVCVInterface.Endpoint = GenerateEmpowerREST.getEndpoint('AVCV');
         
          if(AVCVInterface.Endpoint.Active__c)
            {
                //Setup the JSON_Field_Map for this interface.
                AVCVInterface.initializeJSON_Field_Map();
                //Get the list of Empower_REST__c records
                List<Empower_REST__c> empRESTList = AVCVInterface.CreateJSON(AVCVInterface.executeQuery(sObjList));
                //Insert the list of Empower_REST__c records
                GenerateEmpowerREST.InsertEmpREST( empRESTList, AVCVInterface.Endpoint.Immediate_Execution__c ) ;
                system.debug('emp list val :'+empRESTList);
            }
     }
   
    /*
     * execute(List<Drop_CAF__c> sObjList)
     * ---> This method is called for ePos Interface [CAF Validation]
     */
    public static void execute(List<Drop_CAF__c> sObjList)
    {
        System.Debug('GenerateEmpowerREST--------- execute() for Drop CAF');
        //Get the Interface Details for BuildingQuery Interface.
        EPOSInterface.Endpoint = GenerateEmpowerREST.getEndpoint('ePos');
        //Continue the execution only if the Interface is Active.
        if(EPOSInterface.Endpoint.Active__c)
        {
            //Get the list of Empower_REST__c records
            List<Empower_REST__c> empRESTList = EPOSInterface.CreateJSON(sObjList);
            //Insert the list of Empower_REST__c records
            GenerateEmpowerREST.InsertEmpREST( empRESTList , EPOSInterface.Endpoint.Immediate_Execution__c) ;
        }
    }
    
}