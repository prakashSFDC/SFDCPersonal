public class RecentAccessedRecords{
    
    public List<RecentlyViewed> listRecentRecords {get;set;}
    public RecentAccessedRecords (){
         listRecentRecords = new List<RecentlyViewed>();
         listRecentRecords = [ SELECT Id, Name,Type FROM RecentlyViewed WHERE LastViewedDate !=null ORDER BY LastViewedDate DESC Limit 5 ] ;
     }
}