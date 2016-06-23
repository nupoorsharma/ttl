/*
 * Name        : IntegrationStatusViewerController
 * Description : IntegrationStatusViewerController class is used to as the extension for
 *               ALL Integration Status Viewer VisualForce pages for the objects:
 *               Feasibility__c, AV_CV__c, Purchase_Order__c, Business_CAse__c, 
 *               Account, Opportunity
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 8 June 2016
 * Change Log History:
 * |---------------------------------------------------------------|
 * | Version | Changes By | Date   | Description                   |
 * |---------------------------------------------------------------|
 * |   0.1   | Nupoor     | 08-06-16 |Initial version of Class     |
 * |---------------------------------------------------------------|  
*/
public without sharing class IntegrationStatusViewerController{

    //The text shown on VF under the label "Error Code"
    public static String ErrorCode{get;set;}
    //The label "Error Code" is shown when this variable is true
    public static Boolean RenderErrorCode{get;set;}
    //The text shown on VF under the label "ActionRequired"
    public static String ActionRequired{get;set;}
    //The label "Action Required" is shown when this variable is true
    public static Boolean RenderActionRequired{get;set;}
    //The link to Errored Integration Status
    public static String Link{get;set;}
    //The label link is shown to User_Category__c "Governance" when this variable is true
    public static Boolean RenderLink{get;set;}
    
    // Constructor for initializing the variables and populating them.
    public IntegrationStatusViewerController(ApexPages.StandardController controller) 
    {
       Schema.DescribeSObjectResult FANResult = Feasibility__c.SObjectType.GetDescribe();
       String FANKey = FANResult.getKeyPrefix();
       Schema.DescribeSObjectResult POResult = Purchase_Order__c.SObjectType.GetDescribe();
       String POKey = POResult.getKeyPrefix();
       Schema.DescribeSObjectResult BCResult = Business_Case__c.SObjectType.GetDescribe();
       String BCKey = BCResult.getKeyPrefix();
       Schema.DescribeSObjectResult AVCVResult = Av_CV__c.SObjectType.GetDescribe();
       String AVCVKey = AVCVResult.getKeyPrefix();
       ErrorCode = '' ;
       ActionRequired = null ;
       Link = null ;
       ID RecordID = ApexPages.CurrentPage().getparameters().get('Id');
        //Depending on the Object Type Call the method to populate Text in ErrorCode / ActionRequired
        if(String.ValueOf(RecordID).startsWith(FANKey))
        {
            getFeasibilityStatus( RecordID );
        }
        else if(String.ValueOf(RecordID).startsWith(POKey))
        {
            getPurchaseOrderStatus( RecordID );
        }
        else if(String.ValueOf(RecordID).startsWith(BCKey))
        {
            getBusinessCaseStatus( RecordID );
        }
        else if(String.ValueOf(RecordID).startsWith(AVCVKey))
        {
            getAVCVStatus( RecordID );
        }
        RenderErrorCode = String.IsNotBlank(ErrorCode) ;
        RenderActionRequired =String.IsNotBlank(ActionRequired)  ;
        RenderLink =String.IsNotBlank(Link)  ;
    }
    
    /*
     * getFeasibilityStatus()
     * Purpose : Set the text in Action Required and Error code based on the below Scenarios
     *           => SSP Account Interface
                    SSP Account Request Submitted-	     SSP_Submitted
                    SSP Account Request Failed-	         FAN_SSP_Failure
                    SSP Account Request Failed/Retrial - Retrial_Error
     *           => Feasibility interface
                    FAN Submitted (In Progress), backupdate pending-	Fan_Submitted_In_Progress
                    FAN Submitted (Success), backupdate pending-	    FAN_Submitted_Success
                    FAN Submitted, 395 error/Retrial-	                Retrial_Error
                    FAN Submitted, 395 error (3 times)-	                FAN_Failure
                    Fan Submitted, other errors-	                    FAN_Failure
      *
      */
    public static void getFeasibilityStatus(ID RecordID)
    {
        System.Debug('IntegrationStatusViewerController --------> getFeasibilityStatus()') ;
        Feasibility__C FAN = [Select ID, Is_Single_Invoice_Required__c, SSP_Account_Integration__c, Feasibility_Status__c, Opportunity__r.Company__c, Submit_to_AMT__c, 
                              (Select ID, Status__C, error_Code__c, retrial_required__c from Empower_REST__r order by LastModifiedDate desc) 
                              from Feasibility__c where ID= :RecordID];
		//Get the Empower Rest record for ssp account interface if the below conditions are true
        if((FAN != null) &&  (FAN.Submit_to_AMT__c==false) 
           && (FAN.Is_Single_Invoice_Required__c == 'Y') && String.ISBlank(FAN.SSP_Account_Integration__c) 
           && String.ISNotBlank(FAN.Opportunity__r.Company__c))
        {
         ID CompanyID = FAN.Opportunity__r.Company__c;
         List<Empower_Rest__C> SSPStatusList = new List<Empower_Rest__c>([Select ID, Status__C, error_Code__c, retrial_required__c, Company__r.SSP_Account__c from empower_rest__c where Company__c= :CompanyID order by LastModifiedDate desc]);
         if( !SSPStatusList.isEmpty() )
         {
             if( SSPStatusList[0].Status__c.equalsIgnoreCase('New') || SSPStatusList[0].Status__c.equalsIgnoreCase('In Progress'))
                 ActionRequired = System.Label.SSP_Submitted ;
             else if( ((SSPStatusList[0].Status__c.equalsIgnoreCase('Failure') ||  SSPStatusList[0].Status__c.equalsIgnoreCase('Error') ) 
                        && SSPStatusList[0].retrial_required__c == false)
                     ||  (SSPStatusList[0].Status__c.equalsIgnoreCase('Success') && String.IsBlank(SSPStatusList[0].Company__r.SSP_Account__c) )
                    )
                {ActionRequired = System.Label.FAN_SSP_Failure ;
                 ErrorCode = SSPStatusList[0].Error_Code__c ;
                 Link = '/'+SSPStatusList[0].id;
                }
             else if( (SSPStatusList[0].Status__c.equalsIgnoreCase('Failure') || SSPStatusList[0].Status__c.equalsIgnoreCase('Error') ) && SSPStatusList[0].retrial_required__c == true ) 
                 {
                    ActionRequired = System.Label.Retrial_Error ;
                    ErrorCode = SSPStatusList[0].Error_Code__c ; 
                    Link = '/'+SSPStatusList[0].id;
                 }
         }
        }
        else if(FAN!=null && FAN.Submit_to_AMT__c==true && !FAN.Empower_Rest__r.IsEmpty()) 
        {
            Empower_Rest__c StatusRecord = FAN.Empower_Rest__r[0];
            if(StatusRecord.Status__c.equalsIgnoreCase('New') 
               || StatusRecord.Status__c.equalsIgnoreCase('In Progress')
              )
                ActionRequired = System.Label.Fan_Submitted_In_Progress;
            else if(StatusRecord.Status__c.equalsIgnoreCase('Success') && String.IsBlank(FAN.Feasibility_Status__c))
                ActionRequired = System.Label.FAN_Submitted_Success;
            else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure')  || StatusRecord.Status__c.equalsIgnoreCase('Error') )
                     && StatusRecord.Retrial_Required__c == false
                   )
            {
                 ActionRequired = System.Label.FAN_Failure ;
                 ErrorCode = StatusRecord.Error_Code__c ;
                 Link = '/' + StatusRecord.id ;
            }
             else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure') || StatusRecord.Status__c.equalsIgnoreCase('Error') ) && StatusRecord.retrial_required__c == true ) 
              {
                ActionRequired = System.Label.Retrial_Error ;
                ErrorCode = StatusRecord.Error_Code__c ; 
                Link = '/' + StatusRecord.id ;
              }
        }
    }
    
    /*
     * getBusinessCaseStatus()
     * Purpose : Set the text in Action Required and Error code based on the below Scenarios
     *           => Business Case interface
                    Business_Case__c	Calculate BC	BC_In_Progress
                    Business_Case__c	FAN Submitted, 395 error/retrial	Retrial_Error
                    Business_Case__c	FAN Submitted, 395 error (3 times)	BC_Failure
                    Business_Case__c	Fan Submitted, other errors	BC_Failure
     *
     */
     public static void getBusinessCaseStatus(ID RecordID)
     {
        System.Debug('IntegrationStatusViewerController --------> getBusinessCaseStatus()') ;
        Business_Case__c BC = [Select ID,(Select ID, Status__C, error_Code__c, retrial_required__c from Empower_REST__r order by LastModifiedDate desc) 
                              from Business_Case__c where ID= :RecordID];
         if( BC!=null && !BC.Empower_Rest__r.IsEmpty()) 
         {
            Empower_Rest__c StatusRecord = BC.Empower_Rest__r[0];
            if(StatusRecord.Status__c.equalsIgnoreCase('New') 
               || StatusRecord.Status__c.equalsIgnoreCase('In Progress')
              )
                ActionRequired = System.Label.BC_In_Progress;
            else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure')  || StatusRecord.Status__c.equalsIgnoreCase('Error') )
                     && StatusRecord.Retrial_Required__c == false
                   )
            {
                 ActionRequired = System.Label.BC_Failure ;
                 ErrorCode = StatusRecord.Error_Code__c ;
                 Link = '/' + StatusRecord.id ;
            }
             else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure') || StatusRecord.Status__c.equalsIgnoreCase('Error') ) && StatusRecord.retrial_required__c == true ) 
              {
                ActionRequired = System.Label.Retrial_Error ;
                ErrorCode = StatusRecord.Error_Code__c ; 
                Link = '/' + StatusRecord.id ;
              }

         }
   
     }
    
    /*
     * getPurchaseOrderStatus()
     * Purpose : Set the text in Action Required and Error code based on the below Scenarios
     *           => Purchase Order interface
                    PO In Progress	PO_In_Progress
                    PO Retrial	    Retrial_Error
                    PO Failure	    PO_Failure
     *
     */
     public static void getPurchaseOrderStatus(ID RecordID)
     {
        System.Debug('IntegrationStatusViewerController --------> getPurchaseOrderStatus()') ;
        Purchase_Order__c PO = [Select ID,(Select ID, Status__C, error_Code__c, retrial_required__c from Empower_REST__r order by LastModifiedDate desc) 
                              from Purchase_Order__c where ID= :RecordID];
         if( PO!=null && !PO.Empower_Rest__r.IsEmpty()) 
         {
            Empower_Rest__c StatusRecord = PO.Empower_Rest__r[0];
            if(StatusRecord.Status__c.equalsIgnoreCase('New') 
               || StatusRecord.Status__c.equalsIgnoreCase('In Progress')
              )
                ActionRequired = System.Label.PO_In_Progress;
            else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure')  || StatusRecord.Status__c.equalsIgnoreCase('Error') )
                     && StatusRecord.Retrial_Required__c == false
                   )
            {
                 ActionRequired = System.Label.PO_Failure ;
                 ErrorCode = StatusRecord.Error_Code__c ;
                 Link = '/' + StatusRecord.id ;
            }
             else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure') || StatusRecord.Status__c.equalsIgnoreCase('Error') ) && StatusRecord.retrial_required__c == true ) 
              {
                ActionRequired = System.Label.Retrial_Error ;
                ErrorCode = StatusRecord.Error_Code__c ; 
                Link = '/' + StatusRecord.id ;
              }

         }
     }
    
    /*
     * getAVCVStatus()
     * Purpose : Set the text in Action Required and Error code based on the below Scenarios
     *           => ePos Interface
                    CAF In Progress	     CAF_Validation
     *           => AVCV interface
                    AVCV In Progress	    AVCV_In_Progress
                    AVCV Retrial Required	Retrial_Error
                    AVCV Failure	        AVCV_Failure
      *
      */
     public static void getAVCVStatus(ID RecordID)
     {
        System.Debug('IntegrationStatusViewerController --------> getAVCVStatus()') ;
        AV_CV__c AVCV = [Select ID, Submit_to_AV_CV_Team__c, Valid_CAF_Status__c,
                              (Select ID, Status__C, error_Code__c, retrial_required__c from Empower_REST__r where User_Input_1__c=null order by LastModifiedDate desc) 
                              from AV_CV__c where ID= :RecordID];
         if(AVCV!=null && AVCV.Submit_to_AV_CV_Team__c==false && AVCV.Valid_CAF_Status__c==false)
                ActionRequired = System.Label.CAF_Validation ;
         else if(AVCV!=null && AVCV.Submit_to_AV_CV_Team__c==true && !AVCV.Empower_Rest__r.isEmpty())
         {
            Empower_Rest__c StatusRecord = AVCV.Empower_Rest__r[0];
            if(StatusRecord.Status__c.equalsIgnoreCase('New') 
               || StatusRecord.Status__c.equalsIgnoreCase('In Progress')
              )
                ActionRequired = System.Label.AVCV_In_Progress;
            else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure')  || StatusRecord.Status__c.equalsIgnoreCase('Error') )
                     && StatusRecord.Retrial_Required__c == false
                   )
            {
                 ActionRequired = System.Label.AVCV_Failure ;
                 ErrorCode = StatusRecord.Error_Code__c ;
                 Link = '/' + StatusRecord.id ;
            }
             else if( (StatusRecord.Status__c.equalsIgnoreCase('Failure') || StatusRecord.Status__c.equalsIgnoreCase('Error') ) && StatusRecord.retrial_required__c == true ) 
              {
                ActionRequired = System.Label.Retrial_Error ;
                ErrorCode = StatusRecord.Error_Code__c ; 
                Link = '/' + StatusRecord.id ;
              }
         }
     }
}