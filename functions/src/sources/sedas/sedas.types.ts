export interface PowerOutage {
  neighborhood: string;
  start: string;
  end: string;
  description: string;
}

export interface PowerOutagesData {
  district: string;
  date: string;
  outages: PowerOutage[];
  source: string;
}
