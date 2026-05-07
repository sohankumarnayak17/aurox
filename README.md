<div align="center">

<br/>

```
░█████╗░██╗░░░██╗██████╗░░█████╗░██╗░░██╗
██╔══██╗██║░░░██║██╔══██╗██╔══██╗╚██╗██╔╝
███████║██║░░░██║██████╔╝██║░░██║░╚███╔╝░
██╔══██║██║░░░██║██╔══██╗██║░░██║░██╔██╗░
██║░░██║╚██████╔╝██║░░██║╚█████╔╝██╔╝╚██╗
╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝
```

**Your personal finance command centre.**  
Track expenses, plan budgets, and understand your money — all in one place.

<br/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Firestore](https://img.shields.io/badge/Firestore-FF6F00?style=for-the-badge&logo=google-cloud&logoColor=white)

</div>

---

## What is Aurox?

Aurox is a mobile-first personal finance app built with Flutter that gives you a clear, real-time picture of your financial life. Whether you're tracking daily expenses, setting monthly budgets, or reviewing where your money went — Aurox keeps it simple and visual.

> 🔗 **Bank account integration is in active development** — automatic transaction syncing coming soon.

---

## Features

| Feature | Status |
|---|---|
| 🔐 User Authentication (Firebase Auth) | ✅ Live |
| 💸 Expense Tracking | ✅ Live |
| 💰 Income Tracking | ✅ Live |
| 📋 Transaction History | ✅ Live |
| 📊 Budget Planning | ✅ Live |
| 📈 Charts & Analytics (fl_chart) | ✅ Live |
| 👤 Profile & Settings | ✅ Live |
| 🏦 Bank Account Integration | 🔄 Coming Soon |

---

## Tech Stack

```
Flutter (Dart)          — Cross-platform mobile UI framework
Firebase Auth           — Secure user authentication
Cloud Firestore         — Real-time NoSQL database & sync
Provider               — State management
fl_chart               — Financial data visualisation
shared_preferences     — Local storage for user preferences
image_picker           — Profile image support
intl                   — Currency & date formatting
```

---

## Getting Started

### Prerequisites
- Flutter SDK `^3.9.0`
- A Firebase project with Firestore enabled
- Android Studio or VS Code with Flutter extension

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/sohankumarnayak17/aurox.git
cd aurox

# 2. Install dependencies
flutter pub get

# 3. Firebase configuration
# Add your google-services.json to /android/app/
# Add your GoogleService-Info.plist to /ios/Runner/
# (Create a Firebase project at console.firebase.google.com)

# 4. Run the app
flutter run
```

> ⚠️ You'll need your own Firebase project credentials. The app won't run without `google-services.json` configured.

---

## Project Structure

```
lib/
├── main.dart              # Entry point & Firebase init
├── models/                # Data models (transaction, budget, user)
├── screens/               # UI screens (home, auth, history, profile)
├── widgets/               # Reusable UI components & charts
├── services/              # Firebase & Firestore service layer
└── providers/             # Provider state management
```

---

## Roadmap

- [x] User authentication & profiles
- [x] Expense & income tracking
- [x] Budget planning with limits
- [x] Transaction history with filters
- [x] Charts and spending analytics
- [ ] Bank account linking & auto-sync
- [ ] Export transactions to CSV
- [ ] Recurring transactions
- [ ] Multi-currency support

---

## Author

**Sohan Kumar Nayak**  
B.Tech CSE — KIIT University, Bhubaneswar  
[GitHub](https://github.com/sohankumarnayak17)

---

<div align="center">
  <sub>Built with Flutter 💙 — because your money deserves better than a spreadsheet.</sub>
</div>
