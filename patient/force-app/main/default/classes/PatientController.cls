public without sharing class PatientController {
	 @AuraEnabled
    public static list<Patient__c> getPatientRecordsBySearchKey(string searchOpted, string searchKey) {
        list<Patient__c> patientListRecord = new list<Patient__c>();    
        System.debug('searchOpted : '+searchOpted);
         System.debug('searchKey : '+searchKey);
        if(String.isBlank(searchOpted) ){
			 throw new AuraHandledException('Please Select Search by option..'); 
        }else if(String.isBlank(searchKey)){
             throw new AuraHandledException('Please Enter a '+searchOpted+' value to search..'); 
        }else{
        string searchKeyword = '%' + searchKey + '%';
        
        if(searchOpted == 'Medical Record #'){
            System.debug('Inside Medical Record #');
            patientListRecord = [Select Address_Line_1__c,Address_Line_2__c,Admitted_Date__c,Amount_Paid__c,
                                 Amount_Pending__c,Any_Disability__c,Any_Health_History_Related_Information__c,
                                 Any_other_Information__c,Billing_Status__c,City__c,Contact_Number__c,Country__c,
                                 County__c,CreatedById,CreatedDate,Date_of_Birth__c,Death_Date__c,Death_Reason__c,
                                 Discharge_Date__c,Do_you_drink__c,Do_you_smoke__c,
                                 Doctor_s_Consultation__c,Doctor_s_Prescribed_Medicine__c,Email__c,First_Name__c,
                                 Full_Name__c,Gender__c,Guardian_Address__c,Guardian_Contact_Number__c,
                                 Guardian_Name__c,Guardian_Relationship__c,Hospital_Name__c,Id,IsDeleted,
                                 Last_Name__c,LastActivityDate,LastModifiedById,LastModifiedDate,
                                 LastReferencedDate,LastViewedDate,Marital_Status__c,Middle_Name__c,
                                 Name,New_Patient__c,Next_Appointment_Date__c,Parent_Medical_Record_Number__c,
                                 Patient_need_to_take_any_tests__c,Postal_Code__c,PPS_Number__c,Salutation__c,
                                 Total_Amount__c,Passport_Number__c 
                                 FROM Patient__c
                                 WHERE Name LIKE : searchKeyword];
        }else if(searchOpted == 'Contact Number'){
            System.debug('Inside Contact Number');
            patientListRecord = [Select Address_Line_1__c,Address_Line_2__c,Admitted_Date__c,Amount_Paid__c,
                                 Amount_Pending__c,Any_Disability__c,Any_Health_History_Related_Information__c,
                                 Any_other_Information__c,Billing_Status__c,City__c,Contact_Number__c,Country__c,
                                 County__c,CreatedById,CreatedDate,Date_of_Birth__c,Death_Date__c,Death_Reason__c,
                                 Discharge_Date__c,Do_you_drink__c,Do_you_smoke__c,
                                 Doctor_s_Consultation__c,Doctor_s_Prescribed_Medicine__c,Email__c,First_Name__c,
                                 Full_Name__c,Gender__c,Guardian_Address__c,Guardian_Contact_Number__c,
                                 Guardian_Name__c,Guardian_Relationship__c,Hospital_Name__c,Id,IsDeleted,
                                 Last_Name__c,LastActivityDate,LastModifiedById,LastModifiedDate,
                                 LastReferencedDate,LastViewedDate,Marital_Status__c,Middle_Name__c,
                                 Name,New_Patient__c,Next_Appointment_Date__c,Parent_Medical_Record_Number__c,
                                 Patient_need_to_take_any_tests__c,Postal_Code__c,PPS_Number__c,Salutation__c,
                                 Total_Amount__c,Passport_Number__c 
                                 FROM Patient__c
                                 WHERE Contact_Number__c LIKE : searchKeyword];
        }else if(searchOpted == 'PPS Number'){
            System.debug('Inside PPS Number');
            patientListRecord = [Select Address_Line_1__c,Address_Line_2__c,Admitted_Date__c,Amount_Paid__c,
                                 Amount_Pending__c,Any_Disability__c,Any_Health_History_Related_Information__c,
                                 Any_other_Information__c,Billing_Status__c,City__c,Contact_Number__c,Country__c,
                                 County__c,CreatedById,CreatedDate,Date_of_Birth__c,Death_Date__c,Death_Reason__c,
                                 Discharge_Date__c,Do_you_drink__c,Do_you_smoke__c,
                                 Doctor_s_Consultation__c,Doctor_s_Prescribed_Medicine__c,Email__c,First_Name__c,
                                 Full_Name__c,Gender__c,Guardian_Address__c,Guardian_Contact_Number__c,
                                 Guardian_Name__c,Guardian_Relationship__c,Hospital_Name__c,Id,IsDeleted,
                                 Last_Name__c,LastActivityDate,LastModifiedById,LastModifiedDate,
                                 LastReferencedDate,LastViewedDate,Marital_Status__c,Middle_Name__c,
                                 Name,New_Patient__c,Next_Appointment_Date__c,Parent_Medical_Record_Number__c,
                                 Patient_need_to_take_any_tests__c,Postal_Code__c,PPS_Number__c,Salutation__c,
                                 Total_Amount__c,Passport_Number__c 
                                 FROM Patient__c
                                 WHERE PPS_Number__c LIKE : searchKeyword];
        }else{
            System.debug('Inside Name');
            patientListRecord = [Select Address_Line_1__c,Address_Line_2__c,Admitted_Date__c,Amount_Paid__c,
                                 Amount_Pending__c,Any_Disability__c,Any_Health_History_Related_Information__c,
                                 Any_other_Information__c,Billing_Status__c,City__c,Contact_Number__c,Country__c,
                                 County__c,CreatedById,CreatedDate,Date_of_Birth__c,Death_Date__c,Death_Reason__c,
                                 Discharge_Date__c,Do_you_drink__c,Do_you_smoke__c,
                                 Doctor_s_Consultation__c,Doctor_s_Prescribed_Medicine__c,Email__c,First_Name__c,
                                 Full_Name__c,Gender__c,Guardian_Address__c,Guardian_Contact_Number__c,
                                 Guardian_Name__c,Guardian_Relationship__c,Hospital_Name__c,Id,IsDeleted,
                                 Last_Name__c,LastActivityDate,LastModifiedById,LastModifiedDate,
                                 LastReferencedDate,LastViewedDate,Marital_Status__c,Middle_Name__c,
                                 Name,New_Patient__c,Next_Appointment_Date__c,Parent_Medical_Record_Number__c,
                                 Patient_need_to_take_any_tests__c,Postal_Code__c,PPS_Number__c,Salutation__c,
                                 Total_Amount__c,Passport_Number__c 
                                 FROM Patient__c
                                 WHERE Full_Name__c LIKE : searchKeyword];
        }
       
         if(patientListRecord.size() == 0){
            throw new AuraHandledException('No Patient Records Found..'); 
         }
        }
        System.debug('searchKey : '+patientListRecord);
        return patientListRecord;
    }
    @AuraEnabled
    public static String getPatientIdByPPSN(string ppsnumber) {
        String patientId = '';
         System.debug('ppsnumber : '+ppsnumber);
        if(String.isBlank(ppsnumber) ){
			 throw new AuraHandledException('Please Enter valid PPS Number..'); 
        }else{
			patientId = [Select Id FROM Patient__c WHERE PPS_Number__c =: ppsnumber Limit 1].Id;
        }
        System.debug('patientId : '+patientId);
        return patientId;
    }
    
    @AuraEnabled
    public static Boolean validateReceptionist() {
        Boolean isReceptionist = false;
        String userId = UserInfo.getUserId();
        System.debug('userId : '+userId);
        User usr = [Select Id,FederationIdentifier FROM USER WHere Id=:userId];
         System.debug('usr : '+usr);
        if(usr != null && String.isNotBlank(usr.FederationIdentifier) && usr.FederationIdentifier.StartsWith('Receptionist_')){
			 isReceptionist = true;
        }
        System.debug('isReceptionist : '+isReceptionist);
        return isReceptionist;
    }
}