import 'package:objectbox/objectbox.dart';

@Entity()
class LoadChatModel {
  int id;
  int loaded = 0;

  LoadChatModel(
      {
        this.id = 0,
        this.loaded = 0,
      });
}
