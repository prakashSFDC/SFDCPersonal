/*  
* File Name     : NonFederalSearchLogic  
* Description   : This class contains the Processing logic for the Non Federal Partners in UPL.
                  It also includes the Keyword search functionality of UPL.                   
* @author       : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     23-Apr-10   Infosys       Created
*   2.0     25-Feb-11   Infosys       Modified the Keyword Queries to process more than 200 records
*   2.1     14-Mar-11   Infosys       Modified Search logics to include Support/Advanced Service filter           
*/

public class NonFederalSearchLogic{
string query = null;
public Set<Id> validAccounts = null;
Set<Id> AccountsSetNonFed=new Set<Id>();
Set<Id> AccountsSetNonFedAPAC=new Set<Id>();
Set<Id> AccountIdKeyword=new Set<Id>();
Set<Id> AccountsSetNonFedNA=new Set<Id>();
String Federal_condition_2='Both';
String Federal_condition_3='Non Federal';

String Partner_Locator_Status='Active';
Set<Id> validAccountsSetKeyword=new Set<Id>();
Set<Id> validAccountsSetKeywordNonFed=new Set<Id>();
Set<Id> validAccountsSetNonFed = new Set<Id>();
Set<Id> Accid_Industry = new Set<Id>();
Set<Id> Accid_Solution = new Set<Id>();
Set<Id> validAccountsSetNonFedKeyword = new Set<Id>();
Set<Id> Accid_Products = new Set<Id>();
Set<Id> Accid_PartnerLevel = new Set<Id>();
Set<Id> Accid_Mego=new Set<Id>();
set<id> Accid_NarrowIndustry = new Set<Id>();
set<id> Accid_NarrowSolution = new Set<Id>();
set<id> Accid_NarrowService = new Set<Id>();
set<id> Accid_NarrowLevel = new Set<Id>();
List<Sales_Region__c> NASearch = new List<Sales_Region__c>();
Integer additionalBlocksFlag=0;
Integer flagIndustry=0;
Integer flagSolutions=0;
Integer flagPartnerLevel=0;
Integer flagIndustryNA=0;
Integer flagSolutionsNA=0;
Integer flagPartnerLevelNA=0;
Integer Flag_LevelGeneral=0;
Integer Flag_LevelChina=0;
Integer Flag_LevelKorea=0;
Integer Flag_LevelApac=0;
Integer Flag_LevelApacRADIO=0;

public String RegionOfPartner=null;
public String ProductLevel2Visibility=null;

//public String ProductLevel2VisibilityREG=null;

List<Account> NASearchProducts1 = new List<Account>();
List<Account> APACSearchProducts1 = new List<Account>();
List<Account> LASearchProducts1 = new List<Account>();
List<Product_Offered__c> NASearchProducts = new List<Product_Offered__c>();
List<Product_Offered__c> APACSearchProducts = new List<Product_Offered__c>();
List<Product_Offered__c> LAProducts = new List<Product_Offered__c>();
List<Product_Offered__c> APACProducts = new List<Product_Offered__c>();
List<Industry__c> NAIndustry = new List<Industry__c>();
List<Industry__c> APACIndustry = new List<Industry__c>();
List<Validated_Solution__c> NASolution = new List<Validated_Solution__c>();
List<Partner_Type__c> NAPartnerlevel = new List<Partner_Type__c>();
List<Technology_Specialization__c> TechPartnerlevel = new List<Technology_Specialization__c>();
List<Partner_Type__c> APACPartnerlevel = new List<Partner_Type__c>();
List<Partner_Location__c> LASearchTwoWay = new List<Partner_Location__c>();
List<Validated_Solution__c> APACSolution = new List<Validated_Solution__c>();
List<Account> resultset = new List<Account>();
List<Account> NonFedAccounts = new List<Account>();
List<Partner_Location__c> results= new List<Partner_Location__c>();
List<Industry__c> LAIndustry = new List<Industry__c>();
List<Validated_Solution__c> LASolution = new List<Validated_Solution__c>();
List<Partner_Type__c> LAPartnerlevel = new List<Partner_Type__c>();
List<Partner_Location__c> results_chunk; 
List<Id> FinalAccIdList;
boolean locationPublishFlag = true;
boolean PublishFlag = true;
Integer salesRegionResultFlag=0;

Integer NAFLAG_Ind=0;
Integer NAFLAG_Sol=0;
Integer NAFLAG_Level=0;
Integer LAFLAG_Ind=0;
Integer LAFLAG_Sol=0;
Integer LAFLAG_Level=0;
Integer EMEAFLAG_Ind=0;
Integer EMEAFLAG_Sol=0;
Integer EMEAFLAG_Level=0;

Integer APACFLAG_Serv=0;
Integer APACFLAG_Ind=0;
Integer APACFLAG_Sol=0;
Integer APACFLAG_Level=0;

Integer APACFLAG_Serv2=0;
Integer APACFLAG_Ind2=0;
Integer APACFLAG_Level2=0;

List<Id> accountsWithServices = new List<Id>();


//**NON FEDERAL PARTNERS *****/
Public Set<Id> NonFederalSearch(String Keyword,String ProductOffered,String PartnerName,String Region,String Products,List<String> ProductsLevel2ListNonFed,String Location,String[] IndustryShowLess,String[] IndustryShowMore,String[] PartnerLevelGeneral,String[] PartnerLevelChina,String[] ServicesShowLess,String[] Solutions,Boolean MEGO,Boolean ASCCheckbox,String Industry_Filter,List<String> Industry_FilterList,String Solutions_Filter,List<String> Solutions_FilterList,String Services_Filter,List<String> Services_FilterList,String Level_Filter,List<String> Level_FilterList,String[] PartnerLevelKorea, String[] PartnerLevelApac,String[] PartnerLevelApacRADIO, String[] ServicesShowMore,String productL2VisibilityREG,Boolean MobilityAdvCheckbox,Boolean MobilitySuppCheckbox,String TechSpecialization)
{
List<Id> TechIds = new List<Id>();
Set<Id> TechIdsSet = new Set<Id>();
System.debug('############TechSpecialization:'+TechSpecialization);

 if(TechSpecialization!=null)
{
   List<Technology_Specialization__c> accTechCon = [select Account__c from Technology_Specialization__c where Technology_Specialization__c =:TechSpecialization limit 8000];
   for(Technology_Specialization__c tec:accTechCon)
   {
     TechIds.add(tec.Account__c);
     TechIdsSet.add(tec.Account__c);
   }
   
   System.debug('#########TechIds'+TechIds);
   System.debug('#########TechIds.size'+TechIds.size());
   
   
 }

 
  
 System.debug('VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVproductL2VisibilityREG:'+productL2VisibilityREG);

 Id recPartnerAccId=null;       
 Integer indexRec=0;
RecordType[] accRecTypes = [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType='Account' and IsActive=true];
while(indexRec<accRecTypes.size()) 
 {
    if('Partner' == accRecTypes[indexRec].DeveloperName)
    {
       recPartnerAccId = accRecTypes[indexRec].Id;
    }
indexRec++;
}
Integer flag_IndustryNarrow=0;

Dependent_List__c[] depList=[select Dependent_List__c.Controller_Name__r.Name,Dependent_List__c.Controller_Name__r.Product_Visibility__c from Dependent_List__c
                                 where Country_Name__c=:Region limit 1];
if(depList.size()>0)
  {
    RegionOfPartner=depList[0].Controller_Name__r.Name;
    ProductLevel2Visibility = depList[0].Controller_Name__r.Product_Visibility__c;
    
    
  }  
if((ProductOffered.equals('WNS'))||(ProductOffered.equals('RADIO'))||(ProductOffered.equals('TETRA'))||(ProductOffered.equals('ASTRO')))
{
    
    additionalBlocksFlag=0;//Do not display the additional blocks.
}
else if(ProductOffered.equals('SCADA'))
     additionalBlocksFlag=1;//The product is SCADA.Product Level 2 is not visible.

else
    additionalBlocksFlag=2;//Enterprise Partners-Display the additionalblocks

//NEW CODE FOR ADVANCED/SUPPORT SERVICES
//Query the Partnertype object to get the list of accounts if Support/Advanced Service is selected.


System.debug('########SearchController1.MobilityAdvCheckbox:'+MobilityAdvCheckbox);
System.debug('########SearchController1.ASCCheckbox:'+ASCCheckbox);


String program1 = null;
if(ProductOffered.equals('WNS'))
program1 = 'WNS';
else if(ProductOffered.equals('RADIO')||ProductOffered.equals('TETRA')||ProductOffered.equals('ASTRO'))
program1 = 'RADIO'; 
else if(ProductOffered.equals('SCADA'))
program1 = 'SCADA';
else
program1 = 'Mobility';  
 
String quer123 = 'select Account__c from Partner_Type__c where Program__c=:program1';

if(MobilityAdvCheckbox==true)
quer123 = quer123 + ' and Advanced_Services__c=true';

if(MobilitySuppCheckbox==true)

quer123 = quer123 + ' and Support_Services__c=true';

 if(ASCCheckbox==true)

 quer123 = quer123 + ' and Authorized_Service_Center__c=true';

quer123 = quer123 + ' limit 10000';

List<Partner_Type__c> parts= Database.query(quer123);
for(Partner_Type__c parts1:parts)
accountsWithServices.add(parts1.Account__c);

System.debug('########SearchController1.ASCCheckbox:'+accountsWithServices.size());
//END OF NEW CODE FOR ADVANCED/SUPPORT SERVICES

//NEW CODE FOR AUTHORISED SERVICE CENTER 
//Query the Partnertype object to get the list of accounts if Authorized Service Center  is selected.

/*if(ASCCheckbox==true){

String quer1 = 'select Account__c from Partner_Type__c where Authorized_Service_Center__c=true';

List<Partner_Type__c> parts1= Database.query(quer1);
for(Partner_Type__c parts2:parts1)
accountsWithServices.add(parts2.Account__c);

}*/

//END OF NEW CODE FOR AUTHORISED SERVICE CENTER 


if(RegionOfPartner=='North America')
{
//product is Two Way Radio or WNS
if(additionalBlocksFlag == 0)
{  
    List<Sales_Territory__c> slsTerritory = new List<Sales_Territory__c>();  
    List<Territory_Master__c> territory =new List<Territory_Master__c>();
    List<String> territoryList= new List<String>();
    
    string locationConcat=null;
    if(Location!=null)
     Location = Location.trim();
   locationConcat='%'+Location+'%';
    if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
      System.debug('#######Value of Products!=null:');
   else
      System.debug('#######Value of Products IS = null:');
  
   String[] locationArray=null;
   locationArray = Location.split(',');
   String cityStateZipQuery = null;
   for(Integer i=0;i<locationArray.size();i++)
    {
        if(locationArray[i]!=null)
        locationArray[i] = locationArray[i].trim().replaceAll('^+(?!$)', '');
        
        
        if(i>=1)
         cityStateZipQuery = cityStateZipQuery + ' and CityStateZip__c like '+'\'%'+','+locationArray[i]+','+'%\'';
        else 
        cityStateZipQuery = '\'%'+','+locationArray[i]+','+'%\'';  
     }
     
   //NEW Sales Territory logic for RADIO ,US
  if((ProductOffered.equals('RADIO'))&&(Region.equals('United States')))
  {
     System.debug('######## CityStateZip:'+cityStateZipQuery);
    //Query the Territory master
    String querys = null;
    querys = 'select Territory_Code__c from Territory_Master__c where CityStateZip__c like '+cityStateZipQuery+' limit 5000';
    territory = Database.query(querys);
   if(territory.size()>0)
   {
     for(integer i=0;i<territory.size();i++)
     {
       territoryList.add(territory[i].Territory_Code__c);
     }
    //Query Sales Territory
    if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
     {
       if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
        slsTerritory = [select Account__c from Sales_Territory__c where Product_Offering__c =: ProductOffered and Territory_Code__c in:territoryList and Product__c in:ProductsLevel2ListNonFed  and Account__c in:accountsWithServices limit 7000];
       else
        slsTerritory = [select Account__c from Sales_Territory__c where Product_Offering__c =: ProductOffered and Territory_Code__c in:territoryList and Product__c in:ProductsLevel2ListNonFed  limit 7000];
     } 
    else
    {
     if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
      slsTerritory = [select Account__c from Sales_Territory__c where Product_Offering__c =: ProductOffered and Territory_Code__c in:territoryList and Account__c in:accountsWithServices limit 7000];
     else
      slsTerritory = [select Account__c from Sales_Territory__c where Product_Offering__c =: ProductOffered and Territory_Code__c in:territoryList limit 7000];
    }  
   }
     for(Sales_Territory__c NASls:slsTerritory)
     {
        validAccountsSetNonFed.add(NASls.Account__c);
     }
  }
   else if((ProductOffered.equals('RADIO'))&&(Region.equals('Canada')))
   {
     if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
     {
        String qur1=null;
        if(accountsWithServices.size()>0)
         qur1= 'Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed and CityStateZip__c like '+cityStateZipQuery+' and Account__c in:accountsWithServices limit 7000';
        else
         qur1= 'Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed and CityStateZip__c like '+cityStateZipQuery+' limit 7000';
        NASearch = Database.query(qur1);
     }
     else
     {
       String qur=null;
       if(accountsWithServices.size()>0)
        qur= 'Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered  and CityStateZip__c like '+cityStateZipQuery+' and Account__c in:accountsWithServices limit 7000';
       else
        qur= 'Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered  and CityStateZip__c like '+cityStateZipQuery+' limit 7000';
       NASearch = Database.query(qur);
     }
     for(Sales_Region__c NALocationSearch:NASearch)
     {
        validAccountsSetNonFed.add(NALocationSearch.Account__c);
     }
   
   }//End of Logic for Radio-Canada
     
  slsTerritory.clear();
  territoryList.clear(); 
   
}   
 
//If Scada   
   
  
//////for other products
}


else if(RegionOfPartner=='Latin America')
{


if(additionalBlocksFlag == 0)
{
    List<Partner_Location__c> LASearchTwoWay;
    if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
     LASearchTwoWay = [Select Account__c from Partner_Location__c where Country1__c =: Region  and Account__r.Partner_Locator_Status__c='Active' and Location_Publish_Flag__c=:locationPublishFlag and Account__c in:accountsWithServices limit 2000];
    else
     LASearchTwoWay = [Select Account__c from Partner_Location__c where Country1__c =: Region  and Account__r.Partner_Locator_Status__c='Active' and Location_Publish_Flag__c=:locationPublishFlag limit 2000];
    
    for(Partner_Location__c LALocationSearch:LASearchTwoWay)
    {
      AccountsSetNonFed.add(LALocationSearch.Account__c);
    }
     
     if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
       LAProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed and Account__c in:AccountsSetNonFed and Publish_Flag__c=true limit 2000];
     else
       LAProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered and Account__c in:AccountsSetNonFed and Publish_Flag__c=true limit 2000];
     
     for(Product_Offered__c LALocSearch:LAProducts)
      {
        validAccountsSetNonFed.add(LALocSearch.Account__c);
      } 
  }
//If the product is SCADA

//for all other products
}



