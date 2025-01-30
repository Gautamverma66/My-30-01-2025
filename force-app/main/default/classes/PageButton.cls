public class PageButton {
    public List<Account> acc;
    public List<SelectOption> l{get;set;}
    public String filterId{get;set;}
    public boolean b{set;get;}
    public Integer page;
    public Integer pageSize{get;set;}
    public Integer resultSize{get;set;}
    String s ;
    String m ='Select Id,Name,Industry,Rating From Account';
    public Apexpages.StandardSetController controller {set;get;}
     
    public PageButton(){
          s ='Select Id,Name,Industry,Rating From Account';
          acc = Database.query(s);
         controller = new Apexpages.StandardSetController(acc);

         filterId='one';
     }
     public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('one','All Account'));
        options.add(new SelectOption('two','My Accounts'));
     
        return options;
    }
    public List<Account> getAccou(){
         
         acc = Database.query(s);
         
         List<Account> acc = (List<Account>) controller.getRecords();
       
        return acc;
    }
    public void filt(){
        
           if(filterId=='one'){
             System.debug(filterId);
            s=m;
            acc = Database.query(s);
            controller = new Apexpages.StandardSetController(acc);
            System.debug(s);
        }  
        if(filterId=='two'){
             System.debug(filterId);
            String str = ' 2023-03-10T11:30:00Z';
            s=s+' Where LastModifiedDate >'+str;
             acc = Database.query(s);
            controller = new Apexpages.StandardSetController(acc);
            System.debug(s);
        }
        
      
       
        
    }
   
     public pageReference saveAndRedirect()
  {
      
      update acc;
     
      PageReference submissionPage = new PageReference('https://briskmind3-dev-ed.develop.lightning.force.com/lightning/r/Account/0012w00001Ks5hOAAR/view');
      submissionPage.setRedirect(true);
      return submissionPage;
  }
    public void quickSave(){
        update acc;
        b=false;
    }
      public pageReference edit(){
        b=true;
        return null;
    }
    public Integer getre(){
         page=controller.getPageNumber();
        pageSize=controller.getPageSize();
        resultSize=controller.getResultSize();
        
        return page;
         }
    public void you(){
        controller.setPageSize(pageSize);
    }
    

}