# 🚗 Car List Page – CST2335 Final Project

This page is part of a group submission for the CST2335 Graphical Interface Programming Final Project at Algonquin College. It simulates managing a list of cars with full CRUD operations (Create, Read, Update, Delete), persistent storage, localization, and modern UI elements.

---

## 📋 Overview

This module allows users to:
- Add new cars with details like make, model, year, and image.
- View a list of all added cars using a responsive `ListView`.
- Select a car to view or update its details.
- Delete existing car records.
- Automatically repopulate data after app restart using a local database.
- Save previously entered data using EncryptedSharedPreferences.
- Reuse previous car details for new entries.
- Support bilingual UI (English and Vietnamese and more).

---

## 🧱 Features Implemented

### 🔗 Main Integration
- Integrated into the app's **main navigation page** via one of the four module buttons.
- Launches a car-specific management interface.

### 📄 UI Components
- **ListView** of all saved cars.
- **TextField + Add Button** for inserting cars.
- **Detail Dialog** for editing or deleting cars (reuses creation form layout).
- **Image Picker** for selecting a car photo from gallery.
- **Default Image Placeholder** if no image selected.
- **Snackbar** for user feedback on success/failure actions.
- **AlertDialog** for user confirmations and instructions.

### 🗃️ Persistent Storage
- Uses **Drift/Moor** to store and retrieve car entries.
- Database repopulates `ListView` on app launch.

### 🔐 Preferences & Caching
- Uses **EncryptedSharedPreferences** to cache the most recent entry for reuse.
- “Use Previous Data” feature replicates the customer page’s functionality.

### 🌍 Localization
- Fully supports:
  - **English**
  - **Vietnamese**
  - **And more...**

### 📱 Responsive Layout
- Optimized for both **phones** and **tablets**:
  - Single-pane on small screens.
  - Two-pane layout on larger screens for side-by-side view/edit.
---

## 🧑‍💻 Tech Stack

- **Language**: Dart
- **Framework**: Flutter
- **Database**: Drift (Moor)
- **UI Elements**: Material, Dialogs, Snackbars
- **Preferences**: EncryptedSharedPreferences
- **Image Support**: image_picker plugin

---

## 👨‍👩‍👧 Group Info

This module was developed as part of a 4-person group project.

## 👥 Team Members

| No. | Name                  | Email Address                     | Project Topic             |
|-----|-----------------------|-----------------------------------|---------------------------|
| 1   | Lihua Lu              | lu000199@algonquinlive.com        | Customer list page        |
| 2   | Hao Tan               | tan00122@algonquinlive.com        | Car Dealership list page  |
| 3   | Viet-Quynh Nguyen     | nguy1079@algonquinlive.com        | Car list page             |
| 4   | Alexander Ala-Kantti  | alak0035@algonquinlive.com        | Sales list page           |
