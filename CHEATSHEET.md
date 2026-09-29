# Firebase CRUD Lab Exam Cheat Sheet

## 1. Firebase initialization

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

## 2. Firestore collection

```dart
final CollectionReference items =
    FirebaseFirestore.instance.collection('items');
```

## 3. CREATE

```dart
items.add({
  'name': name,
  'quantity': quantity,
  'created_at': Timestamp.now(),
});
```

## 4. READ

```dart
Stream<QuerySnapshot> getItems() {
  return items.snapshots();
}
```

Use it with:

```dart
StreamBuilder<QuerySnapshot>(
  stream: service.getItems(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    final docs = snapshot.data!.docs;

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final item = docs[index];
        final data =
            item.data() as Map<String, dynamic>;

        return ListTile(
          title: Text(data['name']),
          subtitle: Text(
            'Quantity ${data['quantity']}',
          ),
        );
      },
    );
  },
)
```

## 5. UPDATE

```dart
items.doc(id).update({
  'name': name,
  'quantity': quantity,
});
```

## 6. DELETE

```dart
items.doc(id).delete();
```

## 7. Favorite field

When creating:

```dart
'is_favorite': false,
```

Toggle:

```dart
items.doc(id).update({
  'is_favorite': !currentStatus,
});
```

Filter:

```dart
docs = docs.where((doc) {
  final data =
      doc.data() as Map<String, dynamic>;

  return data['is_favorite'] == true;
}).toList();
```

## 8. Commands to remember

```bash
flutter pub get
firebase login
flutterfire configure
flutter run
```

If the platform folders are missing:

```bash
flutter create . --project-name lab_exam
```

## 9. Mental model

```text
UI
↓
CrudService
↓
FirebaseFirestore.instance
↓
collection('items')
↓
documents
```

The four Firestore calls to remember:

```dart
.add()
.snapshots()
.update()
.delete()
```
