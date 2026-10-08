import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
const serviceAccount = require('./serviceAccountKey.json');
initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

async function seed() {
  const timestamp = FieldValue.serverTimestamp();
  
  // Seed Pharmacies
  await db.collection('gebze').doc('pharmacies').set({
    success: true,
    district: 'GEBZE',
    source: 'KOCAELI_ECZACI_ODASI',
    fetchedAt: timestamp,
    date: '2026-10-08',
    pharmacies: [
      {
        name: 'GÖKÇEN ECZANESİ',
        region: 'Merkez',
        address: 'SULTAN ORHAN MAH. 1122. SOK. NO:11/A GEBZE',
        phone: '02626437171',
        latitude: 40.803,
        longitude: 29.431,
        start: '08:30',
        end: '08:30 (Ertesi Gün)'
      },
      {
        name: 'SARA ECZANESİ',
        region: 'Perifer',
        address: 'ARAPÇEŞME MAH. KAVAK CAD. NO:14/B MEDİCALPARK HASTANESİ KARŞISI',
        phone: '05449031744',
        latitude: 40.812,
        longitude: 29.445,
        start: '08:30',
        end: '08:30 (Ertesi Gün)'
      },
      {
        name: 'MUSA ECZANESİ',
        region: 'Merkez',
        address: 'KÖŞKLÜ ÇEŞME MAH. YENİ BAĞDAT CAD. NO:351/A',
        phone: '05541107672',
        latitude: 40.795,
        longitude: 29.420,
        start: '08:30',
        end: '08:30 (Ertesi Gün)'
      },
      {
        name: 'HÜRRİYET ECZANESİ',
        region: 'Beylikbağı',
        address: 'HÜRRİYET MAH. YASA CAD. NO:24/A GEBZE',
        phone: '02627449672',
        latitude: 40.820,
        longitude: 29.400,
        start: '08:30',
        end: '23:59'
      }
    ]
  });

  // Seed Power Outages (SEDAŞ)
  await db.collection('gebze').doc('powerOutages').set({
    success: true,
    district: 'GEBZE',
    source: 'SEDAS',
    fetchedAt: timestamp,
    date: '2026-10-08',
    outages: [
      {
        neighborhood: 'İSTASYON',
        start: '09:00',
        end: '15:00',
        description: '1401. SK., 1402. SK., 1403. SK., 1404. SK., İSTASYON CD., ŞEHİT MÜCAHİT OKUR CD. - Planlı Bakım ve İyileştirme'
      },
      {
        neighborhood: 'HACİHALİL, MUSTAFAPAŞA',
        start: '10:00',
        end: '18:00',
        description: '1203. SK., 602. SK., 701. SK., KIZILAY CD. - Tesis Çalışması'
      }
    ]
  });

  // Seed Water Outages (ISU)
  await db.collection('gebze').doc('waterOutages').set({
    success: true,
    district: 'GEBZE',
    source: 'ISU',
    fetchedAt: timestamp,
    date: '2026-10-08',
    outages: [
      {
        neighborhood: 'ARAPÇEŞME MAHALLESİ',
        start: '13:30',
        end: '16:00',
        description: 'Ana şebeke borusu arızası nedeniyle planlı su kesintisi.'
      }
    ]
  });

  console.log('Seed successful!');
}

seed().catch(console.error);
