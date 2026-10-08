import 'dotenv/config';
import { initializeApp, cert } from 'firebase-admin/app';
import * as cron from 'node-cron';
import { updateWeather } from './jobs/weather.job';
import { updatePharmacies } from './jobs/pharmacies.job';
import { updateWaterOutages } from './jobs/water-outages.job';
import { updatePowerOutages } from './jobs/power-outages.job';

// Ensure you have the JSON file inside the `functions` directory
const serviceAccount = require('../serviceAccountKey.json');

initializeApp({
  credential: cert(serviceAccount)
});

console.log('Firebase Admin initialized. Setting up cron jobs...');

// Run immediately on startup for the first time
console.log('Running initial data fetch...');
updateWeather();
updatePharmacies();
updateWaterOutages();
updatePowerOutages();
// 1. Weather: Every 10 minutes
cron.schedule('*/10 * * * *', async () => {
  await updateWeather();
});

// 2. Pharmacies: At 08:00 and 17:00 daily
cron.schedule('0 8,17 * * *', async () => {
  await updatePharmacies();
}, { timezone: 'Europe/Istanbul' });

// 3. Water outages: Every 10 minutes
cron.schedule('*/10 * * * *', async () => {
  await updateWaterOutages();
});

// 4. Power outages: Every 30 minutes
cron.schedule('*/30 * * * *', async () => {
  await updatePowerOutages();
});

console.log('Cron jobs are now running in the background.');

// Keep the process alive
process.on('SIGINT', () => {
  console.log('Stopping server...');
  process.exit();
});