else if(RegionOfPartner=='EMEA')
{
  
   //EMEA Sales Region Logic for Product RADIO
   if(ProductOffered.equals('RADIO')||ProductOffered.equals('TETRA')||ProductOffered.equals('ASTRO'))
   {
    
    List<Sales_Region__c> EASearch = null;
    if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
    { 
     if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
      EASearch=[Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed and Country__c =: Region and Account__c in:accountsWithServices limit 7000];
     else
      EASearch=[Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed and Country__c =: Region limit 7000];
    } 
    else
    {
      if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
       EASearch=[Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Country__c =: Region and Account__c in:accountsWithServices limit 7000];
      else
       EASearch=[Select Account__c from Sales_Region__c where Product_Offering__c =: ProductOffered and Country__c =: Region limit 7000];
    }
    for(Sales_Region__c EALocationSearch:EASearch)
    {
      validAccountsSetNonFed.add(EALocationSearch.Account__c);
    } 
     //If Sales Region data is found,then publish the location of these accounts
    if(EASearch!=null)
    {
      salesRegionResultFlag=1;  
    }
    else//Follow normal EMEA search as in case of WNS
    salesRegionResultFlag=0;
   } 

    else if(((additionalblocksflag == 0)&&(salesRegionResultFlag==0))|| (additionalblocksflag == 1))
    {
    List<Partner_Location__c> LASearch;
    if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
     LASearch = [Select Account__c from Partner_Location__c where Country1__c =: Region and Location_Publish_Flag__c=:locationPublishFlag and Account__c in:accountsWithServices limit 2000];
    else
      LASearch = [Select Account__c from Partner_Location__c where Country1__c =: Region and Location_Publish_Flag__c=:locationPublishFlag limit 2000];
    for(Partner_Location__c LALocationSearch:LASearch)
     {
      
        AccountsSetNonFed.add(LALocationSearch.Account__c);

     } 
    if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes'))
     LAProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered  and Product__c in:ProductsLevel2ListNonFed and account__c in: AccountsSetNonFed and Publish_Flag__c = true limit 2000];
    else
     LAProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered  and account__c in: AccountsSetNonFed and Publish_Flag__c=true  limit 2000];
    for(Product_Offered__c LALocSearch:LAProducts)
       {
         validAccountsSetNonFed.add(LALocSearch.Account__c);
       }
    }
    
                      
}

