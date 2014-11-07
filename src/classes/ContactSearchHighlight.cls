public class ContactSearchHighlight{
    public string srchArg{get;set;}
    public List<Contact> lstcontact {get;set;}
    public ContactSearchHighlight(){
        lstContact = [select id, name, details__c from contact where details__c != null];
    }
    
    public PageReference search(){
        string srchPhrase = '%' + srchArg + '%';
        lstContact = [select id, name, details__c from contact where details__c like :srchPhrase];
        
        for(Contact cnt: lstContact){
            cnt.details__c = highlightPhrase(cnt.details__c, srchArg);
        }
        
        return null;
    }
    
    public string highlightPhrase(string mainString, string phrase){
        mainString = mainString.toLowerCase().replaceAll(phrase.toLowerCase(), '<span class="highlight_word">' + phrase + '</span>');
        return mainString;
    }

}