/*
 * Name        : EmpowerRESTScheduler
 * Description : EmpowerRESTScheduler class is used to schedule the Batch Class EmpowerRESTBatch.
 *               Scope is set to 100 to handle 100 callout/transaction limit.
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 2 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class EmpowerRESTScheduler implements Schedulable{

    global void execute(SchedulableContext sc)
    {
        System.Debug('EmpowerRESTSccheduler------------ execute()');
        EmpowerRESTBatch EmpowerRESTBatchObject = new EmpowerRESTBatch();
         Database.ExecuteBatch(EmpowerRESTBatchObject,100);
    }
}