else if(RegionOfPartner=='APAC')
{
///Radio       
     
  
//For Scada
  
    
  //For all other products   
}

//***************code for other products in NA and LA
//Other Products and WNS in North America
if(((RegionOfPartner=='North America') && ((additionalBlocksFlag == 2)||(additionalBlocksFlag ==0 && ProductOffered.equals('WNS')))) || ((RegionOfPartner=='Latin America')&&(additionalBlocksFlag==2))||((RegionOfPartner=='APAC')&&(additionalBlocksFlag==2)) ||((RegionOfPartner=='EMEA')&&(additionalBlocksFlag==2)) || ((RegionOfPartner=='APAC')&&(ProductOffered.equals('WNS'))) || ((RegionOfPartner=='APAC')&&(ProductOffered.equals('RADIO'))) )
{
List<Partner_Location__c>  NASearch1 = new List<Partner_Location__c>();
if((Products!=null)&&(Products!='None')&&(productL2VisibilityREG=='Yes')&& (RegionOfPartner=='North America' && ProductOffered.equals('WNS')))
{
    if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
     NASearch1 = [Select Account__c from Partner_Location__c where Country1__c =: Region and account__c in (select account__c from Product_Offered__c where Product_offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed) and Location_Publish_Flag__c=:locationPublishFlag and Account__c in:accountsWithServices limit 9000];
    else 
     NASearch1 = [Select Account__c from Partner_Location__c where Country1__c =: Region and account__c in (select account__c from Product_Offered__c where Product_offering__c =: ProductOffered and Product__c in:ProductsLevel2ListNonFed) and Location_Publish_Flag__c=:locationPublishFlag limit 9000];
}   
 
 else
{
   if(MobilityAdvCheckbox==true || MobilitySuppCheckbox==true ||ASCCheckbox==true)
    NASearch1 = [Select Account__c from Partner_Location__c where Country1__c =: Region and account__c in (select account__c from Product_Offered__c where Product_offering__c =: ProductOffered) and Location_Publish_Flag__c=:locationPublishFlag and Account__c in:accountsWithServices limit 9000];
   else
    NASearch1 = [Select Account__c from Partner_Location__c where Country1__c =: Region and account__c in (select account__c from Product_Offered__c where Product_offering__c =: ProductOffered) and Location_Publish_Flag__c=:locationPublishFlag limit 9000]; 
 } 
//List<Partner_Location__c>  NASearch1 = [Select Account__c from Partner_Location__c where Country1__c =: Region and account__c in (select account__c from Product_Offered__c where Product_offering__c =: ProductOffered) and Location_Publish_Flag__c=:locationPublishFlag limit 9000];

 
 
 for(Partner_Location__c NALocationSearch:NASearch1)
{
    //For North America,Select only the Accounts which have Tech Specialization
     if(RegionOfPartner=='North America' && additionalBlocksFlag == 2 && TechSpecialization!=null)
     {
       if(TechIdsSet.contains(NALocationSearch.Account__c))
         AccountsSetNonFed.add(NALocationSearch.Account__c);
     }
     else
     {
     AccountsSetNonFed.add(NALocationSearch.Account__c);
     }
}

// if any of Services checkbox  selected
if(ServicesShowLess.size()!=0 || ServicesShowMore.size()!=0 )
{
  NASearchProducts1 = [Select id from Account where (tolabel(Services_Provided__c) in: ServicesShowLess or tolabel(Services_Provided__c) in: ServicesShowMore or Services_Provided__c in:ServicesShowMore or Services_Provided__c in:ServicesShowLess ) and Id in:AccountsSetNonFed and recordtypeid=:recPartnerAccId limit 10000];
for(Account accidproducts:NASearchProducts1)
  Accid_Products.add(accidproducts.Id); 
}
else
{
Accid_Products.clear();
Accid_Products = AccountsSetNonFed;
  
 }

 if(Services_Filter!=null)
{
    if(Services_FilterList.size()>0)
    {
       NASearchProducts1.clear();
       for(Integer i=0;i<Services_FilterList.size();i++)
      {
         if(i==0)
           NASearchProducts1 = [Select id from Account where (tolabel(Services_Provided__c) =:Services_FilterList[i] or Services_Provided__c =:Services_FilterList[i]) and Id in:Accid_Products and recordtypeid=:recPartnerAccId limit 10000];  
         else
         {
           Accid_NarrowService.clear();
           for(Account ServiceAcc:NASearchProducts1)
            Accid_NarrowService.add(ServiceAcc.Id);
           NASearchProducts1 = [Select Id from Account where (tolabel(Services_Provided__c) =:Services_FilterList[i] or Services_Provided__c =:Services_FilterList[i]) and Id in:Accid_NarrowService and recordtypeid=:recPartnerAccId limit 10000];  
         }
      }
      Accid_Products.clear();
      for(Account accidproducts:NASearchProducts1)
      {
        Accid_Products.add(accidproducts.Id);
        
      }
    }
}  

// If any of Industry checkbox is selected
if((IndustryShowLess.size()!=0)||(IndustryShowMore.size()!=0))
{
    flagIndustryNA=1;    
    NAIndustry = [Select Account__c from Industry__c where Account__c in: Accid_Products and (tolabel(Industry_Type__c) in: IndustryShowLess or tolabel(Industry_Type__c) in: IndustryShowMore or Industry_Type__c in: IndustryShowMore or Industry_Type__c in: IndustryShowLess) and Publish_Flag__c=true limit 10000];
    for(Industry__c accidindustry:NAIndustry)
    {
        Accid_Industry.add(accidindustry.Account__c);
        
    }
    
    NAFLAG_Ind=1;

}
else
{
   if(Industry_Filter!=null)
   {
     if(Industry_FilterList.size()>0)
     {
       flagIndustryNA=1;
     }
   }  
   NAFLAG_Ind=0;
}

    if(Industry_Filter!=null)
    {
    if(Industry_FilterList.size()>0)
    {
      NAIndustry .clear();
      for(Integer i=0;i<Industry_FilterList.size();i++)
      {
        if(i==0)
        {
          if(NAFLAG_Ind==1)
           NAIndustry = [Select account__c from Industry__c where account__c in : Accid_Industry and (tolabel(Industry_Type__c) =:Industry_FilterList[i] or Industry_Type__c =:Industry_FilterList[i]) and Publish_Flag__c=true limit 10000];  
          else
           NAIndustry = [Select account__c from Industry__c where (tolabel(Industry_Type__c) =:Industry_FilterList[i] or Industry_Type__c =:Industry_FilterList[i]) and Account__c in: Accid_Products and Publish_Flag__c=true limit 10000];  
        }
        else
          {
           Accid_NarrowIndustry.clear();
           for(Industry__c IndusAcc:NAIndustry)
            Accid_NarrowIndustry.add(IndusAcc.Account__c);
           NAIndustry = [Select account__c from Industry__c where account__c in : Accid_NarrowIndustry and (tolabel(Industry_Type__c) =:Industry_FilterList[i] or Industry_Type__c =:Industry_FilterList[i] ) and Publish_Flag__c=true limit 10000];  
          }
      } 
      Accid_Industry.clear();
      for(Industry__c accidindustry:NAIndustry)
        {
        Accid_Industry.add(accidindustry.Account__c);
        
        }
    }  
    }

// if any of Validated Solution checkbox selected
if(Solutions.size()!=0)
{
  flagSolutionsNA=1;
  List<Validated_Solution__c> NASolution = [Select Account__c from Validated_Solution__c where Account__c in:Accid_Products and (tolabel(Solution__c) in:Solutions or Solution__c in:Solutions) and Publish_Flag__c=true limit 10000];
  for(Validated_Solution__c accidsolution:NASolution)
    Accid_Solution.add(accidsolution.Account__c);
  
  NAFLAG_Sol = 1;
}  
else
{
     if(Solutions_FilterList!=null)
     {
         if(Solutions_FilterList.size()>0)
           flagSolutionsNA=1; 
     }
  NAFLAG_Sol=0;
}

  if(Solutions_FilterList!=null)
  {
   NASolution.clear();
   if(Solutions_FilterList.size()>0)
    {
      for(Integer i=0;i<Solutions_FilterList.size();i++)
      {
        if(i==0)
        {
            if(NAFLAG_Sol==1)
            NASolution = [Select account__c from Validated_Solution__c where account__c in : Accid_Solution and (tolabel(Solution__c) =:Solutions_FilterList[i] or Solution__c =:Solutions_FilterList[i]) and Publish_Flag__c=true limit 10000];  
           else 
            NASolution = [Select account__c from Validated_Solution__c where account__c in : Accid_Products and (tolabel(Solution__c) =:Solutions_FilterList[i] or Solution__c =:Solutions_FilterList[i]) and Publish_Flag__c=true limit 10000];
        }
        else
          {
           Accid_NarrowSolution.clear();
           for(Validated_Solution__c SolAcc:NASolution)
            Accid_NarrowSolution.add(SolAcc.Account__c);
           NASolution = [Select account__c from Validated_Solution__c where account__c in : Accid_NarrowSolution and (tolabel(Solution__c) =:Solutions_FilterList[i] or Solution__c =:Solutions_FilterList[i]) and Publish_Flag__c=true limit 10000];  
          }
      } 
      Accid_Solution.clear();
      for(Validated_Solution__c accidsolution:NASolution)
        {
        Accid_Solution.add(accidsolution.Account__c);
        }
    }
  }  

//For North America,query on Tech Specialization.For other regions use Partner Type object.   
if(RegionOfPartner!='North America')
{
// if any of Partner Level checkbox  selected 
if(PartnerLevelGeneral.size()>0 && RegionOfPartner!='North America')
  Flag_LevelGeneral=1;
if(PartnerLevelChina.size()>0)  
  Flag_LevelChina=1;
if(PartnerLevelKorea.size()>0)  
  Flag_LevelKorea=1;
if(PartnerLevelApac.size()>0)  
  Flag_LevelApac=1;  
if(PartnerLevelApacRADIO.size()>0)  
  Flag_LevelApacRADIO=1;   
    
  
if((Flag_LevelGeneral==1)||(Flag_LevelChina==1) || (Flag_LevelKorea==1) || (Flag_LevelApac==1)|| (Flag_LevelApacRADIO==1)) 

{
   NAFLAG_Level = 1;
   
   if(Flag_LevelGeneral==1)
      flagPartnerLevelNA=1;
   if(Flag_LevelChina==1)
      flagPartnerLevelNA=1;
   if(Flag_LevelKorea==1)
      flagPartnerLevelNA=1;
   if(Flag_LevelApac==1)
      flagPartnerLevelNA=1;
   if(Flag_LevelApacRADIO==1)
      flagPartnerLevelNA=1;   
   String NAPartnerLevelQuery=null;
   NAPartnerLevelQuery='select Account__c from Partner_Type__c where Account__c in:Accid_Products and (tolabel(Partner_Level__c) in:';
   if(Flag_LevelGeneral==1)
    NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelGeneral or Partner_Level__c in:PartnerLevelGeneral ';
   if(Flag_LevelChina==1)
   { 
       if(Flag_LevelGeneral==0)
        NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelChina or Partner_Level__c in:PartnerLevelChina';
       else
        NAPartnerLevelQuery = NAPartnerLevelQuery+' or tolabel(Partner_Level__c) in :PartnerLevelChina or Partner_Level__c in :PartnerLevelChina';      
   }
   if(Flag_LevelKorea==1)
   {
     if((Flag_LevelGeneral==0)&&(Flag_LevelChina==0))
        NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelKorea or Partner_Level__c in:PartnerLevelKorea';
       else
        NAPartnerLevelQuery = NAPartnerLevelQuery+' or tolabel(Partner_Level__c) in :PartnerLevelKorea or Partner_Level__c in:PartnerLevelKorea ';       
   }
   if(Flag_LevelApac==1)
   {
     if((Flag_LevelGeneral==0)&&(Flag_LevelChina==0)&&(Flag_LevelKorea==0))
        NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelApac or Partner_Level__c in :PartnerLevelApac';
       else
        NAPartnerLevelQuery = NAPartnerLevelQuery+' or tolabel(Partner_Level__c) in :PartnerLevelApac or Partner_Level__c in :PartnerLevelApac';        
   }
   if(Flag_LevelApacRADIO==1)
   {
     if((Flag_LevelGeneral==0)&&(Flag_LevelChina==0)&&(Flag_LevelKorea==0)&&(Flag_LevelApac==0))
        NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelApacRADIO or Partner_Level__c in :PartnerLevelApacRADIO';
       else
        NAPartnerLevelQuery = NAPartnerLevelQuery+' or tolabel(Partner_Level__c) in :PartnerLevelApacRADIO or Partner_Level__c in :PartnerLevelApacRADIO';        
   }
   NAPartnerLevelQuery = NAPartnerLevelQuery+ ' )'+' limit 1000';
   System.debug('###QUERY:'+NAPartnerLevelQuery);
   NAPartnerlevel = Database.query(NAPartnerLevelQuery);
   for(Partner_Type__c accidpartner:NAPartnerlevel)
      Accid_PartnerLevel.add(accidpartner.Account__c);
      
   
}     
else
{
  if(Level_Filter!=null)
  {
   if(Level_FilterList.size()>0)
      flagPartnerLevelNA=1;
  }    
   NAFLAG_Level = 0;

}

if(Level_Filter!=null)
{
    if(Level_FilterList.size()>0)
    {
     NAPartnerlevel.clear();
  
      for(Integer i=0;i<Level_FilterList.size();i++)
      {
        if(i==0)
        {
          if(NAFLAG_Level==1)
          NAPartnerlevel = [Select account__c from Partner_Type__c where account__c in : Accid_PartnerLevel and (tolabel(Partner_Level__c) =:Level_FilterList[i] or Partner_Level__c =:Level_FilterList[i]) and Status__C = 'Active'  limit 1000];  
          else
          NAPartnerlevel = [Select account__c from Partner_Type__c where account__c in : Accid_Products and (tolabel(Partner_Level__c) =:Level_FilterList[i] or Partner_Level__c =:Level_FilterList[i]) and Status__C = 'Active' limit 1000];
        
        }
        else
          {
           Accid_NarrowLevel.clear();
           for(Partner_Type__c LevelAcc:NAPartnerlevel)
            Accid_NarrowLevel.add(LevelAcc.Account__c);
           NAPartnerlevel = [Select account__c from Partner_Type__c where account__c in : Accid_NarrowLevel and (tolabel(Partner_Level__c) =:Level_FilterList[i] or Partner_Level__c =:Level_FilterList[i]) and Status__C = 'Active' limit 1000];  
          }
      } 
      Accid_PartnerLevel.clear();
      for(Partner_Type__c accidlevel:NAPartnerlevel)
        {
        Accid_PartnerLevel.add(accidlevel.Account__c);
        }
      }
}
}//End of Non-North America
//For North America ,Use Tech Specialization
else
{
// if any of Partner Level checkbox  selected 
if(PartnerLevelGeneral.size()>0 && RegionOfPartner=='North America')
  Flag_LevelGeneral=1;

    
  
if((Flag_LevelGeneral==1)) 

{
   NAFLAG_Level = 1;
   
   if(Flag_LevelGeneral==1)
      flagPartnerLevelNA=1;
   
   String NAPartnerLevelQuery=null;

   NAPartnerLevelQuery='select Account__c from Technology_Specialization__c where Account__c in:Accid_Products and (tolabel(Technology_Specialization_Level__c) in:';
   if(Flag_LevelGeneral==1)
    NAPartnerLevelQuery = NAPartnerLevelQuery+' PartnerLevelGeneral or Technology_Specialization_Level__c in:PartnerLevelGeneral ';
   
   NAPartnerLevelQuery = NAPartnerLevelQuery+ ' )'+' and Technology_specialization__c=:TechSpecialization limit 5000';

   System.debug('###QUERY:'+NAPartnerLevelQuery);
   TechPartnerlevel = Database.query(NAPartnerLevelQuery);
   for(Technology_Specialization__c accidpartner:TechPartnerlevel)
      Accid_PartnerLevel.add(accidpartner.Account__c);
      
   
}     
else
{
  if(Level_Filter!=null)
  {
   if(Level_FilterList.size()>0)
      flagPartnerLevelNA=1;
  }    
   NAFLAG_Level = 0;

}

if(Level_Filter!=null)
{
    if(Level_FilterList.size()>0)
    {
     TechPartnerlevel.clear();
  
      for(Integer i=0;i<Level_FilterList.size();i++)
      {
        if(i==0)
        {
          if(NAFLAG_Level==1)
          TechPartnerlevel = [Select account__c from Technology_Specialization__c where account__c in : Accid_PartnerLevel and (tolabel(Technology_Specialization_Level__c) =:Level_FilterList[i] or Technology_Specialization_Level__c =:Level_FilterList[i]) and  Technology_specialization__c=:TechSpecialization  limit 2000];  
          else
          TechPartnerlevel = [Select account__c from Technology_Specialization__c where account__c in : Accid_Products and (tolabel(Technology_Specialization_Level__c) =:Level_FilterList[i] or Technology_Specialization_Level__c =:Level_FilterList[i]) and Technology_specialization__c=:TechSpecialization limit 2000];
        
        }
        else
          {
           Accid_NarrowLevel.clear();
           for(Technology_Specialization__c LevelAcc:TechPartnerlevel)
            Accid_NarrowLevel.add(LevelAcc.Account__c);
           TechPartnerlevel = [Select account__c from Technology_Specialization__c where account__c in : Accid_NarrowLevel and (tolabel(Technology_Specialization_Level__c) =:Level_FilterList[i] or Technology_Specialization_Level__c =:Level_FilterList[i]) and Technology_specialization__c=:TechSpecialization limit 2000];  
          }
      } 
      Accid_PartnerLevel.clear();
      for(Technology_Specialization__c accidlevel:TechPartnerlevel)
        {
        Accid_PartnerLevel.add(accidlevel.Account__c);
        }
      }
}
}   

if((RegionOfPartner=='APAC')&& (ProductOffered=='RADIO'))
{   
if(MEGO == true)
{
   List<Account> MegoAccounts;

   MegoAccounts = [Select Id from Account where Mego_Status1__c!=null and Id in:Accid_Products and recordtypeid=:recPartnerAccId limit 2000];
  
  for(Account MEGOAcc:MegoAccounts)
   Accid_Mego.add(MEGOAcc.Id);
}
else
{  
    for(Id MegoUnchecked:Accid_Products)
      Accid_Mego.add(MegoUnchecked);  
}  
query = 'Select id from Account where id in:Accid_Mego';
if(flagIndustryNA == 1)
  query = query + ' and id in:Accid_Industry'; 
if(flagSolutionsNA == 1)
   query = query + ' and id in :Accid_Solution';    
if(flagPartnerLevelNA == 1)
  query = query + ' and id in:Accid_PartnerLevel'; 
    
resultset = Database.query(query);    
for(Account FinalAcclist:resultset)
   validAccountsSetNonFed.add(FinalAcclist.Id);   
}  

else
{   
query = 'Select id from Account where id in :Accid_Products';
if(flagIndustryNA == 1)
   query = query + ' and id in :Accid_Industry';
if(flagSolutionsNA == 1)
   query = query + ' and id in :Accid_Solution';   
 if(flagPartnerLevelNA == 1)
    query = query + ' and id in:Accid_PartnerLevel'; 
  
 query = query +' limit 9500';

resultset = Database.query(query);  
for(Account FinalAcclist:resultset)
  validAccountsSetNonFed.add(FinalAcclist.Id);
}
}

