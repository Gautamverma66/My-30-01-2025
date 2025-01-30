public class ContactEmailField {
    public static void checkEmail(List<Contact> cList){
        for(Contact c:cList){
            String lt=UserInfo.getUserEmail();
            if(c.Email==null){
                c.Email=lt;
            }
            else if(c.Email==lt){
                c.Email.addError('Email is same as owner email change it!');
            }
        }
    }
}