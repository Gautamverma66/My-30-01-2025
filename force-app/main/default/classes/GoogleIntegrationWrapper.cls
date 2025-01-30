public class GoogleIntegrationWrapper {
	
	@AuraEnabled public cls_files[] files;
	class cls_files {
		@AuraEnabled public String kind;	
		@AuraEnabled public String mimeType;	
		@AuraEnabled public String id;	
		@AuraEnabled public String name;	
        @AuraEnabled public String webViewLink;
		@AuraEnabled public String webContentLink;
		@AuraEnabled public String shared;
	}
	public static GoogleIntegrationWrapper parse(String json){
		return (GoogleIntegrationWrapper) System.JSON.deserialize(json, GoogleIntegrationWrapper.class);
	}

	

}