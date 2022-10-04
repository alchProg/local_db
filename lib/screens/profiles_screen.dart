import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:local_db/db/local_database.dart';
import 'package:local_db/models/car_model.dart';
import 'package:local_db/models/profile_model.dart';
import 'package:local_db/screens/profile_settings_screen.dart';

import 'package:local_db/screens/set_screen.dart';
import 'package:local_db/widget/new_profile_dialog.dart';
import 'package:local_db/widget/profile_card_widget.dart';



class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({Key? key}) : super(key: key);

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {

  late List <Profile> profiles;
  late List <Car> cars;
  bool isLoading = false;
  TextEditingController dialogNameController = TextEditingController();
  TextEditingController dialogDescController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    refreshProfiles();
  }

  @override
  void dispose() {
    LocalDatabase.instance.close();
    super.dispose();
  }

  Future refreshProfiles() async {
    setState(() => isLoading = true);
    cars = await LocalDatabase.instance.readGlobalCars();
    profiles = await LocalDatabase.instance.readAllProfiles();
    setState(() => isLoading = false);
  }

  Future newProfileCreate(String title, String? description) async {
    final profile = Profile(
        title: title,
        description: description,
        createdTime: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())
    );
    await LocalDatabase.instance.createProfile(profile);
    refreshProfiles();
    final temp = await LocalDatabase.instance.readTitleProfile(title);
    final pID = temp.id;
    if (cars.isNotEmpty){
      for (Car car in cars) {
        await LocalDatabase.instance.createProfileParts(pID!, car.title);
      }
    }
  }

  void alertButtonPressed () {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      newProfileCreate(
        dialogNameController.text,
        dialogDescController.text,
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
          onPressed: (){refreshProfiles();},
          icon: const Icon(Icons.search_rounded)),
        const SizedBox(width: 12),
      ],
    ),
    body: Column(
      children: [
        isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : profiles.isEmpty
            ? const Center(child: Text(
          'У Вас пока нет ни одного профиля!\n '
              'Создайте профиль нажав на кнопку "+" в левом нижнем углу экрана',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),)
            :buildProfiles(),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      //backgroundColor: Colors.brown,
      child: const Icon(Icons.add),
      onPressed: () async {
        RoundedAlertBox(
            formKey: formKey,
            context: context,
            label: "Новый профиль",
            labelTextName: "Имя профиля",
            press: () => alertButtonPressed(),
            pressText: "Создать",
            controllerName: dialogNameController,
            labelTextDesc: 'Описание профиля',
            controllerDesc: dialogDescController,
        ).openAlertBox();
      },
    ),
  );

  Widget buildProfiles() => Expanded(
    child: ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return ProfileCardWidget(
          profile: profile,
          index: index,
          onProfileSelect: () { onProfileSelect(profile); },
          onProfileSettings: () {onProfileSettings(profile);},
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
        builder: (context) => PartsSettingsScreen(pID: profile.id!, pName: profile.title,)));
    refreshProfiles();
  }
  onProfileSelect(Profile profile) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetScreen(pID: profile.id!, pName: profile.title,)));
  }
}