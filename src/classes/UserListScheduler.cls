/*
 * Name        : UserListScheduler
 * Description : UserListScheduler class is used to schedule the Batch Class UserListBatch.
 *               UserListBatch will fetch the PO Team records from USERLIST interface 
 *               and deactivate the old PO Team records.
 *               CRON: '0 0 1 * * ?' runs everyday at 1 AM
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 30 May 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 02/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
global without sharing class UserListScheduler implements Schedulable{

    global void execute(SchedulableContext sc)
    {
        System.Debug('UserListScheduler------------ execute()');
        UserListBatch UserListBatchObject = new UserListBatch();
         Database.ExecuteBatch(UserListBatchObject);
    }
}