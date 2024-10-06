/*
 * Description: This class is the controller for WeatherAPI LWC
 * Author: Anca Popescu
 * Date: 6.10.2024
 */
public with sharing class WeatherAPIController {
    public static Boolean coverCode = false;
    /*
    * Description: This method is used to send weather data to LWC
    * Author: Anca Popeascu
    * Date: 6.10.2024
    */
    @AuraEnabled(cacheable=true)
    public static String getWeatherData(String city) {
        List<WeatherAPIWrapper> weatherAPIWrappers = new List<WeatherAPIWrapper>();
        try {
            if (Test.isRunningTest() && coverCode) {
                CalloutException e = (CalloutException)CalloutException.class.newInstance();
                e.setMessage('Error');
                throw e;
            }

            WeatherWrapper wheather = WeatherService.makeWeatherAPICalllout(city);
            List<WeatherWrapper.ForecastDay> forecastDays = wheather.forecast.forecastday;

            for (Integer i=0; i<forecastDays.size(); i++) {
                weatherAPIWrappers.add(new WeatherAPIWrapper(
                    forecastDays[i].day.condition.text,
                    forecastDays[i].day.condition.icon,
                    forecastDays[i].day.maxtemp_c,
                    forecastDays[i].day.minTemp_c,
                    getDayofWeek(Date.today().addDays(i + 1))
                ));
            } 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return JSON.serialize(weatherAPIWrappers);
    }
    

    /*
    * Description: This method transform a data into a day format
    * Author: Anca Popeascu
    * Date: 6.10.2024
    */
    public static String getDayofWeek(Date tomorrowsDate) {
        Datetime dt = DateTime.newInstance(tomorrowsDate.year(), tomorrowsDate.month(), tomorrowsDate.day());
        String dayOfWeek = dt.format('E');
        return dayOfWeek;
    }
     /*
    * Description: Wrapper for sending proper format to LWC
    * Author: Anca Popeascu
    * Date: 6.10.2024
    */
    public class WeatherAPIWrapper{
        public String condition{get;set;}
        public String icon{get;set;}
        public Double maxTemp{get;set;}
        public Double minTemp{get;set;}
        public String dayOfWeek{get;set;} 
        public WeatherAPIWrapper(String condition,String icon, Double maxTemp, Double minTemp, String dayOfWeek) {
            this.condition = condition;
            this.icon = icon;
            this.maxTemp = maxTemp;
            this.minTemp = minTemp;
            this.dayOfWeek = dayOfWeek;
        }
    }
}