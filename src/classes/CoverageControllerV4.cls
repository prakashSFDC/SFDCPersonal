public with sharing class CoverageControllerV4 {    
    
    public String territory {get; set;} 
    public String mapOption {get; set;}
    public String accountType {get; set;}
    public String slcAnalysis {get; set;} 
    
    public String testAnalysis {get; set;} 
    
    public Boolean MobilityCheckbox{get;set;}
    public Boolean RadioCheckbox{get;set;}
    public Boolean WNSCheckbox{get;set;}
    public List<String> accIndustry {get; set;} 
    
    public Opportunity opty;
    public List<String> primaryProductTrack {get; set;}
    public string mFlag{get; set;}
    public string rFlag{get; set;}
    public string sFlag{get; set;}
    public string wFlag{get; set;}
    public List<String> mobilityProductTrackDetail {get; set;}
    public List<String> radioProductTrackDetail {get; set;}
    public List<String> systemProductTrackDetail {get; set;}
    public List<String> wnsProductTrackDetail {get; set;}   
    public List<String> oppStage {get; set;}
    public date fromDate; 
    public Date toDate;     
    public List<String> oppIndustry {get; set;}
    public Id endUserAccount;
    public Id partnerAccount;
    public Id distributorAccount;
    public String partnerAccountName = null;
    public String distributorAccountName = null;
    public String dealLocationCountry ;
    public String dealLocationState;
    public String oppAmountCondition {get; set;}
    public Double oppAmountValue ;
   
    
    public Integer currentIndex {get; set;}
    public String logger {get; set;}   
    public Decimal amount {get; private set;}
    public Integer markers {get; private set;}  

    public List<Account> PartnerAccountList =new List<Account>();
    public List<Id> PartnerAccountListId =new List<Id>();
    public List<Account> NonPartnerAccountList =new List<Account>();
    public List<Id> NonPartnerAccountListId =new List<Id>();
    public List<Partner_Location__c> PartnerAccountLocValues=new List<Partner_Location__c>();
    public List<Partner_Location__c> PartnerOppLocValues=new List<Partner_Location__c>();

    public List<Partner_Coverage_Geocode__c> PCGeocode=new List<Partner_Coverage_Geocode__c>();
    public List<Opportunity> GeocodeOpportunityList =new List<Opportunity>();
    public List<Id> GeocodeOpportunityListId =new List<Id>();

    public List<Account> AccountList {get; private set;}
    public List<Opportunity> OpportunityList {get; private set;}
    public List<Partner_Location__c> PartnerList =new List<Partner_Location__c>();
    public List<Partner_Location__c> OppPartnerList =new List<Partner_Location__c>();
    public string Localterritory = null;   
    public List<wrapperProduct> WrapperAccountPLChanges {get; private set;}    
    public List<wrapperProduct> WrapperOpporPLChanges {get; private set;}     

  

    public CoverageControllerV4(ApexPages.StandardController controller) {

        this.opty=(Opportunity)controller.getRecord();

        this.slcAnalysis = 'Account';
        this.mapOption = 'None';
        this.territory = 'Territory 5 - Brazil';             
        this.accountType = 'All'; 
        this.currentIndex = 0;
        this.logger = '';
        this.markers = 0; 
        this.amount = 0;            

        this.PartnerAccountList=new List<Account>();
        this.NonPartnerAccountList=new List<Account>();
        this.PartnerAccountListId=new List<Id>();
        this.NonPartnerAccountListId=new List<Id>();

        this.AccountList = new List<Account>();
        this.OpportunityList = new List<Opportunity>();       
        this.WrapperAccountPLChanges = new List<wrapperProduct>();
        this.WrapperOpporPLChanges = new List<wrapperProduct>();
       
        Schema.DescribeFieldResult fieldResult;       

        this.accIndustry = new List<String>();
        this.oppIndustry = new List<String>();  
        this.oppStage= new List<String>();

      
        this.primaryProductTrack =new List<String>();
        this.mobilityProductTrackDetail = new List<String>();
        this.radioProductTrackDetail = new List<String>();
        this.systemProductTrackDetail =new List<String>();
        this.wnsProductTrackDetail = new List<String>();        
       

    }

    /* <<<<<<<<<<<<<<<<< For Account Analysis>>>>>>>>>>>>>>>>>>>> */
    public void  AccountPLChanges(){
        
        Localterritory= this.territory;
        double LocalLatitude = null;
        double LocalLongitude = null;
        //LocalAccountType ='Partner' ;
        integer CountPartners = 0;
        integer flagCheck=0;// for Mobility,Radio,WNS checkBox conditions

        if(WrapperAccountPLChanges.size()!=null)
            WrapperAccountPLChanges.clear();
            
        if(WrapperOpporPLChanges.size()<>null)
            WrapperOpporPLChanges.clear();

        
        String query = 'SELECT Id, Type,Name,RecordTypeId,Latitude__c, Longitude__c,BillingStreet, BillingCity, BillingCountry FROM Account WHERE BillingCity<>\'\' and Territory__c=\''+this.territory+'\'';
        String queryCount = 'SELECT COUNT() FROM Account WHERE BillingCity<>\'\' and Territory__c=\''+this.territory+'\'';
        String filters = '';

        if (accountType!='All'){
            if (accountType=='Partner')                 
                filters+=' AND Type =\''+accountType+'\''; 
            else
                //filters+=' AND Type !=\''+LocalAccountType+'\''; 
                filters+=' AND Type IN (\'End User'+ '\'' + ',\'Sold To Account'+ '\'' + ',\'Prospect' + '\')'; 
        }

        if (MobilityCheckbox==true){
            filters+=' AND (Mobility_Track__c=true';
            flagCheck=1;
        } 

        if (RadioCheckbox==true){
            if(flagCheck==1){
                filters+=' OR Radio_Partner__c=true';
                flagCheck=12;
            }else{
                filters+=' AND (Radio_Partner__c=true';                 
                flagCheck=2;
            }
        }

        if (WNSCheckbox==true){
            if(flagCheck==12 || flagCheck==2||flagCheck==1){
                filters+=' OR WNS_Track__c=true';
                flagCheck=123;

            }else if(flagCheck==2){
                filters+=' AND WNS_Track__c=true';                  
                flagCheck=3;
            }
        }

        if(flagCheck!=0 && flagCheck!=3){
            filters+=')';
        }                  
        
        if (accIndustry.size()>0) {
            filters+=' AND Industry IN (';
            boolean firstElement = true;
            for (String currentItem : accIndustry) {
                if (firstElement) {
                    filters+='\''+currentItem+'\'';
                    firstElement = false;
                }
                else
                    filters+=',\''+currentItem+'\'';
            }
            filters+=')';
        }

        System.debug('Filter Value:'+filters);
        System.debug('Total Query Value:'+query+filters);
        this.AccountList = Database.query(query+filters+' LIMIT 1000');
        
        
        
         /* From the Above Results we are Creating two Account Lists one is of Partner Record Type and other Non-Partner Record Type */   
           
        for(Account acct: AccountList){ 
            if(acct.RecordTypeId=='012Q0000000ClemIAC'){
                PartnerAccountListId.add(acct.Id);
                PartnerAccountList.add(acct);
            }else {
                NonPartnerAccountListId.add(acct.Id);
                NonPartnerAccountList.add(acct);                                        
            }
        }
        
         System.debug('PartnerAccountList size'+PartnerAccountList.size());
         System.debug('NonPartnerAccountList size'+NonPartnerAccountList.size());
                
         /* From the Above Results we are Creating two Account Lists one is of Partner Record Type and other Non-Partner Record Type */

        Map<Id,double> PartLocLatValueMap=new Map<Id,double>();
        Map<Id,double> PartLocLongValueMap=new Map<Id,double>();

        Map<Id,double> NonPartLocLatValuesMap=new Map<Id,double>();
        Map<Id,double> NonPartLocLongValuesMap=new Map<Id,double>();


        if(PartnerAccountList.size()>0){             
            PartnerAccountLocValues = [select Latitude__c, Longitude__c,Account__c  from Partner_Location__c where Account__c in : PartnerAccountListId and Address_Type__c='HQ' ];

            for(Partner_Location__c p:PartnerAccountLocValues){   

                PartLocLatValueMap.put(p.Account__c,p.Latitude__c);
                PartLocLongValueMap.put(p.Account__c,p.Longitude__c);  

            } 
        }          

            for(Account acc : PartnerAccountList){
                LocalLatitude = (double)PartLocLatValueMap.get(acc.id);
                LocalLongitude = (double)PartLocLongValueMap.get(acc.id);               
                wrapperProduct wrapP=new wrapperProduct(acc.id, acc.Type, acc.Name,LocalLatitude, LocalLongitude,0,null,null);
                WrapperAccountPLChanges.add(wrapP);             
                CountPartners++;
            }         

        if(NonPartnerAccountList.size()>0){ 

            for(Account acc:NonPartnerAccountList){
                LocalLatitude = (double)acc.Latitude__c;
                LocalLongitude = (double)acc.Longitude__c;
                wrapperProduct wrapP=new wrapperProduct(acc.id, acc.Type, acc.Name,LocalLatitude, LocalLongitude,0,null,null);
                WrapperAccountPLChanges.add(wrapP);
                CountPartners++;
            }
        }
        
        
         system.debug('Total Markers : ' + CountPartners);
        this.markers = CountPartners; 

/* clearing all the List values before each search */
        
        if(PartnerAccountList.size()!=null){
            PartnerAccountList.clear();
        }
        if(PartnerAccountListId.size()!=null){
            PartnerAccountListId.clear();
        }
        if(NonPartnerAccountList.size()!=null){
            NonPartnerAccountList.clear();
        }
        if(NonPartnerAccountListId.size()!=null){
            NonPartnerAccountListId.clear();
        }         
            
        /* clearing all the List values before each search */     

    }

    /* <<<<<<<<<<<<<<<<< For Account Analysis>>>>>>>>>>>>>>>>>>>> */   


    /* <<<<<<<<<<<<<<<<<For Opportunity Analysis >>>>>>>>>>>>>>>>>>>> */    
    public void  OpportunityPLChanges(){

        Localterritory= this.territory;
        //LocalAccountType ='Partner' ;
        double LocalLatitude = null;
        double LocalLongitude = null;
        double LocalAmount = null;
        integer CountPartners = 0;

        String localCountry=null;
        String localState=null;
        String localCountryState=null;

        endUserAccount = null;
        partnerAccountName = null;
        distributorAccountName = null;

        fromDate=null;
        toDate=null;

        dealLocationCountry=opty.Deal_Location_Country__c;
        dealLocationState=opty.Deal_Location_State__c ;

        fromDate=opty.From_Date__c;            
        toDate=opty.To_Date__c;            

        oppAmountValue=opty.Amount;           

        endUserAccount=opty.End_User_Account__c;
        partnerAccount=opty.Partner_Account__c;
        distributorAccount=opty.Distributor_Type_Account__c; 

        List<String> TotalProductTrackList = new List<String>();    
        set<String> OppCountrySet = new set<String>();
        //set<String> OppStateSet = new set<String>();


    /* For Look up Accounts */  
      
        List<Account> LookupAccountNamesList = new List<Account>();
        List<Id> lookupIds = new List<Id>();

        if(partnerAccount!=null)
            lookupIds.add(partnerAccount);
        if(distributorAccount!=null)
            lookupIds.add(distributorAccount);

        if(lookupIds!=null)           
            LookupAccountNamesList = [select Name from Account where Id in:lookupIds];

        for(Account ac:LookupAccountNamesList)
        {             
            if(ac.Id==partnerAccount)  
                partnerAccountName=ac.Name;
            else
                distributorAccountName=ac.Name;
        }  
        
      /* For Look up Accounts */            

        if(WrapperOpporPLChanges.size()<>null)
            WrapperOpporPLChanges.clear();
            
        if(WrapperAccountPLChanges.size()!=null)
            WrapperAccountPLChanges.clear();    



        String query = 'SELECT Account.Id, Account.Name,Amount,CloseDate,Name,Deal_Location_Country__c,Deal_Location_State__c, Account.Type, StageName,  Industry__c FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
        String queryCount = 'SELECT COUNT() FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
        String queryAmount = 'SELECT SUM(Amount)Amt FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';

        String filters = '';
        if (accountType!='All'){
            if (accountType=='Partner') 
                filters+=' and Account.Type =\''+accountType+'\''; 
            else
                //filters+=' and Account.Type !=\''+LocalAccountType+'\''; 
                filters+=' AND Account.Type IN (\'End User'+ '\'' + ',\'Sold To Account'+ '\'' + ',\'Prospect' + '\')';
        }

        if(primaryProductTrack.size()>0) {
            filters+=' and Primary_Product_Track__c  IN (';
            boolean firstElement = true;
            for (String currentItem : primaryProductTrack) {
                if (firstElement) {
                    filters+='\''+currentItem+'\'';
                    firstElement = false;
                }
                else
                    filters+=',\''+currentItem+'\'';
            }
            filters+=')';
        }                
        
    if(mFlag=='Mobility'){
        if (mobilityProductTrackDetail.size()>0) {
            for(integer i=0;i<mobilityProductTrackDetail.size();i++ ){
                TotalProductTrackList.add(mobilityProductTrackDetail[i]);
            }
        }
    }
    
    if(rFlag=='Radio'){
        if (radioProductTrackDetail.size()>0) {
            for(integer i=0;i<radioProductTrackDetail.size();i++ ){
                TotalProductTrackList.add(radioProductTrackDetail[i]);
            }
        }
    }   
    if(sFlag=='System'){
        if (systemProductTrackDetail.size()>0) {
            for(integer i=0;i<systemProductTrackDetail.size();i++ ){
                TotalProductTrackList.add(systemProductTrackDetail[i]);
            }
        }
    }
    if(wFlag=='WNS'){
        if (wnsProductTrackDetail.size()>0) {
            for(integer i=0;i<wnsProductTrackDetail.size();i++ ){
                TotalProductTrackList.add(wnsProductTrackDetail[i]);
            }
        }
    }
    if (TotalProductTrackList.size()>0) {
            filters+=' and Product_Track_Detail__c  IN (';
            boolean firstElement = true;
            for (String currentItem : TotalProductTrackList) {
                if (firstElement) {
                    filters+='\''+currentItem+'\'';
                    firstElement = false;
                }
                else
                    filters+=',\''+currentItem+'\'';
            }
            filters+=')';
        }

    if (oppStage.size()>0){
            filters+=' and StageName IN (';
            boolean firstElement = true;
            for (String currentItem : oppStage) {
                if (firstElement) {
                    filters+='\''+currentItem+'\'';
                    firstElement = false;
                }
                else
                    filters+=',\''+currentItem+'\'';
            }
            filters+=')';
        }

        if(fromDate!=null && toDate==null) 
            filters+=' and CloseDate >=:fromDate' ;            

        if(fromDate!=null && toDate!=null)
            filters+=' and CloseDate >=:fromDate and CloseDate <=:toDate';

        if(fromDate==null && toDate!=null)
            filters+=' and CloseDate <=:toDate';    

        System.debug('From Date Value'+fromDate);
        System.debug('To Date Value'+toDate);   
        system.debug('Date Filter is' + filters);       

        if (oppIndustry.size()>0) {
            filters+=' and Industry__c  IN (';
            boolean firstElement = true;
            for (String currentItem : oppIndustry) {
                if (firstElement) {
                    filters+='\''+currentItem+'\'';
                    firstElement = false;
                }
                else
                    filters+=',\''+currentItem+'\'';
            }
            filters+=')';
        }


        if(endUserAccount!=null){

            filters+=' and opportunity.Account.id =\''+endUserAccount+'\'';
        }

        system.debug('########endUserAccount'+endUserAccount);              

        if(partnerAccountName!=null)
            filters+=' and Primary_Channel_Partner_Formula__c =\''+partnerAccountName+'\'';

        system.debug('#######partnerAccount'+partnerAccountName);                          

        if(distributorAccountName!=null)
            filters+=' and Primary_Distributor_Formula__c =\''+distributorAccountName+'\'';  

        system.debug('########distributorAccount'+distributorAccountName);           

        if(dealLocationCountry!=null)
            filters+=' and Deal_Location_Country__c =\''+dealLocationCountry+'\'';

        system.debug('##########Country'+dealLocationCountry);

        if(dealLocationState!=null)
            filters+=' and Deal_Location_State__c =\''+dealLocationState+'\'';

        system.debug('State'+dealLocationState);                
        system.debug('########Condition is'+oppAmountCondition);

        if(oppAmountValue!=null)
            filters+=' and Amount '+ oppAmountCondition + oppAmountValue ; 

        System.debug('Total Query Value:'+query+filters);

        this.OpportunityList = Database.query(query+filters+' LIMIT 1000');
        this.amount = (Decimal)((AggregateResult)Database.query(queryAmount+filters)).get('Amt');            

/* Form the ResultList we are taking all the Country,State values in to set to get Lat & Long form Partner Location Obj */
        if(OpportunityList.size()>0){
            for(opportunity o:OpportunityList){                 
                        OppCountrySet.add(o.Deal_Location_Country__c);
                    //OppCountrySet.add(o.Deal_Location_State__c);
                }
            }
   
        
        Map<String,double> OppLatValueMap=new Map<String,double>();
        Map<String,double> OppLongValueMap=new Map<String,double>();                
        String GCountry= null;
        String GState= null;
        String GCountryState= null;         
        if(OpportunityList.size()>0){               
            PCGeocode = [select Country__c, State__c,Latitude__c,Longitude__c from Partner_Coverage_Geocode__c where Country__c in :OppCountrySet ]; 
            //System.debug('PCGeocode Size:'+PCGeocode.size());
            for(Partner_Coverage_Geocode__c pcg:PCGeocode){
                    System.debug('In PCG for Loop');
                GCountry=pcg.Country__c;
                GState=pcg.State__c;
                GCountryState=GCountry+','+GState;
                OppLatValueMap.put(GCountryState,pcg.Latitude__c);
                OppLongValueMap.put(GCountryState,pcg.Longitude__c);                                         
            }                       
        }
                       
          for(Opportunity opp : OpportunityList){
                LocalAmount=(double)opp.Amount;
                localCountry=opp.Deal_Location_Country__c;
                localState=opp.Deal_Location_State__c;
                localCountryState=localCountry+','+localState;
                LocalLatitude = (double)OppLatValueMap.get(localCountryState);
                    //System.debug('LocalLatitude:'+LocalLatitude);
                LocalLongitude = (double)OppLongValueMap.get(localCountryState); 
                    //System.debug('LocalLongitude:'+LocalLongitude);               
                wrapperProduct wrapOPP=new wrapperProduct(opp.Account.Id, opp.Account.Type, opp.Name,LocalLatitude, LocalLongitude,LocalAmount ,opp.Industry__c,opp.Account.Name);
                WrapperOpporPLChanges.add(wrapOPP);
                CountPartners++;
            }
            system.debug('My Output for Opportunity : ' + CountPartners);
            this.markers = CountPartners; 
            
     /* clearing all the List values before each search */      
            
            if(PCGeocode.size()!=null)
                    PCGeocode.clear();          
                    
     /* clearing all the List values before each search */                  
            
        
    }
 /* <<<<<<<<<<<<<<<<<For Opportunity Analysis >>>>>>>>>>>>>>>>>>>> */ 

    /* <<<<<<<<<<<<<<<<< Wrapper Class>>>>>>>>>>>>>>>>>>>> */
    public class wrapperProduct{ 
        public Id FieldId{get;set;}
        public String FieldAccountType{get;set;}
        public String FieldsName{get;set;}       
        public double FieldLatitude{get;set;}
        public double FieldLongitude{get;set;}       
        public double FieldAmount{get;set;}     
        public String FieldIndustry{get;set;}
        public String FieldAccountName{get;set;}


        public wrapperProduct(id WrapFieldId,String WrapFieldAccountType, String WrapFieldsName ,double WrapFieldLatitude ,double WrapFieldLongitude,double WrapFieldAmount, string WrapFieldIndustry,string WrapFieldAccountName){
            FieldId=WrapFieldId;
            FieldAccountType=WrapFieldAccountType;
            FieldsName=WrapFieldsName;            
            FieldLatitude=WrapFieldLatitude;
            FieldLongitude=WrapFieldLongitude;            
            FieldAmount=WrapFieldAmount; 
            FieldIndustry=WrapFieldIndustry;
            FieldAccountName=WrapFieldAccountName;
            
        }

    }
   /* <<<<<<<<<<<<<<<<< Wrapper Class>>>>>>>>>>>>>>>>>>>> */


   



    public void next() {  
        if (slcAnalysis=='Account') {
            if (currentIndex+25<WrapperAccountPLChanges.size())
                currentIndex+=25;
        } else {
            if (currentIndex+25<WrapperOpporPLChanges.size())
                currentIndex+=25;
        }
    }

    public void previous() {
        if (currentIndex-25>=0)
            currentIndex-=25;
    }

    public boolean getAccShowResults() {

        if (WrapperAccountPLChanges.isEmpty() ) return false;

        else return true;

    }
    public boolean getOppShowResults() {

        if (WrapperOpporPLChanges.isEmpty() ) return false;

        else return true;

    }

    public String getMapName() {
        if (this.territory=='Territory 5 - Brazil') {
            if (mapOption=='GDP') 
                return 'br_gdr';
            if (mapOption=='GDP per Capita' || mapOption=='GDP Growth')
                return 'br_gdr_per_capita';
            if (mapOption=='Population')
                return 'br_population';
            
        }
         if (this.territory=='Territory 1 - Mexico') {
            if (mapOption=='GDP Growth')
                return 'mex_gdr';
            if (mapOption=='Population')
                return 'mex_population';
        }
        if (this.territory=='Territory 3 - Andean') {
            if (mapOption=='GDP Growth')
                return 'col_gdr';
            if (mapOption=='Population')
                return 'col_population';
        }
        if (this.territory=='Territory 4 - Southern Cone' ||                
                this.territory=='Territory 2 - Caricam') {
            if (mapOption=='GDP Growth')
                return 'la_gdr_grow';
        }
        return '';
    }

    public String getLegendName() {
        if (this.territory=='Territory 5 - Brazil') {
            if (mapOption=='GDP') 
                return 'br_gdr_legend.png';
            if (mapOption=='GDP per Capita' || mapOption=='GDP Growth')
                return 'br_gdr_per_capita_legend.png';
            if (mapOption=='Population')
                return 'br_population_legend.png';
        }
        if (this.territory=='Territory 1 - Mexico') {
            if (mapOption=='GDP Growth')
                return 'mex_gdr_legend.png';
            if (mapOption=='Population')
                return 'mex_population_legend.png';
        }
        if (this.territory=='Territory 3 - Andean') {
            if (mapOption=='GDP Growth')
                return 'col_gdr_legend.png';
            if (mapOption=='Population')
                return 'col_population_legend.png';
        } 
        if (this.territory=='Territory 4 - Southern Cone' ||               
                this.territory=='Territory 2 - Caricam') {
            if (mapOption=='GDP Growth')
                return 'la_gdr_grow_legend.png';
        }
        return '';
    }

    public String getGraphicName() {
        if (this.territory=='Territory 5 - Brazil') {
            if (mapOption=='GDP Growth')
                return 'br_gdr_growth.png';
        }
        return '';
    }

    public String getDataSource() {
        return 'IBGE Brasil';
    }

    public PageReference exportExcel() {
        return Page.CoverageMapExcel;
    }


    public void apply()
    {

        this.currentIndex=0;

        if (slcAnalysis=='Account') {
            AccountPLChanges();
        }
        else{
            OpportunityPLChanges();
        }     

    }

    public List<SelectOption> getAnalisys() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account','Account'));
        options.add(new SelectOption('Opportunity','Opportunity'));
        return options;
    }

     public List<SelectOption> getTesanalisys() {
        List<SelectOption> mapoptionsList= new List<SelectOption>();
        mapoptionsList=optionsList('Test Field',this.territory);
        return mapoptionsList;
    }
    public List<SelectOption> getMapOptions() {
        List<SelectOption> mapoptionsList=new List<SelectOption>();
        mapoptionsList=optionsList('Map Options',this.territory);
        return mapoptionsList;
    }

    public List<SelectOption> getOppIndustries() {
        List<SelectOption> options = new List<SelectOption>();      
        Schema.DescribeFieldResult fieldResult = Opportunity.Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }



    public List<SelectOption> getPrimaryProductTracks() {
        List<SelectOption> primaryproductList=new List<SelectOption>();
        primaryproductList=optionsList('Primary Product Track','NoValue');
        return primaryproductList;
    }

    /* <<<<< For Multiselect ProductTrack>>>>>>>>>>>>>>>>> */

    public void  productFlag(){
        mFlag=null;
        rFlag=null;
        sFlag=null;
        wFlag=null;
        if(PrimaryProductTrack.size()!=null){
            for(integer i=0;i<PrimaryProductTrack.size();i++){
                if(PrimaryProductTrack[i]=='Mobility')
                    mFlag='Mobility';
                else if(PrimaryProductTrack[i]=='Radio')
                    rFlag='Radio';
                else if(PrimaryProductTrack[i]=='System')
                    sFlag='System';
                else
                    wFlag='WNS';                
            }
            System.debug('#####mFlag Value'+mFlag);
            System.debug('#####rFlag Value'+rFlag); 
            System.debug('#####sFlag Value'+sFlag); 
            System.debug('#####wlag Value'+wFlag);                              
        }

    }

    public List<SelectOption> getMobilityProductTrackDetails() {
        List<SelectOption> primaryproductdetailsList=new List<SelectOption>();
        primaryproductdetailsList=optionsList('Primary Product Track Details','Mobility');
        return primaryproductdetailsList;
    }      

    public List<SelectOption> getRadioProductTrackDetails() {
        List<SelectOption> primaryproductdetailsList=new List<SelectOption>();
        primaryproductdetailsList=optionsList('Primary Product Track Details','Radio');
        return primaryproductdetailsList;
    }

    public List<SelectOption> getSystemProductTrackDetails() {
        List<SelectOption> primaryproductdetailsList=new List<SelectOption>();
        primaryproductdetailsList=optionsList('Primary Product Track Details','System');
        return primaryproductdetailsList;
    }

    public List<SelectOption> getWNSProductTrackDetails() {
        List<SelectOption> primaryproductdetailsList=new List<SelectOption>();
        primaryproductdetailsList=optionsList('Primary Product Track Details','WNS');
        return primaryproductdetailsList;
    }

    /* <<<<< For Multiselect ProductTrack>>>>>>>>>>>>>>>>> */

    public List<SelectOption> getOppStages() {
        List<SelectOption> options = new List<SelectOption>();           
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }

    public List<SelectOption> getTerritories() {
        List<SelectOption> territoryList=new List<SelectOption>();
        territoryList=optionsList('Territory','NoValue');
        return territoryList;
    }



    public List<SelectOption> getAccountTypes() {
        List<SelectOption> accounttypeList=new List<SelectOption>();
        accounttypeList=optionsList('Type','NoValue');
        return accounttypeList;
    }


    public List<SelectOption> getAccIndustries() {
        List<SelectOption> options = new List<SelectOption>();          
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;

    } 
