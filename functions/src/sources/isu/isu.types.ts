export interface WaterOutage {
  neighborhood: string;
  start: string;
  end: string;
  description: string;
}

export interface WaterOutagesData {
  district: string;
  date: string;
  outages: WaterOutage[];
  source: string;
}
