public class mycontrollerEx {

    public PageReference loadfields() {
        return null;
    }

    public string currentobject { get; set; }
    public string currentfield { get; set; }
    
    public selectoption[] getobjects() {
        selectoption[] objects = new selectoption[0];
        map<string,schema.sobjecttype> describe = schema.getglobaldescribe();
        for(string objectname:describe.keyset()) {
            objects.add(new selectoption(objectname,describe.get(objectname).getdescribe().getname()));
        }
        return objects;
    }
    
    public selectoption[] getfields() {
        selectoption[] fields = new selectoption[0];
        map<string,schema.sobjecttype> describe = schema.getglobaldescribe();
        if(describe.containskey(currentobject)) {
            map<string,schema.sobjectfield> fieldmap = describe.get(currentobject).getdescribe().fields.getmap();
            for(string fieldname:fieldmap.keyset()) {
                fields.add(new selectoption(fieldname,fieldmap.get(fieldname).getdescribe().getlabel()));
            }
        }
        return fields;
    }
}