import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferenceModel {
  int id = 0;
  String? theme="light"; // dark, light, system
  String? language="en"; // en, id


  UserPreferenceModel(
      {
        this.theme,
        this.language,
      });
}
