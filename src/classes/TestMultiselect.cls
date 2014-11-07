public class TestMultiselect {

    Public Account acc;
     public String oppStage ;
     public String territory ;
     

    public TestMultiselect(ApexPages.StandardController controller) {
            acc=(Account)controller.getRecord();
          
    }   

        
    Public String getGreeting()
        {
            return 'Result - '+oppStage +','+territory ;
       }
       
       Public Void testsubmit()
    {
          oppStage =acc.Stage__c;
          territory =acc.territory__c;          
    }
   

}