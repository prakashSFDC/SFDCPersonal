public class DependentPickListUsingCustomSettingsCtrl{

 public string region;
 public String getRegion(){ 
     return region;
 }
 public void setRegion(String strRegionSelected){ 
     this.region = strRegionSelected;
 }
 
 
 public List<SelectOption> getRegionList(){ 
           List<SelectOption> listRegion = new List<SelectOption>();
            listRegion.add(new selectOption('','--None--'));            
            for(String sRegion : (PersonalSettings__c.getInstance('Region Values').Value__c).split(',')){
                listRegion.add(new selectOption(sRegion,sRegion));
              } 
            return listRegion; 
 }
 
public string country;
 public String getCountry(){ 
     return region;
 }
 
 public void setCountry(String strCountrySelected){ 
     this.country= strCountrySelected;
 }
   public DependentPickListUsingCustomSettingsCtrl(){
          
   }   
   public List<SelectOption> getCountryValuesToDisplay(){
             List<SelectOption> listCountry = new List<SelectOption>();
            listCountry .add(new selectOption('','--None--'));     
            system.debug('$$$$$$Region:'+region);       
            for(String sCountry : (PersonalSettings__c.getInstance(region).Value__c).split(',')){
                system.debug('$$$$$$sCountry :'+sCountry );   
                listCountry .add(new selectOption(sCountry,sCountry));
              }
                 return listCountry;      
       }
   
   }