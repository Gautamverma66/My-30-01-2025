public with sharing class ClientSidePaginationLwc {

    //This method is use to get objects using schema class and return Map of object label and object api name
    @AuraEnabled(cacheable=true)
    public static Map<String,String> fetchObjects(){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        List<String> objList=new List<String>();
        Map<String, String> filterObjectMap = new Map<String, String>();
        String custLab=System.Label.customLabel;
        objectsMap=Schema.getGlobalDescribe();
        for (String objName : objectsMap.keySet()) {
            //Filter the objects
            if(custLab.contains(objectsMap.get(objName).getDescribe().getLabel())  || objectsMap.get(objName).getDescribe().isCustom() && !objectsMap.get(objName).getDescribe().isCustomSetting() ){
                    objList.add(objName);
            }
        }
        objList.sort();
        for(String str:objList){
            filterObjectMap.put(str, objectsMap.get(str).getDescribe().getLabel());
        }
        return filterObjectMap;
    }

    //This method is use to fetch selected object fields and then fillter the fields add in map of fileds api name and fields label name and then return the map
    @AuraEnabled
    public static Map<String,String> fetchFields(String objectName){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();

        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Schema.SObjectType obj=objectsMap.get(objectName);
        fieldsMap=obj.getDescribe().fields.getMap();
        
        List<String> fieldList=new List<String>();
        Map<String, String> filterFiledMap = new Map<String, String>();
        for(String fieldNam:fieldsMap.keySet()){
            //filter the fields 
            if(fieldsMap.get(fieldNam).getDescribe().isCreateable() && fieldsMap.get(fieldNam).getDescribe().isFilterable()  || fieldsMap.get(fieldNam).getDescribe().isCustom() || fieldsMap.get(fieldNam).getDescribe().isAutoNumber() || fieldsMap.get(fieldNam).getDescribe().isNameField()){
                fieldList.add(fieldNam);
            }
        }
        fieldList.sort();
        for(String str:fieldList){
            filterFiledMap.put(fieldsMap.get(str).getDescribe().getName(), fieldsMap.get(str).getDescribe().getLabel());
        }
        
        return filterFiledMap;
    }

    //In this method fetch records based on selected object and selected fields store in SObject type list and then return the list

    @AuraEnabled
    public static List<SObject> fetchRecords(List<String> fieldlist,String objectName){

        String queryStr='Select '+String.join(fieldlist,', ')+' From '+objectName;
        List<SObject> allRecordList=Database.query(queryStr);
       
        return allRecordList;
    }
}