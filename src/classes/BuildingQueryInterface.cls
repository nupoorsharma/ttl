/*
 * Name        : BuildingQueryInterface
 * Description : BuildingQueryInterface class is used to generate the Empower REST records for Building Query
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 2 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
public without sharing class BuildingQueryInterface {
    
    //The Giant Map: Key=Json field, Value= FieldInfo Object (Api Name + Fixed Value + Execute Logic)
    static Map<String,FieldInfo> JSOn_Field_Map{get;set;}
    //Details about the Feasibility Interface eg. Endpoint/Priority are stored in this custom setting.
    public static RESTEndpointURL__c Endpoint{get;set;}
    
    
    //Class for JSON Object
    public class BuildingQueryJSON{
		public String sfdcReqId;
        public String typeOfRequest;
        public String existingBuildingId;
        public String buildingName;
        public String street1;
        public String street2;
        public String landMark;
        public String state;
        public String city;
        public String pinCode;
        public String region;
        public String circle;
        public String latitude;
        public String longitude;
        public String authKey;
        //public String transactionID;
       // public String inputText1;
        //public String inputText2;
       // public String inputText3;
       // public String inputText4;
       // public String inputText5;
        public String media;

   }
    
    //Query all the fields which are required to process the JSON for Building Query.
    public static List<SObject> executeQuery(List<SObject> newsObjList)
    {
        String query = 'Select Id, Name, Media__c, Type_of_Request__c,Existing_Building__r.Empower_Building_Id__c, Existing_Building__c, Building_Name__c, Address__c, Address2__c, Landmark__c, State__c, City__r.Name, Pin_CodeL__r.Name, Region__c, Circle__c, Geolocation__latitude__s, Geolocation__longitude__s from Building_Query__c';
        String q = query +' WHERE Id IN: newsObjList';
        List<SObject> SObjList = Database.query(q);
        return SObjList;
    }
    
    //Initialize the JSOn_Field_Map with appropriate values.
    public static void initializeJSOn_Field_Map()
    {
        JSOn_Field_Map = new Map<String,FieldInfo>();
        
         JSOn_Field_Map.put('sfdcReqId',new FieldInfo('Name',null,FALSE));
         JSOn_Field_Map.put('typeOfRequest',new FieldInfo('Type_of_Request__c',null,FALSE));
         JSOn_Field_Map.put('existingBuildingId',new FieldInfo('Existing_Building__r.Empower_Building_Id__c',null,FALSE));
         JSOn_Field_Map.put('buildingName',new FieldInfo('Building_Name__c',null,FALSE));
         JSOn_Field_Map.put('street1',new FieldInfo('Address__c',null,FALSE));
         JSOn_Field_Map.put('street2',new FieldInfo('Address2__c',null,FALSE));
         JSOn_Field_Map.put('landMark',new FieldInfo('Landmark__c',null,FALSE));
         JSOn_Field_Map.put('state',new FieldInfo('State__c',null,FALSE));
         JSOn_Field_Map.put('city',new FieldInfo('City__r.Name',null,FALSE));
         JSOn_Field_Map.put('pinCode',new FieldInfo('Pin_CodeL__r.Name',null,FALSE));
         JSOn_Field_Map.put('region',new FieldInfo('Region__c',null,FALSE));
         JSOn_Field_Map.put('circle',new FieldInfo('Circle__c',null,FALSE));
         JSOn_Field_Map.put('latitude',new FieldInfo('Geolocation__latitude__s',null,FALSE));
         JSOn_Field_Map.put('longitude',new FieldInfo('Geolocation__longitude__s',null,FALSE));
         JSOn_Field_Map.put('authKey',new FieldInfo(null,'123',FALSE));
         //JSOn_Field_Map.put('transactionID',new FieldInfo('Id',null,FALSE));
         //JSOn_Field_Map.put('inputText1',new FieldInfo(null,'',FALSE));
         //JSOn_Field_Map.put('inputText2',new FieldInfo(null,'',FALSE));
         //JSOn_Field_Map.put('inputText3',new FieldInfo(null,'',FALSE));
         //JSOn_Field_Map.put('inputText4',new FieldInfo(null,'',FALSE));
         //JSOn_Field_Map.put('inputText5',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('media',new FieldInfo('Media__c',null,FALSE));
        
        System.debug('Size of Map: '+ JSOn_Field_Map.size());
        System.Debug('Content :' +JSOn_Field_Map);
    }
    
    //For each sObj in the sObjList, an Empower_REST__c record is created.
    public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList )
    {
        //The Map with all keys to be used for class BuildingQueryJSON
        Map<String, Object> BuildingQueryJSON_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new BuildingQueryJSON()));
        //The list of Empower_Rest__c records which needs to be returned.
        List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
        
        for(SObject sObj : sObjList)
        {
            //The Empower_REST__c record corresponding to this sObj.
            Empower_REST__c empNew = new Empower_REST__c();
            //This Map needs to be converted to the JSON String.
            Map<String, Object> Obj_Map = new Map<String, Object>( BuildingQueryJSON_ObjMap );
            
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
           //BuildingQueryJSON BQJson = (BuildingQueryJSON)JSON.deserializeStrict(JSON.serialize(Obj_Map), BuildingQueryJSON.class);
        	//Get the JSON String from Obj_Map
        	// Get the AuthKey from custom setting
        	if(  String.IsNotBlank(BuildingQueryInterface.EndPoint.Auth_Key__c) )
        	   Obj_Map.put('authKey', BuildingQueryInterface.EndPoint.Auth_Key__c);
            String JSON_String = JSON.serialize(Obj_Map);
            System.Debug('JSON_String : '+ JSON_String);
            
            //Fill in the necessary details for Empower_REST__c record.
            empNew.Building_Query__c = sObj.id ;
            empNew.Endpoint__c = BuildingQueryInterface.EndPoint.Endpoint__c ;
            empNew.JSON__c = JSON_String ;
            empNew.Status__c = 'New' ;
            empNew.Priority__c = BuildingQueryInterface.EndPoint.Priority__c ;
            empNew.Retrial_Count__c = 0 ;
            empNew.Key__c = sObj.id +'~buildingquery~new';
            if(String.IsNotBlank(empNew.JSON__c))
             //Add the Empower_REST__c record to the return list.
             empRESTList.add(empNew);
        }

        return empRESTList;
    }
    

}