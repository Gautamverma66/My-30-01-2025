import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchObjects from '@salesforce/apex/ClientSidePaginationLwc.fetchObjects'
import fetchFields from '@salesforce/apex/ClientSidePaginationLwc.fetchFields'
import fetchRecords from '@salesforce/apex/ClientSidePaginationLwc.fetchRecords'

export default class ClientSidePagination extends LightningElement {

    @api selectedObj;   
    @track objectList = [];
    @track fields =[];
    @track selectedValue=[];
    @track records=[];
    @track recordsOnPage=[];
    @track pageNO=[];
    @track allSelectedList=[];
    @track columnList=[]
    selectedObjLabelName;
    dataTableShow=false;
    fieldBOxShow=false;
    recordPerPageSize;
    totalPages=0;
    currentPageNo=0;
    sortColumn;
    sortedDirection;
    sortedColumn;
    isAsc = false;
    isDsc = false;
    @track isLoading=false;
    recordtableDisable=true;
    firstbuttonDisable=false;
    lastbuttonDisable=false
    recordSize=[10,15,20];

    // use this function to get object from apex then the result store in objectList property
    @wire(fetchObjects)
    result({ error, data }) {
    
        if (data) {
            this.objectList.push({ key: 'None', value: 'None' });
            for (let key of Object.keys(data)) {
                this.objectList.push({ key: key, value: data[key] });
            }
          
        } else if (error) {
            console.log('Error--> ', error);
        }
    }
   
    // this function is call when object value is change from ui select option list it return the list of selected object fields
    handleObjectChange(event) {
        console.log('Js Start handleObjectChange');
        this.isLoading=true;
        this.selectedObj =event.target.value;
        this.selectedValue=[];
        this.fields=[];
        this.columnList=[];

        if(this.selectedObj != 'None'){
            this.getSelectedObjFileds();
        }
        else{
            this.selectedValue = [];
            this.fields = [];
            this.records = [];
            this.recordsOnPage = [];
            this.pageNO = [];
            this.allSelectedList = [];
            this.fieldBOxShow = false;
            this.dataTableShow = false;
        } 
        this.isLoading=false;
    }

    //this function call inside of handleObjectChange function its return the selected object fields
    getSelectedObjFileds(){
        console.log('Js Start getSelectedObjFileds');
        this.fields=[];
        this.selectedValue=[];
        this.fieldBOxShow=true;
        this.dataTableShow=false;
        this.objectList.forEach(item => {
            if(item.key==this.selectedObj){
                this.selectedObjLabelName=item.value;
            }
        });
        fetchFields({ objectName: this.selectedObj })
        .then(result => {
           // Assuming the data is accessible directly from the Proxy object
            for (let key of Object.keys(result)) {
				this.fields.push({ value:key, label:result[key]});
			}

            this.fields.sort((a, b) => (a.label > b.label ? 1 : -1));
        })
        .catch(error => {
            console.error('Error:', error);
        });
        
    }
    
    //this function call when selectedValue change from dualList box and it use  show and hide the datatable 
    handleSelectedValuesChange(event){
        this.isLoading=true;
        this.selectedValue=[];
        this.columnList=[];
        this.selectedValue=event.detail.value;
        this.dataTableShow=false;
        this.isAsc = false;
        this.isDsc = false;
        this.sortedDirection='asc';
        this.isLoading=false;
    }

