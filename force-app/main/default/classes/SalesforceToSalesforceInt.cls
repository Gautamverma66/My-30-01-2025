/* 
Handler name      :   SalesforceToSaleforceIntegration
Created by        :   Gautam
Created on        :   29th June 2023
Last modified by  :   04th July 2023
Description       :   Integration with Salesforce
*/
public with sharing class SalesforceToSalesforceInt {

    /**************************************************************************************
    * @Description      Get the contact list from another org
    * @Parameter        None
    * @Return           List of wrapper(in wrapper contact deatils available like name and id)
    ***************************************************************************************/
    @AuraEnabled
    public static List<WrapperSalesforceToSalesforceIntegration> fetchContacts(){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:SalesforceToSalesforce/services/apexrest/contact/');
        Http htt = new Http();
        HttpResponse res = htt.send(req);
        List<WrapperSalesforceToSalesforceIntegration> wrapData;
        if(res.getStatusCode()==200){
            System.debug(res);
            System.debug('body--> '+res.getBody());
            Map<String,Object> fileDat = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            System.debug(fileDat);
            String resu=JSON.serialize(fileDat.get('conList'));
            System.debug(resu);
            System.debug(fileDat);
            wrapData = (List<WrapperSalesforceToSalesforceIntegration>) JSON.deserialize(resu, List<WrapperSalesforceToSalesforceIntegration>.class);
            System.debug(wrapData);
        }
        return wrapData;
    }

     /**************************************************************************************
    * @Description      Get the Selected contact Files
    * @Parameter        contact id
    * @Return           List of wrapper(in wrapper Files deatils available like title id and type)
    ***************************************************************************************/
    @AuraEnabled
    public static  List<WrapperSalesforceToSalesforceIntegration> fetchFiles(String contactId){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:SalesforceToSalesforce/services/apexrest/contact/'+contactId);
        Http htt = new Http();
        HttpResponse res = htt.send(req);
        List<WrapperSalesforceToSalesforceIntegration> wrapData;
        if(res.getStatusCode()==200){
            System.debug(res);
            System.debug('body--> '+res.getBody());
            Map<String,Object> fileDat = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            System.debug(fileDat);
            String resu=JSON.serialize(fileDat.get('contentList'));
            System.debug(resu);
            System.debug(fileDat);
            wrapData = (List<WrapperSalesforceToSalesforceIntegration>) JSON.deserialize(resu, List<WrapperSalesforceToSalesforceIntegration>.class);
            System.debug(wrapData);

        }
        return wrapData;
    }

    /**************************************************************************************
    * @Description      upload files on selected contect
    * @Parameter        contact id,file name,file data
    * @Return           Boolean
    ***************************************************************************************/
    @AuraEnabled
   
        public static Boolean uploadFile(String contactId, String documentName, String documentData) {

            String endpointUrl = 'callout:SalesforceToSalesforce/services/apexrest/contact';
    
            // Create the JSON request body
            Map<String, Object> requestBody = new Map<String, Object>{
                'contactId' => contactId,
                'documentName' => documentName,
                'documentData' => documentData
            };
            String requestBodyJson = JSON.serialize(requestBody);
    
            // Create the HTTP request object
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBodyJson);
    
            // Create the HTTP object to send the request
            Http http = new Http();
    
            try {
                // Send the request and get the response
                HttpResponse response = http.send(request);
    
                // Process the response
                if (response.getStatusCode() == 200) {
                    // Successful response handling
                    String responseBody = response.getBody();
                    System.debug('Response Body: ' + responseBody);
                    return true;
                } else {
                    // Handle error response
                    System.debug('Error Response: ' + response.getBody());
                }
            } catch (Exception ex) {
                // Handle any exceptions
                System.debug('Exception: ' + ex.getMessage());
            }
            return false;
        }
    
    
    
   
}