![iOS](https://img.shields.io/badge/iOS-17+-black)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-✓-blue)
![License](https://img.shields.io/badge/License-MIT-green)

# 🚀 Spendora

> A modern, beautifully crafted iOS expense tracking app built with **SwiftUI** and **SwiftData**.

Spendora helps you track, understand, and optimize your spending with a clean UI, powerful analytics, and seamless Apple ecosystem integration.

---

## ✨ Why Spendora?

Managing personal finances shouldn’t feel like a chore.

Spendora is designed to be:
- ⚡ Fast
- 🎯 Intuitive
- 📊 Insightful
- 🌙 Beautiful in both light & dark mode

---

## 🎯 Motivation

Most expense tracking apps are either:
- Too complex 🧩  
- Too boring 😴  
- Or too outdated 🕰️  

Spendora was built to fix that.

The goal was simple:
> Build an expense tracker that is fast, beautiful, and actually enjoyable to use.

---

## 📱 Features

### 💸 Expense Tracking
- Log expenses with title, amount, category, and notes
- Attach receipt images
- Clean and intuitive input flow

### 🧠 Smart Organization
- Categorize expenses with icons and colors
- Automatic grouping (Today, Yesterday, Weekly, Monthly)

### 🌍 Multi-Currency Support
- Track expenses in multiple currencies
- Automatic conversion to base currency

### 📊 Visual Analytics
- Category breakdown (pie chart)
- Monthly spending trends (bar chart)
- Real-time insights into spending habits

### ☁️ Sync & Security
- iCloud sync across devices
- Face ID / biometric authentication

### 🎨 Beautiful UI
- Fully optimized for **Light & Dark mode**
- Gradient-based design system
- Smooth animations & transitions

---

## 📸 Screenshots

### 📊 Dashboard (Transactions & Grouping)
Grouped sections like Today, Yesterday, Last Week with realistic data.

<table>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/DashboardSnapshotInitial.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/DashboardSnapshotInitial.Dark.png" width="300"/></td>
</tr>
</table>

---

### ➕ Add Expense (Filled Form)
Realistic filled state with selected category.

<table>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/AddExpenseScreen.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/AddExpenseScreen.Dark.png" width="300"/></td>
</tr>
</table>

---

### 🧾 Category Summary
Clear breakdown of spending across categories.

<table>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/CategorySummaryScreen.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/CategorySummaryScreen.Dark.png" width="300"/></td>
</tr>
</table>

---

### 📈 Analytics (Charts)
Understand your spending patterns visually.

<table>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/CategoryChart.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/CategoryChart.Dark.png" width="300"/></td>
</tr>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/TrendChart.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/TrendChart.Dark.png" width="300"/></td>
</tr>
</table>

---

### 🔐 Authentication
Secure login with Apple Sign In & Face ID.

<table>
<tr>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/LoginScreen.Light.png" width="300"/></td>
<td><img src="SpendoraTests/__Snapshots__/SpendDashboardSnapshotTests/LoginScreen.Dark.png" width="300"/></td>
</tr>
</table>

---

## 🏗️ Tech Stack

- **SwiftUI** – Declarative UI framework
- **SwiftData** – Modern persistence layer
- **Charts** – Native data visualization
- **Combine** – Reactive programming
- **iCloud** – Sync & storage

---

## 🧩 Architecture

Spendora follows a clean, scalable architecture:

- **MVVM** – Separation of UI and business logic
- **SwiftData** – Modern persistence layer with reactive updates
- **Feature-based modular structure**
- **Reusable UI components**
- **Deterministic snapshot testing for UI stability**

---

## 📁 Project Structure

```
Spendora/
├── Spendora/                 # Main app code
│   ├── Core/Mock/           # Mock data & testing utilities
│   ├── Finances/            # Core finance features (charts, services, views)
│   └── Views/               # App-level UI (Account, MainApp, Splash)
│
├── SharedModels/            # Shared models, extensions, reusable UI
│   ├── Models/              # Spend, Category, User
│   ├── Views/               # Reusable UI components
│   └── Helper/              # Utilities & helpers
│
├── LoginFeature/            # Modular login feature (MVVM)
│   ├── API/                 # Authentication + Keychain
│   ├── ViewModel/
│   └── Views/
│
├── SpendoraTests/           # Unit + Snapshot tests
│   └── __Snapshots__/       # Snapshot images
│
├── SpendoraUITests/         # UI tests
├── Screenshots/             # README images (curated snapshots)
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- iOS 17+
- Xcode 15+
- Apple ID (for iCloud sync)

---

### Installation

```bash
git clone https://github.com/pragoel/Spendora.git
cd Spendora
open Spendora.xcodeproj
```

Run the app:
```
Cmd + R
```

---

## 🧪 Example Usage

```swift
let spend = Spend(
    title: "Coffee at Starbucks",
    detail: "Morning coffee",
    amount: 5.50,
    currency: "USD",
    date: Date(),
    category: foodCategory,
    receiptImageDatas: [receiptImageData]
)

modelContext.insert(spend)
```

---

## 🤝 Contributing

Contributions are welcome!

- Open issues for bugs or feature requests
- Submit PRs for improvements

---

## 💬 Support

- Issues: https://github.com/pragoel/Spendora/issues  
- Discussions: https://github.com/pragoel/Spendora/discussions  

---

## 👨‍💻 Maintainer

**Pratik Goel**

---

## ⭐️ If you like this project

Give it a star ⭐️ — it helps a lot!
