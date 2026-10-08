import { WeatherData } from './mgm.types';

export class MgmParser {
  static parse(sondurumData: any, gunlukData: any, saatlikData: any): WeatherData {
    // Current weather
    const current = sondurumData[0] || {};
    // Sun details are sometimes in daily
    const firstDaily = (gunlukData[0] && gunlukData[0].tarihGun1) ? gunlukData[0] : {};

    const daily = [];
    if (gunlukData[0]) {
      // MGM daily response usually contains properties like tarihGun1, tarihGun2, enDusukGun1, enYuksekGun1, vb.
      for (let i = 1; i <= 5; i++) {
        if (gunlukData[0][`tarihGun${i}`]) {
          daily.push({
            date: gunlukData[0][`tarihGun${i}`],
            minTemp: gunlukData[0][`enDusukGun${i}`],
            maxTemp: gunlukData[0][`enYuksekGun${i}`],
            condition: gunlukData[0][`hadiseGun${i}`] || '',
            conditionCode: gunlukData[0][`hadiseGun${i}`] || '',
          });
        }
      }
    }

    const hourly = [];
    if (saatlikData[0] && Array.isArray(saatlikData[0].tahmin)) {
      for (const item of saatlikData[0].tahmin) {
        hourly.push({
          time: item.tarih,
          temperature: item.sicaklik,
          condition: item.hadise,
          conditionCode: item.hadise,
        });
      }
    }

    return {
      district: 'GEBZE',
      location: {
        latitude: current.enlem || 40.8028,
        longitude: current.boylam || 29.4307,
      },
      current: {
        temperature: current.sicaklik || 0,
        condition: current.hadiseKodu || '',
        conditionCode: current.hadiseKodu || '',
        precipitation: current.yagis06Ihtimali || 0,
        observationTime: current.veriZamani || '',
      },
      sun: {
        sunrise: firstDaily.gunesDogus || '',
        sunset: firstDaily.gunesBatis || '',
      },
      daily: daily,
      hourly: hourly,
      source: 'MGM',
    };
  }
}
