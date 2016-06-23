/*
 * Name        : FabBCTriggerHandler
 * Description : This class auto populate Rate Card Fields on FanBC record.
 *                => Before Insert
 *                => Before Update if Recalculate_Rate_Card_Values__c is Changed to TRUE.
 * Author      : Nupoor Sharma (Compro Technologies)
 * Created On  : 29 May 2016
 */
public without sharing class FanBCTriggerHandler {
    
    //RateCard Keys Populated for each FAn_BC__c record where Ratecards are applicable.
    public class RateCardKeys
    {
        public String LastMile{get;set;}
        public String L2MC{get;set;}
        public String MSR{get;set;}
        public String BandwidthCharges{get;set;}
        public String NLD{get;set;}
        public String LastMileB{get;set;}
        public String MSRB{get;set;}
        public RateCardKeys()
        {
         LastMile=null;
         L2MC=null;
         MSR=null; 
         BandwidthCharges=null;
         NLD=null;
         LastMileB=null;
         MSRB=null;
        }
    }
    
    /*
     * getBandwidth()
     * Purpose: Returns a Clean Bandwidth Value for DLC and NPLC
     */
    public static String getBandwidth( String Bandwidth, String ProductName , Integer valueOfn)
    {
        //This bandwidth Value will be returned from this method.
        String returnVal = null;
        if( ProductName == 'DLC' || ProductName == 'NPLC')
        {
            if(Bandwidth == 'DS3') 
                returnVal = '45 Mbps' ;
       		else if(Bandwidth == 'DS3 - 45 Mbps')
                returnVal = '45 Mbps' ;
            else if(Bandwidth == 'E1 - 2 Mbps')
                returnVal = '2 Mbps' ;
            else if(Bandwidth == 'E3 - 34 Mbps')
                returnVal = '34 Mbps' ;
            else if(Bandwidth == 'Multiple E1s - N * E1s')
                returnVal = String.ValueOf( 2 * valueOfn) + ' Mbps' ;
            else if(Bandwidth == 'STM 1 - 63 E1s')
                returnVal = '155 Mbps' ;
            else if(Bandwidth == 'STM 16 - 16 * STM 1')
                returnVal = '2480 Mbps' ;
            else if(Bandwidth == 'STM 4 - 4 * STM 1')
                returnVal = '620 Mbps' ;
            else if(Bandwidth == 'STM1')
                returnVal = '155 Mbps' ;
            else if(Bandwidth == 'STM16')
                returnVal = '2480 Mbps' ;
            else
               returnVal =  Bandwidth ;
       }
        return returnVal;
    }


    /*
     * populateRateCardFields()
     * Purpose: Populates the values on Rate Card Fields For NPLC/DLC/ILL/MPLS
     */
    public static void populateRateCardFields(List<Fan_BC__c> newList, Map<Id, FAN_BC__c> mapOld, Boolean IsInsert, Boolean IsUpdate)
    {
        System.Debug('FanBCTriggerHandler-------------------------populateRateCardFields()');
        //Collect the Feasibility__C IDs to query all records.
        List<ID> ParentFeasibilityList = new List<ID>();
        for(FAN_BC__c fanbc : newList)
         if((isInsert==true) || ( (isUpdate==true) && (fanbc.Recalculate_Rate_Card_Values__c == true) && (mapOld.get(fanbc.id).Recalculate_Rate_Card_Values__c == false) ))
              if(String.IsNotBlank(fanbc.Feasibility__c))
                   ParentFeasibilityList.add(fanbc.Feasibility__c);
        
        if(ParentFeasibilityList.size()>0)
        {
         System.Debug(LoggingLevel.FINE,'Rate Card Calculation ############ LOGIC IS TURNED ON !!') ;   
        //Get the details from Parent Feasibility records on FAN BC records.
        MAP<Id,Feasibility__c> Feasibility_Map = new Map<Id,Feasibility__c>([Select Id, Product__r.BC_Category__c, L2MC_Type__c, Flavor__c, Product_Variant__C,
                                                                          Internet_Bandwidth_Ratio__c,Nimble_Type__c,Class_Of_Service_Variant__c, Enter_value_of_N__c,
                                                                          Enter_value_of_N_B__c, Enter_value_of_N_A__c,
                                                                          Feasibility_Status__r.Chargeable_Distance__c,Feasibility_Status__r.Chargeable_Distance_B__c, 
                                                                          Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c, Class_Of_Service_Type__c,
                                                                          Bandwidth_Required__c, Bandwidth_Required_At_A__c, Bandwidth_A__c, MPLS_Bandwidth__c,
                                                                          Bandwidth_Required_at_B__c, Bandwidth_B__c, Last_Mile_Bandwidth_Required__c, ILL_Bandwidth__c,
                                                                          Feasibility_Status__r.NLD_Distance__c, Feasibility_Status__C
                                                                          from Feasibility__c where ID IN :ParentFeasibilityList]);
        
        //The List to fill in the Gross Values after Rate Cards have been queried.
        List<Fan_BC__c> ReFill_These = new List<FAN_BC__c>();
        
        //For each FAN BC record in ReFill_These List, a RAteCArdKeys Object is mapped to its Id.
        //All the Rate Card Related Keys are found in this object.
        Map<Id, RateCardKeys> RAteCard_Keyset = new MAP<Id, RateCardKeys>();
        
        //The set of Unique Keys to query Rate Cards.
        Set<String> setOfExtID = new Set<String>();
       
        for(Fan_BC__c newoBJ: newList)
        {
            Feasibility__c FAN = Feasibility_Map.get(newobj.Feasibility__c);
            if( String.IsNotBlank(newobj.Feasibility__c) && FAN !=null && String.IsNotBlank(FAN.Product__c) )
            {
                /**********************************   DLC   ***********************************************/
                if( FAN.Product__r.Bc_category__c == 'DLC' && String.IsNotBlank(FAN.Bandwidth_Required__c) && (FAN.Bandwidth_Required__c != 'Other') )
                {
                        System.Debug('Rate Card Applicable for : DLC');
                        /* Get the Keys the following Rate Cards
                         *  LastMile ARC
                         *  MSR
                         *  L2MC
                         */
                       ReFill_These.add(newoBJ);
                       RateCardKeys R = new RateCardKeys();
                       String bandwidthVal = FanBCTriggerHandler.getBandwidth( FAN.Bandwidth_Required__c, 'DLC' , Integer.ValueOf(FAN.Enter_value_of_N__c) );
                       String unit = bandwidthVal.substringAfter(' ').toUpperCase();
                        String bandwidth = bandwidthVal.substringBefore(' ');
                        System.debug(LoggingLevel.FINE,'DLC bandwidth: ['+bandwidth + '] unit : ['+unit+']');
                        if(String.IsNotBlank(FAN.Feasibility_Status__C) )
                        {
                            //For Last Mile ARC DLC~Lastmile ARC~17~KBPS~512
                            if( FAN.Feasibility_Status__r.Chargeable_Distance__c != null  )
                            {Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance__c) : 501 );
                             distance = ( distance<5 ? 5 : distance ) ; 
                             R.LastMile = 'DLC~Lastmile ARC~'+distance+'~'+unit+'~'+bandwidth;
                             setOfExtID.add(R.LastMile);
                            }
                            //For L2MC DLC~L2MC~17~KBPS~512
                            if(FAN.Flavor__c == 'L2MC' && (FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c != null))
                            {   Integer l2mcdistance = ( FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c) : 501);
                                l2mcdistance = ( l2mcdistance<5 ? 5 : l2mcdistance ) ;
                                R.L2MC = 'DLC~L2MC~'+l2mcdistance+'~'+unit+'~'+bandwidth ;
                                setOfExtID.add(R.L2MC);
                            }
                         }
                            // For MSR
                            Integer msrbandwidth = ((unit=='KBPS')? (Integer.ValueOf(bandwidth)/1024) : Integer.ValueOf(bandwidth));
                            if( msrbandwidth <= 156 )
                                R.MSR='DLC~MSR~0~156';
                            else if(msrbandwidth <=622)
                                R.MSR='DLC~MSR~157~622'; 
                            else if(msrbandwidth <=2488)
                                R.MSR = 'DLC~MSR~623~2488';
                            setOfExtID.add(R.MSR); 
                        RAteCard_Keyset.put(newObj.Id, R);
                }
                /**********************************   ILL   ***********************************************/
                else if( FAN.Product__r.Bc_category__c == 'ILL' && String.IsNotBlank(FAN.ILL_Bandwidth__c) )
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Applicable for : ILL');
                     /* Get the Keys the following Rate Cards
                         *  LastMile ARC - (ILL~Lastmile ARC~11~MBPS~12)
                         *  MSR - (ILL~MSR~0~156)
                         *  Bandwidth Charges - (ILL~Bandwidth Charges~~MBPS~10)
                         */
                       ReFill_These.add(newoBJ);
                       RateCardKeys R = new RateCardKeys();
                       //Use ILL Bandwidth for ALL Rate Card
                       String ILLunit = FAN.ILL_Bandwidth__c.substringAfter(' ').toUpperCase();
                       String ILLbandwidth = FAN.ILL_Bandwidth__c.substringBefore(' ');
                       System.debug(LoggingLevel.FINE,'ILL bandwidth: ['+ILLbandwidth + '] unit : ['+ILLunit+']');
                       //For Bandwidth Charges ILL~Bandwidth Charges~~MBPS~10
                       R.BandwidthCharges = 'ILL~Bandwidth Charges~~'+ ILLunit+'~'+ILLbandwidth;
                        setOfExtID.add(R.BandwidthCharges);
                       if(String.IsNotBlank(FAN.Feasibility_Status__C) && (FAN.Feasibility_Status__r.Chargeable_Distance__c != null) )
                       {
                            //For Last Mile ARC ILL~Lastmile ARC~11~MBPS~12
                            Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance__c) : 501 );
                            distance = ( distance < 5 ? 5 : distance ) ;
                             R.LastMile = 'ILL~Lastmile ARC~'+distance+'~'+ILLunit+'~'+ILLbandwidth;
                             setOfExtID.add(R.LastMile);
                        }
                   			 // For MSR
                            Integer msrbandwidth = ((ILLunit=='KBPS')? (Integer.ValueOf(ILLbandwidth)/1024) : Integer.ValueOf(ILLbandwidth));
                            if( msrbandwidth <= 156 )
                                R.MSR='ILL~MSR~0~156';
                            else if(msrbandwidth <=622)
                                R.MSR='ILL~MSR~157~622'; 
                            else if(msrbandwidth <=2488)
                                R.MSR = 'ILL~MSR~623~2488';
                            setOfExtID.add(R.MSR); 
                    RAteCard_Keyset.put(newObj.Id, R);
                    
                }
                /**********************************   MPLS   ***********************************************/
                else if( FAN.Product__r.Bc_category__c == 'MPLS'  && String.IsNotBlank(FAN.MPLS_Bandwidth__c))
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Applicable for : MPLS');
                    /* Get the Keys the following Rate Cards
                         *  LastMile ARC - (MPLS~Lastmile ARC~17~MBPS~1000)
                         *  Port BW Charges - (MPLS~Port BW Charges~~MBPS~1000)
                         */
                    ReFill_These.add(newoBJ);
                    RateCardKeys R = new RateCardKeys();
                    //Use MPLS Bandwidth for ALL Rate Card
                    String MPLSunit = FAN.MPLS_Bandwidth__c.substringAfter(' ').toUpperCase();
                    Long MPLSbandwidth = Decimal.ValueOF(FAN.MPLS_Bandwidth__c.substringBefore(' ')).round(System.RoundingMode.CEILING);
                    System.debug(LoggingLevel.FINE,'MPLS bandwidth: ['+MPLSbandwidth + '] unit : ['+MPLSunit+']');
                       //For Bandwidth Charges ILL~Bandwidth Charges~~MBPS~10
                       R.BandwidthCharges = 'MPLS~Port BW Charges~~'+ MPLSunit+'~'+MPLSbandwidth;
                        setOfExtID.add(R.BandwidthCharges);
                     if(String.IsNotBlank(FAN.Feasibility_Status__C) && (FAN.Feasibility_Status__r.Chargeable_Distance__c != null) )
                     {
                            //For Last Mile ARC ILL~Lastmile ARC~11~MBPS~12
                            Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance__c) : 501 );
                            distance = ( distance < 5 ? 5 : distance);
                            R.LastMile = 'MPLS~Lastmile ARC~'+distance+'~'+MPLSunit+'~'+MPLSbandwidth;
                             setOfExtID.add(R.LastMile);
                      }   
                    RAteCard_Keyset.put(newObj.Id, R); 
                }
                /**********************************   NPLC   ***********************************************/
                else if( FAN.Product__r.Bc_category__c == 'NPLC')
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Applicable for : NPLC');
                    /* Get the Keys the following Rate Cards
                         *  LastMile ARC - Point A and B
                         *  MSR - Point A and B
                         *  NLD
                         *  L2MC
                         */
                     ReFill_These.add(newoBJ);
                     RateCardKeys R = new RateCardKeys();
                    //For Premium NPLC
                    if(String.IsBlank(FAN.Bandwidth_Required_at_B__c ) && String.IsNotBlank(FAN.Bandwidth_Required__c)) 
                    {
                       String bandwidthVal = FanBCTriggerHandler.getBandwidth( FAN.Bandwidth_Required__c, 'NPLC' , Integer.ValueOf(FAN.Enter_value_of_N__c) );
                       String unit = bandwidthVal.substringAfter(' ').toUpperCase();
                       String bandwidth = bandwidthVal.substringBefore(' ');
                       System.debug(LoggingLevel.FINE,'NPLC bandwidth: ['+bandwidth + '] unit : ['+unit+']');
                       if(String.IsNotBlank(FAN.Feasibility_Status__C) )
                        {
                            //For Point A Last Mile ARC NPLC~Lastmile ARC~17~MBPS~1
                            if( FAN.Feasibility_Status__r.Chargeable_Distance__c != null  )
                            {Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance__c) : 501 );
                             distance = ( distance < 5 ? 5 : distance);
                             R.LastMile = 'NPLC~Lastmile ARC~'+distance+'~'+unit+'~'+bandwidth;
                             setOfExtID.add(R.LastMile);
                            }
                            //For Point B Last Mile ARC NPLC~Lastmile ARC~17~MBPS~1
                            if( FAN.Feasibility_Status__r.Chargeable_Distance_B__c != null  )
                            {Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance_B__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance_B__c) : 501 );
                             distance = ( distance < 5 ? 5 : distance);
                             R.LastMileB = 'NPLC~Lastmile ARC~'+distance+'~'+unit+'~'+bandwidth;
                             setOfExtID.add(R.LastMileB);
                            }
                            //For L2MC NPLC~L2MC~17~MBPS~1
                            if(FAN.Flavor__c == 'L2MC' && (FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c != null))
                            {   Integer l2mcdistance = ( FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c) : 501);
                                l2mcdistance = ( l2mcdistance < 5 ? 5 : l2mcdistance);
                                R.L2MC = 'NPLC~L2MC~'+l2mcdistance+'~'+unit+'~'+bandwidth ;
                                setOfExtID.add(R.L2MC);
                            }
                            //For NLD NPLC~NLD~17~MBPS~1
                            if(FAN.Feasibility_Status__r.NLD_Distance__c != null)
                            {   Integer nlddistance = ( FAN.Feasibility_Status__r.NLD_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.NLD_Distance__c) : 501);
                                nlddistance = ( nlddistance < 5 ? 5 : nlddistance);
                                R.NLD = 'NPLC~NLD~'+nlddistance+'~'+unit+'~'+bandwidth ;
                                setOfExtID.add(R.NLD);
                            }
                         }
                        // For MSR NPLC~MSR~0~156
                            Integer msrbandwidth = ((unit=='KBPS')? (Integer.ValueOf(bandwidth)/1024) : Integer.ValueOf(bandwidth));
                            if( msrbandwidth <= 156 )
                                R.MSR='NPLC~MSR~0~156';
                            else if(msrbandwidth <=622)
                                R.MSR='NPLC~MSR~157~622'; 
                            else if(msrbandwidth <=2488)
                                R.MSR = 'NPLC~MSR~623~2488';
                            setOfExtID.add(R.MSR); 
                        R.MSRB = R.MSR;
                    }
                    //For EPL
                    else if( String.IsNotBlank(FAN.Bandwidth_Required_at_A__c) && String.IsNotBlank(FAN.Bandwidth_Required_at_B__c) && String.IsNotBlank(FAN.Bandwidth_Required__c) )
                    {
                       //EPL Bandwidth at Point A
                       String bandwidthValA = FanBCTriggerHandler.getBandwidth( FAN.Bandwidth_Required_at_A__c.trim(), 'NPLC' , Integer.ValueOf(FAN.Enter_value_of_N_A__c) );
                       String unitA = bandwidthValA.substringAfter(' ').toUpperCase();
                       String bandwidthA = bandwidthValA.substringBefore(' ');
                       System.debug(LoggingLevel.FINE,'EPL bandwidth A: ['+bandwidthA + '] unit : ['+unitA+']');
                       //EPL Bandwidth at Point B
                       String bandwidthValB = FanBCTriggerHandler.getBandwidth( FAN.Bandwidth_Required_at_B__c.trim(), 'NPLC' , Integer.ValueOf(FAN.Enter_value_of_N_B__c) );
                       String unitB = bandwidthValB.substringAfter(' ').toUpperCase();
                       String bandwidthB = bandwidthValB.substringBefore(' ');
                       System.debug(LoggingLevel.FINE,'EPL bandwidth B: ['+bandwidthB + '] unit : ['+unitB+']'); 
                       //NPLC BAndwidth
                       String bandwidthVal = FanBCTriggerHandler.getBandwidth( FAN.Bandwidth_Required__c, 'NPLC' , Integer.ValueOf(FAN.Enter_value_of_N__c) );
                       String unit = bandwidthVal.substringAfter(' ').toUpperCase();
                       String bandwidth = bandwidthVal.substringBefore(' ');
                       System.debug(LoggingLevel.FINE,'NPLC bandwidth: ['+bandwidth + '] unit : ['+unit+']');
                       if(String.IsNotBlank(FAN.Feasibility_Status__C) )
                        {
                            //For Point A Last Mile ARC NPLC~Lastmile ARC~17~MBPS~1
                            if( FAN.Feasibility_Status__r.Chargeable_Distance__c != null  )
                            {Integer distance = ( FAN.Feasibility_Status__r.Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance__c) : 501 );
                             distance = ( distance < 5 ? 5 : distance);
                             R.LastMile = 'NPLC~Lastmile ARC~'+distance+'~'+unitA+'~'+bandwidthA;
                             setOfExtID.add(R.LastMile);
                            }
                            //For Point B Last Mile ARC NPLC~Lastmile ARC~17~MBPS~1
                            if( FAN.Feasibility_Status__r.Chargeable_Distance_B__c != null  )
                            {Integer distanceB = ( FAN.Feasibility_Status__r.Chargeable_Distance_B__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.Chargeable_Distance_B__c) : 501 );
                             distanceB = ( distanceB < 5 ? 5 : distanceB);
                             R.LastMileB = 'NPLC~Lastmile ARC~'+distanceB+'~'+unitB+'~'+bandwidthB;
                             setOfExtID.add(R.LastMileB);
                            }
                            //For L2MC NPLC~L2MC~17~MBPS~1
                            if(FAN.Flavor__c == 'L2MC' && (FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c != null))
                            {   Integer l2mcdistance = ( FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.L2_Multicast_Chargeable_Distance__c) : 501);
                                l2mcdistance = ( l2mcdistance < 5 ? 5 : l2mcdistance);
                                R.L2MC = 'NPLC~L2MC~'+l2mcdistance+'~'+unit+'~'+bandwidth ;
                                setOfExtID.add(R.L2MC);
                            }
                            //For NLD NPLC~NLD~17~MBPS~1
                            if(FAN.Feasibility_Status__r.NLD_Distance__c != null)
                            {   Integer nlddistance = ( FAN.Feasibility_Status__r.NLD_Distance__c <= 500 ? Integer.ValueOf(FAN.Feasibility_Status__r.NLD_Distance__c) : 501);
                                nlddistance = ( nlddistance < 5 ? 5 : nlddistance);
                                R.NLD = 'NPLC~NLD~'+nlddistance+'~'+unit+'~'+bandwidth ;
                                setOfExtID.add(R.NLD);
                            }
                         }
                         // For MSR NPLC~MSR~0~156
                            Integer msrbandwidth = ((unit=='KBPS')? (Integer.ValueOf(bandwidth)/1024) : Integer.ValueOf(bandwidth));
                            if( msrbandwidth <= 156 )
                                R.MSR='NPLC~MSR~0~156';
                            else if(msrbandwidth <=622)
                                R.MSR='NPLC~MSR~157~622'; 
                            else if(msrbandwidth <=2488)
                                R.MSR = 'NPLC~MSR~623~2488';
                            setOfExtID.add(R.MSR);
                            R.MSRB = R.MSR ;
                    }
                    RAteCard_Keyset.put(newObj.Id, R);
                }
            }
        }
        System.Debug(LoggingLevel.FINE,'Required RAte Cards : '+setOfExtID);
        if( setOfExtID.size() > 0 )
        {
         List<RateCard__c> RateCardList = new List<RateCard__c>([Select Id, Amount__c, One_To_One_Price__c, One_To_Four_Price__c, 
                                                                 Cost_Standard__c, Cost_Business__c, Cost_Premium__c, Cost_Platinum__c,
                                                                 Unique__c from RateCard__C where Unique__c In :setOfExtID]);
         MAP<String, RateCard__c> RateCArd_MAp = new MAP<String, RateCard__C>();
         for(RateCard__c r : RateCardList)
            RateCArd_MAp.put(r.Unique__c, r);
         
         System.Debug(LoggingLevel.FINE,'Keys----------------->'+RateCard_Map.Keyset());
         
          for(Fan_BC__c newoBJ: ReFill_These)
          {
              Feasibility__c FAN = Feasibility_Map.get(newoBJ.Feasibility__c);
              RateCardKeys myKeys = RAteCard_Keyset.get(newoBJ.Id);
              if( FAN.Product__r.Bc_category__c == 'DLC')
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Population for : DLC');
                    /* Populate the following fields
                     *  Gross_ARC_LL_Rental_in_Rs__c
                     *  MSR_Gross_in_Rs__c
                     *  L2MC_from_customer_in_Rs__c
                     */
                    //For LastMile ARC
                    if(RateCArd_MAp.get(myKeys.LastMile) != null)
                         newObj.Gross_ARC_LL_Rental_in_Rs__c = RateCArd_MAp.get(myKeys.LastMile).Amount__c;
                    //For L2MC DLC~L2MC~17~KBPS~512
                    if(FAN.Flavor__c == 'L2MC' && (RateCArd_MAp.get(myKeys.L2MC) != null) && (RateCArd_MAp.get(myKeys.L2MC).Amount__c != null))
                         newObj.L2MC_from_customer_in_Rs__c = ( (FAN.L2MC_Type__c == 'Premium') ? 1.623 * RateCArd_MAp.get(myKeys.L2MC).Amount__c : RateCArd_MAp.get(myKeys.L2MC).Amount__c);
                    //For MSR
                    if(RateCArd_MAp.get(myKeys.MSR) != null)
                        newObj.MSR_Gross_in_Rs__c = RateCArd_MAp.get(myKeys.MSR).Amount__c;
                   }
                else if( FAN.Product__r.Bc_category__c == 'ILL')
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Population for : ILL');
                    /* Populate the following fields
                     *  Gross_ARC_LL_Rental_in_Rs__c
                     *  NE_Rental_Gross_Amount__c
                     *  Bandwidth_Rental_Charges_Gross_Amount__c
                     */
                    //For Lastmile ARC
                    if(RateCArd_MAp.get(myKeys.LastMile) != null)
                         newObj.Gross_ARC_LL_Rental_in_Rs__c = RateCArd_MAp.get(myKeys.LastMile).Amount__c;
                    //For Bandwidth Charges
                    if(RateCArd_MAp.get(myKeys.BandwidthCharges) != null) 
                         newObj.Bandwidth_Rental_Charges_Gross_Amount__c = (FAN.Internet_Bandwidth_Ratio__c == '1:1' ? RateCArd_MAp.get(myKeys.BandwidthCharges).One_To_One_Price__c : RateCArd_MAp.get(myKeys.BandwidthCharges).One_To_Four_Price__c );
                    //For MSR
                    if(RateCArd_MAp.get(myKeys.MSR) != null)
                        newObj.NE_Rental_Gross_Amount__c = RateCArd_MAp.get(myKeys.MSR).Amount__c;
                }
                else if( FAN.Product__r.Bc_category__c == 'MPLS')
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Population for : MPLS');
                    /* Populate the following fields
                     *  Gross_ARC_LL_Rental_in_Rs__c
                     *  MPLS_Port_BW_Charges_Gross_Amount__c
                     */
                    //For Lastmile ARC
                    if(RateCArd_MAp.get(myKeys.LastMile) != null)
                         newObj.Gross_ARC_LL_Rental_in_Rs__c = RateCArd_MAp.get(myKeys.LastMile).Amount__c; 
                    //For Port Bandwidth Charges
                    if( (RateCArd_MAp.get(myKeys.BandwidthCharges) != null) && String.IsNotBlank(FAN.Class_Of_Service_Variant__c))
                    {
                        /* If the Cos Variant on Feasibility is 'Single', Pick the price based on COS Type (Standard/Business/Premium/Platinum)
                         *  ====> what to do when COS Type is 'Custom'??
                         * If the Cos Variant on Feasibility is 'Nimble', Pick the Standard price based on Nimble Type (Nimble 1/2/3/4/5/x)
                         * and apply logic as given in the MPLS Rate Card Sheet
                         *  Nimble 1	STANDARD*1.025
                         *  Nimble 2	STANDARD*1.075
                         *  Nimble 3	STANDARD*1.1
                         *  Nimble 4	STANDARD*1.125
                         *  Nimble 5	STANDARD*1.225
                         *  Other Than 	As per the  below Rate card table
                         *   ====> what to do when Nimble Type is 'Nimble X'??
                         */
                        if( (FAN.Class_Of_Service_Variant__c == 'Single') && String.IsNotBlank(FAN.Class_Of_Service_Type__c) && (FAN.Class_Of_Service_Type__c != 'Custom'))
                        {
                            if(FAN.Class_Of_Service_Type__c == 'Standard')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c ;
                            else if(FAN.Class_Of_Service_Type__c == 'Business')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Business__c ;
                            else if(FAN.Class_Of_Service_Type__c == 'Premium')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Premium__c ;
                            else if(FAN.Class_Of_Service_Type__c == 'Platinum')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Platinum__c ;
                        }
                        else if( (FAN.Class_Of_Service_Variant__c == 'Nimble') 
                                && String.IsNotBlank(FAN.Nimble_Type__c) && (FAN.Nimble_Type__c != 'Nimble X') 
                                && (RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c != null) )
                        {
                            if(FAN.Nimble_Type__c == 'Nimble 1')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c * 1.025 ;
                            else if(FAN.Nimble_Type__c == 'Nimble 2')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c * 1.075 ;
                            else if(FAN.Nimble_Type__c == 'Nimble 3')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c * 1.1 ;
                            else if(FAN.Nimble_Type__c == 'Nimble 4')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c * 1.125 ;
                            else if(FAN.Nimble_Type__c == 'Nimble 5')
                                newObj.MPLS_Port_BW_Charges_Gross_Amount__c = RateCArd_MAp.get(myKeys.BandwidthCharges).Cost_Standard__c * 1.225 ;
                        }
                    }
                }
                else if( FAN.Product__r.Bc_category__c == 'NPLC')
                {
                    System.Debug(LoggingLevel.FINE,'Rate Card Population for : NPLC');
                    /* Populate the following fields
                     *  Gross_ARC_LL_Rental_Point_A__c
                     *  Gross_ARC_LL_Rental_Point_B__c
                     *  NE_Rental_Gross_Amount_Point_A__c
                     *  NE_Rental_Gross_Amount_Point_B__c
                     *  NLD_LL_Rental_Gross_Amount__c
                     *  L2MC_from_customer_in_Rs__c
                     */
                    //For LastMile ARC Point A 
                    if(RateCArd_MAp.get(myKeys.LastMile) != null)
                         newObj.Gross_ARC_LL_Rental_Point_A__c = RateCArd_MAp.get(myKeys.LastMile).Amount__c;
                    //For LastMile ARC Point B 
                    if(RateCArd_MAp.get(myKeys.LastMileB) != null)
                         newObj.Gross_ARC_LL_Rental_Point_B__c = RateCArd_MAp.get(myKeys.LastMileB).Amount__c;
                    //For L2MC 
                    if(FAN.Flavor__c == 'L2MC' && (RateCArd_MAp.get(myKeys.L2MC) != null) && (RateCArd_MAp.get(myKeys.L2MC).Amount__c != null))
                         newObj.L2MC_from_customer_in_Rs__c = ( (FAN.L2MC_Type__c == 'Premium') ? 1.623 * RateCArd_MAp.get(myKeys.L2MC).Amount__c : RateCArd_MAp.get(myKeys.L2MC).Amount__c);
                    //For NLD
                    if(RateCArd_MAp.get(myKeys.NLD) != null)
                         newObj.NLD_LL_Rental_Gross_Amount__c = RateCArd_MAp.get(myKeys.NLD).Amount__c;
                    //For MSR Point A
                    if(RateCArd_MAp.get(myKeys.MSR) != null)
                        newObj.NE_Rental_Gross_Amount_Point_A__c = RateCArd_MAp.get(myKeys.MSR).Amount__c;
                    //For MSR Point B
                    if(RateCArd_MAp.get(myKeys.MSRB) != null)
                        newObj.NE_Rental_Gross_Amount_Point_B__c = RateCArd_MAp.get(myKeys.MSRB).Amount__c;
                }
              
          }
         
            
        }
        }
        }
}