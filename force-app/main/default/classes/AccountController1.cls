public class AccountController1 {
    public Boolean b{get;set;}
	public Account acc{get;set;}
    public ID i{get;set;}
    public AccountController1(){
         acc =[Select Id,Name,Industry,Rating From Account Limit 1];
    }
    public pageReference save()
  	{
        upsert acc;
        return new ApexPages.StandardController(acc).view();
  	}
	 public pageReference quickSave(){
      
		upsert acc;
        i=acc.Id;
        b=true;
        return null;
    }
    public pageReference editPage(){
        b=false;
        return null;
    }
    public pageReference newAdd(){
        acc.Id=null;
        acc.Name=null;
        acc.Industry=null;
        acc.Rating=null;
        b=false;
        return null;
        
    }
    public pageReference delet(){
        try{
			delete acc;
        }
        catch(DmlException e) {
    		System.debug('The following exception has occurred: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
		}
        if(ApexPages.getMessages().size()==0){
			return new pageReference('https://briskminds58-dev-ed.develop.lightning.force.com/lightning/o/Account/list?filterName=Recent');
        } 
        
        return null;
    }
    public pageReference Refresh(){
       	acc=[Select Id,Name,Industry,Rating From Account Where Id=:i];
		b=true;
        return null;
    }
    
}