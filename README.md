# Finager Developed By Kyaw Htet Myat Tun.

Finager is a comprehensive finance management application designed to help users track expenses, manage budgets, and monitor financial activities efficiently. Finager targets Logistic Business for truck dispatching, expense tracking and family expenses and incomes. The app is built with Flutter and provides a modern, cross-platform solution for personal and business finance management.

The project uses the following technologies:
- Flutter
- Riverpod
- GoRouter
- HTTP
- Shared Preferences
- Image Picker
- Cached Network Image
- FL Chart
- Flutter Localizations
- Cupertino Icons

## Features

### 💰 Transaction Management
- **Add Transactions**: Record income and expense transactions with detailed information
- **Transaction Types**: Support for both income and expense tracking
- **Categories**: Organize transactions by categories (household expenses and truck expenses)
- **Payment Methods**: Track payment methods for each transaction
- **Transaction History**: View and filter transaction history with date ranges
- **Edit & Delete**: Modify or remove existing transactions

### 🚚 Dispatch Management
- **Truck Dispatch Tracking**: Manage truck dispatching operations
- **Active Dispatch**: Monitor currently active dispatches
- **Dispatch List**: View all dispatch records with details
- **Cost & Revenue Tracking**: Track total costs and revenues for each dispatch
- **Driver Management**: Assign and track drivers for dispatches
- **Dispatch Details**: View comprehensive dispatch information including associated transactions

### 📊 Analytics & Statistics
- **Expense Analytics**: Visual pie charts for expense breakdown
- **Household Expenses**: Separate analytics for household-related expenses
- **Truck Expenses**: Dedicated analytics for truck-related expenses
- **Monthly Statistics**: Track monthly income and expenses
- **Daily Averages**: View daily average income and expenses
- **Weekly Statistics**: Monitor weekly financial trends
- **Today's Summary**: Quick overview of today's income and expenses

### ⚙️ Settings & Customization
- **Account Management**: Manage user account details and display name
- **Multi-language Support**: 
  - English
  - Burmese (Myanmar)
  - Chinese
- **Theme Settings**: Choose between Light, Dark, or System theme
- **Font Size**: Adjustable font size (14-18) for better readability
- **Model Settings**: Manage core data models:
  - **Trucks**: Add, edit, and manage truck information (name, IMEI, license expiry, color, type)
  - **Payment Methods**: Configure available payment methods
  - **Categories**: Manage transaction categories (household and truck expenses)

### 🔐 Authentication
- Secure user authentication
- Token-based authentication system
- Session management

### 📱 User Interface
- Modern and intuitive Material Design UI
- Responsive layout for various screen sizes
- Pull-to-refresh functionality
- Loading indicators and overlays
- Custom bottom navigation bar
- Smooth navigation with GoRouter

## Technology Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Charts**: FL Chart
- **HTTP Client**: HTTP package
- **Local Storage**: Shared Preferences
- **Image Handling**: Image Picker, Cached Network Image
- **Localization**: Flutter Localizations (i18n)
- **UI Components**: Material Design, Cupertino Icons

## Project Structure

```
lib/
├── components/          # Reusable UI components
├── core/               # App configuration and routing
├── l10n/               # Localization files (English, Burmese, Chinese)
├── models/             # Data models (Transaction, Dispatch, Category, etc.)
├── providers/          # Riverpod state providers
├── screens/            # App screens
│   ├── analytics_screen.dart
│   ├── dispatch/       # Dispatch-related screens
│   ├── edit_transaction/
│   ├── home/           # Home screen components
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── new_transaction/
│   ├── settings/       # Settings screens
│   ├── splash_screen.dart
│   └── transaction_history/
├── services/           # API and authentication services
├── utils/              # Utility functions
└── widgets/            # Custom widgets
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A backend API server (configured at `https://finager.pythonanywhere.com`)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Winstonjames2/expense_tracker_flutter.git
cd expense_tracker_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure the API endpoint (if needed):
   - Edit `lib/services/api_service.dart`
   - Update the `baseUrl` constant

4. Generate I10n for translations
```bash
flutter gen-l10n
```

5. Run the app:
```bash
flutter run
```

### make sure to configure the backend cuz this is only flutter frontend 

### Building for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**Web:**
```bash
flutter build web 
```

**Windows:**
```bash
flutter build windows --release
```

## Connect To Backend
For backend, I use python django rest framework. You can find the backend code at https://github.com/finager/finager-backend
To connect to the backend, simply change the `baseUrl` constant in `lib/services/api_service.dart` to your backend URL.

## Key Models

### Transaction
- Tracks financial transactions (income/expense)
- Includes amount, category, payment method, date, description
- Can be associated with truck dispatching

### Dispatch Data
- Manages truck dispatch operations
- Tracks dispatch date, truck, driver, costs, and revenues
- Supports active/inactive status

### Category
- Organizes transactions into categories
- Supports household and truck expense categories
- Multi-language support for category names

### Truck
- Manages truck information
- Includes name, IMEI, license expiry date, color, and type

## API Integration

The app connects to a backend API for data synchronization. The API service handles:
- User authentication
- Transaction CRUD operations
- Dispatch management
- Category, payment method, and truck management
- Data synchronization

## Localization

The app supports three languages:
- English (en)
- Burmese/Myanmar (my)
- Chinese (zh)

Localization files are located in `lib/l10n/` directory.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support or questions, please contact: kyawhtetmyattun@gmail.com

---

**Version**: 1.0.1
