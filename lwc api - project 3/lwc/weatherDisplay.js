
import { LightningElement, track } from 'lwc';
import getWeather from '@salesforce/apex/WeatherController.getWeather';

export default class WeatherComponent extends LightningElement {
    @track city = '';
    @track weatherData;
    @track weatherDescription;
    @track weatherIconUrl;
    @track temperatureInCelsius;

    handleChange(event) {
        this.city = event.target.value;
    }

    async getWeather() {
        try {
            const response = await getWeather({ city: this.city });
            this.weatherData = JSON.parse(response);
            this.weatherDescription = this.weatherData.weather[0].description;
            this.weatherIconUrl = `https://openweathermap.org/img/w/${this.weatherData.weather[0].icon}.png`;
            this.temperatureInCelsius = Math.round(this.weatherData.main.temp - 273.15);

        } catch (error) {
            console.error('Error fetching weather data', error);
        }
    }


}
