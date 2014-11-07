/*  
* File Name      : UPL_Utilities
* Description    : This class contains frequently used method for code optimization                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-23    Sathish           Created  
*   
*/

public class UPL_Utilities {

    /**
     * This method will return a string enclosed with Single quotes which can be used directly in dynamic SOQL
     * @author sathish_selvaraj
     * @since 04-Sep-2012
     * @param inputValue
     * @return sb
     */
    public static String getQuotedStringValue(String inputValue){
    
    StringBuffer sb=new StringBuffer('\'').append(inputValue).append('\'');
    return sb.toStr();
    
    }
      /**
     * This method will return a string enclosed with Single quotes and percentage  which can be used directly in dynamic SOQL
     * @author sathish_selvaraj
     * @since 04-Sep-2012
     * @param inputValue Eg: Motorola
     * @return sb - '%Motorola%'
     */
    public static String getQuotedWildCardStringValue(String inputValue){
    
    StringBuffer sb=new StringBuffer('\'').append('%').append(inputValue).append('%').append('\'');
    return sb.toStr();
    
    }
    
     /**
     * This method will return boolean true if the string is null 
     * @author nimesh_sharma
     * @since 04-Sep-2012
     * @param inputValue
     * @return boolean
     */
    public static Boolean isStringNull(String inputValue){
        Boolean checkStringNull = false;
        String trimmedInputValue ='';
        if( inputValue != null)
            trimmedInputValue = inputvalue.trim(); 
            
            if(trimmedInputValue == '' || trimmedInputValue == null || trimmedInputValue == 'None' || trimmedInputValue.length() == 0){
                checkStringNull = true;
            }
        
        return checkStringNull;
    }
    
    /**
     * This method will return boolean true if the List is null 
     * @author nimesh_sharma
     * @since 04-Sep-2012
     * @param inputValue
     * @return boolean
     */
    public static Boolean isListEmpty(List<String> inputList){
        Boolean checkListEmpty = false;
        if(inputList==null || (inputList.isEmpty() || inputList.size() == 0)){
            checkListEmpty = true;
        }
        
        return checkListEmpty;
    }
     /**
     * This method will return unique IDs
     * @author Sathish
     * @since 04-Sep-2012
     * @param listIDs
     * @return uniqueIDs
     */
    public static Set<ID> getUniqueIds(List<ID> listIDs){
        Set<ID> uniqueIDs=new Set<ID>();
        for(ID idValue:listIDs){
            uniqueIDs.add(idValue);
        }
        return uniqueIDs;
        
    }
     /**
     * This method will return recordType ID for Partner accounts
     * @author Sathish
     * @since 04-Sep-2012
     * @return ID
     */
    public static ID  getRecordTypeIDforPartnerAccount(){
        
        RecordType rec=[Select r.Id From RecordType r where r.SobjectType=:'Account' and r.name=:'Partner'];
        return rec.Id;
        
    }
 
}