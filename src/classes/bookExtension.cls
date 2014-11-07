public with sharing class bookExtension {
    private ApexPages.StandardController controller;

    private Set<String> bookFields = new Set<String>();
    
    public bookExtension (ApexPages.StandardController controller) {
        this.controller = controller;
        Map<String, Schema.SobjectField> fields = 
        Schema.SobjectType.Book__c.fields.getMap();

        for (String s : fields.keySet()) {
        system.debug('###### HI');
        // Only include accessible fields 
            if (fields.get(s).getDescribe().isAccessible() && 
                fields.get(s).getDescribe().isCustom()) {
                    bookFields.add(s);
            }
        }
    }
    
    public  List<String> availableFields {
        get {
           // controller.reset(); 
            controller.addFields(new List<String>(bookFields));
                return new List<String>(bookFields);
        }
    }
}