//************End of Code for other products

//************Begin Of Code for SCADA
if((RegionOfPartner=='North America' || RegionOfPartner=='Latin America' ||RegionOfPartner=='APAC' )&&(additionalBlocksFlag == 1))
{   
 
 List<Partner_Location__c> NASearchScada = [Select Account__c from Partner_Location__c where Country1__c =: Region and Location_Publish_Flag__c=:locationPublishFlag and Account__c in:accountsWithServices limit 9000];
for(Partner_Location__c NALocationSearch:NASearchScada)
  {
    AccountsSetNonFed.add(NALocationSearch.Account__c);    
  } 
   if((Products!=null)&&(Products!='None')&&(ProductL2VisibilityREG=='Yes'))
     NASearchProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered and account__c in:AccountsSetNonFed and Product__c in:ProductsLevel2ListNonFed and Publish_Flag__c = true limit 9000];
   else
     NASearchProducts = [Select Account__c from Product_Offered__c where Product_offering__c =: ProductOffered and account__c in:AccountsSetNonFed and Publish_Flag__c = true limit 9000];
for(Product_Offered__c NSearch:NASearchProducts)
{
    validAccountsSetNonFed.add(NSearch.Account__c);
}
}

//End of Code for SCADA


if(Keyword!=null)
{  
if(Keyword.length()>0)
{
String keywordTerm= null;

String keywordReplaced = Keyword.replaceAll('\\(',' \\( ');
keywordReplaced = keywordReplaced.replaceAll('\\)',' \\) ');
String[] keywordArray=keywordReplaced.split(' ');
for(Integer count=0;count<keywordArray.size();count++)
{   
 
  keywordArray[count]=keywordArray[count].replaceAll('\\s','');
  if(keywordArray[count]!=null)
{
  if(keywordArray[count].length()>0)  
 {
if(keywordTerm==null)    
 {         
   keywordArray[count]=keywordArray[count]+'*';
   keywordTerm=keywordArray[count];  
   
 } 
 else    
 {        
   if((keywordArray[count].equals('and'))||(keywordArray[count].equals('or'))||(keywordArray[count]=='(' )||(keywordArray[count]==')' )||(keywordArray[count].equals('AND'))||(keywordArray[count].equals('OR'))||(keywordArray[count].equals('Or'))||(keywordArray[count].equals('And')))     
    {
      keywordTerm=keywordTerm+' '+keywordArray[count]; 
      
    }      
   else        
   {              
     keywordArray[count]='*'+keywordArray[count]+'*';
     if((keywordArray[count-1]=='(' )||(keywordArray[count-1]== ')' ))
     {
        keywordTerm=keywordTerm+''+keywordArray[count];   
        
     } 
     else
      {  keywordTerm=keywordTerm+' '+keywordArray[count];  
         
      }
   }                    
 }
}
}
       
}
System.debug('#########KeywordTerm:'+keywordTerm);
System.debug('#######validAccountsSetNonFed:'+validAccountsSetNonFed);
System.debug('#######validAccountsSetNonFed:'+validAccountsSetNonFed.size());

List<List<SObject>> searchList=[FIND :keywordTerm in all fields returning Keyword__c(Account__c where Account__c IN :validAccountsSetNonFed)];
List<Keyword__c> accountsWithKeyWord = searchList[0];
for(Keyword__c accountkeyword:accountsWithKeyWord)
  AccountIdKeyword.add(accountkeyword.Account__c);
  
//BEGIN OF: NEW Code for Processsing Additional Records in Keyword(more than 200)  

Integer count=0;
  
for(Integer i=0;i<20;i++)
{
if(count>=200)
{ 
count = 0;
List<List<SObject>> searchList1=[FIND :keywordTerm in all fields returning Keyword__c(Account__c where Account__c IN :validAccountsSetNonFed and Account__c not in:AccountIdKeyword)];  
List<Keyword__c> accountsWithKeyWord1 = searchList1[0];  
for(Keyword__c accountkeyword1:accountsWithKeyWord1)
{
  AccountIdKeyword.add(accountkeyword1.Account__c);  
  count++;
}  
}
else
i=20;  
}  
  
  
  
  
  
//END OF: NEW Code for Processsing Additional Records in Keyword(more than 200)  
    
  
//NEW CODE FOR ACTIVE PROGRAM STATUS ONLY
String statusLevel = null;
if(ProductOffered.equals('RADIO')||ProductOffered.equals('TETRA')||ProductOffered.equals('ASTRO'))
  statusLevel = ' and PartnerStatus_RADIO__c =\'Active\' ';
else if(ProductOffered.equals('WNS'))
  statusLevel = ' and PartnerStatus_WNS__c =\'Active\' ';
else if(ProductOffered.equals('SCADA'))
  statusLevel = ' and PartnerStatus_SCADA__c =\'Active\' ';
else
  statusLevel = ' and Partner_Status_Mobility__c =\'Active\' ';
//END OF NEW CODE

String quer = null;

if(AccountIdKeyword!=null)  
{ 
 quer = 'Select Id from Account where (US_Federal_Partner__c =:Federal_condition_3 or US_Federal_Partner__c =:Federal_condition_2) and id in:AccountIdKeyword and recordtypeid=:recPartnerAccId and Partner_Locator_Status__c=:Partner_Locator_Status'; 
 //If Tech Specialization exists
if(TechSpecialization!=null)
{
  quer = quer + ' and Id in:TechIds limit 7000';
  System.debug('##########Query after Tech Specialization:'+quer );
  NonFedAccounts = Database.query(quer); 
 } 
 else
{ 
 quer = quer + statusLevel + ' limit 7000'; 
 System.debug('#########QUERY:'+quer); 
 NonFedAccounts = Database.query(quer);
}
}

else
{ 
  quer = 'Select Id from Account where (US_Federal_Partner__c =:Federal_condition_3 or US_Federal_Partner__c =:Federal_condition_2) and id           in:validAccountsSetNonFed and recordtypeid=:recPartnerAccId and Partner_Locator_Status__c=:Partner_Locator_Status'; 
  if(TechSpecialization!=null)
  {
   quer = quer + ' and Id in:TechIds';
   quer = quer + ' limit 7000';
   NonFedAccounts = Database.query(quer);
   System.debug('##########Query after Tech Specialization:'+quer ); 
  } 
  else
  {
  quer = quer + statusLevel + ' limit 7000';
  System.debug('#########QUERY:'+quer); 
  NonFedAccounts = Database.query(quer);
 }
}


for(Account accnt:NonFedAccounts)
{
   validAccountsSetKeyword.add(accnt.Id);
}

validAccounts = new Set<Id>(validAccountsSetKeyword);
}




}
else
{
//NEW CODE FOR ACTIVE PROGRAM STATUS ONLY
String statusLevel = null;
if(ProductOffered.equals('RADIO')|| ProductOffered.equals('TETRA') || ProductOffered.equals('ASTRO'))
  statusLevel = ' and PartnerStatus_RADIO__c =\'Active\' limit 7000';
else if(ProductOffered.equals('WNS'))
  statusLevel = ' and PartnerStatus_WNS__c =\'Active\' limit 7000';
else if(ProductOffered.equals('SCADA'))
  statusLevel = ' and PartnerStatus_SCADA__c =\'Active\' limit 4000 ';
else
  statusLevel = ' and Partner_Status_Mobility__c =\'Active\' limit 1800 ';
//END OF NEW CODE

String quer = null;
quer = 'Select Id from Account where (US_Federal_Partner__c =:Federal_condition_3 or US_Federal_Partner__c =:Federal_condition_2 or US_Federal_Partner__c         <>null ) and id in:validAccountsSetNonFed and recordtypeid=:recPartnerAccId and Partner_Locator_Status__c=:Partner_Locator_Status';

if(TechSpecialization!=null)
{
  quer = quer + ' and Id in:TechIds limit 4000';
  System.debug('##########Query after Tech Specialization:'+quer ); 
  NonFedAccounts = Database.query(quer);
} 
else
{
quer = quer + statusLevel;
System.debug('#########QUERY:'+quer);
NonFedAccounts = Database.query(quer);
}

for(Account accnt:NonFedAccounts)
{
   validAccountsSetKeyword.add(accnt.Id);
}   
validAccounts = new Set<Id>(validAccountsSetKeyword);    

} 
  System.debug('############Valid Accounts after Keyword funct in NONfedSLogic:'+validAccounts);
  return validAccounts;
}

