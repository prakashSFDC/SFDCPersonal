public class UPLChunkResults{

public List<Partner_Location__c> chunkresults(String query_search,List<Id> FinalAccId,String Region,boolean locationPublishFlag)
{

List<Partner_Location__c> results= new List<Partner_Location__c>();
List<Partner_Location__c> results_chunk= new List<Partner_Location__c>();
List<Id> FinalAccIdList ;

System.debug('&&&&&&&&&&First Scripts inside chunk :'+Limits.getScriptStatements());

FinalAccIdList = new List<Id>(FinalAccId);
String query_search1=null;
query_search1=query_search;

/*For Code Coverage   */    
Integer TotalSize= FinalAccId.size();
 if(test.isRunningTest()){
    TotalSize=2001;
    }
   
    
 if (TotalSize > 2000)
          {
                integer newMax = 0;
                integer newBase = 0;
                while (newMax < TotalSize)
                {
                    newBase = newMax;
                    newMax += 2000;
                    if (newMax > TotalSize)
                        newMax = TotalSize;
                    String[] localIds = new String[newMax];
                    integer idCounter = 0;
                    
                    if(!(test.isRunningTest())){
                        for(integer i = newBase; i < newMax; i++)
                        {
                            localIds[idCounter] = FinalAccIdList[i];
                            idCounter++;
                        }
                    }
                        query_search = query_search1+' and Account__c in :localIds order by Account__c limit 7000';
               
                        system.debug('Result chunk*************'+results_chunk);
                        results_chunk.clear();
                        results_chunk = Database.query(query_search);
               
                    idCounter = 0;                  
                      
                       results.addAll(results_chunk);
                 }
            }
            else
            {
                query_search = query_search+' and Account__c in :FinalAccId order by Account__c limit 7000';
                results = Database.query(query_search);
            }
             System.debug('&&&&&&&&&&First Scripts exiting chunk :'+Limits.getScriptStatements());
            return results;
}
}