/**
 * @Company     : Adobe Systems Inc.
 * @Description : 
 * ****************************************************************************************
 * The DeploymentTrackerCommon contains the methods that will be shared and called from
 * Deployment Tracker related classes.
 * ****************************************************************************************
 * @History     : 
 * [03.MARCH.2014] Code Creation
 */
 
public without sharing class DeploymentTrackerCommon {
    public DeploymentTrackerCommon() {
        
    }

//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */ 
    // Calling 
    /*
    DeploymentTrackerCommon theCaller = new DeploymentTrackerCommon();
    theCaller.createPackageXml('a8Of000000000aE', null);

    DeploymentTrackerCommon theCaller = new DeploymentTrackerCommon();
    String queryStr = 'Select Id, Name, Type__c, Full_Name__c From CR_Items__c Where Change_Request__c = \'a8Of000000000aJ\' AND Status__c = \'02 Deploy to SFQA\' AND Source__c = \'SFDC\' Order By Type__c, Component_Name__c ';
    theCaller.createPackageXml('a8Of000000000aJ', queryStr);
    */

    public void createPackageXml(String changeRequestId, String queryStr) {

        Map<String, Set<String>> mapPackage = readChangeRequestItems(changeRequestId, queryStr);
        String strXML = createXmlString(mapPackage);
        String strXmlDom = createXmlStringDOM(mapPackage);

        Blob txtBlob = Blob.valueOf(strXML); //Convert it to a blob
        Attachment attach = new Attachment(); //Make an attachment
        attach.Name ='Package.xml';  
        attach.Body = txtBlob;
        attach.ContentType = 'application/xml'; //Signal what the file's MIME type is
        attach.ParentID = changeRequestId;
        try {
            insert attach;
            System.debug(LoggingLevel.INFO, 'Package.xml Attached Sucessfully');
        } catch(Exception ex) {
            System.debug(LoggingLevel.INFO, 'Package.xml Attached Failed: ' + ex.getMessage()) ;
        }

    }

//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */ 

    public String createPackageXmlString(String changeRequestId, String queryStr) {

        Map<String, Set<String>> mapPackage = readChangeRequestItems(changeRequestId, queryStr);
        return createXmlString(mapPackage);
    }
  
//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  

    private static Map<String, Set<String>> readChangeRequestItems(Id changeRequestId, String queryStr) {

        Map<String, Set<String>> mapPackage = new Map<String, Set<String>>();

        if(queryStr == null) {
            queryStr = 'Select Id, Name, Type__c, Full_Name__c From CR_Items__c Where Change_Request__c = \'' + changeRequestId + '\' Order By Type__c, Component_Name__c ';
        }

        List<CR_Items__c> listCRItems = database.query(queryStr.trim());
        return readChangeRequestItems(listCRItems);
    }


//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  

    private static Map<String, Set<String>> readChangeRequestItems(List<CR_Items__c> listCRItems) {

        Map<String, Set<String>> mapPackage = new Map<String, Set<String>>();

        for(CR_Items__c crItem : listCRItems) {  
           
            String memberType = crItem.Type__c;
            String fullName = crItem.Full_Name__c;

            if(null != memberType && null != fullName) {

                Set<String> listMembers = new Set<String>();
                if(mapPackage.containsKey(memberType)) {
                    listMembers = mapPackage.get(memberType);
                }
                listMembers.add(fullName);
                mapPackage.put(memberType, listMembers);
            }
        }

        System.debug(LoggingLevel.INFO, 'mapPackage: ' + mapPackage);

        return mapPackage;
    }
    //------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  
    
    private static Map<String, Set<String>> sortPackageMap(Map<String, Set<String>> mapPackage) {
        Map<String, Set<String>> mapSortedPackage = new Map<String, Set<String>>();
        List<String> listComponent = new List<String>(mapPackage.keySet());
        // sort the list
        listComponent.sort();
        System.debug(LoggingLevel.INFO, 'listComponent ' + listComponent);
        for(String mapKey : listComponent) {
            List<String> listMembers = new List<String>(mapPackage.get(mapKey));
            // sort the list
            listMembers.sort();
            Set<String> setMembers = new Set<String>(listMembers);
            mapSortedPackage.put(mapKey, setMembers);
        }
        return mapSortedPackage;
    }

//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  

    private static Map<String, Set<String>> mergePackageMaps(
        Map<String, Set<String>> firstMapPackage, 
        Map<String, Set<String>> secondMapPackage
    ) {
        for(String mapKey : firstMapPackage.keySet()) {
            Set<String> firstMapValue = firstMapPackage.get(mapKey);
            Set<String> secondMapValue = secondMapPackage.get(mapKey);

            if(null != secondMapValue) {
                secondMapValue.addAll(firstMapValue);
            } else {
                secondMapPackage.put(mapKey, firstMapValue);
            }
        }
        return secondMapPackage;
    }           

//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  

    private String createXmlString(Map<String, Set<String>> mapPackage) {
       Xmlstreamwriter xmlW = new Xmlstreamwriter();
        // XML Begin
       xmlW.writeStartDocument(null,'1.0');
       xmlW.writeStartElement(null,'Package', null);
       xmlW.writeAttribute(null,null,'xmlns','http://soap.sforce.com/2006/04/metadata');

        List<String> listComponent = new List<String>(mapPackage.keySet());
        // sort the list
        listComponent.sort();
        System.debug(LoggingLevel.INFO, 'listComponent: ' + listComponent);
        for(String mapKey : listComponent) {
            // types elements
            xmlW.writeStartElement(null,'types',null);

            List<String> listMember = new List<String>(mapPackage.get(mapKey));
            listMember.sort();
            
            for(String memberStr : listMember) {
                // members elements
                xmlW.writeStartElement(null,'members',null);
                xmlW.writeCharacters(memberStr);
                xmlW.writeEndElement();
            }

            // typesElement elements
            xmlW.writeStartElement(null,'name',null);
            xmlW.writeCharacters(mapKey);
            xmlW.writeEndElement();

            xmlW.writeEndElement();
        }   
        
        //xmlW.writeEndElement();
        xmlW.writeEndDocument(); //Close XML document
        String xmlStringxmlRes = xmlW.getXmlString();
        xmlW.close();
        System.debug(LoggingLevel.INFO, 'xmlStringxmlRes: ' + xmlStringxmlRes);
        return xmlStringxmlRes;
    }

//------------------------------------------------------------------------------------------------
    /**
    * @Desc:    
    * @Param:   
    * @Return:  
    */  
    private static String createXmlStringDOM(Map<String, Set<String>> mapPackage) {
        System.debug(LoggingLevel.INFO, mapPackage);
        // root elements
        DOM.Document doc = new DOM.Document();
        String xmlns = 'http://soap.sforce.com/2006/04/metadata';
        
        dom.XmlNode packageNode = doc.createRootElement('Package', null, null);
        packageNode.setNamespace('', xmlns);
        packageNode.addChildElement('version', null, null).addTextNode('29.0');
        
        List<String> listComponent = new List<String>(mapPackage.keySet());
        // sort the list
        listComponent.sort();
        System.debug(LoggingLevel.INFO, ' listComponent ' + listComponent);
        for(String mapKey : listComponent) {
            // types elements
            dom.XmlNode membersTypes = packageNode.addChildElement('types', null, null);

            List<String> listMember = new List<String>(mapPackage.get(mapKey));
            listMember.sort();
            
            for(String memberStr : listMember) {
                // members elements
                membersTypes.addChildElement('members', null, null).addTextNode(memberStr);
            }

            // Add Types Name
            membersTypes.addChildElement('name', null, null).addTextNode(mapKey);
        }
        System.debug(LoggingLevel.INFO, 'doc.toXmlString(): ' + doc.toXmlString());
        return doc.toXmlString();
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public static String hashString(String stringToHash) {
        Blob input = Blob.valueOf(stringToHash);
        Blob bob = Crypto.generateDigest('MD5', input);
        return EncodingUtil.convertToHex(bob);
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Description:   
     * @param:  
     */  
    public static String calculateHashCriUniqueId(String crParentName, CR_Items__c crItem) {
        return hashString(crParentName + '-' + crItem.Type__c + '-' + crItem.Full_Name__c);
    }    
}