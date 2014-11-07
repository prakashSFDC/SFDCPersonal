/*  
* File Name      : UPL_PopulateDisplayResults
* Description    : This class creates wrapper class which will be used to display in result page                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-12    Nimesh           Created  
*   1.1     25-Sep-12    Nimesh           Modified for issues found during testing
*   
*/

public class UPL_PopulateDisplayResults{

    private String locale ;
    private String regionEMEA = 'EMEA';
    private String trackRadio = 'RADIO';
    private String trackScada = 'SCADA';
    private String appSpec = 'APP';
    private String techSpec = 'TECH';
    private String strRegion = null; // 
    
      
    /**
     * This method is used to populate the final 100 account details in the wrapper object
     * @author nimesh_sharma
     * @since 13-Sep-2012
     * @param sortedPartnerLocatorRecordsLimitedTo100- contains Partner_Location__c records limited to 100 
     * @return List<UPL_SearchResults> 
     */
    public List<UPL_SearchResults> finalListToDisplay(List<Partner_Location__c> sortedPartnerLocatorRecordsLimitedTo100, UPL_FilterCriteria filterCriteria){
        System.debug( '### Scripts Executed BEFORE finalListToDisplay ###'+Limits.getScriptStatements());
        List<UPL_SearchResults> resultOfAccountInformation = new List<UPL_SearchResults>();
        List<id> accountIdsList = new List<id>();
        UPL_SearchResults accountDetailedObject = new UPL_SearchResults(); 
        
        locale = filterCriteria.locale;
        strRegion = filterCriteria.region;
        logger(' locale : ' +locale + ' Region: ' +strRegion); 
        // get the mapping fr data in the wrapper class for name, address
        for(Partner_Location__c finalResults:sortedPartnerLocatorRecordsLimitedTo100)
        {
            accountDetailedObject = setResultDataForEachAccountDisplay(finalResults);
            resultOfAccountInformation.add(accountDetailedObject);   
        }
        
        // Get Account IDs of all the records from the 
        for(Partner_Location__c final100:sortedPartnerLocatorRecordsLimitedTo100)
        {
            accountIdsList.add(final100.account__c);
        } 
       
        getSpecializationDetails(resultOfAccountInformation, accountIdsList, appSpec);
        
        getSpecializationDetails(resultOfAccountInformation, accountIdsList, techSpec);
        
        getUSFederalSpecialization(resultOfAccountInformation, accountIdsList);
        
        getPartnerLevelOrType(resultOfAccountInformation, accountIdsList);
        
        getAuthorizedProductsOrProductLineOffered(resultOfAccountInformation, accountIdsList);
        
        getCommunities(resultOfAccountInformation, accountIdsList);
       
        System.debug( '### Scripts Executed AFTER finalListToDisplay ###'+Limits.getScriptStatements());
       
        return resultOfAccountInformation;
        
    }
    /**
     * This method set the data for address, partner name from the partner locator results
     * @author nimesh_sharma
     * @since 13-Sep-2012
     * @param accountDetail- contains single Partner_Location__c record 
     * @return UPL_SearchResults 
     */    
    public UPL_SearchResults setResultDataForEachAccountDisplay(Partner_Location__c accountDetail) {
        
        UPL_SearchResults searchResults = new UPL_SearchResults();
        
        searchResults.accountId=accountDetail.Account__c; 
        searchResults.accountName = accountDetail.Account__r.Name;
       // searchResults.accountLocalName = accountDetail.Account__r.NameLocal;
        
        //searchResults.latitude= accountDetail.latitude__c;
        //searchResults.longitude= accountDetail.longitude__c;
        if(accountDetail.latitude__c != null)
            searchResults.latitude= accountDetail.latitude__c;
        else
            searchResults.latitude = 0.000000000000000;
            
        if(accountDetail.longitude__c != null)
            searchResults.longitude= accountDetail.longitude__c;
        else
            searchResults.longitude = 0.000000000000000;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Address_Line1__c))
            searchResults.addressLine1 = accountDetail.Address_Line1__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Address_Line2__c))
            searchResults.addressLine2 = accountDetail.Address_Line2__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Address_Line3__c))
            searchResults.addressLine3 = accountDetail.Address_Line3__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.City__c))
            searchResults.city = accountDetail.City__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.State__c))
            searchResults.state = accountDetail.State__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Country1__c))
            searchResults.country = accountDetail.Country1__c;  
        
        if(!UPL_Utilities.isStringNull(accountDetail.Postal_code__c))
            searchResults.postalCode = accountDetail.Postal_code__c;            
       
        
        if(!UPL_Utilities.isStringNull(accountDetail.Phone__c))
            searchResults.phoneNumber = accountDetail.Phone__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Fax__c))
            searchResults.faxNumber = accountDetail.Fax__c;
        
        if(!UPL_Utilities.isStringNull(accountDetail.Account__r.Website_URL__c))
            searchResults.webUrl = accountDetail.Account__r.Website_URL__c;
        
        
        searchResults.address = '';
        if(!UPL_Utilities.isStringNull(searchResults.addressLine1))
            searchResults.address  = searchResults.addressLine1 +'<br/>';   
        
        if(!UPL_Utilities.isStringNull(searchResults.addressLine2))
            searchResults.address += searchResults.addressLine2 +'<br/>';
        
        if(!UPL_Utilities.isStringNull(searchResults.addressLine3))
            searchResults.address += searchResults.addressLine3 + '<br/>';
        
        if(!UPL_Utilities.isStringNull(searchResults.city))
            searchResults.address += searchResults.city +' <br/>';   
        
        if(!UPL_Utilities.isStringNull(searchResults.state))
            searchResults.address += searchResults.state +' <br/>';   
        
        if(!UPL_Utilities.isStringNull(searchResults.country))
            searchResults.address += searchResults.country +' <br/>';
        
        if(!UPL_Utilities.isStringNull(searchResults.postalCode))
            searchResults.address += searchResults.postalCode +' <br/>';
       
        if(!UPL_Utilities.isStringNull(searchResults.phoneNumber))
            searchResults.address += '<b>'+System.Label.Primary_Phone_Number+'</b> '+searchResults.phoneNumber+'<br/>';
            
        if(!UPL_Utilities.isStringNull(searchResults.faxNumber))
            searchResults.address += '<b>'+System.Label.Fax+'</b> '+searchResults.faxNumber+'<br/>'; 
        
        if(!UPL_Utilities.isStringNull(accountDetail.account__r.Metal_Level__c))
            searchResults.programLevel = accountDetail.account__r.Metal_Level__c+' ' + System.Label.Channel_Partner;
        
       // if(!UPL_Utilities.isStringNull(accountDetail.account__r.NameLocal))
          //  searchResults.accountLocalName = accountDetail.account__r.NameLocal;
        
        return searchResults;
    }

    /**
     * This method retrives Technology Specialisation or Application specialisation results for each record and add to the master wrapper data
     * @author nimesh_sharma
     * @since 13-Sep-2012
     * @param parentWrapperDataList- Contains wrapper records populated with address and name information
     * @param accountIdsList- Contains wrapper records populated with address and name information
     * @param technologyOrApplication- flag to check whether request is for Application or Technology Specialisation
     * @return List<UPL_SearchResults> 
     */     
    public List<UPL_SearchResults> getSpecializationDetails(List<UPL_SearchResults> parentWrapperDataList, List<id> accountIdsList, String technologyOrApplication){
       List<String> specializationCommunities = null;  
       if(technologyOrApplication == appSpec)
            specializationCommunities = new List<String>{'Application Partner'};        
       else if(technologyOrApplication == techSpec)
            specializationCommunities = new List<String>{'Value Added Reseller','Direct Market Reseller','eTailer'};
      
       List<Technology_Specialization__c> specResult = new List<Technology_Specialization__c>();
       Map<Id,List<String>> specResultMap = new Map<Id,List<String>>();
       
       specResult = [Select Account__c, tolabel(Technology_Specialization__c),tolabel(Technology_Specialization_Level__c) from Technology_Specialization__c where Account__c = :accountIdsList and (Technology_Specialization_Level__c!=null and Technology_Specialization_Level__c!='Open' and Technology_Specialization_Level__c!='Authorized')  and Technology_Specialization_Status__c='Active' and Community_Type__c IN :specializationCommunities  limit 1000];
    
       if(specResult!=null && specResult.size()>0){
            for(Technology_Specialization__c mapSpec:specResult){
                 if(specResultMap.get(mapSpec.account__c) == null){
                    specResultMap.put(mapSpec.Account__c,new List<String>());       
                 }
                 specResultMap.get(mapSpec.Account__c).add(mapSpec.Technology_Specialization__c + ' ' + mapSpec.Technology_Specialization_Level__c);
           }    
       }        
       
       for (UPL_SearchResults updateParentWrapper:parentWrapperDataList){
           if(technologyOrApplication == appSpec)
                updateParentWrapper.applicationSpecializations=removeDuplicateAndSort(specResultMap.get(updateParentWrapper.accountId));        
           else if(technologyOrApplication == techSpec)
                updateParentWrapper.technologySpecializations=removeDuplicateAndSort(specResultMap.get(updateParentWrapper.accountId));
               
       }
      logger(' Tech && App Specialization List : ' +parentWrapperDataList);  
      return parentWrapperDataList;
    }


    /**
     * This method retrives US Federal Specialisation results for each record and add to the master wrapper data
     * @author nimesh_sharma
     * @since 17-Sep-2012
     * @param parentWrapperDataList- Contains wrapper records populated with address and name information
     * @param accountIdsList- Contains wrapper records populated with address and name information
     * @return List<UPL_SearchResults> 
     */     
    public List<UPL_SearchResults> getUSFederalSpecialization(List<UPL_SearchResults> parentWrapperDataList, List<id> accountIdsList){
       
        List<Partner_Type__c> usFederalSpecResult = new List<Partner_Type__c>();
        Map<Id,List<String>> usFederalSpecResultMap = new Map<Id,List<String>>();
       
        usFederalSpecResult = [Select Account__c, tolabel(Program__c),tolabel(US_Federal_Specialization__c) from Partner_Type__c where Account__c = :accountIdsList and US_Federal_Specialization__c !=null and US_Federal_Specialization__c !='Open'  and Status__c='Active' limit 1000];
        
        if(usFederalSpecResult!=null && usFederalSpecResult.size()>0){
            for(Partner_Type__c mapUSFederalSpec:usFederalSpecResult){
                 if(usFederalSpecResultMap.get(mapUSFederalSpec.account__c) == null){
                    usFederalSpecResultMap.put(mapUSFederalSpec.account__c,  new List<String>());             
                 }
                 if(mapUSFederalSpec.Program__c!='Mobility')
                    usFederalSpecResultMap.get(mapUSFederalSpec.account__c).add(mapUSFederalSpec.Program__c +' ' + System.label.US_Federal +' ' + mapUSFederalSpec.US_Federal_Specialization__c);
                 else
                   usFederalSpecResultMap.get(mapUSFederalSpec.account__c).add(System.label.Mobile_Solutions +' ' + System.label.US_Federal +' ' + mapUSFederalSpec.US_Federal_Specialization__c);
            }   
        }    
        
        for (UPL_SearchResults updateParentWrapper:parentWrapperDataList){
            updateParentWrapper.usFederalSpecializations=removeDuplicateAndSort(usFederalSpecResultMap.get(updateParentWrapper.accountId));
        }
        logger(' US Federal Specialization List : ' +parentWrapperDataList); 
        return parentWrapperDataList;
    }

    /**
     * This method retrives Partner Level/Type results for each record and add to the master wrapper data
     * @author nimesh_sharma
     * @since 17-Sep-2012
     * @param parentWrapperDataList- Contains wrapper records populated with address and name information
     * @param accountIdsList- Contains wrapper records populated with address and name information
     * @return List<UPL_SearchResults> 
     */     
    public List<UPL_SearchResults> getPartnerLevelOrType(List<UPL_SearchResults> parentWrapperDataList, List<id> accountIdsList){
        
        List<Partner_Type__c> partnerLevelCheck = new List<Partner_Type__c>();
        List<Partner_Type__c> partnerLevelResultRadio = new List<Partner_Type__c>();
        List<Partner_Type__c> partnerLevelResultScada = new List<Partner_Type__c>();
        Map<Id,List<String>> partnerLevelResultMap = new Map<Id,List<String>>();
        List<id> accountIdsForPartnerLevelRadio = new List<id>(); 
        List<id> accountIdsForPartnerLevelScada = new List<id>();
        
        partnerLevelCheck = [Select Account__c, Program__c,Partner_Level__c from Partner_Type__c where Account__c = :accountIdsList and Partner_Level__c !=null and Status__c='Active' limit 1000];
        
        if(partnerLevelCheck!=null && partnerLevelCheck.size()>0){
            for(Partner_Type__c checkPartnerLevel:partnerLevelCheck){
                 if(strRegion == regionEMEA && checkPartnerLevel.Program__c == trackRadio){
                    accountIdsForPartnerLevelRadio.add(checkPartnerLevel.Account__c);        
                 }
                 if(checkPartnerLevel.Program__c == trackScada){
                    accountIdsForPartnerLevelScada.add(checkPartnerLevel.Account__c);        
                 }
            }   
        }
        
        // for EMEA Radio records get the partner level 
        partnerLevelResultRadio = [Select Account__c, tolabel(Program__c),tolabel(Partner_Level__c) from Partner_Type__c where Account__c = :accountIdsForPartnerLevelRadio and Program__c = :trackRadio];
        if(partnerLevelResultRadio!=null && partnerLevelResultRadio.size()>0){
            for(Partner_Type__c mapPartnerLevelRadio:partnerLevelResultRadio){
                 if(partnerLevelResultMap.get(mapPartnerLevelRadio.Account__c) == null){
                    partnerLevelResultMap.put(mapPartnerLevelRadio.Account__c, new List<String>());
                 }
                 partnerLevelResultMap.get(mapPartnerLevelRadio.Account__c).add(mapPartnerLevelRadio.Program__c + ' ' + mapPartnerLevelRadio.Partner_Level__c); 
             }  
        }
        
        // for SCADA get the partner level
        partnerLevelResultScada = [Select Account__c, tolabel(Program__c),tolabel(Partner_Level__c) from Partner_Type__c where Account__c = :accountIdsForPartnerLevelScada and Program__c = :trackScada];
        if(partnerLevelResultScada!=null && partnerLevelResultScada.size()>0){
            for(Partner_Type__c mapPartnerLevelScada:partnerLevelResultScada){
                 if(partnerLevelResultMap.get(mapPartnerLevelScada.Account__c) == null){
                    partnerLevelResultMap.put(mapPartnerLevelScada.Account__c, new List<String>());
                 }
                 partnerLevelResultMap.get(mapPartnerLevelScada.Account__c).add(mapPartnerLevelScada.Program__c + ' ' + mapPartnerLevelScada.Partner_Level__c); 
            }
        }
        for (UPL_SearchResults updateParentWrapper:parentWrapperDataList){
            updateParentWrapper.partnerLevelOrType=removeDuplicateAndSort(partnerLevelResultMap.get(updateParentWrapper.accountId));
        }
        logger(' Partner Level or type List : ' +parentWrapperDataList);
        return parentWrapperDataList;
    }
    /**
     * This method retrives Authorized Product List results for each record and add to the master wrapper data
     * @author nimesh_sharma
     * @since 17-Sep-2012
     * @param parentWrapperDataList- Contains wrapper records populated with address and name information
     * @param accountIdsList- Contains wrapper records populated with address and name information
     * @return List<UPL_SearchResults> 
     */     
    public List<UPL_SearchResults> getAuthorizedProductsOrProductLineOffered(List<UPL_SearchResults> parentWrapperDataList, List<id> accountIdsList){
        List<String> communities = new List<String>{'Application Partner','Value Added Reseller','Direct Market Reseller','eTailer','Carrier','Value Added Distributor','Sub-Distributor'};
        List<String> offerings = new List<String>{'P25 Systems','Radio Solutions','TETRA Systems'};
        Set<String> uniqueProducts=null; 
        
        List<Technology_Specialization__c> technologyCheck = new List<Technology_Specialization__c>();
        List<Product_Offered__c> productLinesOfferedPartnersEMEA = new List<Product_Offered__c>();
        List<Product_Offered__c> productLinesOfferedPartnersSCADA = new List<Product_Offered__c>();
        
        Map<Id,List<String>> authorizedProductMap = new Map<Id,List<String>>();
        Map<Id,List<String>> finalAuthorizedProductMap =null;
        
        technologyCheck = [Select Account__c, tolabel(Technology_Specialization__c),Technology_Specialization_Level__c, Program__c from Technology_Specialization__c where Account__c = :accountIdsList and (Technology_Specialization_Level__c!=null and Technology_Specialization_Level__c!='Open')  and Technology_Specialization_Status__c='Active' and Community_Type__c IN :communities  limit 1000];
        if(technologyCheck!=null && technologyCheck.size()>0){
              for(Technology_Specialization__c checkTechnologies:technologyCheck){
                if(authorizedProductMap.get(checkTechnologies.Account__c) == null){
                    authorizedProductMap.put(checkTechnologies.Account__c,new List<String>());             
                }
                authorizedProductMap.get(checkTechnologies.Account__c).add(checkTechnologies.Technology_Specialization__c);
              }
        }
        
        if(strRegion == regionEMEA){
            productLinesOfferedPartnersEMEA = [Select Account__c,tolabel(Product_offering__c) from Product_offered__c where Publish_Flag__c = true and Account__c =:accountIdsList and product_offering__c in : offerings limit 1000 ];
            if(productLinesOfferedPartnersEMEA!=null && productLinesOfferedPartnersEMEA.size()>0){
                for(Product_offered__c prodLineOfferedEmeaRadio:productLinesOfferedPartnersEMEA){
                        if(authorizedProductMap.get(prodLineOfferedEmeaRadio.Account__c) == null){
                            authorizedProductMap.put(prodLineOfferedEmeaRadio.Account__c,new List<String>());             
                        }
                        authorizedProductMap.get(prodLineOfferedEmeaRadio.Account__c).add(prodLineOfferedEmeaRadio.Product_offering__c);    
                }
            }
        }
        
        productLinesOfferedPartnersSCADA = [Select Account__c,tolabel(Product_offering__c) from Product_offered__c where Publish_Flag__c = true and Account__c =:accountIdsList and product_offering__c = :trackScada limit 1000 ];
        if(productLinesOfferedPartnersSCADA!=null && productLinesOfferedPartnersSCADA.size()>0){
            for(Product_offered__c prodLineOfferedScada:productLinesOfferedPartnersSCADA){
                 if(authorizedProductMap.get(prodLineOfferedScada.Account__c) == null){
                        authorizedProductMap.put(prodLineOfferedScada.Account__c,new List<String>());             
                 }
                 authorizedProductMap.get(prodLineOfferedScada.Account__c).add(trackScada);
            }
        }
        
        
        for (UPL_SearchResults updateParentWrapper:parentWrapperDataList){
            updateParentWrapper.authorizedProductsOrProductLineOffered=removeDuplicateAndSort(authorizedProductMap.get(updateParentWrapper.accountId));
        }   
        logger(' Authorized Products List : ' +parentWrapperDataList);
        return parentWrapperDataList;
     }
    
    /**
     * This method retrives Communities results for each record and add to the master wrapper data
     * @author nimesh_sharma
     * @since 18-Sep-2012
     * @param parentWrapperDataList- Contains wrapper records populated with address and name information
     * @param accountIdsList- Contains wrapper records populated with address and name information
     * @return List<UPL_SearchResults> 
     */     
    public List<UPL_SearchResults> getCommunities(List<UPL_SearchResults> parentWrapperDataList, List<id> accountIdsList){
       List<Technology_Specialization__c> communityResult = new List<Technology_Specialization__c>();
       List<String> commmunityList =new List<String>();       
       Map<Id,List<String>> communityResultMap = new Map<Id,List<String>>();
       
       communityResult = [Select Account__c, UPL_CommunityMarketTerm__c  from Technology_Specialization__c where Account__c = :accountIdsList and UPL_CommunityMarketTerm__c  !=null and UPL_CommunityMarketTerm__c  !='NONE' limit 1000];
       if(communityResult!=null && communityResult.size()>0){
            for(Technology_Specialization__c mapCommunitySpec:communityResult){   
                 String communityTerm = null;
                 if(communityResultMap.get(mapCommunitySpec.account__c) == null){
                    communityResultMap.put(mapCommunitySpec.account__c,new List<String>());           
                 }
                 
                 // since community term is a calculated field, checking for translations here
                 if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Value Added Reseller'){
                    communityTerm = System.Label.Value_Added_Reseller_Community;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Reseller'){
                    communityTerm = System.Label.Reseller;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Distributor'){
                    communityTerm = System.Label.Distributor;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Value Added Distributor'){
                    communityTerm = System.Label.Value_Added_Distributor;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Application Partner'){
                    communityTerm = System.Label.Application_Partner_Community;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'Carrier'){
                    communityTerm = System.Label.Carrier;
                 }else if(mapCommunitySpec.UPL_CommunityMarketTerm__c == 'None'){
                    communityTerm = System.Label.None_Community;
                 }else{
                    communityTerm = mapCommunitySpec.UPL_CommunityMarketTerm__c;
                 }
                 communityResultMap.get(mapCommunitySpec.account__c).add(communityTerm);
            }
       }
       
    
       for (UPL_SearchResults updateParentWrapper:parentWrapperDataList){
            updateParentWrapper.communities=removeDuplicateAndSort(communityResultMap.get(updateParentWrapper.accountId));
       }
       logger(' Communities List : ' +parentWrapperDataList);
       return parentWrapperDataList;
    }  
    
        /**
        * This method will remove duplicate from the input list and returns the sorted list
        * @author Sathish
        * @since 27-Sep-2012
        * @param input- contains duplicated/un-sorted string list
        * @return sortedList - sorted unique list
        */         
        public List<String> removeDuplicateAndSort(List<String> input){
            List<String> sortedList=null;
            if(input!=null && input.size()>0){
                sortedList=new List<String>();
                Set<String> uniqueStrings=new Set<String>();
                uniqueStrings.addAll(input);
             
                sortedList.addAll(uniqueStrings);
                sortedList.sort();
            }
           
            return sortedList;
        
        }
   /**
     * This method is used to print logs
     * to condition is detailed in code comments.
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     *
     */
    private void logger (String message ) {
        System.debug(message);
    }        
        
}