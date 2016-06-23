/*
 * Name        : ExecuteCallouts
 * Description : Generic class used for the execution of callouts on Empower REST records
 *               Called From - GenerateEmpowerREST (for future methods)
 *                           - EmpowerRESTBatch (for Batch class)
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 8 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 08/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class ExecuteCallouts
{
    /*
     * ExecuteFuture(List<ID> EmpowerREST_IDList)
     * Purpose - Future method which executes callouts on the list of 
     *           Empower_REST__c records passed to it as a parameter.
     * Called From - GenerateEmpowerREST
     * Consideration - Max List Size : 100
     */
    @future(callout=true)
    public static void ExecuteFuture(List<ID> EmpowerREST_IDList)
    {   
        String query='Select Id, Endpoint__c, Error_Code__c, Error_Message__c, JSON__c, Priority__c, Retrial_Count__c, Status__c,AV_CV__c, User_Input_1__c, User_Input_2__c, User_Input_3__c , User_Input_4__c , Av_Cv__r.Point_CAF_No__c,Av_Cv__r.CAF_No__c, Av_Cv__r.NLD_CAF_No__c, Av_Cv__r.Parent_CAF_No__c, Av_Cv__r.Point_B_CAF_No__c , Company__c, Drop_CAF__c, Drop_CAF__r.CAF_Number__c, Drop_CAF__r.CAF_Status__c from Empower_REST__c where Id IN :EmpowerREST_IDList';
        List<Empower_REST__c> Scope = Database.query(query);
        ExecuteCallouts.execute(Scope);    
    }
    
    /*
     * execute(List<Empower_REST__c> scope)
     * Purpose - The function executes callouts on the list of Empower_REST__c records
     *           Passed to it as a parameter and updates the status back
     *           based on the response.
     *           Status- SUCCESS/FAILURE => Response from the callout
     *                 - Error => Callout Exception
     *           Error Code/ Error Message is populated for FAILURE
     *           Retrial Count is incremented for FAILURE/Error Scenario.
     * Called From - GenerateEmpowerREST, EmpowerRESTBatch
     * Consideration - Max List Size : 100
     */
    public static void execute(List<Empower_REST__c> scope)
    {
        
        Integer i=0;
          //The statusMsg = value, errorCode=value, errorMessage=value, p_err_msg=value, p_status=value
          Map<String, Object> ResponseMap;
          //The Map of AVCV records which needs to be updated for ePos Validation Interface
          Map<Id, AV_CV__c> UpdateAVCVMap = new MAp<ID, Av_cv__C>() ;
          //The Map of Drop CAF records which needs to be updated for ePos Validation Interface
          Map<Id, Drop_CAF__c> UpdateDropCAFMap = new MAp<ID, Drop_CAF__c>() ;
          //This list will be updated for SSP Account webservice.
          List<Company__C> Companylist = new List<Company__C>();
        
          for(Empower_REST__c empNew : scope)
          {System.Debug('Iteration: '+ i + '   Empower REST ID : ' + empNew.ID);
           System.Debug('Empower CAF : '+ empNew.User_Input_1__c) ;
            HttpRequest req = new HttpRequest();
                  req.setMethod('POST');
                  req.setEndpoint(empNew.Endpoint__c);
                  req.setHeader('Content-Type', 'application/json');
                  req.setTimeout(120000);
           		  if(String.isNotBlank(empNew.JSON__C))
                  req.setBody(empNew.JSON__C);
                  Http http = new Http();
                  HttpResponse res;
                   i++;
                try { System.Debug('Request: '+ req);
                     System.Debug('Request Body : '+ req.getBody());
                    if(! Test.isRunningTest())
                      res = http.send(req);
                    else
                    {
                        res=new HttpResponse();
                        if(empNew.Endpoint__c.contains('GeneralFailure'))
                        res.setBody('{"statusMsg":"FAILURE","errorCode":"395","errorMsg":"Transaction Failed","p_err_msg":null,"p_status":"0"}');
                        else if(empNew.Endpoint__c.contains('GeneralSuccess'))
                        res.setBody('{"statusMsg":"SUCCESS","errorCode":null,"errorMsg":null,"p_err_msg":null,"p_status":"1"}');
                        else if(empNew.Endpoint__c.contains('BCSuccess'))
                        res.setBody('{"status":"success","errorCode":null,"errorMsg":null,"p_err_msg":null,"p_status":"1"}');
                        else if(empNew.Endpoint__c.contains('BCFailure'))
                        res.setBody('{"status":"failure","errorCode":"abcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacababcabcabacabacabacab","errorMsg":null,"p_err_msg":null,"p_status":"1"}');
                        else if(empNew.Endpoint__c.contains('CAFSuccess'))
                        res.setBody('{"p_err_msg":null,"p_status":"1"}');
                        else if(empNew.Endpoint__c.contains('CAFFailure'))
                        res.setBody('{"p_err_msg":null,"p_status":"0"}');
                        else if(empNew.Endpoint__c.contains('CAF403Failure'))
                        res.setBody('{"p_err_msg":"Authorization Failure","p_status":"403"}');
                        else if(empNew.Endpoint__c.contains('SSP'))
                        res.setBody('{"v_parent_acct_nbr":"abcabcabc"}');    
                        else if(empNew.Endpoint__c.contains('CalloutException'))
                        throw new System.CalloutException();
                        else if(empNew.Endpoint__c.contains('JSONE'))
                        throw new System.JSONException();
                    
                    }
                    //System.debug('STATUS: ' + res.getStatus()+' STATUS_CODE:' + res.getStatusCode() );
                    System.Debug('Response:  '+ res ) ;
                    System.Debug('Response Body :  '+ res.getBody() ) ;
                      empNew.Response__c = res+ '\n' +res.getBody() ;
                    ResponseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                   //Sample Response
                   // ResponseMap=(Map<String, Object>)JSON.deserializeUntyped('{"p_err_msg":null,"p_status":"1"}') ;
                    /*String s = '{"statusMsg":"FAILURE","errorCode":"395","errorMsg":"Transaction Failed"}';
                    //ResponseMap = (Map<String, Object>)JSON.deserializeUntyped(s);
                    //system.Debug('RESPONSE MAP generated: '+ResponseMap); */
                    
                    //Code to add Success info on Empower REST record
                    if((String.ValueOf(ResponseMap.get('statusMsg')) == 'SUCCESS') || (String.ValueOf(ResponseMap.get('status')) == 'BC In Progress') || (String.ValueOf(ResponseMap.get('status')) == 'success'))
                    { if((String.ValueOf(ResponseMap.get('statusMsg')) == 'SUCCESS'))
                        empNew.Status__c = String.ValueOf(ResponseMap.get('statusMsg')) ;
                      else if( (String.ValueOf(ResponseMap.get('status')) == 'BC In Progress') || (String.ValueOf(ResponseMap.get('status')) == 'success'))
                        empNew.Status__c = 'SUCCESS' ;
                      empNew.Error_Code__c = null;
                      empNew.Error_Message__c = null;
                    }
                    //Code to add Failure info on Empower REST record
                    else if ( (String.ValueOf(ResponseMap.get('statusMsg')) == 'FAILURE') || (String.ValueOf(ResponseMap.get('status')) == 'failure'))
                        {
                          if((String.ValueOf(ResponseMap.get('statusMsg')) == 'FAILURE'))
                         	 empNew.Status__c =  String.ValueOf( ResponseMap.get('statusMsg') );
                          else if((String.ValueOf(ResponseMap.get('status')) == 'failure'))
                       		 empNew.Status__c = String.ValueOf(ResponseMap.get('status')) ;
                            if(ResponseMap.get('errorCode')!=null)
                            { String x = String.ValueOf( ResponseMap.get('errorCode') );
                             if(x.length() > 254)
                             empNew.Error_Code__c = x.substring(0, 254);
                             else
                             empNew.Error_Code__c = x;    
                            }
                          empNew.Error_Message__c = String.ValueOf( ResponseMap.get('errorMsg') );
                          empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                        }
                   
                     //Code to check for CAF Validation Response
                    else if( String.IsNotBlank( empNew.User_Input_1__c) )
                    {
                       //CAF Number is Valid; update on avcv if the caf number is not changed.
                       if( String.ValueOf(ResponseMap.get('p_status')) == '1' )
                        {
                            empNew.Status__c = 'SUCCESS';
                            empNew.Error_Code__c = null;
                            empNew.Error_Message__c = null;
                            //For CAF Numbers on AVCV
                            if( empNew.getSobject('AV_CV__r') !=null && empNew.User_Input_1__c == empNew.getSobject('AV_CV__r').get( empNew.User_Input_2__c ) )
                            {if(UpdateAVCVMap.get(empNew.AV_CV__c) == null)
                                {
                                    Av_Cv__c updateAVCV = new Av_Cv__c();
                                    updateAVCV.put( 'id', empNew.AV_CV__c );
                                    updateAVCV.put( empNew.User_Input_3__c , 'Valid' );
                                    UpdateAVCVMap.put( empNew.AV_CV__c, updateAVCV ) ;
                                }
                               else
                                   {  Av_Cv__c updateAVCV = UpdateAVCVMap.get(empNew.AV_CV__c);
                                       updateAVCV.put( 'id', empNew.AV_CV__c );
                                       updateAVCV.put( empNew.User_Input_3__c , 'Valid' );
                                       UpdateAVCVMap.put( empNew.AV_CV__c, updateAVCV ) ;
                                   }
                            }
                            //For CAF Number on Drop CAF
                            else if( empNew.getSobject('Drop_CAF__r') !=null && empNew.User_Input_1__c == empNew.getSobject('Drop_CAF__r').get( empNew.User_Input_2__c ) )
                            {
                                    Drop_CAF__c updateDropCAF = new Drop_CAF__c();
                                    updateDropCAF.put( 'id', empNew.Drop_CAF__c );
                                    updateDropCAF.put( empNew.User_Input_3__c , 'Valid' );
                                    UpdateDropCAFMap.put( empNew.Drop_CAF__c, updateDropCAF ) ;
                            }
                            
                        }
                        //CAF Number is Invalid; update on avcv if the caf number is not changed.
                        else if( String.ValueOf(ResponseMap.get('p_status')) == '0' )
                        {
                            empNew.Status__c = 'SUCCESS';
                            empNew.Error_Code__c = null;
                            empNew.Error_Message__c = null;
                            //For CAF Numbers on AVCV
                            if( empNew.getSobject('AV_CV__r') !=null && empNew.User_Input_1__c == empNew.getSobject('AV_CV__r').get( empNew.User_Input_2__c ) )
                            {if(UpdateAVCVMap.get(empNew.AV_CV__c) == null)
                                {
                                    Av_Cv__c updateAVCV = new Av_Cv__c();
                                    updateAVCV.put( 'id', empNew.AV_CV__c );
                                    updateAVCV.put( empNew.User_Input_3__c , 'Invalid' );
                                    UpdateAVCVMap.put( empNew.AV_CV__c, updateAVCV ) ;
                                }
                               else
                                   {  Av_Cv__c updateAVCV = UpdateAVCVMap.get(empNew.AV_CV__c);
                                       updateAVCV.put( 'id', empNew.AV_CV__c );
                                       updateAVCV.put( empNew.User_Input_3__c , 'Invalid' );
                                       UpdateAVCVMap.put( empNew.AV_CV__c, updateAVCV ) ;
                                   }
                            }
                            //For CAF Number on Drop CAF
                            else if( empNew.getSobject('Drop_CAF__r') !=null && empNew.User_Input_1__c == empNew.getSobject('Drop_CAF__r').get( empNew.User_Input_2__c ) )
                            {
                                    Drop_CAF__c updateDropCAF = new Drop_CAF__c();
                                    updateDropCAF.put( 'id', empNew.Drop_CAF__c );
                                    updateDropCAF.put( empNew.User_Input_3__c , 'Invalid' );
                                    UpdateDropCAFMap.put( empNew.Drop_CAF__c, updateDropCAF ) ;
                            }
                        }
                        else if( String.ValueOf(ResponseMap.get('p_status')) != Null )
                        {
                            empNew.Status__c = 'FAILURE';
                            if(ResponseMap.get('p_err_msg')!=null)
                            { String x = String.ValueOf( ResponseMap.get('p_err_msg') );
                             if(x.length() > 254)
                             empNew.Error_Message__c = x.substring(0, 254);
                             else
                             empNew.Error_Message__c = x;    
                            }
                          empNew.Error_Code__c = String.ValueOf(ResponseMap.get('p_status'));
                          empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                        }
                    }
                     //Code Block for SSP Account Webservice.
                    else if( String.IsNotBlank( empNew.User_Input_4__c) )
                    {
                        if( ResponseMap.containsKey('v_parent_acct_nbr') )
                        { empNew.Status__c = 'SUCCESS';
                          empNew.Error_Code__c = null;
                          empNew.Error_Message__c = null;
                          if( String.IsNotBlank( empNew.Company__c ) )
                          {
                              Company__c modifiedCompany = new Company__C();
                              modifiedCompany.id = empNew.Company__c ;
                              modifiedCompany.SSP_Account__c = String.ValueOf( ResponseMap.get('v_parent_acct_nbr') ) ;
                              Companylist.add( modifiedCompany );
                          }
                             
                        }
                          
                    }
                    //System.Debug(ResponseMap.get('statusMsg'));
                    //System.Debug(ResponseMap.get('errorCode'));
                    //System.Debug(ResponseMap.get('errorMsg'));
                    
                    } 
                   catch (System.CalloutException e) 
                   {
                    System.Debug('Callout Exception Occurred!');
                      //Code to add Error info on Empower REST record
                      System.Debug(e);
                      empNew.Status__c = 'Error' ;
                      empNew.Response__c = e.getMessage() ;
                      empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                    continue;
                   }
           
                catch (Exception e) 
                   {
                    System.Debug('Exception Occurred!');
                      //Code to add Error info on Empower REST record
                      System.Debug(e);
                      empNew.Status__c = 'Error' ;
                      empNew.Response__c = e.getMessage() ;
                      empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                    continue;
                   }
          }
          if(UpdateAVCVMap.size() > 0)
          {List<AV_CV__C> avcvlist = new List<AV_CV__C>();
              for(ID key : UpdateAVCVMap.Keyset())
                  avcvlist.add(UpdateAVCVMap.get(key));
           update avcvlist ;
          }
          if(UpdateDropCAFMap.size() > 0)
          {List<Drop_CAF__c> dropCAFlist = new List<Drop_CAF__c>();
                  dropCAFlist.addall(UpdateDropCAFMap.values());
           update dropCAFlist ;
          }
          upsert scope;
          update Companylist;
    }
    
    

}