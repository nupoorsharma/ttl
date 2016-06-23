/*
 * Name        : EPOSInterface
 * Description : EPOSInterface class is used to generate the Empower REST records for ePOS
 * Author      : Rahul Mohan (Compro Technologies)
 * Created On  : 9 April 2016
    * Change Log History:
    * |-------------------------------------------------------------|
    * | Version | Changes By | Date     | Description               | 
    * |-------------------------------------------------------------|
    * |   0.2   | Rahul      | 04-06-16 |Updated version of Trigger | 
    * | 								|with Valid caf Status at PO|
    * |-------------------------------------------------------------|  
    * |   0.3   | Nupoor     | 19-06-16 | Extended for Drop CAF     | 
    * |-------------------------------------------------------------|  
    * |   0.4   | Nupoor     | 21-06-16 | Extended for Retrial      | 
    * |-------------------------------------------------------------|  
 */
public without sharing class EPOSInterface{

     // EndPoint information coming from EPOS custom setting
        public static RESTEndpointURL__c Endpoint{get;set;}
     
    public class JsonEPOS{
        public String in_app_nbr;
        public String in_circle_id;
        public String authKey;
    }
    
    public static void checkAllCAFNoChangeOnAfterInsert(List<AV_CV__c> newlist){
        List<Empower_REST__c> empowerList=new List<Empower_REST__c>(); 
        // Getting Customing Setting Object for ePos
        Endpoint = GenerateEmpowerREST.getEndpoint('ePos');
        
        for(AV_CV__c avcv:newlist){
        
            if(avcv.NLD_CAF_No__c!=NULL && avcv.NLD_CAF_No__c!='' && avcv.NLD_CAF_Status__c!='Valid'){
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.NLD_CAF_No__c;
                jsonObj.in_circle_id = avcv.NLD_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.NLD_CAF_No__c;
                empower.User_Input_2__c = 'NLD_CAF_No__c';
                empower.User_Input_3__c = 'NLD_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'NLD_CAF_No__c'+'~'+avcv.NLD_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
                
            }
            if(avcv.Parent_CAF_No__c!=NULL && avcv.Parent_CAF_No__c!='' && avcv.Parent_CAF_Status__c!='Valid'){
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Parent_CAF_No__c;
                jsonObj.in_circle_id = avcv.Parent_Billing_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Parent_CAF_No__c;
                empower.User_Input_2__c = 'Parent_CAF_No__c';
                empower.User_Input_3__c = 'Parent_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Parent_CAF_No__c'+'~'+avcv.Parent_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
            }
            if(avcv.Point_B_CAF_No__c!=NULL && avcv.Point_B_CAF_No__c!='' && avcv.POINT_B_CAF_Status__c!='Valid'){
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Point_B_CAF_No__c;
                jsonObj.in_circle_id = avcv.Point_B_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Point_B_CAF_No__c;
                empower.User_Input_2__c = 'Point_B_CAF_No__c';
                empower.User_Input_3__c = 'POINT_B_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Point_B_CAF_No__c'+'~'+avcv.Point_B_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
            }
            if(avcv.Point_CAF_No__c!=NULL && avcv.Point_CAF_No__c!='' && avcv.POINT_CAF_Status__c!='Valid'){
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Point_CAF_No__c;
                jsonObj.in_circle_id = avcv.Point_Billing_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Point_CAF_No__c;
                empower.User_Input_2__c = 'Point_CAF_No__c';
                empower.User_Input_3__c = 'POINT_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Point_CAF_No__c'+'~'+avcv.Point_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
                
            }
            
        }
        // EmPower Rest Object
        if(empowerList.size()>0){
            //changed by Nupoor
            //insert empowerList;
            GenerateEmpowerREST.InsertEmpREST( empowerList , Endpoint.Immediate_Execution__c) ;
        }
        
    }
    
    public static void checkAllCAFNoChangeOnAfterUpdate(List<AV_CV__c> newlist,Map<Id,AV_CV__c> oldMap){
        List<Empower_REST__c> empowerList=new List<Empower_REST__c>(); 
        // Getting Customing Setting Object for ePos
        Endpoint = GenerateEmpowerREST.getEndpoint('ePos');

        for(AV_CV__c avcv:newlist){
            if( (avcv.NLD_CAF_No__c!=NULL && avcv.NLD_CAF_No__c!='') 
               && ((oldMap.get(avcv.id).NLD_CAF_No__c != avcv.NLD_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.NLD_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){ System.Debug(LoggingLevel.FINE , 'Epos for NLD_CAF_No__c ');
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.NLD_CAF_No__c;
                jsonObj.in_circle_id = avcv.NLD_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.NLD_CAF_No__c;
                empower.User_Input_2__c = 'NLD_CAF_No__c';
                empower.User_Input_3__c = 'NLD_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'NLD_CAF_No__c'+'~'+avcv.NLD_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
                
            }
            if(avcv.Parent_CAF_No__c!=NULL && avcv.Parent_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Parent_CAF_No__c != avcv.Parent_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.Parent_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){ System.Debug(LoggingLevel.FINE , 'Epos for Parent_CAF_No__c ');
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Parent_CAF_No__c;
                jsonObj.in_circle_id = avcv.Parent_Billing_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Parent_CAF_No__c;
                empower.User_Input_2__c = 'Parent_CAF_No__c';
                empower.User_Input_3__c = 'Parent_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Parent_CAF_No__c'+'~'+avcv.Parent_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
            }
            if(avcv.Point_B_CAF_No__c!=NULL && avcv.Point_B_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Point_B_CAF_No__c != avcv.Point_B_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.POINT_B_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){ System.Debug(LoggingLevel.FINE , 'Epos for Point_B_CAF_No__c ');
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Point_B_CAF_No__c;
                jsonObj.in_circle_id = avcv.Point_B_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Point_B_CAF_No__c;
                empower.User_Input_2__c = 'Point_B_CAF_No__c';
                empower.User_Input_3__c = 'POINT_B_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Point_B_CAF_No__c'+'~'+avcv.Point_B_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
            }
            if(avcv.Point_CAF_No__c!=NULL && avcv.Point_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Point_CAF_No__c != avcv.Point_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.POINT_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){ System.Debug(LoggingLevel.FINE , 'Epos for Point_CAF_No__c ');
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
                jsonObj.in_app_nbr = avcv.Point_CAF_No__c;
                jsonObj.in_circle_id = avcv.Point_Billing_Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.AV_CV__c = avcv.Id;
                empower.User_Input_1__c = avcv.Point_CAF_No__c;
                empower.User_Input_2__c = 'Point_CAF_No__c';
                empower.User_Input_3__c = 'POINT_CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = avcv.Id+'~'+'Point_CAF_No__c'+'~'+avcv.Point_CAF_No__c;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
                
            }
            
        }
         // EmPower Rest Object
        if(empowerList.size()>0){
            //Changed by Nupoor
            //insert empowerList;
            GenerateEmpowerREST.InsertEmpREST( empowerList , Endpoint.Immediate_Execution__c) ;
        }
        
    }
    
    public static void checkAllCAFNoChangeOnBeforeUpdate(List<AV_CV__c> newlist,Map<Id,AV_CV__c> oldMap){
            for(AV_CV__c avcv : newlist){
            
            if( avcv.NLD_CAF_No__c!=NULL && avcv.NLD_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).NLD_CAF_No__c != avcv.NLD_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.NLD_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
               ){
                avcv.NLD_CAF_Status__c='Needs Validation';
                }
                
            if(avcv.Parent_CAF_No__c!=NULL && avcv.Parent_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Parent_CAF_No__c != avcv.Parent_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.Parent_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){
                avcv.Parent_CAF_Status__c='Needs Validation';
               }
                
            if(avcv.Point_B_CAF_No__c!=NULL && avcv.Point_B_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Point_B_CAF_No__c != avcv.Point_B_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.POINT_B_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){
                avcv.POINT_B_CAF_Status__c='Needs Validation';
               }
                
            if(avcv.Point_CAF_No__c!=NULL && avcv.Point_CAF_No__c!='' 
               && ((oldMap.get(avcv.id).Point_CAF_No__c != avcv.Point_CAF_No__c )
                   || (avcv.Retry_CAF_Validation__c == true 
                       && avcv.POINT_CAF_Status__c == 'Needs Validation'
                       && (oldMap.get(avcv.id).Retry_CAF_Validation__c != avcv.Retry_CAF_Validation__c ) )
                  )
              ){
                avcv.POINT_CAF_Status__c='Needs Validation';
               }
            
        }
    }
    
    /*
     * createJSON()
     * Purpose:: Create JSON for ePos Interface
     *           ---> Initiated by Drop CAF record
     */
    public static List<Empower_REST__c> createJSON(List<Drop_CAF__c> newlist)
    {
        List<Empower_REST__c> empowerList = new List<Empower_REST__c>(); 
        
        for(Drop_CAF__c newObj : newList)
        {
            JsonEPOS  jsonObj=new JsonEPOS();
            Empower_REST__c empower = new Empower_REST__c();
            
                jsonObj.in_app_nbr = newObj.CAF_Number__C;
                jsonObj.in_circle_id = newObj.Circle__c;
                jsonObj.authKey = 'dummykey';
                
                if( String.IsNotBlank( EndPoint.Auth_Key__c ))
             	jsonObj.authKey = EndPoint.Auth_Key__c ;
                
                empower.Drop_CAF__c = newObj.Id;
                empower.User_Input_1__c = newObj.CAF_Number__C;
                empower.User_Input_2__c = 'CAF_Number__C';
                empower.User_Input_3__c = 'CAF_Status__c';
                empower.JSON__c = JSON.serialize(jsonObj);
                empower.Key__c = newObj.Id+'~'+'CAF_Number__C'+'~'+newObj.CAF_Number__C;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'New' ;
            	empower.Priority__c = EndPoint.Priority__c ;
            	empower.Retrial_Count__c = 0 ;
                empowerList.add(empower);
        }
        return empowerList;
    }
    
}