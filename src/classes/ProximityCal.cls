public class ProximityCal{
private static string serviceUrl= 'http://maps.google.com/maps/geo?key=ABQIAAAAEE03Dr-W47B95_vzya7jzRTo8B3YJktMb21jjZGvLOSeepqdwxRpC2oq2dfGdQj4KGVWyw8e3wnP0w';
double lat;
double longitude;
List<double> lat_long = new List<double>();

//Value of Pi
public double pi=3.1415926535;

//Radius of earth in KM.
public double radius=6371;

public ProximityCal()
{}


//Create a Wrapper class
public class DistanceWrapper
{
 public Partner_location__c DistanceWrap{get;set;}
 public double distanceforWrapper{get;set;}

 public DistanceWrapper(Partner_location__c distanceWrapobj)
 {
  DistanceWrap = distanceWrapobj;
  distanceforWrapper = 0.0;
 }

}

   
//****************Method for Proximity Sort
public List<Partner_Location__c> ProximitySearch(List<Partner_Location__c> FinalSetforProximitySort1,double latiSearch,double longiSearch)
{
 //Find the latutude and longitude of the location entered in the UI.
    //System.debug('######Location entered in UI:'+Location);
    //System.debug('######DAMMMMMNNNNNNNNNNNNNNNNN:'+FinalSetforProximitySort1);
     system.debug('#######ScriptLimit INSIDE PROXIMITY SORT:'+Limits.getScriptStatements());
    
    List<DistanceWrapper> DistanceWrapperFinal = new List<DistanceWrapper>();
    
   // Map<Id,double> proximityMap = new Map<Id,double>();
   // Map<String,Partner_Location__c> proximityMapLocation = new Map<String,Partner_Location__c>();
    Map<Id,Partner_Location__c> locationMap = new Map<Id,Partner_Location__c>();
    
    //List<String> distanceFromEnteredLocationList=new List<String>();
    List<Partner_Location__c> results1Sorted=new List<Partner_Location__c>();
    double ResultsLat;
    double ResultsLong; 
    Double d=null;
    List<double> distance = new List<double>();
    double dist=0.0;
    //String tempString=null;
    //Integer tmp=0;
    List<double> sorteddistancesList= new List<double>();
    //Set<double> sorteddistancesSet= new Set<double>();
    List<String> distanceFromEnteredLocList=new List<String>();
    List<String> distanceFromEnteredLocListFinal = new List<String>(); 
    //Set<Id> UniqueAccountIDSet = new Set<Id>();
   
   if(latiSearch==null)  
    latiSearch=0.00;  
   
   if(longiSearch==null) 
    longiSearch=0.00;
    
   latiSearch = latiSearch*pi/180; 
   longiSearch= longiSearch*pi/180; 
    
   //****HARDCODED VALUE FOR TESTING******
   
  
   //Process the result set and find the distance of each location from the location entered.
   for(Partner_Location__c plocProximity:FinalSetforProximitySort1)  
   {
    //Retrieve the latitude and longitude of this location
    if(distanceFromEnteredLocList.size()<9000)
    {
    ResultsLat = plocProximity.Latitude__c;
    ResultsLong = plocProximity.Longitude__c;
    
    
    //Call the method to find the distance of this location from the location entered in the UI.
    //dist=ProximitySort(latiSearch,longiSearch,ResultsLat,ResultsLong);
    
///BEGINNNNNNNNNNNNNNNNNN
    if(ResultsLat==null)
    ResultsLat=0.00;
    if(ResultsLong==null)
    ResultsLong=0.00;
    ResultsLat=ResultsLat*pi/180;
    ResultsLong=ResultsLong*pi/180;
    
    double dlat=(ResultsLat-latiSearch)*pi/180;
    double dlong=(ResultsLong-longiSearch)*pi/180;

    Double lati1  = Double.valueOf(latiSearch);
    Double longi1 = Double.valueOf(longiSearch);
    Double lati2  = Double.valueOf(ResultsLat);
    Double longi2 = Double.valueOf(ResultsLong);
    Double dlati  = Double.valueOf(dlat);
    Double dlongi = Double.valueOf(dlong);

    double A = math.sin(dLat/2) * math.sin(dLat/2) + math.cos(latiSearch) * math.cos(ResultsLat) * math.sin(dLong/2) * math.sin(dLong/2);
    dist=radius * 2 * math.atan2(math.SQRT(A),math.SQRT(1-A));
   
///ENDDDDDDDDD
    
    //Create Wrapper
    DistanceWrapper dis = new DistanceWrapper(plocProximity);
    dis.DistanceWrap = plocProximity;
    dis.distanceforWrapper = dist;
    DistanceWrapperFinal.add(dis);
    
   locationMap.put(plocProximity.Id,plocProximity);
   
   }
    
   }
   //Sort the distances
   sorteddistancesList.sort();
   
   //System.debug('######The locations with their distance in the Map:'+proximityMap);
   //System.debug('############distanceFromEnteredLocationList:'+distanceFromEnteredLocList);
    //System.debug('######DAMMMMMNNNNNNNNNNNNNNNNN:'+FinalSetforProximitySort1.size());
   //System.debug('############size of distanceFromEnteredLocationList:'+distanceFromEnteredLocList.size());
   //Sort the distances in ascending order
   
  
    //********************TEST*DistanceWrapperFinal**/
          
      List<DistanceWrapper> resultList = new List<DistanceWrapper>();
      // Create a map of amount to Opportunity collection   
      Map<Decimal, List<DistanceWrapper>> locMap = new Map<Decimal, List<DistanceWrapper>>();
      for(DistanceWrapper o:DistanceWrapperFinal) 
      {            
        if(locMap.get(o.distanceforWrapper) == null) 
        { 
          locMap.put(o.distanceforWrapper, new List<DistanceWrapper>()); 
        }            
        locMap.get(o.distanceforWrapper).add(o);        
      }                
      List<Decimal> keys = new List<Decimal>(locMap.keySet());
      
      // Leverage the standard, primitive collection sort method  
      keys.sort();
      for(Decimal key:keys)
      { 
       resultList.addAll(locMap.get(key));
      }                
    
  // System.debug('################resultListWrapper:'+resultList);   
   for(DistanceWrapper dis:resultList)
   {
    results1Sorted.add(locationMap.get(dis.DistanceWrap.Id));
   }
   
  // System.debug('#############results1SortedWrapper:'+results1Sorted.size());
   
  //*************************/

   system.debug('#######ScriptLimit end of 9PROXIMITY SORT:'+Limits.getScriptStatements());
   return results1Sorted;

}



 //Method for calculating the Proximity.
public double ProximitySort(Double lat1,Double long1,Double lat2,Double long2)
{
    
double d=null;


//Calculate the difference.
/*if(lat1==null)  
    lat1=0.00;*/
if(lat2==null)  
    lat2=0.00;
/*if(long1==null) 
    long1=0.00;*/
if(long2==null) 
    long2=0.00; 
    

//double dLat  = lat2-lat1;
//double dlong = long2-long1;


//Convert it to radians(ie: Pi radians=180 degrees....So 1degree=Pi/180 radians...Multiply the Degrees by Pi/180)
//lat1=lat1*pi/180;
lat2=lat2*pi/180;
//long1=long1*pi/180;
long2=long2*pi/180;

//dlat=dlat*pi/180;
//dlong=dlong*pi/180;
double dlat=(lat2-lat1)*pi/180;
double dlong=(long2-long1)*pi/180;



Double lati1  = Double.valueOf(lat1);
Double longi1 = Double.valueOf(long1);
Double lati2  = Double.valueOf(lat2);
Double longi2 = Double.valueOf(long2);
Double dlati  = Double.valueOf(dlat);
Double dlongi = Double.valueOf(dlong);


double A = math.sin(dLat/2) * math.sin(dLat/2) + math.cos(lat1) * math.cos(lat2) * math.sin(dLong/2) * math.sin(dLong/2);

//double C = 2 * math.atan2(math.SQRT(A),math.SQRT(1-A));

//Calculate the distance with the Harvesines Formula( Distance,d=R*C kilometers.)
//d=radius*C;
d=radius * 2 * math.atan2(math.SQRT(A),math.SQRT(1-A));


return d;

}   



  

}