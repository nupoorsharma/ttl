/*
 * Name        : UserListBatch
 * Description : UserListBatch class processes the callout to get the PO Team 
 *               records and sets the active flag on them.
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 27 May 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 27/05/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class UserListBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

      global Database.QueryLocator start(Database.BatchableContext BC)
      { System.Debug(LoggingLevel.FINE, 'EmpowerRESTBatch------------- START()');
       
        //Key for Today's UserList Integration Record
        String KEY = 'UserList~'+System.Today().dayOfYear()+'~'+System.now();
        //The details related to USERLIST Interface are lying in this custom setting
        RESTEndpointURL__c Endpoint = GenerateEmpowerREST.getEndpoint('UserList');
            if(String.IsNotBlank(Endpoint.Auth_Key__c) && String.IsNotBlank(Endpoint.Endpoint__c) && (Endpoint.Active__c = true))
            {
                System.Debug(LoggingLevel.FINE, 'A Valid Auth Key was found');
                Empower_REST__c empower = new Empower_REST__c();
                empower.JSON__c = '{"authKey": "' + Endpoint.Auth_Key__c + '"}';
                empower.Key__c = KEY;
                empower.Endpoint__c = Endpoint.Endpoint__c;
                empower.Status__c = 'In Progress' ;
                empower.Priority__c = EndPoint.Priority__c ;
                empower.Retrial_Count__c = 10 ;
                upsert empower key__c;
                
                System.Debug(LoggingLevel.FINE, 'Integration Status for USERLIST Interface was upserted with the key : '+ empower.Key__c + ' and Id : '+empower.id);
            }
         //Query the UserList Integration Record created for today.
         String query='Select Id, Endpoint__c, key__c, Error_Code__c, Error_Message__c, JSON__c, Priority__c, Retrial_Count__c, Status__c '
                         + 'from Empower_REST__c where key__c = :KEY';
         return Database.getQueryLocator(query);
      }
      
      global void execute(Database.BatchableContext BC,List<Empower_REST__c> scope)
      { 
          System.Debug(LoggingLevel.FINE, 'EmpowerRESTBatch------------- EXECUTE()');
          //The callout will be made for the Empower REST Record upserted in Start()
          System.Debug('Size of scope : '+ scope.size());
          if(!scope.isEmpty())
          {
              //We are working on the first Empower_REST__C record of the list  
              //with the Key['UserList~'+System.Today().dayOfYear()+'~'+System.now()].
              Empower_REST__c empNew = scope[0];
              //Response Map to store values of the Response JSON
              Map<String, Object> ResponseMap;
              //This Map will contain all the PO Members found in the response.
              Map<String, PO_Team__c> POMap = new MAP<String, PO_Team__c>();
        
              //Prepare the Request for the callout
              HttpRequest req = new HttpRequest();
                  req.setMethod('POST');
                  req.setEndpoint(empNew.Endpoint__c);
                  req.setHeader('Content-Type', 'application/json');
                  req.setTimeout(120000);
                  if(String.isNotBlank(empNew.JSON__C))
                  req.setBody(empNew.JSON__C);
                  Http http = new Http();
                  HttpResponse res;
                  try {
                        System.Debug('Request: '+ req);
                        System.Debug('Request Body : '+ req.getBody());
                        //Make the callout
                        if(! Test.isRunningTest())
                          res = http.send(req);
                        else
                        {
                            //Used only when a TEST class is running.
                            res=new HttpResponse();
                            if(empNew.Endpoint__c.contains('USERLIST'))
                            res.setBody('{"gofNames":[{"userId":"GOF3","userName":"GOF Name3"},{"userId":"GOF2","userName":"GOF Name1"}],"pmNames":[{"userId":"RMCO","userName":"PROGRAM MANAGER"},{"userId":"PM_ROM","userName":"PM_ROM"},{"userId":"BAG2","userName":"Papin Sahani"},{"userId":"8803","userName":"Test 8803"},{"userId":"PMMH","userName":"PM MH"}],"saNames":[{"userId":"SA_MH","userName":"SA_MH"},{"userId":"SA","userName":"SA"},{"userId":"SA_AP","userName":"SA_AP"}],"statusMsg":"SUCCESS","errorCode":null,"errorMsg":null}');
                            else if(empNew.Endpoint__c.contains('CalloutException'))
                            throw new System.CalloutException();
                            else if(empNew.Endpoint__c.contains('JSONE'))
                            throw new System.JSONException();
                            else if(empNew.Endpoint__c.contains('Failure'))
                            res.setBody('{"gofNames":[],"pmNames":[],"saNames":[],"statusMsg":"FAILURE","errorCode":"403","errorMsg":"Authorization failure"}');
                        }
                      
                    //System.debug('STATUS: ' + res.getStatus()+' STATUS_CODE:' + res.getStatusCode() );
                    System.Debug('Response:  '+ res ) ;
                    System.Debug('Response Body :  '+ res.getBody() ) ;
                      //The raw response is recorded in the Empower_REST__c record.
                      empNew.Response__c = res+ '\n' +res.getBody() ;
                      //Create the Response map from the JSON received.
                    ResponseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    }
                catch (System.CalloutException e) 
                   {
                      System.Debug('Callout Exception Occurred!');
                      //Code to add Error info on Empower REST record
                      System.Debug(e);
                      empNew.Status__c = 'Error' ;
                      empNew.Response__c = e.getMessage() ;
                   }
                 catch (Exception e) 
                   {
                      System.Debug('Exception Occurred!');
                      //Code to add Error info on Empower REST record
                      System.Debug(e);
                      empNew.Status__c = 'Error' ;
                      empNew.Response__c = e.getMessage() ;
                   }
              
            if( ResponseMap != null)
            {
                //In case a SUCCESS response is received
                if(ResponseMap.get('statusMsg')!=null && String.ValueOf(ResponseMap.get('statusMsg')).equalsIgnoreCase('SUCCESS') )
                {
                    //Fill in the Status info on Empower REST Record
                    empNew.Status__c = 'SUCCESS';
                    empNew.Error_Code__c = null;
                    empNew.Error_Message__c = null;
                    
                    //Get the List of PO_Team__c records of type 'Solution Architect Team' and add them to the POMap
                    if( ResponseMap.get('saNames') != null )
                    {
                        System.Debug('######################            Solution Architect Team            ######################');
                        List<Object> SAList = (List<Object>)responseMAp.get('saNames');
                        if(!SAList.isEmpty())
                         for(Object key : SAList)
                         {
                           Map<String, Object> SAAttributes = (Map<String, Object>)key;
                           if( (SAAttributes.get('userName')!=Null) && (SAAttributes.get('userId')!=NULL) )
                           {
                               System.Debug('User Name : '+ SAAttributes.get('userName') + '---- User ID : '+ SAAttributes.get('userId'));
                               PO_Team__c SA = new PO_Team__c();
                               SA.External_ID__c = String.ValueOf(SAAttributes.get('userId')) + '~' + 'Solution Architect Team' ;
                               SA.Active__c = true ;
                               SA.Name = String.ValueOf(SAAttributes.get('userName')) ;
                               SA.Type__c = 'Solution Architect Team' ;
                               SA.User_Id__c = String.ValueOf(SAAttributes.get('userId')) ;
                               POMap.put( SA.External_ID__c , SA) ;
                           }
                         }
                    }
                    //Get the List of PO_Team__c records of type 'Geography Order Fulfillment Team' and add them to the POMap
                    if( ResponseMap.get('gofNames') != null )
                    {
                        System.Debug('######################            Geography Order Fulfillment Team             ######################');
                        List<Object> GOFList = (List<Object>)responseMAp.get('gofNames');
                        if(!GOFList.isEmpty())
                         for(Object key : GOFList)
                         {
                           Map<String, Object> GOFAttributes = (Map<String, Object>)key;
                           if( (GOFAttributes.get('userName')!=Null) && (GOFAttributes.get('userId')!=NULL) )
                           {
                               System.Debug('User Name : '+ GOFAttributes.get('userName') + '---- User ID : '+ GOFAttributes.get('userId'));
                               PO_Team__c GOF = new PO_Team__c();
                               GOF.External_ID__c = String.ValueOf(GOFAttributes.get('userId')) + '~' + 'Geography Order Fulfillment Team' ;
                               GOF.Active__c = true ;
                               GOF.Name = String.ValueOf(GOFAttributes.get('userName')) ;
                               GOF.Type__c = 'Geography Order Fulfillment Team' ;
                               GOF.User_Id__c = String.ValueOf(GOFAttributes.get('userId')) ;
                               POMap.put( GOF.External_ID__c , GOF) ;
                           }
                         }
                    }
                    //Get the List of PO_Team__c records of type 'Program Manager' and add them to the POMap
                    if( ResponseMap.get('pmNames') != null )
                    {
                        System.Debug('######################            Program Manager             ######################');
                        List<Object> PMList = (List<Object>)responseMAp.get('pmNames');
                        if(!PMList.isEmpty())
                         for(Object key : PMList)
                         {
                           Map<String, Object> PMAttributes = (Map<String, Object>)key;
                           if( (PMAttributes.get('userName')!=Null) && (PMAttributes.get('userId')!=NULL) )
                           {
                               System.Debug('User Name : '+ PMAttributes.get('userName') + '---- User ID : '+ PMAttributes.get('userId'));
                               PO_Team__c PM = new PO_Team__c();
                               PM.External_ID__c = String.ValueOf(PMAttributes.get('userId')) + '~' + 'Program Manager' ;
                               PM.Active__c = true ;
                               PM.Name = String.ValueOf(PMAttributes.get('userName')) ;
                               PM.Type__c = 'Program Manager' ;
                               PM.User_Id__c = String.ValueOf(PMAttributes.get('userId')) ;
                               POMap.put( PM.External_ID__c , PM) ;
                           }
                         }
                    }
                    
                }
                //In case a FAILURE response is received
                if(ResponseMap.get('statusMsg')!=null && String.ValueOf(ResponseMap.get('statusMsg')).equalsIgnoreCase('FAILURE') )
                {
                    //Set The Error info on Empower_Rest__c record.
                    empNew.Status__c = 'FAILURE';
                    if(ResponseMap.get('errorCode')!=null)
                            {String x = String.ValueOf( ResponseMap.get('errorCode') );
                             if(x.length() > 254)
                             empNew.Error_Code__c = x.substring(0, 254);
                             else
                             empNew.Error_Code__c = x;    
                            }
                    empNew.Error_Message__c = String.ValueOf( ResponseMap.get('errorMsg') );
                }
            }
              //Get the list of PO_Team__c records from POMap
              //These Members will have Active__c set as true
              List<PO_Team__c> POTeamList = new List<PO_Team__c>();
              List<String> POKeyList = new List<String>();
              for(String POkey : POMap.keySet())
              {
                  POTeamList.add( POMap.get(POkey) ) ;
                  POKeyList.add(POkey) ;
              }
              //Upsert the newly received PO Members on the basis of External ID
              System.debug('Size Of PO Team : '+ POTeamList.size());
              upsert POTeamList External_ID__c ;
              
              //Mark all old PO Members as Inactive 
              //(Active__c = false for members which were not upserted as a part of this callout.)
              if( !POKeyList.isEmpty() )
              {
              List<PO_Team__c> oldPOMembers = [Select Id, Active__c, External_ID__c from PO_Team__c where External_ID__c NOT IN :POKeyList] ;
              for(PO_Team__c oldMember : oldPOMembers)
                  oldMember.Active__c = false;
              update oldPOMembers;
              }
              //Update the Empower_Rest__c record with the results of the callout.
              update empNew;
          }
          
      }
      
      global void finish(Database.BatchableContext BC)
      {
        System.Debug('EmpowerRESTBatch------------- FINISH()');
      }
    
}