public class ObjectsController2 {
	public Map<String,Schema.sObjectType> objsMap {get; set;}    //map for all the Objs    
    public Map<String,Schema.sObjectField> selectedObjFields {get; set;}    //map for selected Objs fields
    public List<SelectOption> objOptionsList {get; set;}        //list for selectList values
    public List<SelectOption> fieldList {get; set;}
    public String selectedVal {get; set;}                        //Selected value (SecA)
    public List<String> addField {get; set;}
    public String description {get; set;} 
    public String selectedLabel {get; set;}
       
    public ObjectsController2(){
        objsMap = Schema.getGlobalDescribe(); 
        objOptionsList = new List<SelectOption>();
        fieldList = new List<SelectOption>();
        SelectOption none = new SelectOption('None','-None-'); 
        objOptionsList.add(none);
        System.debug(Schema.getGlobalDescribe());
        System.debug(ObjsMap);
    
        for(String s : objsMap.KeySet() ){
            if(objsMap.get(s).getDescribe().isCreateable()){ 
                objOptionsList.add(new SelectOption(s,objsMap.get(s).getDescribe().getLabel()));
                //new SelectOption(value,Lable)
            } 
        }
        objOptionsList.sort();
        
       //System.debug(objsMap);
       // System.debug(objOptionsList);
       // System.debug(selectedVal);
             
    }
    
    public void fetchFields(){
       selectedObjFields = objsMap.get(selectedVal).getDescribe().fields.getMap();
       //selectedLabel = objsMap.get(selectedVal).getDescribe().getLabel();
       //Schema.DescribeSObjectResult myObj = objsMap.get(selectedVal).getDescribe();
       //description =''+ myObj;
       System.debug(selectedObjFields);
        for(String s : selectedObjFields.keySet()){
            fieldList.add(new selectOption(s,selectedObjFields.get(s).getDescribe().getLabel()));
        }
        fieldList.sort();
    }
}