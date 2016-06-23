/*
 * Name        : AVCVJSON
 * Description : AVCVJSON class is used to generate the json of AV/CV record
 * Author      : Rahul Mohan (Compro Technologies)
 * Created On  : 6 April 2016
 */
    public class AVCVJSON {

        public String soid;
        public String product;
        public String subProdType;
        public String tariffID;
        public String salesID;
        public String salesName;
        public String companyName;
        public List<BillAddressDetail> billAddressDtls;
        public String offlineFlag;
        public String avcvIdentifier;
        public String authKey;
        public String transactionID;
        public String inputText1;
        public String inputText2;
        public String inputText3;
        public String inputText4;
        public String inputText5;
        public String inputText6;
        public String inputText7;
        public String inputText8;
        public String inputText9;
        public String inputText10;
        
        public AVCVJSON()
        {
            billAddressDtls=new List<BillAddressDetail>();
            billAddressDtls.add(new BillAddressDetail());
        }

        public class BillAddressDetail {
            public String fanNo;
            public String parentCafDate;
            public String parentCafNo;
            public String parentAddress1;
            public String parentAddress2;
            public String parentAddress3;
            public String parentCircle;
            public String parentCity;
            public String parentPincode;
            public String pointACafDate;
            public String pointACafNo;
            public String ptAddress1;
            public String ptAddress2;
            public String ptAddress3;
            public String pointACircle;
            public String pointACity;
            public String ptAPincode;
            public String pointBCafDate;
            public String pointBCafNo;
            public String ptBAddress1;
            public String ptBAddress2;
            public String ptBAddress3;
            public String pointBCircle;
            public String pointBCity;
            public String ptBPincode;
            public String nldCafDate;
            public String nldCafNo;
            public String nldAddress1;
            public String nldAddress2;
            public String nldAddress3;
            public String nldCircle;
            public String nldCity;
            public String nldPincode;
            public String dropCaf;
            public String exitApplicable;
            public String srfCopfId;
            public String srfCustSiteId;
            public String srfFarEndId;
            public String srfLmsId;
            
        }
    
    }