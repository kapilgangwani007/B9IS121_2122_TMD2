import { LightningElement } from 'lwc';
import hospital from '@salesforce/resourceUrl/hospital';
export default class HospitalHomePage extends LightningElement {
regReceptionistURL = '';
regDoctorURL = '';
regPatientURL = '';
searchPatientURL = '';
searchDocRecepURL = '';

    teamIcon = hospital + '/team.jpg';
    docIcon = hospital + '/Doctor.jpg';
    homeOneIcon = hospital + '/homeone.jpg';
    homeTwoIcon = hospital + '/hometwo.jpg';
    logoIcon = hospital + '/logo.jpg';
    patientIcon = hospital + '/patient.jpg';
    regPatientIcon = hospital + '/regpatient.jpg';
    receptionistIcon = hospital + '/receptionist.jpg';
    
    connectedCallback() {
        const linkToCase = window.location.origin +'/preg/s/';
                    
        this.regReceptionistURL = linkToCase+'doctor-receptionist-registration';
        this.regDoctorURL = linkToCase+'doctor-receptionist-registration';
        this.regPatientURL = linkToCase+'patient-registration';
        this.searchPatientURL = linkToCase+'search-patient';
        this.searchDocRecepURL = linkToCase+'search-doctor-receptionist';
    }
}