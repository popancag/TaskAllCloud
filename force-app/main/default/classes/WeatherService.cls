/*
 * Description: This class is used to send the request to Weather API
 * Author: Anca Popescu
 * Date: 6.10.2024
 */
public with sharing class WeatherService {
     /*
    * Description: This method is used to send the get request to Weather API
    * Author: Anca Popescu
    * Date: 6.10.2024
    */
    public static WeatherWrapper makeWeatherAPICalllout(String city) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Weather?q=' + city + '&days=6');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            WeatherWrapper weather = WeatherWrapper.parse(response.getBody());
            System.debug(weather);
            return weather;
        }
        return null;
    }
}
