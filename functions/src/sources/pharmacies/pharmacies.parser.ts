import { PharmaciesData, Pharmacy } from './pharmacies.types';

export class PharmaciesParser {
  static parse(apiResponse: any, targetDateStr: string): PharmaciesData {
    const pharmacies: Pharmacy[] = [];

    if (apiResponse && apiResponse.success && Array.isArray(apiResponse.result)) {
      for (const item of apiResponse.result) {
        // CollectAPI 'loc' alanında enlem,boylam veriyor "40.803,29.431"
        let lat = 0;
        let lng = 0;
        if (item.loc) {
          const parts = item.loc.split(',');
          if (parts.length === 2) {
            lat = parseFloat(parts[0]);
            lng = parseFloat(parts[1]);
          }
        }

        pharmacies.push({
          name: item.name || '',
          region: item.dist || 'Merkez', // API dist = Gebze veriyor, bölgesel gruplama istenirse adresden çıkarılabilir
          address: item.address || '',
          phone: item.phone || '',
          latitude: lat,
          longitude: lng,
          start: '08:30',
          end: '08:30 (Ertesi Gün)'
        });
      }
    }

    return {
      district: 'GEBZE',
      date: targetDateStr,
      pharmacies,
      source: 'CollectAPI'
    };
  }
}
