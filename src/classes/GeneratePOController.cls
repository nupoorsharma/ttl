/*
    * Name: GeneratePOController Class
    * Created On: June 4, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Extension for Visualforce Page GeneratePO
    *              Called From: Generate PO link on Business Case.
    *              Purpose : Insertion of a Purchase_order__c record with the BC details populated.
    *                        Redirection to the edit page of the newly created Purchase_order__c record.
    *                        If a Purchase order for that opportunity exists, an exception is thrown. 
    *                        The error message is picked from the custom label 
    *                        PO_Already_Exists.                          
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 04-06-16 |Initial version of Class  |
    * |------------------------------------------------------------|
*/
public class GeneratePOController {

    
    //The Business_Case__C record which needs to be updated.
    public Business_Case__c myBC{get;set;}
    
    //The ID of newly ceated Purchase Order
    public String RecordID{get;set;}
    //Error message to be displayed if an exception occurs.
    public String errorMsg{get;set;}
    //The ID of existing PO
    public String referenceID{get;set;}
    //The state of Database at the start of transaction
    Savepoint sp{get;set;}
    
    /*
     * Constructor
     * Purpose: Gets the details on BC record.
     */
    public GeneratePOController(ApexPages.StandardController controller)
    {
        RecordID='';
        errorMsg='';
        referenceID='';
        myBC = [Select Id, Approval_Status__c, Submit_BC__c, Opportunity__c, Opportunity__r.Is_Macd_Opportunity__c, Product__c, Product__r.FAN_Category__c, (Select ID from Purchase_Orders__r) from Business_Case__c where id = :ApexPages.CurrentPage().getparameters().get('Id')];
    }
    
    /*
     * Redirect()
     * Purpose : Checks if PO needs to be created.
     *           Calls the execute() method of BusinessCaseTriggerHandler which internally calls:
     *            =>Create PO
     *            =>Create AVCV
     *            If a PO already exists, Error is shown from custom label PO_Already_Exists
     *            Additionally, the id of existing PO is set in referenceID
     *            BC Updates: Approval Status = PO Created, Submit_BC__c = True
     */
    public void Redirect()
    { System.debug('Inside GeneratePOController ----------- Redirect()');
      sp = Database.setSavepoint();
     try
     {
          List<Purchase_Order__c> POList = myBC.Purchase_Orders__r;
          if( !POList.isEmpty())
          {
              errorMsg = System.Label.PO_Already_Exists ;
              referenceID = POList[0].id;
          }
         else
         {
             List<Business_Case__c> BCList = new List<Business_Case__c>();
             BCList.add(myBC);
             List<Purchase_Order__c> NewPOList = BusinessCaseTriggerHandler.createPORecords(BCList);
             //The Logic to create PO is contained in createPORecords() of BusinessCaseTriggerHandler.
             if(!NewPOList.isEmpty())
             {RecordID = NewPOList[0].id;
              List<AV_CV__c> AVCVList = BusinessCaseTriggerHandler.createAV_CVRecords(BCList);
             //The Logic to create AVCV records is contained in createAV_CVRecords() of BusinessCaseTriggerHandler.
			  if(!AVCVList.isEmpty())
              {
                 
                 System.Debug(LoggingLevel.FINE, '###### AVCV List: '+ AVCVList);
                  //Add Drop CAF for NPLC - L2MC
                  if( myBC.Product__r!=Null && myBC.Product__r.FAN_Category__c == 'NPLC')
                    BusinessCaseTriggerHandler.createDropCAF(AVCVList, myBC.Opportunity__r.Is_Macd_Opportunity__c );  
                 myBC.Approval_Status__c = 'PO Created';
                 myBC.Submit_BC__c = true;
                 update myBC;
              }
              else
              {  // Rollback the transaction if AVCV records were not created
                 errorMsg = 'System failed to create the CAF & AVCV records' ;
                 Database.rollback(sp);
              }              
             }
             else
             {   // Rollback the transaction if PO record was not created
                 errorMsg = 'System failed to create a Purchase Order' ;
                 Database.rollback(sp);
             }
             
         }
      }
      catch(Exception ex)
      {
          System.Debug(LoggingLevel.ERROR , 'An exception has Occured: '+ ex );
          System.Debug(LoggingLevel.ERROR , ex.getStackTraceString() );
          errorMsg = ex.getMessage();
          Database.rollback(sp);
      }
   }
}