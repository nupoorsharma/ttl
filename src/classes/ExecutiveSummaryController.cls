/*
    * Name: ExecutiveSummaryController Class
    * Created On: December 11, 2015
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Extension for Visualforce Page "Executive Summary" (called from "Executive Summary" button on Account).             
    * Change Log History:
    * |------------------------------------------------------------|
    * | Version | Changes By | Date     | Description              |
    * |------------------------------------------------------------|
    * |   0.1   | Nupoor     | 24-11-15 |Initial version of Class  |
    * |------------------------------------------------------------|
*/
public without sharing class ExecutiveSummaryController {

    //The account record which calls the visualforce page.
    public Account acc{get;set;}
    //Contains the Monthwise total and Grand total of all Billing_Account_Status__c records associated to this account in the last 12 Months.
    public Map<String, String> MapBillingFY { get; set; }
    //Contains the last 12 months in ascending order, in the format MonthName-Year 
    public LIST<String> MonthList {get;set;}
    //Contains all Open Opportunities associated to this account.
    public List<OpportunityLineItem> OpenOpty {get;set;}
    //Contains the Monthwise Toatl and Grand Total of all SME_OrderValueBackUpdation__c records associated to this account in the last 12 Months.
    public Map<String, String> MapOrder { get; set; }
    //Contains all Products associated to this account via Telecom_Spend__c records.
    public List<String> ProductList {get;set;}
    //Contains all Operators associated to this account via Telecom_Spend__c records.
    public List<String> OperatorList {get;set;}
    //Contains a ProductName as the Key and the Corresponding list of Total Annual_Spend__c for each Operator as the value.
    public Map<String , List<String>> TelecomMap{get;set;}
    //Total Annual_Spend__c corresponding to each operator (in lacs)
    public List<Double> OperatorWiseTotal {get;set;}
    //Percentage of Total Annual_Spend__c corresponding to each Operator
    public List<Decimal> OperatorWiseTotalPercentage {get;set;}  
    //The contacts with a role Chief Financial Officer/Managing Director/Chief Executive Officer associated to this account, not added as a Primary/Director contact.
    public List<Contact> ContactRole {get;set;}
    //Contains the Month(eg. APR) as key and MonthName-Year (eg. APR-16) as value.
    public Map<String,String> MonthMap {get;set;}
    //Controls the rendering of Telecom Spent Table.
    public boolean TeleBool {get;set;}
    public Double GrandTelecomTotal {get;set;}
    public Map<String , String> TTLPercentage{get;set;}
    public String EmpRange{get;set;}
    public string TurnoverRange{get;set;}

    public ExecutiveSummaryController(ApexPages.StandardController controller) {
    
    acc= (Account)controller.getRecord(); 
    //Initialize MonthList and MonthMap
      InitializeMonthList();

    //Initialize MapBillingFY 
      InitializeMAp();

    //Calculate Billing for last 12 Months      
      calcBillingFY();
          
    //Get all Open Opportunities
      calcOpenOpty();
          
    //Calculate Orders for last 12 Months 
      calcMapOrder();
          
    //Calculate Telecom Spent Matrix
      calcTelecomSpent();
         
    //Get all Contacts for this account.
      calcContactRole();
      
    //Calculate EmpRange and TurnoverRange for this Account
      calcEmpRangeAndTurnoverRange();
    
    }
    
    /*
     *Calculates the Monthwise total and Grand Total on Billing_Account_status__c for the last 12 Months.
     */
    public void calcBillingFY()
    {

    Double total=0.0;
    //Get the Monthwise total Amount__c on Billing_Date__c associated to this account for the last 12 months.
    List<AggregateResult> x= new List<AggregateResult>([Select CALENDAR_MONTH(Billing_Date__c) CloseMonth, SUM(Amount__c) TotalAmount from Billing_Account_Status__c
                                                    where Account__C= :acc.id and Billing_Date__c= LAST_N_MONTHS:12
                                                    Group By CALENDAR_MONTH(Billing_Date__c)]);
    System.Debug('Monthwise Total :: '+ x);

    //Populate the Map with month [in the format (APR-16)] as key and total for that month as value.
    for(AggregateResult i :x)
        { if( MapBillingFY.get( MonthMap.get(getMonth( Integer.ValueOf(i.get('CloseMonth')) ))) != null )
         { MapBillingFY.put( MonthMap.get(getMonth( Integer.ValueOf(i.get('CloseMonth')) ) ) , sTRING.vALUEoF(Double.ValueOf(i.get('TotalAmount'))/100000) );
          total+=Double.ValueOf(i.get('TotalAmount'))/100000;
         }
         }
        //Populate total of all months for the key "Total"
         MapBillingFY.put('TOTAL',String.ValueOf(total) );
        
    System.debug('MapBillingFY :: '+ MapBillingFY);
    
    

    }
    
    /*
     * Returns the First three letters in Month for its integer value.
     */
    public String getMonth(Integer m)
    {
      String monthString;
      
      if(m == 1)
       monthString = 'JAN'; 
      else  if(m == 2)
       monthString = 'FEB';
      else  if(m == 3)
       monthString = 'MAR';
      else if(m == 4) 
       monthString = 'APR';
      else if(m == 5) 
        monthString = 'MAY';
      else if(m == 6)
        monthString = 'JUN';
      else if(m == 7)
         monthString = 'JUL';
      else if(m == 8)
          monthString = 'AUG';
      else if(m == 9) 
          monthString = 'SEP';
      else if(m == 10) 
         monthString = 'OCT';
      else if(m == 11) 
          monthString = 'NOV';
      else if(m == 12) 
          monthString = 'DEC';
       else 
           monthString = 'Invalid month';
             
        return monthString;
    }
    
    /*
     *Calculates the Month list in ascending order in the format APR-16
     *Also populates the MonthMap
     */
    public void InitializeMonthList()
    {
       MonthList =new LIST<String>();
       MonthMap= new Map<String,String>();
       Date d;
       if( !Date.isLeapYear( System.Today().year() ) )
       d = System.Today()-365;
       else
       d = System.Today()-366;
        for(integer i=0;i<12;i++)
        {
            System.Debug(d.Addmonths(i));
            Date d1=d.AddMonths(i);
            String mnth= getMonth(d1.Month()) + '-' + String.ValueOf(d1.year()).substring(2);
            System.Debug('Month in MonthList() :' + mnth);
            MonthList.add(mnth);
            MonthMap.put( getMonth(d1.Month()) , mnth);
        } 
         MonthList.add('TOTAL');   
         System.Debug(MonthMap);
    }
    
    /*
     *Sets the keys for MapBillingFY and MapOrder Map
     */
    public void InitializeMAp()
    {
       MapBillingFY  = new Map<String,String>();
       for (String key : MonthMap.keySet()) {
        MapBillingFY.put( MonthMap.get(key) , ' ');  
    }
    MapBillingFY.put('TOTAL', ' ');
    
    MapOrder = new Map<String,String>();
   for (String key : MonthMap.keySet()) {
        MapOrder.put( MonthMap.get(key) , ' ');  
    }
    MapBillingFY.put('TOTAL', ' ');
    }
    
    /*
     *Gets all Open Opportunities associated to this account.
     */
     public void calcOpenOpty()
    {
        //Populate the details of OpportunityLineItems for these Open Opportunities.
        OpenOpty = new List<OpportunityLineItem>([Select Id, Opportunity.AccountId, OpportunityId, 
                                                 Opportunity.StageName, Product2.Name , Opportunity.NAme, Opportunity.Type, 
                                                  Opportunity.CloseDate, Opportunity.SOID__c, Opportunity.Amount, Quantity 
                                                  from OpportunityLineItem 
                                                  where Opportunity.AccountId = :acc.id 
                                                  and ( Opportunity.StageName='Identified'  or  Opportunity.StageName='Qualified' 
                                                       or  Opportunity.StageName='Short-listed' or  Opportunity.StageName= 'Verbal Agreement') ]) ;                                            
   
    if(OpenOpty.size()==0)
    {System.Debug('OpenOptySize is Zero');
    }
    

    }
    
    /*
     *Calculates the Monthwise total and Grand Total on SME_OrderValueBackUpdation__c for the last 12 Months.
     */
     public void calcMapOrder()
    {
       
        Double total=0.0;
        //Get the Monthwise total Order_Value_MRC__c on SME_OrderValueBackUpdation__c associated to this account, for the last 12 months.
        List<AggregateResult> x= new List<AggregateResult>([Select CALENDAR_MONTH(Del_Activation_date__c) ActivationMonth, SUM(Order_Value_MRC__c) TotalAmount from SME_OrderValueBackUpdation__c
                                                        where Account__c= :acc.id and Del_Activation_date__c = LAST_N_MONTHS:12
                                                        Group By CALENDAR_MONTH(Del_Activation_date__c)]);
        System.Debug('Monthwise Total :: '+ x);
    
        
        for(AggregateResult i :x)
            { if( MapOrder.get( MonthMAp.Get(getMonth( Integer.ValueOf(i.get('ActivationMonth')) )) ) != null )
                { MapOrder.put( MonthMAp.Get(getMonth( Integer.ValueOf(i.get('ActivationMonth')) )) , sTRING.vALUEoF(Double.ValueOf(i.get('TotalAmount'))/100000) );
                  total+=Double.ValueOf(i.get('TotalAmount'))/100000;
                }
             }
         //Populate total of all months for the key "Total"
             MapOrder.put('TOTAL',String.ValueOf(total) );
            
        System.debug('MapOrder:: '+ MapOrder);
        

    }
    
    /*
     *Calculates the Telecom Spent Martrix
     */
    public void calcTelecomSpent()
    {
       Set<String> ProductSet = new Set<String>();
       Set<String> OperatorSet = new Set<String>();
      //Initialize the Map to store Product-wise Percentage of Contribution by TTL 
        TTLPercentage = new Map<String , String>();
       
      //Get the total Annual_Spend__c for each Product/Operator combination
      List<AggregateResult> AggList = new List<AggregateResult>( [ Select Product__r.NAme, Operator__c, Sum(Annual_Spend__c) TotalAmount
                                                                    from Telecom_Spend__c 
                                                                    where Logo__c = :acc.id
                                                                    group by Product__r.NAme , Operator__c
                                                                    order by Sum(Annual_Spend__c) DESC] ) ;

    //This query will decide which products are grouped as 'Others'
     List<AggregateResult> OpTotal = new List<AggregateResult>([Select Operator__c, Sum(Annual_Spend__c) TotalAmount
                                                                    from Telecom_Spend__c 
                                                                    where Logo__c = :acc.id
                                                                    group by Operator__c
                                                                    order by Sum(Annual_Spend__c) DESC]) ;
        for(AggregateResult ag : AggList)
        { ProductSet.add(String.ValueOf(Ag.get('NAme' ))); 
        }
        for(AggregateResult op : OpTotal)
        {
            if(OperatorSet.size()<4)
                OperatorSet.add(String.ValueOf(op.get('Operator__c')));
            else
                OperatorSet.add('Others');
        }
      //Changes End Here
       //Render the Telecom Spent Matrix if TeleBool is true
       if( ProductSet.size() == 0 || OperatorSet.Size()== 0)
        TeleBool =false;
        else
        TeleBool =true;

       ProductList = new List<String>(ProductSet);
       OperatorList = new List<String>(OperatorSet);
       OperatorList.add('Total');
       //Stores Operator name as key and Index for operator as value.
       Map<String, Integer> OpMap = new Map< String, Integer>();
       
       integer index=0;
       for(String s : OperatorList)
         {//Populate Operator Name as Key and its index in the List as the value.
           OpMap.put(s,index);
           index++;
         }
      
      //Collects list of Operatorwise total Annual_Spend__c for each Product.
      TelecomMap = new Map<String , List<String> >();
      Integer i = OperatorList.size();
        
       for( String s : ProductList )
       {   
           Double PrTotal = 0.0;
           Double TotalOther = 0.0;
           Double TTLVal = 0.0 ;
           Double TTLPer = 0.0 ;
        //Initialize the Operator List Mapped to Product Name.
       List<String> Values = new List<String>();
       for(integer j=0;j<i;j++)
          Values.add('');
          
          for( AggregateResult AG : AggList )
          {  if( String.ValueOf(Ag.get('NAme' )) == s ) 
              {  System.Debug('Product' + s + 'Value:: '+ prTotal);
                  prTotal += Double.ValueOf(AG.get( 'TotalAmount' )) / 100000;
               
               if( OperatorSet.contains(String.ValueOf(Ag.get('Operator__c' )) ))
                 Values[ OpMap.get(String.ValueOf(Ag.get('Operator__c' ))) ] = String.ValueOf( Double.ValueOf(AG.get( 'TotalAmount' )) / 100000 ) ;
               else
                   //Add value to the 'Others' column.
                 TotalOther += Double.ValueOf(AG.get( 'TotalAmount' )) / 100000  ;
               
               //Store the value for TTL irrespective of it being present in the OperatorList
               if( String.ValueOf(Ag.get('Operator__c' )) == 'TTL')
                   TTLVal = Double.ValueOf(AG.get( 'TotalAmount' )) / 100000 ;
              }
          }
           //Store Value for TTL and Productwise Total in the Map.
          if(prTotal > 0)
            TTLper =  Decimal.ValueOf(((TTLVal*100) / prTotal)).setScale(2) ;
          TTLPercentage.put(s, String.ValueOf(TTLper) );
           Values[ OpMap.get('Total') ] = String.ValueOf( prTotal );
           if(TotalOther > 0)
           Values[ OpMap.get('Others') ] = String.ValueOf( TotalOther ) ;
           //Populate the Product name as key and Total Annual_Spend__c List as value.
          TelecomMap.put( s, Values);
          }
          
          Double BigTotal = 0.0;
          //OperatorWiseTotal calculates the column wise total based on Operators in Telecom Spent Matrix.
          OperatorWiseTotal = new List<Double>();
          for(String operator : OperatorList)
          { if(operator != 'Total')
              {Double total=0.0;
                for(String product : ProductList )
                {
                  if( TelecomMap.get(product)[OpMap.get(operator)] != '')
                    total += Double.VAlueOf( TelecomMap.get(product)[OpMap.get(operator)] );
                   
                }
                OperatorWiseTotal.add(total);
                 BigTotal += total;
              }
          }
       
        //BigTotal is the Grand Total of Operator wise Total.
          System.Debug('BigTotal' + BigTotal );
        GrandTelecomTotal = BigTotal ;
          OperatorWiseTotalPercentage = new List<Double>();
          for(Double d : OperatorWiseTotal)
            OperatorWiseTotalPercentage.add( Decimal.ValueOf(((d*100) / BigTotal)).setScale(2) );
         
       
       
    }
    
    /*
     *Gets all Contacts associated to this account with the role Chief Financial Officer','Managing Director','Chief Executive Officer'
     *Filters out the contacts populated on Account fields- Primary_Contact__c and Director__c
     */
    public void calcContactRole()
    {ContactRole= new List<Contact>();
     List<Contact> ContactAll= new List<Contact>([Select Name, Role__c, Email, MobilePhone, AccountId 
                                     from Contact 
                                     where AccountId= :acc.id 
                                     and role__c in ('Chief Financial Officer','Managing Director','Chief Executive Officer' ) ]);
     for(Contact c: ContactAll)
     if(c.id != Acc.Primary_Contact__c && c.id != Acc.Director__C)
       ContactRole.add(c);                               
   
                                          
    }
   
    
     /*
     *Calculate Number of Employee Range and Turnover Range 
     */
    public void calcEmpRangeAndTurnoverRange()
    {   
        Account extendedAcc = [Select Id, NumberOfEmployees, AnnualRevenue from account where id = :acc.id];
    //Range for NumberOfEmployees
    //Employee Base need to be given in Range rather than absolute no (Range Can be : 0 -100,100-500,500-5000,5000+)
    if( extendedAcc.NumberOfEmployees == null )
        EmpRange = ' ';
    else if(extendedAcc.NumberOfEmployees < 101)
        EmpRange = '0 - 100';
    else if(extendedAcc.NumberOfEmployees >= 101 && extendedAcc.NumberOfEmployees < 501)
        EmpRange = '100 - 500' ;
    else if (extendedAcc.NumberOfEmployees >= 501 && extendedAcc.NumberOfEmployees < 5001)
        EmpRange = '500 - 5000' ;
    else if(extendedAcc.NumberOfEmployees >= 5001)
        EmpRange = '5000+' ;
        
    //Range for Annual Revenue
    //Turnover need to be given in Range rather than absolute no (Range Can be : 0 -10,10-100,100-500,500+ In crs)
    Double x = ( extendedAcc.AnnualRevenue != null) ? (extendedAcc.AnnualRevenue / 10000000) : null;
    if( extendedAcc.AnnualRevenue == null)
        TurnoverRange = ' ' ;
    else if( x <11  &&  extendedAcc.AnnualRevenue != null)
        TurnoverRange = '0 - 10' ;
    else if( x >=11 && x<101 && extendedAcc.AnnualRevenue != null)
        TurnoverRange = '10 - 100' ;
    else if( x >=101  &&  x<501 && extendedAcc.AnnualRevenue != null)
        TurnoverRange = '100 - 500' ;
    else if(x >=501 && extendedAcc.AnnualRevenue != null)
        TurnoverRange = '500+';           
    }
    
}