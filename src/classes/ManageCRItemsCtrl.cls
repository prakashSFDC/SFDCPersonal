/********************************************************************************* 
Name : ManageCRItemsCtrl
Created By : Hari Prakash
Created Date : 15 May 2014
Purpose : Apex Controller  Class to Manage CR Items on a Single View
*********************************************************************************/
public without sharing class ManageCRItemsCtrl  {

//  ------------------------------------------------------------------------------------------------------------------
//  Inner Classes
//  ------------------------------------------------------------------------------------------------------------------

     /**
     * @Desc:   Wrapper class for holding CR_Items__c
     * @Param:
     */
    public class cwFilter {
        public String field {get; set;}
        public String operator {get; set;}
        public String value {get; set;}
    }

     /**
     * @Desc:   Wrapper class for holding CR_Items__c
     * @Param:
     */
    public class cwFields {
        public String fieldName;
        public String fieldLabel;
        public String value {get; set;}
    }

     /**
     * @Desc:   Wrapper class for holding CR_Items__c
     * @Param:
     */
    public class cwCRItems {
        // CR_Items__c sobject
        public CR_Items__c item {get; private set;}
        // Unique Key
        public String uniqueKey {get; private set;}
        // Display Name
        public String displayName {get; private set;}
        // selected indicator
        public Boolean isSelected {get; set;}

        // Unique Key Hash
        public String uniqueKeyHash {get; private set;}
      
        /**
         * @Desc:   Class Constructor specifying initial values
         * @Param:  item the CR_Items__c sobject
         */
        public cwCRItems(CR_Items__c item) {
            this.item = item;
            this.isSelected = FALSE;
            this.uniqueKey = item.Type__c + '-' + item.Full_Name__c;
        }

        /**
         * @Desc:   Class Constructor specifying initial values
         * @Param:  item the CR_Items__c sobject
         */
        public cwCRItems(CR_Items__c item, String crName) {
            this.item = item;
            this.isSelected = FALSE;
            this.uniqueKey = item.Type__c + '-' + item.Full_Name__c;

            Blob input = Blob.valueOf(crName = item.Type__c + '-' + item.Full_Name__c);
            Blob bob = Crypto.generateDigest('MD5', input);
            this.uniqueKeyHash =  EncodingUtil.convertToHex(bob);
        }      
    }

//  ------------------------------------------------------------------------------------------------------------------
//  Static Constants
//  ------------------------------------------------------------------------------------------------------------------
 
    // TODO make this based on a field set
    private final Map<String, String> mapFields = new Map<String, String> {'Type'=>'Type__c', 'User Story'=>'User_Story__c', 'Status'=>'Status__c', 'Source'=>'Source__c', 'Requestor'=>'Requestor__c', 'Project'=>'Project__c', 'Code Check In Ids'=>'Checkin_Id__c'};
    private final Map<String, String> mapFieldsForUpdate = new Map<String, String> {'User Story'=>'User_Story__c', 'Status'=>'Status__c', 'Source'=>'Source__c', 'Requestor'=>'Requestor__c', 'Project'=>'Project__c', 'Code Check In Ids'=>'Checkin_Id__c'};

    private final String COMPONENT_WITH_PARENT_SOBJECT = 'CustomField,FieldSet,RecordType,ValidationRule,WebLink,WorkflowAlert,WorkflowFieldUpdate,WorkflowOutboundMessage,WorkflowRule,WorkflowTask,Layout'; 
    //private final String COMPONENT_WITH_PARENT = 'CustomField';
    public final String SELECT_OPTION_VALUE = 'SelectOption';
    public final String SELECT_OPTION_LABEL = '--Select Option--'; 
    public final Integer listLimit = 20;
    private final Set<String> LIST_COMPONENT_TYPE = new Set<String>{'ApexClass', 'ApexComponent', 'ApexPage', 'ApexTrigger', 'CustomApplication', 'CustomLabel', 'CustomObject', 'CustomTab', 'EmailTemplate', 'FieldSet', 'HomePageLayout', 'Layout', 'Queue', 'RecordType', 'ValidationRule', 'WebLink', 'Workflow', 'WorkflowAlert', 'WorkflowFieldUpdate', 'WorkflowRule'};
    private final String QUERY_STRING = 'Select Id, Name, CRI_Unique_ID__c, Requestor__c, Type__c, Full_Name__c, Component_Name__c, Component_Label__c, Component_Parent__c, Folder_Name__c, Checkin_Id__c, User_Story__c, Project__c, Status__c, Code_Reviewed__c, Change_Request__c, Parent_Object__c, Comment__c, Source__c, Is_API_Renamed__c, Is_Update__c From CR_Items__c'; 
    private final String ORDER_BY = ' Order By Type__c, Component_Name__c ';
    
    // current page number
    private Integer currentPageNbr = 1;

    // page size
    public Integer pageSize = 30;

    public final String SYSTEM_ERROR_MSG_PREFIX = System.Label.System_Error_Message_Prefix;
//  ------------------------------------------------------------------------------------------------------------------
//  Variable section
//  ------------------------------------------------------------------------------------------------------------------
    private List<String> listMetadataItems;
    public List<cwCRItems> listSelectedCRItems {get;set;}
    public List<cwCRItems> listAvailableCRItems {get;set;}
    //private Map<String, cwCRItems> mapSelectedCRItems;
    private Map<String, cwCRItems> mapComponentItems;
    private Map<String, cwCRItems> mapAvailableCRItems;
    private Map<String, cwFields> mapFieldFullName;

    public List<SelectOption> selectOptionsFields {get;set;}
    public List<SelectOption> selectOptionsFieldsUpdate {get;set;}
    public List<SelectOption> selectOptionsMetaDataItems {get;set;}
    public List<SelectOption> selectOptionsParentItems {get;set;}
    public Boolean hasParent {get;set;}
    public Boolean hasResults {get;set;}
    public Boolean overLimit {get;set;}
    public Boolean showSearchSection {get;set;}
    public Boolean showSearchPopUp {get;set;}
    public Boolean showFilters {get;private set;}
    public Boolean isReleaseCR {get;set;}

    public CR_Items__c crItemObj {get;set;}
    public CR_Items__c crItemFilterObj {get;set;}
    public CR_Items__c crItemForUpdate {get;set;}
    public CR__c crRecord {get;set;}

    public String selectedField {get;set;}
    public String selectedFieldUpdate {get;set;}
    public String selectedMetaDataItem {get;set;}
    public String selectedParentItem {get;set;}
    public String componentSearchCriteria {get;set;}
    public String componentSearchString {get;set;}
    public String operatorString {get;set;}

    private Set<String> setComponentTypeName = new Set<String>();
    private Set<String> setComponentUniqueId = new Set<String>();
    private Map<String, List<String>> mapOfMetaDataItems = new Map<String,list<String>>();

    private Map<String, String> mapComponent;
    private Map<String, String> mapParentComponent = new Map<String, String>();

    public String crItemsDefaultQueryStr;
    public String crItemsQueryStr;
    public String crObjectName;
    public String crParentName;
    public String default_message;
    public Id changeRequestId = ApexPages.currentPage().getParameters().get('Id'); //grab the Change Request ID

    // total pages
    public Integer totalPages {get; private set;}
    public Integer totalRowCount {get; private set;}

    // for query locator
    private ApexPages.StandardSetController criSetSetController = null;

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Class Constructor specifying initial values
     * @Param:  
     */
    public ManageCRItemsCtrl() {
        
        hasParent = FALSE;
        showSearchSection = FALSE;
        showSearchPopUp = FALSE;
        showFilters = FALSE;
        selectedField = 'NONE';
        selectedFieldUpdate = 'NONE';
        //selectOptionsMetaDataItems = getMetaData();

        List<CR__c> listCR = [SELECT Id, Name, Parent_CR__c, Parent_CR__r.Name, RecordTypeId, RecordType.Name FROM CR__c Where Id =:changeRequestId];
        if(listCR != null && !listCR.isEmpty()) {
            crRecord = listCR[0];
            crObjectName = crRecord.Name;
            crParentName = crRecord.Parent_CR__r.Name;
            isReleaseCR = 'Release'.equalsIgnoreCase(crRecord.RecordType.Name) ? TRUE : FALSE;
        }

        crItemObj = new CR_Items__c();
        crItemFilterObj = new CR_Items__c();
        crItemForUpdate = new CR_Items__c();
        /*
        List<CR_Items__c> CExList = [Select Id, Name, Requestor__c, Type__c, Full_Name__c, Component_Name__c, Component_Label__c, Component_Parent__c, Folder_Name__c,
                                    Checkin_Id__c, User_Story__c, Project__c, Status__c, Code_Reviewed__c, Change_Request__c,                                       
                                    Parent_Object__c,  Comment__c, Source__c, Is_API_Renamed__c, Is_Update__c 
                                    From CR_Items__c Where Change_Request__c =:changeRequestId Order By Type__c];
        */
        for(CR_Items__c crItem : [Select Id, CRI_Unique_ID__c From CR_Items__c Where Change_Request__c =:changeRequestId Order By Type__c]) {
            setComponentUniqueId.add(crItem.CRI_Unique_ID__c);
        }
        System.debug(LoggingLevel.INFO, 'setComponentUniqueId: ' + setComponentUniqueId);

        crItemsDefaultQueryStr = QUERY_STRING + ' Where Change_Request__c = \'' + changeRequestId + '\'' + ORDER_BY;
        crItemsQueryStr = crItemsDefaultQueryStr;
        System.debug(LoggingLevel.INFO, 'ManageCRItemsCtrl() crItemsDefaultQueryStr: ' + crItemsDefaultQueryStr);
        
        retrieveCRItemsList(crItemsDefaultQueryStr);
        /*
        List<CR_Items__c> listCRItems = database.query(queryStr.trim());                                    
        
        listSelectedCRItems = new List <cwCRItems>();
        mapSelectedCRItems = new Map<String, cwCRItems>();
        setComponentTypeName = new Set<String>();

        for (CR_Items__c crItem : listCRItems) {
            cwCRItems newCWItems = new cwCRItems(crItem);
            mapSelectedCRItems.put(newCWItems.uniqueKey, newCWItems);

            listSelectedCRItems.add(newCWItems);
            setComponentTypeName.add(newCWItems.uniqueKey);
        }
        */
        listAvailableCRItems = new List<cwCRItems>();

        hasResults = listAvailableCRItems != null && listAvailableCRItems.size() > 0 ? TRUE : FALSE;

        if(listAvailableCRItems != null && listAvailableCRItems.size() == listLimit + 1) {
            overLimit = TRUE;
            listAvailableCRItems.remove(listLimit);
        } else {
            overLimit = FALSE;
        }

        createOptionsFields();

        //mapOfMetaDataItems = getMapMetaDataItems(LIST_COMPONENT_TYPE);
        //System.debug(LoggingLevel.INFO, 'mapOfMetaDataItems:' + mapOfMetaDataItems);

    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    private String hashString(String stringToHash) {
        Blob input = Blob.valueOf(stringToHash);
        Blob bob = Crypto.generateDigest('MD5', input);
        return EncodingUtil.convertToHex(bob);
    }
//-----------------------------------------------------------------------------------------    
    
    public PageReference doshowHideSearchPopUp() {
        componentSearchString = null;
        selectedMetaDataItem = null;
        selectedParentItem = null;
        crItemObj = new CR_Items__c();

        listAvailableCRItems = new List <cwCRItems>();
        selectOptionsParentItems = new List<SelectOption>();
        mapParentComponent = new Map<String, String>();

        showSearchPopUp = !showSearchPopUp;         
        return null;        
    }  

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference refreshSearchField() {
        System.debug(LoggingLevel.INFO, 'refreshSearchField: ');
        try {
            crItemFilterObj = new CR_Items__c();
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }  

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference refreshMassUpdateField() {
        System.debug(LoggingLevel.INFO, 'refreshMassUpdateField: ');
        try {
            crItemForUpdate = new CR_Items__c();
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }  
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public void createOptionsFields() {
        
        selectOptionsFields = new List<SelectOption>();
        selectOptionsFields.add(new SelectOption(SELECT_OPTION_VALUE, SELECT_OPTION_LABEL));
        for(String fieldName : mapFields.keySet()) {
            selectOptionsFields.add(new SelectOption(mapFields.get(fieldName), fieldName));
        }
        
        selectOptionsFieldsUpdate = new List<SelectOption>();
        selectOptionsFieldsUpdate.add(new SelectOption(SELECT_OPTION_VALUE, SELECT_OPTION_LABEL));
        for(String fieldName : mapFieldsForUpdate.keySet()) {
            selectOptionsFieldsUpdate.add(new SelectOption(mapFieldsForUpdate.get(fieldName), fieldName));
        }
    } 
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference refreshParentComponentList() {
        try {
            getRefreshParentComponentList();
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public void getRefreshParentComponentList() {
        System.debug(LoggingLevel.INFO, 'selectedMetaDataItem:' + selectedMetaDataItem);
        System.debug(LoggingLevel.INFO, 'crItemObj:' + crItemObj);
        componentSearchString = null;
        //selectedParentItem = null;
        listAvailableCRItems = new List <cwCRItems>();
        selectOptionsParentItems = new List<SelectOption>();
        selectedMetaDataItem = crItemObj.Type__c;
        mapParentComponent = new Map<String, String>();
        showSearchSection  = FALSE;

        if(COMPONENT_WITH_PARENT_SOBJECT.containsIgnoreCase(selectedMetaDataItem)) {
            hasParent = TRUE;
            Boolean isParentMatch = FALSE;
            List<String> listSObject = new List<String>();
            List<Schema.SObjectType> schemaSObjectType = Schema.getGlobalDescribe().values();
        
            // Search every object in the getGlobalDescribe() map to check key prefixes
            for( Schema.SObjectType t :  schemaSObjectType) {
                Schema.DescribeSObjectResult descObject = t.getDescribe();
                String sObjectAPIName = descObject.getName();
                /*
                if(!(descObject.isCustomSetting()
                    || sObjectAPIName.toLowerCase().endsWith('tag') 
                    || sObjectAPIName.toLowerCase().endsWith('history')
                    || sObjectAPIName.toLowerCase().endsWith('feed')
                    || sObjectAPIName.toLowerCase().endsWith('share'))
                ) {
                    */
                if(!(sObjectAPIName.toLowerCase().endsWith('tag') || 
                    sObjectAPIName.toLowerCase().endsWith('history') || 
                    sObjectAPIName.toLowerCase().endsWith('feed') || 
                    sObjectAPIName.toLowerCase().endsWith('share'))
                ) {
                    String fullName = descObject.getLabel() + ' (' + sObjectAPIName + ')';
                    listSObject.add(fullName);
                    mapParentComponent.put(fullName, sObjectAPIName);
                    //selectOptionsParentItems.add(new SelectOption(sObjectAPIName, descObject.getLabel()));
                    //selectOptionsParentItems.add(new SelectOption(sObjectAPIName, sObjectAPIName));

                    if(sObjectAPIName.equalsIgnoreCase(selectedParentItem)) {
                        isParentMatch = TRUE;
                    }
                }
            }

            listSObject.sort();
            
            selectOptionsParentItems.add(new SelectOption(SELECT_OPTION_VALUE, SELECT_OPTION_LABEL));
            for(String sObjectName : listSObject) {
                selectOptionsParentItems.add(new SelectOption(mapParentComponent.get(sObjectName), sObjectName));
            }

            if(isParentMatch) {
                getRefreshComponentList();
            }
        } else if('EmailTemplate'.equalsIgnoreCase(selectedMetaDataItem)) {
            hasParent = TRUE;
            selectedParentItem = null;
            selectOptionsParentItems.add(new SelectOption(SELECT_OPTION_VALUE, SELECT_OPTION_LABEL));
            for(Folder folderObj : [SELECT AccessType, DeveloperName, Id, IsReadonly, Name, NamespacePrefix, Type FROM Folder WHERE Type = 'Email']) {
                selectOptionsParentItems.add(new SelectOption(folderObj.DeveloperName, folderObj.DeveloperName));
            }
        } else {
            hasParent = FALSE;
            selectedParentItem = null;
            getRefreshComponentList();
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference refreshComponentList() {
        try {
            getRefreshComponentList();
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public void getRefreshComponentList() {
        componentSearchString = null;
        listAvailableCRItems = new List <cwCRItems>();
        showSearchSection  = TRUE;

        listMetadataItems = getListMetadataItem(selectedMetaDataItem);
        updateAvailableList(FALSE);
        /*
        if(listMetadataItems != null && listMetadataItems.size() > 0) {
            hasResults = TRUE;
            for(Integer index = 0; index < listMetadataItems.size() && index < listLimit; index ++) {
                //listAvailableCRItems.add(new cwCRItems(new CR_Items__c(Change_Request__c = changeRequestId, Component_Name__c = listMetadataItems[index], ItemName__c = listMetadataItems[index], Type__c = selectedMetaDataItem, Parent_Object__c = selectedParentItem, Component_Parent__c = selectedParentItem), listMetadataItems[index]));
                cwCRItems cwCRItemsRecord = mapComponentItems.get(listMetadataItems[index]);
                if(cwCRItemsRecord != null ) {
                    listAvailableCRItems.add(new cwCRItems(cwCRItemsRecord.item));
                }
            }

            if(listMetadataItems.size() > listLimit) {
                overLimit = TRUE;
            } else {
                overLimit = FALSE;
            }
        } else {
            hasResults = FALSE;
        }
        */
        System.debug(LoggingLevel.INFO, 'listAvailableCRItems:' + listAvailableCRItems);
    }   

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference refreshFilteredResult() {
        try {
            updateAvailableList(TRUE);
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }

//-----------------------------------------------------------------------------------------------------------------------------------------
    /**
     * @Description:  
     * 
     * @Param:
     * 
     * @Return:
     */     
    public void updateAvailableList(Boolean isFilter) {
        System.debug(LoggingLevel.INFO, 'componentSearchString:' + componentSearchString);
        System.debug(LoggingLevel.INFO, 'selectedMetaDataItem:' + selectedMetaDataItem); 
        System.debug(LoggingLevel.INFO, 'selectedParentItem:' + selectedParentItem);

        System.debug(LoggingLevel.INFO, 'listAvailableCRItems:' + listAvailableCRItems);
        overLimit = FALSE;
        listAvailableCRItems = new List <cwCRItems>();
        if(listMetadataItems != null && listMetadataItems.size() > 0) {
            Integer index = 0;
            for(String mdItem : listMetadataItems) {

                if((isFilter == FALSE) ||
                    ('Contains'.equalsIgnoreCase(operatorString) && mdItem.containsIgnoreCase(componentSearchString)) ||
                    ('Equals'.equalsIgnoreCase(operatorString) && mdItem.equalsIgnoreCase(componentSearchString)) ||
                    ('StartsWith'.equalsIgnoreCase(operatorString) && mdItem.startsWithIgnoreCase(componentSearchString))
                ) {
                    cwCRItems newCWItem = wrapCRItem(mdItem);
                    newCWItem.displayName = mdItem;
                    if(newCWItem != null && !setComponentUniqueId.contains(newCWItem.item.CRI_Unique_ID__c)) {
                        index ++;
                        listAvailableCRItems.add(newCWItem); 
                        if(index == listLimit + 1) {
                            overLimit = TRUE;
                            listAvailableCRItems.remove(listLimit);
                            break;    
                        }
                    }
                }
            }
        } 
        
        hasResults = listAvailableCRItems != null && listAvailableCRItems.size() > 0 ? TRUE : FALSE;

        System.debug(LoggingLevel.INFO, 'listAvailableCRItems:' + listAvailableCRItems);

    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference addSelected() {
        /*
        if(listSelectedCRItems == null) {
            listSelectedCRItems = new List<cwCRItems>();
        }
        /*
        if(mapSelectedCRItems == null) {
            mapSelectedCRItems = new Map<String, cwCRItems>();
        }
        */
        List<CR_Items__c> listCRItemsAdd = new List<CR_Items__c>();

        for(cwCRItems cwItem : listAvailableCRItems) {
            if(cwItem.isSelected ==TRUE) {
                //listSelectedCRItems.add(new cwCRItems(cwItem.item));
                //mapSelectedCRItems.put(cwItem.uniqueKey, new cwCRItems(cwItem.item));
                listCRItemsAdd.add(cwItem.item);
                setComponentUniqueId.add(cwItem.item.CRI_Unique_ID__c);
            }
        }
        //System.debug(LoggingLevel.INFO, 'addSelected listSelectedCRItems:' + listSelectedCRItems);
        
        if(listCRItemsAdd != null && !listCRItemsAdd.isEmpty()) {
            // TODO: use upsert for this operation
            insert listCRItemsAdd;
            retrieveCRItemsList(crItemsDefaultQueryStr);
            updateAvailableList(TRUE);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select at least one component and then click on Add Selected.'));
        }
        
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference selectAllSearchSection() {
        System.debug(LoggingLevel.INFO, 'selectAllSearchSection listAvailableCRItems:' + listAvailableCRItems);

        for(cwCRItems cwItem : listAvailableCRItems) {
            cwItem.isSelected = TRUE;
        }
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference deSelectAllSearchSection() {
        System.debug(LoggingLevel.INFO, 'deSelectAllSearchSection listAvailableCRItems:' + listAvailableCRItems);

        for(cwCRItems cwItem : listAvailableCRItems) {
            cwItem.isSelected = FALSE;
        }
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference moveSelectedToReleaseCR() {
        System.debug(LoggingLevel.INFO, 'moveSelectedToReleaseCR listSelectedCRItems:' + listSelectedCRItems);
        try {
            List<CR_Items__c> listSelCRItems = new List<CR_Items__c>();

            for(cwCRItems cwItem : listSelectedCRItems) {
                if(cwItem.isSelected == TRUE) {
                    listSelCRItems.add(cwItem.item);
                }
            }
            System.debug(LoggingLevel.INFO, 'moveSelectedToReleaseCR listSelCRItems:' + listSelCRItems);
            if(listSelCRItems != null && !listSelCRItems.isEmpty()) {
                moveToReleaseCR(listSelCRItems);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select at least one component and then click on Move Selected.'));
            } 

        } catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage()));
        }       
        return null; 
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference moveAllToReleaseCR() {
        
        try {
            moveToReleaseCR(database.query(crItemsDefaultQueryStr.trim()));
        } catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage()));
        }
        return null; 
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */
    private void moveToReleaseCR(List<CR_Items__c> listCRItems) {

        System.debug(LoggingLevel.INFO, 'moveToReleaseCR listCRItems:' + listCRItems);
        
        if(listCRItems != null && !listCRItems.isEmpty()) {
            List<CR_Items__c> listCRItemsMove= new List<CR_Items__c>();
            for(CR_Items__c crItem : listCRItems) {
                CR_Items__c crItemNew = new CR_Items__c(Status__c = crItem.Status__c,
                    Type__c = crItem.Type__c,
                    Project__c = crItem.Project__c, 
                    Requestor__c = crItem.Requestor__c,
                    Full_Name__c = crItem.Full_Name__c,
                    Checkin_Id__c = crItem.Checkin_Id__c, 
                    User_Story__c = crItem.User_Story__c,
                    Change_Request__c = crRecord.Parent_CR__c, 
                    Component_Name__c = crItem.Component_Name__c, 
                    Component_Label__c = crItem.Component_Label__c,
                    Component_Parent__c = crItem.Component_Parent__c);
                crItemNew.CRI_Unique_ID__c = DeploymentTrackerCommon.calculateHashCriUniqueId(crParentName, crItem);
                listCRItemsMove.add(crItemNew);
            }
            System.debug(LoggingLevel.INFO, 'listCRItemsMove:' + listCRItemsMove);
            upsert listCRItemsMove CRI_Unique_ID__c;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Moved Successfully to Main Release ' + listCRItemsMove.size() + ' Records.'));
        } 
    } 
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference filterRecords() {

        System.debug(LoggingLevel.INFO, 'selectedField: ' + selectedField);
        System.debug(LoggingLevel.INFO, 'crItemFilterObj: ' + crItemFilterObj);
        String whereStr = ' Where Change_Request__c = \'' + changeRequestId + '\'';
        Boolean isFilterValid = FALSE;
        if(!SELECT_OPTION_LABEL.equalsIgnoreCase(selectedField)) {
            if('Type__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Type__c != null) {
                whereStr += ' And Type__c = \'' + crItemFilterObj.Type__c + '\'';
                isFilterValid = TRUE;
            } else if('Requestor__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Requestor__c != null) {
                whereStr += ' And Requestor__c = \'' + crItemFilterObj.Requestor__c + '\'';
                isFilterValid = TRUE;
            } else if('Status__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Status__c != null) {
                whereStr += ' And Status__c = \'' + crItemFilterObj.Status__c + '\'';
                isFilterValid = TRUE;
            } else if('Source__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Source__c != null) {
                whereStr += ' And Source__c = \'' + crItemFilterObj.Source__c + '\'';
                isFilterValid = TRUE;
            } else if('Project__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Project__c != null) {
                whereStr += ' And Project__c = \'' + crItemFilterObj.Project__c + '\'';
                isFilterValid = TRUE;
            } else if('Checkin_Id__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.Checkin_Id__c != null) {
                whereStr += ' And Checkin_Id__c = \'' + crItemFilterObj.Checkin_Id__c + '\'';
                isFilterValid = TRUE;
            } else  if('User_Story__c'.equalsIgnoreCase(selectedField) && crItemFilterObj.User_Story__c != null) {
                whereStr += ' And User_Story__c = \'' + crItemFilterObj.User_Story__c + '\'';
                isFilterValid = TRUE;
            }

            /*
            List<CR_Items__c> listCRItemsFiltered = database.query(queryStr.trim()); 
            
            listSelectedCRItems = new List <cwCRItems>();

            for (CR_Items__c crItem : listCRItemsFiltered) {
                cwCRItems newCWItems = new cwCRItems(crItem);
                listSelectedCRItems.add(newCWItems);
            }
            */
        }

        crItemsQueryStr = QUERY_STRING + whereStr + ORDER_BY;

        System.debug(LoggingLevel.INFO, 'filterRecords() crItemsQueryStr: ' + crItemsQueryStr);
        retrieveCRItemsList(crItemsQueryStr);
        /*
        if(isFilterValid) {
            retrieveCRItemsList(queryStr);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select the field and the value and then click on Filter Records.'));
        }
        */

        return null; 
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference massUpdateSelected() {

        try {
            
            List<CR_Items__c> listCRItemsForUpdate = new List<CR_Items__c>();

            for(cwCRItems cwItem : listSelectedCRItems) {
                if(cwItem.isSelected == TRUE) {
                    listCRItemsForUpdate.add(cwItem.item);
                }
            }

            if(listCRItemsForUpdate != null && !listCRItemsForUpdate.isEmpty()) {
                massUpdateCRItems(listCRItemsForUpdate);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select at least one component and then click on Mass Update Selected.'));
            }

        } catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage()));
        }
        
        return null;
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference massUpdateAllCRItems() {
        
        try {
            massUpdateCRItems(database.query(crItemsQueryStr.trim()));
            retrieveCRItemsList(crItemsQueryStr);
        } catch (Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, SYSTEM_ERROR_MSG_PREFIX + ex.getMessage()));
        }
        return null; 
    }       
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */
    // TODO: redesign this method to be dynamic/Generic
    private void massUpdateCRItems(List<CR_Items__c> listCRItemsForUpdate) {
        System.debug(LoggingLevel.INFO, 'moveToReleaseCR listCRItemsForUpdate:' + listCRItemsForUpdate);
        System.debug(LoggingLevel.INFO, 'selectedFieldUpdate: ' + selectedFieldUpdate);
        System.debug(LoggingLevel.INFO, 'crItemForUpdate: ' + crItemForUpdate);
        
        Boolean isValidMassUpdate = FALSE;
        if( !(('Requestor__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Requestor__c != null) ||
                ('Status__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Status__c != null) ||
                ('Source__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Source__c != null) ||
                ('Project__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Project__c != null) ||
                ('Checkin_Id__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Checkin_Id__c != null) ||
                ('User_Story__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.User_Story__c != null)
            )
        ) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select the field and the value and then click on Mass Update Selected or Mass Update All Components.'));
            return;
        } 

        if(listCRItemsForUpdate != null && !listCRItemsForUpdate.isEmpty()) {
            for(CR_Items__c crItem : listCRItemsForUpdate) {
                if('Requestor__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Requestor__c != null) {
                    crItem.Requestor__c = crItemForUpdate.Requestor__c;
                } else if('Status__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Status__c != null) {
                    crItem.Status__c = crItemForUpdate.Status__c;
                } else if('Source__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Source__c != null) {
                    crItem.Source__c = crItemForUpdate.Source__c;
                } else if('Project__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Project__c != null) {
                    crItem.Project__c = crItemForUpdate.Project__c;
                } else if('Checkin_Id__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.Checkin_Id__c != null) {
                    crItem.Checkin_Id__c = crItemForUpdate.Checkin_Id__c;
                } else  if('User_Story__c'.equalsIgnoreCase(selectedFieldUpdate) && crItemForUpdate.User_Story__c != null) {
                    crItem.User_Story__c = crItemForUpdate.User_Story__c;
                } 
            }

            update listCRItemsForUpdate;

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Updated Successfully ' + listCRItemsForUpdate.size() + ' Records.'));
        }
    }  
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference deleteSelected() {
        System.debug(LoggingLevel.INFO, 'deleteSelected listSelectedCRItems:' + listSelectedCRItems);
        List<CR_Items__c> listCRItemsDelete = new List<CR_Items__c>();

        for(cwCRItems cwItem : listSelectedCRItems) {
            if(cwItem.isSelected == TRUE) {
                if(cwItem.item.Id != null) {
                    listCRItemsDelete.add(cwItem.item);
                }
                setComponentUniqueId.remove(cwItem.item.CRI_Unique_ID__c);
            }
        }
        
        System.debug(LoggingLevel.INFO, 'deleteSelected listCRItemsDelete:' + listCRItemsDelete);

        if(listCRItemsDelete != null) {
            delete listCRItemsDelete;
            retrieveCRItemsList(crItemsDefaultQueryStr);
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select at least one component and then click on Add Selected.'));
        }

        return null; 
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference selectFilterOwner() {
        System.debug(LoggingLevel.INFO, 'selectFilterUser()');
        crItemFilterObj.Requestor__c = UserInfo.getUserId();
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference selectUpdateOwner() {
        System.debug(LoggingLevel.INFO, 'selectUpdateOwner()');
        crItemForUpdate.Requestor__c = UserInfo.getUserId();
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference selectAll() {
        System.debug(LoggingLevel.INFO, 'selectAll listSelectedCRItems:' + listSelectedCRItems);

        for(cwCRItems cwItem : listSelectedCRItems) {
            cwItem.isSelected = TRUE;
        }
        return null; 
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public PageReference deSelectAll() {
        System.debug(LoggingLevel.INFO, 'deSelectAll listSelectedCRItems:' + listSelectedCRItems);

        for(cwCRItems cwItem : listSelectedCRItems) {
            cwItem.isSelected = FALSE;
        }
        return null; 
    }         
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 

    public PageReference save() {
        System.debug(LoggingLevel.INFO, 'save listSelectedCRItems:' + listSelectedCRItems);
        try {

            List<CR_Items__c> listCRItemsUpdate = new List<CR_Items__c>();
            for(cwCRItems cwItem : listSelectedCRItems) {
                listCRItemsUpdate.add(cwItem.item);
            }
            
            if(listCRItemsUpdate != null && listCRItemsUpdate.size() > 0) {
                upsert listCRItemsUpdate;
            }

            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.Info, 'Record Saved Sucessfully'); //show confirmation message on save
            ApexPages.addMessage(myMsg);
        } catch(DmlException ex) {
            ApexPages.Message myMsg = new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
        }

        return null;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 
    public cwCRItems wrapCRItem(String fullName) {
        
        if('CustomField'.equalsIgnoreCase(selectedMetaDataItem)) {
            cwFields cwField = mapFieldFullName.get(fullName);
            if(cwField != null) {
                CR_Items__c crItem  = new CR_Items__c(Full_Name__c = selectedParentItem + '.' + cwField.fieldName, Change_Request__c = changeRequestId, Component_Name__c = cwField.fieldName, Component_Label__c = cwField.fieldLabel, Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
                crItem.Requestor__c = UserInfo.getUserId();
                crItem.CRI_Unique_ID__c = DeploymentTrackerCommon.calculateHashCriUniqueId(crObjectName, crItem);
                return new cwCRItems(crItem);
            }
                                
        } else {
            String componentName = fullName;
            if(selectedParentItem != null) {
                String seperator = selectedMetaDataItem.equalsIgnoreCase('EmailTemplate') ? '/' : (selectedMetaDataItem.equalsIgnoreCase('Layout') ? '-' : '.');
                componentName = componentName.replace(selectedParentItem + seperator, '');
            }

            CR_Items__c crItem  = new CR_Items__c(Change_Request__c = changeRequestId, Component_Name__c = componentName, Full_Name__c = fullName, Component_Label__c = componentName, Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
            crItem.Requestor__c = UserInfo.getUserId();
            crItem.CRI_Unique_ID__c = DeploymentTrackerCommon.calculateHashCriUniqueId(crObjectName, crItem);
            return new cwCRItems(crItem);
        }
        return null;
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 
    public List<String> getListMetadataItem(String metaDataType) {
        List<String> listFullNames = new List<String>();
        mapComponentItems = new Map<String, cwCRItems>();
        mapFieldFullName = new Map<String, cwFields>();
        if('CustomField'.equalsIgnoreCase(selectedMetaDataItem)) {
            Schema.SObjectType theObjectType = Schema.getGlobalDescribe().get(selectedParentItem);

            if(Null != theObjectType) {
                Schema.DescribeSObjectResult theObjectDescribe = theObjectType.getDescribe(); //describe the sobject
                Map<String, Schema.SObjectField> mapObjectFields = theObjectDescribe.fields.getMap(); //get a map of fields for the passed sobject
                
                for(String theFieldName : mapObjectFields.keySet()) {
                    //System.debug(LoggingLevel.INFO, '>>> theFieldName >>> ' + theFieldName);
                    Schema.DescribeFieldResult fieldDescribeResult = mapObjectFields.get(theFieldName).getDescribe();
                    String fullName = fieldDescribeResult.getLabel() + ' (' + fieldDescribeResult.getName() + ')';
                    listFullNames.add(fullName);

                    cwFields newCWField = new cwFields();
                    newCWField.fieldName = fieldDescribeResult.getName();
                    newCWField.fieldLabel = fieldDescribeResult.getLabel();
                    mapFieldFullName.put(fullName, newCWField);
                    
                    //listFullNames.add(fieldDescribeResult.getName());

                    /*
                    // Create the CR_Items__c and put it in the map
                    CR_Items__c crItem  = new CR_Items__c(Full_Name__c = selectedParentItem + '.' + fieldAPIName, Change_Request__c = changeRequestId, Component_Name__c = fieldAPIName, Component_Label__c = fieldDescribeResult.getLabel(), Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
                    crItem.Requestor__c = UserInfo.getUserId();
                    //crItem.CRI_Unique_ID__c = hashString(crObjectName + crItem.Type__c + '-' + crItem.Full_Name__c);
                    crItem.CRI_Unique_ID__c = DeploymentTrackerCommon.calculateHashCriUniqueId(crObjectName, crItem);
                    cwCRItems newCWItems = new cwCRItems(crItem);
                    //mapComponentItems.put(newCWItems.uniqueKey, newCWItems);
                    mapComponentItems.put(fullName, newCWItems);
                    */
                    
                }

            }
        } else {
            if('ApexClass,ApexComponent,ApexPage,ApexTrigger'.containsIgnoreCase(selectedMetaDataItem)) {
                listFullNames = getListMetaDataItemsQuery(selectedMetaDataItem);
            } else if('EmailTemplate'.equalsIgnoreCase(selectedMetaDataItem) && selectedParentItem != null) {
                listFullNames = getListMetaDataItems(metaDataType, selectedParentItem);
            } else {
                listFullNames = getListMetaDataItems(metaDataType, null);
            }

            System.debug(LoggingLevel.INFO, 'listFullNames.size() ' + listFullNames.size());

            // Create the CR_Items__c and put it in the map
            /*
            for(String fullName : listFullNames) {
                String componentName = fullName;
                if(selectedParentItem != null) {
                    String seperator = selectedMetaDataItem.equalsIgnoreCase('EmailTemplate') ? '/' : (selectedMetaDataItem.equalsIgnoreCase('Layout') ? '-' : '.');
                    componentName = componentName.replace(selectedParentItem + seperator, '');
                }

                CR_Items__c crItem  = new CR_Items__c(Change_Request__c = changeRequestId, Component_Name__c = componentName, Full_Name__c = fullName, Component_Label__c = componentName, Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
                crItem.Requestor__c = UserInfo.getUserId();
                //crItem.CRI_Unique_ID__c = hashString(crObjectName + crItem.Type__c + '-' + crItem.Full_Name__c);
                crItem.CRI_Unique_ID__c = DeploymentTrackerCommon.calculateHashCriUniqueId(crObjectName, crItem);
                cwCRItems newCWItems = new cwCRItems(crItem);
                //mapComponentItems.put(newCWItems.uniqueKey, newCWItems);
                mapComponentItems.put(fullName, newCWItems);
            }

            /*
            if(mapOfMetaDataItems != null && mapOfMetaDataItems.containsKey(metaDataType)) {
                for(String fullName : mapOfMetaDataItems.get(metaDataType)) {                     
                    if(selectedParentItem == null || fullName.startsWith(selectedParentItem)) {
                        listFullNames.add(fullName);
                        // Create the CR_Items__c and put it in the map
                        CR_Items__c crItem  = new CR_Items__c(Change_Request__c = changeRequestId, Component_Name__c = fullName, Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
                        cwCRItems newCWItems = new cwCRItems(crItem, null);
                        mapComponentItems.put(newCWItems.uniqueKey, newCWItems);
                    }
                }
            }
            */
            /*
            // List Metadata items for the selected Metadata Type      
            MetadataService.MetadataPort service = createService();             
            List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
            MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
            //queryLayout.folder = metaDataFolder;
            queryLayout.type_x = metaDataType;
            queries.add(queryLayout);       
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
            
            if(fileProperties != null) {
                for(MetadataService.FileProperties fileProperty : fileProperties) {
                    System.debug(LoggingLevel.INFO, 'fileProperty:' + fileProperty);
                    String fullName = fileProperty.fullName;
                    if(selectedParentItem == null || fullName.startsWith(selectedParentItem)) {
                        listFullNames.add(fullName);
                        /*
                        // Create the CR_Items__c and put it in the map
                        CR_Items__c crItem  = new CR_Items__c(Change_Request__c = changeRequestId, Component_Name__c = fullName, Type__c = selectedMetaDataItem, Component_Parent__c = selectedParentItem);
                        cwCRItems newCWItems = new cwCRItems(crItem, null);
                        mapComponentItems.put(newCWItems.uniqueKey, newCWItems);
                        */
                        /*
                    }
                }
            }
            */
        }

        // Sort
        listFullNames.sort();

        return listFullNames;    
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 
    public List<String> getListMetaDataItemsQuery(String metaDataTypeName) {
        List<String> listFullNames = new List<String>();
        // List Metadata items for the selected Metadata Type      
    //    MetadataService.MetadataPort service = createService();             
        //String queryStr = 'SELECT ApiVersion,CreatedById,CreatedDate,Id,LastModifiedById,LastModifiedDate,Name,NamespacePrefix,SystemModstamp FROM ' +  metaDataTypeName;
        String queryStr = 'SELECT Id, Name FROM ' +  metaDataTypeName; 
        queryStr += ' Where NamespacePrefix = null ';

        System.debug(LoggingLevel.INFO, 'queryStr:' + queryStr);

        List<SObject> listQueryResult = database.query(queryStr.trim()); 
        for(SObject record :listQueryResult) {
            //System.debug(LoggingLevel.INFO, 'Parent Object Id = ' + record.get('Id') + ' Name = ' + record.get('Name'));
            listFullNames.add(String.valueOf(record.get('Name')));
        }
        // Sort
        listFullNames.sort();
        return listFullNames;
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */     
   /* private MetadataService.MetadataPort createService() { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }*/

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 
  /*  public List<SelectOption> getMetaData() {        

        MetadataService.AsyncResult AsyncResult;
        String MetaDataRetrieveZip ;

        // List available Metadata Types via the 'describeMetadata' API call
        MetadataService.MetadataPort service = createService();                 
        MetadataService.DescribeMetadataResult describeResult = service.describeMetadata(26);
        List<String> metadataTypeNames = new List<String>();
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects) {
            metadataTypeNames.add(metadataObject.xmlName);
            // Include child Metadata Types (such as CustomField, ValidationRule etc..)
            if(metadataObject.childXmlNames != null) {
                for(String childXmlName : metadataObject.childXmlNames) {
                    if(childXmlName != null) {
                        metadataTypeNames.add(childXmlName);
                    }
                }
            }
        }   

        // Sort Metadata Types
        metadataTypeNames.sort();

        List<SelectOption> MetaDataTypes = new List<SelectOption>();
        MetaDataTypes.add(new SelectOption(SELECT_OPTION_VALUE, SELECT_OPTION_LABEL));              
        for(String metadataTypeName : metadataTypeNames) {
            MetaDataTypes.add(new SelectOption(metadataTypeName, metadataTypeName));
        }

        return MetadataTypes;
    }*/

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */ 
    public List<String> getListMetaDataItems(String metaDataType, String metaDataFolder) {
        List<String> listFullNames = new List<String>();
        // List Metadata items for the selected Metadata Type      
     //   MetadataService.MetadataPort service = createService();             
    //    List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
   //     MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
   //     queryLayout.folder = metaDataFolder;
  //      queryLayout.type_x = metaDataType;
   //     queries.add(queryLayout);       
    //    MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        
    /*    if(fileProperties != null) {
            for(MetadataService.FileProperties fileProperty : fileProperties) {
                //System.debug(LoggingLevel.INFO, 'fileProperty:' + fileProperty);
                String fullName = fileProperty.fullName;
                if(selectedParentItem == null || fullName.startsWith(selectedParentItem)) {
                    listFullNames.add(fullName);
                }
            }
        }*/
        return listFullNames;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */     
/*    public Map<String,List<String>> getMapMetaDataItems(Set<String> setMetaDataType) {
        // List Metadata items for the selected Metadata Type
        MetadataService.MetadataPort service = createService(); 
        Map<String,List<String>> mapTypeListItems = new Map<String,List<String>>(); 
        List<MetadataService.FileProperties> fileProperties  = new List<MetadataService.FileProperties>();
        List<MetadataService.FileProperties> filePropertiesAll  = new List<MetadataService.FileProperties>();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery queryLayout;

        System.debug(LoggingLevel.INFO, 'setMetaDataType ' + setMetaDataType);
        System.debug(LoggingLevel.INFO, 'setMetaDataType.Size ' + setMetaDataType.size());

        for(String mdType : setMetaDataType) {
            queryLayout = new MetadataService.ListMetadataQuery();
            //queryLayout.folder = MetaDataFolder;
            queryLayout.type_x = mdType;
            queries.add(queryLayout);

            if(queries.size() == 3) {
                fileProperties  = service.listMetadata(queries, 25);
                if(fileProperties != null && fileProperties.size() > 0) {
                    filePropertiesAll.addAll(fileProperties);
                    fileProperties.clear();
                    queries.clear();
                }
            }
        }

        if(queries.size() > 0){
            fileProperties  = service.listMetadata(queries, 25);
            if(fileProperties.size() > 0){
                filePropertiesAll.addAll(fileProperties);
                fileProperties.clear();
                queries.clear();
            }
        }

        // Put the MetaData items into a Map
        if(filePropertiesAll != null && filePropertiesAll.size() > 0) {
            for(MetadataService.FileProperties fileProperty : filePropertiesAll) {
                if(!mapTypeListItems.containsKey(fileProperty.type_x)) {
                    mapTypeListItems.put(fileProperty.type_x,new list<string>()); 
                }
                mapTypeListItems.get(fileProperty.type_x).add(fileProperty.fullName);
            }
        }

        // Sort the mamber of the map
        if(mapTypeListItems != null && mapTypeListItems.size() > 0) {
            for(String mapKey : mapTypeListItems.keySet()) {
                List<String> listFullNames = mapTypeListItems.get(mapKey);
                listFullNames.sort();
                mapTypeListItems.put(mapKey, listFullNames);
            }
        }

        return mapTypeListItems;    
    }*/

//************************************************************************************************


//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Build Agreement wrapper list with the document for UI
     * @Param:  
     * @Return: 
     */     

    private void retrieveCRItemsList(String queryStr) {
        System.debug(LoggingLevel.INFO, 'retrieveCRItemsList() queryStr: ' + queryStr);
        // execute the query
        criSetSetController = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        System.debug(LoggingLevel.INFO, 'criSetSetController: ' + criSetSetController);
        if (criSetSetController != null) { 
            // set the page size
            criSetSetController.setPageSize(pageSize);
            
            totalRowCount = criSetSetController.getResultSize();
            
            totalPages = totalRowCount/pageSize;
            Integer remainder = Math.mod(totalRowCount, pageSize);
            
            if (remainder > 0) {
                totalPages ++;
            }
            
            // build wrapper list
            buildResultList();            
        } else {
            totalPages = 0;
            currentPageNbr = 0;
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Build Agreement wrapper list with the document for UI
     * @Param:  
     * @Return: 
     */     

    private void buildResultList() {
        // set current page number
        criSetSetController.setPageNumber(currentPageNbr);
        listSelectedCRItems = new List <cwCRItems>();
            
        // read records from the current page in the recordset
        for (CR_Items__c crItem : (List<CR_Items__c>) criSetSetController.getRecords()) {            
            cwCRItems newCWItems = new cwCRItems(crItem);
            listSelectedCRItems.add(newCWItems);               
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the next page in the resultset
     * @Param:  
     * @Return: 
     */     

    public void loadCurrentPage() {
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are result to show
     * @Param:  
     * @Return: <code>true</code> if there are results, <code<false</code> otherwise
     */     

    public Boolean getHasResults() {
        return (!listSelectedCRItems.isEmpty());
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are more records after the current page in the resultset
     * @Param:  
     * @Return: <code>true</code> if there are more records, <code>false</code> otherwise
     */     

    public Boolean getHasNextPage() {
        System.debug(LoggingLevel.INFO, '\ntotalPages = ' + totalPages +'\ncurrentPageNbr = ' + currentPageNbr);
        return (totalPages > currentPageNbr);
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are more records before the current page in the resultset
     * @Param:  
     * @Return: <code>true</code> if there are more records, <code>false</code> otherwise
     */     
     
    public Boolean getHasPreviousPage() {
        return ((currentPageNbr != 1) && (currentPageNbr != 0));
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets the page number of the current page in the resultset
     * @Param:  
     * @Return: the page number
     */     

    public Integer getCurrentPageNumber() {
        return currentPageNbr;
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Sets the page number into the resultset
     * @Param:  
     * @Return: 
     */ 
         
    public void setCurrentPageNumber(Integer pageNumber) {
        if(pageNumber <= totalPages) {
            currentPageNbr = pageNumber;
            buildResultList();
        }
        
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets current page start asset count
     * @Param:  
     * @Return: 
     */ 
         
    public Integer getPageStartIndex() {
        if (currentPageNbr == 1) {
            return 1;
        } 
        if (!listSelectedCRItems.isEmpty()) {
            return ((pageSize * (currentPageNbr - 1)) + 1);
        }
        return 0;
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets current page end asset count
     * @Param:  
     * @Return: 
     */     
 
    public Integer getPageEndIndex() {
        if (!listSelectedCRItems.isEmpty()) {
            return (getPageStartIndex() + (listSelectedCRItems.size() - 1));
        }
        return 0;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the first page in the resultset
     * @Param:  
     * @Return: 
     */     

    public void firstPage() {
        
        // reset current page
        currentPageNbr = 1;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the last page in the resultset
     * @Param:  
     * @Return: 
     */     
    public void lastPage() {
        
        // reset current page
        currentPageNbr = totalPages;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the previous page in the resultset
     * @Param:  
     * @Return: 
     */         

    public void previousPage() {

        // adjust current page
        currentPageNbr --;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the next page in the resultset
     * @Param:  
     * @Return: 
     */         

    public void nextPage() {

        // adjust current page
        currentPageNbr ++;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the next page in the resultset
     * @Param:  
     * @Return: 
     */        
    public PageReference doShowHideFilters() {
        showFilters = !showFilters;
        return null;
    }
}