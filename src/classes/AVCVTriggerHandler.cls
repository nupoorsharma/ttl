/*
    * Name: AVCVTriggerHandler Class
    * Created On: February 9, 2016
    * Author: Nupoor(nupoor.sharma@comprotechnologies.com)
    * Description: Called from the AVCVTrigger, AVCVTriggerHandler is called before and after update. 
    *              # In before update, when the Revert to AMT Checkbox field is updated, 
    *                The AMT Comment and Sales Comment is added as a child AVCV Comment.
    * 			   # List of AVCV records are collected and sent for creation of JSON string in after update.
    * Change Log History:
    * |--------------------------------------------------------------------|
    * | Version | Changes By | Date       |  Description                   |
    * |--------------------------------------------------------------------|
    * |   0.1   | Nupoor     | 21-12-2016 | Initial version of Class       |
    * |   0.2   | Rahul      | 04-06-2016 | Updated version with all       | 
    * | 								  | CAFs valid/invalid status on PO|
    * |--------------------------------------------------------------------|    
*/
public class AVCVTriggerHandler {
    /*
     * executeBefore()
     * Purpose :: Called before update, this method adds the comments as child AVCV comments and 
     *            nullifies the comment fields on header. 
     */
    public static void executeBefore(List<AV_CV__c> newList, Map<ID, AV_CV__c> oldMap)
    {System.Debug('AVCVTriggerHandler---execute()');
      List<AVCV_Comments__c> CommentList = new List<AVCV_Comments__c>();
      
        for(AV_CV__c av : newList)
        {
            if(av.Revert_to_AMT__c == true && av.Revert_to_AMT__c != oldMap.get(av.id).Revert_to_AMT__c )
            {	if(!String.IsEmpty(av.AMT_Comment__c) )
                   {AVCV_Comments__c com = new AVCV_Comments__c();
                    com.AV_CV__c = av.id ;
                    com.From__c = 'AMT' ;
                	com.Comment__c = av.AMT_Comment__c ;
                    CommentList.add(com) ;
                   }
                if( !String.IsEmpty(av.Sales_Comment__c))
                   {AVCV_Comments__c com = new AVCV_Comments__c();
                    com.AV_CV__c = av.id ;
                    com.From__c = 'Sales' ;
                	com.Comment__c = av.Sales_Comment__c ;
                    CommentList.add(com) ;
                   }
                   av.AMT_Comment__c = null ;
                   av.Sales_Comment__c = null ;
             	   //av.Revert_to_AMT__c = false ;
            }
        }
     if(CommentList.size() > 0)
         insert CommentList;
    }
    
    
    // Call GenerateEmpowerREST to create record json 
    public static void executeAfter(List<AV_CV__c> newList, Map<ID, AV_CV__c> mapold, Boolean IsInsert, Boolean IsUpdate)
    {
        System.Debug('AVCVTriggerHAndler --------- executeAfter()');
        List<AV_CV__c> ListForInterface = new List<AV_CV__c>();
        for(AV_CV__c NewObj : newlist)
         if(   (isInsert && NewObj.Submit_to_AV_CV_Team__c) 
            || (isUpdate && NewObj.Submit_to_AV_CV_Team__c && NewObj.Submit_to_AV_CV_Team__c!= mapold.get(NewObj.Id).Submit_to_AV_CV_Team__c) 
            || (isUpdate && NewObj.Submit_to_AV_CV_Team__c && NewObj.Revert_to_AMT__c && NewObj.Revert_to_AMT__c != mapold.get(NewObj.Id).Revert_to_AMT__c )
            )
            ListForInterface.add(NewObj);
        
         if( ListForInterface.size() > 0 )
             GenerateEmpowerREST.execute(ListForInterface);
       
    }
    
