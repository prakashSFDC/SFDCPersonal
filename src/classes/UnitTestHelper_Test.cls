@isTest
private class UnitTestHelper_Test {

/**
     * Validates the getTestResult method
     */
    private static testMethod void testGetTestResult() {
        //Setup Test
        Account oAccount = UnitTestHelper.getAccountInstance();
        List<Account> listAccounts = UnitTestHelper.getAccountInstances(UnitTestHelper.BULK_BATCH_SIZE);
        
        //Execute Test
        Test.startTest();
        
        //Test: Basic Success
        UnitTestHelper.TestResult oSuccessResult = UnitTestHelper.getTestResult(Database.insert(oAccount, false));
        System.assert(oSuccessResult.success, 'Expected save result assertion to succeed');
        
        //Test: Basic Fail
        UnitTestHelper.TestResult oFailureResult = UnitTestHelper.getTestResult(Database.insert(new Account(), false));
        System.assert(oFailureResult.success == false, 'Expected save result assertion to fail');
        
        //Test: Bulk Success
        List<UnitTestHelper.TestResult> listBulkSuccessResults = UnitTestHelper.getTestResults(Database.insert(listAccounts, false));
        System.assert(listBulkSuccessResults[0].success, 'Expected save result assertion to succeed');
        
        //Test: Bulk Fail
        List<UnitTestHelper.TestResult> listBulkFailureResults = UnitTestHelper.getTestResults(Database.insert(new List<Account>{ new Account() }, false));
        System.assert(listBulkFailureResults[0].success == false, 'Expected save result assertion to fail');
        
        User userObj=UnitTestHelper.getUserInstance();
        List<User> listUser =UnitTestHelper.getUserInstances(2);
        
         Contact oContact= UnitTestHelper.getContactInstances(oAccount.id,'UnitTestHelper');
        
        PricebookEntry  pb = new PricebookEntry();
        Product2 oProduct =  UnitTestHelper.getProductInstance('Book1', 'salesCreditMap');
        List<PricebookEntry> listpb = UnitTestHelper.getPriceBookEntries(pb.id, oProduct.id);
        
        
        Opportunity oOppty= UnitTestHelper.getOpportunityInstance(oAccount.id);
        
        OpportunityLineItem oOpptyLI = UnitTestHelper.getOpportunityLineItemInstance(oOppty.id,pb.Id );
        
        List<OpportunityLineItem> listOppty= UnitTestHelper.getOpportunityLineItemInstances(oOppty.ID, pb.id, 2);
        
        Test.stopTest();
     }
     
      /**
     * Validates all Account methods and ensures the
     * instance can be inserted into the database
     */
     
    private static testmethod void testAccountMethods() {
        //Execte Test
        Test.startTest();
        
        //Test: Basic Create
        Account oAccount = UnitTestHelper.getAccountInstance();
        
        UnitTestHelper.TestResult oBasicResult = UnitTestHelper.getTestResult(Database.insert(oAccount, false));
        System.assert(oBasicResult.success, oBasicResult.message);
        
        //Test: Bulk Create
        List<Account> listBulkAccounts = UnitTestHelper.getAccountInstances(UnitTestHelper.BULK_BATCH_SIZE);
        
        List<UnitTestHelper.TestResult> listBulkResults = UnitTestHelper.getTestResults(Database.insert(listBulkAccounts, false));
        for (UnitTestHelper.TestResult oBulkResult : listBulkResults) {
            System.assert(oBulkResult.success, oBulkResult.message);
        }
        
        Test.stopTest();
    }

    /**
     * Validates all Contact methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testContactMethods() {
        //Setup Test
        Account oAccount = UnitTestHelper.getAccountInstance();
        insert oAccount;
        
        //Execte Test
        Test.startTest();
        
        //Test: Basic Create
        Contact oContact = UnitTestHelper.getContactInstance(oAccount.Id);
        oContact.Email = 'test_test001@adobe.com';
        
        UnitTestHelper.TestResult oBasicResult = UnitTestHelper.getTestResult(Database.insert(oContact, false));
        System.assert(oBasicResult.success, oBasicResult.message);
        
        //Test: Bulk Create
        List<Contact> listBulkContacts = UnitTestHelper.getContactInstances(oAccount.Id, UnitTestHelper.BULK_BATCH_SIZE);
        
        List<UnitTestHelper.TestResult> listBulkResults = UnitTestHelper.getTestResults(Database.insert(listBulkContacts, false));
        for (UnitTestHelper.TestResult oBulkResult : listBulkResults) {
            System.assert(oBulkResult.success, oBulkResult.message);
        }
        
              
        Test.stopTest();
    }   
    
    /**
     * Validates all Opportunity methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testOpportunityMethods() {
        //Setup Test
        Account oAccount = UnitTestHelper.getAccountInstance();
        insert oAccount;
        
        //Execte Test
        Test.startTest();
        
        //Test: Basic Create
        Opportunity oOpportunity = UnitTestHelper.getOpportunityInstance(oAccount.Id);
        
        UnitTestHelper.TestResult oBasicResult = UnitTestHelper.getTestResult(Database.insert(oOpportunity, false));
        System.assert(oBasicResult.success, oBasicResult.message);
        
        //Test: Bulk Create
        List<Opportunity> listBulkOpportunities = UnitTestHelper.getOpportunityInstances(oAccount.Id, UnitTestHelper.BULK_BATCH_SIZE);
        
        List<UnitTestHelper.TestResult> listBulkResults = UnitTestHelper.getTestResults(Database.insert(listBulkOpportunities, false));
        for (UnitTestHelper.TestResult oBulkResult : listBulkResults) {
            System.assert(oBulkResult.success, oBulkResult.message);
        }
        
        Test.stopTest();
    }
    
    /**
     * Validates all Account methods and ensures the
     * instance can be inserted into the database
     */
    private static testmethod void testLeadMethods() {
        //Execte Test
        Test.startTest();
        
        //Test: Basic Create
        Lead oLead = UnitTestHelper.getLeadInstance();
        
        UnitTestHelper.TestResult oBasicResult = UnitTestHelper.getTestResult(Database.insert(oLead, false));
        System.assert(oBasicResult.success, oBasicResult.message);
        
        //Test: Bulk Create
        List<Lead> listBulkLeads = UnitTestHelper.getLeadInstances(UnitTestHelper.BULK_BATCH_SIZE);
        
        List<UnitTestHelper.TestResult> listBulkResults = UnitTestHelper.getTestResults(Database.insert(listBulkLeads, false));
        for (UnitTestHelper.TestResult oBulkResult : listBulkResults) {
            System.assert(oBulkResult.success, oBulkResult.message);
        }
        
        Test.stopTest();
    }       
}