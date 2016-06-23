/*
 * Name        : FieldInfo
 * Description : Generic class used in the JSOn_Field_Map for all Empower Rest Interfaces.
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 2 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class FieldInfo {
    /*
     * GROUND RULES::
     * *If the API Name is not null and ExecuteLogic is TRUE -> Call executeBusinessLogic()
     * *If the API Name is not null and ExecuteLogic is FALSE -> Get the value from the specified API Name.
     * *If the Fixed Value is not null and ExecuteLogic is FALSE -> Stamp the Fixed value to the JSON field.
     */
    
    //The API name : Get the value for a JSON Field from this API name
    public String APIName{get;set;}
    //The Fixed Value : Stamp this fixed value for the JSON Field 
    public String FixedValue{get;set;}
    //ExecuteLogic : The flag to detemine if some additional business logic needs to be executed.
    public Boolean ExecuteLogic{get;set;} 
    
    //Parameterized Constructor to intitialize a FieldInfo Object
    public FieldInfo(String Api, String fixedval, Boolean elogic)
    {
        APIName = Api ;
        FixedValue = fixedval ;
        ExecuteLogic = elogic ;
    }
    //Default Constructor for a FieldInfo Object
    public FieldInfo()
    {
        APIName = null ;
        FixedValue = null ;
        ExecuteLogic = null ;
    }
}