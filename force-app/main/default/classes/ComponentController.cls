public class ComponentController {     
    public Integer startNo{get;set;}                                //use in loop for wrapper class List
    public Integer endLoop{get;set;}                                //use in loop for wrapper class List
    public Integer page{get;set;}                                   //Number of current record page
    public Integer pageSize{get;set;}                               //set the page size 
    public Integer resultSize{get;set;}                             //total no of record
    public String csvString{get;set;}                               //CSV String
    public String queryStr{get;set;}                                //query String for finding records
    public String objName{get;set;}                                 //Object Name
    public String sortExpression{get;set;}                          //Column Name store for sorting
    public String sortDirection{get;set;}                           //Sorting direction ASC and DESC
    public String selectedId{get;set;}                              //Store Id for delete record       
    public String searchVar{get;set;}                               //Alpabet sorting chose character
    public List<SelectOption> totalList{get;set;}                   //selected list api name and label name
    public List<String> selectfields{get;set;}                      //selected list api name
    public List<String> selectfieldsLabel{get;set;}                 //selected list label name
    Public List<SObject> queryList{get;set;}                        //record list
    public List<String> alphaList{get;set;}                         //alphabet list
    public List<CheckBoxWrapperC> listWrapper{get;set;}             //wrapper list
    public List<CheckBoxWrapperC> listWrapperPagination{get;set;}   //wrapper list show data on UI

    public Apexpages.StandardSetController con {set;get;}           //StandardSetController
    
    public ComponentController(){
        startNo=0;
        endLoop=0;
        page=1;
        pageSize=5;
        resultSize=0;
        csvString=null;
        queryStr=null;
        sortExpression=null;
        selectedId=null;
        searchVar=null;
        sortDirection='DESC';
        alphaList=new  List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'};
        totalList=new List<SelectOption>();
        queryList=new List<SObject>();
        selectfields=new List<String>();
        selectfieldsLabel=new List<String>();
        listWrapper=new List<CheckBoxWrapperC>();
        listWrapperPagination=new List<CheckBoxWrapperC>();
        
    }
    
    //object change method call find all related records
    public void records(){
        pageSize=5;
        sortExpression=null;
        queryStr=null;
        listWrapper.clear();
        totalList.clear();
         for(Integer i=0;i<selectfields.size();i++){
            totalList.add(new SelectOption(selectfields[i],selectfieldsLabel[i]));
        }
      
        queryStr='Select '+string.join(selectfields,', ')+' From '+ objName;
        queryList=Database.query(queryStr);
        con = new Apexpages.StandardSetController(queryList);
        for(SObject s:queryList){
            listWrapper.add(new CheckBoxWrapperC(s));
        }
        startNo=0;
        
        recordDisplay();
           
    }

    //This method is use to display records on UI 
    public void recordDisplay(){
        
        listWrapperPagination.clear();
        con.setPageSize(pageSize);
        queryList=con.getRecords();
        page=con.getPageNumber();
        pageSize=con.getPageSize();
        resultSize=con.getResultSize();
      
        if(startNo==0){
            if(queryList.size()>=pageSize){
                for(Integer j=startNo;j<pageSize;j++){
                    listWrapperPagination.add(listWrapper[j]);
                    startNo++;
                }
            }
            else{
                for(Integer j=startNo;j<queryList.size();j++){
                    listWrapperPagination.add(listWrapper[j]);
                    startNo++;
                }
            }
            if(listWrapperPagination.size()<=0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'No Records'));
            }      
        
        }
        
     
    }
    //This method call when the page size is change
    public void pageSizeChange(){
        startNo=0;
        recordDisplay();
    }

    //first page method
    public void firstButton(){
        con.first();
        startNo=0;
        recordDisplay();
    }
    public void nextButton(){
        con.next();
        recordDisplay();
        
        if(listWrapper.size()<=(startNo+pageSize)){
            endLoop=listWrapper.size();
        }
        else{
            endLoop=pageSize+startNo;
        }
      
        for(Integer j=startNo; j<endLoop;j++){
            listWrapperPagination.add(listWrapper[j]);
        }
        startNo=startNo+pageSize;

    }
    public void perviousButton(){
        con.previous();
        recordDisplay();
        endLoop=startNo-pageSize;
        startNo=startNo-(2*pageSize);
        for(Integer j=startNo; j<endLoop;j++){
            listWrapperPagination.add(listWrapper[j]);
        }
        startNo=startNo+pageSize;
    }
    //Last page method
    public void lastButton(){
        con.last();
        recordDisplay();
        endLoop=listWrapper.size();
        startNo=(Integer)(Math.ceil(resultSize / PageSize))*pageSize;
        System.debug(startNo);
        for(Integer j=startNo;j<endLoop;j++){
            listWrapperPagination.add(listWrapper[j]);
        }
        startNo=startNo+pageSize;
    }

    //This method is use to delete one record 
    public void delLink(){
        
        String st='Select Id From '+objName+' Where Id = '+'\'' + selectedId +  '\'';
        List<Sobject> deletedRecordList=Database.query(st);
        Database.DeleteResult[] drList=Database.delete(deletedRecordList,false);
        records();
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Successfully deleted'));           
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));                
                   
                }
            }
        }
    }
    
    //This method is use to delete records in bulk
    public void deleteSelected(){
        Integer count=0;
        Database.DeleteResult[] drList;
        List<SObject> lt=new List<SObject>();
        for(CheckBoxWrapperC cw:listWrapper){
            if(cw.selectedCheckBox==true){
                lt.add(cw.obj);
                count++;
            }
        }
        if(count!=0){
            drList=Database.delete(lt,false);
            records();
        
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Successfully deleted'));           
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));                
                   
                }
            }
        }
        }
    }

    //This method is use for create the new record for selected object
    public pageReference newRecordCreate(){
        
        String st=Schema.getglobalDescribe().get(objName).getDescribe().getKeyPrefix();
        
        PageReference pageRef= new PageReference('/'+st+'/e?retURL=%2F'+st);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //This method is use to column sorting  base on selected column
    public pageReference columnSort(){
       
        
        listWrapper.clear();
        queryStr='Select '+string.join(selectfields,', ')+' From '+ objName;
        sortDirection=(sortDirection=='DESC')?'ASC':'DESC'; 
        string sortFullExp = sortExpression + ' ' + sortDirection;
        queryStr=queryStr+' order by '+sortFullExp;
        System.debug(queryStr);
        queryList=Database.query(queryStr);
        con = new Apexpages.StandardSetController(queryList);
        for(SObject s:queryList){
            listWrapper.add(new CheckBoxWrapperC(s));
         }  
        startNo=0;
        con.setPageNumber(1);
        recordDisplay();
        return null;
    }

    //This method is use to alphabet sorting on records(by default it sort on name column user can also select  different column)
    public pageReference alphaDisplay(){
            queryStr='Select '+string.join(selectfields,', ')+' From '+ objName;
            if(sortExpression==null){
                if(objName=='Case' || objName=='Solution'){
                    sortExpression=objName+'Number';
                }
                else{
                    sortExpression='Name';
                }
            }
            if(searchVar=='All'){
            
            }
            else if(searchVar=='Other'){
                String tempStr='A ';
                queryStr+=' Where '+sortExpression+'< :tempStr';
            }
            else{
                queryStr=queryStr+' Where '+sortExpression+' Like '+'\''+searchVar+'%\'';
            }
            sortDirection='ASC';
            listWrapper.clear();
            string sortFullExp = sortExpression + ' ' + sortDirection;
            queryStr=queryStr+' order by '+sortFullExp;
            System.debug(queryStr);
            queryList=Database.query(queryStr);
            System.debug(queryList);
            con = new Apexpages.StandardSetController(queryList);
            for(SObject s:queryList){
                listWrapper.add(new CheckBoxWrapperC(s));
            }  
            startNo=0;
            
            recordDisplay(); 
        
        return null;
    }

    //This method is call when user change the page number
    public void pageNumberChange(){
        listWrapperPagination.clear();
        startNo=page*pageSize-pageSize;
        Integer n=(Integer)Math.ceil(resultSize / PageSize);
        
        System.debug(n);
        if(page>(Integer)Math.ceil(resultSize / PageSize)){
            lastButton();
        }
        else if(page<=1){
            firstButton();
        }
        else{
            con.setPageNumber(page);
            recordDisplay();
            for(Integer j=startNo; j<(startNo+pageSize);j++){
                listWrapperPagination.add(listWrapper[j]);
                
            }
            startNo=startNo+pageSize;
        }
        
    }

    //Download CSV file of records 
    public void csvFile(){
        csvString=String.join(selectfields,', ')+'\\n';
        Integer count=0;
        for(CheckBoxWrapperC co:listWrapper){
            SObject o=co.obj;
            if(co.selectedCheckBox==true){
                for(Integer i=0;i<selectfields.size();i++){
                    csvString=csvString+'"'+(o.get(selectfields[i]))+'"'+', ';
                }
                csvString=csvString+'\\n';
                count++;
            }
        }
       

    
       
    }
}