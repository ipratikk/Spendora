# Spendora

A modern iOS expense tracking app built with SwiftUI and SwiftData, designed to help you manage your personal finances with ease.

## What is Spendora?

Spendora is a comprehensive personal finance management application that allows you to track, categorize, and analyze your spending habits. With support for multiple currencies, receipt photo attachments, and iCloud synchronization, it provides a seamless experience across your Apple devices.

## Key Features

- **Expense Tracking**: Log your spends with detailed information including amount, category, date, and notes
- **Receipt Management**: Attach photos of receipts directly to your expense entries
- **Multi-Currency Support**: Track expenses in different currencies with automatic exchange rate conversion
- **Smart Categorization**: Organize expenses with customizable categories and icons
- **Budget Monitoring**: Set spending budgets and track your progress
- **Visual Analytics**: View spending trends and category breakdowns with interactive charts
- **iCloud Sync**: Keep your data synchronized across all your devices
- **Face ID Authentication**: Secure access with biometric authentication
- **Dark Mode Support**: Automatic dark/light mode switching

## Getting Started

### Prerequisites

- iOS 17.0 or later
- Xcode 15.0 or later
- An Apple ID for iCloud synchronization (optional but recommended)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/pragoel/Spendora.git
   cd Spendora
   ```

2. Open the project in Xcode:
   ```bash
   open Spendora.xcodeproj
   ```

3. Select your target device or simulator

4. Build and run the application:
   - Press `Cmd + R` or click the Run button in Xcode

### First Use

1. Launch the app and complete the initial setup
2. Enable Face ID for secure authentication (optional)
3. Sign in with your iCloud account to enable data synchronization
4. Start adding your first expense by tapping the "+" button

### Usage Example

```swift
// Adding a new expense programmatically
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

## Getting Help

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/pragoel/Spendora/issues)
- **Discussions**: Join community discussions on [GitHub Discussions](https://github.com/pragoel/Spendora/discussions)

## Contributing

We welcome contributions! Please feel free to submit issues and pull requests.

## Maintainers

- **Pratik Goel** - Creator and maintainer