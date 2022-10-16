import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/part_model.dart';
import 'package:local_db/screens/part/add_edit_part_screen.dart';
import 'package:local_db/screens/part/components/part_card_widget.dart';

class PartsSlideItems extends StatefulWidget {
  final int pID;
  final String currentCarType;
  final String pName;
  final List<Part> parts;

  const PartsSlideItems({
    Key? key,
    required this.pID,
    required this.currentCarType,
    required this.pName,
    required this.parts,
  }) : super(key: key);

  @override
  State<PartsSlideItems> createState() => _PartsSlideItemsState();
}

class _PartsSlideItemsState extends State<PartsSlideItems> {
  bool isLoading = false;
  late List<Part> parts;
  late String side;
  @override
  void initState() {
    parts = widget.parts;
    side = parts.last.side!;
    super.initState();
  }

  Future refreshParts() async {
    setState(() => isLoading = true);
    parts = await LocalDatabase.instance
        .readProfileParts(widget.currentCarType, widget.pID, side);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: ListView.builder(
                itemCount: parts.length,
                itemBuilder: (context, index) {
                  final part = parts[index];
                  return InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditPartScreen(
                                pID: widget.pID,
                                pName: widget.pName,
                                part: part,
                              )));
                      refreshParts();
                    },
                    child: PartCardWidget(part: part, index: index),
                  );
                },
              )),
      ],
    );
  }
}
