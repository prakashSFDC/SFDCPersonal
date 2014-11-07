/*  
* File Name      : UPL_SortPartnerLocatorResults
* Description    : This class returns sorted partner locations                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-12    Infosys           Created  
*   
*/
public class UPL_SortPartnerLocatorResults{     
          
        public static final String federalSearch='FEDERAL';
        public static final String resellerSearch='RESELLER';
        public static final String distributorSearch='DISTRIBUTOR';
        public static final String nameSearch='NAME';
        public static final String appPartnerSearch='APPLICATION';
        public static final String Mobility='Mobility';
        public static final String RADIO='RADIO';
        public static final String WNS='WNS';
        public static final String SCADA='SCADA';
        public static final String regionLACR='LACR';
        public static final String regionNA='NAMR';
        public static final String regionEMEA='EMEA';
        public static final String regionAPAC='APAC';
        public static final String community_VAD='Value Added Distributor';
        public static final String community_subDist='Sub Distributor';
  
        /**
         * This method is used to sort the partner location based on conditions.Sort logics corresponding
         * to condition is detailed in code comments.
         * @author sathish_selvaraj
         * @since 01-Aug-2012
         * @param searchedPartnerLocationList - Formula Field values (numbers) corresponding to each level
         * @param resultIdforSort - Master list of partner location
         * @param community - Map of account Id & Level values ( number )
         * @param technology
         * @param isUSfed
         * @param isMego
         * @param program (track)
         * @return finalSortedPartnerLocationList
         */
        public List<Partner_Location__c> getSortedPartnerLocations(List<Partner_Location__c> searchedPartnerLocationList,Set<Id> resultIdforSort,UPL_FilterCriteria filterCriteria ){        
          logger('Entering findSortLogic ######## ');  
          List<Partner_Location__c> finalSortedPartnerLocationList=null;
          logger('####### Scripts Executed BEFORE Sort Logics :'+Limits.getScriptStatements());
          if(filterCriteria.searchType==resellerSearch){
                finalSortedPartnerLocationList=sortResellers(searchedPartnerLocationList, resultIdforSort, filterCriteria);
          }else if(filterCriteria.searchType==distributorSearch){
                finalSortedPartnerLocationList=sortDistributors(searchedPartnerLocationList, resultIdforSort, filterCriteria);
          }else if(filterCriteria.searchType==federalSearch){
                finalSortedPartnerLocationList=sortFederalPartner(searchedPartnerLocationList, resultIdforSort, filterCriteria);
          }else if(filterCriteria.searchType==appPartnerSearch){
                finalSortedPartnerLocationList=sortApplicationPartner(searchedPartnerLocationList, resultIdforSort, filterCriteria);
          }else if(filterCriteria.searchType==nameSearch){
                finalSortedPartnerLocationList=sortPartnersByName(searchedPartnerLocationList);
          }
         logger('####### Scripts Executed AFTER Sort Logics :'+Limits.getScriptStatements());
         return finalSortedPartnerLocationList;
        
        }  
     
         /**
         * This method is used to print logs. In case of production release and if logs needs to turned off,
         * it can be commented only in this method.
         * @author sathish_selvaraj
         * @since 01-Aug-2012
         * @param message
         */
        private void logger(String message){
             //system.debug(Logginglevel.INFO,message);
             system.debug(message);
        }
         
        /**
         * This method is used to covert a map to list in order of map keys
         * @author sathish_selvaraj
         * @since 01-Aug-2012
         * @param inputMap - Map of levels and its partner location list
         * @return outputPartnerLocationList - list containing all partner location sorted on order of map keys
         */
        private List<Partner_Location__c> convertMapToList(Map<Double,List<Partner_Location__c>>  inputMap){
          logger('Entering convertMapToList ######## ');  
          List<Partner_Location__c> outputPartnerLocationList=new List<Partner_Location__c>();
          Set<Double> keyValue=inputMap.keySet();
          List<Double> sortedKey=new List<Double>();
          sortedKey.addAll(keyValue);
          sortedKey.sort();
           for(Double key :sortedKey){
                outputPartnerLocationList.addAll(inputMap.get(key));
           }
          logger('Exiting  convertMapToList ######## '); 
          return outputPartnerLocationList; 
        } 

