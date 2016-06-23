/*
    * Name: FanBCTriggerHandlerTest Class
    * Created On: May 19, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Used to test the FabBCTrigger, FabBCTriggerHandler 
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 10-05-16 |Initial version of Class  |
    * |------------------------------------------------------------|    
*/
@isTest
public class FanBCTriggerHandlerTest {
    static Opportunity Opp1;
    static Account testacc;
    static Company__C c1;
    static Product2 p;
    Static Feasibility__C F;
    
    @isTest(seeAllData = false)
    static void TestFANBC() 
    {
        List<user> u = TestDataFactory.createUsers();
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
				EmpowerTransactionTest.CreateConfig();
        
            testacc = new Account(Name = 'Test Account');
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
            
            Opp1= new Opportunity();
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
                 
            List<Product2> ProductList = new List<Product2>();
            Product2 P1 = new Product2();
            P1.Name = 'DLC';
            P1.Bc_category__c = 'DLC';
             ProductList.add(P1);
            Product2 P2 = new Product2();
            P2.Name = 'ILL';
            P2.Bc_category__c = 'ILL';
             ProductList.add(P2);
            Product2 P3 = new Product2();
            P3.Name = 'MPLS';
            P3.Bc_category__c = 'MPLS';
             ProductList.add(P3);
            Product2 P4 = new Product2();
            P4.Name = 'NPLC';
            P4.Bc_category__c = 'NPLC';
             ProductList.add(P4);
            Product2 P5 = new Product2();
            P5.Name = 'Ethernet Privale Line';
            P5.Bc_category__c = 'NPLC';
             ProductList.add(P5);
            Insert ProductList;

                 
            PricebookEntry pbe1 = new PricebookEntry(unitprice=0.00,Product2Id=ProductList[0].Id,Pricebook2Id=Test.getStandardPricebookId(), IsActive = true);
            insert pbe1 ;
                 
            OpportunityLineItem OppLine1 = new OpportunityLineItem();
            OppLine1.OpportunityID = opp1.Id ;
            OppLine1.PriceBookEntryId = pbe1.Id ;
            OppLine1.Solution_Type__c = 'Complex' ;
            OppLine1.Quantity = 10 ;
            insert oppLine1 ; 
            
            
            opp1.StageName = 'Qualified';
            update opp1;
             
            List<Feasibility__C> FeasibilityList = new List<Feasibility__C>();
            Feasibility__C F1 =new Feasibility__c();
            F1.Opportunity__c=Opp1.Id;
            F1.Product__C=ProductList[0].ID;
            F1.Return_to_AMT_Reason__c='whatever';
            F1.Feasibility_AMT_Status_2__c ='CLOSED';
            F1.Bandwidth_Required__c = '1000 Mbps';
            F1.Flavor__c = 'L2MC';
            F1.Is_Single_Invoice_Required__c='Y';
            F1.Bill_Format__c='Single Invoice';
            F1.Single_Invoice_Flavours__c='Circuit wise';
             FeasibilityList.Add(F1);
            Feasibility__C F2 =new Feasibility__c();
            F2.Opportunity__c=Opp1.Id;
            F2.Product__C=ProductList[1].ID;
            F2.Return_to_AMT_Reason__c='whatever';
            F2.Feasibility_AMT_Status_2__c ='CLOSED';
            F2.ILL_Bandwidth__C = '1000 Mbps';
            F2.Last_Mile_Bandwidth_Required__c = '2000 Mbps';
             FeasibilityList.Add(F2);
            Feasibility__C F3 =new Feasibility__c();
            F3.Opportunity__c=Opp1.Id;
            F3.Product__C=ProductList[2].ID;
            F3.Return_to_AMT_Reason__c='whatever';
            F3.Feasibility_AMT_Status_2__c ='CLOSED';
            F3.MPLS_Bandwidth__c = '1000 Mbps';
            F3.Last_Mile_Bandwidth_Required__c='2000 Mbps';
            F3.Plan_Type__c='Base Plans';
            F3.Class_Of_Service_Variant__c='Nimble';
            F3.Nimble_Type__c='Nimble 5';
             FeasibilityList.Add(F3);
            Feasibility__C F4 =new Feasibility__c();
            F4.Opportunity__c=Opp1.Id;
            F4.Product__C=ProductList[3].ID;
            F4.Return_to_AMT_Reason__c='whatever';
            F4.Feasibility_AMT_Status_2__c ='CLOSED';
            F4.Bandwidth_Required__C = '1000 Mbps';
            F4.Flavor__c = 'L2MC';
            F4.Is_Single_Invoice_Required__c='Y';
            F4.Bill_Format__c='Single Invoice';
            F4.Single_Invoice_Flavours__c='Circuit wise';
             FeasibilityList.Add(F4);
            Feasibility__C F5 =new Feasibility__c();
            F5.Opportunity__c=Opp1.Id;
            F5.Product__C=ProductList[4].ID;
            F5.Return_to_AMT_Reason__c='whatever';
            F5.Feasibility_AMT_Status_2__c ='CLOSED';
            F5.Bandwidth_Required__C = '1000 Mbps';
            F5.Bandwidth_Required_AT_A__C = '1000 Mbps';
            F5.Bandwidth_Required_AT_B__C = '1000 Mbps';
            F5.Flavor__c = 'L2MC';
            F5.Is_Single_Invoice_Required__c='Y';
            F5.Bill_Format__c='Single Invoice';
            F5.Single_Invoice_Flavours__c='Circuit wise';
            F5.L2MC_Type__c ='Premium';
            FeasibilityList.Add(F5);
            Feasibility__C F6 =new Feasibility__c();
            F6.Opportunity__c=Opp1.Id;
            F6.Product__C=ProductList[2].ID;
            F6.Return_to_AMT_Reason__c='whatever';
            F6.Feasibility_AMT_Status_2__c ='CLOSED';
            F6.MPLS_Bandwidth__c = '1000 Mbps';
            F6.Last_Mile_Bandwidth_Required__c='2000 Mbps';
            F6.Plan_Type__c='Base Plans';
            F6.Class_Of_Service_Variant__c='Single';
            F6.Class_Of_Service_Type__c='Platinum';
             FeasibilityList.Add(F6);
             
            Insert FeasibilityList;
             
            List<Feasibility_Status__c> StatusList = new List<Feasibility_Status__C>();
            Feasibility_Status__c FS1 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[0].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=17,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS1);
            Feasibility_Status__c FS2 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[1].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=17,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS2);
            Feasibility_Status__c FS3 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[2].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=17,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS3);
            Feasibility_Status__c FS4 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[3].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=17,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS4);
            Feasibility_Status__c FS5 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[4].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=18,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS5);
            Feasibility_Status__c FS6 = new Feasibility_Status__c(Feasibility__c = FeasibilityList[5].id,
                                                                  Chargeable_Distance__c=17,
                                                                  L2_Multicast_Chargeable_Distance__c=17,
                                                                  Chargeable_Distance_B__c=17,
                                                                  NLD_Distance__c=17
                                                                  );
            StatusList.add(FS6);
            Insert StatusList;
             
             List<RateCard__C> RateCardList = new LIST<RateCard__C>();
             RateCard__C R1 = new RateCard__C(Unique__c='DLC~Lastmile ARC~17~MBPS~1000',
                                              Amount__c= 2000);
             RateCardList.add(R1);
             RateCard__C R2 = new RateCard__C(Unique__c='NPLC~Lastmile ARC~17~MBPS~1000',
                                 Amount__c= 2000);
             RateCardList.add(R2);
             RateCard__C R3 = new RateCard__C(Unique__c='MPLS~Lastmile ARC~17~MBPS~1000',
                                 Amount__c= 2000);
             RateCardList.add(R3);
             RateCard__C R4 = new RateCard__C(Unique__c='ILL~Lastmile ARC~17~MBPS~1000',
                                 Amount__c= 2000);
             RateCardList.add(R4);
             RateCard__C R5 = new RateCard__C(Unique__c='ILL~MSR~623~2488',
                                 Amount__c= 4000);
             RateCardList.add(R5);
             RateCard__C R6 = new RateCard__C(Unique__c='DLC~MSR~623~2488',
                                 Amount__c= 4000);
             RateCardList.add(R6);
             RateCard__C R7 = new RateCard__C(Unique__c='NPLC~MSR~623~2488',
                                 Amount__c= 4000);
             RateCardList.add(R7);
             RateCard__C R8 = new RateCard__C(Unique__c='MPLS~Port BW Charges~~MBPS~1000',
                                 Amount__c= 4000, One_To_One_Price__c=9000, Cost_Platinum__c=8000, Cost_Standard__c=7000, Cost_Business__c=80,Cost_Premium__c =700 );
             RateCardList.add(R8);
             RateCard__C R9 = new RateCard__C(Unique__c='ILL~Bandwidth Charges~~MBPS~1000',
                                 Amount__c= 4000);
             RateCardList.add(R9);
             RateCard__C R10 = new RateCard__C(Unique__c='DLC~L2MC~17~MBPS~1000',
                                 Amount__c= 4000);
             RateCardList.add(R10);
             RateCard__C R11 = new RateCard__C(Unique__c='NPLC~L2MC~17~MBPS~1000',
                                 Amount__c= 4000);
             RateCardList.add(R11);
             RateCard__C R12 = new RateCard__C(Unique__c='NPLC~NLD~17~MBPS~1000',
                                 Amount__c= 4000);
             RateCardList.add(R12);
             RateCard__C R13 = new RateCard__C(Unique__c='NPLC~Lastmile ARC~18~MBPS~1000',
                                 Amount__c= 2000);
             RateCardList.add(R13);
             
             Insert RateCardList;
             
             Business_Case__C BC = new Business_Case__C(Opportunity__c = opp1.Id);
             insert BC;
             
             List<FAN_BC__C> FANBCLIST = new LIST<FAN_BC__C>();
             FAN_BC__C FB1= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[0].id);
             FANBCLIST.add(FB1);
             FAN_BC__C FB2= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[1].id);
             FANBCLIST.add(FB2);
             FAN_BC__C FB3= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[2].id);
             FANBCLIST.add(FB3);
             FAN_BC__C FB4= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[3].id);
             FANBCLIST.add(FB4);
             FAN_BC__C FB5= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[4].id);
             FANBCLIST.add(FB5);
             FAN_BC__C FB6= new FAN_BC__C(Business_Case__C = BC.id, Feasibility__c = FeasibilityList[5].id);
             FANBCLIST.add(FB6);
             Database.Insert( FANBCLIST , false);
             
             FanBCTriggerHandler.getBandwidth( 'DS3', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'DS3 - 45 Mbps', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'E1 - 2 Mbps', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'E3 - 34 Mbps', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'Multiple E1s - N * E1s', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'STM 1 - 63 E1s', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'STM 16 - 16 * STM 1', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'STM 4 - 4 * STM 1', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'STM1', 'DLC' , 10);
             FanBCTriggerHandler.getBandwidth( 'STM16', 'DLC' , 10);
            }
    }
}