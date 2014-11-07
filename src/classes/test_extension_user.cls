@isTest
private class test_extension_user {
   
   static testMethod void test_logic() {
      User u = [SELECT Id FROM User LIMIT 1]; //grab a user
      
      //create a reference to the Visualforce page we just made
      PageReference sample_page = Page.VisualforcePicklist;
      Test.setCurrentPage(sample_page);
      
      ApexPages.currentPage().getParameters().put('id', u.Id); //populate the Visualforce page with the Id of the user from above
      
      //create an instance of the controller extension as if editing the user's details
      ApexPages.StandardController standard_controller = new ApexPages.standardController(u);
      extension_user extension_to_standard_controller = new extension_user(standard_controller);
      
      //call the method for populuating the Locale picklist
      List<selectOption> locale_picklist_options = extension_to_standard_controller.getLocales();
      System.AssertNotEquals(0, locale_picklist_options.size()); //assert that the size of our picklist is not 0

      //call the method for populuating the Locale picklist
      List<selectOption> time_zone_picklist_options = extension_to_standard_controller.getTimeZones();
      System.AssertNotEquals(0, time_zone_picklist_options.size()); //assert that the size of our picklist is not 0
   }
}