public String calculatePartnerlink(String loc)
{
    String relatedResourcelinkPartner=null;
        if(loc!=null)
      loc=loc.trim();


    if(loc.equals('us-en')||loc.equals('US-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/staticfiles/Business/US-EN/ChannelPartners/homepage/index.html';
     
    //EMEA 
    else if(loc.equals('xu-en')||loc.equals('XU-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XU-EN/Motorola+Channel+Partners/?vgnextoid=512150699d62d110VgnVCM1000008806b00aRCRD&vgnextchannel=5faab10e9761b110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xn-en')||loc.equals('XN-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XN-EN/Motorola+Channel+Partners/?vgnextoid=b14435e7884fd110VgnVCM1000008806b00aRCRD&vgnextchannel=bb44a49420d0c110VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextnoice=1';
    else if(loc.equals('xc-en')||loc.equals('XC-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XC-EN/Motorola+Channel+Partners/?vgnextoid=512150699d62d110VgnVCM1000008806b00aRCRD&vgnextchannel=5faab10e9761b110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xm-en')||loc.equals('XM-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XM-EN/Motorola+Channel+Partners/?vgnextoid=372a325bca9fd110VgnVCM1000008406b00aRCRD&vgnextchannel=b758d0e8d9d0c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xe-en')||loc.equals('XE-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XE-EN/Motorola+Channel+Partners/?vgnextoid=1b182be33e30e110VgnVCM1000008406b00aRCRD&vgnextchannel=3b5573664ed0c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xf-en')||loc.equals('XF-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XF-EN/Channel+Partners';
    else if(loc.equals('ru-ru')||loc.equals('RU-RU'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/RU-RU/Motorola+Channel+Partners/';
    else if(loc.equals('pl-pl')||loc.equals('PL-PL'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/PL-PL/Motorola+Channel+Partners/';
    else if(loc.equals('xc-de')||loc.equals('XC-DE')||loc.equals('DE-XC')||loc.equals('de-xc'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XC-DE/Motorola+Channel+Partners/';
    else if(loc.equals('fr-fr')||loc.equals('FR-FR'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/FR-FR/Motorola+Channel+Partners/?vgnextoid=a29ac26efffcd110VgnVCM1000008406b00aRCRD&vgnextchannel=786a6a9eca71b110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('pk-en')||loc.equals('PK-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/PK-EN/Channel+Partners';
    
    //LATAM
    else if(loc.equals('xl-es')||loc.equals('XL-ES')||loc.equals('ES-XL')||loc.equals('es-xl'))
     //relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=432fe4abb63fd110VgnVCM1000008406b00aRCRD&vgnextchannel=268ee4abb63fd110VgnVCM1000008406b00aRCRD&appInstanceName=default';
     relatedResourcelinkPartner='http://motorolachannelpartner.com/main2/login.php?idiomaLogin=';
     
    else if(loc.equals('xl-en')||loc.equals('XL-EN')||loc.equals('EN-XL')||loc.equals('en-xl'))
     //relatedResourcelinkPartner='http://www.motorola.com/staticfiles/Business/US-EN/ChannelPartners/homepage/index.html';
     relatedResourcelinkPartner='http://motorolachannelpartner.com/main2/login.php?idiomaLogin=en';
    
    else if(loc.equals('pt-xl')||loc.equals('PT-XL')||loc.equals('XL-PT')||loc.equals('xl-pt'))
     relatedResourcelinkPartner='http://motorolachannelpartner.com/main2/login.php?idiomaLogin=br';
     
     
    //APAC
    else if(loc.equals('cn-zh')||loc.equals('CN-ZH')||loc.equals('ZH-CN')||loc.equals('zh-cn'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/CN-ZH/Channel+Partners';
    else if(loc.equals('tw-za')||loc.equals('TW-ZA')||loc.equals('ZH-TW')||loc.equals('zh-tw'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/TW-ZA/Channel+Partners';
    else if(loc.equals('jp-ja')||loc.equals('JP-JA')||loc.equals('JA-JP')||loc.equals('JA-JP'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/JP-JA/Channel_Partner_Program';
    else if(loc.equals('kr-ko')||loc.equals('KR-KO')||loc.equals('KO-KR')||loc.equals('ko-kr'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/KR-KO/Channel+Partners';
    else if(loc.equals('hk-en')||loc.equals('HK-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=c7a60aa7e0bde110VgnVCM1000008806b00aRCRD&vgnextchannel=769bb2716ae8e110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('th-en')||loc.equals('TH-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/TH-EN/Channel+Partners';
    else if(loc.equals('xp-en')||loc.equals('XP-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/XP-EN/Channel+Partners';
    else if(loc.equals('id-en')||loc.equals('ID-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/ID-EN/Channel+Partners';
    else if(loc.equals('ph-en')||loc.equals('PH-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/Business/PH-EN/Channel+Partners';
    else if(loc.equals('sg-en')||loc.equals('SG-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=9ff542398346d110VgnVCM1000008406b00aRCRD&vgnextchannel=3140ba83be60c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xa-en')||loc.equals('XA-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=c04913237c0bd110VgnVCM1000008406b00aRCRD&vgnextchannel=000c82060932c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('in-en')||loc.equals('IN-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=34a537f1dd27d110VgnVCM1000008406b00aRCRD&vgnextchannel=c0f29fcced32c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('my-en')||loc.equals('MY-EN'))
     relatedResourcelinkPartner='http://www.motorola.com/business/v/index.jsp?vgnextoid=f24909690527d110VgnVCM1000008406b00aRCRD&vgnextchannel=a2e006d6b452c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
else
    relatedResourcelinkPartner='http://www.motorola.com/staticfiles/Business/US-EN/ChannelPartners/homepage/index.html';
  return relatedResourcelinkPartner;
}
    
public String calculateContactlink(String loc)
{
    String relatedResourcelinkContact=null;
    if(loc!=null)
      loc=loc.trim();
    
    if(loc.equals('us-en')||loc.equals('US-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/US-EN/Pages/Contact_Us';
     
    //EMEA 
    else if(loc.equals('xu-en')||loc.equals('XU-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XU-EN/Pages/Contact_Us';
    else if(loc.equals('xn-en')||loc.equals('XN-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XN-EN/Pages/Contact_Us';
    else if(loc.equals('xc-en')||loc.equals('XC-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XC-EN/Pages/Contact_Us';
    else if(loc.equals('xm-en')||loc.equals('XM-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XM-EN/Pages/Contact_Us';
    else if(loc.equals('xe-en')||loc.equals('XE-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XE-EN/Pages/Contact_Us';
    else if(loc.equals('xf-en')||loc.equals('XF-EN'))
     relatedResourcelinkContact='http://www.motorola.com/Business/XF-EN/Pages/Contact_Us';
    else if(loc.equals('ru-ru')||loc.equals('RU-RU'))
     relatedResourcelinkContact='http://www.motorola.com/Business/RU-RU/Pages/Contact_Us';
    else if(loc.equals('pl-pl')||loc.equals('PL-PL'))
     relatedResourcelinkContact='http://www.motorola.com/Business/PL-PL/Pages/Contact_Us';
    else if(loc.equals('xc-de')||loc.equals('XC-DE')||loc.equals('DE-XC')||loc.equals('de-xc'))
    relatedResourcelinkContact='http://www.motorola.com/Business/XC-DE/Pages/Contact_Us';
    else if(loc.equals('fr-fr')||loc.equals('FR-FR'))
     relatedResourcelinkContact='http://www.motorola.com/Business/FR-FR/Pages/Contact_Us';
    else if(loc.equals('pk-en')||loc.equals('PK-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=a0a5621bb051f110VgnVCM1000008406b00aRCRD&vgnextchannel=4e6e57015296c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    
    else if(loc.equals('xl-es')||loc.equals('XL-ES')||loc.equals('es-xl')||loc.equals('ES-XL'))
     //relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=73d65be79f0dd110VgnVCM1000008806b00aRCRD&vgnextchannel=7dab81fc2e8bb110VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=f46421dbe55dd110VgnVCM1000008406b00aRCRD&vgnextchannel=6bf35753655dd110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('xl-en')||loc.equals('XL-EN')||loc.equals('en-xl')||loc.equals('EN-XL'))
     //relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=a4b4f9a81ad5f110VgnVCM1000008806b00aRCRD&vgnextchannel=0e2a1e867d81b110VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=1e4b0bd978e5f110VgnVCM1000008806b00aRCRD&vgnextchannel=69700bd978e5f110VgnVCM1000008806b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('pt-xl')||loc.equals('PT-XL')||loc.equals('xl-pt')||loc.equals('XL-PT'))
     //relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=e0f9bdd9ff0fe110VgnVCM1000008806b00aRCRD&appInstanceName=default';
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=21270bd978e5f110VgnVCM1000008806b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    
    
    else if(loc.equals('cn-zh')||loc.equals('CN-ZH')||loc.equals('zh-cn')||loc.equals('ZH-CN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=cf2da1205e226210VgnVCM1000008406b00aRCRD&vgnextchannel=dc8212409f18d110VgnVCM1000008806b00aRCRD&appInstanceName=default';
    else if(loc.equals('tw-za')||loc.equals('TW-ZA')||loc.equals('ZH-TW')||loc.equals('zh-tw'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=d0eff995ef226210VgnVCM1000008b06b00aRCRD&vgnextchannel=490aefab1eca1210VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('jp-ja')||loc.equals('JP-JA')||loc.equals('JA-JP')||loc.equals('ja-jp'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=0708fea5c2105210VgnVCM1000008406b00aRCRD&vgnextchannel=e3fbfea5c2105210VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('kr-ko')||loc.equals('KR-KO')||loc.equals('ko-kr')||loc.equals('KO-KR'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=08ee79eb91326210VgnVCM1000008b06b00aRCRD&vgnextchannel=f0b0cb68a0326210VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('hk-en')||loc.equals('HK-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=2f4e2da00edf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=ff6da3a720806210VgnVCM1000008b06b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('th-en')||loc.equals('TH-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=09aacd63bcdf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=b528f9264009e110VgnVCM1000008806b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('xp-en')||loc.equals('XP-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=861cd6a6404af110VgnVCM1000008406b00aRCRD&vgnextchannel=9a012249d659f110VgnVCM1000008806b00aRCRD&appInstanceName=default';
    else if(loc.equals('id-en')||loc.equals('ID-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=80f296146ddf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=f0b3ee9e2309e110VgnVCM1000008806b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('ph-en')||loc.equals('PH-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=f8fb2da00edf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=b8f73eeec709e110VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('sg-en')||loc.equals('SG-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=d588d8b0bbdf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=81a4a3a720806210VgnVCM1000008b06b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('xa-en')||loc.equals('XA-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=97f7f34e8adf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=9706145b3532c110VgnVCM1000008406b00aRCRD&appInstanceName=default&vgnextrefresh=1';
    else if(loc.equals('in-en')||loc.equals('IN-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=b4ff0b8be422e110VgnVCM1000008806b00aRCRD&vgnextchannel=e1b7838f5a32c110VgnVCM1000008406b00aRCRD&appInstanceName=default';
    else if(loc.equals('my-en')||loc.equals('MY-EN'))
     relatedResourcelinkContact='http://www.motorola.com/business/v/index.jsp?vgnextoid=bc44d8b0bbdf5210VgnVCM1000008b06b00aRCRD&vgnextchannel=f89c0819aa706210VgnVCM1000008b06b00aRCRD&appInstanceName=default&vgnextrefresh=1';
  else
   relatedResourcelinkContact='http://www.motorola.com/Business/US-EN/Pages/Contact_Us';
   return relatedResourcelinkContact;
}   
public List<Partner_Location__c> chunkresults(String query_search,Set<Id> FinalAccId,String Region,boolean locationPublishFlag)
{
results=new List<Partner_Location__c>();
results_chunk=new List<Partner_Location__c>();

FinalAccIdList = new List<Id>(FinalAccId);
String query_search1=null;
query_search1=query_search;
if (FinalAccId.size() > 2000)
          {
                integer newMax = 0;
                integer newBase = 0;
                while (newMax < FinalAccId.size())
                {
                    newBase = newMax;
                    newMax += 2000;
                    if (newMax > FinalAccId.size())
                        newMax = FinalAccId.size();
                    String[] localIds = new String[newMax];
                    integer idCounter = 0;
                    for(integer i = newBase; i < newMax; i++)
                    {
                        localIds[idCounter] = FinalAccIdList[i];
                        idCounter++;
                    }
               query_search = query_search1+' and Account__c in :localIds order by Account__c limit 7000';
               results_chunk.clear();
               results_chunk = Database.query(query_search);
                    idCounter = 0;

                      for(integer i = 0; i < results_chunk.size(); i++)
                      {
                        results.add(results_chunk[i]); 
                        //idCounter++;
                      }
                }
            }
            else
            {
                query_search = query_search+' and Account__c in :FinalAccId order by Account__c limit 7000';
                results = Database.query(query_search);
            }
            return results;
}
}