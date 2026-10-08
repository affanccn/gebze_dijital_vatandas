export interface Pharmacy {
  name: string;
  region: string;
  address: string;
  phone: string;
  latitude: number;
  longitude: number;
  start: string;
  end: string;
}

export interface PharmaciesData {
  district: string;
  date: string;
  pharmacies: Pharmacy[];
  source: string;
}
