export interface Location {
  latitude: number;
  longitude: number;
}

export interface CurrentWeather {
  temperature: number;
  condition: string;
  conditionCode: string;
  precipitation: number;
  observationTime: string;
}

export interface SunDetails {
  sunrise: string;
  sunset: string;
}

export interface DailyForecast {
  date: string;
  minTemp: number;
  maxTemp: number;
  condition: string;
  conditionCode: string;
}

export interface HourlyForecast {
  time: string;
  temperature: number;
  condition: string;
  conditionCode: string;
}

export interface WeatherData {
  district: string;
  location: Location;
  current: CurrentWeather;
  sun: SunDetails;
  daily: DailyForecast[];
  hourly: HourlyForecast[];
  source: string;
}
