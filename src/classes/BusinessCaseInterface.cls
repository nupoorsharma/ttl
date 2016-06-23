/*
 * Name        : BusinesscaseInterface
 * Description : BusinessCaseInterface class is used to generate the Empower REST records for Business case
 * Author      : Abhishek Tyagi (Compro Technologies)
 * Created On  : 8 April 2016
 */


public without sharing class BusinessCaseInterface {
    
    
    public static RESTEndpointURL__c Endpoint{get;set;}
    public static Set<ID> BCIDs = new Set<ID>();
    
    public static void initializeJSOn_Field_Map()
    {
        // Not required
    } 
    
    public static List<SObject> executeQuery(List<SObject> newsObjList){
        
        for(Sobject obj: newsObjList){
            BCIDs.add((ID)obj.get('ID'));
        }
        System.debug('BCIDs set size ----------'+BCIDs.size());
      //  System.debug('BCIDs set ----------'+BCIDs);
          String query = 'select Id, Additional_Charges_FAN__c,  ARC_Discount__c,  ARC_Discount_B__c,'+
              '  Backhaul_Capex__c,  Backhaul_Opex_per_month__c,  Bandwidth__c,  Bandwidth_Units__c,  Blitz_Amount__c,  Blitz_Discount__c,'+
              '  Blitz_Charges__c,  Business_Case__c,  Capex__c,  COMMON_WBSE_AMOUNT__c,  COMMON_WBSE_NO__c,'+
              '  Cos_Type__c,  Cos_Variant__c,  Demo_Period__c,  Distance__c,  Drop_Amount__c,  Drop_OTC__c,  External_ID__c,'+
              '  Feasibility__c,  Gross_MSR_Point_A__c,  Gross_MSR_point_B__c, Gross_ARC_LL_Rental_in_Rs__c, Installation_And_Testing_Charges__c,'+
              '  Installation_And_Testing_Charges_B__c,Manage_Service_Charges__c,Discount_on_Manage_Service_Charges__c,Manage_Service_Charges_NetAmount__c,MSR_Gross_in_Rs__c, Gross_SLA_Charges_in_Rs__c,One_Time_Charges_from_Customer_in_Rs__c, IP_Additional_Charges__c,  IP_Additional_Charges_Discount__c,'+
              '  IP_CAPTURE_FLAG__c,  L2MC_Discount__c, Lastmile_Discount__c,'+
              '  Manage_Service__c,  Manage_Service_Location__c,  Manage_Service_Type__c,  MEDIA__c,MSR_Discount__c,'+
              '  MSR_Discount_B__c,  Net_ARC_LL_Rental_in_Rs__c,  Net_ARC_LL_Rental_Net_SLA_Charges__c,'+
              '  Net_ARC_LL_Rental_Net_SLA_Charges_B__c,  Net_ARC_LL_Rental_B__c,Secondary_Last_Mile_Charges_Discount__c,Secondary_Last_Mile_Charges_Net_Amount__c,  Net_IP_Additional_Charges__c,  Net_L2MC__c,'+
              '  Net_Last_Mile_Amount__c,  Net_MSR__c,  Net_MSR_B__c,  Net_NLD_LL_Rental__c,L2MC_from_customer_in_Rs__c,Net_NLD_LL_Rental_Net_SLA_Charges__c,'+
              '  Net_NLD_SLA_Charges__c,  Net_One_Time_Charges_B__c,  Net_One_Time_Charges_from_Customer__c,  Net_Shifting_Charges__c,'+
              '  Net_Shifting_Charges_B__c,  Net_SLA_Charges__c,  Net_SLA_Charges_B__c,  Network_Type__c,'+
              '  NLD_LL_Discount__c,  NLD_SLA_Discount__c,  No_of_Channels__c,business_case__r.Opportunity__r.Aggregate_Period_Revision__c,business_case__r.Opportunity__r.Renewal_Revision__c,'+
              '  No_of_DIDs__c,  No_Of_IP_s__c,Bandwidth_Rental_Charges_Gross_Amount__c,Bandwidth_Rental_Charges_Discount__c,Bandwidth_Rental_Charges_Net_Amount__c,  Opex_per_month__c,  OTC_Discount__c,  OTC_Discount_B_in__c,'+
              '  Part_Code__c,  Photon_Charges__c,  Price_Type__c,  Product__c,  RANGE__c,  Rate_Card__c,'+
              '  Rate_of_Additional_Charges_DID__c,  Router_Charges__c,  Router_Make__c,  Shifting_Charges_Amount__c,'+
              '  Shifting_Charges_Amount_B__c,  Shifting_Discount__c,  Shifting_Discount_B_in__c,  SLA_Discount__c,'+
              '  SLA_Discount_B__c,  Total_Additional_Charges__c,  Type__c,  Variant_Type__c,  WBSE_AMOUNT1__c,  WBSE_AMOUNT2__c,'+
              '  WBSE_AMOUNT3__c,  WBSE_ID1__c,  WBSE_ID2__c,  WBSE_ID3__c,business_case__r.Opportunity__r.BC_MACD_Type__c,'+
              'NE_Rental_Gross_Amount__c,NE_Rental_Discount__c,NE_Rental_Net_Amount__c,Hardware_Support_Charges__c,'+
              'Secondary_LM_Gross_Amount__c,MPLS_Port_BW_Charges_Gross_Amount__c,MPLS_Port_BW_Charges_Discount__c,'+
              'MPLS_Port_BW_Charges_Net_Amount__c,Gross_ARC_LL_Rental_Point_A__c,ARC_Discount_Point_A__c,'+
              'Net_ARC_LL_Rental_Point_A__c,Gross_ARC_LL_Rental_Point_B__c,Gross_SLA_Charges_Point_A__c,'+
              'SLA_Discount_Point_A__c,Net_SLA_Charges_Point_A__c,Gross_SLA_Charges_Point_B__c,'+
              'One_Time_Charges_from_Customer_Point_A__c,OTC_Discount_Point_A__c,Net_OTC_Customer_Point_A__c,'+
              'One_Time_Charges_from_Customer_Point_B__c,NE_Rental_Gross_Amount_Point_A__c,NE_Rental_Discount_Point_A__c,'+
              'NE_Rental_Net_Amount_Point_A__c,NE_Rental_Gross_Amount_Point_B__c,NE_Rental_Discount_Point_B__c,'+
              'NE_Rental_Net_Amount_Point_B__c,Shifting_Charges_Amount_Point_A__c,Shifting_Discount_Point_A__c,'+
              'Net_Shifting_Charges_Point_A__c,NLD_LL_Rental_Gross_Amount__c,NLD_SLA_Charges_Gross_Amount__c,'+
              'Installation_Testing_Charges_Point_A__c,Net_ARC_LL_Rental_Net_SLA_Charges_A__c,'+              
              'Feasibility__r.No_of_DIDs_Extensions__c,Feasibility__r.Preferred_Media_A_End__c, Feasibility__r.No_of_Channels__c,Feasibility__r.Network_Type__c,'+
              ' Feasibility__r.Circle__c ,Feasibility__r.Order_Size_No_of_DELs__c,Feasibility__r.Activity_Type__c,Feasibility__r.Last_Mile__c,Feasibility__r.Name, Feasibility__r.city__r.Name,Feasibility__r.FAN_Number__c,Feasibility__r.Customer_Type__c,Feasibility__r.billing_circle__c,Feasibility__r.Product_Variant__c, business_case__r.Opportunity__r.Product__r.name, '+
              ' business_case__r.Opportunity__c,Business_Case__r.Lock_In_Amount__c,business_case__r.Type_of_customer__c, business_case__r.Circle__c, business_case__r.Opportunity__r.Type, business_case__r.Opportunity__r.TCL_Feasibility_Flag__c,'+
              ' business_case__r.Opportunity__r.SOID__c,business_case__r.EPABX_Rental_3rd_Party_Integration__c,'+
              'Business_case__r.Opportunity__r.Owner.Email,business_case__r.EPABX_Drop__c, business_case__r.Self_Use_or_Commercial__c,business_case__r.Plan_Name__c,business_case__r.OSP_MW_Capex__c,'+
              'business_case__r.Modems__c,business_case__r.Miscellaneous_Capex__c,business_case__r.FCV_Per_Channel_in_Rs__c,'+
              'business_case__r.I_R_Agency_Charges_Payable__c,business_case__r.Inbuilding_Wiring__c,business_case__r.Lastmile_Bandwidth_Charges_Payable__c,'+
              'business_case__r.Network_Electronics__c,business_case__r.Recurring_PROW_Rental__c,business_case__r.Miscellaneous_Project__c,'+
              'business_case__r.SIP_Trunk_Card__c,business_case__r.EPABX__c,business_case__r.Miscellaneous_EPABX__c,'+
              'business_case__r.Number_of_Phone_Instruments__c,business_case__r.Total_Phone_Instruments_Amount__c,business_case__r.EPABX_Hiring_Rental_Payable_to_3rd_Party__c,'+
              'business_case__r.EPABX_AMC_Charges__c,business_case__r.Capex_Comments__c,business_case__r.OTC_Payable_to_Third_party_for_Last_Mile__c,'+
              'business_case__r.EPABX_Rental_Discount__c,business_case__r.SIP_Trunk_Card_Bill_Discount__c,business_case__r.Total_Direct_Cost__c,'+
              'business_case__r.Subtotal__c,business_case__r.Type_of_Request__c,business_case__r.Total_Capex__c,business_case__r.Capex_Subtotal__c,'+
              ' Feasibility__r.Opportunity__r.Owner.Email,business_case__r.Green_Channel__c, '+
              'business_case__r.EPABX_Phone_Instrument_Charges__c,business_case__r.EPABX_Device_Charges__c,business_case__r.EPABX_NIU_Rack_Charges__c,'+
              'business_case__r.EPABX_Miscellaneous_Project__c,business_case__r.EPABX_OTC__c,business_case__r.Total_Additional_Charges__c,'+
              'business_case__r.Handset_Type__c,business_case__r.Handset_Plan_Name__c,business_case__r.Handset_Special_Price__c,'+
              'business_case__r.Device_Details__r.Make_Model__c,business_case__r.Down_Payment__c,business_case__r.EMI_Handset__r.EMI_Amount__c,'+
              'business_case__r.Device_Details__r.Lock_In_Amount__c,business_case__r.Device_Details__r.Lock_In_Period__c,'+
              'business_case__r.EMI_Handset__r.Number_of_Months__c,business_case__r.Device_Details__r.Cost__c,business_case__r.Device_Details__r.Material_Code__c,'+
              'business_case__r.EMI_Handset__r.EMI_Handset_Type__c,business_case__r.EMI_Handset__r.EMI_Handset_Plan_Name__c,'+
              'business_case__r.otcCrossConnect__c,business_case__r.otcPayableCrossConnect__c,business_case__r.Total_OTC__c,'+
              'business_case__r.FCV_Per_Channel_in__c,business_case__r.Non_Recurring_Charges__c,business_case__r.lock_period__c,'+
                'business_case__r.SIP_Trunk_Card_Discount_Month_Proposer__c,business_case__r.No_of_months_SIP_Trunk_Rental_Discount__c,'+
              '  business_case__r.Payment_Terms__c,business_case__r.Check_Rate_Revision_Rate__c,business_case__r.Sponsored_CPE_Required__c,business_case__r.Product__r.Empower_Product__c,business_case__r.Product__r.BC_Category__c, business_case__r.Request_ID__c,business_case__r.Product__r.Empower_Sub_Product__c, business_case__r.Billing_Cycle__c, business_case__r.Source_of_Sale__c, business_case__r.AdvanceArrears__c,  business_case__r.One_Time_Acquisition_Cost__c,'+
              '  business_case__r.Link_Contract_Period__c,business_case__r.Market_Code__c,business_case__r.Plan_Applicability__c,  business_case__r.Effective_Date__c,  business_case__r.Account_Type__c,  business_case__r.Current_account_number__c,'+
              '  business_case__r.Channel_Commision__c,  business_case__r.Tariff_Plan_Type_Proposed__c,  business_case__r.Device_Type__c,  business_case__r.Minimum_Order_Size_No_of_dels__c,'+
              '  business_case__r.Type_of_Plan__c,  business_case__r.Rental_amount__c,  business_case__r.Description__c,  business_case__r.Free_Call_Value_Amount__c,'+
              '  business_case__r.Description_Free_Val__c,  business_case__r.New_One_Time_Charges_amount__c,  business_case__r.Taxable__c,  business_case__r.Description_NRC__c,'+
              '  business_case__r.Call_Wait__c,  business_case__r.Call_Forward__c,  business_case__r.Voicemail__c,  business_case__r.CLIP__c,  business_case__r.Threeway_Conference__c,'+
              '  business_case__r.Itemised_Bill__c,business_case__r.Total_Capex_A_B__c,   business_case__r.LocalProposer__c,'+
              'business_case__r.Additional_Usage_Type__c,business_case__r.Rental_Waiver_Del__c,business_case__r.NE_Rentals_Payable_to_3rd_Party__c,'+
              'business_case__r.Additional_Usage_Charges_Rs_Kb__c,business_case__r.RW_ID_Charge__c,business_case__r.RW_ARC__c,'+
              'business_case__r.RW_OTC__c,business_case__r.ARP_Amount__c,business_case__r.ARP_Duration__c,'+
              'business_case__r.ARP_Free_GB_Discount_Month__c,business_case__r.Type_of_Plan_Continuation__c,business_case__r.ARP_to_be_Charged_In__c,'+
              'business_case__r.Advance_Deposit_Amount__c,business_case__r.Advance_Deposit_Description__c,business_case__r.Billing_Frequency__c,'+
              'business_case__r.Prop_rental_Mandatory__c,business_case__r.Prop_Free_Mandatory__c,business_case__r.Data_Usage_Details_in_GB_Free_Usage__c,'+
              ' business_case__r.Wifi_Zone__r.Zone_id__c, business_case__r.Wifi_Zone__r.Zone_Network_Id__c,business_case__r.Wifi_Zone__r.Name,'+
              '  business_case__r.IntraProposer__c,business_case__r.EPABX_Rentals__c,  business_case__r.InterProposer__c,  business_case__r.RoamingProposer__c,  business_case__r.ILDProposer__c,'+
              '  business_case__r.MOU_in_Mins_per_DELProposer__c,  business_case__r.Revenue_ShareProposer__c,  business_case__r.AMC_Requirement__c,'+
              '  business_case__r.PRI_Card_Discount_Month_RsProposer__c,business_case__r.Tariff_plan_required__c,  business_case__r.Noof_months_for_PRI_Rental_discount__c,  business_case__r.Rental_per_month__c,'+
              '  business_case__r.Noof_months_for_EPABX_Rental_discount__c,Business_Case__r.TARID__c,  business_case__r.EPABX_Type__c,'+ 
              'business_case__r.Rollover_Discount__c,Business_case__r.Status_Change_Integration__c, business_case__r.No_Of_Months__c,business_case__r.Calling_Levels__c,'+
              'business_case__r.Discount_Restricted_Propsr__c,business_case__r.Proration_Propsr__c,business_case__r.Free_SMS_in_Number__c,'+
              'business_case__r.Free_SMS_Mandatory__c,business_case__r.SMS_Description_Local_STD_Roaming__c,business_case__r.Additional_ISD_Amount_Initial__c,'+
              'business_case__r.Bill_Discount_Amount_1__c,business_case__r.TARID_Status_Integration__c, business_case__r.Bill_Discount_Percentage_1__c,business_case__r.Bill_Discount_Amount_2__c,'+
              'business_case__r.Bill_Discount_Percentage_2__c,business_case__r.Bill_Discount_Amount_3__c,business_case__r.Bill_Discount_Percentage_3__c,'+
              'business_case__r.Installation_Circle__c,business_case__r.Direct_Lines__c,'+
              'business_case__r.Extensions__c,business_case__r.FWT_NIU_Drop__c,business_case__r.opportunity__r.Green_Channel_Opportunity__c,'+
              'business_case__r.CLI_Instrument__c,business_case__r.Rack__c,business_case__r.AMC_to_be_born_by_TTL__c,'+
              'business_case__r.EPABX_Device_Type__c,business_case__r.EPABX_FWT_NIU_Subsidy_Charges__c,'+
              ' Feasibility__r.Feasibility_Status__r.OSP_CAPEX__c, Feasibility__r.Feasibility_Status__r.NW_ELECTRONICS_CAPEX__c,'+
              ' Feasibility__r.Feasibility_Status__r.MODEMS__c, Feasibility__r.Feasibility_Status__r.MISC_CAPEX__c, Feasibility__r.Feasibility_Status__r.IR_CHARGES__c,'+
              ' Feasibility__r.Feasibility_Status__r.INBUILD_WIRING_CHARGES__c, Feasibility__r.Feasibility_Status__r.LASTMILE_BW_CHARGES__c,'+
              ' Feasibility__r.Feasibility_Status__r.NET_RENTAL__c, Feasibility__r.Feasibility_Status__r.PROW_RENTAL__c,'+
              ' Feasibility__r.Feasibility_Status__r.PROJ_MISC__c, Feasibility__r.Feasibility_Status__r.EPABX_RENTAL__c,'+
              'Feasibility__r.Feasibility_Status__r.OTC_TP__c,'+
              'Feasibility__r.Feasibility_Status__r.EPABX_DISCOUNT__c,'+
              'Feasibility__r.Feasibility_Status__r.PRI_DISCOUNT__c,'+
              ' (select CPE_Ownership__c,Is_CPE_Required__c,Equipment_Type__c,Router__r.Equipment_Type__c,Router__r.CDMA_MAT_CODE__c,Router__r.Part_Code__c,Router__r.Router_Make__c,Router__r.Amount__c,Manage_Service__c,Net_MSR_in_Rs__c,Manage_Service_Charges__c,Discount_on_Manage_Service_Charges__c,Manage_Service_Location__c,Type_of_Equipment_Used_by_Customer__c,CPE_charges__c,CPE_Charges_Discount__c,CPE_Charges_Net_Amount__c,UTM_Flag__c from cpe_details__r) ,'+
              ' (select Drop_Id__c, Drop_Amount_Formula__c, drop_OTC__c from Bc_Drops__r)'+
              ' from Fan_bc__c where business_case__c in :BCIDs';
       // String query = 'select bc fields .... (select fanbc fields from fan_bc__c) from business_case__c where id IN :newsObjList';    
        System.debug('query-------'+query);
        List<SObject> SObjList = Database.query(query);
        system.debug('query result---' + SObjList.size());
         system.debug('query result---' + SObjList);
        
        
           return SObjList;   
        
    }
    
    public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList ){

        String query2 = generateTariffQuery(BCIDs);
        List<Business_case__c> BCTariffList = Database.query(query2);
        Map<ID,Business_case__c> BCTariffMap = new Map<ID,Business_case__c>();
        for(Business_case__c bcTariff: BCTariffList){
            BCTariffMap.put(bcTariff.ID,bcTariff);
        }
        
        List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
        Map<Id,BusinessCaseJSON> bcMAP = new Map<ID,BusinessCaseJSOn>();
        
        for(SObject fanbc: sObjList){
            
            System.debug('----------------Inside FANBC---------------');
           
            String productCheck = GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Product__r.BC_Category__c');
            System.debug('product name is ----'+ productCheck); 
            
            if(!bcMaP.containsKey((Id)fanbc.get('business_case__c'))){
            
                BusinessCaseJSON bcjson = new BusinessCaseJSON();
               
                bcjson.tarid= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.TARID__c');
                bcjson.soid= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Opportunity__r.SOID__c');
                bcjson.requestId= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Request_ID__c');
                bcjson.productType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Product__r.Empower_Product__c');
                
                if('DLC~ILL~MPLS~NPLC~WiFi'.contains(productCheck)){
                    bcjson.subProdType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Product__r.Empower_Sub_Product__c');
                    bcjson.subProductType= '';
                }
                else{
                    bcjson.subProdType='';
                    bcjson.subProductType = GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Product__r.Empower_Sub_Product__c');
                }
                bcjson.paymentTerms= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Payment_Terms__c');
                bcjson.billingCycle= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Billing_Cycle__c');
                bcjson.billingTypeCb= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.AdvanceArrears__c');
                bcjson.otacqAmtIni= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.One_Time_Acquisition_Cost__c');
                bcjson.validityPeriod= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Link_Contract_Period__c');
                bcjson.modificationType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Opportunity__r.BC_MACD_Type__c');
             
                //   Datetime dt = Date.parse(GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Effective_Date__c'));
            //   Datetime dte = Datetime.newInstance(Date.valueOf(sObj.get('CreatedDate')).year(), Date.valueOf(sObj.get('CreatedDate')).month(), Date.valueOf(sObj.get('CreatedDate')).day());
                if(GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Effective_Date__c')!= ''){
                    Datetime dt = Date.valueOf(GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Effective_Date__c'));
                    bcjson.effectiveDate=  dt.format('yyyy-MM-dd');
                 }
                else bcjson.effectiveDate= '';
             //   bcjson.effectiveDate= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Effective_Date__c');
                bcjson.mplsCpeRequired=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Sponsored_CPE_Required__c');
                bcjson.linkAggregatePeriodRevisionFlag= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Opportunity__r.Aggregate_Period_Revision__c');
                bcjson.rateRenewalRevisionFlag= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Opportunity__r.Renewal_Revision__c');
                bcjson.greenChannel= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Green_Channel__c');
              
                bcjson.taridStatus = GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.TARID_Status_Integration__c');
                
                if('DLC~ILL~MPLS~NPLC~Wireline'.contains(productCheck)){
                    bcjson.hsiaEvp='';
                    bcjson.sourceOfSale= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Source_of_Sale__c');     
                }
                else{
                    bcjson.hsiaEvp= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Source_of_Sale__c');
                    bcjson.sourceOfSale='';
                }
          
                //     -----------------------SIP Mapping -----------------
                if('SIP~GSM~WireLessVoice~EPABX'.contains(productCheck)){
                    bcjson.customerType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Plan_Applicability__c');
                }else if(productCheck.equalsIgnoreCase('Wireline')){
                    bcjson.customerType=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Type_of_customer__c');
                }else if(productCheck.equalsIgnoreCase('3GDongle'))
                    bcjson.customerType=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Tariff_plan_required__c');
                else
                    bcjson.customerType='';
                    
                bcjson.marketCode= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Market_Code__c');
                bcjson.planType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Tariff_Plan_Type_Proposed__c');
                bcjson.reqTypeId= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Type_of_Request__c');
                bcjson.deviceType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Type__c');
                bcjson.typeofPlan= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Type_of_Plan__c');
               
                bcjson.localInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.LocalProposer__c');
                bcjson.intraInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.IntraProposer__c');
                bcjson.interInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.InterProposer__c');
                bcjson.roamingInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.RoamingProposer__c');
                bcjson.ildInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.ILDProposer__c');
                bcjson.rentalPerDelInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Rental_amount__c');
                bcjson.rentalPropDescr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Description__c');
                bcjson.totalSipTrunkFreeVal= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.FCV_Per_Channel_in__c');
                if(productCheck.equalsIgnoreCase('3GDongle'))
                    bcjson.freeValPerDelInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Data_Usage_Details_in_GB_Free_Usage__c');
                else
                    bcjson.freeValPerDelInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.FCV_Per_Channel_in_Rs__c');
                
                bcjson.freevalPropDescr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Description_Free_Val__c');
                bcjson.nrcRental= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Non_Recurring_Charges__c');
                bcjson.nrcTaxable= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Taxable__c');
                bcjson.nrcDescr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Description_NRC__c');
                bcjson.emuInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.MOU_in_Mins_per_DELProposer__c');
                bcjson.rentalpermonthInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.SIP_Trunk_Card_Discount_Month_Proposer__c');
                bcjson.nomEpabxRD= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.No_of_months_SIP_Trunk_Rental_Discount__c');
                bcjson.priCardDiscountPerMonthInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Rentals__c');
                bcjson.nomPriRD= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Noof_months_for_EPABX_Rental_discount__c');
                bcjson.revInit= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Revenue_ShareProposer__c');
                bcjson.callWait= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Call_Wait__c');
                bcjson.callForward= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Call_Forward__c');
                bcjson.voiceMail= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Voicemail__c');
                bcjson.clip= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.CLIP__c');
                bcjson.wayConf= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Threeway_Conference__c');
                bcjson.itemBill= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Itemised_Bill__c');
               
               // ------------------------GSM-------------------
                bcjson.accountType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Account_Type__c');
                bcjson.typeOfCustomer= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Type_of_customer__c');
                bcjson.allCircles=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Circle__c');
                bcjson.currentAccountNumber= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Current_account_number__c');
                
                
                bcjson.checkRRR= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Check_Rate_Revision_Rate__c');
                bcjson.channelcommision= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Channel_Commision__c');
                
                bcjson.flagList= 'Non-FTSP';
                bcjson.newIshndset= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Type__c');
                
                bcjson.handsetType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Handset_Type__c');
                bcjson.handsetplaname= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Handset_Plan_Name__c'); //na
                bcjson.hndsetSplPriPropos = GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Handset_Special_Price__c');     
         //       -------------start 3g dongle sheet-----------------
                
                bcjson.handsetmodelPropos= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Details__r.Make_Model__c') ;
                bcjson.upfrontamountPropos= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Down_Payment__c') ;
                
                if(GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Type__c').equals('Device on EMI')){
                    bcjson.emiamountPropos= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EMI_Handset__r.EMI_Amount__c') ;
                    bcjson.noofmonthsPropos= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EMI_Handset__r.Number_of_Months__c') ;
                }else
                {
                    bcjson.emiamountPropos='0';
                    bcjson.noofmonthsPropos='0';
                }
                bcjson.handsetcostPropos= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Details__r.Cost__c') ;
                bcjson.materialcodeProps=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Details__r.Material_Code__c') ;
                bcjson.handsetSplPrice= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Handset_Special_Price__c') ;
                bcjson.emihandsetType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EMI_Handset__r.EMI_Handset_Type__c') ;
                bcjson.emihandsetplaname= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EMI_Handset__r.EMI_Handset_Plan_Name__c') ;
                
                
                bcjson.freeUsgTyp= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Additional_Usage_Type__c') ;
                bcjson.hsiarevShare= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Rental_Waiver_Del__c') ;
                bcjson.orderSize= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Minimum_Order_Size_No_of_dels__c');
                bcjson.rateperunit=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Additional_Usage_Charges_Rs_Kb__c') ;
                bcjson.rwIdCharge=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.RW_ID_Charge__c') ;
                bcjson.rwArc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.RW_ARC__c') ;
                bcjson.rwOtc=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.RW_OTC__c') ;
                
               
                bcjson.arpAmount=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.ARP_Amount__c') ;
                bcjson.arpDuration=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.ARP_Duration__c') ;
                bcjson.arpFreeGBAmt=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.ARP_Free_GB_Discount_Month__c') ;
                bcjson.typeofplanCont= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Type_of_Plan_Continuation__c') ;
                bcjson.arpcharge=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.ARP_to_be_Charged_In__c') ;
                bcjson.advanceAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Advance_Deposit_Amount__c') ;
                bcjson.advanceDescription=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Advance_Deposit_Description__c') ;
                bcjson.hsiaDuration=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Billing_Frequency__c') ;
                
                if(productCheck.equalsIgnoreCase('EPABX')){
                    bcjson.hsiaLockPeriod='36';
                    bcjson.hsiaLockAmt= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Lock_In_Amount__c');
                }else{
                    bcjson.hsiaLockPeriod= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Details__r.Lock_In_Period__c');
                    bcjson.hsiaLockAmt= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Details__r.Lock_In_Amount__c');     
                }
                
                
                bcjson.proprentalMandatory= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Prop_rental_Mandatory__c');
                
                
                bcjson.propfreeMandatory=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Prop_Free_Mandatory__c');
          //      -----------------------end 3g dongle sheet--------------------------------------
               
                
           //     ----------start SIP New Mapping sheet-------------------
                if(productCheck.equalsIgnoreCase('Wireline'))
                    bcjson.lockPeriod=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Link_Contract_Period__c');
                else
                    bcjson.lockPeriod= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.lock_period__c');
                
                bcjson.selfuseorCommercial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Self_Use_or_Commercial__c');
                
         //       -----------end SIP Mapping sheet------
                bcjson.zoneType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Wifi_Zone__r.Zone_id__c');
                bcjson.zoneName= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Wifi_Zone__r.Name');
                bcjson.zoneNetworkId= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Wifi_Zone__r.Zone_Network_Id__c');
                
                

            //  ------------------------Wireline voice sheet-------------------------------------
                
                
                
                if(!'DLC~ILL~MPLS~NPLC'.contains(productCheck))
                    bcjson.serviceType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Product__r.Empower_Product__c');  
                else
                   bcjson.serviceType=''; 
                
                bcjson.rolloverDiscount= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Rollover_Discount__c');
                bcjson.noOfMonths= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.No_Of_Months__c');
                bcjson.callinlevels= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Calling_Levels__c');
                
             
                bcjson.discountRestrictedField= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Discount_Restricted_Propsr__c');
                bcjson.rentalProrationFileld= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Proration_Propsr__c');
                bcjson.freeSMSPerDel= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Free_SMS_in_Number__c');
                bcjson.freeSMSMandatory=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Free_SMS_Mandatory__c');
                bcjson.freeSMSDescr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.SMS_Description_Local_STD_Roaming__c');
                
            
                bcjson.billAmount1= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Amount_1__c');
                bcjson.billDisc1= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Percentage_1__c');
                bcjson.billAmount2= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Amount_2__c');
                bcjson.billDisc2= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Percentage_2__c');
                bcjson.billAmount3= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Amount_3__c');
                bcjson.billDisc3=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Bill_Discount_Percentage_3__c');
                bcjson.additionalISDInitial= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Additional_ISD_Amount_Initial__c');
        
                
          //      --------------------Tariff Plan fields-----------------------------------------
                if(BCTariffMap.containsKey((Id)fanbc.get('business_case__c'))){     
                Business_case__c bc = BCTariffMap.get((Id)fanbc.get('business_case__c'));
                if('GSM~Wireline~WireLessVoice~3GDongle'.contains(productCheck))
                    bcjson.exactPlanName= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Name');
                else
                    bcjson.exactPlanName='';
                    
                bcjson.rentalWLStandard=  GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Rental__c');
                bcjson.tariffplanName= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Package_ID__c');
                bcjson.planDescription= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Name');
                bcjson.billingPackageID= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Package_ID__c');
                bcjson.eposPackageID= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Epos_ID__c');
                bcjson.tariffplaname= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Package_ID__c');
                bcjson.tifRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_rate_Local__c');
                bcjson.tifPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Local__c');
                bcjson.tifUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_distri_Local__c');
                bcjson.ofRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixedrate_Local__c');
                bcjson.ofPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_pulse_Local__c');
                bcjson.ofUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_distribution_Local__c');
                bcjson.timRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_rate_Local__c');
                bcjson.timPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_pulse_Local__c');
                bcjson.timuDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_distribu_Local__c');
                bcjson.omRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_rate_Local__c');
                bcjson.omPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_pulse_Local__c');
                bcjson.omUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_distribution_Local__c');
                bcjson.cugRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_rate_Local__c');
                bcjson.cugPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_pulse_Local__c');
                bcjson.cugPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_distri_Local__c');
                bcjson.tifintraRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_rate_Intra__c');
                bcjson.tifintraPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Intra__c');
                bcjson.tifintraUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_distri_Intra__c');
                bcjson.ofintraRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixedrate_Intra__c');
                bcjson.ofintraPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_pulse_Intra__c');
                bcjson.ofintraDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_distribution_Intra__c');
                bcjson.cugintraRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Intracircle_CUG_App_rate_Intra__c');
                bcjson.cugintraPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Intracircle_CUG_Appl_pulse_Intra__c');
                bcjson.cugintraDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_IntracircleCUG_if_App_dist_Intra__c');
                bcjson.tifinterRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_rate_Inter__c');
                bcjson.tifinterinterPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Inter__c');
                bcjson.tifinterUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Fixed_distri_Inter__c');
                bcjson.ofinterRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixedrate_Inter__c');
                bcjson.ofinterPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_pulse_Inter__c');
                bcjson.ofinterUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_distribution_Inter__c');
                bcjson.timinterRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_rate_Inter__c');
                bcjson.timinterPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_pulse_Inter__c');
                bcjson.timinterUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Indicom_Mobiles_distri_Inter__c');
                bcjson.ominterRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_rate_Inter__c');
                bcjson.ominterPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_pulse_Inter__c');
                bcjson.ominterUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Mobiles_distribution_Inter__c');
                bcjson.cuginterRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_rate_Inter__c');
                bcjson.cuginterPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_pulse_Inter__c');
                bcjson.cuginterPulsePropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_Local_CUG_if_App_distri_Inter__c');
                bcjson.uscRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.USA_Canada_rate__c');
                bcjson.uscPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.USA_Canada_pulse__c');
                bcjson.uscUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.USA_Canada_distribution__c');
                bcjson.gulfRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Gulf_rate__c');
                bcjson.gulfPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Gulf_pulse__c');
                bcjson.gulfUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Gulf_distribution__c');
                bcjson.seaRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.South_East_Asia_rate__c');
                bcjson.seaPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.South_East_Asia_pulse__c');
                bcjson.seaUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.South_East_Asia_distribution__c');
                bcjson.ukFx1RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_1_rate__c');
                bcjson.ukFx1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_1_pulse__c');
                bcjson.ukFx1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_1_distribution__c');
                bcjson.ukFx2RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_2_rate__c');
                bcjson.ukFx2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_2_pulse__c');
                bcjson.ukFx2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_2_distribution__c');
                bcjson.ukFx3RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_3_rate__c');
                bcjson.ukFx3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_3_pulse__c');
                bcjson.ukFx3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Fixed_3_distribution__c');
                bcjson.ukMb1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_1_pulse__c');
                bcjson.ukMb1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_1_distribution__c');
                bcjson.ukMb2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_2_pulse__c');
                bcjson.ukMb2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_2_distribution__c');
                bcjson.ukMb3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_3_pulse__c');
                bcjson.ukMb3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_3_distribution__c');
                bcjson.ukMb1RatePropsr = GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ukMb1RatePropsr__c');
                bcjson.ukMb2RatePropsr = GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ukMb2RatePropsr__c');
                bcjson.ukMb3RatePropsr = GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ukMb3RatePropsr__c');
                bcjson.ukMb4RatePropsr = GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ukMb4RatePropsr__c');
                bcjson.ukMb4PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_4_pulse__c');
                bcjson.ukMb4UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.UK_Mobile_4_distribution__c');
                bcjson.euFx1RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_1_rate__c');
                bcjson.euFx1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_1_pulse__c');
                bcjson.euFx1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_1_distribution__c');
                bcjson.euFx2RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_2_rate__c');
                bcjson.euFx2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_2_pulse__c');
                bcjson.euFx2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_2_distribution__c');
                bcjson.euFx3RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_3_rate__c');
                bcjson.euFx3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_3_pulse__c');
                bcjson.euFx3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_3_distribution__c');
                bcjson.euFx4RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_4_rate__c');
                bcjson.euFx4PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_4_pulse__c');
                bcjson.euFx4UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Fixed_4_distribution__c');
                bcjson.euMo1RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_mobile_1_rate__c');
                bcjson.euMo1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_mobile_1_pulse__c');
                bcjson.euMo1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_mobile_1_distribution__c');
                bcjson.euMo2RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_2_rate__c');
                bcjson.euMo2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_2_pulse__c');
                bcjson.euMo2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_2_distribution__c');
                bcjson.euMo3RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_3_rate__c');
                bcjson.euMo3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_3_pulse__c');
                bcjson.euMo3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_3_distribution__c');
                bcjson.euMo4RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_4_rate__c');
                bcjson.euMo4PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_4_pulse__c');
                bcjson.euMo4UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Europe_Mobile_4_distribution__c');
                bcjson.sarcRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SAARC_rate__c');
                bcjson.sarcPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SAARC_pulse__c');
                bcjson.sarcUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SAARC_distribution__c');
                bcjson.afr1RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_1_rate__c');
                bcjson.afr1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_1_pulse__c');
                bcjson.afr1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_1_distribution__c');
                bcjson.afr2RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_2_rate__c');
                bcjson.afr2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_2_pulse__c');
                bcjson.afr2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_2_distribution__c');
                bcjson.afr3RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_3_rate__c');
                bcjson.afr3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_3_pulse__c');
                bcjson.afr3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_3_distribution__c');
                bcjson.afr4RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_4_rate__c');
                bcjson.afr4PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_4_pulse__c');
                bcjson.afr4UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Africa_4_distribution__c');
                bcjson.chiRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.China_rate__c');
                bcjson.chiPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.China_pulse__c');
                bcjson.chiUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.China_distribution__c');
                bcjson.aufRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Fixed_rate__c');
                bcjson.aufPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Fixed_pulse__c');
                bcjson.aufUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Fixed_distribution__c');
                bcjson.aumRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Mobile_rate__c');
                bcjson.aumPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Mobile_pulse__c');
                bcjson.aumUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Australia_Mobile_distribution__c');
                bcjson.nzfRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Fixed_rate__c');
                bcjson.nzfPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Fixed_pulse__c');
                bcjson.nzfUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Fixed_distribution__c');
                bcjson.nzmRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Mobile_rate__c');
                bcjson.nzmPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Mobile_pulse__c');
                bcjson.nzmUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.New_Zealand_Mobile_distribution__c');
                bcjson.row1RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_1_rate__c');
                bcjson.row1PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_1_pulse__c');
                bcjson.row1UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_1_distribution__c');
                bcjson.row2RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_2_rate__c');
                bcjson.row2PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_2_pulse__c');
                bcjson.row2UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_2_distribution__c');
                bcjson.row3RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_3_rate__c');
                bcjson.row3PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_3_pulse__c');
                bcjson.row3UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_3_distribution__c');
                bcjson.row4RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_4_rate__c');
                bcjson.row4PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_4_pulse__c');
                bcjson.row4UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_4_distribution__c');
                bcjson.row5RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_5_rate__c');
                bcjson.row5PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_5_pulse__c');
                bcjson.row5UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_5_distribution__c');
                bcjson.row6RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_6_rate__c');
                bcjson.row6PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_6_pulse__c');
                bcjson.row6UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_6_distribution__c');
                bcjson.row7RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_7_rate__c');
                bcjson.row7PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_7_pulse__c');
                bcjson.row7UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_7_distribution__c');
                bcjson.row8RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_8_rate__c');
                bcjson.row8PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_8_pulse__c');
                bcjson.row8UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_8_distribution__c');
                bcjson.row9RatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_9_rate__c');
                bcjson.row9PulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_9_pulse__c');
                bcjson.row9UDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ROW_9_distribution__c');
                bcjson.inmRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.INMARSAT_rate__c');
                bcjson.inmPulsePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.INMARSAT_pulse__c');
                bcjson.inmUDPropsrt= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.INMARSAT_distribution__c');
                    
                bcjson.planfor= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Plan_For__c');
                bcjson.granularity= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Granularity__c');
                bcjson.cntofsubsbrs= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Count_of_subscribers__c');
                bcjson.ogpercentage= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_in_p__c');
                bcjson.localgranularity= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Local_Granularity_p__c');
                bcjson.moulcugonnet= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.CUG_On_Net_MOU_Calculation_l_p__c');
                bcjson.tflcugonnet= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.CUG_On_Net_Tariff_inputs_l_Rs_Min__c');
                bcjson.moult2tgsm= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_GSM_MOU_Calculation_l_p__c');
                bcjson.tflt2tgsm= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_GSM_Tariff_inputs_l_Rs_Min__c');
                bcjson.moult2tcdma= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_CDMA_MOU_Calculation_l_p__c');
                bcjson.tflt2tcdma= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_CDMA_Tariff_inputs_l_Rs_Min__c');
                bcjson.moult2mob= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2_Mobile_MOU_Calculation_p__c');
                bcjson.tflt2mob= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2_Mobile_Tariff_inputs_Rs_Min__c');
                bcjson.moultfixline= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tfixed_Line_MOU_Calculation_p__c');
                bcjson.tfltfixline= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tfixed_Line_Tariff_inputs_Rs_Min__c');
                bcjson.moulothers= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_line_MOU_Calculation_p__c');
                bcjson.tflothers= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_Fixed_line_Tariff_inputs_Rs_Min__c');
                bcjson.stdgranularity= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.STD_Granularity_p__c');
                bcjson.moustdcugonnet= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.CUG_On_Net_MOU_Calculation_std_p__c');
                bcjson.tfstdcugonnet= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.CUG_On_Net_Tariff_inputs_std_Rs_Min__c');
                bcjson.moustdt2tgsm= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_GSM_MOU_Calculation_std_p__c');
                bcjson.tfstdt2tgsm= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_GSM_Tariff_inputs_std_Rs_Min__c');
                bcjson.moustdt2tcdma= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_CDMA_MOU_Calculation_std_p__c');
                bcjson.tfstdt2tcdma= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_CDMA_Tariff_inputs_std_Rs_Min__c');
                bcjson.moustdothers= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Fixed_MOU_Calculation_p__c');
                bcjson.tfstdothers= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Tata_Fixed_Tariff_inputs_Rs_Min__c');
                bcjson.moustdFLP= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.To_OtherFixedPhones_MOU_Calculation_p__c');
                bcjson.tfstdFLP= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OtherFixedPhones_Tariff_inputs_Rs_Min__c');
                bcjson.moustdOMP= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.allotherMobile_MOU_Calculation_p__c');
                bcjson.tfstdOMP= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.allotherMobile_Tariff_inputs_Rs_Min__c');
                bcjson.isdgranularity= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.ISD_Granularity_p__c');
                bcjson.mouslab1= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_1_MOU_Calculation_p__c');
                bcjson.tfslab1= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_1_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab2= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_2_MOU_Calculation_p__c');
                bcjson.tfslab2= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_2_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab3= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_3_MOU_Calculation_p__c');
                bcjson.tfslab3= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_3_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab4= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_4_MOU_Calculation_p__c');
                bcjson.tfslab4= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_4_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab5= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_5_MOU_Calculation_p__c');
                bcjson.tfslab5= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_5_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab6= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_6_MOU_Calculation_p__c');
                bcjson.tfslab6= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_6_Tariff_inputs_Rs_Min__c');
                bcjson.mouslab7= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_7_MOU_Calculation_p__c');
                bcjson.tfslab7= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Slab_7_Tariff_inputs_Rs_Min__c');
                bcjson.outroaminggranularity= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Out_Roaming_Granularity_p__c');
                bcjson.mouincoming= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Incoming_MOU_Calculation_p__c');
                bcjson.tfincoming= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Incoming_Tariff_inputs_Rs_Min__c');
                bcjson.mouoglocal= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_Local_MOU_Calculation_p__c');
                bcjson.tfoglocal= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_Local_Tariff_inputs_Rs_Min__c');
                bcjson.mouogstd= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_STD_MOU_Calculation_p__c');
                bcjson.tfogstd= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_STD_Tariff_inputs_Rs_Min__c');
                bcjson.mouincomtata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Incoming_Tata_MOU_Calculation_p__c');
                bcjson.tfincomtata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Incoming_Tata_Tariff_inputs_Rs_Min__c');
                bcjson.mouoglocaltata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_Local_Tata_MOU_Calculation_p__c');
                bcjson.tfoglocaltata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_Local_Tata_Tariff_inputs_Rs_Min__c');
                bcjson.mouogstdtata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_STD_Tata_MOU_Calculation_p__c');
                bcjson.tfogstdtata= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.OG_STD_Tata_Tariff_inputs_Rs_Min__c');
                bcjson.rentalvalue= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Rental_in_Rs__c');
                bcjson.vasusgrev= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.VAS_p_of_usage_Rev_in_p__c');
                bcjson.otherrevcharges= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Other_revenue_charges_in_Rs__c');
                bcjson.avgmou= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Average_MOU_per_Sub__c');
                bcjson.mouSMSInternational= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_International_tf__c');
                bcjson.tfSMSInternational= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_International_mou__c');
                bcjson.mouSMSLocTataCDMA= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_Local_Tata_CDMA_Tata_Fixed_mou__c');
                bcjson.tfSMSLocTataCDMA= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_Local_Tata_CDMA_Tata_Fixed_tf__c');
                bcjson.mouSMSLocTataGSM= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_Local_Tata_GSM_mou__c');
                bcjson.tfSMSLocTataGSM= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_Local_Tata_GSM_tf__c');
                bcjson.mouSMSSTDTataCDMA= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_STD_Tata_CDMA_Tata_Fixed_mou__c');
                bcjson.tfSMSSTDTataCDMA= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_STD_Tata_CDMA_Tata_Fixed_tf__c');
                bcjson.mouSMSSTDTataGSM= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_STD_Tata_GSM_mou__c');
                bcjson.tfSMSSTDTataGSM= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_To_STD_Tata_GSM_tf__c');
                bcjson.mouSMSLocOther= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_Local_OtherNetwork_mou__c');
                bcjson.tfSMSLocOther= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_Local_OtherNetwork_tf__c');
                bcjson.mouSMSNationalOther= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_National_OtherNetwork_mou__c');
                bcjson.tfSMSNationalOther= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_National_OtherNetwork_tf__c');
                bcjson.freeMinutes= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Free_Minutes__c');
                
                bcjson.extPlanid =  GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Package_ID__c');
                bcjson.extPlandesc = GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.Name');
                
                bcjson.t2tsmsLocalRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_SMS_Local__c');
                bcjson.smsLocalRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_Local__c');
                bcjson.t2tsmsNatRatePropsr= GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.T2T_SMS_National__c');
                bcjson.smsNatRatePropsr=GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_National__c');
                bcjson.smsIsdRatePropsr=GenerateEmpowerREST.GetFieldValue(bc,'Tariff_Plan__r.SMS_ISD__c');

                }

                // wireless voice tariff----------
                

                bcjson.amcrequirement= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.AMC_Requirement__c');
                
                bcjson.ishndset= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Device_Type__c');
                bcjson.rentalProartion= '' ;// TODO
               
                
             //  -------------------start capex & cpe in SIP new sheet-----------------
                if(!'DLC~ILL~MPLS~NPLC'.contains(productCheck)){
                bcjson.ospCapex= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.OSP_MW_Capex__c');
                bcjson.neTrCapex= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Network_Electronics__c');
                bcjson.irmod= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Modems__c');
                bcjson.miscCapex= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Miscellaneous_Capex__c');
                bcjson.ircharges= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.I_R_Agency_Charges_Payable__c');
                bcjson.ircpxIW= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Inbuilding_Wiring__c');
                bcjson.lbCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Lastmile_Bandwidth_Charges_Payable__c');
                    if(productCheck.equalsIgnoreCase('Wireline'))
                        bcjson.netRental= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.NE_Rentals_Payable_to_3rd_Party__c');
                    else
                        bcjson.netRental= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Network_Electronics__c');
                bcjson.prowRental= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Recurring_PROW_Rental__c');  
                bcjson.irPri= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.SIP_Trunk_Card__c'); 
                bcjson.totDelAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Total_Phone_Instruments_Amount__c');
                bcjson.epabxhirRentl= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Rental_3rd_Party_Integration__c'); 
                bcjson.capexComments= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Capex_Comments__c');
                bcjson.otcCrossConnect=GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.otcCrossConnect__c');
                bcjson.otcPayableCrossConnect= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.otcPayableCrossConnect__c');
                bcjson.totOtc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Total_OTC__c');
                bcjson.irSubTot= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Subtotal__c');
                bcjson.cpxTot= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Total_Capex_A_B__c');
                bcjson.epabxdisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Rental_Discount__c');
                bcjson.priDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.SIP_Trunk_Card_Bill_Discount__c');
                bcjson.totDirCost= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Total_Direct_Cost__c');
                bcjson.capexSubTot= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Capex_Subtotal__c');
                bcjson.epabxamc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_AMC_Charges__c');
                    if(productCheck.equalsIgnoreCase('EPABX')){
                        bcjson.ircpxPhInstr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Phone_Instrument_Charges__c');
                        bcjson.irepabx= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Device_Charges__c');
                        bcjson.irMisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_NIU_Rack_Charges__c');
                        bcjson.projMisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Miscellaneous_Project__c');
                        bcjson.otc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_OTC__c');
                        
                    }else{   
                        bcjson.ircpxPhInstr= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Number_of_Phone_Instruments__c');
                        bcjson.irepabx= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX__c');
                        bcjson.irMisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Miscellaneous_EPABX__c');
                        bcjson.projMisc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Miscellaneous_Project__c');
                        bcjson.otc= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.OTC_Payable_to_Third_party_for_Last_Mile__c');
                    }
                }else{
                    bcjson.ospCapex= '';
                bcjson.neTrCapex= '';
                bcjson.irmod= '';
                bcjson.miscCapex= '';
                bcjson.ircharges= '';
                bcjson.ircpxIW= '';
                bcjson.lbCharges='';
                bcjson.netRental= '';
                bcjson.prowRental= '';
                bcjson.projMisc= '';
                bcjson.irPri= '' ;
                bcjson.irepabx= '' ;
                bcjson.irMisc= '' ;
                bcjson.ircpxPhInstr= '' ;
                bcjson.totDelAmount= '' ;
                bcjson.epabxhirRentl= '';
                bcjson.epabxamc= '' ;
                bcjson.capexComments= '' ;
                bcjson.otc= '';
                bcjson.otcCrossConnect= '' ;
                bcjson.otcPayableCrossConnect= '' ;
                bcjson.totOtc= '' ;
                bcjson.irSubTot= '' ;
                bcjson.cpxTot= '' ;
                bcjson.epabxdisc= '';
                bcjson.priDisc='';
                bcjson.totDirCost= '' ;
                bcjson.capexSubTot= '' ;
                    
                }

            //  -------------------end capex & cpe-----------------

                bcjson.instCircle= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Installation_Circle__c');
                bcjson.epabxType= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Type__c');
                bcjson.directlines=  GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Direct_Lines__c');
                bcjson.extensions= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Extensions__c');
                bcjson.epabxdrop= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Drop__c');
                bcjson.fwtniudrop= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.FWT_NIU_Drop__c');
                bcjson.clsidrop= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.CLI_Instrument__c');
                bcjson.rackdrop= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Rack__c');
                bcjson.amcttsl= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.AMC_to_be_born_by_TTL__c');
                bcjson.amcdrop= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_Device_Type__c');
                bcjson.fwtniu= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.EPABX_FWT_NIU_Subsidy_Charges__c');
                
        
        //  --------------------GSM New----------------------
                
                                
                if(productCheck.equalsIgnoreCase('SIP')){
                    bcjson.totAddCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'business_case__r.Total_Additional_Charges__c');    
                }else{
                    bcjson.totAddCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Total_Additional_Charges__c');
                }

                bcjson.brmMailID = GenerateEmpowerREST.GetFieldValue(fanbc,'Business_case__r.Opportunity__r.Owner.Email');
                
                bcjson.identifier = GenerateEmpowerREST.GetFieldValue(fanbc,'Business_case__r.Status_Change_Integration__c');
                bcjson.textFeild1 = '';
                bcjson.textFeild2 = '';
                bcjson.textFeild3 = '';
                bcjson.textFeild4 = '';
                bcjson.textFeild5 = '';



               
                bcMap.put((Id)fanbc.get('business_case__c'),bcjson);
                
            }
             //   BusinessCaseJSON.FanDetails fanjson = new BusinessCaseJSON.FanDetails();
                Fan_bc__c fb = (fan_bc__c)fanbc;
                List<Cpe_details__c> cpeList = fb.cpe_details__r;
                List<BC_Drop__c> dropList = fb.BC_Drops__r;
                
                BusinessCaseJSON bcjson = bcMap.get((Id)fanbc.get('business_case__c'));
                BusinessCaseJSON.FanDetails fanjson = new BusinessCaseJSON.FanDetails();
                
                BusinessCaseJSON.WIrelineVoiceFANDetails wirelineJSON = new BusinessCaseJSON.WIrelineVoiceFANDetails();
                BusinessCaseJSON.WiFiFANDetails wifiJSON = new BusinessCaseJSON.WiFiFANDetails();
                BusinessCaseJSON.SIPFANDetails sipJSON = new BusinessCaseJSON.SIPFANDetails();
                
                fanjson.fanId= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Name');
            
           
                fanjson.arclmcCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_Net_SLA_Charges__c');
                fanjson.arc= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_ARC_LL_Rental_in_Rs__c');
                fanjson.arcDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'ARC_Discount__c');
                fanjson.arcNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_in_Rs__c');
                fanjson.lmc= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_SLA_Charges_in_Rs__c');
                fanjson.lmcDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'SLA_Discount__c');
                fanjson.lmcNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_SLA_Charges__c');
                fanjson.otc= GenerateEmpowerREST.GetFieldValue(fanbc,'One_Time_Charges_from_Customer_in_Rs__c');  // fixed value always
                fanjson.otcDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'OTC_Discount__c');
                fanjson.otcNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_One_Time_Charges_from_Customer__c');
                
                fanjson.installAndTestingCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Installation_And_Testing_Charges__c');
                fanjson.shifting= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Charges_Amount__c');
                fanjson.shiftingDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Discount__c');
                fanjson.shiftingNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_Shifting_Charges__c');
            
            if(productCheck.equalsIgnoreCase('DLC')){
                fanjson.msr= GenerateEmpowerREST.GetFieldValue(fanbc,'MSR_Gross_in_Rs__c');
                fanjson.msrDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'MSR_Discount__c');
                fanjson.msrNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_MSR__c');
            }
            else if(productCheck.equalsIgnoreCase('ILL')){
                fanjson.msr= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Gross_Amount__c');
                fanjson.msrDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Discount__c');
                fanjson.msrNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Net_Amount__c');
            }
            else{
                fanjson.msr= '';
                fanjson.msrDisc= '';
                fanjson.msrNetAmount= '';
            }
         
            
                fanjson.manageService= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service__c');
                fanjson.managedServiceCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Charges__c');
                fanjson.managedServiceDiscount= GenerateEmpowerREST.GetFieldValue(fanbc,'Discount_on_Manage_Service_Charges__c');
                fanjson.managedServiceNetamount=GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Charges_NetAmount__c');
                fanjson.msrLocation= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Location__c');
                fanjson.msrType= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Type__c');
                fanjson.demoPeriod= GenerateEmpowerREST.GetFieldValue(fanbc,'Demo_Period__c');
            
          //  --------  For ILL ----------
                
                
            
                    fanjson.secondaryLastmileGross= GenerateEmpowerREST.GetFieldValue(fanbc,'Secondary_LM_Gross_Amount__c'); 
                    fanjson.secondaryLastmileDiscount=GenerateEmpowerREST.GetFieldValue(fanbc,'Secondary_Last_Mile_Charges_Discount__c');
                    fanjson.secondaryLastmileNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Secondary_Last_Mile_Charges_Net_Amount__c');
            
            

                fanjson.bwCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Bandwidth_Rental_Charges_Gross_Amount__c');
                fanjson.bwChargesDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'Bandwidth_Rental_Charges_Discount__c');
                fanjson.bwChargesNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Bandwidth_Rental_Charges_Net_Amount__c');
                
            
                fanjson.ipAmount=GenerateEmpowerREST.GetFieldValue(fanbc,'IP_Additional_Charges__c');
                fanjson.ipDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'IP_Additional_Charges_Discount__c');
                fanjson.ipNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_IP_Additional_Charges__c');
                fanjson.noOfIps= GenerateEmpowerREST.GetFieldValue(fanbc,'No_Of_IP_s__c');
            
                if(productCheck.equalsIgnoreCase('ILL'))
                    fanjson.ipCaptureFlag= GenerateEmpowerREST.GetFieldValue(fanbc,'IP_CAPTURE_FLAG__c');
                else
                    fanjson.ipCaptureFlag='';
            
            
                fanjson.arcLmcACharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_Net_SLA_Charges_A__c');
                fanjson.arcLmcBCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_Net_SLA_Charges_B__c');
                fanjson.arcAAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_ARC_LL_Rental_Point_A__c');
                fanjson.arcADisc= GenerateEmpowerREST.GetFieldValue(fanbc,'ARC_Discount_Point_A__c');
                fanjson.arcANetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_Point_A__c');
                fanjson.arcBAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_ARC_LL_Rental_Point_B__c');
                fanjson.arcBDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'ARC_Discount_B__c');
                fanjson.arcBNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_ARC_LL_Rental_B__c');
                fanjson.lmcAAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_SLA_Charges_Point_A__c');
                fanjson.lmcADisc= GenerateEmpowerREST.GetFieldValue(fanbc,'SLA_Discount_Point_A__c');
                fanjson.lmcANetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_SLA_Charges_Point_A__c');
                fanjson.lmcBAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Gross_SLA_Charges_Point_B__c');
                fanjson.lmcBDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'SLA_Discount_B__c');
                fanjson.lmcBNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_SLA_Charges_B__c');
                fanjson.otcAAmount=  GenerateEmpowerREST.GetFieldValue(fanbc,'One_Time_Charges_from_Customer_Point_A__c');  // fixed value - check
                fanjson.otcADisc= GenerateEmpowerREST.GetFieldValue(fanbc,'OTC_Discount_Point_A__c');
                fanjson.otcANetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_OTC_Customer_Point_A__c');
                fanjson.otcBAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'One_Time_Charges_from_Customer_Point_B__c');// fixed value -- check
                fanjson.otcBDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'OTC_Discount_B_in__c');
                fanjson.otcBNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_One_Time_Charges_B__c');
                fanjson.msrAAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Gross_Amount_Point_A__c');
                fanjson.msrADisc= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Discount_Point_A__c');
                fanjson.msrANetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Net_Amount_Point_A__c');
                fanjson.msrBAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Gross_Amount_Point_B__c');
                fanjson.msrBDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Discount_Point_B__c');
                fanjson.msrBNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NE_Rental_Net_Amount_Point_B__c');
                fanjson.shiftingAAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Charges_Amount_Point_A__c');
                fanjson.shiftingADisc= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Discount_Point_A__c');
                fanjson.shiftingANetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_Shifting_Charges_Point_A__c');
                fanjson.shiftingBAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Charges_Amount_B__c');
                fanjson.shiftingBDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'Shifting_Discount_B_in__c');
                fanjson.shiftingBNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_Shifting_Charges_B__c');
                fanjson.nldLmcCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_NLD_LL_Rental_Net_SLA_Charges__c');
                fanjson.nplcAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NLD_LL_Rental_Gross_Amount__c');
                fanjson.nplcDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'NLD_LL_Discount__c');
                fanjson.nplcNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_NLD_LL_Rental__c');
                fanjson.lmcNLDAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'NLD_SLA_Charges_Gross_Amount__c');
                fanjson.lmcNLDDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'NLD_SLA_Discount__c');
                fanjson.lmcNLDNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_NLD_SLA_Charges__c');
                fanjson.itACharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Installation_Testing_Charges_Point_A__c');
                fanjson.itBCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Installation_And_Testing_Charges_B__c');
                fanjson.cosType= GenerateEmpowerREST.GetFieldValue(fanbc,'Cos_Type__c');
                fanjson.lmulticastGross= GenerateEmpowerREST.GetFieldValue(fanbc,'L2MC_from_customer_in_Rs__c');
                fanjson.lmulticastDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'L2MC_Discount__c');
                fanjson.lmulticastNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'Net_L2MC__c');
            

                fanjson.portBwCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'MPLS_Port_BW_Charges_Gross_Amount__c');
                fanjson.portBwChargesDisc= GenerateEmpowerREST.GetFieldValue(fanbc,'MPLS_Port_BW_Charges_Discount__c');
                fanjson.portBwChargesNetAmount= GenerateEmpowerREST.GetFieldValue(fanbc,'MPLS_Port_BW_Charges_Net_Amount__c');
               
                fanjson.routerCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Router_Charges__c');
                fanjson.hardwareSupportCharges= GenerateEmpowerREST.GetFieldValue(fanbc,'Hardware_Support_Charges__c');
            
 

                // dropJSOn fields to go as list
             System.debug('Drops---------'+dropList);
            for(BC_Drop__c bcDrop : dropList){
                System.debug('bcDrop--------'+bcDrop);
                BusinessCaseJSON.DropsDetails dropJSON = new BusinessCaseJSON.DropsDetails();
                dropJSON.dropId = GenerateEmpowerREST.GetFieldValue(bcDrop,'Drop_Id__c');
                dropJSON.dropsAmount = GenerateEmpowerREST.GetFieldValue(bcDrop,'Drop_Amount_Formula__c');
                dropJSON.dropsOTC = GenerateEmpowerREST.GetFieldValue(bcDrop,'Drop_OTC__c');
                fanjson.dropsDetails.add(dropJSON);   // add dropjson to fanjson dropsDetails list
            }
                
        //iterate cpe list of fan_bc
                for(Cpe_details__c cpe : cpeList){
                    BusinessCaseJSON.CpeDetails cpeJSON = new BusinessCaseJSON.CpeDetails();
                    cpeJSON.cpeRequired= GenerateEmpowerREST.GetFieldValue(cpe,'Is_CPE_Required__c');
                    cpeJSON.cpeType= GenerateEmpowerREST.GetFieldValue(cpe,'CPE_Ownership__c');
                    cpeJSON.routersMakeModel= GenerateEmpowerREST.GetFieldValue(cpe,'Router__r.Equipment_Type__c');
                    cpeJSON.cdmaMatCode= GenerateEmpowerREST.GetFieldValue(cpe,'Router__r.CDMA_MAT_CODE__c');
                    cpeJSON.typeOfEquipment= GenerateEmpowerREST.GetFieldValue(cpe,'Type_of_Equipment_Used_by_Customer__c');
                    cpeJSON.cpeCharges= GenerateEmpowerREST.GetFieldValue(cpe,'CPE_charges__c');
                    cpeJSON.cpeChargesDisc= GenerateEmpowerREST.GetFieldValue(cpe,'CPE_Charges_Discount__c');
                    cpeJSON.cpeChargesNetAmt= GenerateEmpowerREST.GetFieldValue(cpe,'CPE_Charges_Net_Amount__c');
                    cpeJSON.utmFlag= GenerateEmpowerREST.GetFieldValue(cpe,'UTM_Flag__c');
                    cpeJSON.routerMake= GenerateEmpowerREST.GetFieldValue(cpe,'Router__r.Router_Make__c');
                    cpeJSON.routerModel= GenerateEmpowerREST.GetFieldValue(cpe,'Router__r.Part_Code__c');
                  //  fanjson.manageService= GenerateEmpowerREST.GetFieldValue(cpe,'Manage_Service__c');
                //  fanjson.managedServiceCharges= GenerateEmpowerREST.GetFieldValue(cpe,'Manage_Service_Charges__c'); // TODO;
                //  fanjson.managedServiceDiscount= GenerateEmpowerREST.GetFieldValue(cpe,'Discount_on_Manage_Service_Charges__c'); // TODO;
                //  fanjson.managedServiceNetamount=GenerateEmpowerREST.GetFieldValue(cpe,'Net_MSR_in_Rs__c'); // TODO;
               //   fanjson.msrLocation= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Location__c');
                //  fanjson.msrType= GenerateEmpowerREST.GetFieldValue(fanbc,'Manage_Service_Type__c');

                    fanjson.cpeDetails.add(cpeJSON);   // add cpeJSON to fanjson cpeDetails list
                    
                }                 
                
                // wireline json fields........ 
            if(productCheck.equalsIgnoreCase('Wireline')){
                wirelineJSON.fanId= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Name');
                wirelineJSON.circle= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.billing_circle__c');
                wirelineJSON.city= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.city__r.Name');
                wirelineJSON.media= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Preferred_Media_A_End__c');
                wirelineJSON.fanType= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Activity_Type__c');
                wirelineJSON.networkType= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Network_Type__c');
                String num = GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.No_of_DIDs_Extensions__c');
                if(String.isBlank(num))
                    wirelineJSON.noofdidLines = '0';
                else
                    wirelineJSON.noofdidLines = GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.No_of_DIDs_Extensions__c');
                wirelineJSON.orderSize =  GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Order_Size_No_of_DELs__c');
                wirelineJSON.fanCategory= 'NA'; 
                wirelineJSON.fanTag= 'NA';  
                wirelineJSON.ftspIdentifier= 'NO';  
            }else{
                wirelineJSON.fanId='';
                wirelineJSON.circle='';
                wirelineJSON.city=''; 
                wirelineJSON.media='';
                wirelineJSON.fanType='';
                wirelineJSON.networkType= '';
                wirelineJSON.noofdidLines ='';
                wirelineJSON.orderSize = '';
                wirelineJSON.fanCategory='';
                wirelineJSON.fanTag= '';
                wirelineJSON.ftspIdentifier= '';
                
            }
                
                
               
               if(productCheck.equalsIgnoreCase('WiFi')){
                wifiJSON.fanId= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Name');
                wifiJSON.capex= GenerateEmpowerREST.GetFieldValue(fanbc,'Capex__c');
                wifiJSON.opexPerMonth= GenerateEmpowerREST.GetFieldValue(fanbc,'Opex_per_month__c');
                wifiJSON.backhaulCapex= GenerateEmpowerREST.GetFieldValue(fanbc,'Backhaul_Capex__c');
                wifiJSON.backhaulOpexPerMonth= GenerateEmpowerREST.GetFieldValue(fanbc,'Backhaul_Opex_per_month__c');
                wifiJSON.wifiModtype= '';  //not required
               }else{
                  wifiJSON.fanId=''; 
                  wifiJSON.capex= '';
                  wifiJSON.opexPerMonth= '';
                  wifiJSON.backhaulCapex= '';
                  wifiJSON.backhaulOpexPerMonth= '';
                  wifiJSON.wifiModtype= '';  //not required
               }
                

                // sipJSON fields  
            if(productCheck.equalsIgnoreCase('SIP')){
                sipJSON.fanNo= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.FAN_Number__c');
                sipJSON.fanCircleName= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.billing_circle__c');
                sipJSON.fanCity= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.city__r.Name');
                sipJSON.noDDLines= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.No_of_DIDs_Extensions__c');
                sipJSON.noChannels= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.No_of_Channels__c');
                sipJSON.fanCircleId= '8'; //NA
                sipJSON.fanType= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Activity_Type__c');
                sipJSON.networkType= GenerateEmpowerREST.GetFieldValue(fanbc,'Feasibility__r.Network_Type__c');
                sipJSON.rateofAddChargesperDD= GenerateEmpowerREST.GetFieldValue(fanbc,'Rate_of_Additional_Charges_DID__c');
                sipJSON.addChargesperFan= GenerateEmpowerREST.GetFieldValue(fanbc,'Additional_Charges_FAN__c');
            }
               else{
                  sipJSON.fanNo='';
                  sipJSON.fanCircleName='';
                  sipJSON.fanCity=''; 
                  sipJSON.noDDLines= '';
                  sipJSON.noChannels= '';
                  sipJSON.fanCircleId= ''; //NA
                  sipJSON.fanType= ''; //nf
                  sipJSON.networkType= '';
                  sipJSON.rateofAddChargesperDD= '';
                  sipJSON.addChargesperFan= '';
               }
                

                
                
                bcjson.fanDetails.add(fanjson); // adding fanjson to fanDetails list
                bcjson.wirelineVoiceFANDetails.add(wirelineJSON);
                bcjson.wiFiFANDetails.add(wifiJSON);
                bcjson.sipFANDetails.add(sipJSON);
                
            
            
              BusinessCaseJSON bc = bcMap.get((Id)fanbc.get('business_case__c'));
              String JSON_String = JSON.serialize(bc); 
              System.debug('BC JSON-----'+ JSON_String);

                      
        }
        
        Set<ID> bcSet = bcMap.keySet();
            for(ID id: bcSet){
                Empower_REST__c empNew = new Empower_REST__c();
                empNew.Business_Case__c  = id;
                empNew.Endpoint__c = BusinessCaseInterface.EndPoint.Endpoint__c ;
                BusinessCaseJSON bc = bcMap.get(id);
                System.debug('For business case-----'+id);
                String JSON_String = JSON.serialize(bc);
                System.debug('JSON_String========='+JSON_String);
                empNew.JSON__c = JSON_String ;
                empNew.Status__c = 'New' ;
                empNew.Priority__c = BusinessCaseInterface.EndPoint.Priority__c ;
                empNew.Retrial_Count__c = 0 ;
                empNew.Key__c = id +'~BusinessCase~new';
                    if(String.IsNotBlank(empNew.JSON__c))
                        //Add the Empower_REST__c record to the return list.
                        empRESTList.add(empNew);
                        
            }
        
        System.debug('EmpowerList size------'+ empRESTList.size());

        return empRESTList;
        
    }
    
    public static String generateTariffQuery(Set<ID> BCIDSet){
        
      
        
        String query= 'select Tariff_Plan__r.Package_ID__c,Tariff_Plan__r.Epos_ID__c,Tariff_Plan__r.Name, Tariff_Plan__r.Count_of_subscribers__c,Tariff_Plan__r.Tata_Indicom_Fixed_rate_Local__c,   Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Local__c,   Tariff_Plan__r.Tata_Indicom_Fixed_distri_Local__c,'+
            'Tariff_Plan__r.T2T_SMS_Local__c,Tariff_Plan__r.SMS_Local__c,Tariff_Plan__r.T2T_SMS_National__c,Tariff_Plan__r.SMS_National__c,Tariff_Plan__r.SMS_ISD__c,'+  
            '  Tariff_Plan__r.Other_Fixedrate_Local__c, Tariff_Plan__r.Other_Fixed_pulse_Local__c,  Tariff_Plan__r.Other_Fixed_distribution_Local__c,'+
            'Tariff_Plan__r.ukMb1RatePropsr__c,Tariff_Plan__r.ukMb2RatePropsr__c,Tariff_Plan__r.ukMb3RatePropsr__c,Tariff_Plan__r.ukMb4RatePropsr__c,'+  
            '  Tariff_Plan__r.Tata_Indicom_Mobiles_rate_Local__c,   Tariff_Plan__r.Tata_Indicom_Mobiles_pulse_Local__c, Tariff_Plan__r.Tata_Indicom_Mobiles_distribu_Local__c,'+
              ' Tariff_Plan__r.Other_Mobiles_rate_Local__c, Tariff_Plan__r.Other_Mobiles_pulse_Local__c,    Tariff_Plan__r.Other_Mobiles_distribution_Local__c,'+
              ' Tariff_Plan__r.T2T_Local_CUG_if_App_rate_Local__c,  Tariff_Plan__r.T2T_Local_CUG_if_App_pulse_Local__c, Tariff_Plan__r.T2T_Local_CUG_if_App_distri_Local__c,'+
              ' Tariff_Plan__r.Tata_Indicom_Fixed_rate_Intra__c,    Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Intra__c,   Tariff_Plan__r.Tata_Indicom_Fixed_distri_Intra__c,'+
              ' Tariff_Plan__r.Other_Fixedrate_Intra__c,    Tariff_Plan__r.Other_Fixed_pulse_Intra__c,  Tariff_Plan__r.Other_Fixed_distribution_Intra__c,'+
              ' Tariff_Plan__r.T2T_Intracircle_CUG_App_rate_Intra__c,   Tariff_Plan__r.T2T_Intracircle_CUG_Appl_pulse_Intra__c, Tariff_Plan__r.T2T_IntracircleCUG_if_App_dist_Intra__c,'+
              ' Tariff_Plan__r.Tata_Indicom_Fixed_rate_Inter__c,    Tariff_Plan__r.Tata_Indicom_Fixed_pulse_Inter__c,   Tariff_Plan__r.Tata_Indicom_Fixed_distri_Inter__c,'+
              ' Tariff_Plan__r.Other_Fixedrate_Inter__c,    Tariff_Plan__r.Other_Fixed_pulse_Inter__c,  Tariff_Plan__r.Other_Fixed_distribution_Inter__c,'+
              ' Tariff_Plan__r.Tata_Indicom_Mobiles_rate_Inter__c,  Tariff_Plan__r.Tata_Indicom_Mobiles_pulse_Inter__c, Tariff_Plan__r.Tata_Indicom_Mobiles_distri_Inter__c,'+
              ' Tariff_Plan__r.Other_Mobiles_rate_Inter__c, Tariff_Plan__r.Other_Mobiles_pulse_Inter__c,    Tariff_Plan__r.Other_Mobiles_distribution_Inter__c,'+
              ' Tariff_Plan__r.T2T_Local_CUG_if_App_rate_Inter__c,  Tariff_Plan__r.T2T_Local_CUG_if_App_pulse_Inter__c, Tariff_Plan__r.T2T_Local_CUG_if_App_distri_Inter__c,'+
              ' Tariff_Plan__r.USA_Canada_rate__c,  Tariff_Plan__r.USA_Canada_pulse__c, Tariff_Plan__r.USA_Canada_distribution__c,  Tariff_Plan__r.Gulf_rate__c,'+
              ' Tariff_Plan__r.Gulf_pulse__c,   Tariff_Plan__r.Gulf_distribution__c,    Tariff_Plan__r.South_East_Asia_rate__c, Tariff_Plan__r.South_East_Asia_pulse__c,'+
              ' Tariff_Plan__r.South_East_Asia_distribution__c, Tariff_Plan__r.UK_Fixed_1_rate__c,  Tariff_Plan__r.UK_Fixed_1_pulse__c, Tariff_Plan__r.UK_Fixed_1_distribution__c,'+
              ' Tariff_Plan__r.UK_Fixed_2_rate__c,  Tariff_Plan__r.UK_Fixed_2_pulse__c, Tariff_Plan__r.UK_Fixed_2_distribution__c,  Tariff_Plan__r.UK_Fixed_3_rate__c,'+
              ' Tariff_Plan__r.UK_Fixed_3_pulse__c, Tariff_Plan__r.UK_Fixed_3_distribution__c,  Tariff_Plan__r.UK_Mobile_1_rate__c,'+
              ' Tariff_Plan__r.UK_Mobile_1_pulse__c,    Tariff_Plan__r.UK_Mobile_1_distribution__c, Tariff_Plan__r.UK_Mobile_2_rate__c,'+
              ' Tariff_Plan__r.UK_Mobile_2_pulse__c, Tariff_Plan__r.UK_Mobile_2_distribution__c,    Tariff_Plan__r.UK_Mobile_3_rate__c,'+
              ' Tariff_Plan__r.UK_Mobile_3_pulse__c,    Tariff_Plan__r.UK_Mobile_3_distribution__c, Tariff_Plan__r.UK_Mobile_4_rate__c,'+
              ' Tariff_Plan__r.UK_Mobile_4_pulse__c,    Tariff_Plan__r.UK_Mobile_4_distribution__c, Tariff_Plan__r.Europe_Fixed_1_rate__c,'+
              ' Tariff_Plan__r.Europe_Fixed_1_pulse__c, Tariff_Plan__r.Europe_Fixed_1_distribution__c,  Tariff_Plan__r.Europe_Fixed_2_rate__c,'+
              ' Tariff_Plan__r.Europe_Fixed_2_pulse__c, Tariff_Plan__r.Europe_Fixed_2_distribution__c,  Tariff_Plan__r.Europe_Fixed_3_rate__c,'+
              ' Tariff_Plan__r.Europe_Fixed_3_pulse__c, Tariff_Plan__r.Europe_Fixed_3_distribution__c,  Tariff_Plan__r.Europe_Fixed_4_rate__c,  Tariff_Plan__r.Europe_Fixed_4_pulse__c,'+
              ' Tariff_Plan__r.Europe_Fixed_4_distribution__c,  Tariff_Plan__r.Europe_mobile_1_rate__c, Tariff_Plan__r.Europe_mobile_1_pulse__c,    Tariff_Plan__r.Europe_mobile_1_distribution__c,'+
              ' Tariff_Plan__r.Europe_Mobile_2_rate__c, Tariff_Plan__r.Europe_Mobile_2_pulse__c,    Tariff_Plan__r.Europe_Mobile_2_distribution__c, Tariff_Plan__r.Europe_Mobile_3_rate__c,'+
              ' Tariff_Plan__r.Europe_Mobile_3_pulse__c,    Tariff_Plan__r.Europe_Mobile_3_distribution__c, Tariff_Plan__r.Europe_Mobile_4_rate__c, Tariff_Plan__r.Europe_Mobile_4_pulse__c,'+
              ' Tariff_Plan__r.Europe_Mobile_4_distribution__c, Tariff_Plan__r.SAARC_rate__c,   Tariff_Plan__r.SAARC_pulse__c,  Tariff_Plan__r.SAARC_distribution__c,'+
              ' Tariff_Plan__r.Africa_1_rate__c,    Tariff_Plan__r.Africa_1_pulse__c,   Tariff_Plan__r.Africa_1_distribution__c,    Tariff_Plan__r.Africa_2_rate__c,'+
              ' Tariff_Plan__r.Africa_2_pulse__c,   Tariff_Plan__r.Africa_2_distribution__c,    Tariff_Plan__r.Africa_3_rate__c,    Tariff_Plan__r.Africa_3_pulse__c,'+
              ' Tariff_Plan__r.Africa_3_distribution__c,    Tariff_Plan__r.Africa_4_rate__c,    Tariff_Plan__r.Africa_4_pulse__c,   Tariff_Plan__r.Africa_4_distribution__c,'+
              ' Tariff_Plan__r.China_rate__c,   Tariff_Plan__r.China_pulse__c,  Tariff_Plan__r.China_distribution__c,   Tariff_Plan__r.Australia_Fixed_rate__c,'+
              ' Tariff_Plan__r.Australia_Fixed_pulse__c,    Tariff_Plan__r.Australia_Fixed_distribution__c, Tariff_Plan__r.Australia_Mobile_rate__c,    Tariff_Plan__r.Australia_Mobile_pulse__c,'+
              ' Tariff_Plan__r.Australia_Mobile_distribution__c,    Tariff_Plan__r.New_Zealand_Fixed_rate__c,   Tariff_Plan__r.New_Zealand_Fixed_pulse__c,  Tariff_Plan__r.New_Zealand_Fixed_distribution__c,'+
              ' Tariff_Plan__r.New_Zealand_Mobile_rate__c,  Tariff_Plan__r.New_Zealand_Mobile_pulse__c, Tariff_Plan__r.New_Zealand_Mobile_distribution__c,  Tariff_Plan__r.ROW_1_rate__c,'+
              ' Tariff_Plan__r.ROW_1_pulse__c,  Tariff_Plan__r.ROW_1_distribution__c,   Tariff_Plan__r.ROW_2_rate__c,   Tariff_Plan__r.ROW_2_pulse__c,  Tariff_Plan__r.ROW_2_distribution__c,'+
              ' Tariff_Plan__r.ROW_3_rate__c,   Tariff_Plan__r.ROW_3_pulse__c,  Tariff_Plan__r.ROW_3_distribution__c,   Tariff_Plan__r.ROW_4_rate__c,   Tariff_Plan__r.ROW_4_pulse__c,'+
              ' Tariff_Plan__r.ROW_4_distribution__c,   Tariff_Plan__r.ROW_5_rate__c,   Tariff_Plan__r.ROW_5_pulse__c,  Tariff_Plan__r.ROW_5_distribution__c,   Tariff_Plan__r.ROW_6_rate__c,'+
              ' Tariff_Plan__r.ROW_6_pulse__c,  Tariff_Plan__r.ROW_6_distribution__c,   Tariff_Plan__r.ROW_7_rate__c,   Tariff_Plan__r.ROW_7_pulse__c,  Tariff_Plan__r.ROW_7_distribution__c,'+
              ' Tariff_Plan__r.ROW_8_rate__c,   Tariff_Plan__r.ROW_8_pulse__c,  Tariff_Plan__r.ROW_8_distribution__c,   Tariff_Plan__r.ROW_9_rate__c,   Tariff_Plan__r.ROW_9_pulse__c,'+
              ' Tariff_Plan__r.ROW_9_distribution__c,   Tariff_Plan__r.INMARSAT_rate__c,    Tariff_Plan__r.INMARSAT_pulse__c,   Tariff_Plan__r.INMARSAT_distribution__c,'+
              'Tariff_Plan__r.OG_in_p__c,Tariff_Plan__r.Local_Granularity_p__c,'+   'Tariff_Plan__r.CUG_On_Net_MOU_Calculation_l_p__c,Tariff_Plan__r.CUG_On_Net_Tariff_inputs_l_Rs_Min__c,'+
              'Tariff_Plan__r.T2T_GSM_MOU_Calculation_l_p__c,Tariff_Plan__r.T2T_GSM_Tariff_inputs_l_Rs_Min__c,'+
              'Tariff_Plan__r.T2T_CDMA_MOU_Calculation_l_p__c,Tariff_Plan__r.T2T_CDMA_Tariff_inputs_l_Rs_Min__c,'+  'Tariff_Plan__r.T2_Mobile_MOU_Calculation_p__c,Tariff_Plan__r.T2_Mobile_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Tfixed_Line_MOU_Calculation_p__c,Tariff_Plan__r.Tfixed_Line_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Other_Fixed_line_MOU_Calculation_p__c,Tariff_Plan__r.Other_Fixed_line_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.STD_Granularity_p__c,Tariff_Plan__r.CUG_On_Net_MOU_Calculation_std_p__c,'+
              'Tariff_Plan__r.CUG_On_Net_Tariff_inputs_std_Rs_Min__c,Tariff_Plan__r.T2T_GSM_MOU_Calculation_std_p__c,'+
              'Tariff_Plan__r.T2T_GSM_Tariff_inputs_std_Rs_Min__c,Tariff_Plan__r.T2T_CDMA_MOU_Calculation_std_p__c,'+
              'Tariff_Plan__r.T2T_CDMA_Tariff_inputs_std_Rs_Min__c,Tariff_Plan__r.Tata_Fixed_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.Tata_Fixed_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.To_OtherFixedPhones_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.OtherFixedPhones_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.allotherMobile_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.allotherMobile_Tariff_inputs_Rs_Min__c,   Tariff_Plan__r.ISD_Granularity_p__c,'+
              'Tariff_Plan__r.Slab_1_MOU_Calculation_p__c,Tariff_Plan__r.Slab_1_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Slab_2_MOU_Calculation_p__c,Tariff_Plan__r.Slab_2_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Slab_3_MOU_Calculation_p__c,  Tariff_Plan__r.Slab_3_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Slab_4_MOU_Calculation_p__c,Tariff_Plan__r.Slab_4_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Slab_5_MOU_Calculation_p__c,Tariff_Plan__r.Slab_5_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Slab_6_MOU_Calculation_p__c,  Tariff_Plan__r.Slab_6_Tariff_inputs_Rs_Min__c,  '+
              'Tariff_Plan__r.Slab_7_MOU_Calculation_p__c,Tariff_Plan__r.Slab_7_Tariff_inputs_Rs_Min__c,'+
              'Tariff_Plan__r.Out_Roaming_Granularity_p__c,Tariff_Plan__r.Incoming_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.Incoming_Tariff_inputs_Rs_Min__c, Tariff_Plan__r.OG_Local_MOU_Calculation_p__c,'+ 
              'Tariff_Plan__r.OG_Local_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.OG_STD_MOU_Calculation_p__c,'+    
              'Tariff_Plan__r.OG_STD_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.Incoming_Tata_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.Incoming_Tata_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.OG_Local_Tata_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.OG_Local_Tata_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.OG_STD_Tata_MOU_Calculation_p__c,'+
              'Tariff_Plan__r.OG_STD_Tata_Tariff_inputs_Rs_Min__c,Tariff_Plan__r.Rental_in_Rs__c,Tariff_Plan__r.Rental__c,'+
              'Tariff_Plan__r.VAS_p_of_usage_Rev_in_p__c,Tariff_Plan__r.Other_revenue_charges_in_Rs__c,'+
              'Tariff_Plan__r.Average_MOU_per_Sub__c,   Tariff_Plan__r.SMS_To_International_tf__c,'+
              'Tariff_Plan__r.SMS_To_International_mou__c,Tariff_Plan__r.SMS_To_Local_Tata_CDMA_Tata_Fixed_mou__c,'+
              'Tariff_Plan__r.SMS_To_Local_Tata_CDMA_Tata_Fixed_tf__c,Tariff_Plan__r.SMS_To_Local_Tata_GSM_mou__c,'+
              'Tariff_Plan__r.SMS_To_Local_Tata_GSM_tf__c,  Tariff_Plan__r.SMS_To_STD_Tata_CDMA_Tata_Fixed_mou__c,'+
              'Tariff_Plan__r.SMS_To_STD_Tata_CDMA_Tata_Fixed_tf__c,Tariff_Plan__r.SMS_To_STD_Tata_GSM_mou__c,'+
              'Tariff_Plan__r.SMS_To_STD_Tata_GSM_tf__c,Tariff_Plan__r.SMS_Local_OtherNetwork_mou__c,'+
              'Tariff_Plan__r.SMS_Local_OtherNetwork_tf__c,Tariff_Plan__r.SMS_National_OtherNetwork_mou__c,'+
              'Tariff_Plan__r.SMS_National_OtherNetwork_tf__c,Tariff_Plan__r.Plan_For__c,Tariff_Plan__r.Granularity__c,Tariff_Plan__r.Free_Minutes__c'+
              ' from Business_case__c where id IN :BCIDs';
        
        return query;
    }
    
    

}