/* */


/* */


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////Filter Field Values - Common Function - Start//////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    Public List<SelectOption> optionsList(String filterField, String ControllingValue)
    {

        String filterFieldValue;
        List<String> filterFieldValueList=new List<String>();

        if(ControllingValue=='NoValue')
        {
            filterFieldValue=[Select Filter_Field_Values__c from Partner_Coverage_Control__c where Filter_Field__c=:filterField limit 1].Filter_Field_Values__c;
        }
        else
        {
            filterFieldValue=[Select Filter_Field_Values__c from Partner_Coverage_Control__c where Filter_Field__c=:filterField AND Controlling_Value__c=:ControllingValue limit 1].Filter_Field_Values__c;
        }
        
        System.debug('##############filterFieldValue:'+filterFieldValue);

        filterFieldValueList=filterFieldValue.Split(';');
        
         System.debug('##############filterFieldValueList:'+filterFieldValueList);

        List<SelectOption> selectOptions = new List<SelectOption>();

        for(integer i=0;i<filterFieldValueList.Size();i++)
        {
            selectOptions.add(new SelectOption(filterFieldValueList[i],filterFieldValueList[i]));
        }
        
        System.debug('##############selectOptions:'+selectOptions);
        
        return selectOptions;

    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////Filter Field Values - Common Function - End//////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////             

}