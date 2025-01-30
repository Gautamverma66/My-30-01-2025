public class ServerSidePaginationControllerClass {

    
	@AuraEnabled
    public static Map<String,String> fatchObjects(){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        List<String> objList=new List<String>();
        Map<String, String> filterObjectMap = new Map<String, String>();
        String custLab=System.Label.customLabel;
        objectsMap=Schema.getGlobalDescribe();
        for (String objName : objectsMap.keySet()) {
            //Filter the objects
            if(custLab.contains(objectsMap.get(objName).getDescribe().getLabel())  || objectsMap.get(objName).getDescribe().isCustom() ){
                    objList.add(objName);
            }
        }
        objList.sort();
        for(String str:objList){
            filterObjectMap.put(str, objectsMap.get(str).getDescribe().getLabel());
        }
        System.debug(objList);
        return filterObjectMap;
    }
    @AuraEnabled
    public static Map<String,String> fatchFields(String objectName){
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();

        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Schema.SObjectType obj=objectsMap.get(objectName);
        fieldsMap=obj.getDescribe().fields.getMap();
        
        List<String> fieldList=new List<String>();
        Map<String, String> filterFiledMap = new Map<String, String>();
        for(String fieldNam:fieldsMap.keySet()){
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
    
    @AuraEnabled
    public static DataTableWrapper fatchData(List<String> fieldlt,String objectName, Integer pagSize,Integer pagNumber,String firstRecordId,String lastRecordId,String actionButton){
        System.debug(fieldlt);
        System.debug(objectName);
        System.debug(pagNumber);
        System.debug(pagSize);
        System.debug(firstRecordId);
        System.debug(lastRecordId);
        System.debug(actionButton);
        
        
        Integer totalRecod=database.countQuery('select count() from '+objectName);
        Integer lastpageRecord=(Integer)(totalRecod - Math.floor(totalRecod/pagSize)*pagSize);
        List<SObject> recordsList=new List<SObject>();
        String totalStr='Select Id,'+String.join(fieldlt,', ')+' From '+objectName;
        if(actionButton=='next'){
            totalStr+=' where Id> :lastRecordId Order By Id Limit '+pagSize;
        }
        else if(actionButton=='prev'){
            totalStr+=' where Id< :firstRecordId Order By Id DESC Limit '+pagSize;
        }
        else if(actionButton=='pageSizeChange' || actionButton=='first'){
            totalStr+=' Order By Id Limit '+pagSize;
        }
        else if(actionButton=='last'){
            totalStr+=' Order By Id DESC Limit '+lastpageRecord;
        }
        

        System.debug(totalStr); 
        List<SObject> allRecordList=Database.query(totalStr);
       
     /*   Integer startLoop;
        Integer endLoop;
        startLoop=pagNumber*pagSize;
        endLoop=(pagNumber+1)*pagSize;
        if(endLoop>=allRecordList.size()){
            endLoop=allRecordList.size();
        }
        for(Integer i=startLoop;i<endLoop;i++){
            recordsList.add(allRecordList[i]);
        }  */
       List<SObject> lt=new List<SObject>();
       DataTableWrapper datadetails=new DataTableWrapper();
        if(actionButton=='prev' || actionButton=='last'){
            for(Integer i=allRecordList.size()-1;i>=0;i--){
                lt.add(allRecordList[i]);
            }
            datadetails.dataList=lt;
        }
        else{
            datadetails.dataList=allRecordList;
        }
        datadetails.totalRecords=totalRecod;
        return datadetails;
    }


    public class DataTableWrapper {
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public List<SObject> dataList {get;set;}
    }
}