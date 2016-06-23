/*
    * Name: FeasibilityTriggerTest Class
    * Created On: Jaunuary 27, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the FeasibilityTrigger, FeasibilityTriggerHAndler 
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 27-01-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/

@isTest(seeAllData = false)
public without sharing class FeasibilityTriggerTest {
    
    static testMethod void TestFeasibility()
    {
        List<user> u = TestDataFactory.createUsers();
        //u[0].ManagerId = u[2].Id;
        //update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
                          Test.startTest();

             EmpowerTransactionTest.CreateConfig();
        
        Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
        testacc.Market_Segment__c = 'SME A - COCP';
        testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
        testacc.Sub_Segment__c = 'SME A';
        testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
        testacc.Logo_Status__c = 'Verified';
        insert testacc;
             
        
             
        Company__C c1 = [Select Id,SSp_Account__c, Account__C from Company__c where Account__C = :testacc.id and default__c=true];
        c1.SSp_Account__c =  'lalala';  
        update c1;
             
        Company__C c2 = new Company__C( account__c = testacc.id, default__c=false);
        insert c2;
             
        Opportunity Opp1= new Opportunity();
        Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
        Opp1.Name = 'Opty 1';
        Opp1.AccountId = testacc.Id;
        Opp1.CloseDate = System.Today().addMonths(1);
        Opp1.StageName = 'Identified' ;
        Opp1.Win_Reason__c = 'Fresh Requirement' ;
        Opp1.Channel_Type__c = 'Direct' ;
        Opp1.Lead_No__c = 'abc123' ;
        Opp1.Type = 'New';
        Opp1.SOID_Created_in_Empower__c=true;
        Opp1.Block_SOID__c = false;
        //Opp1.Company__c= c1.id;
        Opp1.Lead_Owner_User_Segment__c = 'B2B';
        insert Opp1;
             
             
        Contact c = new Contact();
        c.LastName = 'Random Contact';
        c.AccountId = testacc.id ;
        c.Role__c = 'IT' ;
        c.Business_Function__c = 'Finance';
        c.Email = 'contact@random.com' ;
        c.MobilePhone = '9899075612' ;
        insert c;
        
        OpportunityContactRole oppContact = new OpportunityContactRole() ;
        oppContact.OpportunityId = Opp1.id;
        oppContact.ContactId = c.Id;
        OppContact.Role = 'Decision Maker';
        insert oppContact;  
             
        Product2 p = new Product2();
        p.Name = 'DLC' ;
        p.fan_category__c = 'Wireline Voice' ;
        p.IsActive = true ;
        p.Domain_Expert__c = u[0].Id ;
        p.Product_Type__c = 'Non-Standard' ;
        p.Product_Group__c = 'MS' ;
        p.Family = 'Solutions' ;
        p.TTL_TCL__c = 'TTL' ;
        p.BD_Category__c = 'Enterprise Voice' ;
        insert p;
             
        PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=p.Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
        insert pbe1 ;
             
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe1.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
        
        
        opp1.StageName = 'Qualified';
        update opp1;
             
              //Extended
             RESTEndpointURL__c rec = new RESTEndpointURL__c(Interface_Name__c='Feasibility',name ='Feasibility' , Endpoint__c = '', Active__c = true, Auth_Key__c='123');
             insert rec;
             
              RESTEndpointURL__c res = new RESTEndpointURL__c(Interface_Name__c='SSPAccount',name ='SSPAccount' , Endpoint__c = '', Active__c = true, Auth_Key__c='123');
             insert res;
             
        Feasibility__c F1 = new Feasibility__c();
          //F1.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('DLC-New').getRecordTypeId() ;
          F1.Opportunity__c = Opp1.Id;
          F1.Contact_Mobile__c = '9955446622';
          F1.Submit_to_AMT__c = true;
          F1.Product__C = p.id;
          insert F1 ;    
        Feasibility__c F2 = new Feasibility__c();
          //F2.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('FAN').getRecordTypeId() ;
          F2.Opportunity__c = Opp1.Id;
          F2.Contact_Mobile__c = '9955446622';
          F2.Product__C = p.id;
          //F2.Feasibility__c = F1.Id;
          insert F2 ;
             
       Feasibility__C F3 = new Feasibility__c();
          //F3.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('FAN').getRecordTypeId() ;
          F3.Opportunity__c = Opp1.Id;
          F3.Contact_Mobile__c = '9955446622';
           F3.Product__C = p.id;
          F3.Return_to_AMT_Reason__c = 'whatever';
          //F3.Feasibility__c = F1.Id;
          insert F3 ;
            
              Drop__c d1 = new Drop__c();
             d1.Feasibility__c = F3.id;
             d1.Name ='1';
             d1.Circle__c = F3.Billing_Circle__c ;
             insert d1;
             
             F1=[Select Name, Id from Feasibility__c where id = :F1.id];
             
          Feasibility_Status__C fs1 = new Feasibility_Status__C();
             //fs1.Feasibility__C = F1.id ;
             fs1.FAN_Number__c = F1.Name;
             //fs1.Status__C = 'Feasible' ;
             fs1.Feasibility_Status_ID__c = F1.Name;
             upsert fs1 Feasibility_Status_ID__c ;
         
             p.Fan_Category__c = 'DLC';
             update p;
        
             RecursionControl.FeasibilityrunBefore = true;
             RecursionControl.FeasibilityrunAfter = true ;
             F3.Is_Single_Invoice_Required__c ='Y';
             F3.Bill_Format__c = 'Single invoice' ;
             F3.Add_to_BC__c = true;
             F3.Flavor__c = 'Tactical Single Invoice';
             F3.Feasibility_AMT_Status_2__c = 'Closed';
             F3.Number_of_Links_required__c = 3;
             F3.Submit_to_AMT__c = true ;
             F3.Feasibility_AMT_Status_2__c ='CLOSED';
             update F3;
             
             RecursionControl.FeasibilityrunBefore = true;
             RecursionControl.FeasibilityrunAfter = true ;
             F3.ReSubmit_to_AMT__c = true ;
            update F3;
             
             Opp1.Company__c= c2.id;
             update Opp1;
             
             RecursionControl.FeasibilityrunBefore = true;
             RecursionControl.FeasibilityrunAfter = true ;
             F3.Is_Single_Invoice_Required__c ='Y';
             F3.Bill_Format__c = 'Single invoice' ;
             F3.Submit_to_AMT__c = False;
             F3.Add_to_BC__c = true;
             F3.Flavor__c = 'Tactical Single Invoice';
             F3.Feasibility_Status2__c = 'Accepted';
             F3.Number_of_Links_required__c = 3;
             F3.ReSubmit_to_AMT__c = true ;
            update F3;
             
             F3.Number_of_Links_required__c =1;
             update F3;
             Multimedia__c m1 =new Multimedia__c();
             m1.Feasibility__c = F3.id;
             m1.Media_A__c = 'Copper';
             m1.Media_B__c = '';
             insert m1;
             
             m1.Create_Multi_Media_FAN__c = true;
             update m1;
             
             
             Opportunity Opp2 = [Select Id, SOID__c from Opportunity where id = :Opp1.id];
             Business_Case__c bc = new Business_Case__C(Opportunity__c = Opp1.Id, key__c = Opp2.Soid__C);
             upsert bc Key__C;
             
             Test.stopTest();
          }
    }
    
    static testMethod void TestFeasibilityAdditional()
    {
        List<user> u = TestDataFactory.createUsers();
        //u[0].ManagerId = u[2].Id;
        //update u;
        System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[1])
            {System.debug('Current User: ' + UserInfo.getUserName());
                          Test.startTest();
            
             EmpowerTransactionTest.CreateConfig();
        
        Account testacc = new Account(Name = 'Test Account');
        testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
        testacc.Type = 'Other';        
        testacc.Logo_Segment__c = 'B2B' ;
        testacc.Market_Segment__c = 'SME A - COCP';
        testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
        testacc.Sub_Segment__c = 'SME A';
        testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
        testacc.Logo_Status__c = 'Verified';
        insert testacc;
             
        
             
        Company__C c1 = new Company__C(SSp_Account__c = 'lalala', account__c = testacc.id, default__c=false);
        insert c1;
             
        Company__C c2 = new Company__C( account__c = testacc.id, default__c=false);
        insert c2;
             
        Opportunity Opp1= new Opportunity();
        Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
        Opp1.Name = 'Opty 1';
        Opp1.AccountId = testacc.Id;
        Opp1.CloseDate = System.Today().addMonths(1);
        Opp1.StageName = 'Identified' ;
        Opp1.Win_Reason__c = 'Fresh Requirement' ;
        Opp1.Channel_Type__c = 'Direct' ;
        Opp1.Lead_No__c = 'abc123' ;
        Opp1.Type = 'New';
        Opp1.SOID_Created_in_Empower__c=true;
        Opp1.Block_SOID__c = false;
        //Opp1.Company__c= c1.id;
        Opp1.Lead_Owner_User_Segment__c = 'B2B';
        insert Opp1;
             
             
        Contact c = new Contact();
        c.LastName = 'Random Contact';
        c.AccountId = testacc.id ;
        c.Role__c = 'IT' ;
        c.Business_Function__c = 'Finance';
        c.Email = 'contact@random.com' ;
        c.MobilePhone = '9899075612' ;
        insert c;
        
        OpportunityContactRole oppContact = new OpportunityContactRole() ;
        oppContact.OpportunityId = Opp1.id;
        oppContact.ContactId = c.Id;
        OppContact.Role = 'Decision Maker';
        insert oppContact;  
             
        Product2 p = new Product2();
        p.Name = 'DLC' ;
        p.fan_category__c = 'Wireline Voice' ;
        p.IsActive = true ;
        p.Domain_Expert__c = u[0].Id ;
        p.Product_Type__c = 'Non-Standard' ;
        p.Product_Group__c = 'MS' ;
        p.Family = 'Solutions' ;
        p.TTL_TCL__c = 'TTL' ;
        p.BD_Category__c = 'Enterprise Voice' ;
        insert p;
             
        PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=p.Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
        insert pbe1 ;
             
        OpportunityLineItem OppLine1 = new OpportunityLineItem();
        OppLine1.OpportunityID = opp1.Id ;
        OppLine1.PriceBookEntryId = pbe1.Id ;
        OppLine1.Solution_Type__c = 'Complex' ;
        OppLine1.Quantity = 10 ;
        insert oppLine1 ; 
        
        
        opp1.StageName = 'Qualified';
        update opp1;
             
              Feasibility__C F3 = new Feasibility__c();
              //F3.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('FAN').getRecordTypeId() ;
              F3.Opportunity__c = Opp1.Id;
              F3.Contact_Mobile__c = '9955446622';
               F3.Product__C = p.id;
              F3.Return_to_AMT_Reason__c = 'whatever';
              F3.Product_Variant__c = 'Standard';
              F3.Flavor__c = 'mno';
              F3.Class_Of_Service_Variant__c = 'mno' ;
              F3.Nimble_Type__c = 'mno';
              //F3.Feasibility__c = F1.Id;
              insert F3 ;
             
             
             PageReference pageRef = Page.RaiseFANtype;
         Test.setCurrentPage(pageRef);
        ApexPages.standardController stdcontroller = new ApexPages.standardController(OppLine1);
        ApexPages.currentPage().getParameters().put('id', OppLine1.id);
        RaiseFeasibilityController controller = new RaiseFeasibilityController(stdcontroller);
             controller.Redirect();
             controller.myFeasibility.RecordTypeId=null;
             controller.Redirect();
         PageReference pageRefBC = Page.RaiseBCtype;
         Test.setCurrentPage(pageRefBC);
         ApexPages.standardController stdcontroller2 = new ApexPages.standardController(OppLine1);
         ApexPages.currentPage().getParameters().put('id', OppLine1.id);
        RaiseFeasibilityController controller2 = new RaiseFeasibilityController(stdcontroller2);
             controller2.Redirect();
             controller2.myBusinessCase.RecordTypeId=null;
             controller2.Redirect();
         RaiseFeasibilityController.getRecordType('mno', 'lalala',false, 'kmn') ;
             
              FieldInfo x = new FieldInfo();
             
              Feasibility__c F4 = [Select ID,FAN_number__c,Opportunity__r.Account.Owner.NAme, Opportunity__r.SOID__c, Opportunity__r.Account.Logo_Id__c from Feasibility__c where id = :F3.id];
              
             AV_CV__C avObj = new AV_CV__C(FAN_No__c = F4.id, Opportunity__c = Opp1.Id);
             insert avObj;
             SME_OrderValueBackUpdation__c circuit = new SME_OrderValueBackUpdation__c();
             circuit.Logo_ID__c = F4.Opportunity__r.Account.Logo_Id__c ;
             circuit.ExtraText2__c = F4.Opportunity__r.SOID__c ;
             Circuit.FAN_number__c = F4.FAN_Number__c ;
             insert circuit;
             
             circuit.FAN_Number__c = null;
             update circuit;
             
             circuit.FAn_number__c = F4.FAN_Number__c;
             update circuit;
             
              GenerateEmpowerREST.getFieldValue(F4,'Opportunity__r.Account.Owner.NAme') ;
             
             Building_Master__c bm = new Building_Master__c(Empower_Building_Id__c='abc',
                                                            Name='abc',
                                                            Address__c = 'abc',
                                                           Address2__c = 'abc',
                                                           Status__c = 'On-Net',
                                                           Last_Status_Update_Date__c = System.Now());
             insert bm;
             
             
             RecursionControl.FeasibilityrunBefore = true;
             RecursionControl.FeasibilityrunAfter = true ;
             F3.Flavor__c = 'Green Channel';
             F3.Is_Single_Invoice_Required__c ='N';
             F3.Building__c = bm.id;
             F3.Submit_to_AMT__c = true;
             F3.Number_of_Drops__c = null;
             update F3;
             
             RecursionControl.FeasibilityrunBefore = true;
             Feasibility__C F5 = F3.Clone();
             insert F5;
             
             
              City__c City1 = new City__c( Circle_desc__c = 'ASSAM');
            insert City1;
             Pin_Code__c PinCode1 = new Pin_Code__c(City__c=City1.Id);
             insert PinCode1;
             
             Feasibility__C F11 = new Feasibility__c();
              //F11.RecordTypeId = Schema.SObjectType.Feasibility__c.getRecordTypeInfosByName().get('FAN').getRecordTypeId() ;
              F11.Opportunity__c = Opp1.Id;
              F11.Contact_Mobile__c = '9955446622';
               F11.Product__C = p.id;
              F11.Return_to_AMT_Reason__c = 'whatever';
              F11.Product_Variant__c = 'Platinum';
              F11.Number_of_Drops__c = '1' ;
              F11.L2MC_Type__c = 'Premium';
              F11.Billing_Circle__c = 'ASSAM';
              F11.Address_1__c = 'abc';
              F11.Address_1_B__c = 'abc';
              F11.Address_2__c = 'abc';
              F11.Address_2_B__c = 'abc';
              F11.Address_3__c = 'abc';
              F11.Address_3_B__c = 'abc';
              F11.City__c = City1.id;
              F11.Pincode_New__c = Pincode1.id;
              F11.City_B__c = City1.id;
              F11.Pincode_B_new__c = Pincode1.id;
              F11.Flavor__c = 'xyz';
              F11.Class_Of_Service_Variant__c = 'xyz' ;
              F11.Nimble_Type__c = 'xyz';

              //F11.Feasibility__c = F1.Id;
             try{
                 RecursionControl.FeasibilityrunAfter = true;
              insert F11 ;
             }
             catch(Exception Ex)
             {
                insert F11; 
             }
              Drop__c d1 = new Drop__c();
             d1.Feasibility__c = F11.id;
             d1.Name ='1';
             d1.Circle__c = F11.Billing_Circle__c ;
             insert d1;
             
              //For Controller MassEditFeasibilityDropsController
             PageReference pageRef2 = Page.MassEditFeasibilityDrops;
             Test.setCurrentPage(pageRef2);
             ApexPages.standardController stdcontrollerDrop = new ApexPages.standardController(F11);
             ApexPages.currentPage().getParameters().put('id', F11.id);
             MassEditFeasibilityDropsController controllerDrop = new MassEditFeasibilityDropsController(stdcontrollerDrop);
             controllerDrop.updateDrops();
             
              PageReference pageRef3 = Page.MassEditFeasibilityDrops;
             Test.setCurrentPage(pageRef3);
             ApexPages.standardController stdcontrollerDrop2 = new ApexPages.standardController(F3);
             ApexPages.currentPage().getParameters().put('id', F3.id);
             MassEditFeasibilityDropsController controllerDrop2 = new MassEditFeasibilityDropsController(stdcontrollerDrop2);
             controllerDrop2.updateDrops();
             
          FeasibilityInterface f = new FeasibilityInterface();
          FeasibilityInterface.FeasibilityJSON fb = new FeasibilityInterface.FeasibilityJSON();
            fb.popCity= '';
            fb.popLocation= '';
            fb.popPincode= '';
            fb.installationCircle= '';
            fb.popAddress= '';
            fb.networkConnectivityType= '';
            fb.aggregateRequired= '';
            fb.networkTopology= '';
            fb.comboSolution= '';
            fb.nimbleType= '';
            fb.customerType= '';
            fb.classServiceType= '';
            fb.percentileLogic= '';
            fb.classServiceVariant= '';
            fb.planType= '';
            fb.vpnSubType= '';
            fb.lastMile= '';
            fb.vpnType= '';
            fb.packages= '';
            fb.expectedServiceSLA= '';
            fb.lmValue= '';
            fb.numberLocations= '';
            fb.serviceProvider= '';
            fb.mplsBandwidth= '';
            fb.illBandwidth= '';
            fb.lmBandwidth= '';
            fb.internetBandwidthRatio= '';
            fb.parentBillingCircle= '';
            fb.priAccountNumber= '';
            fb.product= '';
            fb.pilotDel1= '';
            fb.isdnBandwidth= '';
            fb.pilotDel2= '';
            fb.isdnBackupPort= '';
            fb.internetGateway= '';
            fb.sspAccount= '';
            fb.subActivity= '';
            fb.panDetails= '';
            fb.wanConfiguration= '';
            fb.companyId= '';
            fb.dlcSoid= '';
            fb.fanCreationDate= '';
            fb.nplcSoid= '';
            fb.comments= '';
            fb.addIpRequest= '';
            fb.Remarks= '';
            fb.ipUsedaddressRange= '';
            fb.nValueB= '';
            fb.custAutonomousNumber= '';
            fb.netBandwidthB= '';
            fb.custIpAddBlock= '';
            fb.bandwidthB= '';
            fb.noOfRoutes= '';
            fb.bandwidthReqatB= '';
            fb.routes= '';
            fb.nValueA= '';
            fb.lanNetworkAddress= '';
            fb.netBandwidthA= '';
            fb.lanHostFrom= '';
            fb.bandwidthA= '';
            fb.lanHostTo= '';
            fb.bandwidthReqatA= '';
            fb.lanBroadcastAddress= '';
            fb.itemisedBill= '';
            fb.lanSubnetMask= '';
            fb.percentilePercentage= '';
            fb.wanIpAddressPool= '';
            fb.billingType= '';
            fb.wanSubnetMask= '';
            fb.typeofLeasedLine= '';
            fb.ipAddressatTtsl= '';
            fb.aggregatedCircuit= '';
            fb.customerWanIp= '';
            fb.isAggregatedILLReq= '';
            fb.IpAddressCustomer= '';
            fb.phoneNumber= '';
            fb.IpAddressPopEnd= '';
            fb.effectiveDate= '';
            fb.IpAddressPool= '';
            fb.billingCycle= '';
            fb.publicIpAddress= '';
            fb.paymentTerms= '';
            fb.provider= '';
            fb.arrearsAdvance= '';
            fb.addressSpace= '';
            fb.agreementPeriod= '';
            fb.spaceUtilization= '';
            fb.existingCircuitId= '';
            fb.dialUp= '';
            fb.migrationType= '';
            fb.cable= '';
            //fb.wifiSoid= '';
            fb.webHosting= '';
            fb.fanStatus= '';
            fb.leasedLine= '';
            fb.activity= '';
            fb.xdsl= '';
            fb.flavour= '';
            fb.coLocation= '';
 
            fb.wireless= '';
            fb.mocnNumber= '';
            fb.enterpriseUse= '';
            fb.bscName= '';
            fb.routerPorts= '';
            fb.infraVendor= '';
            fb.packetShaper= '';
            fb.fanShared= '';
            fb.firewall= '';
            fb.ptBinterface3= '';
            fb.dmzServers= '';
            fb.interface3= '';
            fb.customerVpnServers= '';
            fb.ptBinterface2= '';
            fb.ipAllocation= '';
            fb.interface2= '';
            fb.expectedSurrenderDate= '';
            fb.ptBinterface1= '';
            fb.cyberButlerRequired= '';
            fb.interface1= '';
            fb.hotspotName= '';
            fb.mediaTypeB= '';
            fb.hotspotType= '';
            fb.mediaType= '';
            fb.contactLastPerson= '';
            fb.ptBnetworkType= '';
            fb.authenticationType= '';
            fb.networkType= '';
            fb.address1= '';
            fb.ptBemailID= '';
            fb.landmark= '';
            fb.emailID= '';
            fb.landmark1= '';
            fb.custPhoneNoB= '';
            fb.orderSize= '';
            fb.custPhoneNo= '';
            fb.noOfDids= '';
            fb.ptBcontactPerson= '';
            fb.interface11= '';
            fb.contactPerson= '';
            fb.noOfChannels= '';
            fb.ptBpincode= '';
            fb.phoneType= '';
            fb.pincode= '';
            fb.noOfAnalogLines= '';
            fb.ptBcity= '';
            fb.ipCentrexBandwidth= '';
            fb.city= '';
            fb.noOfIPExtensions= '';
            fb.ptBaddress3= '';
            fb.mode1= '';
            fb.address3= '';
            fb.shiftingType= '';
            fb.ptBaddress2= '';
            fb.newChannels= '';
            fb.address2= '';
            fb.totalChannels= '';
            fb.ptBfloor= '';
            fb.units= '';
            fb.floor= '';
            fb.coverageType= '';
            fb.ptBcustOriginationAddress= '';
            fb.contractPeriod= '';
            fb.custOriginationAddress= '';
            fb.billingFrequency= '';
            fb.ptBcircle= '';
            fb.paymentType= '';
            fb.Circle= '';
            fb.custMobileNo= '';
            fb.backhaulBadwidth= '';
            fb.adminEmail= '';
            fb.productVariant= '';
            fb.additionalEmail= '';
            fb.netBandwidth= '';
            fb.noOfLicense= '';
            fb.customerEmail= '';
            fb.additionalLicense= '';
            fb.nValue= '';
            fb.totalLicense= '';
            fb.bandwidth= '';
            fb.instPreName= '';
            fb.bandwidthReq= '';
            fb.motherFatherName= '';
            fb.linkCapacity= '';
            fb.firstName= '';
            fb.channelBandwidthReq= '';
            fb.lastName= '';
            fb.typeofLink= '';
            fb.addressProofDetails= '';
            fb.csitmsFlag= '';
            fb.idProofDetails= '';
            fb.billingCircle= '';
            fb.signProofDetails= '';
            fb.downgradeDisconnection= '';
            fb.productModules= '';
            fb.upgradeDisconnection= '';
            fb.additionalPlugins= '';
            fb.referenceCircuit= '';
            fb.customizationReq= '';
            fb.paralleBuildUp= '';
            fb.domainName= '';
            fb.shiftRequiredAt= '';
            fb.mxRecords= '';
            fb.existingCircuitAccountNo= '';
            fb.accessDomainControl= '';
            fb.accountNumber= '';
            fb.dataMigration= '';
            fb.addOn= '';
            fb.migrationDetails= '';
            fb.l2mcType= '';
            fb.advance= '';
            fb.noofDrops= '';
            
            fb.aggregatedIllFan= '';
            
            fb.aggregatedIll= '';
            
            fb.noofLinksReq= '';
            
            fb.serviceSubTypeothers= '';
            fb.bundleName= '';
            fb.singleInvoiceRequired= '';
            fb.bundleID= '';
            fb.billFormat= '';
            fb.bundleRequired= '';
            fb.singleInvoiceFlavours= '';
            fb.exceptionID= '';
            fb.serviceSubType= '';
            fb.accountCategory= '';
            
            fb.marketSegment= '';
            fb.authKey= '';
            fb.exceptionRequired= '';
            fb.transactionID= '';
            fb.subCategory= '';
            fb.inputText1= '';
            fb.linkType= '';
            fb.inputText2= '';
            fb.productType= '';
            fb.inputText3= '';
            fb.salesMailId= '';
            fb.inputText4= '';
            fb.uniqueID= '';
            fb.inputText5= '';
            fb.fanNumber= '';
            fb.inputText6= '';
            fb.invoiceType= '';
            fb.inputText7= '';
            fb.salesId= '';
            fb.inputText8= '';
            fb.salesName= '';
            fb.inputText9= '';
            fb.soid= '';
            fb.inputText10= '';
            fb.companyName= '';

            FeasibilityInterface.dropDetailsList d = new FeasibilityInterface.dropDetailsList();
            d.dropNo = '';
            d.dropAddress3 = '';
            d.dropAddress2 = '';
            d.dropPinCode = '';
            d.dropAddress1 = '';
            d.dropId = '';
            d.dropCity = '';
            d.drop_ckt_id = '';
            d.dropCircle = '';
             
             SSPAccountInterface.SSPAccountJSON sspObj = new SSPAccountInterface.SSPAccountJSON();
             sspObj.v_parent_circuit = '';
             sspObj.v_activity_type = '';
             sspObj.authKey = '';
             sspObj.v_company = '';
             
            RaiseFeasibilityController.getRecordType('DLC', 'New', false,'FAN BC');
            RaiseFeasibilityController.getRecordType('DLC', 'New', false,'AVCV');
            RaiseFeasibilityController.getRecordType('DLC', 'New', false,'Feasibility');
            RaiseFeasibilityController.getRecordType('DLC', 'New', false,'Business Case');


             Test.stopTest();

            }
    }

    
   
}