        /** This method is used to sort the partner location based on levels passed as argument and make a random sort on the result.
         * @author sathish_selvaraj
         * @since 01-Aug-2012
         * @param sortParameterList
         * @param patnerLocationList - Master list of partner location
         * @param mapAccountParameter - Map of account Id & Level values ( number )
         * @param isRandomRequired - boolean to make a random sort.
         * @param isProximitySort - boolean to make proximity sort
         * @param latitude
         * @param longitude
         * @returnfinalSortedPartnerLocationList
         */  
       private  Map<Double,List<Partner_Location__c>> sortOnParameter(Set<Double> sortParameterList,List<Partner_Location__c> patnerLocationList,Map<Id,Double> mapAccountParameter,boolean isRandomRequired,boolean isProximitySort,Double latitude,Double longitude) {            
           logger('Entering sortOnParameter ######## ');
           logger('#######ScriptLimit INSIDE PARTNER LEVEL PROXIMITY SORT:'+Limits.getScriptStatements());
           logger('######Parameter Sorted List : '+sortParameterList);
           logger('######PartnerLocation List : '+patnerLocationList);
           logger('######Account-parameter MAP : '+mapAccountParameter);
           
           //Create a map with the Distinct levels as Key and the List of level records with that Level
           Map<Double,List<Partner_Location__c>> sortedMap = new Map<Double,List<Partner_Location__c>>(); 
           Map<Double,List<Partner_Location__c>> randomSortedMap = null; 
           Map<Double,List<Partner_Location__c>> proximtySortedMap = null; 
           
           if(sortParameterList!=null && sortParameterList.size()>0){
                 //Populate the map with the Keys and empty lists     
               for(Double param:sortParameterList)  {        
                 sortedMap.put(param,new List<Partner_Location__c>());
               }      
                 
               //Loop through the location records and populate the map with the location records of a particular level    
               for(integer j =0;j<patnerLocationList.size();j++)    
               {             
                 Double parameterValue = mapAccountParameter.get(patnerLocationList[j].Account__c);
                // logger('###############patnerLocationList[j].Account__c:'+patnerLocationList[j].Account__c);
                 logger('###############parameterValue:'+parameterValue);
                // if(levelMap.get(partLevel2) != null)
                    if(sortedMap.get(parameterValue)!=null){
                         sortedMap.get(parameterValue).add(patnerLocationList[j]); 
                    }
               }
           }
          
           /**
           *Make a random sort on partner location list 
           */  
           if(isRandomRequired && sortedMap !=null ){
                 randomSortedMap = new Map<Double,List<Partner_Location__c>>(); 
                    for(Double key :sortedMap.keySet()){
                        // Replace map values with the randomly sorted partner location list
                        if(sortedMap.get(key)!=null && sortedMap.get(key).size()>1){
                             randomSortedMap.put(key,new UPL_RandomNumberSort().makeRandomSort(sortedMap.get(key)));
                        }else{
                            randomSortedMap.put(key,sortedMap.get(key));
                        }
                    }
                return randomSortedMap;
           }
           if(isProximitySort && sortedMap !=null){
             proximtySortedMap = new Map<Double,List<Partner_Location__c>>(); 
                for(Double key :sortedMap.keySet()){
                        if(sortedMap.get(key)!=null && sortedMap.get(key).size()>1){
                           proximtySortedMap.put(key,new UPL_ProximityCal().ProximitySearch(sortedMap.get(key),latitude,longitude));
                        }else{
                           proximtySortedMap.put(key,sortedMap.get(key));
                        }
                    }
              return proximtySortedMap;
           }
            logger('sortOnParameter Result ### :: '+sortedMap);
            logger('Exiting sortOnParameter ######## ');  
            return sortedMap;
        }    
        
