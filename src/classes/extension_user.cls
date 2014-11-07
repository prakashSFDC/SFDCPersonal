public with sharing class extension_user {
   private String first_picklist_option = '- All -'; //first value to display in picklist
   private final User user_object; //User sobject
   
   public extension_user(ApexPages.StandardController stdController) {
      this.user_object = (User)stdController.getRecord();
   }
   
   //builds a picklist of values based upon the passed information
   public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
      List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
      if (first_val != null) { //if there is a first value being provided
         options.add(new selectOption(first_val, first_val)); //add the first option
      }
      Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
      for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
         options.add(new selectOption(a.getLabel(), a.getValue())); //add the value and label to our final list
      }
      return options; //return the List
   }
   
   //return the picklist options for User.TimeZoneSidKey
   public List<selectOption> getTimeZones() {
      return getPickValues(user_object, 'TimeZoneSidKey', first_picklist_option);
   }
   
   //return the picklist options for User.LocaleSidKey
   public List<selectOption> getLocales() {
      return getPickValues(user_object, 'LocaleSidKey', first_picklist_option);
   }

}