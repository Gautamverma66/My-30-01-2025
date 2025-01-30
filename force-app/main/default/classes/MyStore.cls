public class MyStore {
	List<WrapClass> myList=null;
    public List<WrapClass> cartList{get;set;}
    public List<WrapClass> shopList{get;set;}
    
    public List<WrapClass> getRecords(){
        if(myList==null){
            myList=new List<WrapClass>();
        }
        List<Merchandise__c> lt=[Select Name,Job_Description__c,Price__c,Total_Inventory__c From Merchandise__c];
        for(Merchandise__c m:lt){
            myList.add(new WrapClass(m));
        }
        return myList;
    }
    public PageReference addToCart()
    {
        if(cartList==null)
        {
            cartList=new List<WrapClass>();
        }
        for(WrapClass obj:myList)
        {
            if(obj.qtyToBuy>0)
            {
                obj.totalAmount=obj.qtyToBuy*obj.Price;
                cartList.add(obj);
            }
        }
        return null;
    }

    public PageReference shopNow()
    {
        if(shopList==null)
        {
            shopList=new List<WrapClass>();
        }
        for(WrapClass obj:cartList)
        {
            if(obj.checkStatus==true)
            {
                shopList.add(obj);
            }
        }
        return null;
    }

    
    public class WrapClass{
        Merchandise__c merch;
        public WrapClass(Merchandise__c merch){
            this.merch=merch;
        }
        public String Name{get{return merch.Name;}}
        public String Description{get{return merch.Job_Description__c;}}
        public Decimal Price{get{return merch.Price__c;}}
        public Boolean Stock{get { return (0 < merch.Total_Inventory__c);}}
        public Integer qtyToBuy{get;set;}
        public Boolean checkStatus{get;set;}
        public Decimal totalAmount{get;set;}

    }
}