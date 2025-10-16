# Chorva Yem - O'rnatish Qo'llanmasi

## 🚀 Tezkor Boshlash

### 1. Talablar
- Flutter SDK 3.9.2+
- Android Studio / VS Code
- Firebase loyihasi

### 2. Firebase Sozlash

#### Firebase Console da:
1. [Firebase Console](https://console.firebase.google.com/) ga kiring
2. "Add project" tugmasini bosing
3. Loyiha nomini kiriting: `chorva-yem`
4. Google Analytics ni yoqing
5. "Create project" tugmasini bosing

#### Android uchun:
1. "Add app" > Android tugmasini bosing
2. Package name: `com.example.chorva_yem`
3. App nickname: `Chorva Yem Android`
4. `google-services.json` faylini yuklab oling
5. `android/app/` papkasiga qo'ying

#### iOS uchun:
1. "Add app" > iOS tugmasini bosing
2. Bundle ID: `com.example.chorvaYem`
3. App nickname: `Chorva Yem iOS`
4. `GoogleService-Info.plist` faylini yuklab oling
5. `ios/Runner/` papkasiga qo'ying

#### Authentication:
1. Firebase Console da "Authentication" ga o'ting
2. "Get started" tugmasini bosing
3. "Sign-in method" tabiga o'ting
4. "Email/Password" ni yoqing
5. "Save" tugmasini bosing

### 3. Loyihani Ishga Tushirish

```bash
# 1. Repository ni klonlang
git clone <repository-url>
cd chorva_yem

# 2. Paketlarni o'rnating
flutter pub get

# 3. Firebase konfiguratsiyasini tekshiring
flutter packages pub run build_runner build

# 4. Loyihani ishga tushiring
flutter run
```

### 4. Test Qilish

#### Android:
```bash
flutter run -d android
```

#### iOS:
```bash
flutter run -d ios
```

#### Web:
```bash
flutter run -d web
```

## 🔧 Qo'shimcha Sozlamalar

### Firebase Storage (Rasmlar uchun):
1. Firebase Console da "Storage" ga o'ting
2. "Get started" tugmasini bosing
3. "Start in test mode" ni tanlang
4. Location ni tanlang (Yevropa yoki Osiyo)

### Firebase Firestore (Ma'lumotlar uchun):
1. Firebase Console da "Firestore Database" ga o'ting
2. "Create database" tugmasini bosing
3. "Start in test mode" ni tanlang
4. Location ni tanlang

### Push Notifications:
1. Firebase Console da "Cloud Messaging" ga o'ting
2. "Get started" tugmasini bosing
3. Android uchun `google-services.json` ni yangilang
4. iOS uchun APNs sertifikatini sozlang

## 📱 Ilova Xususiyatlari

### ✅ Tayyor Funksiyalar:
- ✅ Firebase Authentication
- ✅ Foydalanuvchi ro'yxatdan o'tish va kirish
- ✅ Mahsulotlar katalogi
- ✅ Savatcha tizimi
- ✅ Buyurtma tizimi
- ✅ Profil boshqaruvi
- ✅ Zamonaviy UI/UX

### 🔄 Rivojlantirilayotgan:
- 🔄 Backend API integratsiyasi
- 🔄 Yetkazib berish xizmati
- 🔄 To'lov tizimi
- 🔄 Push bildirishnomalar

## 🐛 Muammolar va Yechimlar

### Firebase xatoligi:
```
FirebaseApp not initialized
```
**Yechim:** `firebase_options.dart` faylini tekshiring

### Android build xatoligi:
```
Gradle build failed
```
**Yechim:** 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS build xatoligi:
```
CocoaPods not found
```
**Yechim:**
```bash
cd ios
pod install
cd ..
```

## 📞 Yordam

Agar muammolar bo'lsa:
- GitHub Issues da xabar bering
- Telegram: @chorvayem_support
- Email: support@chorvayem.uz

## 🎯 Keyingi Qadamlar

1. **Backend API** - Node.js yoki Python
2. **Admin Panel** - Web dashboard
3. **Payment Gateway** - Payme, Click yoki Uzcard
4. **Delivery Tracking** - GPS kuzatuvi
5. **Analytics** - Firebase Analytics
6. **Crash Reporting** - Firebase Crashlytics

---

**Chorva Yem** - Chorva mollaringiz uchun eng yaxshi yemlarni toping! 🐄🐑🐔
