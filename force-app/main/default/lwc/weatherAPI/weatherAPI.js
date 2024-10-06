import { LightningElement, api, wire} from 'lwc';
import getWeatherData from '@salesforce/apex/WeatherAPIController.getWeatherData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { LABELS } from './labelsUtility';


export default class WeatherAPI extends LightningElement {
    @api recordId;
    @api cityFieldApiName;
    @api objectApiName;

    items;
    city;
    error = false;
    isLoading = true;

    get fieldsFormatted() {
        return [`${this.objectApiName}.${this.cityFieldApiName}`]; 
    }

    get labels() {
        return LABELS;
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: '$fieldsFormatted'
    })
    record({ error, data }) {
        if (data) {
            this.error = false;
            console.log('@@ in data');
            const cityField = data.fields[this.cityFieldApiName];
            if (cityField && cityField.value) {
                this.city = cityField.value;
            } else {
                this.city = null;
            }

            if (this.city) {
                getWeatherData({ city: this.city })
                .then((result) => {
                    this.isLoading = false;
                    this.error = false;
                    this.items = JSON.parse(result);
                })
                .catch((error) => {
                    this.isLoading = false;
                    this.error = true;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: this.labels.titleErrorLabel,
                            message: this.labels.messageErrorLocationLabel,
                            variant: this.labels.variantErrorLabel
                        })
                    );
                });
            } else {
                this.isLoading = false;
                this.error = true;
            }

        } else if (error) {
            this.isLoading = false;
            this.error = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.labels.titleErrorLabel,
                    message: this.labels.messageErrorLocationLabel,
                    variant: this.labels.variant
                })
            );

        }
    }
}