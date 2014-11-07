public class PickListExCtrl{
    
    public string picklist{get;set;}
    public string metalLevel{get;set;}
    public string metalLevel2{get;set;}
    
    public PickListExCtrl(ApexPages.StandardController controller) {

    }    
    
   public List<SelectOption> getMetalLevels() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Platinum','Platinum'));
        options.add(new SelectOption('Gold','Gold'));
        options.add(new SelectOption('Silver','Silver'));
        return options;
   }
   
    public List<SelectOption> getMetalLevels2() {
        List<SelectOption> options = new List<SelectOption>();      
        Schema.DescribeFieldResult fieldResult = Account.Metal_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                options.add(new SelectOption('',''));
        for(Schema.PicklistEntry p : ple)
            if (p.isActive())
                options.add(new SelectOption(p.getValue(), p.getValue()));        
        return options;
    }

   
}