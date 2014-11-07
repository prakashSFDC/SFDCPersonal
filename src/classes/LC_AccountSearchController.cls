/*
Class Name : LC_AccountSearchController 
User Story : 126
Description: This class supports the auto complete functionality in order to avoid the governor limit.

Date                    Author                        Version
10/14/2010            SORNANATHAN                    
*/

public class LC_AccountSearchController 
{
    public String resp {get; set;}
    
    //Default Contructor
    public LC_AccountSearchController() 
    {

        resp = '';
        String query = '';
        // Check if parameter was passed, then do the search
        if (ApexPages.currentPage().getParameters().get('q') != null) 
        {
            query += ApexPages.currentPage().getParameters().get('q');
            
            try{
            RecordType recType = [Select Id from RecordType where Name = 'Partner' 
                                                 and SobjectType = :'Account'
                                                 and isActive = true];   
            if(recType!=null)      
            {
            List<Account> students = [select Id, Name
                                            From Account 
                                            Where Name like :(query+'%')
                                            ];

            for (Integer i=0;i<students.size();i++) 
            {
                resp += students[i].Name + '<div style=\'display:none\'>' + students[i].Id+'</div>';  
                if(i<(students.size()-1))
                    resp += '\n';
            }
            }
            }
            Catch(QueryException e)
            {
                System.debug('Exception caught:'+e.getMessage());
            }
        }      
    }
}