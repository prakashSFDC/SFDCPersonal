trigger InsertNewShipmentRecord on Opportunity (after update) {

List<Shipment__c> shipmentList = new List<Shipment__c>();

for(Opportunity O :Trigger.new)
{
    if(O.SubmitionStatus__c == 'Approved'){
        Shipment__c s=new Shipment__c(Opportunity__c=O.id,
        Id__c=O.AccountId,Delivery_Date__c=O.CloseDate);
        shipmentList.add(s);
    }
}
if(shipmentList!=null && shipmentList.size()>0) 
insert shipmentList;

}