/*
 * Name        : SSPAccountInterface
 * Description : SSPAccountInterface class is used to generate the Empower REST records for SSPAccount Webservice
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 29 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 06/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
public without sharing class SSPAccountInterface {
    
    //The Giant Map: Key=Json field, Value= FieldInfo Object (Api Name + Fixed Value + Execute Logic)
    static Map<String,FieldInfo> JSOn_Field_Map{get;set;}
    //Details about the SSPAccount Interface eg. Endpoint/Priority are stored in this custom setting.
    public static RESTEndpointURL__c Endpoint{get;set;}
    
    //The Class for JSON Object
    public class SSPAccountJSON
    {
		public String v_parent_circuit{get;set;}
		public String v_activity_type{get;set;}
		public String authKey{get;set;}
		public String v_company{get;set;}
	}
    
    //Query all the fields which are required to process the JSON for Feasibility.
    public static List<SObject> executeQuery(List<SObject> newsObjList)
    {
        String query ='Select Id, Opportunity__r.Company__r.Name, Opportunity__r.Company__r.Id from Feasibility__c' ;

        String q = query +' WHERE Id IN: newsObjList';
        List<SObject> SObjList = Database.query(q);
        //System.debug(SObjList);
        return SObjList;
    }
    
    //Initialize the JSOn_Field_Map with appropriate values.
    public static void initializeJSOn_Field_Map()
    {
        JSOn_Field_Map = new Map<String,FieldInfo>();
        
        JSOn_Field_Map.put('v_parent_circuit',new FieldInfo(null,'',FALSE));
        JSOn_Field_Map.put('v_activity_type',new FieldInfo(null,'SSP',FALSE));
        JSOn_Field_Map.put('authKey',new FieldInfo(null,'1234',FALSE));
        JSOn_Field_Map.put('v_company',new FieldInfo('Opportunity__r.Company__r.Name',null,FALSE));
    }
    
    //For each sObj in the sObjList, an Empower_REST__c record is created.
     public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList )
    {
        //The Map with all keys to be used for class SSPJSON
        Map<String, Object> sspJSON_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new SSPAccountJSON()));
        //The list of Empower_Rest__c records which needs to be returned.
        List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
        //This set is used to check that a duplicate record is not created for the same company.
        Set<String> CompanySet = new Set<String>();
       
        for(SObject sObj : sObjList)
        {
            String companyId = GenerateEmpowerREST.GetFieldValue( sObj , 'Opportunity__r.Company__r.Id' );
            if( companyId != '' && CompanySet.contains(companyId) == false ) 
            {
            CompanySet.add(companyId);
            //The Empower_REST__c record corresponding to this sObj.
            Empower_REST__c empNew = new Empower_REST__c();
            //This Map needs to be converted to the JSON String.
            Map<String, Object> Obj_Map = new Map<String, Object>( sspJSON_ObjMap );
            
        	for(String key : Obj_Map.keySet())
            {
                //For each Key found in the JSOn_Field_Map, fill in the value from API Name/ Fixed value.
                if(JSOn_Field_Map.get(key)!=null)
                {
                   if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                       Obj_Map.put(key, GenerateEmpowerREST.GetFieldValue( sObj , JSOn_Field_Map.get(key).APIName ) ) ;
                    else if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == true )
                    {System.Debug('Execute Business Logic for this field : '+ JSOn_Field_Map.get(key).APIName) ;
                    }
                    else if(JSOn_Field_Map.get(key).FixedValue != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                       Obj_Map.put(key, String.ValueOF(JSOn_Field_Map.get(key).FixedValue ) );
                } 
            }
        	//Get the JSON String from Obj_Map
        	// Get the AuthKey from custom setting
        	if(  String.IsNotBlank(SSPAccountInterface.EndPoint.Auth_Key__c) )
        	   Obj_Map.put('authKey', SSPAccountInterface.EndPoint.Auth_Key__c);
            String JSON_String = JSON.serialize(Obj_Map);
            System.Debug('JSON_String : '+ JSON_String);
            
            //Fill in the necessary details for Empower_REST__c record.
             empNew.Company__c = companyId ;
            //IMPORTANT: Fill the User_input_4__c field for Empower rest record
            //so that it can be differentiated for SSP Interface.
            empNew.User_Input_4__c = 'SSP' ;
            empNew.Endpoint__c = SSPAccountInterface.EndPoint.Endpoint__c ;
            empNew.JSON__c = JSON_String ;
            empNew.Status__c = 'New' ;
            empNew.Priority__c = SSPAccountInterface.EndPoint.Priority__c ;
            empNew.Retrial_Count__c = 0 ;
            empNew.Key__c = companyId +'~sspAccount~new';
            if(String.IsNotBlank(empNew.JSON__c))
             //Add the Empower_REST__c record to the return list.
             empRESTList.add(empNew);
            }
        }

        return empRESTList;
    }

}