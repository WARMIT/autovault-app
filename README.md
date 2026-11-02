# 🏎️ AutoVault — Premium Car Selling & Marketplace Platform (Flutter)

A state-of-the-art, luxury car selling and verified marketplace mobile application built with **Flutter**. Designed with dark automotive aesthetics, vibrant sunset neon accents, glassmorphic card designs, and authentic stock automotive photography.

---

## ✨ Features Overview

### 1. 🔍 Explore & Verified Marketplace
- **Spotlight Hero Showcase**: Auto-sliding featured hypercars and supercars with performance telemetry (0-60, HP, top speed).
- **Top Marques Brand Selector**: One-tap filtering for Porsche, Tesla, Mercedes-Benz, BMW, Audi, Lamborghini, Land Rover, Ford Performance, and Ferrari.
- **Body Style Filtering**: Fast category pills for *Supercar, Electric, Coupe, Sedan, SUV, Convertible*.
- **Hot Deals & Price Drops**: Curated cars with certified savings.
- **Pure Electric Performance Row**: Filtered showcase for high-performance electric vehicles.

### 2. 📸 High-Definition Stock Automotive Photography
- Powered by high-resolution automotive photography from Unsplash.
- Includes models:
  - *Porsche 911 GT3 RS (992)*
  - *Tesla Model S Plaid Tri-Motor*
  - *Mercedes-AMG GT 63 S Coupe*
  - *BMW M4 Competition xDrive*
  - *Audi RS6 Avant Performance*
  - *Lamborghini Huracán EVO Spyder*
  - *Range Rover SV Autobiography LWB*
  - *Ford Mustang Dark Horse Fastback*

### 3. 🚗 Comprehensive Vehicle Details & 360° Studio
- **Multi-Photo Gallery**: Interactive carousel with indicator dots.
- **Interactive 360° View Mode**: Simulates full exterior rotation.
- **Performance Telemetry Gauge Cards**: 0-60 mph acceleration, peak horsepower, top speed, range/fuel economy.
- **Detailed Specifications Table**: Powertrain, transmission, drivetrain, VIN, odometer, exterior/interior colors.
- **Verified Equipment Checklist**: Installed packages (Carbon Ceramic Brakes, Weissach, Autopilot, Burmester Sound, etc.).
- **Seller Profile Card**: Direct chat and phone contact buttons with seller rating, response time, and verified badge.

### 4. 💰 Real-Time Financing & EMI Loan Calculator
- **Vehicle Price & Down Payment Slider**: Dynamically adjusts down payment percentage (5% to 50%).
- **Loan Term Selector**: 24, 36, 48, 60, or 72 months.
- **APR Interest Slider**: Real-time adjustable interest rate.
- **Instant Monthly Payment Calculation**: Live updates showing monthly payment, total interest, and total cost breakdown.
- **Pre-Approval CTA**: Direct pre-qualification submission.

### 5. 🏷️ "Sell Your Car" Listing Wizard
- **Stock Photo Presets**: Tap to select high-res stock photos for your make or paste custom image URLs.
- **AI Smart Market Valuation**: Instant valuation tool that estimates market price range based on make, model, year, and mileage.
- **Technical Attributes Input**: Make, model, year, mileage, HP, 0-60 time, fuel type, transmission, colors.
- **Instant Live Preview Card**: Dynamically updates as you type before publishing.
- **Live Publishing**: Injects the vehicle directly into the active app marketplace and your personal garage.

### 6. ⚖️ Side-by-Side Car Comparison
- Select up to 3 cars from your favorites.
- Side-by-side comparison table highlighting the winner for 0-60 mph, horsepower, top speed, asking price, and monthly EMI.

### 7. 📅 VIP Test Drive Booking System
- Select between **Showroom Visit** or **At-Home Concierge Delivery**.
- Date selector and time slots (10:00 AM, 11:30 AM, 2:00 PM, 4:30 PM, 6:00 PM).
- Generates confirmed booking receipt and displays inside user profile.

### 8. 💬 In-App Chat & Official Offer Submissions
- Direct messaging with dealers and private sellers.
- Quick prompt buttons (*"Is the price negotiable?", "Send CarFax report"*).
- **Make Official Offer Modal**: Percentage discount shortcuts (-3%, -5%, -8%) and custom offer amounts.
- Renders special highlighted purchase offer cards with status tracking.

### 9. 🌓 Luxury Dark & Crisp Light Themes
- One-tap toggle between Deep Obsidian Dark Mode and Clean Light Mode.

---

## 📁 Project Architecture

```
demo app/
├── pubspec.yaml                 # Dependencies and asset declarations
├── analysis_options.yaml        # Dart linter configurations
├── web/                         # Web runner and manifest
├── android/                     # Android project files and manifest
├── ios/                         # iOS project files and Info.plist
├── lib/
│   ├── main.dart                # Application entrypoint & theme setup
│   ├── theme/
│   │   ├── app_colors.dart      # Color tokens & gradients
│   │   └── app_theme.dart       # ThemeData for Dark & Light modes
│   ├── models/
│   │   ├── car.dart             # Car model with EMI calculation helpers
│   │   ├── brand.dart           # Brand marque model
│   │   ├── seller.dart          # Verified dealer & private seller model
│   │   ├── review.dart          # Reviews and testimonials
│   │   ├── chat_message.dart    # Chat & offer message model
│   │   └── test_drive_booking.dart # Test drive booking model
│   ├── data/
│   │   └── mock_cars.dart       # Tested Unsplash stock photos & car catalog
│   ├── state/
│   │   └── car_store.dart       # Reactive ChangeNotifier state management
│   ├── widgets/
│   │   ├── custom_image.dart    # Network stock image loader with shimmer & fallback
│   │   ├── car_card.dart        # Horizontal & vertical automotive cards
│   │   ├── brand_selector.dart  # Horizontal brand marque selector
│   │   ├── loan_calculator_modal.dart # Interactive slider EMI financing sheet
│   │   ├── test_drive_modal.dart # VIP test drive appointment modal
│   │   └── make_offer_modal.dart # Instant offer negotiation sheet
│   └── screens/
│       ├── main_layout.dart     # Bottom navigation with active badges
│       ├── explore_screen.dart  # Marketplace home with hero carousel
│       ├── car_details_screen.dart # Car showcase, 360 preview, specs & actions
│       ├── sell_car_screen.dart # Car seller wizard with stock images & AI valuation
│       ├── search_filter_screen.dart # Real-time search & multi-slider filters
│       ├── saved_cars_screen.dart # Wishlist & comparison launcher
│       ├── car_comparison_screen.dart # Side-by-side comparative matrix
│       ├── chat_screen.dart     # Seller-buyer conversation & offer thread
│       └── profile_screen.dart  # User garage, active listings & scheduled bookings
```

---

## 🚀 How to Run the Flutter App

### Prerequisites
Make sure Flutter is installed on your machine. You can verify with:
```bash
flutter doctor
```

### Install Dependencies
```bash
flutter pub get
```

### Run Locally
- **Web (Chrome)**:
  ```bash
  flutter run -d chrome
  ```
- **macOS Desktop**:
  ```bash
  flutter run -d macos
  ```
- **iOS Simulator**:
  ```bash
  flutter run -d "iPhone 15 Pro"
  ```
- **Android Emulator / Device**:
  ```bash
  flutter run -d android
  ```

---

## 🎨 Stock Images
All vehicle imagery in this project uses verified, high-resolution automotive stock photography from Unsplash via secure CDN URLs with graceful shimmer loaders and offline fallback illustrations.
