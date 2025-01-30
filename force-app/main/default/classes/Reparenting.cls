public class Reparenting {
    public static void parent(List<Contact> newC,List<Contact> oldC){
        if(newC[0].AccountId!=oldC[0].AccountId){
               Account a=[Select Rating from Account where Id=:newC[0].AccountId];
               Account a1=[Select Rating from Account where Id=:oldC[0].AccountId];
               a.Rating='Hot';
               a1.Rating='Cold';
               update a;
               update a1;
          }
      
      
    }
}