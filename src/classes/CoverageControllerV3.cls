public with sharing class CoverageControllerV3 {

    public CoverageControllerV3(ApexPages.StandardController controller) {
    
        this.slcAnalysis = 'Account';
        this.mapOption = 'None';
        this.territory = 'Territory 5 - Brazil';
        this.accountType = 'All';
        
        this.currentIndex = 0;
        
        this.logger = '';
        
        this.oppStage = 'All';
        this.oppIndustry = 'All';
        this.markers = 0;
        this.amount = 0;
        this.accs = new List<Account>();
        this.opps = new List<Opportunity>();
        
        Schema.DescribeFieldResult fieldResult;
        
        this.certificationLevel = new List<String>();
        fieldResult = Account.Qualification_Type__c.getDescribe();
        for(Schema.PicklistEntry p : fieldResult.getPicklistValues())
            this.certificationLevel.add(p.getValue());       

        this.accTrack = new List<String>();
        this.oppTrack = new List<String>();
        fieldResult = Opportunity.Primary_Technology__c.getDescribe();
        for(Schema.PicklistEntry p : fieldResult.getPicklistValues()) {
            this.accTrack.add(p.getValue());
            this.oppTrack.add(p.getValue());
        }

    }


   


   

    public String slcAnalysis {get; set;}
    public String mapOption {get; set;}
    public String accountType {get; set;}
    public String territory {get; set;}
    public List<String> certificationLevel {get; set;}
    public List<String> accTrack {get; set;}
    public String oppIndustry {get; set;}
    public List<String> oppTrack {get; set;}
    public String oppStage {get; set;}
    
    public Integer currentIndex {get; set;}
    
    public String logger {get; set;}
    
    public String updateId {get; set;}
    public String latitude {get; set;}
    public String longitude {get; set;}

    public Decimal amount {get; private set;}
    public Integer markers {get; private set;}
    public List<Account> accs {get; private set;}
    public List<Opportunity> opps {get; private set;}
    
    
    
    public void next() {
        if (slcAnalysis=='Account') {
            if (currentIndex+25<accs.size())
              currentIndex+=25;
        } else {
            if (currentIndex+25<opps.size())
              currentIndex+=25;
        }
    }
    
    public void previous() {
        if (currentIndex-25>=0)
           currentIndex-=25;
    }
    
  public boolean getShowResults() {
        if (accs.isEmpty() && opps.isEmpty()) return false;
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
        if (this.territory=='Territory 4 - Southern Cone' ||
            this.territory=='Territory 3 - Andean' ||
            this.territory=='Territory 2 - Caricam' ||
            this.territory=='Territory 1 - Mexico') {
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
        if (this.territory=='Territory 4 - Southern Cone' ||
            this.territory=='Territory 3 - Andean' ||
            this.territory=='Territory 2 - Caricam' ||
            this.territory=='Territory 1 - Mexico') {
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
    
    public void apply() {
        
        this.currentIndex=0;
        system.debug('enter 1');
        
        if (slcAnalysis=='Account') {
        system.debug('enter 2 account');
            //String query = 'SELECT Id, Account_Subtype_M__c, Name, Qualification_Type__c, Latitude__c, Longitude__c, BillingStreet, BillingCity, BillingCountry FROM Account WHERE BillingCity<>\'\' and Territory__c=\''+this.territory+'\'';
            String query = 'SELECT Id, Account_Subtype_M__c, Name,Qualification_Type__c,Latitude__c, Longitude__c, BillingStreet, BillingCity, BillingCountry FROM Account WHERE BillingCity<>\'\' and Territory__c=\''+this.territory+'\'';
            
            
            
            String queryCount = 'SELECT COUNT() FROM Account WHERE BillingCity<>\'\' and Territory__c=\''+this.territory+'\'';
    
            String filters = '';
            if (accountType!='All')
                filters+=' AND Account_Subtype_M__c INCLUDES (\''+accountType+'\')';
                
            if (accTrack.size()>0) {
                filters+=' AND (Id IN (SELECT AccountId FROM Opportunity WHERE Primary_Technology__c IN (';
                boolean firstElement = true;
                for (String currentItem : accTrack) {
                    if (firstElement) {
                        filters+='\''+currentItem+'\'';
                        firstElement = false;
                    }
                    else
                        filters+=',\''+currentItem+'\'';
                }
                filters+=')))';
            }
            
            this.markers = Database.countQuery(queryCount+filters);
            this.accs = Database.query(query+filters+' LIMIT 1000');
            system.debug('acccs.sxe' +accs.size());         
            
        } else {
        
            //String query = 'SELECT Account.Id, Amount, Name, Account.Account_Subtype_M__c, StageName, Account.Vertical_Market__c, Primary_Technology__c, Account.Latitude__c, Account.Longitude__c, Account.BillingStreet, Account.BillingCity, Account.BillingCountry FROM Opportunity WHERE Account.BillingCity<>\'\' and PartnerAccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            //String queryCount = 'SELECT COUNT() FROM Opportunity WHERE Account.BillingCity<>\'\' and PartnerAccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            //String queryAmount = 'SELECT SUM(Amount)Amt FROM Opportunity WHERE Account.BillingCity<>\'\' and PartnerAccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            system.debug('enter 3 opportunity');
            String query = 'SELECT Account.Id, Amount, Name, Account.Account_Subtype_M__c, StageName,  Primary_Technology__c, Account.Latitude__c, Account.Longitude__c, Account.BillingStreet, Account.BillingCity, Account.BillingCountry FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            String queryCount = 'SELECT COUNT() FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            String queryAmount = 'SELECT SUM(Amount)Amt FROM Opportunity WHERE Account.BillingCity<>\'\' and AccountId<>NULL and Account.Territory__c=\''+this.territory+'\'';
            
            String filters = '';
            if (accountType!='All')
                filters+=' and Account.Account_Subtype_M__c includes (\''+accountType+'\')';
            
            if (oppStage!='All')
                filters+=' and StageName=\''+oppStage+'\'';
                
            if (oppIndustry!='All')
                filters+=' and Account.Vertical_Market__c=\''+oppIndustry+'\'';
                
            if (oppTrack.size()>0) {
                filters+=' and Primary_Technology__c IN (';
                boolean firstElement = true;
                for (String currentItem : oppTrack) {
                    if (firstElement) {
                        filters+='\''+currentItem+'\'';
                        firstElement = false;
                    }
                    else
                        filters+=',\''+currentItem+'\'';
                }
                filters+=')';
            }
            
            this.markers = Database.countQuery(queryCount+filters);
            this.opps = Database.query(query+filters+' LIMIT 1000');
            system.debug('oppy sixe' + opps.size());
            this.amount = (Decimal)((AggregateResult)Database.query(queryAmount+filters)).get('Amt');
            system.debug('amt####' + this.amount);
        }
    }
    
    public void updateLocation() {
        Account act = [SELECT name, latitude__c, longitude__c FROM Account WHERE id=:this.updateId LIMIT 1];
        act.Latitude__c = Double.valueOf(this.latitude);
        act.Longitude__c = Double.valueOf(this.longitude);
        update act;
    }

    public List<SelectOption> getAnalisys() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account','Account'));
        options.add(new SelectOption('Opportunity','Opportunity'));
        return options;
    }

    public List<SelectOption> getMapOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','None'));
        if (this.territory=='Territory 5 - Brazil') {
            options.add(new SelectOption('GDP','GDP'));
            options.add(new SelectOption('GDP per Capita','GDP per Capita'));
            options.add(new SelectOption('GDP Growth','GDP Growth'));
            options.add(new SelectOption('Population','Population'));
        } else 
        if (this.territory=='Territory 4 - Southern Cone' ||
            this.territory=='Territory 3 - Andean' ||
            this.territory=='Territory 2 - Caricam' ||
            this.territory=='Territory 1 - Mexico') {
            options.add(new SelectOption('GDP Growth','GDP Growth'));
        }
        return options;
    }

   /* public List<SelectOption> getOppIndustries() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        Schema.DescribeFieldResult fieldResult = Account.Vertical_Market__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
           if (p.isActive())
               options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }*/

    public List<SelectOption> getOppStages() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }

    public List<SelectOption> getAccLevels() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Qualification_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }

    public List<SelectOption> getTerritories() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Territory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }

    public List<SelectOption> getAccountTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        Schema.DescribeFieldResult fieldResult = Account.Account_Subtype_M__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));
        return options;
    }

    public List<SelectOption> getTracks() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Primary_Technology__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }    
 Public String getTestPrintvalues(){            
            //return  this.slcAnalysis + '-------'+this.mapOption+ '-------'+this.accountType+ '-------'+this.territory + '-------'+this.certificationLevel+''-------'+this.accTrack+ '-------'+ this.MobilityCheckbox + '-------'+ this.RadioCheckbox+ '-------'+this.WNSCheckbox + '-------'+this.accIndustry +'-------'+this.oppIndustry + '-------'+this.primaryProductTrack+ '-------'+this.productTrackDetail + '-------'+this.dealLocationCountry+ '-------'+this.dealLocationState+ '-------'+this.oppAmountCondition+ '-------'+this.oppAmountValue ;   
        return   'Result - '+this.slcAnalysis+','+this.mapOption+','+this.accountType+','+this.territory; 
        
        }
}