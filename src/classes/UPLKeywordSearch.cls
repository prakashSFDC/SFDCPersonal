/*  
 * File Name     : UPLKeywordSearch
 * Description   : This class returns a list of AccountIds which have a keyword term
 *                 that matches with the Keyword entered in the UPL Search page                                 
 * @author       : Infosys Technologies Limited
 *
 * Modification Log
 * =============================================================================
 *   Ver     Date         Author          Modification
 *------------------------------------------------------------------------------
 *   1.0     14-Nov-11   Infosys       Created   
 *   
 */

public class UPLKeywordSearch
{
    String keywordTerm= null;
    List<Id> AccountIdKeyword=new List<Id>();

    public List<Id> KeywordSearchLogic(List<Id> Input_Accounts,String Keyword)
    {
        //Replace special characters and create the keyword term
        String keywordReplaced = Keyword.replaceAll('\\(',' \\( ');
        keywordReplaced = keywordReplaced.replaceAll('\\)',' \\) ');
        String[] keywordArray=keywordReplaced.split(' ');
        for(Integer count=0;count<keywordArray.size();count++)
        {   

            keywordArray[count]=keywordArray[count].replaceAll('\\s','');
            if(keywordArray[count]!=null)
            {
                if(keywordArray[count].length()>0)  
                {
                    if(keywordTerm==null)    
                    {         
                        keywordArray[count]=keywordArray[count]+'*';
                        keywordTerm=keywordArray[count];  

                    } 
                    else    
                    {        
                        if((keywordArray[count].equals('and'))||(keywordArray[count].equals('or'))||(keywordArray[count]=='(' )||(keywordArray[count]==')' )||(keywordArray[count].equals('AND'))||(keywordArray[count].equals('OR'))||(keywordArray[count].equals('Or'))||(keywordArray[count].equals('And')))     
                        {
                            keywordTerm=keywordTerm+' '+keywordArray[count]; 

                        }      
                        else        
                        {              
                            keywordArray[count]='*'+keywordArray[count]+'*';
                            if((keywordArray[count-1]=='(' )||(keywordArray[count-1]== ')' ))
                            {
                                keywordTerm=keywordTerm+''+keywordArray[count];   

                            } 
                            else
                            {  keywordTerm=keywordTerm+' '+keywordArray[count];  

                            }
                        }                    
                    }
                }
            }

        }//end of for loop
        System.debug('#########KeywordTerm:'+keywordTerm);       
        System.debug('#######Input_Accounts:'+Input_Accounts.size());
        
        //SOSL Query to find AccountIds with the Keywordterm
        List<List<SObject>> searchList=[FIND :keywordTerm in all fields returning Keyword__c(Account__c where Account__c IN :Input_Accounts)];
        List<Keyword__c> accountsWithKeyWord = searchList[0];
        for(Keyword__c accountkeyword:accountsWithKeyWord)
            AccountIdKeyword.add(accountkeyword.Account__c);

        //Since SOSL can retrieve only 200 records,run the SOSL again to fetch more records  
        Integer counter=20;
        
         //For testclass,set the counter to 1 so that the SOSL is run only once(Otherwise,SOSL needs to be run 20 times)
         if(test.isRunningTest())
         {
            counter=1;
         }       
        Integer count=0;

        for(Integer i=0;i<counter;i++)
        {
            if(count>=200)
            { 
                count = 0;
                List<List<SObject>> searchList1=[FIND :keywordTerm in all fields returning Keyword__c(Account__c where Account__c IN :Input_Accounts and Account__c not in:AccountIdKeyword)];  
                List<Keyword__c> accountsWithKeyWord1 = searchList1[0];  
                for(Keyword__c accountkeyword1:accountsWithKeyWord1)
                {
                    AccountIdKeyword.add(accountkeyword1.Account__c);  
                    count++;
                }  
            }
            else
                i=20;  
        }
        
        //Clear the temporary lists
        if(accountsWithKeyWord.size()>0)
         accountsWithKeyWord .clear();
        
        //Return the list of AccountIds
        return AccountIdKeyword;
          
    }//End of method  
}//End of Class