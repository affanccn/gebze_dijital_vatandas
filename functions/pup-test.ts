import puppeteer from 'puppeteer';

async function test() {
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();
  await page.goto('https://www.kocaelieo.org.tr/nobetci-eczaneler', { waitUntil: 'networkidle2' });
  
  // They have a sidebar for Ilce. We need Gebze.
  // Wait, does the page load all by default?
  const html = await page.content();
  const fs = require('fs');
  fs.writeFileSync('pup.html', html);
  
  await browser.close();
  console.log('done');
}
test().catch(console.error);
