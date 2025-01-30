public class ObjectsController1 {
    public boolean fieldPanel{get;set;}                               //Selectedfield List rendered
    public boolean addbuttonDis{get;set;}                             //Add button disable and enable
    public boolean removebuttonDis{get;set;}                          //Remove button disable and enable
    public boolean compPageRe{get;set;}                               //Component page show and hide
    public boolean resetButt{get;set;}                                //Reset button disable and enable
    public boolean processButtonDis{get;set;}                         //Process button disable and enable
    public String objNameShow{get;set;}                               //Selected Object LabelName
  	public String selectObject{get;set;}                              //Selected Object ApiName
    public Set<String> fieldsAdd {get;set;}                           //Selected Object all field label 
    public List<String> fieldQuery{get;set;}                          //Selected Field Api Name for Component page
    public List<String> fieldQueryLabel{get;set;}                     //Selected Field Label Name for Component page
   	public List<SelectOption> fields1 {get;set;}                      //Non Selected Fields Show on UI page
    public List<SelectOption> options {get;set;}                      //Objects List
    public List<String> selectedList{get;set;}                        //Selected Field List by user 
    public Set<String> selectedSet{get;set;}                          //Selected Field List by user convert in Set
    public List<String> reSelectedList{get;set;}                      //Selected Field List box to again selected 
    public List<SelectOption> selectedFieldList{get;set;}             //Selected Field list show on UI
    public Map<String, Schema.SObjectType> allObjects{get;set;}       //Objects map
    Public Map<String,Schema.SObjectField> fieldsMap{get;set;}        //All Fields map
    public Map<String,String> filedsValueMap{get;set;}                //Filter Field value and Label
    Public String custLab{get;set;}                                   //Custom Label
   

    public ObjectsController1() {
        fieldPanel=false;
        addbuttonDis=false;
        removebuttonDis=false;
        compPageRe=false;
        processButtonDis=false;
        custLab=System.Label.customLabel;
        fieldsAdd=new Set<String>();
        fieldQuery=new List<String>();
        fieldQueryLabel=new List<String>();
        selectedSet=new Set<String>();
        fields1=new List<SelectOption>();
        selectedList=new List<String>();
        reSelectedList=new List<String>();
        selectedFieldList=new List<SelectOption>();
        options= new List<SelectOption>();
        fieldsMap=new Map<String,Schema.SObjectField>();
        filedsValueMap=new Map<String,String>();
        options.add(new SelectOption('None', '--None--'));
        allObjects = Schema.getGlobalDescribe();
        
        //Objects find in org

        for (String objName : allObjects.keySet()) {
            //Filter the objects
            if(custLab.contains(allObjects.get(objName).getDescribe().getLabel())  || allObjects.get(objName).getDescribe().isCustom() ){
                    options.add(new SelectOption(objName, allObjects.get(objName).getDescribe().getLabel()));
            }
        }
        options.sort();
        resetButt=true;
      
    }
    
    //This method is use to find selected objects fields

    public void objFields(){
        
        objNameShow=null;
        objNameShow=allObjects.get(selectObject).getDescribe().getLabel();

        fieldsAdd.clear();
        selectedSet.clear();
       

        String s=options.get(0).getLabel();
        if(s=='--None--'){
            options.get(0).setDisabled(true);
        }
        if(selectObject!='None'){
            Schema.SObjectType obj=allObjects.get(selectObject);
            fieldsMap=obj.getDescribe().fields.getMap();
            
            for(String fieldNam:fieldsMap.keySet()){
                if(fieldsMap.get(fieldNam).getDescribe().isCreateable() && fieldsMap.get(fieldNam).getDescribe().isFilterable()  || fieldsMap.get(fieldNam).getDescribe().isCustom() || fieldsMap.get(fieldNam).getDescribe().isAutoNumber() || fieldsMap.get(fieldNam).getDescribe().isNameField()){
                    filedsValueMap.put(fieldsMap.get(fieldNam).getDescribe().getLabel(),fieldNam);
                    fieldsAdd.add(fieldsMap.get(fieldNam).getDescribe().getLabel());
                }
            }
            fieldsBoth();
            fieldPanel=true;
            compPageRe=false;
            resetButt=false;
        }
        
    }

    //This method is use for both add and remove field operation
    public void fieldsBoth(){
        fields1.clear();
       	fieldQuery.clear();
        fieldQueryLabel.clear();
        selectedFieldList.clear();
        for(String s:fieldsAdd){
            fields1.add(new SelectOption(s,s));
        }
    
        for(String s:selectedSet){
            selectedFieldList.add(new SelectOption(s,s));
            fieldQuery.add(filedsValueMap.get(s));
            fieldQueryLabel.add(s);
        }

        fields1.sort();
        selectedFieldList.sort();
        removebuttonDis=selectedFieldList.isEmpty();
        processButtonDis=!fieldQuery.isEmpty();
        addbuttonDis=fieldsAdd.isEmpty();
        if(selectedList.size()>0 || reSelectedList.size()>0 ){
            compPageRe=false;
        }
        selectedList.clear();
        reSelectedList.clear();
        
    }
    
    //This method use to add field in selected fields on add button click
    public void addButton(){
        fieldsAdd.removeAll(selectedList);
        selectedSet.addAll(selectedList);
        fieldsBoth();
        
    }
  	
    //This method is use to remove fields in selected fields on remove button click
    public void removeButton(){
        fieldsAdd.addAll(reSelectedList);
        selectedSet.removeAll(reSelectedList);
        fieldsBoth(); 
       
      
    }
    
    //This method is use to reset the fill data and hide all panel
    public void resetButton(){
        selectObject='None';
        selectedFieldList.clear();
        fieldQuery.clear();
        fieldsAdd.clear();
        selectedSet.clear();
        fields1.clear();
       	fieldQuery.clear();
        fieldQueryLabel.clear();

        resetButt=true;
        compPageRe=false;
        fieldPanel=false;
    }

    //This method is use to show the Record page (Component page call the record method)
    public void processButton(){
        compPageRe=true;
       
    }
  
    
}