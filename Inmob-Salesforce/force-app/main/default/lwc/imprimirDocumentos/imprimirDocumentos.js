import { LightningElement,api, track, wire} from 'lwc';
import CONTRACT_OBJECT from '@salesforce/schema/Quote';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contrato__c.Name';

export default class ImprimirDocumentos extends LightningElement {
    @api recordId;
    @track allData = {};
    @track documents= [];

    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    wiredAccount({data, error}) {
        if (data) {
            this.allData.title = data.fields.Name.value;
            this.documents.push({name : "Autorización de Buró", url: "/apex/AutorizacionBuroPdf?id=" + this.recordId})
            this.documents.push({name : "Carta de Responsabilidad Cliente", url: "/apex/ResponsabilidadClientePdf?id=" + this.recordId})
            this.documents.push({name : "Declaración Y Autorización Pep Cii", url: "/apex/DeclaracionAutorizacionPepPdf?id=" + this.recordId})
            this.documents.push({name : "Entrevistas De Créditos", url: "/apex/EntrevistaCreditoPdf?id=" + this.recordId})
            this.documents.push({name : "Documento 5", url: "/apex/nada?id=" + this.recordId})
            this.documents.push({name : "Documento 6", url: "/apex/nada?id=" + this.recordId})
            this.documents.push({name : "Documento 7", url: "/apex/nada?id=" + this.recordId})
            this.documents.push({name : "Documento 8", url: "/apex/nada?id=" + this.recordId})
            this.documents.push({name : "Documento 9", url: "/apex/nada?id=" + this.recordId})
            this.documents.push({name : "Documento 10", url: "/apex/nada?id=" + this.recordId})
        }
    }

}