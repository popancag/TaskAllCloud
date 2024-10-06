/*
 * Description: Wrapper for parsing the Weather API
 * Author: Anca Popescu
 * Date: 6.10.2024
 */
public with sharing class WeatherWrapper {

      public Forecast forecast;

      public class Forecast{

        public List<ForecastDay> forecastDay;

      }

      public class ForecastDay{
        public Day day;
      }

      public class Day{
        public Double maxtemp_c;
        public Double mintemp_c;
        public Condition condition;
      }

      public class Condition{
        public String text;
        public String icon;
      }

      public static WeatherWrapper parse(String json){
		return (WeatherWrapper) System.JSON.deserialize(json, WeatherWrapper.class);
	}

}