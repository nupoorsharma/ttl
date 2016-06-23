/*
 * Name        : AVCVInterface
 * Description : AVCVInterface class is used to generate the Empower REST records for AV/CV
 * Author      : Rahul Mohan (Compro Technologies)
 * Created On  : 6 April 2016
 */
/*
* Change Log History:
* |---------------------------------------------------------------|
* | Version | Changes By | Date   | Description                   |
* |---------------------------------------------------------------|
* |   0.1   | Rahul      | 06-04-16 |Initial version of Class     |
* |   0.2   | Rahul      | 25-05-16 |New version of class with    |
* |				   					|PO and Offline Flag Relation |
* |---------------------------------------------------------------|  
*/
public without sharing class AVCVInterface {
     
     // EndPoint information coming from AV/CV custom setting
     public static RESTEndpointURL__c Endpoint{get;set;}
    
    /*
		executeQuery() Purpose : Query all the fields which are required to process the JSON for AVCV
	*/
     public static List<SObject> executeQuery(List<SObject> newsObjList)
    {
        String query = 'SELECT id,AVCV_Identifier__c,Opportunity__r.SOID__c,Product__r.Name,Sub_Product_Type__c,Tariff__c,Tariff__r.TARID__c,'+
                       'Opportunity__r.Owner.IDM_Id__c,Opportunity__r.Owner.Name,Company_Name__r.Logo_Id__c,Offline_Flag__c,'+
                       'AVCV_Id__c,Auth_Key__c,Transaction_ID__c,Input_text1__c,Input_text2__c, Opportunity__r.Account.Name,'+
                       'Input_text3__c,Input_text4__c,Input_text5__c,Input_text6__c,Offline_Entry__c,'+
                       'Input_text7__c,Input_text8__c,Input_text9__c,Input_text10__c,'+
                       'FAN_No__r.FAN_Number__c,Parent_CAF_Date__c,Parent_CAF_No__c,Parent_Billing_Address_1__c,'+
                       'Parent_Billing_Address_2__c,Parent_Billing_Address_3__c,Parent_Billing_Circle__c,Parent_Billing_City__c,'+
                       'Parent_Billing_Pincode__c,CAF_Date__c,Point_CAF_No__c,Point_A_Address_1__c,'+
                       'Point_A_Address_2__c,Point_A_Address_3__c,Point_Billing_Circle__c,Point_B_City__c,'+
                       'Point_A_Pincode__c,Point_B_CAF_Date__c,Point_B_CAF_No__c,Point_B_Address_1__c,'+
                       'Point_B_Address_2__c,Point_B_Address_3__c,Point_B_Circle__c,Point_Billing_City__c,'+
            		   'Parent_Billing_City1__r.Name , NLD_City1__r.Name, Point_A_City1__r.Name, Point_B_City1__r.Name,' +
            		   'Parent_Billing_Pincode1__r.Name, NLD_Pincode1__r.Name,  Point_A_Pincode1__r.Name, Point_B_Pincode1__r.Name,' +
                       'Point_B_Pincode__c,NLD_CAF_Date__c,NLD_CAF_No__c,NLD_Address_1__c,NLD_Address_2__c,'+
                       'NLD_Address_3__c,NLD_Circle__c,NLD_City__c,NLD_Pincode__c,Drops_CAF_Numbers__c,'+
                       'Exit_Applicable__c,SRF_COPF_ID__c,SRF_CUST_SITE_ID__c,SRF_FAR_END_SITE_ID__c,'+
                       'SRF_LMS_ID__c, Product__r.Offline_Flag__c FROM AV_CV__c';
        String q = query +' WHERE Id IN: newsObjList';
        List<SObject> SObjList = Database.query(q);
        return SObjList;
    }
     
    public static void initializeJSOn_Field_Map()
    {
        // not in use
    }   
    
    /*
		CreateJSON() Purpose : This method create json data records for AVCV 
	*/
    public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList )
    {
    List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
    
     
        for(SObject sObj : sObjList)
        {
             AVCVJSON obj_Json=new AVCVJSON();
                obj_Json.soid = GenerateEmpowerREST.GetFieldValue( sObj , 'Opportunity__r.SOID__c' );
                obj_Json.product = GenerateEmpowerREST.GetFieldValue( sObj , 'Product__r.Name' );
                obj_Json.subProdType = GenerateEmpowerREST.GetFieldValue( sObj , 'Sub_Product_Type__c' );
                obj_Json.tariffID = GenerateEmpowerREST.GetFieldValue( sObj , 'Tariff__r.TARID__c' );
                obj_Json.salesID = GenerateEmpowerREST.GetFieldValue( sObj , 'Opportunity__r.Owner.IDM_ID__c' );
                obj_Json.salesName = GenerateEmpowerREST.GetFieldValue( sObj , 'Opportunity__r.Owner.Name' );
                obj_Json.companyName = GenerateEmpowerREST.GetFieldValue( sObj , 'Opportunity__r.Account.Name' );
                //obj_Json.offlineFlag = GenerateEmpowerREST.GetFieldValue( sObj , 'Product__r.Offline_Flag__c' );
                obj_Json.offlineFlag = GenerateEmpowerREST.GetFieldValue( sObj , 'Offline_Entry__c' );
                obj_Json.avcvIdentifier = GenerateEmpowerREST.GetFieldValue( sObj , 'AVCV_Identifier__c');
                obj_Json.authKey = ( String.IsNotBlank(AVCVInterface.EndPoint.Auth_Key__c) ? AVCVInterface.EndPoint.Auth_Key__c : '');
                obj_Json.transactionID = GenerateEmpowerREST.GetFieldValue( sObj , 'id' );
                obj_Json.inputText1 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text1__c' );
                obj_Json.inputText2 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text2__c' );
                obj_Json.inputText3 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text3__c' );
                obj_Json.inputText4 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text4__c' );
                obj_Json.inputText5 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text5__c' );
                obj_Json.inputText6 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text6__c' );
                obj_Json.inputText7 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text7__c' );
                obj_Json.inputText8 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text8__c' );
                obj_Json.inputText9 = GenerateEmpowerREST.GetFieldValue( sObj , 'Input_text9__c' );
                obj_Json.inputText10 = GenerateEmpowerREST.GetFieldValue( sObj ,'Input_text10__c');
                obj_Json.billAddressDtls[0].fanNo = GenerateEmpowerREST.GetFieldValue( sObj , 'FAN_No__r.FAN_Number__c' );
                obj_Json.billAddressDtls[0].parentCafDate = convertDate( sObj , 'Parent_CAF_Date__c' );
                obj_Json.billAddressDtls[0].parentCafNo = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_CAF_No__c' );
                obj_Json.billAddressDtls[0].parentAddress1 = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_Address_1__c' );
                obj_Json.billAddressDtls[0].parentAddress2 = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_Address_2__c' );
                obj_Json.billAddressDtls[0].parentAddress3 = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_Address_3__c' );
                obj_Json.billAddressDtls[0].parentCircle = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_Circle__c' );
                obj_Json.billAddressDtls[0].parentCity = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_City1__r.Name' );
                obj_Json.billAddressDtls[0].parentPincode = GenerateEmpowerREST.GetFieldValue( sObj , 'Parent_Billing_Pincode1__r.Name' );
                obj_Json.billAddressDtls[0].pointACafDate = convertDate( sObj , 'CAF_Date__c' );
                obj_Json.billAddressDtls[0].pointACafNo = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_CAF_No__c' );
                obj_Json.billAddressDtls[0].ptAddress1 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_A_Address_1__c' );
                obj_Json.billAddressDtls[0].ptAddress2 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_A_Address_2__c' );
                obj_Json.billAddressDtls[0].ptAddress3 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_A_Address_3__c' );
                obj_Json.billAddressDtls[0].pointACircle = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_Billing_Circle__c' );
                obj_Json.billAddressDtls[0].pointACity = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_A_City1__r.Name' );
                obj_Json.billAddressDtls[0].ptAPincode = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_A_Pincode1__r.Name' );
                obj_Json.billAddressDtls[0].pointBCafDate = convertDate( sObj , 'Point_B_CAF_Date__c' );
                obj_Json.billAddressDtls[0].pointBCafNo = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_CAF_No__c' );
                obj_Json.billAddressDtls[0].ptBAddress1 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_Address_1__c' );
                obj_Json.billAddressDtls[0].ptBAddress2 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_Address_2__c' );
                obj_Json.billAddressDtls[0].ptBAddress3 = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_Address_3__c' );
                obj_Json.billAddressDtls[0].pointBCircle = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_Circle__c' );
                obj_Json.billAddressDtls[0].pointBCity = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_City1__r.Name' );
                obj_Json.billAddressDtls[0].ptBPincode = GenerateEmpowerREST.GetFieldValue( sObj , 'Point_B_Pincode1__r.Name' );
                obj_Json.billAddressDtls[0].nldCafDate = convertDate( sObj , 'NLD_CAF_Date__c' );
                obj_Json.billAddressDtls[0].nldCafNo = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_CAF_No__c' );
                obj_Json.billAddressDtls[0].nldAddress1 = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_Address_1__c' );
                obj_Json.billAddressDtls[0].nldAddress2 = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_Address_2__c' );
                obj_Json.billAddressDtls[0].nldAddress3 = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_Address_3__c' );
                obj_Json.billAddressDtls[0].nldCircle = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_Circle__c' );
                obj_Json.billAddressDtls[0].nldCity = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_City1__r.Name' );
                obj_Json.billAddressDtls[0].nldPincode = GenerateEmpowerREST.GetFieldValue( sObj , 'NLD_Pincode1__r.Name' );
                obj_Json.billAddressDtls[0].dropCaf = GenerateEmpowerREST.GetFieldValue( sObj , 'Drops_CAF_Numbers__c' );
                obj_Json.billAddressDtls[0].exitApplicable = GenerateEmpowerREST.GetFieldValue( sObj , 'Exit_Applicable__c' );
                obj_Json.billAddressDtls[0].srfCopfId = GenerateEmpowerREST.GetFieldValue( sObj , 'SRF_COPF_ID__c' );
                obj_Json.billAddressDtls[0].srfCustSiteId = GenerateEmpowerREST.GetFieldValue( sObj , 'SRF_CUST_SITE_ID__c' );
                obj_Json.billAddressDtls[0].srfFarEndId = GenerateEmpowerREST.GetFieldValue( sObj , 'SRF_FAR_END_SITE_ID__c' );
                obj_Json.billAddressDtls[0].srfLmsId = GenerateEmpowerREST.GetFieldValue( sObj , 'SRF_LMS_ID__c' );

            String JSON_String = JSON.serialize(obj_Json);
            Empower_REST__c empNew = new Empower_REST__c(); 
            empNew.AV_CV__c= sObj.id ;
            empNew.Endpoint__c = AVCVInterface.EndPoint.Endpoint__c ; 
            empNew.JSON__c = JSON_String ;
            empNew.Status__c = 'New' ;
            empNew.Priority__c = AVCVInterface.EndPoint.Priority__c ;
            empNew.Retrial_Count__c = 0 ;
            empNew.Key__c = sObj.id +'~avcv~new';
            if(String.IsNotBlank(empNew.JSON__c))
             empRESTList.add(empNew);
        
        }
        
        return empRESTList;
    }
     
    /*
		convertDate() Purpose : This method convert date field record in a specified format
   */
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