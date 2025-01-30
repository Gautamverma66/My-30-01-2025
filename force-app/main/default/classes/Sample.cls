public class Sample{
	public Integer a=10;
    public List<Integer> fList;
    public List<Integer> firstList;
    public List<Integer> secondList;
    
    public List<Integer> getLMN(){
        if(fList==null){
            fList=new Integer[10];
        }
        for(Integer i=0;i<10;i++){
            fList[i]=i+1;
        }
        return fList;
    }
    public PageReference page1(){
        if(firstList==null){
            firstList=new Integer[10];
        }
        for(Integer i=0;i<10;i++){
            firstList[i]=10*(i+1);
        }
        return null;
    }
    public List<Integer> getABC(){
        return firstList;
    }
    public PageReference page2(){
        if(secondList==null){
            secondList=new Integer[10];
        }
        for(Integer i=0;i<10;i++){
            secondList[i]=fList[i]*(i+1);
        }
        return null;
    }
    public List<Integer> getXYZ()
    {
        system.debug('11111111111getXYZ'+secondList);
        return secondList;
    }


}