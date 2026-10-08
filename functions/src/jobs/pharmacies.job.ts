import { PharmaciesService } from '../sources/pharmacies/pharmacies.service';
import { BaseRepository } from '../firestore/repositories/base.repository';
import { PharmaciesData } from '../sources/pharmacies/pharmacies.types';

const pharmaciesRepository = new BaseRepository<PharmaciesData>('pharmacies');
const pharmaciesService = new PharmaciesService();

export const updatePharmacies = async () => {
  console.log('Fetching pharmacies data...');
  try {
    const data = await pharmaciesService.fetchPharmacies();
    await pharmaciesRepository.save(data);
    console.log('Pharmacies data saved successfully.');
  } catch (error) {
    console.error('Error fetching pharmacies data:', error);
    await pharmaciesRepository.saveError(error, 'KOCAELI_ECZACI_ODASI');
  }
};
