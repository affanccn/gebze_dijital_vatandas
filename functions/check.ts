import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
const serviceAccount = require('./serviceAccountKey.json');
initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();
Promise.all(['weather', 'pharmacies', 'waterOutages', 'powerOutages'].map(c => db.collection('gebze').doc(c).get())).then(docs => docs.forEach(d => console.log(d.id, d.data() ? Object.keys(d.data() as any) : 'null')));
