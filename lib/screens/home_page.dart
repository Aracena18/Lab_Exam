import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/crud_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudService service = CrudService();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  static const Color primaryBlue = Color(0xFF075F7D);
  static const Color editGray = Color(0xFF555555);
  static const Color deleteRed = Color(0xFFC75C5C);
  static const Color hintGray = Color(0xFFA9A9A9);
  static const Color textBlack = Color(0xFF222222);

  @override
  void dispose() {
    foodController.dispose();
    editController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // CREATE: validates the input before saving a task to Firestore.
  Future<void> addFood() async {
    final String name = foodController.text.trim();

    if (name.isEmpty) {
      showMessage('Please enter a task.');
      return;
    }

    try {
      await service.addFood(name);
      foodController.clear();
    } on FirebaseException catch (e) {
      showMessage('Firebase error: ${e.code}');
    } catch (e) {
      showMessage('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textBlack,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        titleSpacing: 24,
        title: const Text(
          'Labexam2_ARACENA',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: textBlack,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: textBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),

      // Single-page layout based on the provided lab-exam reference design.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: foodController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => addFood(),
                      style: const TextStyle(
                        fontSize: 17,
                        color: textBlack,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Add a new task...',
                        hintStyle: TextStyle(
                          color: hintGray,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 62,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: addFood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // READ: automatically rebuilds whenever Firestore data changes.
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: service.getFoods(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Firestore error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryBlue,
                        ),
                      );
                    }

                    final foods = snapshot.data!.docs;

                    if (foods.isEmpty) {
                      return const Center(
                        child: Text(
                          'No tasks yet.',
                          style: TextStyle(
                            fontSize: 16,
                            color: hintGray,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: foods.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final food = foods[index];
                        final data =
                            food.data() as Map<String, dynamic>;

                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['name']?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: textBlack,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit',
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                openEditDialog(context, food);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: editGray,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              tooltip: 'Delete',
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                confirmDelete(context, food.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: deleteRed,
                                size: 22,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UPDATE: opens a simple edit dialog for the selected task.
  void openEditDialog(
    BuildContext context,
    DocumentSnapshot food,
  ) {
    final data = food.data() as Map<String, dynamic>;
    editController.text = data['name']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Task name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final String name = editController.text.trim();

              if (name.isEmpty) {
                showMessage('Task cannot be empty.');
                return;
              }

              Navigator.pop(dialogContext);

              try {
                await service.updateFood(food.id, name);
              } on FirebaseException catch (e) {
                showMessage('Firebase error: ${e.code}');
              } catch (e) {
                showMessage('Error: $e');
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  // DELETE: confirms before removing the selected task.
  void confirmDelete(
    BuildContext context,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              try {
                await service.deleteFood(id);
              } on FirebaseException catch (e) {
                showMessage('Firebase error: ${e.code}');
              } catch (e) {
                showMessage('Error: $e');
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: deleteRed),
            ),
          ),
        ],
      ),
    );
  }
}
