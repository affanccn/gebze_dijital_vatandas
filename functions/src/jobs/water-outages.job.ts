import { IsuService } from '../sources/isu/isu.service';
import { BaseRepository } from '../firestore/repositories/base.repository';
import { WaterOutagesData } from '../sources/isu/isu.types';

const isuRepository = new BaseRepository<WaterOutagesData>('waterOutages');
const isuService = new IsuService();

export const updateWaterOutages = async () => {
  console.log('Fetching ISU water outages data...');
  try {
    const data = await isuService.fetchOutages();
    await isuRepository.save(data);
    console.log('ISU water outages data saved successfully.');
  } catch (error) {
    console.error('Error fetching ISU data:', error);
    await isuRepository.saveError(error, 'ISU');
  }
};