    // Update "Valid CAF status" on Parent PO record
    public static void updateCAFStatusOnParentPO(List<AV_CV__c> newList, Map<ID, AV_CV__c> mapold, Boolean IsInsert, Boolean IsUpdate) {
    Set<ID> POIDs = new Set<ID>();
    for (AV_CV__c NewObj : newlist) {
        
        if (NewObj.Purchase_Order__c != NULL && IsUpdate) {
            if ( NewObj.Valid_CAF_Status__c != mapold.get(NewObj.Id).Valid_CAF_Status__c ) {

                POIDs.add(NewObj.Purchase_Order__c);
            }
        } /*else if (NewObj.Purchase_Order__c != NULL && IsInsert) {
            POIDs.add(NewObj.Purchase_Order__c);
        }*/
    }

    List<Purchase_Order__c> Po_lst = [SELECT ID, Valid_CAF_Status__c,
                                      (select ID, Valid_CAF_Status__c from AV_CV__r)
                                      FROM Purchase_Order__c WHERE ID IN:POIDs];
    List<Purchase_Order__c> Po_lst_update = new  List<Purchase_Order__c>();

    for (Purchase_Order__c po : Po_lst) {
        boolean chk = true;
        for (AV_CV__c avac : po.AV_CV__r) {
            if (!avac.Valid_CAF_Status__c) {
                chk = false;
                break;
            }
        }
        // List of PO to Update
        Po_lst_update.add(new Purchase_Order__c(id = po.ID, Valid_CAF_Status__c = chk));
    }

    // Check List size before update
    if (Po_lst_update.size() > 0) {
        update Po_lst_update;
    }
 }
  
