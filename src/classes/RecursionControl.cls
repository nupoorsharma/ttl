public without sharing class RecursionControl {

    //###############________AccountTrigger_________#####################
    //For AccountTrigger
    public static boolean Accountrun = true;
    public static boolean AccountrunOnce(){
    if(Accountrun){
     Accountrun=false;
     return true;
    }else{
        return Accountrun;
    }
    }

    //###############________BuildingQUery_________#####################
    //For BuildingQUerytrigger
    public static boolean BQrun = true;
    public static boolean BQrunOnce(){
    if(BQrun){
     BQrun=false;
     return true;
    }else{
        return BQrun;
    }
    }
    
    //###############________Feasibility_________#####################
    //Control recursion in the Before Trigger
    public static boolean FeasibilityrunBefore = true;
    public static boolean FeasibilityrunOnceBefore(){
    if(FeasibilityrunBefore){
     FeasibilityrunBefore=false;
     return true;
    }else{
        return FeasibilityrunBefore;
    }
    }
    
    //Control recursion in the After Trigger
    public static boolean FeasibilityrunAfter = true;
    public static boolean FeasibilityrunOnceAfter(){
    if(FeasibilityrunAfter){
     FeasibilityrunAfter=false;
     return true;
    }else{
        return FeasibilityrunAfter;
    }
    }
    
    //###############________AVCV_________#####################
    //Control recursion in the Before Trigger for AVCV
    public static boolean AVCVrunBefore= true;
    public static boolean AVCVrunOnceBefore(){
    if(AVCVrunBefore){
     AVCVrunBefore=false;
     return true;
    }else{
        return AVCVrunBefore;
    }
    }
    
    //Control recursion in the After Trigger for AVCV
    public static boolean AVCVrunAfter = true;
    public static boolean AVCVrunOnceAfter(){
    if(AVCVrunAfter){
     AVCVrunAfter=false;
     return true;
    }else{
        return AVCVrunAfter;
    }
    }
    
     //###############________PO_________#####################
     //Control recursion in the Before Trigger
    public static boolean POrunBefore = true;
    public static boolean POrunOnceBefore(){
    if(POrunBefore){
     POrunBefore=false;
     return true;
    }else{
        return POrunBefore;
    }
    }
    //Control recursion in the After Trigger
    public static boolean POrunAfter = true;
    public static boolean POrunOnceAfter(){
    if(POrunAfter){
     POrunAfter=false;
     return true;
    }else{
        return POrunAfter;
    }
    }
    
    
      //###############________BC_________#####################
  
    //Control recursion in the After Trigger
    public static boolean BCrunAfter = true;
    public static boolean BCrunOnceAfter(){
    if(BCrunAfter){
     BCrunAfter=false;
     return true;
    }else{
        return BCrunAfter;
    }
    }
    
    //###############________FAN BC_________#####################
  
    //Control recursion in the Before Trigger
    public static boolean FANBCrunBefore = true;
    public static boolean FANBCrunOnceBefore(){
    if(FANBCrunBefore){
     FANBCrunBefore=false;
     return true;
    }else{
        return FANBCrunBefore;
    }
    }
    
      //###############________Drop CAF_________#####################
  
    //Control recursion in the After Trigger
    public static boolean DropCAFrunAfter = true;
    public static boolean DropCAFrunOnceAfter(){
    if(DropCAFrunAfter){
     DropCAFrunAfter=false;
     return true;
    }else{
        return DropCAFrunAfter;
    }
    }
}