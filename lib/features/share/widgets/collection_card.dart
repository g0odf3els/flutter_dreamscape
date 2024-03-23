import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/features/image/widgets/widgets.dart';
import 'package:flutter_dreamscape/repositories/collection/models/models.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    Key? key,
    required this.collection,
    this.inCollection =
        false, // Додали параметр inCollection зі значенням за замовчуванням false
  }) : super(key: key);

  final Collection collection;
  final bool inCollection; // Параметр, що вказує, чи є колекція у колекції

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  collection.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (inCollection)
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(4.0),
                    child:
                        const Icon(Icons.bookmark_outline, color: Colors.black),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TagList(tags: collection.tags),
          ),
        ],
      ),
    );
  }
}
