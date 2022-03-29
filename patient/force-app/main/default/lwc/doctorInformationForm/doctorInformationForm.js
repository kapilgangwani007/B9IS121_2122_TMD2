import { LightningElement,track,wire,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getSearchedRecords from '@salesforce/apex/DoctorsController.getSearchedRecords';

const actions = [
    { label: 'View details', name: 'view_details' }
];
const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Doctor Role', fieldName: 'Doctor_Role__c', type: 'text' },
    { label: 'Gender', fieldName: 'Gender__c', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'Phone' },
     {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class DoctorInformationForm extends LightningElement {
searchByValue = '';
searchKeyValue= '';
userData =[];
selectedRecordId ='';
columns = columns;
isModalOpen = false;
professionValue = '';
isUserDataAvailable = false;
    

    handleProfessionChange(event){
        this.professionValue = event.detail.value;
        console.log('this.professionValue before : '+this.professionValue);
        this.searchKeyValue = '';
        this.searchByValue = '';
        this.reset();
    }

    handleSeachByChange(event) {
        this.searchByValue = event.detail.value;
        console.log('this.searchByValue before : '+this.searchByValue);
        this.searchKeyValue = '';
         this.reset();
    }

    handleSearchKeyChange(event) {
        this.searchKeyValue = event.detail.value;
        if(this.searchKeyValue == undefined || this.searchKeyValue == '' ||this.searchKeyValue == null){
            this.reset();
        }
        
    }

    handleRowAction(event) {
        //const actionName = event.detail.action.name;
        this.selectedRecordId = event.detail.row.Id;
         console.log('create selectedRecordId : '+JSON.stringify(this.selectedRecordId));
        this.isModalOpen = true;
    }

    get searchByOptions(){
        console.log('searchByOptions : ');
         return [
            { label: 'First Name', value: 'firstName' },
            { label: 'Last Name', value: 'lastName' },
            { label: 'Doctor Role', value: 'Doctor_Role__c' },
            { label: 'Gender', value: 'Gender__c' },
            { label: 'Available Days', value: 'Available_Days__c' }
        ];
    }

    get professionOptions(){
        console.log('professionOptions : ');
         return [
            { label: 'Doctor', value: 'Doctor' },
            { label: 'Receptionist', value: 'Receptionist' }
        ];
    }

    handleSearchRecords(){
        getSearchedRecords({
                    professionValue: this.professionValue,
                    searchByValue: this.searchByValue,
                    searchKeyValue: this.searchKeyValue
                }).then(result => {
                    console.log('create result : '+JSON.stringify(result));
                    console.log('create result : '+JSON.stringify(result[0]));
                   if(result != '' && result != null && result != undefined){
                       this.userData =result;
                       this.isUserDataAvailable = true;
                       this.isModalOpen = false;
                    }else{
                        this.isUserDataAvailable = false;
                        this.isModalOpen = false;
                      this.showMessage('Error!','Error',result);
                   }
                }).catch(error => {
                    this.isUserDataAvailable = false;
                    this.isModalOpen = false;
                   this.showMessage('Error!','Error',error.body.message);
                });
    }

     closeModal() {
         this.isModalOpen = false;
         this.selectedRecordId = '';
    }

    reset(){
        this.isModalOpen = false;
        this.userData = [];
        this.selectedRecordId = '';
        this.isUserDataAvailable = false;
    }

    resetAll(){
        this.professionValue = '';
        this.searchByValue = '';
        this.searchKeyValue = '';
        this.isModalOpen = false;
        this.userData = [];
        this.selectedRecordId = '';
        this.isUserDataAvailable = false;
    }

    showMessage(header,type,msg) {
            const event = new ShowToastEvent({
                title: header,
                variant: type,
                message: msg
            });
            this.dispatchEvent(event);
    }
}