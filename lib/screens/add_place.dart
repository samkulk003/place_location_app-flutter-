import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'dart:io';

class AddPlaces extends ConsumerStatefulWidget {
  const AddPlaces({super.key});

  @override
  ConsumerState<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends ConsumerState<AddPlaces> {
  final titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selecetdLocation;

  void savePlace() {
    final enteredTitle = titleController.text;

    if (enteredTitle.isEmpty ||
        selectedImage == null ||
        selecetdLocation == null) {
      return;
    }
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, selectedImage!, selecetdLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void save(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add places'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(onPickImage: (image) {
              selectedImage = image;
            }),
            const SizedBox(
              height: 16,
            ),
            LocationInput(
              onSelectLocation: (location) {
                selecetdLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
                onPressed: savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'))
          ],
        ),
      ),
    );
  }
}
