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
public without sharing class EmpowerTransactionTest {
    static testMethod void TestTransaction()
    {
        List<user> u = TestDataFactory.createUsers();
        //u[0].ManagerId = u[2].Id;
        //update u;
        //System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
             Test.startTest();
            Account testacc = new Account(Name = 'Test Account');
            testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
            testacc.Type = 'Other';        
            testacc.Logo_Segment__c = 'B2B' ;
            testacc.Market_Segment__c = 'SME A - COCP';
            testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc.Sub_Segment__c = 'SME A';
             testacc.NV_Created_in_Empower__c=true;
             testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc;
             
            Account testacc2 = new Account(Name = 'Test Account');
            testacc2.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
            testacc2.Type = 'Other';        
            testacc2.Logo_Segment__c = 'B2B' ;
            testacc2.Market_Segment__c = 'SME A - COCP';
            testacc2.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc2.Sub_Segment__c = 'SME A';
             testacc.NV_Created_in_Empower__c=true;
             testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc2;
             
            Opportunity Opp1 = new Opportunity();
            Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
            Opp1.Name = 'Opty 1';
            Opp1.AccountId = testacc.Id;
            Opp1.CloseDate = System.Today().addMonths(1);
            Opp1.StageName = 'Identified' ;
            Opp1.Win_Reason__c = 'Fresh Requirement' ;
            Opp1.Channel_Type__c = 'Direct' ;
            Opp1.Lead_No__c = 'abc123' ;
            Opp1.Type = 'New';
            Opp1.Block_SOID__c = false;
             Opp1.SOID_Created_in_Empower__c=true;
            //Opp1.Company__c= c1.id;
            Opp1.Lead_Owner_User_Segment__c = 'B2B';
            insert Opp1;
             
             List<EMPOWER_TRANSACTION__c> empList = new List<EMPOWER_TRANSACTION__c>();
             List<EMPOWER_TRANSACTION__c> empListShort = new List<EMPOWER_TRANSACTION__c>();
             EMPOWER_TRANSACTION__c emp1 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'NONVERIFIED', Account__c=testacc.id);
             empList.add(emp1);
             empListShort.add(emp1);
             EMPOWER_TRANSACTION__c emp2 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'LOGO_VERFIFCATION_STATUS', Account__c=testacc.id);
             empList.add(emp2);
             EMPOWER_TRANSACTION__c emp3 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'CREATESOID', Opportunity__c=Opp1.id);
             empList.add(emp3);
             empListShort.add(emp3);
             EMPOWER_TRANSACTION__c emp4 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'NONVERIFIED', Account__c=testacc.id);
             empList.add(emp4);
             EMPOWER_TRANSACTION__c emp5 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'LOGO_VERFIFCATION_STATUS', Account__c=testacc.id);
             empList.add(emp5);
             EMPOWER_TRANSACTION__c emp6 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'CREATESOID', Opportunity__c=Opp1.id);
             empList.add(emp6);
             EMPOWER_TRANSACTION__c emp7 = new EMPOWER_TRANSACTION__c( Empower_Method_Name__c = 'LOGO_VERFIFCATION_STATUS', Account__c=testacc2.id);
			 empList.add(emp7);
             
             insert empList;
             
             for(EMPOWER_TRANSACTION__c em : empList)
             {
                em.Empower_status__c = 'SUCCESS'; 
             }
             update empList;
             update empListShort;
             
             RecursionControl.AccountrunOnce();
             RecursionControl.AccountrunOnce();
             RecursionControl.BQrunOnce();
             RecursionControl.BQrunOnce();
             RecursionControl.FeasibilityrunOnceBefore();
             RecursionControl.FeasibilityrunOnceBefore();
             RecursionControl.FeasibilityrunOnceAfter();
             RecursionControl.FeasibilityrunOnceAfter();
             RecursionControl.AVCVrunOnceBefore();
             RecursionControl.AVCVrunOnceBefore();
             RecursionControl.AVCVrunOnceAfter();
             RecursionControl.AVCVrunOnceAfter();
             RecursionControl.POrunOnceBefore();
             RecursionControl.POrunOnceBefore();
             RecursionControl.POrunOnceAfter();
             RecursionControl.POrunOnceAfter();
             RecursionControl.BCrunOnceAfter();
             RecursionControl.BCrunOnceAfter();
             RecursionControl.FANBCrunOnceBefore();
             RecursionControl.FANBCrunOnceBefore();
                 
              Test.stopTest();
            }
        
    }
    
    public static testMethod void CreateConfig()
    {
        List<Empower_Transaction_Config__c> configList = new List<Empower_Transaction_Config__c>();
       
            Empower_Transaction_Config__c configAcc0 = new Empower_Transaction_Config__c(); 
            configAcc0.Related_Object__c = 'Company__c';
            configAcc0.Empower_Parameters_Config__c = 'NAME:Name^^SFDC_ID:Id^^';
            configAcc0.Business_Unit__c =  'SME ';
            configAcc0.Empower_Method_Name__c =  'NVACCDELETION ';
            configAcc0.Status__c = true;
            configAcc0.Criteria_Fields__c =  null;
            configAcc0.Fixed_Values__c  =  null;
            configList.add( configAcc0 );
            
            Empower_Transaction_Config__c configAcc1 = new Empower_Transaction_Config__c(); 
            configAcc1.Related_Object__c = 'Company__c';
            configAcc1.Empower_Parameters_Config__c = 'NAME:Account__r.Name^^OWNERIDMID:Account__r.Owner.IDM_ID__C^^SEGMENT: ^^UNIQUEID:Account__r.Logo_Id__c^^FLAG: ^^SFDC_ID:Account__r.Id^^MRKTSEGMENT:Account__r.Sub_Segment__c^^SMELOGO:Name^^COMPANY_BACKEND_CODE:Account__r.Id^^PRIMARY_OWNER: ^^OWNER_SALES_CODE:Account__r.Owner.Sales_Code__c^^COMPANY_ID:AutoNumber_Field__c^^LOGO_ID:Account__r.Logo_Id__c^^VERTICAL_SEGMENT:Account__r.Industry^^TCL_SEGMENT:Account__r.TCL_Segment__c^^';
            configAcc1.Business_Unit__c =  'SME ';
            configAcc1.Empower_Method_Name__c =  'NONVERIFIED ';
            configAcc1.Status__c = true;
            configAcc1.Criteria_Fields__c =  'Account__r.Owner.IDM_ID__C,Account__r.Owner.Sales_Code__c, Account__r.Logo_Status__c,Account__r.RecordTypeId,Account__r.NV_Created_in_Empower__c,Account__r.NV_Transaction_Created__c';
            configAcc1.Fixed_Values__c  =  'SEGMENT:SME^^PRIMARY_OWNER:Y^^FLAG: ^^ ';
             configList.add( configAcc1 );
            
            Empower_Transaction_Config__c configAcc2 = new Empower_Transaction_Config__c(); 
            configAcc2.Related_Object__c = 'Company__c';
            configAcc2.Empower_Parameters_Config__c = 'Company_Name:Name^^Company_ID:ID__c^^Logo_Name:Account__r.Name^^Logo_ID:Account__r.Logo_Id__c^^Unique_ID:Account__r.Logo_Id__c^^Company_unique_ID:ID__c^^Segment:Account__r.Sub_Segment__c^^Vertical_Segment:Account__r.Industry^^TCL_Segment:Account__r.TCL_Segment__c^^Owner_IDM_ID:Account__r.Owner.IDM_ID__c^^PAN_Number:Account__r.PAN_No__c^^Address:Account__r.BillingStreet^^City:Account__r.BillingCity^^Pin_Code:Account__r.BillingPostalCode^^RPT_Flag:Account__r.RPT_Flag__c^^GTM_Type:Account__r.GTM_Type__c^^Payment_Terms:Account__r.Payment_Terms__c^^Advance_Arrears:Account__r.Advance_Arrears__c^^Bill_Dispatch_Location: ^^Logo_creation_date: ^^Account_Backend_ID:Account__c^^';
            configAcc2.Business_Unit__c =  'SME ';
            configAcc2.Empower_Method_Name__c =  'LOGO_UPDATE ';
            configAcc2.Status__c = true;
            configAcc2.Criteria_Fields__c =  'Account__r.Logo_Status__c, Account__r.OwnerId,Account__r.CreatedDate ';
            configAcc2.Fixed_Values__c  =  'Bill_Dispatch_Location:Y^^ ';
             configList.add( configAcc2 );
            
            Empower_Transaction_Config__c configAcc3 = new Empower_Transaction_Config__c(); 
            configAcc3.Related_Object__c = 'Company__c';
            configAcc3.Empower_Parameters_Config__c = 'NAME:Name^^NEW_OWNER:Account__r.Owner.IDM_Id__c^^OLD_OWNER:old~Account__r.Owner.IDM_ID__c^^OLDLOGONAME:old~Account__r.Name^^NEWLOGONAME:Account__r.Name^^NEWLOGOID:Account__r.Logo_Id__c^^OLDLOGOID:old~Account__r.Logo_Id__c^^COMPANY_ID:Id__c^^';
            configAcc3.Business_Unit__c =  'SME ';
            configAcc3.Empower_Method_Name__c =  'LOGOCHANGE ';
            configAcc3.Status__c = true;
            configAcc3.Criteria_Fields__c =  'Account__c ';
            configAcc3.Fixed_Values__c  =  null;
             configList.add( configAcc3 );
            
            Empower_Transaction_Config__c configAcc4 = new Empower_Transaction_Config__c(); 
            configAcc4.Related_Object__c = 'OPPORTUNITY';
            configAcc4.Empower_Parameters_Config__c = 'SOID:SOID__c^^UPDATED_BY:Owner.IDM_Id__c^^STATUS:StageName^^EXPECTED_CLOSE_DATE:CloseDate^^QUANTITY:TotalOpportunityQuantity^^REMARKS:Description^^WINNING_PROBABILITY:Probability^^NO_OF_LOCATIONS:No_of_Locations__c^^ORDER_VALUE:Amount^^TCL_FEASBLTY_STATUS:TCL_Feasibility_Flag__c^^OWNERCHANGE_YN: ^^OWNER_ID: ^^SFDC_ID:Id^^';
            configAcc4.Business_Unit__c =  'SME ';
            configAcc4.Empower_Method_Name__c =  'UPDATESOID ';
            configAcc4.Status__c = true;
            configAcc4.Criteria_Fields__c =  'OwnerId, Name,Execute_Create_SOID__c ';
            configAcc4.Fixed_Values__c  =  null;
            configList.add( configAcc4 );
            
            Empower_Transaction_Config__c configAcc5 = new Empower_Transaction_Config__c(); 
            configAcc5.Related_Object__c = 'OPPORTUNITY';
            configAcc5.Empower_Parameters_Config__c = 'SOID:SOID__c^^ACCOUNT_NAME:Account.Name^^COMPANY_ID:Company__r.ID__c^^ACCOUNT_OWNER:Account.Owner.IDM_Id__c^^LOGO_NAME:Account.Name^^LOGO_ID:Account.Logo_Id__c^^UPDATED_BY: ^^FLAG: ^^SFDC_OPPID:Id^^';
            configAcc5.Business_Unit__c =  'SME ';
            configAcc5.Empower_Method_Name__c =  'BLOCKSOID / UNBLOCKSOID ';
            configAcc5.Status__c = true;
            configAcc5.Criteria_Fields__c =  'Block_SOID__c ';
            configAcc5.Fixed_Values__c  =  'UPDATED_BY:SFDC Admin - SOID Block^^ ';
             configList.add( configAcc5 );
            
            Empower_Transaction_Config__c configAcc6 = new Empower_Transaction_Config__c(); 
            configAcc6.Related_Object__c = 'Company__c';
            configAcc6.Empower_Parameters_Config__c = 'Company_Name:Name^^Company_ID:ID__c^^Logo_Name:Account__r.Name^^Logo_ID:Account__r.Logo_Id__c^^Unique_ID:Account__r.Logo_Id__c^^Company_unique_ID:ID__c^^Segment:Account__r.Sub_Segment__c^^Vertical_Segment:Account__r.Industry^^TCL_Segment:Account__r.TCL_Segment__c^^Owner_IDM_ID:Account__r.Owner.IDM_ID__c^^PAN_Number:Account__r.PAN_No__c^^Address:Account__r.BillingStreet^^City:Account__r.BillingCity^^Pin_Code:Account__r.BillingPostalCode^^RPT_Flag:Account__r.RPT_Flag__c^^GTM_Type:Account__r.GTM_Type__c^^Payment_Terms:Account__r.Payment_Terms__c^^Advance_Arrears:Account__r.Advance_Arrears__c^^Bill_Dispatch_Location: ^^Logo_creation_date: ^^Account_Backend_ID:Account__c^^';
            configAcc6.Business_Unit__c =  'SME ';
            configAcc6.Empower_Method_Name__c =  'LOGO_VERFIFCATION_STATUS ';
            configAcc6.Status__c = true;
            configAcc6.Criteria_Fields__c =  'Account__r.Logo_Status__c, Account__r.CreatedDate ';
            configAcc6.Fixed_Values__c  =  'Bill_Dispatch_Location:Y^^ ';
             configList.add( configAcc6 );
            
            Empower_Transaction_Config__c configAcc7 = new Empower_Transaction_Config__c(); 
            configAcc7.Related_Object__c = 'ACCOUNT';
            configAcc7.Empower_Parameters_Config__c = 'NAME:Name^^OLDOWNER:old~Owner.IDM_Id__c^^NEWOWNER:Owner.Idm_Id__c^^SEGMENT:Sub_Segment__c^^SFDC_ID:Name^^OLDLOGONAME:Name^^NEWLOGONAME:Name^^OLDLOGOID:Logo_Id__c^^NEWLOGOID:Logo_Id__c^^PRIMARY_OWNER: ^^OWNER_SALES_CODE:Owner.Sales_Code__c^^';
            configAcc7.Business_Unit__c =  'SME ';
            configAcc7.Empower_Method_Name__c =  'COMPANYTRANSFER ';
            configAcc7.Status__c = true;
            configAcc7.Criteria_Fields__c =  'OwnerId, Logo_Status__c, Id ';
            configAcc7.Fixed_Values__c  =  'PRIMARY_OWNER:Y^^ ';
             configList.add( configAcc7 );
            
            Empower_Transaction_Config__c configAcc8 = new Empower_Transaction_Config__c(); 
            configAcc8.Related_Object__c = 'LEAD';
            configAcc8.Empower_Parameters_Config__c = 'DEL_NO:Owner.Phone^^MSG: ^^SHORTCODE: ^^SYS_NAME: ^^LOC_DESC:Id^^CIRC_DESC: ^^IN_MSG_ID: ^^SRV_TYPE: ^^CREATED_BY: ^^UPDATED_BY: ^^';
            configAcc8.Business_Unit__c =  'SME ';
            configAcc8.Empower_Method_Name__c =  'SENDSMS ';
            configAcc8.Status__c = true;
            configAcc8.Criteria_Fields__c =  'Company,MobilePhone,Account__r.Name,Account__c,Phone,Product_Interest__c ';
            configAcc8.Fixed_Values__c  =  'SYS_NAME:SFDC^^IN_MSG_ID:0^^SRV_TYPE:GSM^^CREATED_BY:TIBCO-SFDC^^UPDATED_BY:TIBCO-SFDC^^ ';
            configList.add( configAcc8 );
            
            Empower_Transaction_Config__c configAcc9 = new Empower_Transaction_Config__c(); 
            configAcc9.Related_Object__c = 'OpportunityLineItem';
            configAcc9.Empower_Parameters_Config__c = 'SOID:Opportunity.SOID__c^^ACCOUNT:Opportunity.Account.Name^^OWNER:Opportunity.Account.Owner.Id^^CLOSE_DATE:Opportunity.CloseDate^^SUPPORT_REQUIRED:Opportunity.Description^^WINNING_PROBABILITY:Opportunity.Probability^^PRODUCT:Product2.Name^^TOTAL_QUANTITY:Opportunity.TotalOpportunityQuantity^^LOCATION:Opportunity.No_of_Locations__c^^ORDER_VALUE:Opportunity.Amount^^VERTICAL_SEGMENT:Opportunity.Account.Industry^^STAGE:Opportunity.StageName^^OPPORITUNITY_TYPE:Opportunity.Type^^PRODUCT_TYPE: ^^ISSTANDARD:Product_Type__c^^BACKHAULBW: ^^SFDC_ID:OpportunityId^^CONTACTNAME: ^^CONTACTNUMBER: ^^COMBO_ID: ^^COMBO_TYPE: ^^COMBO_FLAVOUR: ^^DEALER_CODE:Opportunity.Owner.Sales_Code__c^^IDM_ID:Opportunity.IDM_Id_Integration__c^^CUSTFIRSTNAME: ^^CUSTLASTNAME: ^^CUSTEMAIL: ^^CUSTPHONE: ^^LPMS_ID:Opportunity.Lead_No__c^^Lead_Creation_Date: ^^TMflag:Opportunity.TM_Flag__c^^Company_ID:Opportunity.Company__r.Id__c^^AMR_FLAG: ^^AMR_BACKHAUL_FLAG: ^^ILL_MPLS_SOID: ^^TMflag:Opportunity.TM_Flag__c^^';
            configAcc9.Business_Unit__c =  'SME ';
            configAcc9.Empower_Method_Name__c =  'CREATESOID ';
            configAcc9.Status__c = true;
            configAcc9.Criteria_Fields__c =  'Opportunity.Execute_Create_SOID__c, Opportunity.Channel_Type__c, Opportunity.Account.Channel_Partner_Code__c ';
            configAcc9.Fixed_Values__c  =  'PRODUCT_TYPE:TTL^^BACKHAULBW: ^^COMBO_ID: ^^COMBO_TYPE: ^^COMBO_FLAVOUR: ^^AMR_FLAG: ^^AMR_BACKHAUL_FLAG: ^^ILL_MPLS_SOID: ^^ ';
            configList.add( configAcc9 );
        
        insert configList ;
    }
    
    static testMethod void TestGenerateEmpowerTransactions()
    {
        List<user> u = TestDataFactory.createUsers();
        //u[0].ManagerId = u[2].Id;
        //update u;
        u[0].Phone = '9898989898';
        update u[0];
        //System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
              
             
             CreateConfig();
            Account testacc = new Account(Name = 'Test Account');
            testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
            testacc.Type = 'Other';        
            testacc.Logo_Segment__c = 'B2B' ;
            testacc.Market_Segment__c = 'SME A - COCP';
            testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc.Sub_Segment__c = 'SME A';
            testacc.Logo_Status__c = 'Non-Verified';
             testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc;
             
            Company__C c1 = new Company__C(SSp_Account__c = 'lalala', account__c = testacc.id, default__c=false);
        	insert c1;
             
             RecursionControl.Accountrun=true;
             testacc.Logo_Status__c = 'Verified' ;
             update testacc ;
             
             RecursionControl.Accountrun=true;
             testacc.Name = 'Changed Name';
             update testacc;   
             
             RecursionControl.Accountrun=true;
            Account testacc2 = new Account(Name = 'Test Account');
            testacc2.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId() ;
            testacc2.Type = 'Other';        
            testacc2.Logo_Segment__c = 'B2B' ;
            testacc2.Market_Segment__c = 'SME A - COCP';
            testacc2.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc2.Sub_Segment__c = 'SME A';
            testacc2.Logo_Status__c = 'Non-Verified';
             testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc2;
             
            RecursionControl.Accountrun=true;
             testacc.OwnerId = u[1].id ;
             update testacc;
           
              test.startTest();
             
             RecursionControl.Accountrun=true;
             testacc.Sub_Segment__c = 'TC';
             update testacc; 
             
             RecursionControl.Accountrun=true;
             testacc.Industry = 'Education' ;
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.TCL_Segment__c = 'Enterprise - MES';
             testacc.TCL_Status__c = 'Verified';
             testacc.TCL_Account_Id__c ='xyz';
             testacc.TCL_Account_Name__c = 'xyz';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.PAN_No__c = 'AGVFD3456T';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.BillingStreet = 'abc';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.BillingCity = 'New Delhi';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.BillingPostalCode = '1100101';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.RPT_Flag__c = true;
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.GTM_Type__c = 'Carrier' ;
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.Payment_Terms__c = 'Monthly';
             update testacc;  
             
             RecursionControl.Accountrun=true;
             testacc.Advance_Arrears__c = 'Advance';
             update testacc;  
             
             			
            Lead y = new lead();
            y.Lead_Type__c = 'New';
            y.Region__c='North';
            y.Circle__c='Delhi';
            y.Status = 'New';
            y.email = 'abc2' +'@lead.com';
            y.MobilePhone = '9878986752';
            y.lastname = 'Lead from Dev 2';
            y.company = 'abcsjdghdjsfhfgdfj';
            //l.Convert_Lead__c = true;
            insert y;
             
             Lead l = new lead();
            l.Lead_Type__c = 'Sharing Request';
            l.Region__c='North';
            l.Circle__c='Delhi';
            l.Status = 'New';
            l.email = 'abc1' +'@lead.com';
            l.MobilePhone = '9978986751';
            l.lastname = 'Lead from Dev 1';
            l.company = 'abcsjsdfh';
            l.account__c = testacc.id;
            //l.Convert_Lead__c = true;
            insert l;
             
             c1.Account__c = testacc2.id;             
             update c1;
              
             delete c1;
           
			 test.stopTest();
             
            }
    }
    
    static testMethod void TestGenerateEmpowerTransactionsOpp()
    {
        List<user> u = TestDataFactory.createUsers();
        //u[0].ManagerId = u[2].Id;
        //update u;
        u[0].Phone = '9898989898';
        update u[0];
        //System.Debug('Manager : '+ u[0].ManagerId);
        System.runAs(u[0])
            {System.debug('Current User: ' + UserInfo.getUserName());
             test.startTest();
             CreateConfig();
             
             Account testacc = new Account(Name = 'Test Account');
            testacc.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Non-Verified Logo').getRecordTypeId() ;
            testacc.Type = 'Other';        
            testacc.Logo_Segment__c = 'B2B' ;
            testacc.Market_Segment__c = 'SME A - COCP';
            testacc.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc.Sub_Segment__c = 'SME A';
            testacc.Logo_Status__c = 'Non-Verified';
             testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc;
             
             RecursionControl.Accountrun=true;
             Account testacc2 = new Account(Name = 'Test Account');
            testacc2.RecordTypeID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId() ;
            testacc2.Type = 'Other';        
            testacc2.Logo_Segment__c = 'B2B' ;
            testacc2.Market_Segment__c = 'SME A - COCP';
            testacc2.Account_Category__c = 'Small and Medium Enterprises - SMEA';
            testacc2.Sub_Segment__c = 'SME A';
            testacc2.Logo_Status__c = 'Non-Verified';
             testacc.NV_Created_in_Empower__c=true;
        testacc.Verified_Acc_Created_in_Empower__c =true;
            insert testacc2;
             
             Contact c = new Contact();
            c.LastName = 'Random Contact';
            c.AccountId = testacc2.id ;
            c.Role__c = 'IT' ;
            c.Business_Function__c = 'Finance';
            c.Email = 'contact@random.com' ;
            c.MobilePhone = '9899075612' ;
            insert c;
             
            Opportunity Opp1 = new Opportunity();
            Opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TTL New Opportunity').getRecordTypeId() ;
            Opp1.Name = 'Opty 1';
            Opp1.AccountId = testacc.Id;
            Opp1.CloseDate = System.Today().addMonths(1);
            Opp1.StageName = 'Identified' ;
            Opp1.Win_Reason__c = 'Fresh Requirement' ;
             Opp1.SOID_Created_in_Empower__c=true;
            Opp1.Channel_Type__c = 'Direct' ;
            Opp1.Lead_No__c = 'abc123' ;
            Opp1.Channel_Type__c ='Channel';
            Opp1.Channel_Partner__c = testacc2.Id;
            Opp1.FOS__c = c.Id;
            Opp1.Type = 'New';
            Opp1.Block_SOID__c = false;
            //Opp1.Company__c= c1.id;
            Opp1.Lead_Owner_User_Segment__c = 'B2B';
            insert Opp1;
             
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
              
             opp1.No_of_Locations__c = 10;
             update opp1;
             
             opp1.ownerId = u[1].Id;
             update opp1;
             
             
             opp1.Block_SOID__c = true;
             update opp1;
               
             opp1.Block_SOID__c = false;
             update opp1;
             
             test.stopTest();
            }
    }
    
    
}