public class AWStoSFDC{

@AuraEnabled
 public static List<Patient__c> callAWS(String PPSNumber) {
    // Name of files in the AWS
    List<String> fileNames = new List<String>{'PatientData'};
	List<Patient__c> patientList = new List<Patient__c>();
    //Get file contents
   
  
   
     //get Patient__c with taking refernce of PPSN field ;
    try{
         patientList = getCSVFileContent(fileNames, PPSNumber);
        system.debug('patientList--->'+patientList);

		 if(patientList.isEmpty()){
            throw new AuraHandledException('No Patient Records Found with '+PPSNumber); 
         }
            
    }Catch(DMLException de){
         System.debug('GetError---->'+de);
         return patientList;
     }
     return patientList;
 }

//Get file contents via HTTP Request
public static List<Patient__c> getCSVFileContent(list<string> fileNames, String PPSNumber) {
List<Patient__c> patientList = new List<Patient__c>();
    Http http = new Http();    
    HttpRequest request = new HttpRequest();
    FileMapping fileMapping = new FileMapping();
    for(String fileName : fileNames){
          
        // Set the request parameter
        setSetRequestParams(request, fileName);       
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('response'+response.getBody());
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
            patientList = parsePatientResponse(response,PPSNumber);
           
                                 
        } 
        else {
             System.debug(response.getBody());
            }
    }
    return patientList;
}

Public static List<Patient__c> parsePatientResponse(HttpResponse response,String PPSNumber){
    String[] csvFileLines = response.getBody().split('\n'); 
    List<Patient__c> patientlist = new List<Patient__c>();
    try{
        
        for(Integer i=1;i<csvFileLines.size();i++){
            String[] csvRecordData = csvFileLines[i].split(',');
            if(String.isNotBlank(PPSNumber) && String.isNotBlank(csvRecordData[0]) && PPSNumber.equalsIgnoreCase(csvRecordData[0])){
                Patient__c patientObj = new Patient__c() ;
                patientObj.PPS_Number__c = csvRecordData[0];
                patientObj.Salutation__c = csvRecordData[1];             
                patientObj.First_Name__c = csvRecordData[2];
                patientObj.Last_Name__c = csvRecordData[3];
                patientObj.Middle_Name__c = csvRecordData[4]; 
                patientObj.Passport_Number__c = csvRecordData[5];  
                patientObj.Marital_Status__c = csvRecordData[6];
                System.debug('@@csvRecordData[7] : '+csvRecordData[7]);
                patientObj.Date_of_Birth__c = date.parse(csvRecordData[7]);
                patientObj.Address_Line_1__c = csvRecordData[8]; 
                patientObj.Address_Line_2__c = csvRecordData[9];  
                patientObj.County__c = csvRecordData[10];
                patientObj.City__c = csvRecordData[11];
                patientObj.Country__c = csvRecordData[12];
                patientObj.Postal_Code__c = csvRecordData[13]; 
                patientObj.Contact_Number__c = csvRecordData[14];
                patientObj.Email__c = csvRecordData[15] ;
                patientlist.add(patientObj);  
            }
            }
     }
     catch (Exception exp)
     {
         //ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
        // ApexPages.addMessage(errorMessage);
        System.debug('Exception occurred : '+exp.getStackTraceString());
        throw new AuraHandledException('Unable to get patient records from AWS..'); 
         
     }

     return patientlist;
}

Public static void setSetRequestParams(HttpRequest request, string fileName){
    //String endPoint = 'callout:AWS/'+fileName+'.csv';
  //  String endPoint = 'callout:AWS/myppsndata/'+fileName+'.csv';
  String endPoint = 'callout:AWS/PatientData.csv';
    System.debug('@@@endPoint : '+endPoint);
    request.setEndpoint(endPoint);
    request.setMethod('GET');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    //request.setHeader('Host', 's3.amazonaws.com/myppsndata');
    System.debug('@@@request : '+request);
}

  public  class FileMapping{
    public List<Patient__c> patientRecords;
  }


}