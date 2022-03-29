trigger PatientTrigger on Patient__c (after update) {
SendAppointmentConfirmationMail.sendConfirmationMail();
}