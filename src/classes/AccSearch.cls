public class AccSearch{

  

public string accountname {get; set;}
public List<Account> acc;

public  void doSearch(){   
for(List<Account> accounts1 :[select Name,phone from Account where name like :accountname +'%' ])                                             
 acc=accounts1;  
}
public Account getFirstName()
{
   return [select Name from Account limit 1];
}

 Public List<Account> getAccounts(){
    return acc;
    }


}