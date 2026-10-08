import * as cheerio from 'cheerio';
import { formatInTimeZone } from 'date-fns-tz';
import { WaterOutage, WaterOutagesData } from './isu.types';

export class IsuParser {
  static parse(html: string): WaterOutagesData {
    const $ = cheerio.load(html);
    const outages: WaterOutage[] = [];
    
    // We target only #InterruptionPanel2
    const panelHtml = $('#InterruptionPanel2').html();
    
    if (panelHtml) {
      const panel$ = cheerio.load(panelHtml);
      // Data is usually in list items or div rows inside this panel.
      // E.g., 'GEBZE / ARAPÇEŞME'
      panel$('li, .row, .item').each((i, el) => {
        const textContext = panel$(el).text().trim();
        if (textContext.includes('GEBZE /')) {
          // Attempt to extract details
          // "GEBZE / ARAPÇEŞME 07.10.2026 11:23 ile 07.10.2026 14:30 tarihleri arasında ..."
          const neighborhoodMatch = textContext.match(/GEBZE\s*\/\s*([^\d]+)/);
          const neighborhood = neighborhoodMatch ? neighborhoodMatch[1].trim() : '';

          // Look for dates like 07.10.2026 11:23
          const dateMatches = textContext.match(/(\d{2}\.\d{2}\.\d{4}\s\d{2}:\d{2})/g);
          
          let startStr = '';
          let endStr = '';
          
          if (dateMatches && dateMatches.length >= 2) {
            startStr = IsuParser.parseDate(dateMatches[0]);
            endStr = IsuParser.parseDate(dateMatches[1]);
          } else if (dateMatches && dateMatches.length === 1) {
            startStr = IsuParser.parseDate(dateMatches[0]);
          }

          // Very simple description extraction: the whole text after dates
          let description = textContext;
          if (dateMatches && dateMatches.length > 0) {
             const lastDate = dateMatches[dateMatches.length - 1];
             const parts = textContext.split(lastDate);
             if (parts.length > 1) {
               description = parts[1].replace(/tarihleri arasında/, '').trim();
             }
          }

          if (neighborhood) {
            outages.push({
              neighborhood,
              start: startStr,
              end: endStr,
              description
            });
          }
        }
      });
    }

    const now = new Date();
    const todayStr = formatInTimeZone(now, 'Europe/Istanbul', 'yyyy-MM-dd');

    return {
      district: 'GEBZE',
      date: todayStr,
      outages,
      source: 'ISU'
    };
  }

  // Convert DD.MM.YYYY HH:mm to ISO8601 in Europe/Istanbul
  private static parseDate(dateStr: string): string {
    const parts = dateStr.split(/[\s.]+/);
    if (parts.length === 5) {
      const day = parts[0];
      const month = parts[1];
      const year = parts[2];
      const time = parts[3]; // HH:mm format inside?
      // Since date-fns-tz parse might be complex without format string matching, we format manually:
      return `${year}-${month}-${day}T${time}:00+03:00`; 
    }
    return dateStr;
  }
}
