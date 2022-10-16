import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:local_db/db/local_database.dart';
import 'package:local_db/screens/car/components/car_model.dart';
import 'package:local_db/models/profile_model.dart';
import 'package:local_db/screens/profile/profile_settings_screen.dart';

import 'package:local_db/screens/current_price_list/set_screen.dart';
import 'package:local_db/screens/profile/components/new_profile_dialog.dart';
import 'package:local_db/screens/profile/components/profile_card_widget.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({Key? key}) : super(key: key);

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late List<Profile> _profiles;
  late List<Car> _cars;
  late bool _isLoading;
  late TextEditingController _dialogNameController;
  late TextEditingController _dialogDescController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dialogNameController = TextEditingController();
    _dialogDescController = TextEditingController();
    _isLoading = false;
    super.initState();
    refreshProfiles();
  }

  @override
  void dispose() {
    _dialogNameController.dispose();
    _dialogDescController.dispose();
    super.dispose();
  }

  Future refreshProfiles() async {
    setState(() => _isLoading = true);
    _cars = await LocalDatabase.instance.readGlobalCars();
    _profiles = await LocalDatabase.instance.readAllProfiles();
    setState(() => _isLoading = false);
  }

  Future newProfileCreate(String title, String? description) async {
    final profile = Profile(
        title: title,
        description: description,
        createdTime: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()));
    await LocalDatabase.instance.createProfile(profile);
    refreshProfiles();
    final temp = await LocalDatabase.instance.readTitleProfile(title);
    final pID = temp.id;
    if (_cars.isNotEmpty) {
      for (Car car in _cars) {
        await LocalDatabase.instance.createProfileParts(pID!, car.title);
      }
    }
  }

  void alertButtonPressed() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      newProfileCreate(
        _dialogNameController.text,
        _dialogDescController.text,
      );
      Navigator.of(context).pop();
    }
  }

  bool checked = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Профили цен',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  refreshProfiles();
                },
                icon: const Icon(Icons.search_rounded)),
            const SizedBox(width: 12),
          ],
        ),
        body: Column(
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _profiles.isEmpty
                    ? const Center(
                        child: Text(
                          'У Вас пока нет ни одного профиля!\n '
                          'Создайте профиль нажав на кнопку "+" в левом нижнем углу экрана',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    : buildProfiles(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            RoundedAlertBox(
              formKey: _formKey,
              context: context,
              label: "Новый профиль",
              labelTextName: "Имя профиля",
              press: () => alertButtonPressed(),
              pressText: "Создать",
              controllerName: _dialogNameController,
              labelTextDesc: 'Описание профиля',
              controllerDesc: _dialogDescController,
            ).openAlertBox();
          },
        ),
      );

  Widget buildProfiles() => Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _profiles.length,
          itemBuilder: (context, index) {
            final profile = _profiles[index];
            return ProfileCardWidget(
              profile: profile,
              index: index,
              onProfileSelect: () {
                onProfileSelect(profile);
              },
              onProfileSettings: () {
                onProfileSettings(profile);
              },
              onDeletePressed: () {
                LocalDatabase.instance.deleteProfile(profile.id!);
                refreshProfiles();
              },
            );
          },
        ),
      );

  onProfileSettings(Profile profile) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PartsSettingsScreen(
              pID: profile.id!,
              pName: profile.title,
            )));
    refreshProfiles();
  }

  onProfileSelect(Profile profile) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetScreen(
              pID: profile.id!,
              pName: profile.title,
            )));
  }
}
