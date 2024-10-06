/*
 * Description: Test class for WeatherService
 * Author: Anca Popescu
 * Date: 06.10.2024
 */
@isTest
private class WeatherServiceTest {
    @isTest
    static void makeWeatherAPICallloutTestSuccess() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock('Success'));
        
        Test.startTest();
        WeatherWrapper wheather = WeatherService.makeWeatherAPICalllout('TestCity');
        Test.stopTest();

        System.assert(wheather != null, 'Weather body is null');
    }

    @isTest
    static void makeWeatherAPICallloutTestError() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock('Error'));
        
        Test.startTest();
        WeatherWrapper wheather = WeatherService.makeWeatherAPICalllout('TestCity');
        Test.stopTest();

        System.assert(wheather == null, 'Weather body is not null');
    }
}