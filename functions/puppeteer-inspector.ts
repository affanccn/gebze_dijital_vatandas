import puppeteer from 'puppeteer';
import * as fs from 'fs';

async function inspect() {
  const browser = await puppeteer.launch({ 
    headless: true,
    executablePath: "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
  });
  const page = await browser.newPage();
  await page.goto('https://www.sedas.com/Tr/SupplyContinuityUrl/PlannedView', { waitUntil: 'networkidle2' });
  
  // Wait a bit just in case
  await new Promise(r => setTimeout(r, 3000));
  
  const html = await page.content();
  fs.writeFileSync('sedas-rendered.html', html);
  await browser.close();
  console.log('Done rendering sedas');
}

inspect().catch(console.error);
