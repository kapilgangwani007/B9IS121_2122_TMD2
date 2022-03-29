import { LightningElement,track,wire,api } from 'lwc';
import getPatientIdByPPSN from '@salesforce/apex/PatientController.getPatientIdByPPSN';
import validateReceptionist from '@salesforce/apex/PatientController.validateReceptionist';
import getPatientDetailsFromAWS from '@salesforce/apex/AWStoSFDC.callAWS';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class PatientRegistrationForm extends LightningElement {
@track patientRecords;
@track modifiedPatientRecords;
@track detailFromAWS;
showPatientInfo = false;
showRecords = false;
selectedPatientId = '';
isFirstDetailSubmitted= false;
newCreatedPatientId = '';
ppsnValue='';
salutation='';
firstName='';
lastName='';
middleName='';
passportNumber='';
maritalStatus='';
dob='';
addressLine1='';
addressLine2='';
county='';
city='';
postalCode='';
contactNumber='';
email='';
totalAmount;
amountPending;
amountWaivedOff;
amountPaid;
isTotalAmount= true;
isReceptionist = false;


   connectedCallback() {
        this.validateUser();
    }
    
    handleReset(event) {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleSeachByChange(event) {
        this.searchByValue = event.detail.value;
        this.seachKeyLabel = "Enter a "+this.searchByValue;
    }

    get searchByOptions() {
        return [
            { label: 'Medical Record #', value: 'Medical Record #' },
            { label: 'Name', value: 'Name' },
            { label: 'PPS Number', value: 'PPS Number' },
            { label: 'Contact Number', value: 'Contact Number' }
        ];
    }

    createNewPatient(event){
        this.isFirstDetailSubmitted = false;
        this.newCreatedPatientId = '';
        this.handleReset();
    }

    handleSearchKeyChange(event) {
        this.searchKeyValue = event.target.value;
    }

    handleCreateSuccess(event) {
        this.newCreatedPatientId = event.detail.id;
        this.showToastMessage('Success!','Success','Patient Record is created successfully.');
        this.isFirstDetailSubmitted = true;
    }

    handleUpdateSuccess(event) {
        this.showToastMessage('Success!','Success','Patient Record is updated successfully.');
        this.getPatientRecordByPPSN();
    }

    getPatientRecordByPPSN(){
        getPatientIdByPPSN({
                    ppsnumber: this.ppsnValue
                }).then(result => {
                   if(result != '' && result != null && result != undefined){
                        this.newCreatedPatientId = result;
                        this.isFirstDetailSubmitted = true;

                   }
                }).catch(error => {
                   this.showToastMessage('Error!','Error',error.body.message);
                });
    }

    
    handleCreateError(event){
       console.log('Error event : '+JSON.stringify(event));
       event.preventDefault();
        console.log('Error event : '+event.detail.detail);
        var errorMsg = event.detail.detail;
        if(errorMsg.includes('duplicates')){
            this.showToastMessage('Error!','Error','Patient record is already exist with PPS Number : '+this.ppsnValue);

        }
    }

    handlePPSNChange(event){
         this.ppsnValue = event.detail.value;
    }

    handleTotalAmount(event){
         this.totalAmount = event.detail.value;
         if(this.totalAmount != null && this.totalAmount != '' && this.totalAmount != undefined){
             this.isTotalAmount = false;

            if(this.amountPaid != null && this.amountPaid != '' && this.amountPaid != undefined && this.amountWaivedOff != null && this.amountWaivedOff != '' && this.amountWaivedOff != undefined){
                this.amountPending = this.totalAmount - this.amountPaid - this.amountWaivedOff;
            }else if(this.amountPaid != null && this.amountPaid != ''){
                this.amountPending = this.totalAmount - this.amountPaid;
            }else if(this.amountWaivedOff != null && this.amountWaivedOff != '' && this.amountWaivedOff != undefined){
                this.amountPending = this.totalAmount - this.amountWaivedOff;
            }
         }else{
             this.isTotalAmount = true;
             this.amountWaivedOff = 0;
             this.amountPending = 0;
             this.amountPaid = 0;
         }
         
    }

    handleWaivedOff(event){
         this.amountWaivedOff = event.detail.value;
         this.amountPending = this.amountPaid != null && this.amountPaid != '' && this.amountPaid != undefined 
         ? this.totalAmount - this.amountPaid - this.amountWaivedOff : this.totalAmount - this.amountWaivedOff;
         
    }

    handleAmountPaid(event){
         this.amountPaid = event.detail.value;
         
         this.amountPending = this.amountWaivedOff != null && this.amountWaivedOff != '' && this.amountWaivedOff != undefined 
         ? this.totalAmount - this.amountPaid - this.amountWaivedOff : this.totalAmount - this.amountPaid;
    }

    handlePPSNDetails(event){
       
        console.log('this.ppsnValue : '+this.ppsnValue);
        if(this.ppsnValue == '' || this.ppsnValue == null || this.ppsnValue == undefined){
            this.showToastMessage('Error!','Error','Please Enter PPS Number to get details.');
        }else{
            getPatientDetailsFromAWS({
                    PPSNumber: this.ppsnValue
                })
                .then(result => {
                    console.log('Result PPSN : '+JSON.stringify(result));
                   if(result != '' && result != null && result != undefined){
                      this.detailFromAWS = result;
                      console.log('this.detailFromAWS : '+this.detailFromAWS[0].Salutation__c);

                      this.salutation = this.detailFromAWS[0].Salutation__c;
                      this.firstName = this.detailFromAWS[0].First_Name__c;
                      this.middleName = this.detailFromAWS[0].Middle_Name__c;
                      this.lastName = this.detailFromAWS[0].Last_Name__c;
                      this.passportNumber = this.detailFromAWS[0].Passport_Number__c;
                      this.gender = this.detailFromAWS[0].Gender__c;
                      this.maritalStatus = this.detailFromAWS[0].Marital_Status__c;
                      this.dob = this.detailFromAWS[0].Date_of_Birth__c;
                      this.addressLine1 = this.detailFromAWS[0].Address_Line_1__c;
                      this.addressLine2 = this.detailFromAWS[0].Address_Line_2__c;
                      this.county = this.detailFromAWS[0].County__c;
                      this.city = this.detailFromAWS[0].City__c;
                      this.postalCode = this.detailFromAWS[0].Postal_Code__c;
                      this.contactNumber = this.detailFromAWS[0].Contact_Number__c;
                      this.email = this.detailFromAWS[0].Email__c;
                   }else{
                       this.showToastMessage('Error!','Error','No Patient Records Found with '+PPSNumber);
                   }
                })
                .catch(error => {
                   this.showToastMessage('Error!','Error',error.body.message);
                    this.patientRecords = null;
                     this.showRecords = false;
                     this.countOfRecords = 0;
                });
        }
    }

    validateUser(){
         validateReceptionist().then(result => {
                   console.log('result :: '+result);
                   if(result){
                       this.isReceptionist = true;
                   }else{
                      this.isReceptionist = false;
                   }
                }).catch(error => {
                    this.isReceptionist = false;
                   this.showToastMessage('Error!','Error',error.body.message);
                });
        }
    

    showToastMessage(header,type,msg) {
            const event = new ShowToastEvent({
                title: header,
                variant: type,
                message: msg
            });
            this.dispatchEvent(event);
    }
}