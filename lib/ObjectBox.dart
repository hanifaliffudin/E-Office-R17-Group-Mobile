import 'package:militarymessenger/models/ContactModel.dart';
import 'package:militarymessenger/models/ConversationModel.dart';
import 'package:militarymessenger/models/UserModel.dart';
import 'package:militarymessenger/models/SuratModel.dart';
import 'package:militarymessenger/models/UserPreferenceModel.dart';

import 'models/ChatModel.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  late final Box<ChatModel> boxChat;
  late final Box<UserModel> boxUser;
  late final Box<ConversationModel> boxConversation;
  late final Box<UserPreferenceModel> boxUserPreference;
  late final Box<ContactModel> boxContact;
  late final Box<SuratModel> boxSurat;

  /// A stream of all notes ordered by date.
  late final Stream<Query<ChatModel>> queryStreamChat;
  late final Stream<Query<UserModel>> queryStreamUser;
  late final Stream<Query<ConversationModel>> queryStreamConversation;
  late final Stream<Query<ContactModel>> queryStreamContact;
  late final Stream<Query<SuratModel>> queryStreamSurat;

  ObjectBox._create(this.store) {
    boxChat = Box<ChatModel>(store);
    boxUser = Box<UserModel>(store);
    boxConversation = Box<ConversationModel>(store);
    boxUserPreference = Box<UserPreferenceModel>(store);
    boxContact = Box<ContactModel>(store);
    boxSurat = Box<SuratModel>(store);

    final qBuilderChat = boxChat.query()
      ..order(ChatModel_.id, flags: Order.descending);
    queryStreamChat = qBuilderChat.watch(triggerImmediately: true);

    final qBuilderUser = boxUser.query()
      ..order(UserModel_.id, flags: Order.descending);
    queryStreamUser = qBuilderUser.watch(triggerImmediately: true);

    final qBuilderConversation = boxConversation.query()
      ..order(ConversationModel_.id, flags: Order.descending);
    queryStreamConversation = qBuilderConversation.watch(triggerImmediately: true);

    final qBuilderContact = boxContact.query()
      ..order(ContactModel_.id, flags: Order.descending);
    queryStreamContact = qBuilderContact.watch(triggerImmediately: true);

    final qBuilderSurat = boxSurat.query()
      ..order(SuratModel_.id, flags: Order.descending);
    queryStreamSurat = qBuilderSurat.watch(triggerImmediately: true);

    // Add some demo data if the box is empty.
    //if (mains.objectbox.boxConversation.isEmpty()) {
    //  _putDemoData();
    //}
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
/*
  void _putDemoData() {
    final demoConversation = [
      ConversationModel(id : 0, idConversation: 1, idReceiver: 2, fullName: 'Selamat datang di R17 ',image: '',message: 'Selamat datang di R17',date: DateTime.now().toString(),messageCout: 1)

      /*,
      ConversationModel(idConversation: 2, idReceiver: 3, fullName: 'Galih moumin',image: '',message: 'Hello...',date: '3 days ago',messageCout: 0),
      ConversationModel(idConversation: 3, idReceiver: 4, fullName: 'Trisna rachi',image: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_960_720.png',message: 'a feen',date: '12:00 AM',messageCout: 4),
      ConversationModel(idConversation: 4, idReceiver: 5, fullName: 'Malik yassine',image: 'https://thumbs.dreamstime.com/b/profile-icon-male-avatar-portrait-casual-person-silhouette-face-flat-design-vector-illustration-58249439.jpg',message: 'hi',date: '11:48 AM',messageCout:0),
      ConversationModel(idConversation: 5, idReceiver: 6, fullName: 'Frans trick',image: 'https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-male-avatar-maker.jpg',message: 'hi',date: 'yesterday',messageCout: 0),
      ConversationModel(idConversation: 6, idReceiver: 7, fullName: 'Yusuf aleson',image: 'https://www.doesport.co.uk/wp-content/uploads/2017/11/profile-icon-male-avatar-portrait-casual-person-silhouette-face-flat-design-vector-illustration-58249394.jpg',message: 'hi',date: '17:48 PM',messageCout: 0),
      ConversationModel(idConversation: 7, idReceiver: 8, fullName: 'Ali mourad',image: 'https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_960_720.png',message: 'salam ',date: 'yesterday',messageCout: 0)*/
    ];
    //boxConversation.putMany(demoConversation);
    boxConversation.put(demoConversation);
  }*/
}