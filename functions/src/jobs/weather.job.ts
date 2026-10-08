import { MgmService } from '../sources/mgm/mgm.service';
import { BaseRepository } from '../firestore/repositories/base.repository';
import { WeatherData } from '../sources/mgm/mgm.types';

const weatherRepository = new BaseRepository<WeatherData>('weather');
const mgmService = new MgmService();

export const updateWeather = async () => {
  console.log('Fetching MGM weather data...');
  try {
    const data = await mgmService.fetchWeather();
    await weatherRepository.save(data);
    console.log('MGM weather data saved successfully.');
  } catch (error) {
    console.error('Error fetching MGM weather data:', error);
    await weatherRepository.saveError(error, 'MGM');
  }
};
