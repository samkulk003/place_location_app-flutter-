import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:favorite_places/models/place.dart';
//import 'package:flutter/widgets.dart';

class Places extends ConsumerStatefulWidget {
  const Places({super.key});
  @override
  ConsumerState<Places> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends ConsumerState<Places> {
  late Future<void> placesFuture;

  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const AddPlaces()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}
