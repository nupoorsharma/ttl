/*
 * Name        : PurchaseOrderInterface
 * Description : PurchaseOrderInterface class is used to generate the Empower REST records for Purchase Order
 * Author      : Abhishek Tyagi (Compro Technologies)
 * Created On  : 6 April 2016
 */
/*
 * Change Log History:
* |---------------------------------------------------------------------|
* | Version | Changes By | Date   | Description                         |
* |---------------------------------------------------------------------|
* |   0.1   | Abhishek   | 06-04-16 |Initial version of Class           |
* |   0.2   | Rahul      | 01-06-16 |New version of class with          |
* |								    |"BillingdispatchLocation" field    | 
* |									|replacement		                |
* |---------------------------------------------------------------------|   
*/

public without sharing class PurchaseOrderInterface {

	static Map<String,FieldInfo> JSOn_Field_Map{get;set;}
    public static RESTEndpointURL__c Endpoint{get;set;}
   
    // Class for JSON Object
  public class PurchaseOrderJSON{
	public String soid;
	public String product;
	public String tariffID;
	public String poNumber;
	public String custPoDate;
	public String billingModel;
	public String revenueShare;
	public String rentalAmount;
	public String custCategory;
	public String minGuarantee;
	public String custAltNumber;
	public String poID;
	public String poQuantity;
	public String custEmailID;
	public String salesID;
	public String salesName;
	public String billDispatchLocation;
	public String accountCategory;
	public String dealerCode;
	public String inquiryCenter;
	public String marketCode;
	public String olid;
	public String omAccountNumber;
	public String parentAccNumber;
	public String salesDealerCode;
	public String validityFrom;
	public String validityPeriod;
	public String validityTo;
	public String wifiPoId;
	public String saName;
	public String gofName;
	public String pmName;
	public String companyName;	
	public String avcvIdentifier;
    public List<BillAddressDtls> billAddressDtls;
	public String authKey;
	public String transactionID;
	public String inputText1;
	public String inputText2;
	public String inputText3;
	public String inputText4;
	public String inputText5;
	public String inputText6;
	public String inputText7;
	public String inputText8;
	public String inputText9;
	public String inputText10;
    
	
	}

	public class BillAddressDtls {
		public String fanNo;
		public String parentCafDate;
		public String parentCafNo;
		public String parentAddress1;
		public String parentAddress2;
		public String parentAddress3;
		public String parentCircle;
		public String parentCity;
		public String parentPincode;
		public String pointACafDate;
		public String pointACafNo;
		public String ptAddress1;
		public String ptAddress2;
		public String ptAddress3;
		public String pointACircle;
		public String pointACity;
		public String ptAPincode;
		public String pointBCafDate;
		public String pointBCafNo;
		public String ptBAddress1;
		public String ptBAddress2;
		public String ptBAddress3;
		public String pointBCircle;
		public String pointBCity;
		public String ptBPincode;
		public String nldCafDate;
		public String nldCafNo;
		public String nldAddress1;
		public String nldAddress2;
		public String nldAddress3;
		public String nldCircle;
		public String nldCity;
		public String nldPincode;
		public String dropCaf;
		public String exitApplicable;
		public String srfCopfId;
		public String srfCustSiteId;
		public String srfFarEndId;
		public String srfLmsId;
	}
    
    public static void initializeJSOn_Field_Map()
    {
        // Not required
    }  



	public static List<SObject> executeQuery(List<SObject> newsObjList)
    {
        String query = 'select ID, Name, AvCv_Identifier__c, Opportunity__r.SOID__c, WiFi_PO_ID__c, Product__r.Name,	Product__r.Product_Type__c,	Tariff__r.TARID__c,	PO_Number__c,' +
            'Date__c,	Billing_model__c,	Percentage_of_revenue_share__c,	Rental_Amount__c,	Customer_Category__c,	Minimum_guarantee__c,'+
            'Customer_Alternate_Phone_Number__c, Opportunity__r.Account.Account_Category__c,	PO_ID__c,	PO_Quantity__c,	Customer_Email_ID__c,	Opportunity__r.Owner.IDM_Id__c,	Opportunity__r.Owner.Name,	Bill_Dispatch_Location_Integration__c,'+
            'Opportunity__r.Owner.AccountID,	Dealer_Code__c,	Inquiry_Ctr__c,	Market_Code__c,	OLID__c,'+
            'Opportunity__r.Owner.Sales_Code__c,	Validity_Starts_From__c,	Validity_Period__c,	Validity_Date__c,'+
            'Solution_Architect_Team__c,	Geography_Order_Fulfillment_Team__c,	Program_Manager__c,	Opportunity__r.Account.Name	,'+
            'Authentication_Key__c, Input_text1__c,Input_text2__c,Input_text3__c,Input_text4__c,Input_text5__c,Input_text6__c,'+
            'Input_text7__c,Input_text8__c,Input_text9__c,Input_text10__c,Transaction_ID__c,  Solution_Architect_Team1__r.Name, Geography_Order_Fulfillment_Team1__r.Name, Program_Manager1__r.Name	,'+
            '(select ID, FAN_No__r.FAN_Number__c,	Parent_CAF_Date__c	,Parent_CAF_No__c,	Parent_Billing_Address_1__c,	Parent_Billing_Address_2__c,'+
            'Parent_Billing_Address_3__c,	Parent_Billing_Circle__c,	Parent_Billing_City__c,	Parent_Billing_Pincode__c,	CAF_Date__c,'+
            'Point_CAF_No__c,	Point_A_Address_1__c,	Point_A_Address_2__c,	Point_A_Address_3__c,	Point_Billing_Circle__c,	Point_Billing_City__c,	Point_A_Pincode__c,'+
            'Point_B_CAF_Date__c, Point_B_CAF_No__c,	Point_B_Address_1__c,	Point_B_Address_2__c,	Point_B_Address_3__c,	Point_B_Circle__c,'+
            'Point_B_City__c,	Point_B_Pincode__c,	NLD_CAF_Date__c,	NLD_CAF_No__c,	NLD_Address_1__c,	NLD_Address_2__c,	NLD_Address_3__c,	NLD_Circle__c,	NLD_City__c,'+
            'NLD_Pincode__c,	Drops_CAF_Numbers__c,	Exit_Applicable__c,	SRF_COPF_ID__c,	SRF_CUST_SITE_ID__c,	SRF_FAR_END_SITE_ID__c,	SRF_LMS_ID__c,	AVCV_Id__c, '+
            'Parent_Billing_City1__r.Name , NLD_City1__r.Name, Point_A_City1__r.Name, Point_B_City1__r.Name, '+
            'Parent_Billing_Pincode1__r.Name, NLD_Pincode1__r.Name,  Point_A_Pincode1__r.Name, Point_B_Pincode1__r.Name '+
            'from av_cv__r) '+
            'from Purchase_Order__c';
        String q = query +' WHERE Id IN :newsObjList';
        System.debug(newsObjList);
        System.debug(q);
        List<SObject> SObjList = Database.query(q);
        return SObjList;
    }

	
	
	 public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList )
    {

  	//	Map<String, Object> PurchaseOrderJSON_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new PurchaseOrderJSON()));
    //    Map<String, Object> BillAddressDtls_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new BillAddressDtls()));
        List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
        for(SObject sObj : sObjList)
        {
            Empower_REST__c empNew = new Empower_REST__c();
            Purchase_Order__c PO = (Purchase_Order__c)sObj;
            List<AV_CV__c> listACVC = PO.AV_CV__r;
            
            
            PurchaseOrderJson poJSON = new PurchaseOrderJson();
            
         //   poJSON.soid = GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.SOID__c');
            poJSON.soid= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.SOID__c');
			poJSON.product= GenerateEmpowerREST.GetFieldValue(sObj,'Product__r.Name');
			poJSON.tariffID= GenerateEmpowerREST.GetFieldValue(sObj,'Tariff__r.TARID__c');
			poJSON.poNumber= GenerateEmpowerREST.GetFieldValue(sObj,'PO_Number__c');
			poJSON.custPoDate= convertDate(sObj, 'Date__c');
			poJSON.billingModel= GenerateEmpowerREST.GetFieldValue(sObj,'Billing_model__c');
			poJSON.revenueShare= GenerateEmpowerREST.GetFieldValue(sObj,'Percentage_of_revenue_share__c');
			poJSON.rentalAmount= GenerateEmpowerREST.GetFieldValue(sObj,'Rental_Amount__c');
			poJSON.custCategory= GenerateEmpowerREST.GetFieldValue(sObj,'Customer_Category__c');
			poJSON.minGuarantee= GenerateEmpowerREST.GetFieldValue(sObj,'Minimum_guarantee__c');
			poJSON.custAltNumber= GenerateEmpowerREST.GetFieldValue(sObj,'Customer_Alternate_Phone_Number__c');
			poJSON.poID= GenerateEmpowerREST.GetFieldValue(sObj,'Name');
			poJSON.poQuantity= GenerateEmpowerREST.GetFieldValue(sObj,'PO_Quantity__c');
			poJSON.custEmailID= GenerateEmpowerREST.GetFieldValue(sObj,'Customer_Email_ID__c');
			poJSON.salesID= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Owner.IDM_Id__c');
			poJSON.salesName= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Owner.Name');
			poJSON.billDispatchLocation= GenerateEmpowerREST.GetFieldValue(sObj,'Bill_Dispatch_Location_Integration__c');
			poJSON.accountCategory= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Account.Account_Category__c');
			poJSON.dealerCode= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Owner.AccountID');
			poJSON.inquiryCenter= GenerateEmpowerREST.GetFieldValue(sObj,'Inquiry_Ctr__c');
			poJSON.marketCode= GenerateEmpowerREST.GetFieldValue(sObj,'Market_Code__c');
			poJSON.olid= GenerateEmpowerREST.GetFieldValue(sObj,'OLID__c');
			poJSON.omAccountNumber= '';  //Passing blank value
			poJSON.parentAccNumber= '';  //Passing blank value
			poJSON.salesDealerCode= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Owner.Sales_Code__c');
            poJSON.validityFrom= GenerateEmpowerREST.GetFieldValue(sObj,'Validity_Starts_From__c');
            poJSON.validityPeriod= GenerateEmpowerREST.GetFieldValue(sObj,'Validity_Period__c');
            poJSON.validityTo= convertDate(sObj, 'Validity_Date__c' );
            poJSON.wifiPoId= GenerateEmpowerREST.GetFieldValue(sObj,'WiFi_PO_ID__c');
            poJSON.saName= GenerateEmpowerREST.GetFieldValue(sObj,'Solution_Architect_Team1__r.Name');
            poJSON.gofName= GenerateEmpowerREST.GetFieldValue(sObj,'Geography_Order_Fulfillment_Team1__r.Name');
            poJSON.pmName= GenerateEmpowerREST.GetFieldValue(sObj,'Program_Manager1__r.Name');
            poJSON.companyName= GenerateEmpowerREST.GetFieldValue(sObj,'Opportunity__r.Account.Name');
            poJSON.avcvIdentifier= GenerateEmpowerREST.GetFieldValue(sObj,'AVCV_Identifier__c');
            poJSON.authKey= ( String.IsNotBlank(PurchaseOrderInterface.EndPoint.Auth_Key__c) ? PurchaseOrderInterface.EndPoint.Auth_Key__c : '');
            poJSON.transactionID= GenerateEmpowerREST.GetFieldValue(sObj,'Id');
            poJSON.inputText1= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text1__c');
            poJSON.inputText2= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text2__c');
            poJSON.inputText3= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text3__c');
            poJSON.inputText4= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text4__c');
            poJSON.inputText5= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text5__c');
            poJSON.inputText6= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text6__c');
            poJSON.inputText7= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text7__c');
            poJSON.inputText8= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text8__c');
            poJSON.inputText9= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text9__c');
            poJSON.inputText10= GenerateEmpowerREST.GetFieldValue(sObj,'Input_text10__c');

            
			List<BillAddressDtls> l = new List<BillAddressDtls>();
            
            for(AV_CV__c ac: listACVC){
                BillAddressDtls baJSON = new BillAddressDtls();
               // baJSON.fanNo = GenerateEmpowerREST.GetFieldValue(ac,'APIName');
               // = GenerateEmpowerREST.GetFieldValue(baJSON,'
                baJSON.fanNo= GenerateEmpowerREST.GetFieldValue(ac,'FAN_No__r.FAN_Number__c');
                baJSON.parentCafDate= convertDate(ac,'Parent_CAF_Date__c');
                baJSON.parentCafNo= GenerateEmpowerREST.GetFieldValue(ac,'Parent_CAF_No__c');
                baJSON.parentAddress1= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_Address_1__c');
                baJSON.parentAddress2= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_Address_2__c');
                baJSON.parentAddress3= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_Address_3__c');
                baJSON.parentCircle= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_Circle__c');
                baJSON.parentCity= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_City1__r.Name');
                baJSON.parentPincode= GenerateEmpowerREST.GetFieldValue(ac,'Parent_Billing_Pincode1__r.Name');
                baJSON.pointACafDate= convertDate(ac,'CAF_Date__c');
                baJSON.pointACafNo= GenerateEmpowerREST.GetFieldValue(ac,'Point_CAF_No__c');
                baJSON.ptAddress1= GenerateEmpowerREST.GetFieldValue(ac,'Point_A_Address_1__c');
                baJSON.ptAddress2= GenerateEmpowerREST.GetFieldValue(ac,'Point_A_Address_2__c');
                baJSON.ptAddress3= GenerateEmpowerREST.GetFieldValue(ac,'Point_A_Address_3__c');
                baJSON.pointACircle= GenerateEmpowerREST.GetFieldValue(ac,'Point_Billing_Circle__c');
                baJSON.pointACity= GenerateEmpowerREST.GetFieldValue(ac,'Point_A_City1__r.Name');
                baJSON.ptAPincode= GenerateEmpowerREST.GetFieldValue(ac,'Point_A_Pincode1__r.Name');
                baJSON.pointBCafDate= convertDate(ac,'Point_B_CAF_Date__c');
                baJSON.pointBCafNo= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_CAF_No__c');
                baJSON.ptBAddress1= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_Address_1__c');
                baJSON.ptBAddress2= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_Address_2__c');
                baJSON.ptBAddress3= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_Address_3__c');
                baJSON.pointBCircle= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_Circle__c');
                baJSON.pointBCity= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_City1__r.Name');
                baJSON.ptBPincode= GenerateEmpowerREST.GetFieldValue(ac,'Point_B_Pincode1__r.Name');
                baJSON.nldCafDate= convertDate(ac,'NLD_CAF_Date__c');
                baJSON.nldCafNo= GenerateEmpowerREST.GetFieldValue(ac,'NLD_CAF_No__c');
                baJSON.nldAddress1= GenerateEmpowerREST.GetFieldValue(ac,'NLD_Address_1__c');
                baJSON.nldAddress2= GenerateEmpowerREST.GetFieldValue(ac,'NLD_Address_2__c');
                baJSON.nldAddress3= GenerateEmpowerREST.GetFieldValue(ac,'NLD_Address_3__c');
                baJSON.nldCircle= GenerateEmpowerREST.GetFieldValue(ac,'NLD_Circle__c');
                baJSON.nldCity= GenerateEmpowerREST.GetFieldValue(ac,'NLD_City1__r.Name');
                baJSON.nldPincode= GenerateEmpowerREST.GetFieldValue(ac,'NLD_Pincode1__r.Name');
                baJSON.dropCaf= GenerateEmpowerREST.GetFieldValue(ac,'Drops_CAF_Numbers__c');
                baJSON.exitApplicable= GenerateEmpowerREST.GetFieldValue(ac,'Exit_Applicable__c');
                baJSON.srfCopfId= GenerateEmpowerREST.GetFieldValue(ac,'SRF_COPF_ID__c');
                baJSON.srfCustSiteId= GenerateEmpowerREST.GetFieldValue(ac,'SRF_CUST_SITE_ID__c');
                baJSON.srfFarEndId= GenerateEmpowerREST.GetFieldValue(ac,'SRF_FAR_END_SITE_ID__c');
                baJSON.srfLmsId= GenerateEmpowerREST.GetFieldValue(ac,'SRF_LMS_ID__c');

                
                l.add(baJSON);
            }
            
			poJSON.billAddressDtls = l; 
            
            // creating final JSON
         
        	String JSON_String = JSON.serialize(poJSON); 
        	System.debug('PO JSON-----'+ JSON_String);
        
            
        	empNew.Purchase_order__c = sObj.ID;
            empNew.Endpoint__c = PurchaseOrderInterface.EndPoint.Endpoint__c ;
            empNew.JSON__c = JSON_String ;
            empNew.Status__c = 'New' ;
            empNew.Priority__c = PurchaseOrderInterface.EndPoint.Priority__c ;
            empNew.Retrial_Count__c = 0 ;
            empNew.Key__c = sObj.id +'~PurchaseOrder~new';
            if(String.IsNotBlank(empNew.JSON__c))
             //Add the Empower_REST__c record to the return list.
             empRESTList.add(empNew);
            
        }  
		return empRESTList;
    }
    
     public static String convertDate( SObject sObj , String FieldName )
     {
         String returnVAl = '';
         if( sObj.get(FieldName) != null)
         { Datetime dte = Datetime.newInstance(Date.valueOf(sObj.get(FieldName)).year(), Date.valueOf(sObj.get(FieldName)).month(), Date.valueOf(sObj.get(FieldName)).day());
		   returnVAl = dte.format('MM/dd/yyyy');
         }
         return returnVAl;
     }
    
  }