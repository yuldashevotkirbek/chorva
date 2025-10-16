# Chorva Yem - Chorva Mollari uchun Online Yem Do'koni

Bu Flutter ilovasi chorva mollari uchun yem sotib olish va yetkazib berish xizmatini taqdim etadi.

## 🚀 Asosiy Xususiyatlar

### 👤 Foydalanuvchi Tizimi
- **Ro'yxatdan o'tish va kirish** - Email va telefon orqali
- **Profil boshqaruvi** - Shaxsiy ma'lumotlarni yangilash
- **Parol tiklash** - Xavfsizlik uchun
- **Manzil boshqaruvi** - Yetkazib berish manzillarini saqlash

### 🛍️ Mahsulotlar Katalogi
- **Kategoriyalar** - Qoramol, qo'y, tovuq, baliq yemlari
- **Mahsulot qidiruv** - Tez va aniq qidiruv
- **Mahsulot tafsilotlari** - Batafsil ma'lumot va rasmlar
- **Reyting tizimi** - Foydalanuvchi baholari
- **Filtr va tartiblash** - Narx, reyting, nom bo'yicha

### 🛒 Savatcha va Buyurtma
- **Savatcha** - Mahsulotlarni saqlash va miqdorni o'zgartirish
- **Buyurtma berish** - Oson va tez buyurtma jarayoni
- **Buyurtma kuzatuvi** - Real vaqtda buyurtma holati
- **Buyurtma tarixi** - Barcha buyurtmalarni ko'rish

### 🚚 Yetkazib Berish
- **Manzil boshqaruvi** - Bir nechta yetkazib berish manzillari
- **Yetkazib berish hisob-kitobi** - Masofa va vazn bo'yicha
- **Bepul yetkazib berish** - Ma'lum miqdordan yuqori buyurtmalar uchun
- **Kuzatish raqami** - Buyurtma holatini kuzatish

### 💳 To'lov Tizimi
- **Naqd pul** - Yetkazib berish vaqtida to'lash
- **Karta orqali** - Xavfsiz online to'lov
- **Bank o'tkazmasi** - Bank orqali to'lov
- **Raqamli hamyon** - Zamonaviy to'lov usullari

## 🛠️ Texnologiyalar

### Frontend
- **Flutter** - Cross-platform mobil ilova
- **Dart** - Dasturlash tili
- **Material Design** - Zamonaviy UI/UX

### State Management
- **Provider** - State boshqaruvi
- **SharedPreferences** - Lokal ma'lumotlar saqlash

### Backend Integration
- **HTTP/Dio** - API so'rovlari
- **Firebase** - Autentifikatsiya va ma'lumotlar bazasi
- **RESTful API** - Backend bilan aloqa

### Qo'shimcha Xususiyatlar
- **Geolocation** - Joylashuv xizmatlari
- **Push Notifications** - Bildirishnomalar
- **Image Picker** - Rasm yuklash
- **Cached Network Image** - Rasm cache
- **Lottie Animations** - Animatsiyalar

## 📱 Ilova Tuzilishi

```
lib/
├── constants/          # Konstanta va sozlamalar
├── models/            # Ma'lumotlar modellari
├── providers/         # State management
├── screens/           # UI ekranlari
│   ├── auth/         # Autentifikatsiya
│   ├── main/         # Asosiy ekranlar
│   └── product/      # Mahsulot ekranlari
├── services/          # API va xizmatlar
├── utils/            # Yordamchi funksiyalar
└── widgets/          # Qayta ishlatiladigan widgetlar
```

## 🚀 O'rnatish va Ishlatish

### Talablar
- Flutter SDK 3.9.2+
- Dart 3.0+
- Android Studio / VS Code
- Git

### O'rnatish
1. **Repository ni klonlang:**
   ```bash
   git clone https://github.com/your-username/chorva-yem.git
   cd chorva-yem
   ```

2. **Paketlarni o'rnating:**
   ```bash
   flutter pub get
   ```

3. **Ilovani ishga tushiring:**
   ```bash
   flutter run
   ```

### Konfiguratsiya
1. **Firebase sozlamalari:**
   - Firebase loyihasi yarating
   - `google-services.json` (Android) va `GoogleService-Info.plist` (iOS) fayllarini qo'shing

2. **API sozlamalari:**
   - `lib/constants/app_constants.dart` faylida API URL ni o'zgartiring

## 📋 Loyiha Rejasi

### ✅ Bajarilgan
- [x] Loyiha tuzilishi va arxitektura
- [x] Ma'lumotlar modellari
- [x] Autentifikatsiya tizimi
- [x] Mahsulotlar katalogi
- [x] Savatcha tizimi
- [x] Asosiy UI/UX dizayn

### 🔄 Jarayonda
- [ ] Backend API integratsiyasi
- [ ] Yetkazib berish xizmati
- [ ] To'lov tizimi integratsiyasi
- [ ] Push bildirishnomalar
- [ ] Geolocation xizmatlari

### 📅 Rejalashtirilgan
- [ ] Admin panel
- [ ] Mahsulot boshqaruvi
- [ ] Buyurtma boshqaruvi
- [ ] Hisobotlar va statistika
- [ ] Ko'p til qo'llab-quvvatlash
- [ ] Dark mode
- [ ] Offline rejim

## 🎨 Dizayn

Ilova Material Design 3 asosida yaratilgan va zamonaviy, foydalanuvchi-do'st interfeysga ega:

- **Rang palitra:** Yashil asosiy rang (chorva va tabiatni ifodalaydi)
- **Tipografiya:** O'qish oson va zamonaviy shriftlar
- **Ikonlar:** Material Design ikonlari
- **Animatsiyalar:** Yumshoq va tabiiy o'tishlar
- **Responsive:** Barcha ekran o'lchamlarida ishlaydi

## 🔒 Xavfsizlik

- **Parol shifrlash** - Bcrypt algoritmi
- **JWT tokenlar** - Xavfsiz autentifikatsiya
- **HTTPS** - Barcha ma'lumotlar shifrlangan
- **Input validatsiya** - XSS va SQL injection himoyasi
- **Rate limiting** - API so'rovlarini cheklash

## 📞 Qo'llab-quvvatlash

Agar savollar yoki muammolar bo'lsa:

- **Email:** support@chorvayem.uz
- **Telegram:** @chorvayem_support
- **Telefon:** +998 XX XXX XX XX

## 📄 Litsenziya

Bu loyiha MIT litsenziyasi ostida tarqatiladi. Batafsil ma'lumot uchun `LICENSE` faylini ko'ring.

## 👥 Jamoa

- **Dasturchi:** [Sizning ismingiz]
- **Dizayner:** [Dizayner ismi]
- **Backend:** [Backend dasturchi]

## 🙏 Minnatdorchilik

- Flutter jamoasiga
- Material Design jamoasiga
- Barcha ochiq manba paketlar mualliflariga
- Beta test qilgan foydalanuvchilarga

---

**Chorva Yem** - Chorva mollaringiz uchun eng yaxshi yemlarni toping! 🐄🐑🐔# chorva