    //this function call when click on process button inside this call a method to get records from apex and store in records list   
    handleChild(){
        this.isLoading=true;
        this.fields.forEach(item => {
            if(this.selectedValue.includes(item.value)){
                this.columnList.push({ value:item.value, label:item.label});
            }
        });
        console.log('this.columnList-->',JSON.stringify(this.columnList));
        fetchRecords({ fieldlist:this.selectedValue,objectName: this.selectedObj })
        .then(result => {
            this.records=result;
            this.recordsOnPage=[];
            this.recordPerPageSize=10;
            if(this.recordPerPageSize>=this.records.length){
                this.recordPerPageSize=this.records.length;
            }
            for(let i=0;i<this.recordPerPageSize;i++){
                this.recordsOnPage.push(this.records[i]);
            }
            
            this.pageNoShow();
            this.dataTableShow=true;
            if(this.records.length==0){
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'No Records !',
                    variant: 'error'
                  });
                this.dispatchEvent(event);
                this.recordtableDisable=false;
            }
            else{
                this.recordtableDisable=true;
            }
            
        })
        .catch(error => {
            // Handle the error
            console.error('Error:', error);
        });

        this.isLoading=false;
    }

    //this function is use to show page No in the middle of first and last button like first,2,3,4,5,6,last
    pageNoShow(){
        console.log('pageNoShow function');

        this.totalPages=Math.ceil(this.records.length / this.recordPerPageSize);
        this.currentPageNo=1;
        this.pageNO=[];
        if(this.totalPages>2){
            if(this.totalPages>7){
                for(let i=2;i<7;i++){
                    this.pageNO.push({value:i,label:false});
                }
            }
            else{
                for(let i=2;i<this.totalPages;i++){
                    this.pageNO.push({value:i,label:false});
                }
            }
            
        }
        if(this.totalPages<7){
            this.pageNO=[];
            for(let i=2;i<7;i++){
                if(this.totalPages>i){
                    this.pageNO.push({value:i,label:false});
                }
                else{
                    this.pageNO.push({value:i,label:true});
                } 
            }
        }
        this.disableButtons();
    }
    //this function is call when record size change from ui show records according to selected size(10,15,20)
    recordPerPageShow(event){
        this.isLoading=true;
        this.recordsOnPage=[];
        this.recordPerPageSize =event.target.value;
        if(this.recordPerPageSize>=this.records.length){
            this.recordPerPageSize=this.records.length;
        }
       
        for(let i=0;i<this.recordPerPageSize;i++){
            this.recordsOnPage.push(this.records[i]);
        }
      
        this.pageNoShow();
        this.isLoading=false;
    }

    //this function call when click on first button in this method get starting 10 records 
    firstButton(event){
        console.log('first');
        this.isLoading=true;
        this.recordsOnPage=[];
        this.pageNO=[];
        this.recordSize=[10,15,20];
        if(this.recordPerPageSize>=this.records.length){
            this.recordPerPageSize=this.records.length;
        }
        for(let i=0;i<this.recordPerPageSize;i++){
            this.recordsOnPage.push(this.records[i]);
        }
        if(this.records.length==0){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'No Records !',
                variant: 'error'
              });
            this.dispatchEvent(event);
            this.recordtableDisable=false;
        }
        else{
            this.recordtableDisable=true;
        }
        this.pageNoShow();
        this.isLoading=false;
       
    }
   
    //this function call when click on last button to get last page records 
    lastButton(){
        this.isLoading=true;
        this.recordsOnPage=[];
        this.pageNO=[];
        
        for(let i= (this.totalPages-1) * this.recordPerPageSize;i<this.records.length;i++){
            this.recordsOnPage.push(this.records[i]);
        }
       
        this.currentPageNo=this.totalPages;
        if(this.totalPages-5>2){
                for(let i=this.totalPages-5;i<this.totalPages;i++){
                    this.pageNO.push({value:i,label:false});
                }
        }
        else {
            for(let i=2;i<this.totalPages;i++){
                this.pageNO.push({value:i,label:false});
            }
        }
        if(this.totalPages<7){
            this.pageNO=[];
            for(let i=2;i<7;i++){
                if(this.totalPages>i){
                    this.pageNO.push({value:i,label:false});
                }
                else{
                    this.pageNO.push({value:i,label:true});
                } 
            } 
        }
        this.disableButtons()
        this.isLoading=false;
        
    }
    //this function is call when click on page no button its return records according to slected page no and set the page numbers also
    buttonClick(event){
        this.isLoading=true;
        this.recordsOnPage=[];
        this.pageNO=[];
        this.currentPageNo =event.target.value;
        for(let i= (this.currentPageNo-1) * this.recordPerPageSize; i < this.currentPageNo * this.recordPerPageSize;i++){
            this.recordsOnPage.push(this.records[i]);
        }
        if(this.totalPages>this.currentPageNo){
            if((this.currentPageNo-2)>=2){
                if((this.currentPageNo+2) < (this.totalPages)){
                    for(let i=this.currentPageNo-2;i<=this.currentPageNo+2;i++){
                        this.pageNO.push({value:i,label:false});
                    }
                }
                else{
                    if(this.totalPages-5>2){
                        for(let i=this.totalPages-5;i<=this.totalPages-1;i++){
                            this.pageNO.push({value:i,label:false});
                        }
                    }
                    else{
                        for(let i=this.currentPageNo-2;i<=this.totalPages-1;i++){
                            this.pageNO.push({value:i,label:false});
                        }
                    }
                }
            }
            else{
                if(6 < (this.totalPages)){
                    for(let i=2;i<=6;i++){
                        this.pageNO.push({value:i,label:false});
                    }
                }
                else{
                    console.log('6');
                    for(let i=2;i<=this.totalPages-1;i++){
                        this.pageNO.push({value:i,label:false});
                    }
                }
            }  
        }
   
        this.disableButtons();
        console.log('15');
        this.isLoading=false;
    }
    //this function is use in column sorting when click on column acccording to selected column sort the records
    sortRecord(event){
        this.isLoading=true;
        console.log('sortRecord');
       this.sortColumn=event.currentTarget.dataset.id;
       this.sortData(this.sortColumn);
       this.isLoading=false;
    }
    sortData(sortColumnName) {
        console.log('sortColumnName');
        // check previous column and direction
       
            if (this.sortedColumn === sortColumnName) {
                this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
            } 
            else {
                this.sortedDirection = 'desc';
            }

            // check arrow direction
            if (this.sortedDirection === 'asc') {
                this.isAsc = true;
                this.isDsc = false;
            } 
            else {
                this.isAsc = false;
                this.isDsc = true;
            }

            // check reverse direction
            let isReverse = this.sortedDirection === 'asc' ? 1 : -1;

            this.sortedColumn = sortColumnName;

            // sort the data
            this.recordsOnPage = JSON.parse(JSON.stringify(this.recordsOnPage)).sort((a, b) => {
                a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
                b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';

                return a > b ? 1 * isReverse : -1 * isReverse;
            });;
        
    }
  
    //this method is use to maitain master checkbox
    handleAllSelected(event){
        console.log('parent-handleAllSelected');
        let selectedRows = this.template.querySelectorAll('lightning-input[data-key="rowCheckbox"]');
        console.log(selectedRows);
        selectedRows.forEach(row => {
            if (row.type == 'checkbox') {
                row.checked = event.target.checked;
                if(row.checked==true){
                    if(!this.allSelectedList.includes(row.value)){
                        this.allSelectedList.push(row.value);
                    }
                }
                else if(row.checked==false){
                    if(this.allSelectedList.includes(row.value)){
                        this.allSelectedList.splice(this.allSelectedList.indexOf(row.value),1);
                    }
                }
            }
        });
       
        
    }
    //this function is use to maintain child checkbox
    handleCheckboxSelect(){
        console.log('parent-handleCheckboxSelect');
        let selectedRows = this.template.querySelectorAll('lightning-input[data-key="rowCheckbox"]');
        let allSelected = true;
        selectedRows.forEach(currentItem => {
            if (!currentItem.checked && currentItem.type === 'checkbox') {
                allSelected = false;
                if(this.allSelectedList.includes(currentItem.value)){
                    this.allSelectedList.splice(this.allSelectedList.indexOf(currentItem.value),1);
                }
            }
            if(currentItem.checked && currentItem.type === 'checkbox'){
                if(!this.allSelectedList.includes(currentItem.value)){
                    this.allSelectedList.push(currentItem.value);
                }
                
            }
        });
        console.log('this.allSelectedList--> ',JSON.stringify(this.allSelectedList));
        let selectedRow = this.template.querySelector('lightning-input[data-key="allCheckbox"]');
        if(selectedRow != null){
            if (allSelected) {
                selectedRow.checked = true;
            } else {
                selectedRow.checked = false;
            }
            if(selectedRows.length==0){
                selectedRow.checked = false;
            }
        }

        
    }
    //this function call when renderedCallback call use to maintain child checkbox  on paginaton
    maintaincheckbox(event){
        console.log('parent-maintaincheckbox');
        let selectedRows = this.template.querySelectorAll('lightning-input[data-key="rowCheckbox"]');
        selectedRows.forEach(currentItem => {
            console.log('this.allSelectedList--> ',JSON.stringify(this.allSelectedList));
            if(this.allSelectedList.includes(currentItem.value)){
                if (currentItem.type == 'checkbox') {
                    console.log('if checkbox');
                    currentItem.checked = true;
                }
            }
            
        });
    }
    //this function is use to search records by its name 
    search(event){
        console.log('parent-search');
        this.isLoading=true;
        let searchName=event.target.value;
        let count=0;
        if(this.selectedValue.includes('Name')){
            if(searchName != ''){
            
                this.recordsOnPage=[];
                for(let rec of this.records){
                    if(rec.Name==searchName){
                        this.recordsOnPage.push(rec);
                        count++;
                    }
                }
                this.totalPages=Math.ceil(count / this.recordPerPageSize);
                this.disableButtons()
                if(this.totalPages<0){
                    this.totalPages=0;
                }
                this.pageNO=[];
                if(count>0){
                    this.currentPageNo=1;
                    if(this.totalPages>2){
                        if(this.totalPages>7){
                            for(let i=2;i<7;i++){
                                this.pageNO.push({value:i,label:false});
                            }
                        }
                        else{
                            for(let i=2;i<this.totalPages;i++){
                                this.pageNO.push({value:i,label:false});
                            }
                        }
                        
                    }
                    this.recordtableDisable=true;
                }
                else{
                    this.recordtableDisable=false;
                    this.currentPageNo=0;
                    
                    const event = new ShowToastEvent({
                        title: 'Error',
                        message: 'No Records Available !',
                        variant: 'error'
                      });
                      this.dispatchEvent(event);
                
                }
                if(count<=10){
                    this.recordSize=[10];
                }
                if(count<7){
                    this.pageNO=[];
                    for(let i=2;i<7;i++){
                        if(count>i){
                            this.pageNO.push({value:i,label:false});
                        }
                        else{
                            this.pageNO.push({value:i,label:true});
                        }
                        
                    }
                   
                }
            }
            else{
                this.firstButton();
            }
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Name Field are not Available !',
                variant: 'error'
              });
              this.dispatchEvent(event);
        }
        
        this.isLoading=false;
       
    }
    //this function is use to disable and enable  first and last button
    disableButtons(){
        console.log('parent-disableButtons');
        if(this.totalPages<=1){
            this.firstbuttonDisable=true;
            this.lastbuttonDisable=true;
        }
        else{
            this.firstbuttonDisable=false;
            this.lastbuttonDisable=false;
            
        }
        if(this.currentPageNo==this.totalPages){
            this.lastbuttonDisable=true;
        }
        if(this.currentPageNo==1){
            this.firstbuttonDisable=true;
        }
    }

    renderedCallback(){
        console.log('parent-renderedCallback');
        this.maintaincheckbox();
        this.handleCheckboxSelect();
       
    }

    constructor(){
        super();
        console.log('parent-constructor');
    }
    connectedCallback(){
        console.log('parent-connectedCallback');
    }
    

}