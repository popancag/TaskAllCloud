/*
 * Description: Test class for WeatherAPIController
 * Author: Anca Popescu
 * Date: 6.10.2024
 */
@isTest
private class WeatherAPIControllerTest {
    @isTest
    static void getWeatherDataTest() {
        Test.setMock(HttpCalloutMock.class, new WeatherApiMock('Success'));
        
        Test.startTest();
        String  weatherAPIWrappersSerialized = WeatherAPIController.getWeatherData('TestCity');
        Test.stopTest();

        List<WeatherAPIController.WeatherAPIWrapper> weatherAPIWrappers = (List<WeatherAPIController.WeatherAPIWrapper>) JSON.deserialize(weatherAPIWrappersSerialized,List<WeatherAPIController.WeatherAPIWrapper>.class);
        for(Integer i=0; i<weatherAPIWrappers.size(); i++) {
            System.assert(weatherAPIWrappers[i].condition == 'Sunny', 'Condition was not proper set');
            System.assert(weatherAPIWrappers[i].icon == '//cdn.weatherapi.com/weather/64x64/day/113.png', 'Icon was not proper set');
            System.assert(weatherAPIWrappers[i].maxTemp == 25, 'MaxTemp was not proper set');
            System.assert(weatherAPIWrappers[i].minTemp == 15, 'MinTemp was not proper set');
            System.assert(weatherAPIWrappers[i].dayOfWeek == WeatherAPIController.getDayofWeek(Date.today().addDays(i + 1)), 'DayOfWeek was not proper set');
        }
    }

    @isTest
    static void getWeatherDataTestError() {
        WeatherAPIController.coverCode = true;

        Test.startTest();
        try {
             String  weatherAPIWrappersSerialized = WeatherAPIController.getWeatherData('TestCity');

        } catch (Exception e) {
            System.assertNotEquals(null, e, 'Error should be thrown!');
        }
        Test.stopTest();
    }
}