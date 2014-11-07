public class UnitTestHelper {

    
    //Private Constants
    private static UnitTestHelper oUnitTest;
    
    //Public Constants
    public static final integer BULK_BATCH_SIZE = 200;
    
    
    /**
     * Method that provides a singleton instance of the unit test
     * utility class allowing global transactions values to be stored
     * and accessed.
     */
    public static UnitTestHelper getInstance() {
        if (oUnitTest == null) {
            oUnitTest = new UnitTestHelper();
        }
        
        return oUnitTest;
    }
    
  /**
     * Evaluates the specified SaveResult and reports the results as a
     * success or failure
     *
     * @param   oSaveResult     the result of a database DML operation to assert
     * @return  an TestResult representing the results of the evaluation
     */
    public static UnitTestHelper.TestResult getTestResult(Database.SaveResult oSaveResult) {
        UnitTestHelper.TestResult oTestResult = new UnitTestHelper.TestResult();
        oTestResult.success = oSaveResult.isSuccess();
        
        if (!oTestResult.success && oSaveResult.getErrors() != null) {
            oTestResult.message = oSaveResult.getErrors()[0].getMessage();
        }
        
        return oTestResult;
    }   
    
    
     /**
     * @Return Campaign Object
     */
     
    public static Campaign getCampaignInstance(){
        Campaign oCampaign = new Campaign();
        oCampaign.Status = 'In Progress';       
        oCampaign.Name = 'Test Campaign1';
        return oCampaign;
    }
    
     /**
     *
     * @param   Id CampaignId, String Status, Id ContactId
     * @return  CampaignMember instance
     */
     
    public static CampaignMember getCampaignMemberInstance(Id CampaignId, String Status, Id ContactId){
        CampaignMember oCampaignMember = new CampaignMember();
        oCampaignMember.Status = Status;
        oCampaignMember.CampaignId = CampaignId;
        oCampaignMember.ContactId = ContactId;
        return oCampaignMember;
    }
    
       /**
     * Evaluates the specified SaveResult and reports the results as a
     * success or failure
     *
     * @param   listSaveResults  the list of save results of a database DML operation to assert
     * @return  an array of TestResult objects representing the results of the evaluation
     */
    public static List<UnitTestHelper.TestResult> getTestResults(List<Database.SaveResult> listSaveResults) {
        List<UnitTestHelper.TestResult> listTestResults = new List<UnitTestHelper.TestResult>();
        
        for (Database.SaveResult oSaveResult : listSaveResults) {
            UnitTestHelper.TestResult oTestResult = new UnitTestHelper.TestResult();
            oTestResult.success = oSaveResult.isSuccess();
            
            if (!oTestResult.success) {
                oTestResult.message = oSaveResult.getErrors()[0].getMessage();
            }
            
            listTestResults.add(oTestResult);
        }
        
        return listTestResults;
    }
    
    //Internal Classes
    
    /**
     * Data structure that provides information regarding
     * the evalution of a test result.
     * <p>
     * Primarily used to safely report the results of a Database.SaveResult
     */
    public class TestResult {
        public boolean success {get; set;}
        public string message {get;set;}
        
        public TestResult() {
            success = false;
            message = '';
        }
    }
    
    public static User getUserInstance(){
        User oUser = new User();
        String sAppend = ''+String.valueOf(Math.random());
        
        oUser.FirstName = 'TestFirstName';
        oUser.LastName = 'TestLastName';
        oUser.Email = 'test'+sAppend+'@adobe.com';
        oUser.Username = 'test'+sAppend+'@adobe.com.sandbox';
        oUser.Alias = oUser.FirstName.substring(0,1)+oUser.LastName.substring(0,4);
        oUser.ProfileId = '00e30000000dOCn';
        oUser.UserRoleId = '00E30000000dnlS';
        oUser.TimeZoneSidKey = 'America/Los_Angeles';
        oUser.LocaleSidKey = 'en_US';
        oUser.LanguageLocaleKey = 'en_US';
        oUser.EmailEncodingKey = 'ISO-8859-1';
        return oUser;
    }
    
    public static List<User> getUserInstances(integer iCount){
        List<User> listUser = new List<User>();
        for (integer i = 0; i < iCount; i++) {
            User oUser = getUserInstance();
            oUser.FirstName += ' - ' + i;
            oUser.LastName += ' - ' + i;
            listUser.add(oUser);    
        }
        return listUser;
    }
    
    
    /**
     * Static method that generates an instance of an Account object
     * with its required field values pre-populated.
     *
     * @return  an instance of an Account that has not been committed
     *          to the database
     */
    public static Account getAccountInstance() {
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test Account';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '75006';
        oAccount.BillingCountry='US';
        oAccount.Industry = 'Commerical';
        return oAccount;
    }

    /**
     * Static method that generates multiple instances of an Account object
     * with its required field values pre-populated.
     *
     * @param   iCount  the number of Accounts to generate
     * @return  a list of Accounts that have not been committed
     *          to the database
     */
    public static List<Account> getAccountInstances(integer iCount) {
        List<Account> listAccounts = new List<Account>();
        
        for (integer i = 0; i < iCount; i++) {
            Account oAccount = getAccountInstance();
            oAccount.Name += ' - ' + i;
            
            listAccounts.add(oAccount); 
        }
        
        return listAccounts;
    }
    
    /**
     * Static method that generates an instance of a Contact object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @return  an instance of a Contact that has not been committed
     *          to the database
     */
    public static Contact getContactInstance(Id masterAccountId) {
        //P. Victoriano - added email uniqueness to contact email for validation rule
        String sAppend = ''+String.valueOf(Math.random());
        sAppend = sAppend.replaceAll('0.','.');
        sAppend = sAppend.trim();
        //
        Contact oContact = new Contact();
        oContact.AccountId = masterAccountId;
        oContact.FirstName = 'Ryan';
        oContact.LastName = 'Wilson';
        oContact.Email = 'test'+sAppend+'@adobe.com';
        //oContact.Email = 'test01pS00000009Oiv@adobe.com';

        return oContact;
    }

    /**
     * Static method that generates multiple instances of a Contact object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Contacts that have not been committed
     *          to the database
     */
    public static List<Contact> getContactInstances(Id masterAccountId, integer iCount) {
        List<Contact> listContacts = new List<Contact>();
        
        for (integer i = 0; i < iCount; i++) {
            Contact oContact = new Contact();
            oContact.AccountId = masterAccountId;
            oContact.LastName += ' - ' + i;
            //oContact.Email = 'test'+i+'@adobe.com';
            listContacts.add(oContact); 
        }
        
        return listContacts;
    }
    
    /**
     * Static method that generates multiple instances of a Contact object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Contacts that have not been committed
     *          to the database
     */
    public static Contact getContactInstances(Id masterAccountId, String className) {
        //P. Victoriano - added email uniqueness to contact email for validation rule
        String sAppend = ''+String.valueOf(Math.random());
        sAppend = sAppend.replace('.','');
        sAppend = sAppend.trim();
        //
        string domainName =  className.replace('.','');
        domainName =  className.replace('_','');
        Contact oContact = new Contact();
        oContact.AccountId = masterAccountId;
        oContact.FirstName = 'Ryan';
        oContact.LastName = 'Wilson';
        oContact.Email = 'test'+sAppend+'@'+domainName+'.com';
        //oContact.Email = 'test01pS00000009Oiv@adobe.com';

        return oContact;
    }
    
    
    /**
     * Static method that generates an instance of an Opportunity object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @return  an instance of an Opportunity that has not been committed
     *          to the database
     */
    public static Opportunity getOpportunityInstance(Id masterAccountId) {
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = masterAccountId;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Prospect';
        
        return oOpportunity;
    }
    
    /**
     * Static method that generates multiple instances of an Opportunity object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Opportunities that have not been committed
     *          to the database
     */
    public static List<Opportunity> getOpportunityInstances(Id masterAccountId, integer iCount) {
        List<Opportunity> listOpportunities = new List<Opportunity>();
        
        for (integer i = 0; i < iCount; i++) {
            Opportunity oOpportunity = getOpportunityInstance(masterAccountId);
            oOpportunity.Name += ' - ' + i;
            
            listOpportunities.add(oOpportunity);    
        }
        
        return listOpportunities;
    }

    /**
     * Static method that generates an instance of an Event object
     * with its required field values pre-populated.
     *
     * @param   userId     the id of the user/owner of task record
     * @param   masterAccountId     the id of the master account record
     * @param   masterContactId     the id of the contact record
     @return  an instance of an Event that has not been committed
     *          to the database
     */
 
    public static Event getEventInstance(Id userId,Id masterAccountId,Id masterContactId) {
        Event oEvent=new Event();
        oEvent.Subject = 'Event Test Subject';
        oEvent.ActivityDate = System.today();
        oEvent.OwnerId = userId;
        oEvent.WhatId = masterAccountId;  
        oEvent.StartDateTime = System.today();
        oEvent.EndDateTime = System.today();
        oEvent.WhoId = masterContactId;
        return oEvent;
    }
    
     /**
     * Static method that generates multiple instances of an Event object
     * with its required field values pre-populated.
     *
     * @param   userId     the id of the user/owner of task record
     * @param   masterAccountId     the id of the master account record
     * @param   masterContactId     the id of the contact record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Event that have not been committed
     *          to the database
     */
    public static List<Event> getEventInstances(Id userId,Id masterAccountId,Id masterContactId, integer iCount) {
        List<Event> listEvents = new List<Event>();
        
        for (integer i = 0; i < iCount; i++) {
            Event oEvent = getEventInstance(userId, masterAccountId, masterContactId);
            oEvent.Subject += ' - ' + i;
            listEvents.add(oEvent);    
        }
        
        return listEvents;
    }
    
    
    /**
     * Static method that generates an instance of an Task object
     * with its required field values pre-populated.
     *
     * @param   userId     the id of the user/owner of task record
     * @param   masterAccountId     the id of the master account record
     * @param   masterContactId     the id of the contact record
     @return  an instance of an Task that has not been committed
     *          to the database
     */
 
    public static Task getTaskInstance(Id userId,Id masterAccountId,Id masterContactId) {
        Task oTask=new Task();
        oTask.Subject='Test Subject';
        oTask.OwnerId=userId;
        oTask.ActivityDate=System.today();
        oTask.WhatId=masterAccountId;
        oTask.WhoId = masterContactId;
        return oTask;
    }
    
     /**
     * Static method that generates multiple instances of an Task object
     * with its required field values pre-populated.
     *
     * @param   userId     the id of the user/owner of task record
     * @param   masterAccountId     the id of the master account record
     * @param   masterContactId     the id of the contact record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Task that have not been committed
     *          to the database
     */
    public static List<Task> getTaskInstances(Id userId,Id masterAccountId,Id masterContactId, integer iCount) {
        List<Task> listTasks = new List<Task>();
        
        for (integer i = 0; i < iCount; i++) {
            Task oTask = getTaskInstance(userId, masterAccountId, masterContactId);
            oTask.Subject += ' - ' + i;
            listTasks.add(oTask);    
        }
        
        return listTasks;
    }
    
    
    /**
     * Static method that generates an instance of an Opportunity object
     * with its required field values pre-populated.
     *
     * @param   parentOpportunityId the id of the parent Opportunity
     * @param   priceBookEntryId    the id of the PriceBookEntry associated with this OpportunityLineItem
     * @return  an instance of an OpportunityLineItem
     */
    public static OpportunityLineItem getOpportunityLineItemInstance(Id parentOpportunityId, Id priceBookEntryId) {
        
        OpportunityLineItem oOpportunityLineItem = new OpportunityLineItem();
        oOpportunityLineItem.OpportunityId = parentOpportunityId;
        oOpportunityLineItem.PricebookEntryId = priceBookEntryId;       
        oOpportunityLineItem.UnitPrice=747;
        oOpportunityLineItem.Quantity=40;
        
        return oOpportunityLineItem;
    }
    
    /**
     * Static method that generates multiple instances of an OpportunityLineItem object
     * with its required field values pre-populated.
     *
     * @param   parentOpportunityId the id of the parent Opportunity record
     * @param   priceBookEntryId    the id of the PriceBookEntry associated with the OpportunityLineItems
     * @param   iCount              the number of OpportunityLineItems to generate
     * @return  a list of OpportunityLineItems
     */
    public static List<OpportunityLineItem> getOpportunityLineItemInstances(Id parentOpportunityId, Id priceBookEntryId, integer iCount) {
        List<OpportunityLineItem> listOpportunityLineItems = new List<OpportunityLineItem>();
        
        for (integer i = 0; i < iCount; i++) {
            OpportunityLineItem oOpportunityLineItem = getOpportunityLineItemInstance(parentOpportunityId, priceBookEntryId);
            listOpportunityLineItems.add(oOpportunityLineItem); 
        }
        
        return listOpportunityLineItems;
    }
    
        /**
     * Static method that generates an instance of a Product object
     * with its required field values pre-populated.
     *
     * @param   name    the Name of the returned Product
     * @param   salesCreditMap  a string representing a SalesCreditMap
     * @return  an instance of a Product
     */
    public static Product2 getProductInstance(String name, String salesCreditMap) {
        
        Product2 oProduct = new Product2();
        oProduct.Name = name;
        oProduct.Description = name + '\'s Description';       
        oProduct.isActive=true;
        oProduct.ProductCode = 'OSCT';

        return oProduct;
    }
    
    /**
     * Static method that generates an instance of a Pricebook object
     * with its required field values pre-populated.
     *
     * @param   name    the Name of the returned PriceBook
     * @return  a PriceBook object
     */
    public static PriceBook2 getPriceBookInstance(String name) {

        Pricebook2 oPriceBook = new PriceBook2();
        oPriceBook.Name = name;
        oPriceBook.Description = name + '\'s Description';
        oPriceBook.IsActive = true;

        return oPriceBook;
    }
    
    
     /**
     * Static method that generates an instance of a PricebookEntry object
     * with its required field values pre-populated.
     *
     * @param   pricebookId the id of the non-standard PriceBook to append with this PriceBookEntry
     * @param   product2Id  the id of the Product2 item to create an PricebookEntry with
     * @return  a List of PricebookEntry's, including the required standard PriceBook
     */
    public static List<PricebookEntry> getPriceBookEntries(Id pricebookId, Id product2Id) {

        List<PricebookEntry> listPriceBookEntry = new List<PricebookEntry>();
        
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard=true LIMIT 1];
        
        listPriceBookEntry.add(new PricebookEntry(Pricebook2Id = standardPriceBook.id, Product2Id = product2Id, UnitPrice=1.0, isActive=true));
    
        PriceBookEntry oPriceBookEntry = new PriceBookEntry();
        oPriceBookEntry.Pricebook2Id = pricebookId;
        oPriceBookEntry.Product2Id = product2Id;
        oPriceBookEntry.UnitPrice = 1.0;
        oPriceBookEntry.IsActive = true;
        
        listPriceBookEntry.add(oPriceBookEntry);

        
        return listPriceBookEntry;
    }
    
     /**
     * Static method that generates an instance of an Lead object
     * with its required field values pre-populated.
     *
     * 
     * @return  an instance of an Lead that has not been committed
     *          to the database
     */
    public static Lead getLeadInstance() {
        Lead oLead = new Lead();
        //oLead.Account__c='Unit Test';
        oLead.LastName = 'Unit Test Last Name';
        oLead.Company = 'Unit Test Company Name';
        oLead.Status = 'New';
        oLead.LeadSource = 'Other';
        oLead.Country = 'US';
        oLead.Email = 'srini@test.com';
        return oLead;
    }
    
    /**
     * Static method that generates multiple instances of an Lead object
     * with its required field values pre-populated.
     *
     * @param   masterAccountId     the id of the master account record
     * @param   iCount              the number of contacts to generate
     * @return  a list of Opportunities that have not been committed
     *          to the database
     */
    public static List<Lead> getLeadInstances(integer iCount) {
        List<Lead> listLead = new List<Lead>();
        
        for (integer i = 0; i < iCount; i++) {
            Lead oLead = getLeadInstance();
            oLead.LastName += ' - ' + i;
            
            listLead.add(oLead);    
        }
        
        return listLead;
    }
    
    
     /**
     * Queries the system for an active record type to be used for testing.
     *
     * @param   sObjectName     the sObject name to filter by.
     * @param   sDeveloperName  the developer name of the record type to filter by.
     */
    public static Id lookupRecordTypeId(string sObjectName, string sDeveloperName) {
        Id recordTypeId = null;
        List<RecordType> listRecordType;
        
        listRecordType = [SELECT Id 
                                 FROM RecordType 
                                 WHERE sObjectType=:sObjectName 
                                 AND DeveloperName=:sDeveloperName 
                                 AND IsActive=true];
        System.assert(listRecordType.size() > 0, 'Expected a record type to exist for the ' + sObjectName + ' object with a developer name of ' + sDeveloperName);
        
        if (!listRecordType.isEmpty()) {
            recordTypeId = listRecordType.get(0).Id;
        }
        
        return recordTypeId;
    }
    
    /**
     * Queries the system for an active record type to be used for testing.
     *
     * @param   sObjectName     the sObject name to filter by.
     * @param   recordTypeName  record Type Name
     */
    public static Id lookupRecordTypeByName(string sObjectName, string sRecordTypeName) {
        Id recordTypeId = null;
        List<RecordType> listRecordType;
        
        listRecordType = [SELECT Id 
                                 FROM RecordType 
                                 WHERE sObjectType=:sObjectName 
                                 AND Name =:sRecordTypeName 
                                 AND IsActive=true];
        System.assert(listRecordType.size() > 0, 'Expected a record type to exist for the ' + sObjectName + ' object with a recort type name of ' + sRecordTypeName);
        
        if (!listRecordType.isEmpty()) {
            recordTypeId = listRecordType.get(0).Id;
        }
        
        return recordTypeId;
    }
    
     public static void insertTestDataCustomSettings(){
          User testSysAdmin = [Select id from User where profileId in (Select id from Profile where Name = 'System Administrator') limit 1];
          System.runAs( testSysAdmin ){       
            
          NVP__c objNVP= new NVP__c();
            objNVP.Name='Backlog';
            objNVP.String__c ='4-In Queue';
            try{ insert objNVP; } catch(Exception e) { System.assert( false, 'Failed while inserting values for Custom Setting -  Add NVP.'+e.getMessage());}
          
          }
 }     
    
}