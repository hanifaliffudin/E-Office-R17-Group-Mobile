import 'package:objectbox/objectbox.dart';

@Entity()
class SavedModel {
  int id;
  String? type;
  bool? value;

  SavedModel({
    this.id = 0,
    this.type,
    this.value,
  });
}
