public Class TestExample{

public String strName{get;set;}
public List<Account> listAccounts{get;set;}
private integer intPhno;

//Constructor
public TestExample(){

    displayName();
}

public void displayName(){
    
    listAccounts = [Select Id,Name from Account];
}

}