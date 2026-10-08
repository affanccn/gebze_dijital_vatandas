import { SedasService } from '../sources/sedas/sedas.service';
import { BaseRepository } from '../firestore/repositories/base.repository';
import { PowerOutagesData } from '../sources/sedas/sedas.types';

const sedasRepository = new BaseRepository<PowerOutagesData>('powerOutages');
const sedasService = new SedasService();

export const updatePowerOutages = async () => {
  console.log('Fetching SEDAS power outages data...');
  try {
    const data = await sedasService.fetchOutages();
    await sedasRepository.save(data);
    console.log('SEDAS power outages data saved successfully.');
  } catch (error) {
    console.error('Error fetching SEDAS data:', error);
    await sedasRepository.saveError(error, 'SEDAS');
  }
};
