import 'package:flutter/material.dart';
import 'package:local_db/db/local_database.dart';
import '../models/profile_model.dart';

class ProfileCardWidget extends StatefulWidget {
  const ProfileCardWidget({
    Key? key,
    required this.onProfileSelect,
    required this.onProfileSettings,
    required this.onDeletePressed,
    required this.profile,
    required this.index,
  }) : super(key: key);

  final Profile profile;
  final int index;
  final VoidCallback onProfileSelect;
  final VoidCallback onProfileSettings;
  final VoidCallback onDeletePressed;

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  bool deleteIsVisible = false;

  final color = Colors.black;
  double _height0 = 0;
  double _height1 = 70;
  bool isEdited = false;
  bool isPressedK = false;
  bool isLoading = false;
  TextEditingController titleFieldController = TextEditingController(text: '');
  TextEditingController descFieldController = TextEditingController(text: '');
  late Profile profile;

  @override
  void initState() {
    profile = widget.profile;
    descFieldController.text = (profile.description!.isEmpty
        ? "Описание отсутсвует"
        : profile.description)!;
    titleFieldController.text = profile.title;
    super.initState();
  }

  Future _refreshProfiles() async {
    setState(() => isLoading = true);
    profile = await LocalDatabase.instance.readIDProfile(widget.profile.id!);
    descFieldController.text = (profile.description!.isEmpty
        ? "Описание отсутсвует"
        : profile.description)!;
    titleFieldController.text = profile.title;
    setState(() => isLoading = false);
  }

  _descContAnimations() {
    _height0 = _height0 + _height1;
    _height1 = -_height1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 5),
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            decoration: BoxDecoration(
                                color: isEdited
                                    ? ThemeData.dark()
                                        .dialogBackgroundColor
                                        .withOpacity(0.5)
                                    : null,
                                borderRadius: BorderRadius.circular(4)),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              enabled: isEdited,
                              maxLength: 20,
                              controller: titleFieldController,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                suffixIcon: isEdited
                                    ? Icon(
                                        Icons.edit,
                                        color: Colors.white.withOpacity(0.3),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        profile.createdTime.toString(),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                      onTap: widget.onProfileSelect,
                      onLongPress: () {
                        setState(() {
                          deleteIsVisible = !deleteIsVisible;
                        });
                      },
                      trailing: deleteIsVisible
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 25,
                              onPressed: widget.onDeletePressed,
                              alignment: Alignment.center,
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.redAccent,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                  alignment: Alignment.centerLeft,
                                  onPressed: widget.onProfileSettings,
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.yellow,
                                  ),
                                ),
                                isEdited
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        splashRadius: 25,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          _profileUpdate(
                                              descFieldController.text,
                                              titleFieldController.text);
                                        },
                                        icon: const Icon(
                                          Icons.save,
                                          color: Colors.tealAccent,
                                        ),
                                      )
                                    : IconButton(
                                        padding: EdgeInsets.zero,
                                        splashRadius: 25,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          _profileUpdate(
                                              descFieldController.text,
                                              titleFieldController.text);
                                          setState(() {
                                            isEdited = !isEdited;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                              ],
                            ),
                    ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(4),
                    ),
                    color: isEdited
                        ? ThemeData.dark()
                            .dialogBackgroundColor
                            .withOpacity(0.7)
                        : null,
                  ),
                  padding: const EdgeInsets.only(left: 6),
                  duration: const Duration(milliseconds: 400),
                  height: _height0,
                  alignment: Alignment.topLeft,
                  child: TextField(
                    enabled: isEdited,
                    controller: descFieldController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Описание",
                      labelStyle: const TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      suffixIcon: isEdited
                          ? Icon(
                              Icons.edit,
                              color: Colors.white.withOpacity(0.3),
                            )
                          : null,
                      counterText: "",
                    ),
                    maxLines: 2,
                    maxLength: 75,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _profileUpdate(String newDesc, String newTitle) async {
    if (isEdited) {
      final newProfile = profile.copy(
        title: newTitle,
        description: newDesc,
      );
      await LocalDatabase.instance.updateProfile(newProfile);
      setState(() {
        isEdited = !isEdited;
        _descContAnimations();
      });
      _refreshProfiles();
    } else {
      setState(() {
        _descContAnimations();
      });
      _refreshProfiles();
    }
  }
}
