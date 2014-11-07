@isTest
public class DistributorTypeCheckTest{

    
    
   static testMethod void classTest(){
    test.startTest();
        String Tem1 = 'Distributor\'s Type Check';
        String Tem2='MOtOrOla';        
        DistributorTypeCheckSchedulable d = new DistributorTypeCheckSchedulable ();
        system.schedule('DistributorType Checked Achieved Update','0 0 0 * * ?',d);
        d.insertSingleQuote(Tem1);
        d.replaceCapitalvalue(Tem2);
        d.Schedbatch(); 
    test.stopTest();
    } 
    
 }