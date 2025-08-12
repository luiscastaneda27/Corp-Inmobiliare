import { LightningElement,api,track,wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getQuote from "@salesforce/apex/CrearContratoControlador.getQuote";
import saveData from "@salesforce/apex/CrearContratoControlador.saveData";

export default class CrearContrato extends NavigationMixin(LightningElement) {
    @api recordId;
    @track data = {showSpinner : true, step1: true, step2: false};

    connectedCallback() {
    }

    saveData() {
        this.data.showSpinner = true;
        var objContrato = {recordId : this.recordId, estado: this.data.estado, tipo: this.data.tipo }
        console.log('Vamos: ' + this.recordId);
        saveData({
            jsonData: JSON.stringify(objContrato)
        }).then(response => {
            console.log(JSON.stringify(response));
            this.pushMessage('Exitoso', 'success', 'El contrato se ha generado con éxito.');
            this.data.showSpinner = false;
            this.navigationContact(response);
        }).catch(e => {
            console.log('Error: ' + JSON.stringify(e));
            this.pushMessage('Error', 'error', 'Ha ocurrido un error, por favor contacte a su admin.' );
            this.data.showSpinner = false;
        });
    }

    handleClick(event){
        const name = event.target.name;
        const value = event.target.value;
        console.log('Name: ' + name);
        if(name == 'siguiente'){
            this.data.step1 = false;
            this.data.step2 = true;
        }
    }

    handleChange(even){
        const name = even.target.name;
        const value = even.target.value;

        if(name == 'estado'){
            this.data.estado = value;
        }if(name == 'tipo'){
            this.data.tipo = value;
        }
        console.log(this.data.estado +' ' + this.data.tipo);
    }

    @wire(getQuote, { recordId: '$recordId' })
    wiredQuotes({ data, error }) {
        if (data) {
            this.data.cuenta = data.cotizacion.CI_Cuenta__r.Name;
            this.data.proyecto = data.cotizacion.CI_Proyecto__r.Name;
            this.data.etapa = data.cotizacion.CI_Etapa__r.Name;
            this.data.manzana = data.cotizacion.CI_Manzana__r.Name;
            this.data.modelo = data.cotizacion.CI_Modelo__r.Name;
            this.data.lote = data.cotizacion.Lote__r.Name;
            this.data.optionsTipo = data.optionsTipo
            this.data.optionsEstados = data.optionsEstados;
            this.data.tipo = this.data.optionsTipo[0].value;
            this.data.estado = this.data.optionsEstados[0].value;
            this.data.showSpinner = false;
            
        } else if (error) {
            this.data.showSpinner = false;
        }
    }
    
    navigationContact(cttId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: cttId, 
                objectApiName: 'Contrato__c',
                actionName: 'view'
            }
        });
        
    }

    pushMessage(title,variant,msj){
        const message = new ShowToastEvent({
            "title": title,
            "variant": variant,
            "message": msj
            });
            this.dispatchEvent(message);
    }
    
}