public class permissionSetExampleController {

public Map<String, String> mapAgreementValues {get; set;}

public List<SelectOption> getAgreementTypes()
    {
        List<RegionType__c> listRegionTypes = RegionType__c.getAll().values();
        List<SelectOption> listAgreements = new List<SelectOption>();
        //mapAgreementValues = new Map<String, String>();
        
        for(RegionType__c region: listRegionTypes ){
                listAgreements.add(new SelectOption(region.Name, region.Region_Name__c));
                
        }
        listAgreements.sort();
        return listAgreements;
    }
}