  /*
   * executeBefore()
   * Purpose : Used to populate the field Drops_CAF_Numbers__c
   *           >> Point_CAF_No__c is appended if the Circle on Feasibility is same
   *           >> Point_B_CAF_No__c is appended if the circle is different.
   *           >> Format : D1:CAF_No,D2:CAF_No,D3:CAF_No....
   */
  public static void PopulateDropCafNumbers(List<AV_CV__c> newList, Map<ID, AV_CV__c> mapold, Boolean IsInsert, Boolean IsUpdate)
  {
        System.Debug('AVCVTriggerHandler ---------- PopulateDropCafNumbers()');
        SET<ID> FAN_ID_SET = new SET<ID>();
        MAP<ID,ID> FAN_AVCV_MAP = new MAP<ID,ID>();
        MAP<ID, AV_CV__c> AVCV_MAP = new MAP<ID,AV_CV__c>();
           for( AV_CV__c avcv : [Select Id, Valid_CAF_Status__c, Drops_CAF_Numbers__c, Product__r.FAN_Category__c,
                                 FAN_No__c, FAN_No__r.Flavor__c,
                                 Point_CAF_No__c, Point_B_CAF_No__c, Number_of_Drop_CAF__c, Number_of_Valid_Drop_CAF__c,
                                 (Select ID, Circle__c, CAF_Number__C from Drop_CAF__r)
                                  from AV_CV__c where ID IN :newList])
           {
                if( avcv.FAN_No__r != Null && avcv.Product__r != Null
                    && avcv.FAN_No__r.Flavor__c == 'L2MC'
                    && (avcv.Product__r.FAN_Category__c == 'DLC' || avcv.Product__r.FAN_Category__c == 'NPLC')
                    && ( (IsUpdate && avcv.Valid_CAF_Status__c && avcv.Valid_CAF_Status__c != mapold.get(avcv.ID).Valid_CAF_Status__c)
                        || (avcv.Product__r.FAN_Category__c == 'DLC' && String.IsNotBlank(avcv.Point_CAF_No__c) ) 
                        || (avcv.Product__r.FAN_Category__c == 'NPLC' 
                            && String.IsNotBlank(avcv.Point_CAF_No__c) && String.IsNotBlank(avcv.Point_B_CAF_No__c) 
                            && avcv.Number_of_Drop_CAF__c==avcv.Number_of_Valid_Drop_CAF__c ) 
                       )
                   )
                { 
                   FAN_ID_SET.add(avcv.FAN_No__c);
                   FAN_AVCV_MAP.put(avcv.FAN_No__c, avcv.ID);
                   AVCV_MAP.put(avcv.Id, avcv) ;
                }
    
           }
      	System.Debug('AVCVTriggerHandler ---------- FAN_ID_SET'+FAN_ID_SET);
    		//Execute Logic for Calculating the drop CAF number if any applicable FAN records are found.
           if( !FAN_ID_SET.IsEmpty() )
           {
    
            List<Feasibility__c> FAN_List = [Select Id, Product__r.Fan_Category__c, Flavor__c, Circle__c, Circle_B__c,  
                                            (Select Id, Name, Drop_Id__c, Circle__c from Drops__r where Auto_Created__C=false order by Name) 
                                            from Feasibility__c
                                            where ID IN :FAN_ID_SET] ;
    
            for(Feasibility__c fan : FAN_List )
            {   String dropcafnumber = null ;
                AV_CV__c avcv = AVCV_MAP.get( FAN_AVCV_MAP.get(fan.ID) ) ;
                List<Drop__C> Drop_List = fan.Drops__r ;
                if( (!Drop_List.IsEmpty()) && (fan.Product__r!=Null) && (fan.Product__r.FAN_Category__c == 'DLC') )
                {
                    for(Drop__c drop: Drop_List)
                              dropcafnumber = ( dropcafnumber==null ? ('D'+drop.Name+':'+avcv.Point_CAF_No__c) : (dropcafnumber+'^^'+ 'D'+drop.Name+':'+avcv.Point_CAF_No__c) ) ;
    
                }
                else if(  (!Drop_List.IsEmpty()) && (fan.Product__r!=Null) && (fan.Product__r.FAN_Category__c == 'NPLC') )
                {
                    List<Drop_CAF__c> DropCAF_List = avcv.Drop_CAF__r ;
                    MAP<String, String> Circle_CAF_MAP = new Map<String, String>();
                    for(Drop_CAF__c dropCAF : DropCAF_List)
                        Circle_CAF_MAP.put( dropCAF.Circle__c , dropCAF.CAF_Number__C );
    
                    /*Populate Drop_CAF_Numbers__c string on AVCV record based on the below logic
                     * IF Drop Circle = Point A circle on FAN : Use Point_CAF_No__c
                     * IF Drop Circle = Point B circle on FAN : Use Point_B_CAF_No__c
                     * IF Drop Circle != Point A/B circle on FAN 
                     *                : Use the CAF listed against that circle on Drop_CAF__c
                     */
                    for(Drop__c drop: Drop_List)
                    {
                        if(drop.Circle__c == fan.Circle__c)
                              dropcafnumber = ( dropcafnumber==null ? ('D'+drop.Name+':'+avcv.Point_CAF_No__c) : (dropcafnumber+'^^'+ 'D'+drop.Name+':'+avcv.Point_CAF_No__c) ) ;
                        else if(drop.Circle__c == fan.Circle_B__c)
                              dropcafnumber = ( dropcafnumber==null ? ('D'+drop.Name+':'+avcv.Point_B_CAF_No__c) : (dropcafnumber+'^^'+ 'D'+drop.Name+':'+avcv.Point_B_CAF_No__c) ) ;
                        else if( Circle_CAF_MAP.get(drop.Circle__c) != NULL )
                                 dropcafnumber = ( dropcafnumber==null ? ('D'+drop.Name+':'+Circle_CAF_MAP.get(drop.Circle__c)) : (dropcafnumber+'^^'+ 'D'+drop.Name+':'+Circle_CAF_MAP.get(drop.Circle__c)) ) ;
    
    
                   }
                }
    			System.Debug('dropCAFNumber'+dropcafnumber);
                avcv.Drops_CAF_Numbers__c = dropcafnumber;
                AVCV_MAP.put(avcv.id, avcv);
           }
               for(AV_CV__c newObj : newList)
               {
                   if(AVCV_MAP.get( newObj.id) != Null)
                       newObj.Drops_CAF_Numbers__c = AVCV_MAP.get( newObj.id).Drops_CAF_Numbers__c ;
               }
    
          }
  }



}