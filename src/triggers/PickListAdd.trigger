trigger PickListAdd on Account (after update,after insert){

    List<String> StatusValues = new List<String>();
    Schema.DescribeFieldResult fieldResult;
    fieldResult = Partner_Location__c.Status__c.getDescribe();
    for(Schema.PicklistEntry p : fieldResult.getPicklistValues())
            StatusValues.add(p.getValue());       

    private String testStatus ;
    private boolean booleanFlag=false;
    List<Account> currentAccount =[SELECT Status__c FROM Account WHERE Id IN :Trigger.new];
    for (Account acc: currentAccount) {
            testStatus = acc.status__c;
        }
    for(Schema.PicklistEntry p : fieldResult.getPicklistValues()){
            if(testStatus==p.getValue()){
                booleanFlag = true;
                break;
            }
        }
    List<Partner_Location__c> Locations = new List<Partner_Location__c>();
        List<Partner_Location__c> currentLocation =[SELECT Status__c FROM Partner_Location__c WHERE Account__r.Id IN :Trigger.new];
        for (Partner_Location__c loc: currentLocation) {
            if(booleanFlag){
                loc.status__c=testStatus;
            }
            else{
                loc.status__c='Testing';
            }
            Locations.add(loc); 
        }
    
        
    
    update Locations;
}