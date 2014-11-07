public class Acc
{
    
    
    public Account acc1;
    public Boolean viewSLA { get; set; }
    public String Rating { get; set; }

    public Acc(ApexPages.StandardController controller)
    {
     this.acc1=(Account)controller.getRecord(); 
    System.debug('GGGGGGGGGGG:'+acc1.Rating );
     System.debug('GGGGGGG1222222:'+acc1);
     if(acc1.rating!=null)
     {
      System.debug('Hai');   
     if((acc1.Rating.equals('Hot'))||(Rating=='Hot'))
              viewSLA = true;
     else
              viewSLA =false;       
    }
}

public List<SelectOption> getRating() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Hot','Hot'));
            options.add(new SelectOption('Warm','Warm'));
            options.add(new SelectOption('Cold','Cold'));
            return options;
        }


}