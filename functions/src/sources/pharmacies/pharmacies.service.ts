import axios from 'axios';
import { formatInTimeZone } from 'date-fns-tz';
import { PharmaciesParser } from './pharmacies.parser';
import { PharmaciesData } from './pharmacies.types';

export class PharmaciesService {
  private static readonly URL = 'https://api.collectapi.com/health/dutyPharmacy?ilce=Gebze&il=Kocaeli';

  async fetchPharmacies(): Promise<PharmaciesData> {
    const now = new Date();
    const targetDateStr = formatInTimeZone(now, 'Europe/Istanbul', 'yyyy-MM-dd');
    
    // API Key `.env` dosyasından okunacak
    const apiKey = process.env.COLLECT_API_KEY;
    if (!apiKey) {
      console.warn('UYARI: COLLECT_API_KEY .env dosyasında bulunamadı! Eczane verisi çekilemiyor.');
      return { district: 'GEBZE', date: targetDateStr, pharmacies: [], source: 'CollectAPI' };
    }

    try {
      const res = await axios.get(PharmaciesService.URL, {
        headers: {
          'authorization': `apikey ${apiKey}`,
          'content-type': 'application/json'
        },
      });

      return PharmaciesParser.parse(res.data, targetDateStr);
    } catch (e) {
      console.error('CollectAPI Eczane Hatası:', e);
      return { district: 'GEBZE', date: targetDateStr, pharmacies: [], source: 'CollectAPI' };
    }
  }
}
