public class CustomSettingExampleCtrl{

 public String region{ get; set; }
 public String country {get; set;} 
 
public List<SelectOption> getRegionTypes(){

       //Querying Custom Setting Data 
        List<RegionType__c> listRegionTypes = RegionType__c.getAll().values();
        List<SelectOption> listRegion = new List<SelectOption>();           
        
        for(RegionType__c region: listRegionTypes){            
                listRegion.add(new SelectOption(region.Region_Name__c, region.Region_Name__c));              
            }       
        listRegion.sort();
        return listRegion;   
   } 

/*public List<SelectOption> getCountryTypes(){

       //Querying Custom Setting Data 
        List<RegionType__c> listCountryTypes = RegionType__c.getAll().values();
        List<SelectOption> listCountry = new List<SelectOption>();           
        
        for(RegionType__c country: listCountryTypes ){            
                listCountry.add(new SelectOption(country.Region_Name__c, country.Region_Name__c));              
            }       
        listCountry.sort();
        return listCountry;   
   }   */
   
   public List<SelectOption> getCountryTypes(){

       //Querying Custom Setting Data 
        List<RegionType__c> listCountryTypes = RegionType__c.getAll().values();
        system.debug('#######:-'+listCountryTypes);
        system.debug('####### this.region:-'+this.region);
        
        Map<String, RegionType__c> countries= RegionType__c.getAll();
        RegionType__c a = RegionType__c.getValues(this.region);
        system.debug('####### a :-'+a );
        system.debug('####### countries.values():-'+countries.values());
        for(RegionType__c c: countries.values()) {
        
            if (c.Region_Name__c == this.region) {
                countries.put(c.Country__c, c);
            }
        }
       system.debug('#######:-'+countries);
        List<String> countryNames = new List<String>();
        countryNames.addAll(countries.keySet());
        countryNames.sort();
        system.debug('#######:-'+countryNames);
        List<SelectOption> listCountry = new List<SelectOption>();           
        
        for(String countryName: countryNames){            
                RegionType__c country = countries.get(countryName);
                listCountry.add(new SelectOption(country.Country__c, country.Country__c));              
            }       
        //listCountry.sort();
        system.debug('#######:-'+listCountry);
        return listCountry;   
   }  
   
}