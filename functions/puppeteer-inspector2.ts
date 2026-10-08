import puppeteer from 'puppeteer-extra';
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
puppeteer.use(StealthPlugin());
import * as fs from 'fs';

async function inspect() {
  const browser = await puppeteer.launch({ 
    headless: true,
    executablePath: "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
    args: ['--no-sandbox']
  });
  const page = await browser.newPage();
  
  await page.goto('https://www.sedas.com/Tr/SupplyContinuityUrl/PlannedView', { waitUntil: 'networkidle2' });
  
  await new Promise(r => setTimeout(r, 10000)); // wait 10s for cloudflare
  
  const html = await page.content();
  fs.writeFileSync('sedas-stealth.html', html);
  await browser.close();
  console.log('Done rendering sedas with stealth');
}

inspect().catch(console.error);
