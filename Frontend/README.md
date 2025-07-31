# tripsol_clean

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# TripSol App

A smart travel planning assistant that helps users generate personalized trip plans, explore destinations, and manage their saved itineraries with ease.


## 📅 Timeline & Team

* **Project Duration:** June 3, 2025 – July 31, 2025
* **Team Members:** Hasini, Hasini's teammates (Sudhiksha, Mounika, Siddhi)
* **Role:** Frontend Developer (Flutter) + AI/ML Integrations

---

## 📚 Features

 Homepage (Search + Recommendations)

* Greeting with user name
* Destination search bar
* Recommended destinations (e.g., Udaipur, Goa, Manali)

 Place Details Page

* Day-wise itinerary from backend/ML
* Budget, travel mode display
* Save trip functionality

 Trip Customization

* Select travel mode, dates, and budget
* Get AI-generated revised itinerary (mock/real depending on backend readiness)

 Saved Trips

* View past saved itineraries
* Delete trips
* View trip details

 📄 Profile Page

* User info (mocked currently)
* Trip count

 Settings & Info

* About App page
* Settings Page UI
* (Optional: Feedback & Logout)



## ⚖️ Tech Stack

* **Frontend:** Flutter
* **Backend:** Node.js + Express (API provided by team)
* **Database:** MongoDB (used via backend)
* **AI/ML:** Integrated or mocked itinerary generation
* **Authentication:** Firebase (Google Sign-In)


##  Screens Implemented (Frontend)

*  Login/Signup Page
*  Intro Page
*  Homepage
*  Place Details Page
*  Trip Customization Page
*  Results Page (Customized Plan)
*  Saved Trips Page
*  Trip Detail Page
*  Profile Page
*  Settings Page
*  About App Page
*  Error/Loading Widgets

>  **UI is almost 95% complete**


##  Mock Integrations (for now)

* Place recommendations
* Saved trips list
* Trip customization
* Trip plan (unless backend integrated)


##  To-Do (End Phase)

* [ ] Firebase Google Sign-In (UI done)
* [ ] Connect to real backend API
* [ ] AI/ML trip customization integration
* [ ] Polish UI/UX


##  Feedback & Testing

* Tested on Android Emulator
* Feedback welcome for UI improvements or feature additions


## 📁 Folder Structure

lib/
|- screens/
|- services/
|- widgets/
|- main.dart


## 📥 Setup Instructions

```bash
git clone https://github.com/Techwizard843/TripSolApp.git
cd tripsol_clean
flutter pub get
flutter run
```

---

## 📄 License

This project is for educational purposes under IIT Indore's summer internship 2025.
