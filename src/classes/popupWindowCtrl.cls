public class popupWindowCtrl { 
    public String someNumber { get; set; }

    public String someText { get; set; }
    

    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
  }