public class PickListUsingCustomSettingsCtrl {

 public String region{ get; set; }
 public String country {get; set;} 
 List<SelectOption> RegionList = new List<SelectOption>();         
 

   public PickListUsingCustomSettingsCtrl(){
           Regionlist = new List<SelectOption>();
            RegionList.add(new selectOption('','--None--'));            
            for(String sRegion : (PersonalSettings__c.getInstance('Region Values').Value__c).split(',')){
                RegionList.add(new selectOption(sRegion,sRegion));
              }     
   }
}