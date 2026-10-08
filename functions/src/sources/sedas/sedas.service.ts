import puppeteer from 'puppeteer-extra';
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
puppeteer.use(StealthPlugin());
import { SedasParser } from './sedas.parser';
import { PowerOutagesData } from './sedas.types';
import { formatInTimeZone } from 'date-fns-tz';

export class SedasService {
  private static readonly URL = 'https://www.sedas.com/Tr/SupplyContinuityUrl/PlannedView';

  async fetchOutages(): Promise<PowerOutagesData> {
    const now = new Date();
    const targetDateStr = formatInTimeZone(now, 'Europe/Istanbul', 'yyyy-MM-dd');

    try {
      console.log('Sedaş için Puppeteer başlatılıyor...');
      const browser = await puppeteer.launch({ 
        headless: true,
        // Sunucuda veya lokalde Chrome yolunu belirtiyoruz (Gerekirse sunucu ortamına göre güncellenmeli)
        executablePath: "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe", 
        args: ['--no-sandbox']
      });

      const page = await browser.newPage();
      
      let interceptedData: any = null;
      
      // Sedaş'ın arka planda Kendo UI ile çektiği JSON verisini yakalıyoruz (Network Interception)
      page.on('response', async (response) => {
        const url = response.url();
        // Eğer grid datası çeken bir API URL'si içeriyorsa:
        if (url.includes('GetPlanned') || url.includes('SupplyContinuityUrl/List') || url.includes('Grid')) {
          try {
            const data = await response.json();
            if (data && data.Data) {
              interceptedData = data.Data;
            } else {
              interceptedData = data;
            }
          } catch(e) {}
        }
      });

      await page.goto(SedasService.URL, { waitUntil: 'networkidle2' });

      // İl ve ilçe seçim dropdown'larını bulup Kocaeli -> Gebze seçimi yapılması
      // Sedaş Kendo UI kullandığı için DOM elementlerini simüle edip tıklatıyoruz.
      // NOT: Aşağıdaki selectorler Sedaş sisteminin güncel HTML IDsine göre ayarlanmalıdır.
      try {
        // Örnek: İl seçimi
        // await page.click('span[aria-owns="CityId_listbox"]'); 
        // await page.click('li:contains("Kocaeli")');
        // await page.waitForTimeout(1000);
        // await page.click('span[aria-owns="CountyId_listbox"]');
        // await page.click('li:contains("Gebze")');
        // await page.click('#btnSearch'); // Ara butonu
        
        // Verilerin gelmesi için bekle
        await new Promise(r => setTimeout(r, 5000));
      } catch (interactionError) {
        console.log('Sedaş arayüz otomasyonu: Dropdown etkileşimi başarısız oldu veya henüz implement edilmedi.');
      }

      await browser.close();

      // Eğer sistemden canlı json alabildiysek onu parse et, yoksa boş veya fallback data dön
      if (interceptedData) {
         return SedasParser.parse(interceptedData, targetDateStr);
      } else {
         // Fallback Data
         console.warn('Sedaş canlı verisi yakalanamadı, mock veri dönülüyor.');
         return SedasParser.parse(null, targetDateStr); // Parser null durumunda fallback dönmeli
      }

    } catch (error) {
      console.error('Sedaş Puppeteer hatası:', error);
      return SedasParser.parse(null, targetDateStr);
    }
  }
}
