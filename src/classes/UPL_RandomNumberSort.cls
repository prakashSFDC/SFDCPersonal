/*  
* File Name      : UPL_RandomNumberSort
* Description    : This class will randomly sorts the partner location list ensuring that the result will 
*                  will display in difffernt order fo different users.                                      
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     27-Sep-12    Infosys           Created  
*   
*/

public class UPL_RandomNumberSort {
    
          //Method to do random sort
          public List<Partner_Location__c> makeRandomSort(List<Partner_Location__c>  partnerLocationList){
               Map<Double,Partner_Location__c> randomKeyMap = new Map<Double,Partner_Location__c>();
               List<Double> randomSortedList = new List<Double>();
               List<Partner_Location__c> finalRandomlySortedPartnerLocationList = new List<Partner_Location__c>();
                //Loop through the Account Ids and assign a random number to each of them and add them to a map\
                for(Partner_Location__c plc:partnerLocationList)
                {
                  //Generate a random number
                  Double d = Math.random();
                  randomKeyMap.put(d,plc); 
                }    
                 //Sort the random number key set in ascending order
                 Set<Double> tempSet = randomKeyMap.keySet();
                 randomSortedList.addAll(tempSet);
                 randomSortedList.sort();
                   
                //Loop through the randomly sorted key and add its corresponding accountid to the final list  
                for(Double db:randomSortedList)
                { 
                  finalRandomlySortedPartnerLocationList.add(randomKeyMap.get(db));
                }
                 
                //Return the randomly sorted list of Ids
                return finalRandomlySortedPartnerLocationList;
          }

}