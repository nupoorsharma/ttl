/*
 * Name        : EmpowerRESTBatch
 * Description : EmpowerRESTBatch class processes the callouts for Empower REST records and updates the status back.
 * 			     The scope is set to 100 records/execute call to handle the callout limit.
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 2 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class EmpowerRESTBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

      global Database.QueryLocator start(Database.BatchableContext BC)
      { System.Debug('EmpowerRESTBatch------------- START()');
		//Query all Empower_REST__c records ordered by the priority where retrial count<3 and status is New/Error/Failure
        String query='Select Id, Endpoint__c, Error_Code__c, Error_Message__c, JSON__c, Priority__c, Retrial_Count__c, Status__c, '
                     +'AV_CV__c, User_Input_1__c, User_Input_2__c, User_Input_3__c , User_Input_4__c, Av_Cv__r.Point_CAF_No__c,'
            		 + 'Av_Cv__r.CAF_No__c, Av_Cv__r.NLD_CAF_No__c, Av_Cv__r.Parent_CAF_No__c, Av_Cv__r.Point_B_CAF_No__c, Company__c, '
                     + 'Drop_CAF__c, Drop_CAF__r.CAF_Number__c, Drop_CAF__r.CAF_Status__c  '
                     + 'from Empower_REST__c where Retrial_Required__c=true order by Priority__c';
        return Database.getQueryLocator(query);

      }
      
      global void execute(Database.BatchableContext BC,List<Empower_REST__c> scope)
      { 
          System.Debug('EmpowerRESTBatch------------- EXECUTE()');
          ExecuteCallouts.execute(scope);
          /*
          Integer i=0;
          //The statusMsg = value, errorCode=value, errorMessage=value
          Map<String, Object> ResponseMap;
          
          for(Empower_REST__c empNew : scope)
          {System.Debug('Iteration: '+ i + '   Empower REST ID : ' + empNew.ID);
            HttpRequest req = new HttpRequest();
                  req.setMethod('POST');
                  req.setEndpoint(empNew.Endpoint__c);
                  req.setHeader('Content-Type', 'application/json');
           		  req.setTimeout(6000);
           		  req.setBody(empNew.JSON__C);
                  Http http = new Http();
                  HttpResponse res;
                   i++;
                try {
                    res = http.send(req);
                    System.debug('STATUS: ' + res.getStatus()+' STATUS_CODE:' + res.getStatusCode() );
                    //Code to add Success info on Empower REST record
                    ResponseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    //String s = '{"statusMsg":"FAILURE","errorCode":"395","errorMsg":"Transaction Failed"}';
                    //ResponseMap = (Map<String, Object>)JSON.deserializeUntyped(s);
                    //system.Debug('RESPONSE MAP generated: '+ResponseMap);
                    if((String.ValueOf(ResponseMap.get('statusMsg')) == 'SUCCESS'))
                        empNew.Status__c = String.ValueOf(ResponseMap.get('statusMsg')) ;
                    else if ( (String.ValueOf(ResponseMap.get('statusMsg')) == 'FAILURE') )
                        {
                          empNew.Status__c =  String.ValueOf( ResponseMap.get('statusMsg') );
                          empNew.Error_Code__c = String.ValueOf( ResponseMap.get('errorCode') );
                          empNew.Error_Message__c = String.ValueOf( ResponseMap.get('errorMsg') );
                          empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                        }
                    //System.Debug(ResponseMap.get('statusMsg'));
                    //System.Debug(ResponseMap.get('errorCode'));
                    //System.Debug(ResponseMap.get('errorMsg'));
                    
                    } 
                   catch (System.CalloutException e) 
                   {
                    System.Debug('Callout Exception Occurred!');
                      //Code to add Error info on Empower REST record
                      empNew.Status__c = 'Error' ;
                      empNew.Retrial_Count__c = (empNew.Retrial_Count__c!=null ? ++empNew.Retrial_Count__c : 1);
                    continue;
                   }
          }
          
          upsert scope; */
      }
      
      global void finish(Database.BatchableContext BC)
      {
        System.Debug('EmpowerRESTBatch------------- FINISH()');

        /* AsyncApexJob a = [Select Id,Status,NumberOfErrors,JobItemsProcessed,TotalJobItems,CreatedBy.Email
                           From AsyncApexJob where id= :BC.getJobId()];
         
              Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
              email.setSubject('BatchExample Run Report');
              email.setPlainTextBody('Out of '+a.TotalJobItems+' items , '+a.JobItemsProcessed+' items have been processed. \n'
              +'Number of Failures: '+a.NumberOfErrors);
              String[] toAddresses = new String[] {a.CreatedBy.Email};
              email.setToAddresses(toAddresses);
              Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});*/
      }
    
}