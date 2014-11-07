/*  
* File Name      : UPL_ProximitySort
* Description    : This class returns sorted partner locations  onj basis of the proximity to the location entered by user.                                      
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     27-Sep-12    Infosys           Created  
*   
*/
public class UPL_ProximitySort {
  
  public UPL_ProximitySort(){
  
  }
  
  //****************Method for Proximity Sort
  public List<Partner_Location__c> ProximitySearch(List<Partner_Location__c> unsortedPartnerLocations,double latiSearch,double longiSearch){
        system.debug('#######ScriptLimit INSIDE PROXIMITY SORT:'+Limits.getScriptStatements());
        
        //Value of Pi
      double pi=3.1415926535;
      //Radius of earth in KM.
      double radius=6371;
        List<Partner_Location__c> sortedResults=new List<Partner_Location__c>();
        Map<Double,List<Partner_Location__c>> distancePartnerListMap = new Map<Double,List<Partner_Location__c>>();
        double ResultsLat;
        double ResultsLong; 
        List<double> distance = new List<double>();
        double dist=0.0;
        List<double> sorteddistancesList= new List<double>();
      
      latiSearch = latiSearch*pi/180; 
      longiSearch= longiSearch*pi/180; 

       for(Partner_Location__c plocProximity:unsortedPartnerLocations){
        //Retrieve the latitude and longitude of this location
        ResultsLat = plocProximity.Latitude__c;
        ResultsLong = plocProximity.Longitude__c;
        
        if(ResultsLat==null)
            ResultsLat=0.00;
       
        if(ResultsLong==null)
            ResultsLong=0.00;
        
        ResultsLat=ResultsLat*pi/180;
        ResultsLong=ResultsLong*pi/180;
        
        double dlat=(ResultsLat-latiSearch)*pi/180;
        double dlong=(ResultsLong-longiSearch)*pi/180;
    
        double A = math.sin(dLat/2) * math.sin(dLat/2) + math.cos(latiSearch) * math.cos(ResultsLat) * math.sin(dLong/2) * math.sin(dLong/2);
        dist=radius * 2 * math.atan2(math.SQRT(A),math.SQRT(1-A));
       
        sorteddistancesList.add(dist);
        
        if(distancePartnerListMap.get(dist)==null){
          distancePartnerListMap.put(dist,new List<Partner_Location__c>());
        }
       
        distancePartnerListMap.get(dist).add(plocProximity);
        
       }
       //Sort the distances
       sorteddistancesList.sort();
       
       for(Double sortedDistance: sorteddistancesList){
           sortedResults.addAll(distancePartnerListMap.get(sortedDistance));
       }
       
       system.debug('#######ScriptLimit end of 9PROXIMITY SORT:'+Limits.getScriptStatements());
       return sortedResults;
  
  }

}