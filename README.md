# Lab Exam 2 - Flutter Firebase Food List

## Objective

Develop a **single-page Food List Flutter mobile application** that performs CRUD operations using **Firebase Cloud Firestore**.

The application allows the user to:

- Add a new food task.
- Display all saved food tasks automatically.
- Edit an existing food task.
- Delete a food task.
- Prevent empty food names.

## Required Interface

The application includes the required components from the rubric:

- AppBar: `Labexam2_ARACENA`
- TextField for entering a food task
- Add button
- Food/task list
- Edit button
- Delete button

## Firebase Connection

Firebase project:

```text
lab-exam-firebase-aracena
```

Firestore collection:

```text
foods
```

Document structure:

```text
foods/{documentId}
├── name: String
└── created_at: Timestamp
```

The project is initialized with FlutterFire through:

```text
lib/firebase_options.dart
android/app/google-services.json
```

## CRUD Explanation

### Create

The app validates the TextField and adds a new document to the `foods` collection.

```dart
foods.add({
  'name': name,
  'created_at': Timestamp.now(),
});
```

### Read

A Firestore snapshot stream is used with `StreamBuilder`, so the list refreshes automatically whenever Firestore data changes.

```dart
foods.orderBy('created_at', descending: true).snapshots();
```

### Update

The Edit button opens an edit dialog and updates the selected document.

```dart
foods.doc(id).update({
  'name': name,
});
```

### Delete

The Delete button opens a confirmation dialog and removes the selected document.

```dart
foods.doc(id).delete();
```

## Input Validation

Empty food names are rejected. The app displays a SnackBar instead of saving an invalid task.

## Code Organization

```text
lib/
├── firebase_options.dart
├── main.dart
├── screens/
│   └── home_page.dart
└── services/
    └── crud_service.dart
```

- `main.dart` initializes Firebase and starts the application.
- `home_page.dart` contains the single-page UI and input validation.
- `crud_service.dart` contains the Firestore CRUD operations.

## Screenshots

For submission, add screenshots showing:

1. The running **Labexam2_ARACENA** Food List application with saved tasks.
2. The **Add** function.
3. The **Edit** dialog or edited result.
4. The **Delete** confirmation/result.
5. The Firestore `foods` collection in Firebase Console.

These screenshots should be added before final submission because the rubric explicitly requires project screenshots.

## Run

```bash
git pull origin main
flutter pub get
flutter run
```
