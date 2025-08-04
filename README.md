🚗 Car List Page – CST2335 Final Project
This page is part of a group submission for the CST2335 Graphical Interface Programming Final Project at Algonquin College. It simulates managing a list of cars with full CRUD operations (Create, Read, Update, Delete), persistent storage, localization, and modern UI elements.

📋 Overview
This module allows users to:

Add new cars with details like make, model, year, and image.

View a list of all added cars using a responsive ListView.

Select a car to view or update its details.

Delete existing car records.

Automatically repopulate data after app restart using a local database.

Save previously entered data using EncryptedSharedPreferences.

Reuse previous car details for new entries.

Support bilingual UI (English and Vietnamese).

🧱 Features Implemented
🔗 Main Integration
Integrated into the app's main navigation page via one of the four module buttons.

Launches a car-specific management interface.

📄 UI Components
ListView of all saved cars.

TextField + Add Button for inserting cars.

Detail Dialog for editing or deleting cars (reuses creation form layout).

Image Picker for selecting a car photo from gallery.

Default Image Placeholder if no image selected.

Snackbar for user feedback on success/failure actions.

AlertDialog for user confirmations and instructions.

🗃️ Persistent Storage
Uses Drift/Moor to store and retrieve car entries.

Database repopulates ListView on app launch.

🔐 Preferences & Caching
Uses EncryptedSharedPreferences to cache the most recent entry for reuse.

“Use Previous Data” feature replicates the customer page’s functionality.

🌍 Localization
Fully supports:

English

Vietnamese

Chinese

And more...

🧑‍💻 Tech Stack
Language: Dart

Framework: Flutter

Database: Drift (Moor)

UI Elements: Material, Dialogs, Snackbars

Preferences: EncryptedSharedPreferences

Image Support: image_picker plugin
