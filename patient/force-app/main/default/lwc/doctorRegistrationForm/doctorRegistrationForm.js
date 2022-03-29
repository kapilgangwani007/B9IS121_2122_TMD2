import { LightningElement,track,wire,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import createDocUser from '@salesforce/apex/DoctorsController.createDocUser';
import validateReceptionist from '@salesforce/apex/PatientController.validateReceptionist';
import validateDocUser from '@salesforce/apex/DoctorsController.validateDocUser';
export default class DoctorRegistrationForm extends LightningElement {

firstName='';
middleName='';
lastName='';
gender='';
licenseNumber='';
availableDays='';
ppsnValue='';
doctorRole='';
dob='';
address='';
city='';
county='';
country='';
postalCode='';
email='';
phone='';
profession='';
isReceptionist= false;
showPersonalInfo = true;
newCreatedDoctorId ='';

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
                   this.showMessage('Error!','Error',error.body.message);
                });
        }

    showMessage(header,type,msg) {
            const event = new ShowToastEvent({
                title: header,
                variant: type,
                message: msg
            });
            this.dispatchEvent(event);
    }

    handleCreateSubmit(event){
        event.preventDefault();
          const fields = event.detail.fields;
          console.log('fields : '+fields);
          console.log('fields JSON: '+JSON.stringify(fields));
         
        this.validateExistingDoctor(fields);
    }
    
    handleCreateSuccess(event) {
        this.newCreatedDoctorId = event.detail.id;
        var contId = this.newCreatedDoctorId;
        console.log('this.newCreatedDoctorId : '+this.newCreatedDoctorId);
        this.createDoctorUser(contId);
        this.showMessage('Success!','Success','User is reggistered successfully.');
        this.showPersonalInfo = false;
    }

    handleCreateError(event){
       event.preventDefault();
       // console.log('Error event : '+event.detail.detail);
    }

    

    createDoctorUser(contId){
         console.log('contId 2: '+contId);
        createDocUser({
                    contactId: contId
                }).then(result => {
                   console.log('result :: '+result);
                   if(result != '' && result != null && result != undefined){
                       console.log('User is created successfully.');
                   }else{
                      this.showMessage('Error!','Error',result);
                   }
                }).catch(error => {
                   this.showMessage('Error!','Error',error.body.message);
                });
        }

    validateExistingDoctor(fields){
         console.log('emaiId : '+emaiId);
          var emaiId = fields.Email;
          console.log('emaiId 1 : '+emaiId);
        validateDocUser({
                    emailId: emaiId
                }).then(result => {
                   console.log('result :: '+result);
                   if(!result){
                       console.log('inside result false');
                       this.template.querySelector('lightning-record-edit-form').submit(fields);
                   }else{
                      this.showMessage('Error!','Error',result);
                   }
                }).catch(error => {
                   this.showMessage('Error!','Error',error.body.message);
                });
        }

    
}