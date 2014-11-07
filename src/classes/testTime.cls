public class testTime{                    
    public dateTime startTime{get;set;}
    public dateTime stopTime{get;set;}
    
    
    public TestTime(){
        startTime = null;
    }
    
    public PageReference startTimer(){         
        startTime=system.now(); 
        return null;        
    }
    
    public PageReference checkTimer(){         
        system.debug('startTime in checkTimer!!' + startTime);  
        return null;                
    }
    public PageReference testTimefn(){         
        system.debug('startTime in testTimefn!!' + startTime);
        return null;                
    }
    
    public void stopMonitor(){
        
        system.debug('startTime in stopMonitor !!' + startTime);  
        /*cspMonitoring__c cspMonitoring  = new cspMonitoring__c();               
        cspMonitoring.startTime__c = startTime;
              
        cspMonitoring.endTime__c = system.now(); 
        
        if(cspMonitoring.startTime__c != null && cspMonitoring.endTime__c != null){
            insert cspMonitoring;    */   
        }
        
    }