import { getFirestore, FieldValue } from 'firebase-admin/firestore';

export class BaseRepository<T extends { source: string }> {
  constructor(private collectionName: string) {}

  protected get collection() {
    return getFirestore().collection('gebze').doc('data').collection(this.collectionName);
  }

  protected get docRef() {
    return getFirestore().collection('gebze').doc(this.collectionName);
  }

  async save(data: T): Promise<void> {
    const timestamp = FieldValue.serverTimestamp();
    
    // As per user's preference for flat structure /gebze/{collectionName}:
    // /gebze/weather
    const firestoreData = {
      ...data,
      fetchedAt: timestamp,
      success: true,
    };
    
    await this.docRef.set(firestoreData, { merge: true });
  }

  async saveError(error: any, source: string): Promise<void> {
    const timestamp = FieldValue.serverTimestamp();
    
    await this.docRef.set({
      success: false,
      isStale: true,
      lastAttempt: timestamp,
      error: error.message || 'Unknown error',
    }, { merge: true });
  }
}
