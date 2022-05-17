import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import 'add_place_screen.dart';
import '../providers/places.dart';
import 'place_details_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: GoogleFonts.cabin(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            Text(
              'Your places',
              style: GoogleFonts.cabin(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    child: const Center(
                      child: Text('Got no places yet'),
                    ),
                    builder: (ctx, greatPlaces, ch) => greatPlaces.items.isEmpty
                        ? ch
                        : ListView.builder(
                            itemCount: greatPlaces.items.length,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[i].image),
                              ),
                              title: Text(
                                greatPlaces.items[i].title,
                                style: GoogleFonts.cabin(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                greatPlaces.items[i].location.address,
                                style: GoogleFonts.cabin(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: greatPlaces.items[i].id,
                                );
                              },
                            ),
                          ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
        },
        child: Icon(Ionicons.add),
      ),
    );
  }
}
