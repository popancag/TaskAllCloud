/*
 * Description: This class is a mock for weatherAPI
 * Author: Anca Popescu
 * Date: 6.10.2024
 */
@isTest
global class WeatherApiMock implements HttpCalloutMock {
    private String responseType;

    public WeatherApiMock(String type) {
        this.responseType = type;
    }
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if (this.responseType == 'Success') {
            response.setBody('{"forecast": {"forecastday": [{"day": {"maxtemp_c": 25.0,"mintemp_c": 15.0,"condition": {"text": "Sunny","icon": "//cdn.weatherapi.com/weather/64x64/day/113.png","code": 1000}}}]}}'); 
            response.setStatusCode(200);
        } else {
            response.setStatusCode(400);
        }

        return response;
    }
}