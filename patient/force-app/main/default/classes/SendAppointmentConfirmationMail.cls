public without sharing class SendAppointmentConfirmationMail {
Public static void sendConfirmationMail(){
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Map<id,Patient__c> MapPatientIdToPatient = new Map<id,Patient__c>();
     
        for(Patient__c patientrecords : (list<Patient__c>)Trigger.new){
            Patient__c oldpatientrecords=(Patient__c)Trigger.oldMap.get(patientrecords.Id);
            if(String.isnotblank(patientrecords.Email__c) && patientrecords.Next_Appointment_Date__c != null && 
               (oldpatientrecords.Next_Appointment_Date__c == null || 
                oldpatientrecords.Next_Appointment_Date__c != patientrecords.Next_Appointment_Date__c)){
                   
                   MapPatientIdToPatient.put(oldpatientrecords.id, oldpatientrecords);     
                   
               }
        }
        
        if(!MapPatientIdToPatient.isEmpty()){
            String orgAddrId= '0D28d000000kAET';
                
                String template = '00X8d000000MJNU';
                for(Patient__c patientrecords: MapPatientIdToPatient.values()){
                    if(string.isnotblank(template) && string.isnotblank(orgAddrId)){
                    
                        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(template, null, patientrecords.id);
                        mail.setTemplateID(template);
                        mail.setSaveAsActivity(false);
                        mail.setReplyTo('NoReply@yopmail.com');
                        mail.setOrgWideEmailAddressId(orgAddrId);
                        
                        mail.setToAddresses(new List<string>{MapPatientIdToPatient.get(patientrecords.id).Email__c});
                        allmsg.add(mail);
                    }
                }
            }
            try{
                if(allmsg.size()>0){
                     List<Messaging.SendEmailResult> results = Messaging.sendEmail(allmsg,false);
                    system.debug('####allmsg'+allmsg);
                }
            }
            catch(Exception e){
                system.debug('Exception Occured');
            }       
        
    }
}