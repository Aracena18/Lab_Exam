# Lab Exam 2 Firestore CRUD Cheat Sheet

## Collection

```dart
final CollectionReference foods =
    FirebaseFirestore.instance.collection('foods');
```

## CREATE

```dart
foods.add({
  'name': name,
  'created_at': Timestamp.now(),
});
```

## READ

```dart
foods.orderBy('created_at', descending: true).snapshots();
```

Use the stream in:

```dart
StreamBuilder<QuerySnapshot>(
  stream: service.getFoods(),
  builder: (context, snapshot) {
    final foods = snapshot.data!.docs;
    // Build the food list here.
  },
)
```

## UPDATE

```dart
foods.doc(id).update({
  'name': name,
});
```

## DELETE

```dart
foods.doc(id).delete();
```

## Input Validation

```dart
final name = foodController.text.trim();

if (name.isEmpty) {
  return;
}
```

## Files to remember

```text
lib/main.dart
lib/firebase_options.dart
lib/screens/home_page.dart
lib/services/crud_service.dart
```

## Run

```bash
flutter pub get
flutter run
```
