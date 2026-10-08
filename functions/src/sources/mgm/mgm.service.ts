import axios from 'axios';
import { MgmParser } from './mgm.parser';
import { WeatherData } from './mgm.types';

export class MgmService {
  private static readonly BASE_URL = 'https://servis.mgm.gov.tr/web';
  
  // Gebze center id and hourly station id
  private static readonly GEBZE_MERKEZ_ID = 94103;
  private static readonly GEBZE_SAATLIK_IST_NO = 17066;

  async fetchWeather(): Promise<WeatherData> {
    // 1. Verify Center ID
    const centersRes = await axios.get(`${MgmService.BASE_URL}/merkezler?il=Kocaeli&ilce=Gebze`, {
        headers: { 'Origin': 'https://www.mgm.gov.tr' }
    });
    const center = centersRes.data[0];
    const merkezId = center?.merkezId || MgmService.GEBZE_MERKEZ_ID;
    const saatlikIstNo = center?.saatlikTahminIstNo || MgmService.GEBZE_SAATLIK_IST_NO;

    // 2. Fetch Data
    const [sondurum, gunluk, saatlik] = await Promise.all([
      axios.get(`${MgmService.BASE_URL}/sondurumlar?merkezid=${merkezId}`, { headers: { 'Origin': 'https://www.mgm.gov.tr' } }),
      axios.get(`${MgmService.BASE_URL}/tahminler/gunluk?istno=${merkezId}`, { headers: { 'Origin': 'https://www.mgm.gov.tr' } }),
      axios.get(`${MgmService.BASE_URL}/tahminler/saatlik?istno=${saatlikIstNo}`, { headers: { 'Origin': 'https://www.mgm.gov.tr' } })
    ]);

    // 3. Parse Data
    return MgmParser.parse(sondurum.data, gunluk.data, saatlik.data);
  }
}
