import 'package:militarymessenger/models/ChatModel.dart';
import 'objectbox.g.dart';

class DBHelpers{

  static Future<int> setChat(ChatModel chat) async {
    final store = await openStore();
    final box = store.box<ChatModel>();
    int x = box.put(chat);
    store.close();
    return x;
  }

  static Future<bool> deleteChat(int id) async {
    final store = await openStore();
    var box = store.box<ChatModel>();
    store.close();
    bool x = box.remove(id);
    store.close();
    return x;
  }

  static Future<ChatModel?> getChat(int id) async {
    final store = await openStore();
    var box = store.box<ChatModel>();
    var x = box.get(id);
    store.close();
    return x;
  }

  static Future<List<ChatModel>> getChatAll() async {
    final store = await openStore();
    var box = store.box<ChatModel>();
    List<ChatModel> x = box.getAll().toList();
    store.close();
    return x;
  }
}