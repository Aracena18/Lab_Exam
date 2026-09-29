# Flutter Firebase CRUD Lab Exam

A small, exam-friendly Flutter + Firebase Firestore CRUD reference.

## What this project covers

- Create an item
- Read items in real time with `StreamBuilder`
- Update an item
- Delete an item
- Favorite / unfavorite an item
- Favorite-only filter
- Simple file structure that is easy to study

## File structure

```text
lib/
├── main.dart
├── screens/
│   └── home_page.dart
└── services/
    └── crud_service.dart
```

## First-time setup

Clone the repository:

```bash
git clone https://github.com/Aracena18/Lab_Exam.git
cd Lab_Exam
```

Generate the Flutter platform folders if they are not present:

```bash
flutter create . --project-name lab_exam
```

Install the dependencies:

```bash
flutter pub get
```

Make sure Firebase CLI and FlutterFire CLI are available:

```bash
firebase --version
flutterfire --version
```

If needed:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

Log in and configure Firebase:

```bash
firebase login
flutterfire configure
```

Choose or create a Firebase project and select **Android**.

Then enable Firestore in Firebase Console:

```text
Firebase Console
→ Databases & Storage
→ Firestore Database
→ Create database
```

For a classroom/lab exercise, use the Firestore mode required by your instructor.

Run the app:

```bash
flutter run
```

## Firestore collection

This app uses:

```text
items
```

Each document contains:

```text
name
quantity
created_at
is_favorite
```

## CRUD mapping

| CRUD | Flutter / Firestore |
|---|---|
| Create | `collection.add({...})` |
| Read | `collection.snapshots()` |
| Update | `doc(id).update({...})` |
| Delete | `doc(id).delete()` |

See [CHEATSHEET.md](CHEATSHEET.md) for the shortest exam-review version.
