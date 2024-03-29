// weatherController.cls
public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static String getWeather(String city) {
        String apiKey = 'f848c244e44758f37218da6c1b68cbf0';
        String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + apiKey;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            return 'Erro ao obter os dados meteorológicos.';
        }
    }
}