      private List<Partner_Location__c> sortResellers(List<Partner_Location__c> searchedPartnerLocationList,Set<Id> resultIdforSort,UPL_FilterCriteria filterCriteria ){
          logger('Entering sortResellers ######## '); 
          List<String> nonCarrierresellerCommunities = new List<String>{'Value Added Reseller','Direct Market Reseller','eTailer'};
          Double latitude;
          Double longitude;
          List<Partner_Location__c> finalSortedPartnerLocationList=null;
          
           if((filterCriteria.latLong!=null)&&(filterCriteria.latLong!='')) {
                logger('Lati-Long from G API:'+filterCriteria.latLong);
                String[] latilongiArray2=filterCriteria.latLong.split(',');
                latitude = Double.valueOf(latilongiArray2[0]);
                longitude = Double.valueOf(latilongiArray2[1]);   
            }else{ 
                latitude = 0.0;
                longitude = 0.0;  
            }
          
          if(filterCriteria.track!=SCADA && ((filterCriteria.region==regionNA && filterCriteria.track!=RADIO) || filterCriteria.region==regionLACR || (filterCriteria.region==regionAPAC && filterCriteria.track!=RADIO) || (filterCriteria.region==regionEMEA && filterCriteria.track!=RADIO ))){
            
                //Declare/Intilaise variables for  Program level Sort
                  List <Account> metalLevelAccountList = null;
                  Set<Double> distinctProgramlevel=null;
                  Map<Id,Double> accountProgramLevelMap=new Map<Id,Double>();
                  Map<Double,List<Partner_Location__c>> finalSortedMap=new Map<Double,List<Partner_Location__c>>();
                  
                  //Declare/Intilaise variables for  Tech Spl level Sort
                  List<Technology_Specialization__c> nonCarriertechSplLevelList=null;
                  List<Technology_Specialization__c> carrierTechSplLevelList=null;
                  Map<Id,Double> accountTechLevelMap=null;
                  Set<Double> distinctTechlevel=null;
                  
                  metalLevelAccountList = [Select Metal_Level_Sort__c,ID from Account where Id in :resultIdforSort  order by Metal_Level_Sort__c asc limit 10000];
                  nonCarriertechSplLevelList = [Select Account__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and  Community_Type__c IN :nonCarrierresellerCommunities order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
                  carrierTechSplLevelList = [Select Account__c,Account__r.Metal_Level_Sort__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and Community_Type__c='Carrier' order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
                  
                  if(metalLevelAccountList!=null && metalLevelAccountList.size()>0){
                      distinctProgramlevel=new Set<Double>();
                      for(Account acc:metalLevelAccountList) {
                           accountProgramLevelMap.put(acc.Id,acc.Metal_Level_Sort__c );      
                           distinctProgramlevel.add(acc.Metal_Level_Sort__c);
                      }
                  }
                  
                  if(nonCarriertechSplLevelList!=null && nonCarriertechSplLevelList.size()>0){
                        distinctTechlevel=new Set<Double>(); 
                        accountTechLevelMap=new Map<Id,Double>();
                        //finalSortedMap=new Map<Double,List<Partner_Location__c>>();
                        for(Technology_Specialization__c nonCarrier:nonCarriertechSplLevelList){
                            accountTechLevelMap.put(nonCarrier.Account__c,nonCarrier.sort_order__c);
                            distinctTechlevel.add(nonCarrier.sort_order__c);
                        }  
                    }   
                  if(carrierTechSplLevelList!=null && carrierTechSplLevelList.size()>0){
                        if(accountTechLevelMap==null){
                              accountTechLevelMap=new Map<Id,Double>();
                        }
                        if(distinctTechlevel==null){
                                distinctTechlevel=new Set<Double>(); 
                        }
                        for(Technology_Specialization__c carrier:carrierTechSplLevelList){
                            distinctTechlevel.add(1);
                            accountTechLevelMap.put(carrier.Account__c,1); // For carrier community,tech spl is assumed to be Elite spl
                            
                            if(filterCriteria.region==regionEMEA){
                                distinctProgramlevel.add(4);
                                accountProgramLevelMap.put(carrier.Account__c, 4);// For carrier-EMEA community,tech spl is assumed to be Authorized
                            }else{
                                distinctProgramlevel.add(2);
                                accountProgramLevelMap.put(carrier.Account__c, 2);// For carrier-NON-EMEA community,tech spl is assumed to be Gold
                            }                         
                        }  
                    }
                    
                   Map<Double,List<Partner_Location__c>> sortOnTechSplLevel = sortOnParameter(distinctTechlevel, searchedPartnerLocationList, accountTechLevelMap, false, false,latitude,longitude);
                    
                    for(Double techLevel:sortOnTechSplLevel.keySet()){
                        finalSortedMap.put(techLevel,convertMapToList(sortOnParameter(distinctProgramlevel,sortOnTechSplLevel.get(techLevel),accountProgramLevelMap,false,true,latitude,longitude)));
                    }
                    
                    finalSortedPartnerLocationList=convertMapToList(finalSortedMap);
                    
          }else if(filterCriteria.track!=SCADA && filterCriteria.region==regionEMEA && filterCriteria.track==RADIO){
                  List<Partner_Type__c> partnerLevelList=null;
                  Map<Id,Double> accountPartnerLevelMap=null;
                  Set<Double> distinctPartnerLevel=null;
                  partnerLevelList=[Select  ID,Account__c,sort_order_1__c from Partner_Type__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track order by sort_order_1__c  limit 10000];
                  
                  if(partnerLevelList!=null && partnerLevelList.size()>0){
                        accountPartnerLevelMap=new Map<Id,Double>();
                        distinctPartnerLevel=new Set<Double>();
                        for(Partner_Type__c partnerType:partnerLevelList){
                            accountPartnerLevelMap.put(partnerType.Account__c,partnerType.sort_order_1__c);
                            distinctPartnerLevel.add(partnerType.sort_order_1__c);
                        }
                        Map<Double,List<Partner_Location__c>> sortOnPartnerLevel = sortOnParameter(distinctPartnerLevel, searchedPartnerLocationList, accountPartnerLevelMap, false, true,latitude,longitude);
                        finalSortedPartnerLocationList=convertMapToList(sortOnPartnerLevel);
                  }
                  
         }else if(filterCriteria.region==regionNA && filterCriteria.track==RADIO){
             //Declare/Intilaise variables for  Tech Spl level Sort
              List<Technology_Specialization__c> nonCarriertechSplLevelList=null;
              List<Technology_Specialization__c> carrierTechSplLevelList=null;
              Map<Id,Double> accountTechLevelMap=new Map<Id,Double>();
              Set<Double> distinctTechlevel=null;
              
              nonCarriertechSplLevelList = [Select Account__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and  Community_Type__c IN :nonCarrierresellerCommunities order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
              carrierTechSplLevelList = [Select Account__c,Account__r.Metal_Level_Sort__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and Community_Type__c='Carrier' order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
              
              if(nonCarriertechSplLevelList!=null && nonCarriertechSplLevelList.size()>0){
                        distinctTechlevel=new Set<Double>(); 
                        
                        for(Technology_Specialization__c nonCarrier:nonCarriertechSplLevelList){
                            accountTechLevelMap.put(nonCarrier.Account__c,nonCarrier.sort_order__c);
                            distinctTechlevel.add(nonCarrier.sort_order__c);
                        }  
                    }   
              if(carrierTechSplLevelList!=null && carrierTechSplLevelList.size()>0){
                        if(distinctTechlevel==null){
                                distinctTechlevel=new Set<Double>(); 
                        }
                        for(Technology_Specialization__c carrier:carrierTechSplLevelList){
                            distinctTechlevel.add(1);
                            accountTechLevelMap.put(carrier.Account__c,1); // For carrier community,tech spl is assumed to be Elite spl
                        }  
                    }
                    
            Map<Double,List<Partner_Location__c>> sortOnTechLevel = sortOnParameter(distinctTechlevel, searchedPartnerLocationList, accountTechLevelMap, false, true,latitude,longitude);
            finalSortedPartnerLocationList=convertMapToList(sortOnTechLevel);
            
        }else if(filterCriteria.region==regionAPAC && filterCriteria.track==RADIO){
              //Declare/Intilaise variables for  Program level Sort
              Map<Id,Double> accountProgramLevelMap=new Map<Id,Double>();
              Set<Double> distinctProgramLevelSet=new Set<Double>();
              
              //Declare/Intilaise variables for  Tech Spl level Sort
              List<Technology_Specialization__c> techSplNonCarrierLevelList=null;
              List<Technology_Specialization__c> techSplCarrierLevelList=null;
              Map<Id,Double> accountTechLevelMap=new Map<Id,Double>();
              Set<Double> distinctTechLevelSet=new Set<Double>();
              
              //Declare/Intilaise variables for  MEGO Sort
              List<Partner_Type__c> megoList=null;
              Map<Id,Double> accountMegoMap=new Map<Id,Double>();
              Set<Double> distinctMegoSet=null;
              
              Map<Double,List<Partner_Location__c>> sortedPartnerLocProgramLevel=null;
              
              List <Account> metalLevelAccountList = [Select Metal_Level_Sort__c,ID from Account where Id in :resultIdforSort  order by Metal_Level_Sort__c asc limit 10000];
             
              if(metalLevelAccountList!=null && metalLevelAccountList.size()>0){
                  for(Account acc:metalLevelAccountList) {
                   //Populate a map with the AccountId and Program Level Sort order
                       accountProgramLevelMap.put(acc.Id,acc.Metal_Level_Sort__c );      
                       distinctProgramLevelSet.add(acc.Metal_Level_Sort__c);
                         // distinctProgramLevelList.add(acc.Metal_Level_Sort__c);
                       
                  }
                  system.debug('Set of Metele Level : '+distinctProgramLevelSet);
                  
              }else{
                logger('Alert : Metal Level List is null');
              }
                 
            techSplNonCarrierLevelList = [Select Account__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and  Community_Type__c IN :nonCarrierresellerCommunities order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
            techSplCarrierLevelList = [Select Account__c,Account__r.Metal_Level_Sort__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and Community_Type__c='Carrier' order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
            
               if(techSplNonCarrierLevelList!=null && techSplNonCarrierLevelList.size()>0){
                     for(Technology_Specialization__c Tech:techSplNonCarrierLevelList){
                         accountTechLevelMap.put(Tech.Account__c,Tech.sort_order__c);
                         distinctTechLevelSet.add(Tech.sort_order__c); 
                    }  
                }
                if(techSplCarrierLevelList!=null && techSplCarrierLevelList.size()>0){
                    for(Technology_Specialization__c Tech:techSplCarrierLevelList){
                        distinctTechLevelSet.add(1);
                        accountTechLevelMap.put(Tech.Account__c,1); // For carrier community,tech spl is assumed to be Elite spl
                        
                        if(filterCriteria.region==regionEMEA){
                            distinctProgramLevelSet.add(4);
                            accountProgramLevelMap.put(Tech.Account__c, 4);// For carrier-EMEA community,tech spl is assumed to be Authorized
                        }else{
                            distinctProgramLevelSet.add(2);
                            accountProgramLevelMap.put(Tech.Account__c, 2);// For carrier-NON-EMEA community,tech spl is assumed to be Gold
                        }        
                    }
                    
                }
           
            megoList=[Select Account__c,Partner_Level__c,sort_order_1__c,Account__r.Mego_order__c from Partner_Type__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track order by Account__r.Mego_Order__c asc,sort_order_1__c asc limit 10000];
             if(megoList!=null && megoList.size()>0){
                distinctMegoSet=new  Set<Double>();
                accountMegoMap=new Map<Id,Double>();
                    for(Partner_Type__c m_ptc:megoList){ 
                        accountMegoMap.put(m_ptc.Account__c, m_ptc.Account__r.Mego_order__c);    
                        distinctMegoSet.add(m_ptc.Account__r.Mego_order__c);
                    }  
             } 
            // Sort logic needs to start here
             Map<Double,List<Partner_Location__c>> sortedPartnerLocMegoLevelTemp1=sortOnParameter(distinctTechLevelSet,searchedPartnerLocationList,accountTechLevelMap,false,false,latitude,longitude);
             Map<Double,List<Partner_Location__c>> sortedPartnerLocMegoLevelTemp2=new Map<Double,List<Partner_Location__c>>();
             Map<Double,List<Partner_Location__c>> finalMegoSortedMap=new Map<Double,List<Partner_Location__c>>();
            
             for(Double tempMap1:sortedPartnerLocMegoLevelTemp1.keySet()){
                sortedPartnerLocMegoLevelTemp2.put(tempMap1,convertMapToList(sortOnParameter(distinctProgramLevelSet,sortedPartnerLocMegoLevelTemp1.get(tempMap1),accountProgramLevelMap,false,false,latitude,longitude)));
             }  
             for(Double tempMap2:sortedPartnerLocMegoLevelTemp2.keySet()){
                finalMegoSortedMap.put(tempMap2,convertMapToList(sortOnParameter(distinctMegoSet,sortedPartnerLocMegoLevelTemp2.get(tempMap2),accountMegoMap,false,true,latitude,longitude)));
             }
             finalSortedPartnerLocationList=convertMapToList(finalMegoSortedMap);
            
        
        }else if(filterCriteria.track==SCADA ){
             finalSortedPartnerLocationList=new UPL_ProximityCal().ProximitySearch(searchedPartnerLocationList,latitude,longitude);
        }
        logger('Exiting  sortResellers ######## '); 
        return finalSortedPartnerLocationList;
     
    }
    
     private List<Partner_Location__c> sortDistributors(List<Partner_Location__c> searchedPartnerLocationList,Set<Id> resultIdforSort,UPL_FilterCriteria filterCriteria ){
        
      logger('Entering sortDistributors ######## '); 
      
      Double latitude;
      Double longitude;
      List<Partner_Location__c> finalSortedPartnerLocationList=new List<Partner_Location__c>();
      
       if((filterCriteria.latLong!=null)&&(filterCriteria.latLong!='')) {
            logger('Lati-Long from G API:'+filterCriteria.latLong);
            String[] latilongiArray2=filterCriteria.latLong.split(',');
            latitude = Double.valueOf(latilongiArray2[0]);
            longitude = Double.valueOf(latilongiArray2[1]);   
        }else{ 
            latitude = 0.0;
            longitude = 0.0;  
        }
        
        if(filterCriteria.region==regionEMEA && filterCriteria.track==RADIO){
              List<Partner_Type__c> partnerLevelList=null;
              Map<Id,Double> accountPartnerLevelMap=null;
              Set<Double> distinctPartnerLevel=null;
              partnerLevelList=[Select  ID,Account__c,sort_order_1__c from Partner_Type__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track order by sort_order_1__c  limit 10000];
              
              if(partnerLevelList!=null && partnerLevelList.size()>0){
                    accountPartnerLevelMap=new Map<Id,Double>();
                    distinctPartnerLevel=new Set<Double> ();
                    for(Partner_Type__c partnerType:partnerLevelList){
                        accountPartnerLevelMap.put(partnerType.Account__c,partnerType.sort_order_1__c);
                        distinctPartnerLevel.add(partnerType.sort_order_1__c);
                    }
                    Map<Double,List<Partner_Location__c>> sortOnPartnerLevel = sortOnParameter(distinctPartnerLevel, searchedPartnerLocationList, accountPartnerLevelMap, false, true,latitude,longitude);
                    finalSortedPartnerLocationList=convertMapToList(sortOnPartnerLevel);
              }
                  
        }else{
            //Community_Type__c ,Technology_Specialization__c 
            List<Technology_Specialization__c> vadDistributor= [Select ID,Account__C from Technology_Specialization__c where Community_Type__c= :community_VAD and Account__C in :resultIdforSort ];
            List<Technology_Specialization__c> subDistributor= [Select ID,Account__C from Technology_Specialization__c where Community_Type__c= :community_subDist and Account__C in :resultIdforSort ];
            List<Partner_Location__c> vadPartnerLocations=null;
            List<Partner_Location__c> subDistPartnerLocations=null;
            
            if(vadDistributor!=null && vadDistributor.size()>0){
                vadPartnerLocations=new List<Partner_Location__c>();
                for(Technology_Specialization__c valueAddedDist:vadDistributor){
                    for(Partner_Location__c vadLocation:searchedPartnerLocationList){
                        if(vadLocation.Account__C==valueAddedDist.Account__C){
                            vadPartnerLocations.add(vadLocation);
                        }
                    }
                }
            }
            if(subDistributor!=null && subDistributor.size()>0){
                subDistPartnerLocations=new List<Partner_Location__c>();
                for(Technology_Specialization__c subDist:subDistributor){
                    for(Partner_Location__c subDLocation:searchedPartnerLocationList){
                        if(subDLocation.Account__C==subDist.Account__C){
                            subDistPartnerLocations.add(subDLocation);
                        }
                    }
                }
            }
            
            if(vadPartnerLocations!=null && vadPartnerLocations.size()>0){
                finalSortedPartnerLocationList.addAll(new UPL_ProximityCal().ProximitySearch(vadPartnerLocations,latitude,longitude));
            }
            if(subDistributor!=null && subDistributor.size()>0){
                finalSortedPartnerLocationList.addAll(new UPL_ProximityCal().ProximitySearch(subDistPartnerLocations,latitude,longitude));
            }
        }
            
        logger('Exiting  sortDistributors ######## ');
        
        return finalSortedPartnerLocationList;
     }
     
      private List<Partner_Location__c> sortApplicationPartner(List<Partner_Location__c> searchedPartnerLocationList,Set<Id> resultIdforSort,UPL_FilterCriteria filterCriteria ){
        logger('Entering sortApplicationPartner ######## '); 
          Double latitude;
          Double longitude;
          List<Partner_Location__c> finalSortedPartnerLocationList=null;
          
           if((filterCriteria.latLong!=null)&&(filterCriteria.latLong!='')) {
                logger('Lati-Long from G API:'+filterCriteria.latLong);
                String[] latilongiArray2=filterCriteria.latLong.split(',');
                latitude = Double.valueOf(latilongiArray2[0]);
                longitude = Double.valueOf(latilongiArray2[1]);   
            }else{ 
                latitude = 0.0;
                longitude = 0.0;  
            }
        
          //Declare/Intilaise variables for  Program level Sort
          List <Account> metalLevelAccountList = null;
          Set<Double> distinctProgramlevel=null;
          Map<Id,Double> accountProgramLevelMap=new Map<Id,Double>();
          Map<Double,List<Partner_Location__c>> finalSortedMap=null;
          
          //Declare/Intilaise variables for  Tech Spl level Sort
          List<Technology_Specialization__c> techSplLevelList=null;
          Map<Id,Double> accountTechLevelMap=null;
          Set<Double> distinctTechlevel=null;
          
          metalLevelAccountList = [Select Metal_Level_Sort__c,ID from Account where Id in :resultIdforSort  order by Metal_Level_Sort__c asc limit 10000];
          techSplLevelList = [Select Account__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and  Community_Type__c ='Application Partner' order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
          
          if(metalLevelAccountList!=null && metalLevelAccountList.size()>0){
              distinctProgramlevel=new Set<Double>();
              for(Account acc:metalLevelAccountList) {
                   accountProgramLevelMap.put(acc.Id,acc.Metal_Level_Sort__c );      
                   distinctProgramlevel.add(acc.Metal_Level_Sort__c);
              }
          }
          
          if(techSplLevelList!=null && techSplLevelList.size()>0){
                distinctTechlevel=new Set<Double>(); 
                accountTechLevelMap=new Map<Id,Double>();
                finalSortedMap=new Map<Double,List<Partner_Location__c>>();
                for(Technology_Specialization__c techLevel:techSplLevelList){
                    accountTechLevelMap.put(techLevel.Account__c,techLevel.sort_order__c);
                    distinctTechlevel.add(techLevel.sort_order__c);
                }  
            }   
            
         Map<Double,List<Partner_Location__c>> sortOnTechSplLevel = sortOnParameter(distinctTechlevel, searchedPartnerLocationList, accountTechLevelMap, false, false,latitude,longitude);
            
            for(Double techLevel:sortOnTechSplLevel.keySet()){
                finalSortedMap.put(techLevel,convertMapToList(sortOnParameter(distinctProgramlevel,sortOnTechSplLevel.get(techLevel),accountProgramLevelMap,false,true,latitude,longitude)));
            }
        finalSortedPartnerLocationList=convertMapToList(finalSortedMap);
        logger('Exiting  sortApplicationPartner ######## ');
        return finalSortedPartnerLocationList;
      }
    
     private List<Partner_Location__c> sortFederalPartner(List<Partner_Location__c> searchedPartnerLocationList,Set<Id> resultIdforSort,UPL_FilterCriteria filterCriteria ){
     
      logger('Entering sortFederalPartner ######## '); 
          
          Double latitude;
          Double longitude;
          List<Partner_Location__c> finalSortedPartnerLocationList=null;
          
          if((filterCriteria.latLong!=null)&&(filterCriteria.latLong!='')) {
                logger('Lati-Long from G API:'+filterCriteria.latLong);
                String[] latilongiArray2=filterCriteria.latLong.split(',');
                latitude = Double.valueOf(latilongiArray2[0]);
                longitude = Double.valueOf(latilongiArray2[1]);   
           }else{ 
                latitude = 0.0;  
                longitude = 0.0;  
            }
          
          if(filterCriteria.location!=null && filterCriteria.country!=null){
            
            finalSortedPartnerLocationList=new UPL_ProximityCal().ProximitySearch(searchedPartnerLocationList,latitude,longitude);
          
          }else{
               //Declare/Intilaise variables for  Federal level Sort
              List <Partner_Type__c> federalLevelAccountList = null;
              Set<Double> distinctFederallevel=null;
              Map<Id,Double> accountFederalLevelMap=new Map<Id,Double>();
              Map<Double,List<Partner_Location__c>> groupFederalMap=new Map<Double,List<Partner_Location__c>>();
            
              
              //Declare/Intilaise variables for  Program level Sort
              List <Account> metalLevelAccountList = null;
              Set<Double> distinctProgramlevel=null;
              Map<Id,Double> accountProgramLevelMap=null;
              //groupFederalMap
              Map<Double,List<Partner_Location__c>> groupFederalTechMap=new Map<Double,List<Partner_Location__c>>();
             // Map<Double,List<Partner_Location__c>> finalSortedMap=null;
              
              //Declare/Intilaise variables for  Tech Spl level Sort
              List<Technology_Specialization__c> techSplLevelList=null;
              Map<Id,Double> accountTechLevelMap=null;
              Set<Double> distinctTechlevel=null;
              Map<Double,List<Partner_Location__c>> finalSortedMap=new Map<Double,List<Partner_Location__c>>();
                        
              federalLevelAccountList=[Select Account__c,Federal_Specialization_Sort__c from Partner_Type__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and US_Federal_Specialization__c!=null order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
              metalLevelAccountList = [Select Metal_Level_Sort__c,ID from Account where Id in :resultIdforSort  order by Metal_Level_Sort__c asc limit 10000];
              techSplLevelList = [Select Account__c,Technology_Specialization_Level__c,sort_order__c from Technology_Specialization__c where Account__c in :ResultIdforSort and Program__c =:filterCriteria.track and Technology_specialization__c=:filterCriteria.technology and Technology_Specialization_status__c='Active' and  Community_Type__c ='Application Partner' order by Account__r.Metal_Level_Sort__c,sort_order__c asc limit 10000];
              
               if(federalLevelAccountList!=null && federalLevelAccountList.size()>0){
                  distinctFederallevel=new Set<Double>();
                  for(Partner_Type__c federal:federalLevelAccountList) {
                       accountFederalLevelMap.put(federal.Account__c,federal.Federal_Specialization_Sort__c );      
                       distinctFederallevel.add(federal.Federal_Specialization_Sort__c);
                  }
               }
              
              if(metalLevelAccountList!=null && metalLevelAccountList.size()>0){
                  distinctProgramlevel=new Set<Double>();
                  accountProgramLevelMap=new Map<Id,Double>();
                  for(Account acc:metalLevelAccountList) {
                       accountProgramLevelMap.put(acc.Id,acc.Metal_Level_Sort__c );      
                       distinctProgramlevel.add(acc.Metal_Level_Sort__c);
                  }
               }
              
              if(techSplLevelList!=null && techSplLevelList.size()>0){
                    distinctTechlevel=new Set<Double>(); 
                    accountTechLevelMap=new Map<Id,Double>();
                    finalSortedMap=new Map<Double,List<Partner_Location__c>>();
                    for(Technology_Specialization__c techLevel:techSplLevelList){
                        accountTechLevelMap.put(techLevel.Account__c,techLevel.sort_order__c);
                        distinctTechlevel.add(techLevel.sort_order__c);
                    }  
                }      
                   
              groupFederalMap=sortOnParameter(distinctFederallevel, searchedPartnerLocationList, accountFederalLevelMap, false, false , latitude, longitude);
               
              for(Double federal:groupFederalMap.keySet()){
                   groupFederalTechMap.put(federal,convertMapToList(sortOnParameter(distinctTechlevel,groupFederalMap.get(federal),accountTechLevelMap,false,false,latitude, longitude)));
               }
              boolean proximtyRequired= (filterCriteria.location==null && filterCriteria.country==null);
            
              for(Double federalLevel:groupFederalTechMap.keySet()){
                  finalSortedMap.put(federalLevel,convertMapToList(sortOnParameter(distinctProgramlevel,groupFederalTechMap.get(federalLevel),accountProgramLevelMap,proximtyRequired ? false:true,proximtyRequired,latitude, longitude)));
              } 
              
               finalSortedPartnerLocationList=convertMapToList(finalSortedMap);
          }
            
           return finalSortedPartnerLocationList;  
           
        }
        
         private List<Partner_Location__c> sortPartnersByName(List<Partner_Location__c> searchedResult){
              logger('Entering sortPartnersByName ######## '); 
              List<Partner_Location__c> sortedList=new List<Partner_Location__c>();
              Map<String,List<Partner_Location__c>> accountNamePartnerlistMap=new Map<String,List<Partner_Location__c>>();
              List<String> partnerNameList=new List<String>();
              for(Partner_Location__c partnerLocation:searchedResult){
                 if(accountNamePartnerlistMap.get(partnerLocation.Account__r.Name)==null){
                    accountNamePartnerlistMap.put(partnerLocation.Account__r.Name,new List<Partner_Location__c>());
                 }
                 accountNamePartnerlistMap.get(partnerLocation.Account__r.Name).add(partnerLocation);
              }
              partnerNameList.addAll(accountNamePartnerlistMap.keySet());
              partnerNameList.sort();
              for(String sortedName:partnerNameList){
                 sortedList.addAll(accountNamePartnerlistMap.get(sortedName));
              }
              logger('Exiting sortPartnersByName ######## '); 
              
              return sortedList;
              
         }
}