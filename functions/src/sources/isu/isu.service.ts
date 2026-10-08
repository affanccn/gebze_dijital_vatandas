import axios from 'axios';
import { IsuParser } from './isu.parser';
import { WaterOutagesData } from './isu.types';

export class IsuService {
  private static readonly URL = 'https://www.isu.gov.tr/index.aspx';

  async fetchOutages(): Promise<WaterOutagesData> {
    const res = await axios.get(IsuService.URL, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
      }
    });

    return IsuParser.parse(res.data);
  }
}
