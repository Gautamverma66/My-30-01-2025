public class KanbanViewController {
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
    	System.debug(objList);
        Integer count=0;
        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        for(String obj:objList){
            Schema.SObjectType objct=objectsMap.get(obj);
            fieldsMap=objct.getDescribe().fields.getMap();
            List<String> fieldList=new List<String>();
      
            for(String fieldNam:fieldsMap.keySet()){
                if(fieldsMap.get(fieldNam).getDescribe().getType()== Schema.DisplayType.Picklist){
                    fieldList.add(fieldNam);
            	}
        	}
            System.debug('Size--> '+fieldList.size());
            if(fieldList.size()>0){
               filterObjectMap.put(obj, objectsMap.get(obj).getDescribe().getLabel()); 
            }
            count++;
        }
        System.debug('count'+count);
        System.debug('add'+filterObjectMap.keySet().size());
    	return filterObjectMap;

    }
        
    @AuraEnabled
    public static Map<String,String> fetchPickListField(String objNam){
        System.debug('apex call');
        Map<String, String> filterFiledMap = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();
        Schema.SObjectType objct=objectsMap.get(objNam);
        fieldsMap=objct.getDescribe().fields.getMap();
        List<String> fieldList=new List<String>();
        
        for(String fieldNam:fieldsMap.keySet()){
            if(fieldsMap.get(fieldNam).getDescribe().getType()== Schema.DisplayType.Picklist){
                fieldList.add(fieldNam);
            }
        }
       	for(String str:fieldList){
            filterFiledMap.put(fieldsMap.get(str).getDescribe().getName(), fieldsMap.get(str).getDescribe().getLabel());
        }
        return 	filterFiledMap;
        
    }
     @AuraEnabled
    public static Map<Object,List<SObject>> fetchPickListFieldValue(String fieldNam,String objNam){
        System.debug(fieldNam);
        System.debug('apex call');
        Map<String, String> filterFiledMap = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldsMap=new Map<String, Schema.SObjectField>();
        Map<String, Schema.SObjectType> objectsMap=new Map<String, Schema.SObjectType>();
        objectsMap=Schema.getGlobalDescribe();
        Schema.SObjectType objct=objectsMap.get(objNam);
        fieldsMap=objct.getDescribe().fields.getMap();
        List<String> picklistValue=new List<String>();
        Map<Object,List<SObject>> recordMap=new Map<Object,List<SObject>>();
       
        list<Schema.PicklistEntry> values = fieldsMap.get(fieldNam).getDescribe().getPickListValues();
       	for (Schema.PicklistEntry val : values)
     	{ 
            System.debug('loop');
       	 	picklistValue.add(val.getValue()); 
     	}
        System.debug(picklistValue);

        for(String str:picklistValue){
             if(!recordMap.containsKey(str)){
                    recordMap.put(str,new List<SObject>());
                }
        }
        System.debug(recordMap);
        String queryStr='Select Id,Name,CreatedDate,OwnerId,'+fieldNam+' from '+objNam;
        System.debug(queryStr);
        List<SObject> record=Database.query(queryStr);
        System.debug(record);
        List<Object> temp=new List<Object>();
        String st=fieldNam;
        System.debug(st);
        for(SObject s:record){
            System.debug('loop1');
            System.debug(recordMap.get(s.get(st)));
            System.debug(s);
            if(recordMap.get(s.get(st)) != null){
                if(!recordMap.get(s.get(st)).contains(s)){
                    System.debug('if');
                     recordMap.get(s.get(st)).add(s);
                }
            }
           
           	      
        }
       
        
        return 	recordMap;
        
    }
    
    @AuraEnabled
    public static Map<Object,List<SObject>> updateRecords(ID recordId,String fieldValue,String objName,String newValue){
        System.debug('start update');
        System.debug('new-->'+newValue);
        Schema.SObjectType t = Schema.getGlobalDescribe().get(objName);
        SObject sObj = t.newSObject(recordId);
        sObj.put(fieldValue, newValue);
        Update sObj;
        return fetchPickListFieldValue(fieldValue,objName);
    }
    
    
    
	    
       
    
    
}