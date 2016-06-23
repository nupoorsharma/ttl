/*
 * Name        : FeasibilityInterface
 * Description : FeasibilityInterface class is used to generate the Empower REST records for Feasibility
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 6 April 2016
 * Change Log History
 *  |-------------------------------------------------------------------------|
 *  | Version | Modified By     | Date       | Comment                        |
 *  |-------------------------------------------------------------------------|
 *  | 0.1     | Nupoor          | 06/04/2016 | Initial Version of Class       |
 *  |-------------------------------------------------------------------------|
 */
public without sharing class FeasibilityInterface {
    
    //The Giant Map: Key=Json field, Value= FieldInfo Object (Api Name + Fixed Value + Execute Logic)
    static Map<String,FieldInfo> JSOn_Field_Map{get;set;}
    //Details about the Feasibility Interface eg. Endpoint/Priority are stored in this custom setting.
    public static RESTEndpointURL__c Endpoint{get;set;}
    
    //The Class for JSON Object
    public class FeasibilityJSON{
        public String popCity{get;set;}
        public String popLocation{get;set;}
        public String popPincode{get;set;}
        public String installationCircle{get;set;}
        public String popAddress{get;set;}
        public String networkConnectivityType{get;set;}
        public String aggregateRequired{get;set;}
        public String networkTopology{get;set;}
        public String comboSolution{get;set;}
        public String nimbleType{get;set;}
        public String customerType{get;set;}
        public String classServiceType{get;set;}
        public String percentileLogic{get;set;}
        public String classServiceVariant{get;set;}
        public String planType{get;set;}
        public String vpnSubType{get;set;}
        public String lastMile{get;set;}
        public String vpnType{get;set;}
        public String packages{get;set;}
        public String expectedServiceSLA{get;set;}
        public String lmValue{get;set;}
        public String numberLocations{get;set;}
        public String serviceProvider{get;set;}
        public String mplsBandwidth{get;set;}
        public String illBandwidth{get;set;}
        public String lmBandwidth{get;set;}
        public String internetBandwidthRatio{get;set;}
        public String parentBillingCircle{get;set;}
        public String priAccountNumber{get;set;}
        public String product{get;set;}
        public String pilotDel1{get;set;}
        public String isdnBandwidth{get;set;}
        public String pilotDel2{get;set;}
        public String isdnBackupPort{get;set;}
        public String internetGateway{get;set;}
        public String sspAccount{get;set;}
        public String subActivity{get;set;}
        public String panDetails{get;set;}
        public String wanConfiguration{get;set;}
        public String companyId{get;set;}
        public String dlcSoid{get;set;}
        public String fanCreationDate{get;set;}
        public String nplcSoid{get;set;}
        public String comments{get;set;}
        public String addIpRequest{get;set;}
        //public String Remarks{get;set;}
        public String ipUsedaddressRange{get;set;}
        public String nValueB{get;set;}
        public String custAutonomousNumber{get;set;}
        public String netBandwidthB{get;set;}
        public String custIpAddBlock{get;set;}
        public String bandwidthB{get;set;}
        public String noOfRoutes{get;set;}
        public String bandwidthReqatB{get;set;}
        public String routes{get;set;}
        public String nValueA{get;set;}
        public String lanNetworkAddress{get;set;}
        public String netBandwidthA{get;set;}
        public String lanHostFrom{get;set;}
        public String bandwidthA{get;set;}
        public String lanHostTo{get;set;}
        public String bandwidthReqatA{get;set;}
        public String lanBroadcastAddress{get;set;}
        public String itemisedBill{get;set;}
        public String lanSubnetMask{get;set;}
        public String percentilePercentage{get;set;}
        public String wanIpAddressPool{get;set;}
        public String billingType{get;set;}
        public String wanSubnetMask{get;set;}
        public String typeofLeasedLine{get;set;}
        public String ipAddressatTtsl{get;set;}
        public String aggregatedCircuit{get;set;}
        public String customerWanIp{get;set;}
        public String isAggregatedILLReq{get;set;}
        public String IpAddressCustomer{get;set;}
        public String phoneNumber{get;set;}
        public String IpAddressPopEnd{get;set;}
        public String effectiveDate{get;set;}
        public String IpAddressPool{get;set;}
        public String billingCycle{get;set;}
        public String publicIpAddress{get;set;}
        public String paymentTerms{get;set;}
        public String provider{get;set;}
        public String arrearsAdvance{get;set;}
        public String addressSpace{get;set;}
        public String agreementPeriod{get;set;}
        public String spaceUtilization{get;set;}
        public String existingCircuitId{get;set;}
        public String dialUp{get;set;}
        public String migrationType{get;set;}
        public String cable{get;set;}
        //public String wifiSoid{get;set;}
        public String webHosting{get;set;}
        public String fanStatus{get;set;}
        public String leasedLine{get;set;}
        public String activity{get;set;}
        public String xdsl{get;set;}
        public String flavour{get;set;}
        public String coLocation{get;set;}
        public String remarks{get;set;}
        public String wireless{get;set;}
        public String mocnNumber{get;set;}
        public String enterpriseUse{get;set;}
        public String bscName{get;set;}
        public String routerPorts{get;set;}
        public String infraVendor{get;set;}
        public String packetShaper{get;set;}
        public String fanShared{get;set;}
        public String firewall{get;set;}
        public String ptBinterface3{get;set;}
        public String dmzServers{get;set;}
        public String interface3{get;set;}
        public String customerVpnServers{get;set;}
        public String ptBinterface2{get;set;}
        public String ipAllocation{get;set;}
        public String interface2{get;set;}
        public String expectedSurrenderDate{get;set;}
        public String ptBinterface1{get;set;}
        public String cyberButlerRequired{get;set;}
        public String interface1{get;set;}
        public String hotspotName{get;set;}
        public String mediaTypeB{get;set;}
        public String hotspotType{get;set;}
        public String mediaType{get;set;}
        public String contactLastPerson{get;set;}
        public String ptBnetworkType{get;set;}
        public String authenticationType{get;set;}
        public String networkType{get;set;}
        public String address1{get;set;}
        public String ptBemailID{get;set;}
        public String landmark{get;set;}
        public String emailID{get;set;}
        public String landmark1{get;set;}
        public String custPhoneNoB{get;set;}
        public String orderSize{get;set;}
        public String custPhoneNo{get;set;}
        public String noOfDids{get;set;}
        public String ptBcontactPerson{get;set;}
        public String interface11{get;set;}
        public String contactPerson{get;set;}
        public String noOfChannels{get;set;}
        public String ptBpincode{get;set;}
        public String phoneType{get;set;}
        public String pincode{get;set;}
        public String noOfAnalogLines{get;set;}
        public String ptBcity{get;set;}
        public String ipCentrexBandwidth{get;set;}
        public String city{get;set;}
        public String noOfIPExtensions{get;set;}
        public String ptBaddress3{get;set;}
        public String mode1{get;set;}
        public String address3{get;set;}
        public String shiftingType{get;set;}
        public String ptBaddress2{get;set;}
        public String newChannels{get;set;}
        public String address2{get;set;}
        public String totalChannels{get;set;}
        public String ptBfloor{get;set;}
        public String units{get;set;}
        public String floor{get;set;}
        public String coverageType{get;set;}
        public String ptBcustOriginationAddress{get;set;}
        public String contractPeriod{get;set;}
        public String custOriginationAddress{get;set;}
        public String billingFrequency{get;set;}
        public String ptBcircle{get;set;}
        public String paymentType{get;set;}
        public String Circle{get;set;}
        public String custMobileNo{get;set;}
        public String backhaulBadwidth{get;set;}
        public String adminEmail{get;set;}
        public String productVariant{get;set;}
        public String additionalEmail{get;set;}
        public String netBandwidth{get;set;}
        public String noOfLicense{get;set;}
        public String customerEmail{get;set;}
        public String additionalLicense{get;set;}
        public String nValue{get;set;}
        public String totalLicense{get;set;}
        public String bandwidth{get;set;}
        public String instPreName{get;set;}
        public String bandwidthReq{get;set;}
        public String motherFatherName{get;set;}
        public String linkCapacity{get;set;}
        public String firstName{get;set;}
        public String channelBandwidthReq{get;set;}
        public String lastName{get;set;}
        public String typeofLink{get;set;}
        public String addressProofDetails{get;set;}
        public String csitmsFlag{get;set;}
        public String idProofDetails{get;set;}
        public String billingCircle{get;set;}
        public String signProofDetails{get;set;}
        public String downgradeDisconnection{get;set;}
        public String productModules{get;set;}
        public String upgradeDisconnection{get;set;}
        public String additionalPlugins{get;set;}
        public String referenceCircuit{get;set;}
        public String customizationReq{get;set;}
        public String paralleBuildUp{get;set;}
        public String domainName{get;set;}
        public String shiftRequiredAt{get;set;}
        public String mxRecords{get;set;}
        public String existingCircuitAccountNo{get;set;}
        public String accessDomainControl{get;set;}
        public String accountNumber{get;set;}
        public String dataMigration{get;set;}
        public String addOn{get;set;}
        public String migrationDetails{get;set;}
        public String l2mcType{get;set;}
        public String advance{get;set;}
        public String noofDrops{get;set;}
        public list<String> channelCircuitList{get;set;}
        public String aggregatedIllFan{get;set;}
        public list<String> nplcCircuits{get;set;}
        public String aggregatedIll{get;set;}
        public list<String> dlcCircuits{get;set;}
        public String noofLinksReq{get;set;}
        public list<String> disconnectCircuitsList{get;set;}
        public String serviceSubTypeothers{get;set;}
        public String bundleName{get;set;}
        public String singleInvoiceRequired{get;set;}
        public String bundleID{get;set;}
        public String billFormat{get;set;}
        public String bundleRequired{get;set;}
        public String singleInvoiceFlavours{get;set;}
        public String exceptionID{get;set;}
        public String serviceSubType{get;set;}
        public String accountCategory{get;set;}
        public list<dropDetailsList> dropDetailsList{get;set;}
        public String marketSegment{get;set;}
        public String authKey{get;set;}
        public String exceptionRequired{get;set;}
        public String transactionID{get;set;}
        public String subCategory{get;set;}
        public String inputText1{get;set;}
        public String linkType{get;set;}
        public String inputText2{get;set;}
        public String productType{get;set;}
        public String inputText3{get;set;}
        public String salesMailId{get;set;}
        public String inputText4{get;set;}
        public String uniqueID{get;set;}
        public String inputText5{get;set;}
        public String fanNumber{get;set;}
        public String inputText6{get;set;}
        public String invoiceType{get;set;}
        public String inputText7{get;set;}
        public String salesId{get;set;}
        public String inputText8{get;set;}
        public String salesName{get;set;}
        public String inputText9{get;set;}
        public String soid{get;set;}
        public String inputText10{get;set;}
        public String companyName{get;set;}
        
    }
    public class dropDetailsList{
        public String dropNo{get;set;}
        public String dropAddress3{get;set;}
        public String dropAddress2{get;set;}
        public String dropPinCode{get;set;}
        public String dropAddress1{get;set;}
        public String dropId{get;set;}
        public String dropCity{get;set;}
        public String drop_ckt_id{get;set;}
        public String dropCircle{get;set;}
    }
    
    //Query all the fields which are required to process the JSON for Feasibility.
    public static List<SObject> executeQuery(List<SObject> newsObjList)
    {
        String query = 'Select Id,Name,ILL_Bandwidth__c, DLC_SOID__c,NPLC_SOID__c,POP_City__r.Name ,POP_Location__c,POP_Pincode__r.Name,POP_Address__c, '+
                        ' Network_Connectivity_Type__c, Network_Topology__c, Nimble_Type__c,Opportunity__r.Account.Market_Segment__c,'+
                        ' Opportunity__r.ISP_Non_ISP__c,Bandwidth_B__c, Class_Of_Service_Type__c, Class_Of_Service_Variant__c, Plan_Type__c,'+
                        ' VPN_Sub_Type__c,Bandwidth_A__c,Aggregated_ILL__c, Bandwidth_Required_At_A__c, Last_Mile__c, VPN_Type__c, MPLS_Bandwidth__c,Expected_Service_Assurance_SLA__c, Number_Of_Locations__c,'+
                        ' Service_Provider__c,Internet_Gateway__c, Bandwidth_Required__c, Bandwidth__c, Last_Mile_Bandwidth_Required__c,Floor__c, Floor_B__c,'+
                        ' ParentBilling_Circle__c, Product_BlitZStandard__c, Hotspot_Name__c, SSP_Account_Integration__c, Opportunity__r.Account.PAN_No__c,'+
                        ' WAN_Configuration__c,Interface11__c, Mode__c, Opportunity__r.Company__r.ID__C, Opportunity__r.SOID__c, CreatedDate,Contact_Mobile_B__c,'+
                        ' Reasons_for_additional_IP_request__c, Activity_Type__c, Remarks__c, IP_Addresses_range_currently_Used__c,Flavor__c,landmark__C,'+
                        ' Customers_Autonomous_System_Number__c,Parent_FAN_Number_Integration__c, Customers_IP__c, No_of_routesBGP__c, Bandwidth_Required_at_B__c,'+
                        ' Routes__c, Channelized_Bandwidth__c, Network__c, Host_From__c, Host_To__c, Broadcost_Address__c, Subnet_Mask__c, Return_to_AMT_Reason__c,'+
                        ' IP_Address_Pool__c, Type_of_Billing__c, WANSubnetMask__c, Type_of_Leased_Line__c, IP_Address_at_TTSL_End__c,'+
                        ' aggregatedCircuit__c, Net_Bandwidth_A__c, Type_of_Migration__c, IP_Address_at_Customer_End__c, Contact_Mobile__c, IP_Address_at_POP_End__c,'+
                        ' Effective_Date__c, Billing_Cycle__c, Payment_Terms__c, Provider__c, Arrears_Advance__c, Addresses_space__c,'+
                        ' Agreement_Period__c, Utilization_of_Allocated_addresses_space__c, Circuit_Del__r.Del_Number__c, Dialup__c, Cable__c, Web_Hosting__c,'+
                        ' Leaseline__c, Bandwidth_Required_Integration__c, Opportunity__r.Type, XD_SL__c, CoLocation__c, Wireless__c, MOCN_Number__c, Enterprises_Use__c, BSC_Name__c, Router_Ports__c,'+
                        ' Infra_Vendor__c, PacketShaper__c, Fan_Shared__c, Firewall__c, Interface3_BEnd__c, DMZ_Servers__c, Interface3_AEnd__c, Customer_VPN_Servers__c,'+
                        ' Interface2_BEnd__c, IP_Allocation__c, Interface2_AEnd__c, Expected_date_of_Surrendering__c, Interface1_BEnd__c, Cyber_Butler_Required__c,'+
                        ' Interface1_AEnd__c, Opportunity__r.Name, Preferred_Media_B_End__c, Hotspot_type__c, Preferred_Media_A_End__c, Contact_Name__c, Point_B_Network_Type__c,'+
                        ' Type_of_Authentication__c, Network_Type__c, Address_1__c, Contact_Email_B__c, Contact_Email__c, Opportunity__r.Order_Size__c,'+
                        ' Opportunity__r.No_of_DIDs__c, Contact_NameB__c, Opportunity__r.No_of_Channels__c, Pincode_B_new__r.Name, Type_Of_Phone__c, Pincode_New__r.Name, City_B__c,'+
                        ' City_B__r.Name, City__r.Name, City__c, No_Of_IP_Extensions__c, Address_3_B__c, Address_3__c, Shifting_Type__c, Address_2_B__c, New_Channels__c, Address_2__c, Total_Channels__c,'+
                        ' Coverage_Type__c, Address_1_B__c, Circle_B__c, Circle__c, Product_Variant__c, Net_Bandwidth_Required__c, Enter_value_of_N__c, Link_Capacity__c,'+
                        ' Type_of_Link__c,Opportunity__r.Account.Account_Category__c,  Billing_Circle__c,'+
                        ' Shift_Required_At__c, Circuit_Del__r.Account_Number__c, Opportunity__r.Account.Name, Do_you_want_to_add_on_or_not__c, L2MC_Type__c,'+
                        ' Reference_Circuit_Id__r.Del_number__C, Disconnection_Circuits_List__c , Downgrade_with_Disconnection2__c, Upgrade_with_Disconnection2__c, '+
                        ' Additional_IPs_Required__c, No_Of_Additional_LAN_IPs_Required__c, Number_of_Drops__c, Aggregated_ILL_FAN__c,  Number_of_Links_required__c, Service_Sub_Type_Other__c, Is_Single_Invoice_Required__c,'+
                        ' Bundle_ID__c, IP_Centrex_Bandwidth_Kbps__c, Is_Multimedia_FAN__c, Bill_Format__c, Is_Bundle_required__c, Single_Invoice_Flavours__c, Exception_Id__c, Service_Sub_Type__c, Opportunity__r.Account.Sub_Segment__c,'+
                        ' Opportunity__r.Account.Industry, Is_Exception_Id_Required__c, Sub_Category__c, Link_Type__c, Product__r.Name, Product__r.Fan_Category__c, Opportunity__r.Owner.Email, Opportunity__r.Account.Logo_ID__c,'+
                        ' FAN_Number__c, Wireline_Voice_Bandwidth__c, ISDN_Bandwidth__c, LM_Value__c, Invoice_Type__c, Opportunity__r.Owner.IDM_Id__c, Opportunity__r.Owner.Name, Opportunity__c,'+
                        ' Access_to_Domain_Control__c, Net_Bandwidth_Required_B__c, No_Of_Analog_Lines__c, Customer_Type__c, ISDN_Backup_Port_Required__c, CSITMS_Flag__c, Input_Text_1__c, Data_Migration__c, Combo_Solutions__c, Customization_Required__c, '+
                        ' Input_Text_10__c, Input_Text_2__c, Input_Text_3__c, Input_Text_4__c, Input_Text_5__c, Input_Text_6__c, Input_Text_7__c, Input_Text_8__c, Input_Text_9__c, '+
                        ' Enter_value_of_N_A__c, FAN_Status_Integration__c, Enter_value_of_N_B__c, FAN_Status__c, Percentile_Logic__c, Parallel_Build_Up__c, Packages__c, Sub_Activity__c , ' +
                        ' No_of_Channels__c, No_of_DIDs_Extensions__c, Order_Size_No_of_DELs__c, Pilot_Photon_Del_Number1__c, Pilot_Del_Number2__c, PRI_Photon_Account_Number__c,' +
                        ' Building__r.Name, Building__r.Address__c, Building__r.Address2__c, Building__r.City__c, Building__r.Pin_Code__c, Internet_Bandwidth_Ratio__c,' +
                        ' (Select Id, Name, Drop_Id__c, Address_Line3__c, Address_Line2__c, Pincode_New__r.Name, Address_Line1__c, City__r.Name, Circle__c from Drops__r order by Name)'+
                        ' from Feasibility__c';

        String q = query +' WHERE Id IN: newsObjList';
        List<SObject> SObjList = Database.query(q);
        //System.debug(SObjList);
        return SObjList;
    }
    
    //Initialize the JSOn_Field_Map with appropriate values.
    public static void initializeJSOn_Field_Map()
    {
        JSOn_Field_Map = new Map<String,FieldInfo>();
        
         JSOn_Field_Map.put('popCity',new FieldInfo('POP_City__r.Name',null,FALSE));
         JSOn_Field_Map.put('popLocation',new FieldInfo('POP_Location__c',null,FALSE));
         JSOn_Field_Map.put('popPincode',new FieldInfo('POP_Pincode__r.Name',null,FALSE));
         JSOn_Field_Map.put('installationCircle',new FieldInfo('Billing_Circle__c',null,FALSE));
         JSOn_Field_Map.put('popAddress',new FieldInfo('POP_Address__c',null,FALSE));
         JSOn_Field_Map.put('networkConnectivityType',new FieldInfo('Network_Connectivity_Type__c',null,FALSE));
         JSOn_Field_Map.put('aggregateRequired',new FieldInfo('Aggregated_ILL__c',null,FALSE));
         JSOn_Field_Map.put('networkTopology',new FieldInfo('Network_Topology__c',null,FALSE));
         JSOn_Field_Map.put('comboSolution',new FieldInfo('Combo_Solutions__c',null,FALSE));
         JSOn_Field_Map.put('nimbleType',new FieldInfo('Nimble_Type__c',null,FALSE));
         JSOn_Field_Map.put('customerType',new FieldInfo('Customer_Type__c',null,FALSE));
         JSOn_Field_Map.put('classServiceType',new FieldInfo('Class_Of_Service_Type__c',null,FALSE));
         JSOn_Field_Map.put('percentileLogic',new FieldInfo('Percentile_Logic__c',null,FALSE));
         JSOn_Field_Map.put('classServiceVariant',new FieldInfo('Class_Of_Service_Variant__c',null,FALSE));
         JSOn_Field_Map.put('planType',new FieldInfo('Plan_Type__c',null,FALSE));
         JSOn_Field_Map.put('vpnSubType',new FieldInfo('VPN_Sub_Type__c',null,FALSE));
         JSOn_Field_Map.put('lastMile',new FieldInfo('Last_Mile__c',null,FALSE));
         JSOn_Field_Map.put('vpnType',new FieldInfo('VPN_Type__c',null,FALSE));
         JSOn_Field_Map.put('packages',new FieldInfo('Packages__c',null,FALSE));
         JSOn_Field_Map.put('expectedServiceSLA',new FieldInfo('Expected_Service_Assurance_SLA__c',null,FALSE));
         JSOn_Field_Map.put('lmValue',new FieldInfo('LM_Value__c',null,FALSE));
         JSOn_Field_Map.put('numberLocations',new FieldInfo('Number_Of_Locations__c',null,FALSE));
         JSOn_Field_Map.put('serviceProvider',new FieldInfo('Service_Provider__c',null,FALSE));
         JSOn_Field_Map.put('mplsBandwidth',new FieldInfo('MPLS_Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('illBandwidth',new FieldInfo('ILL_Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('lmBandwidth',new FieldInfo('Last_Mile_Bandwidth_Required__c',null,FALSE));
         JSOn_Field_Map.put('internetBandwidthRatio',new FieldInfo('Internet_Bandwidth_Ratio__c',null,FALSE));
         JSOn_Field_Map.put('parentBillingCircle',new FieldInfo('ParentBilling_Circle__c',null,FALSE));
         JSOn_Field_Map.put('priAccountNumber',new FieldInfo('PRI_Photon_Account_Number__c',null,FALSE));
         JSOn_Field_Map.put('product',new FieldInfo('Product_BlitZStandard__c',null,FALSE));
         JSOn_Field_Map.put('pilotDel1',new FieldInfo('Pilot_Photon_Del_Number1__c',null,FALSE));
         JSOn_Field_Map.put('isdnBandwidth',new FieldInfo('ISDN_Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('pilotDel2',new FieldInfo('Pilot_Del_Number2__c',null,FALSE));
         JSOn_Field_Map.put('isdnBackupPort',new FieldInfo('ISDN_Backup_Port_Required__c',null,FALSE));
         JSOn_Field_Map.put('internetGateway',new FieldInfo('Internet_Gateway__c',null,FALSE));
         JSOn_Field_Map.put('sspAccount',new FieldInfo('SSP_Account_Integration__c',null,FALSE));
         JSOn_Field_Map.put('subActivity',new FieldInfo('Sub_Activity__c' ,null,FALSE));
         JSOn_Field_Map.put('panDetails',new FieldInfo('Opportunity__r.Account.PAN_No__c',null,FALSE));
         JSOn_Field_Map.put('wanConfiguration',new FieldInfo('WAN_Configuration__c',null,FALSE));
         JSOn_Field_Map.put('companyId',new FieldInfo('Opportunity__r.Company__r.ID__C',null,FALSE));
         JSOn_Field_Map.put('dlcSoid',new FieldInfo('DLC_SOID__c',null,FALSE));
         JSOn_Field_Map.put('fanCreationDate',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('nplcSoid',new FieldInfo('NPLC_SOID__c',null,FALSE));
         JSOn_Field_Map.put('comments',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('addIpRequest',new FieldInfo('Reasons_for_additional_IP_request__c',null,FALSE));
         JSOn_Field_Map.put('remarks',new FieldInfo('Remarks__c',null,FALSE));
         JSOn_Field_Map.put('ipUsedaddressRange',new FieldInfo('IP_Addresses_range_currently_Used__c',null,FALSE));
         JSOn_Field_Map.put('nValueB',new FieldInfo('Enter_value_of_N_B__c',null,FALSE));
         JSOn_Field_Map.put('custAutonomousNumber',new FieldInfo('Customers_Autonomous_System_Number__c',null,FALSE));
         JSOn_Field_Map.put('netBandwidthB',new FieldInfo('Net_Bandwidth_Required_B__c',null,FALSE));
         JSOn_Field_Map.put('custIpAddBlock',new FieldInfo('Customers_IP__c',null,FALSE));
         JSOn_Field_Map.put('bandwidthB',new FieldInfo('Bandwidth_B__c',null,FALSE));
         JSOn_Field_Map.put('noOfRoutes',new FieldInfo('No_of_routesBGP__c',null,FALSE));
         JSOn_Field_Map.put('bandwidthReqatB',new FieldInfo('Bandwidth_Required_at_B__c',null,FALSE));
         JSOn_Field_Map.put('routes',new FieldInfo('Routes__c',null,FALSE));
         JSOn_Field_Map.put('nValueA',new FieldInfo('Enter_value_of_N_A__c',null,FALSE));
         JSOn_Field_Map.put('lanNetworkAddress',new FieldInfo('Network__c',null,FALSE));
         JSOn_Field_Map.put('netBandwidthA',new FieldInfo('Net_Bandwidth_A__c',null,FALSE));
         JSOn_Field_Map.put('lanHostFrom',new FieldInfo('Host_From__c',null,FALSE));
         JSOn_Field_Map.put('bandwidthA',new FieldInfo('Bandwidth_A__c',null,FALSE));
         JSOn_Field_Map.put('lanHostTo',new FieldInfo('Host_To__c',null,FALSE));
         JSOn_Field_Map.put('bandwidthReqatA',new FieldInfo('Bandwidth_Required_At_A__c',null,FALSE));
         JSOn_Field_Map.put('lanBroadcastAddress',new FieldInfo('Broadcost_Address__c',null,FALSE));
         JSOn_Field_Map.put('itemisedBill',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('lanSubnetMask',new FieldInfo('Subnet_Mask__c',null,FALSE));
         JSOn_Field_Map.put('percentilePercentage',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('wanIpAddressPool',new FieldInfo('IP_Address_Pool__c',null,FALSE));
         JSOn_Field_Map.put('billingType',new FieldInfo('Type_of_Billing__c',null,FALSE));
         JSOn_Field_Map.put('wanSubnetMask',new FieldInfo('WANSubnetMask__c',null,FALSE));
         JSOn_Field_Map.put('typeofLeasedLine',new FieldInfo('Type_of_Leased_Line__c',null,FALSE));
         JSOn_Field_Map.put('ipAddressatTtsl',new FieldInfo('IP_Address_at_TTSL_End__c',null,FALSE));
         JSOn_Field_Map.put('aggregatedCircuit',new FieldInfo('aggregatedCircuit__c',null,FALSE));
         JSOn_Field_Map.put('customerWanIp',new FieldInfo('IP_Address_at_Customer_End__c',null,FALSE));
         JSOn_Field_Map.put('isAggregatedILLReq',new FieldInfo('Aggregated_ILL__c',null,FALSE));
         JSOn_Field_Map.put('IpAddressCustomer',new FieldInfo('IP_Address_at_Customer_End__c',null,FALSE));
         JSOn_Field_Map.put('phoneNumber',new FieldInfo('Contact_Mobile__c',null,FALSE));
         JSOn_Field_Map.put('IpAddressPopEnd',new FieldInfo('IP_Address_at_POP_End__c',null,FALSE));
         JSOn_Field_Map.put('effectiveDate',new FieldInfo('Effective_Date__c',null,FALSE));
         JSOn_Field_Map.put('IpAddressPool',new FieldInfo('IP_Address_Pool__c',null,FALSE));
         JSOn_Field_Map.put('billingCycle',new FieldInfo('Billing_Cycle__c',null,FALSE));
         JSOn_Field_Map.put('IpAddress',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('paymentTerms',new FieldInfo('Payment_Terms__c',null,FALSE));
         JSOn_Field_Map.put('provider',new FieldInfo('Provider__c',null,FALSE));
         JSOn_Field_Map.put('arrearsAdvance',new FieldInfo('Arrears_Advance__c',null,FALSE));
         JSOn_Field_Map.put('addressSpace',new FieldInfo('Addresses_space__c',null,FALSE));
         JSOn_Field_Map.put('agreementPeriod',new FieldInfo('Agreement_Period__c',null,FALSE));
         JSOn_Field_Map.put('spaceUtilization',new FieldInfo('Utilization_of_Allocated_addresses_space__c',null,FALSE));
         JSOn_Field_Map.put('existingCircuitId',new FieldInfo('Circuit_Del__r.Del_Number__c',null,FALSE));
         JSOn_Field_Map.put('dialUp',new FieldInfo('Dialup__c',null,FALSE));
         JSOn_Field_Map.put('migrationType',new FieldInfo('Type_of_Migration__c',null,FALSE));
         JSOn_Field_Map.put('cable',new FieldInfo('Cable__c',null,FALSE));
         //JSOn_Field_Map.put('wifiSoid',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('webHosting',new FieldInfo('Web_Hosting__c',null,FALSE));
         JSOn_Field_Map.put('fanStatus',new FieldInfo('FAN_Status_Integration__c',null,FALSE));
         JSOn_Field_Map.put('leasedLine',new FieldInfo('Leaseline__c',null,FALSE));
         JSOn_Field_Map.put('activity',new FieldInfo('Activity_Type__c',null,FALSE));
         JSOn_Field_Map.put('xdsl',new FieldInfo('XD_SL__c',null,FALSE));
         JSOn_Field_Map.put('flavour',new FieldInfo('Flavor__c',null,FALSE));
         JSOn_Field_Map.put('coLocation',new FieldInfo('CoLocation__c',null,FALSE));
         JSOn_Field_Map.put('remarks',new FieldInfo('Remarks__c',null,FALSE));
         JSOn_Field_Map.put('wireless',new FieldInfo('Wireless__c',null,FALSE));
         JSOn_Field_Map.put('mocnNumber',new FieldInfo('MOCN_Number__c',null,FALSE));
         JSOn_Field_Map.put('enterpriseUse',new FieldInfo('Enterprises_Use__c',null,FALSE));
         JSOn_Field_Map.put('bscName',new FieldInfo('BSC_Name__c',null,FALSE));
         JSOn_Field_Map.put('routerPorts',new FieldInfo('Router_Ports__c',null,FALSE));
         JSOn_Field_Map.put('infraVendor',new FieldInfo('Infra_Vendor__c',null,FALSE));
         JSOn_Field_Map.put('packetShaper',new FieldInfo('PacketShaper__c',null,FALSE));
         JSOn_Field_Map.put('fanShared',new FieldInfo('Fan_Shared__c',null,FALSE));
         JSOn_Field_Map.put('firewall',new FieldInfo('Firewall__c',null,FALSE));
         JSOn_Field_Map.put('ptBinterface3',new FieldInfo('Interface3_BEnd__c',null,FALSE));
         JSOn_Field_Map.put('dmzServers',new FieldInfo('DMZ_Servers__c',null,FALSE));
         JSOn_Field_Map.put('interface3',new FieldInfo('Interface3_AEnd__c',null,FALSE));
         JSOn_Field_Map.put('customerVpnServers',new FieldInfo('Customer_VPN_Servers__c',null,FALSE));
         JSOn_Field_Map.put('ptBinterface2',new FieldInfo('Interface2_BEnd__c',null,FALSE));
         JSOn_Field_Map.put('ipAllocation',new FieldInfo('IP_Allocation__c',null,FALSE));
         JSOn_Field_Map.put('interface2',new FieldInfo('Interface2_AEnd__c',null,FALSE));
         JSOn_Field_Map.put('expectedSurrenderDate',new FieldInfo('Expected_date_of_Surrendering__c',null,FALSE));
         JSOn_Field_Map.put('ptBinterface1',new FieldInfo('Interface1_BEnd__c',null,FALSE));
         JSOn_Field_Map.put('cyberButlerRequired',new FieldInfo('Cyber_Butler_Required__c',null,FALSE));
         JSOn_Field_Map.put('interface1',new FieldInfo('Interface1_AEnd__c',null,FALSE));
         JSOn_Field_Map.put('hotspotName',new FieldInfo('Hotspot_Name__c',null,FALSE));
         JSOn_Field_Map.put('mediaTypeB',new FieldInfo('Preferred_Media_B_End__c',null,FALSE));
         JSOn_Field_Map.put('hotspotType',new FieldInfo('Hotspot_type__c',null,FALSE));
         JSOn_Field_Map.put('mediaType',new FieldInfo('Preferred_Media_A_End__c',null,FALSE));
         JSOn_Field_Map.put('contactLastPerson',new FieldInfo('Contact_Name__c',null,FALSE));
         JSOn_Field_Map.put('ptBnetworkType',new FieldInfo('Point_B_Network_Type__c',null,FALSE));
         JSOn_Field_Map.put('authenticationType',new FieldInfo('Type_of_Authentication__c',null,FALSE));
         JSOn_Field_Map.put('networkType',new FieldInfo('Network_Type__c',null,FALSE));
         JSOn_Field_Map.put('address1',new FieldInfo('Address_1__c',null,TRUE));
         JSOn_Field_Map.put('ptBemailID',new FieldInfo('Contact_Email_B__c',null,FALSE));
         JSOn_Field_Map.put('landmark',new FieldInfo('landmark__C',null,FALSE));
         JSOn_Field_Map.put('emailID',new FieldInfo('Contact_Email__c',null,FALSE));
         JSOn_Field_Map.put('landmark1',new FieldInfo('Landmark__c',null,FALSE));
         JSOn_Field_Map.put('custPhoneNoB',new FieldInfo('Contact_Mobile_B__c',null,FALSE));
         JSOn_Field_Map.put('orderSize',new FieldInfo('Order_Size_No_of_DELs__c',null,FALSE));
         JSOn_Field_Map.put('custPhoneNo',new FieldInfo('Contact_Mobile__c',null,FALSE));
         JSOn_Field_Map.put('noOfDids',new FieldInfo('No_of_DIDs_Extensions__c',null,FALSE));
         JSOn_Field_Map.put('ptBcontactPerson',new FieldInfo('Contact_NameB__c',null,FALSE));
         JSOn_Field_Map.put('interface11',new FieldInfo('Interface11__c',null,FALSE));
         JSOn_Field_Map.put('contactPerson',new FieldInfo('Contact_Name__c',null,FALSE));
         JSOn_Field_Map.put('noOfChannels',new FieldInfo('No_of_Channels__c',null,FALSE));
         JSOn_Field_Map.put('ptBpincode',new FieldInfo('Pincode_B_new__r.Name',null,FALSE));
         JSOn_Field_Map.put('phoneType',new FieldInfo('Type_Of_Phone__c',null,FALSE));
         JSOn_Field_Map.put('pincode',new FieldInfo('Pincode_New__r.Name',null,TRUE));
         JSOn_Field_Map.put('noOfAnalogLines',new FieldInfo('No_Of_Analog_Lines__c',null,FALSE));
         JSOn_Field_Map.put('ptBcity',new FieldInfo('City_B__r.Name',null,FALSE));
         JSOn_Field_Map.put('ipCentrexBandwidth',new FieldInfo('IP_Centrex_Bandwidth_Kbps__c',null,FALSE));
         JSOn_Field_Map.put('city',new FieldInfo('City__r.Name',null,TRUE));
         JSOn_Field_Map.put('noOfIPExtensions',new FieldInfo('No_Of_IP_Extensions__c',null,FALSE));
         JSOn_Field_Map.put('ptBaddress3',new FieldInfo('Address_3_B__c',null,FALSE));
         JSOn_Field_Map.put('mode1',new FieldInfo('Mode__c',null,FALSE));
         JSOn_Field_Map.put('address3',new FieldInfo('Address_3__c',null,TRUE));
         JSOn_Field_Map.put('shiftingType',new FieldInfo('Shifting_Type__c',null,FALSE));
         JSOn_Field_Map.put('ptBaddress2',new FieldInfo('Address_2_B__c',null,FALSE));
         JSOn_Field_Map.put('newChannels',new FieldInfo('New_Channels__c',null,FALSE));
         JSOn_Field_Map.put('address2',new FieldInfo('Address_2__c',null,TRUE));
         JSOn_Field_Map.put('totalChannels',new FieldInfo('Total_Channels__c',null,FALSE));
         JSOn_Field_Map.put('ptBfloor',new FieldInfo('Floor_B__c',null,FALSE));
         JSOn_Field_Map.put('units',new FieldInfo('Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('floor',new FieldInfo('Floor__c',null,FALSE));
         JSOn_Field_Map.put('coverageType',new FieldInfo('Coverage_Type__c',null,FALSE));
         JSOn_Field_Map.put('ptBcustOriginationAddress',new FieldInfo('Address_1_B__c',null,FALSE));
         JSOn_Field_Map.put('contractPeriod',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('custOriginationAddress',new FieldInfo('Address_1__c',null,FALSE));
         JSOn_Field_Map.put('billingFrequency',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('ptBcircle',new FieldInfo('Circle_B__c',null,FALSE));
         JSOn_Field_Map.put('paymentType',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('Circle',new FieldInfo('Circle__c',null,FALSE));
         JSOn_Field_Map.put('custMobileNo',new FieldInfo('Contact_Mobile__c',null,FALSE));
         JSOn_Field_Map.put('backhaulBadwidth',new FieldInfo('Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('adminEmail',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('productVariant',new FieldInfo('Product_Variant__c',null,FALSE));
         JSOn_Field_Map.put('additionalEmail',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('netBandwidth',new FieldInfo('Net_Bandwidth_Required__c',null,FALSE));
         JSOn_Field_Map.put('noOfLicense',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('customerEmail',new FieldInfo('Contact_Email__c',null,FALSE));
         JSOn_Field_Map.put('additionalLicense',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('nValue',new FieldInfo('Enter_value_of_N__c',null,FALSE));
         JSOn_Field_Map.put('totalLicense',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('bandwidth',new FieldInfo('Bandwidth__c',null,TRUE));
         JSOn_Field_Map.put('instPreName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('bandwidthReq',new FieldInfo('Bandwidth_Required_Integration__c',null,FALSE));
         JSOn_Field_Map.put('motherFatherName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('linkCapacity',new FieldInfo('Link_Capacity__c',null,FALSE));
         JSOn_Field_Map.put('firstName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('channelBandwidthReq',new FieldInfo('Channelized_Bandwidth__c',null,FALSE));
         JSOn_Field_Map.put('lastName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('typeofLink',new FieldInfo('Type_of_Link__c',null,FALSE));
         JSOn_Field_Map.put('addressProofDetails',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('csitmsFlag',new FieldInfo('CSITMS_Flag__c',null,FALSE));
         JSOn_Field_Map.put('idProofDetails',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('billingCircle',new FieldInfo('Billing_Circle__c',null,FALSE));
         JSOn_Field_Map.put('signProofDetails',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('downgradeDisconnection',new FieldInfo('Downgrade_with_Disconnection2__c',null,FALSE));
         JSOn_Field_Map.put('productModules',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('upgradeDisconnection',new FieldInfo('Upgrade_with_Disconnection2__c',null,FALSE));
         JSOn_Field_Map.put('additionalPlugins',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('referenceCircuit',new FieldInfo('Reference_Circuit_Id__r.Del_Number__c',null,FALSE));
      //   JSOn_Field_Map.put('referenceCircuit',new FieldInfo('Circuit_Del__r.Del_Number__c',null,FALSE));
         JSOn_Field_Map.put('customizationReq',new FieldInfo('Customization_Required__c',null,FALSE));
         JSOn_Field_Map.put('paralleBuildUp',new FieldInfo('Parallel_Build_Up__c',null,FALSE));
         JSOn_Field_Map.put('domainName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('shiftRequiredAt',new FieldInfo('Shift_Required_At__c',null,FALSE));
         JSOn_Field_Map.put('mxRecords',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('existingCircuitAccountNo',new FieldInfo(null,'',FALSE));
     //    JSOn_Field_Map.put('existingCircuitAccountNo',new FieldInfo('Circuit_Del__r.Account_Number__c',null,FALSE));
         JSOn_Field_Map.put('accessDomainControl',new FieldInfo('Access_to_Domain_Control__c',null,FALSE));
         JSOn_Field_Map.put('accountNumber',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('dataMigration',new FieldInfo('Data_Migration__c',null,FALSE));
         JSOn_Field_Map.put('addOn',new FieldInfo('Do_you_want_to_add_on_or_not__c',null,FALSE));
         JSOn_Field_Map.put('migrationDetails',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('l2mcType',new FieldInfo('L2MC_Type__c',null,FALSE));
         JSOn_Field_Map.put('advance',new FieldInfo('Arrears_Advance__c',null,FALSE));
         JSOn_Field_Map.put('noofDrops',new FieldInfo('Number_of_Drops__c',null,FALSE));
         JSOn_Field_Map.put('aggregatedIllFan',new FieldInfo('Aggregated_ILL_FAN__c',null,FALSE));
         JSOn_Field_Map.put('aggregatedIll',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('noofLinksReq',new FieldInfo('Number_of_Links_required__c',null,FALSE));
         JSOn_Field_Map.put('serviceSubTypeothers',new FieldInfo('Service_Sub_Type_Other__c',null,FALSE));
         JSOn_Field_Map.put('bundleName',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('singleInvoiceRequired',new FieldInfo('Is_Single_Invoice_Required__c',null,FALSE));
         JSOn_Field_Map.put('bundleID',new FieldInfo('Bundle_ID__c',null,FALSE));
         JSOn_Field_Map.put('billFormat',new FieldInfo('Bill_Format__c',null,FALSE));
         JSOn_Field_Map.put('bundleRequired',new FieldInfo('Is_Bundle_required__c',null,FALSE));
         JSOn_Field_Map.put('singleInvoiceFlavours',new FieldInfo('Single_Invoice_Flavours__c',null,FALSE));
         JSOn_Field_Map.put('exceptionID',new FieldInfo('Exception_Id__c',null,FALSE));
         JSOn_Field_Map.put('serviceSubType',new FieldInfo('Service_Sub_Type__c',null,FALSE));
         JSOn_Field_Map.put('accountCategory',new FieldInfo('Opportunity__r.Account.Account_Category__c',null,FALSE));
         JSOn_Field_Map.put('marketSegment',new FieldInfo('Opportunity__r.Account.Market_Segment__c',null,FALSE));
         JSOn_Field_Map.put('authKey',new FieldInfo(null,null,FALSE));
         JSOn_Field_Map.put('exceptionRequired',new FieldInfo('Is_Exception_Id_Required__c',null,FALSE));
         JSOn_Field_Map.put('transactionID',new FieldInfo('Id',null,FALSE));
         JSOn_Field_Map.put('subCategory',new FieldInfo('Sub_Category__c',null,FALSE));
         JSOn_Field_Map.put('inputText1',new FieldInfo('Is_Multimedia_FAN__c',null,TRUE));
         JSOn_Field_Map.put('linkType',new FieldInfo('Link_Type__c',null,FALSE));
         JSOn_Field_Map.put('inputText2',new FieldInfo('Parent_FAN_Number_Integration__c',null,FALSE));
         JSOn_Field_Map.put('productType',new FieldInfo('Product__r.Name',null,FALSE));
         JSOn_Field_Map.put('inputText3',new FieldInfo('Additional_IPs_Required__c',null,FALSE));
         JSOn_Field_Map.put('salesMailId',new FieldInfo('Opportunity__r.Owner.Email',null,FALSE));
         JSOn_Field_Map.put('inputText4',new FieldInfo('No_Of_Additional_LAN_IPs_Required__c',null,FALSE));
         JSOn_Field_Map.put('uniqueID',new FieldInfo('Opportunity__r.Account.Logo_ID__c',null,FALSE));
         JSOn_Field_Map.put('inputText5',new FieldInfo('Return_to_AMT_Reason__c',null,FALSE));
         JSOn_Field_Map.put('fanNumber',new FieldInfo('Name',null,FALSE));
         JSOn_Field_Map.put('inputText6',new FieldInfo('Input_Text_6__c',null,FALSE));
         JSOn_Field_Map.put('invoiceType',new FieldInfo('Invoice_Type__c',null,FALSE));
         JSOn_Field_Map.put('inputText7',new FieldInfo('Input_Text_7__c',null,FALSE));
         JSOn_Field_Map.put('salesId',new FieldInfo('Opportunity__r.Owner.IDM_Id__c',null,FALSE));
         JSOn_Field_Map.put('inputText8',new FieldInfo('Input_Text_8__c',null,FALSE));
         JSOn_Field_Map.put('salesName',new FieldInfo('Opportunity__r.Owner.Name',null,FALSE));
         JSOn_Field_Map.put('inputText9',new FieldInfo('Input_Text_9__c',null,FALSE));
         JSOn_Field_Map.put('soid',new FieldInfo('Opportunity__r.SOID__c',null,FALSE));
         JSOn_Field_Map.put('inputText10',new FieldInfo('Input_Text_10__c',null,FALSE));
         JSOn_Field_Map.put('companyName',new FieldInfo('Opportunity__r.Account.Name',null,FALSE));
         JSOn_Field_Map.put('dropNo',new FieldInfo('Name',null,FALSE));
         JSOn_Field_Map.put('dropAddress3',new FieldInfo('Address_Line3__c',null,FALSE));
         JSOn_Field_Map.put('dropAddress2',new FieldInfo('Address_Line2__c',null,FALSE));
         JSOn_Field_Map.put('dropPinCode',new FieldInfo('Pincode_New__r.Name',null,FALSE));
         JSOn_Field_Map.put('dropAddress1',new FieldInfo('Address_Line1__c',null,FALSE));
         JSOn_Field_Map.put('dropId',new FieldInfo('Drop_Id__c',null,FALSE));
         JSOn_Field_Map.put('dropCity',new FieldInfo('City__r.Name',null,FALSE));
         JSOn_Field_Map.put('drop_ckt_id',new FieldInfo(null,'',FALSE));
         JSOn_Field_Map.put('dropCircle',new FieldInfo('Circle__c',null,FALSE));
         JSOn_Field_Map.put('publicIpAddress',new FieldInfo(null,'',FALSE));
        
         System.debug('Size of Map: '+ JSOn_Field_Map.size());
         //System.Debug('Content :' +JSOn_Field_Map);

    }
    
    //For each sObj in the sObjList, an Empower_REST__c record is created.
    public static List<Empower_REST__c> CreateJSON( List<sObject> sObjList )
    {
        //The Map with all keys to be used for class FeasibilityJSON
        Map<String, Object> FeasibilityJSON_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new FeasibilityJSON()));
        //The Map with all keys to be used for class DropDetailsList
        Map<String, Object> DropDetailsList_ObjMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(new dropDetailsList()));
        //The list of Empower_Rest__c records which needs to be returned.
        List<Empower_REST__c> empRESTList = new List<Empower_REST__c>();
       
        for(SObject sObj : sObjList)
        {
            //The Empower_REST__c record corresponding to this sObj.
            Empower_REST__c empNew = new Empower_REST__c(); 
            Feasibility__C F =  (Feasibility__c)sObj;
            //Loop over this list to get the array for Drop Details
            List<Drop__c> DropList = F.Drops__r;
            System.Debug('DropList:'+DropList);
            //This list will be appear as an array of Drop Details in the JSON string
            List<dropDetailsList> DetailList = new List<dropDetailsList>();
            //This empty String list will popualte empty json arrays for 
            // nplcCircuits, dlcCircuits, disconnectCircuitsList, channelCircuitList
            List<String> BlankList = new List<String>();
            
            for(Drop__c drop : DropList)
            {
                //This Map needs to be converted to the DropDetailsList Object.
                Map<String, Object> Drop_Map = new Map<String, Object>( DropDetailsList_ObjMap );
                for(String key : Drop_Map.keySet())
                {
                    //For each Key found in the JSOn_Field_Map, fill in the value from API Name/ Fixed value.
                   if(JSOn_Field_Map.get(key)!=null)
                    {//System.Debug(key);
                       if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                           Drop_Map.put(key, GenerateEmpowerREST.GetFieldValue( drop , JSOn_Field_Map.get(key).APIName ) ) ;
                        else if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == true )
                            {System.Debug('Execute Business Logic for this field : '+ JSOn_Field_Map.get(key).APIName) ;
                            }
                        else if(JSOn_Field_Map.get(key).FixedValue != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                           Drop_Map.put(key, String.ValueOF(JSOn_Field_Map.get(key).FixedValue ) );
                    }  
                }
                //Convert the map for this drop record into an object of class dropDetailsList 
            dropDetailsList DDJson = (dropDetailsList)JSON.deserializeStrict(JSON.serialize(Drop_Map), dropDetailsList.class);
            //Add this object to the DetailList which will be an array in the final JSON String.
                DetailList.add(DDJson);
            }
            //This Map needs to be converted to the FeasibilityJSON Object.
            Map<String, Object> Obj_Map = new Map<String, Object>( FeasibilityJSON_ObjMap );
            
            for(String key : Obj_Map.keySet())
            {//For each Key found in the JSOn_Field_Map, fill in the value from API Name/ Fixed value.
                if(JSOn_Field_Map.get(key)!=null)
                {//System.Debug(key);
                   if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                       Obj_Map.put(key, GenerateEmpowerREST.GetFieldValue( sObj , JSOn_Field_Map.get(key).APIName ) ) ;
                    else if(JSOn_Field_Map.get(key).APIName != null && JSOn_Field_Map.get(key).ExecuteLogic == true )
                    {System.Debug('Execute Business Logic for this field : '+ JSOn_Field_Map.get(key).APIName) ;
                       Obj_Map.put(key, ExecuteBusinessLogic( key , (Feasibility__c)sObj) );
                    }
                    else if(JSOn_Field_Map.get(key).FixedValue != null && JSOn_Field_Map.get(key).ExecuteLogic == false )
                       Obj_Map.put(key, String.ValueOF(JSOn_Field_Map.get(key).FixedValue ) );
                } 
            }
            
            //Add the Lists required in the object of FeasibilityJSON class
            FeasibilityJSON FJson = (FeasibilityJSON)JSON.deserializeStrict(JSON.serialize(Obj_Map), FeasibilityJSON.class);
            Datetime dte = Datetime.newInstance(Date.valueOf(sObj.get('CreatedDate')).year(), Date.valueOf(sObj.get('CreatedDate')).month(), Date.valueOf(sObj.get('CreatedDate')).day());
            FJson.fanCreationDate = dte.format('MM/dd/yyyy');
            // #AuthKey : get from custom Setting
            if( String.IsNotBlank( FeasibilityInterface.EndPoint.Auth_Key__c ))
             FJSon.authKey = FeasibilityInterface.EndPoint.Auth_Key__c ;
            FJson.dropDetailsList = DetailList ;
            FJson.nplcCircuits = BlankList ;
            FJson.dlcCircuits = BlankList ;
            if(String.isBlank(F.Disconnection_Circuits_List__c))
             FJson.disconnectCircuitsList = BlankList ;
            else
             FJson.disconnectCircuitsList = F.Disconnection_Circuits_List__c.split(','); 
            FJson.channelCircuitList = BlankList ;
            //Get the JSON String from the object of class FeasibilityJSON 
            String JSON_String = JSON.serialize(FJson);
            System.Debug('JSON_String : '+ JSON_String);
            
            //System.Debug('SObject: '+ sObj.id);
            //Fill in the necessary details for Empower_REST__c record.
            empNew.Feasibility__c = sObj.id ;
            empNew.Endpoint__c = FeasibilityInterface.EndPoint.Endpoint__c ;
            empNew.JSON__c = JSON_String ;
            empNew.Status__c = 'New' ;
            empNew.Priority__c = FeasibilityInterface.EndPoint.Priority__c ;
            empNew.Retrial_Count__c = 0 ;
            empNew.Key__c = sObj.id +'~feasibility~new';
            if(String.IsNotBlank(empNew.JSON__c))
             //Add the Empower_REST__c record to the return list.
             empRESTList.add(empNew);
        }
        return empRESTList;
    }
    
     //For jsonFields where extended business logic needs to be executed.
    public static String ExecuteBusinessLogic( String jsonName , Feasibility__c sObj)
    { String returnVAl;
        
        if(jsonName == 'bandwidth' && sObj.Product__r != null)
        {
          returnVAl= (  (sObj.Product__r.FAN_Category__c == 'Wireline Voice') ? String.ValueOf(sObj.Wireline_Voice_Bandwidth__c) : sObj.Bandwidth__c ) ;
        }
     //Populate Fields From Building__C Lookup for Green Channel.
        if(jsonName == 'address1' && ( (sObj.Flavor__C == 'Green Channel' && sObj.Building__r != null) || sObj.Flavor__C != 'Green Channel' ) )
        {
          returnVAl= (  (sObj.Flavor__C == 'Green Channel') ? String.ValueOf(sObj.Building__r.Name) : sObj.Address_1__c ) ;
        }
     
        if(jsonName == 'address2' && ((sObj.Flavor__C == 'Green Channel' && sObj.Building__r != null) || sObj.Flavor__C != 'Green Channel' ) )
        {
          returnVAl= (  (sObj.Flavor__C == 'Green Channel') ? String.ValueOf(sObj.Building__r.Address__c) : sObj.Address_2__c ) ;
        }
     
        if(jsonName == 'address3' &&  ( (sObj.Flavor__C == 'Green Channel' && sObj.Building__r != null) || sObj.Flavor__C != 'Green Channel' ) )
        {
          returnVAl= (  (sObj.Flavor__C == 'Green Channel') ? String.ValueOf(sObj.Building__r.Address2__c) : sObj.Address_3__c ) ;
        }
     
        if(jsonName == 'city' &&  ( (sObj.Flavor__C == 'Green Channel' && sObj.Building__r != null) || sObj.City__r != null) )
        {
          returnVAl= (  (sObj.Flavor__C == 'Green Channel') ? String.ValueOf(sObj.Building__r.City__c) : sObj.City__r.Name ) ;
        }
     
        if(jsonName == 'pincode' && ( (sObj.Flavor__C == 'Green Channel' && sObj.Building__r != null) || sObj.Pincode_New__r != null ))
        {
          returnVAl= (  (sObj.Flavor__C == 'Green Channel') ? String.ValueOf(sObj.Building__r.Pin_Code__c) : sObj.Pincode_New__r.Name ) ;
        }
        if(jsonName == 'inputText1' && sObj.Is_Multimedia_FAN__c != null)
        {
          returnVAl= (  (sObj.Is_Multimedia_FAN__c == 'Y') ? 'Y' : '') ;
        }
        return ( returnVAl == null ? '' : returnVAl );
    }


}