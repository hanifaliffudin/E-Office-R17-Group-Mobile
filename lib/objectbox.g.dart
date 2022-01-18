// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/ChatModel.dart';
import 'models/ConversationModel.dart';
import 'models/NoteModel.dart';
import 'models/UserModel.dart';
import 'models/UserPreferenceModel.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2617362890201989764),
      name: 'ChatModel',
      lastPropertyId: const IdUid(8, 7091170100017291683),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7807880226498698520),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4133682854709566597),
            name: 'idChat',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 8807375290531646823),
            name: 'idConversation',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8620719327909597962),
            name: 'idSender',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2522249012748665889),
            name: 'idReceiver',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3136398464135854419),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8181558102080200822),
            name: 'sendStatus',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7091170100017291683),
            name: 'date',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 537327663400642605),
      name: 'ConversationModel',
      lastPropertyId: const IdUid(8, 2358156270066709074),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4407016937660491071),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1451680902805366454),
            name: 'idConversation',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1050243948999035998),
            name: 'fullName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4127337301530379116),
            name: 'image',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6741606616559079108),
            name: 'message',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8499427580369717432),
            name: 'date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1798234059809525173),
            name: 'messageCout',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2358156270066709074),
            name: 'idReceiver',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 3636392272907486324),
      name: 'Note',
      lastPropertyId: const IdUid(3, 2750085124402894408),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 831525273482604442),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 6631310519448424802),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2750085124402894408),
            name: 'date',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 5073461934191785218),
      name: 'UserModel',
      lastPropertyId: const IdUid(10, 9141564249933411750),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6836424961400260588),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7733812419507250062),
            name: 'userName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3021367722960246740),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8572729448446248808),
            name: 'token',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8516929362775465282),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6802331174161439454),
            name: 'idInstall',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 262709336685257515),
            name: 'photo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 5699610211018257892),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2068277214091341088),
            name: 'verification_code',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 9141564249933411750),
            name: 'enable',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 551286024786238351),
      name: 'UserPreferenceModel',
      lastPropertyId: const IdUid(3, 1027969147495256970),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2461707581331192172),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5790859715451559556),
            name: 'theme',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1027969147495256970),
            name: 'language',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(5, 551286024786238351),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ChatModel: EntityDefinition<ChatModel>(
        model: _entities[0],
        toOneRelations: (ChatModel object) => [],
        toManyRelations: (ChatModel object) => {},
        getId: (ChatModel object) => object.id,
        setId: (ChatModel object, int id) {
          object.id = id;
        },
        objectToFB: (ChatModel object, fb.Builder fbb) {
          final textOffset = fbb.writeString(object.text);
          final sendStatusOffset = fbb.writeString(object.sendStatus);
          final dateOffset = fbb.writeString(object.date);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idChat);
          fbb.addInt64(2, object.idConversation);
          fbb.addInt64(3, object.idSender);
          fbb.addInt64(4, object.idReceiver);
          fbb.addOffset(5, textOffset);
          fbb.addOffset(6, sendStatusOffset);
          fbb.addOffset(7, dateOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ChatModel(
              idChat: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              idConversation: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              idSender: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              idReceiver: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              text:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              sendStatus:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 16, ''),
              date:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 18, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    ConversationModel: EntityDefinition<ConversationModel>(
        model: _entities[1],
        toOneRelations: (ConversationModel object) => [],
        toManyRelations: (ConversationModel object) => {},
        getId: (ConversationModel object) => object.id,
        setId: (ConversationModel object, int id) {
          object.id = id;
        },
        objectToFB: (ConversationModel object, fb.Builder fbb) {
          final fullNameOffset = object.fullName == null
              ? null
              : fbb.writeString(object.fullName!);
          final imageOffset =
              object.image == null ? null : fbb.writeString(object.image!);
          final messageOffset =
              object.message == null ? null : fbb.writeString(object.message!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idConversation);
          fbb.addOffset(2, fullNameOffset);
          fbb.addOffset(3, imageOffset);
          fbb.addOffset(4, messageOffset);
          fbb.addOffset(5, dateOffset);
          fbb.addInt64(6, object.messageCout);
          fbb.addInt64(7, object.idReceiver);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ConversationModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              idConversation: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              idReceiver: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              fullName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              image: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              message: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              date: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              messageCout: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16));

          return object;
        }),
    Note: EntityDefinition<Note>(
        model: _entities[2],
        toOneRelations: (Note object) => [],
        toManyRelations: (Note object) => {},
        getId: (Note object) => object.id,
        setId: (Note object, int id) {
          object.id = id;
        },
        objectToFB: (Note object, fb.Builder fbb) {
          final textOffset =
              object.text == null ? null : fbb.writeString(object.text!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, textOffset);
          fbb.addInt64(2, object.date.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Note(
              text: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              date: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    UserModel: EntityDefinition<UserModel>(
        model: _entities[3],
        toOneRelations: (UserModel object) => [],
        toManyRelations: (UserModel object) => {},
        getId: (UserModel object) => object.id,
        setId: (UserModel object, int id) {
          object.id = id;
        },
        objectToFB: (UserModel object, fb.Builder fbb) {
          final userNameOffset = object.userName == null
              ? null
              : fbb.writeString(object.userName!);
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          final tokenOffset =
              object.token == null ? null : fbb.writeString(object.token!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final idInstallOffset = object.idInstall == null
              ? null
              : fbb.writeString(object.idInstall!);
          final photoOffset =
              object.photo == null ? null : fbb.writeString(object.photo!);
          final phoneOffset =
              object.phone == null ? null : fbb.writeString(object.phone!);
          fbb.startTable(11);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, userNameOffset);
          fbb.addOffset(2, emailOffset);
          fbb.addOffset(3, tokenOffset);
          fbb.addOffset(4, statusOffset);
          fbb.addOffset(5, idInstallOffset);
          fbb.addOffset(6, photoOffset);
          fbb.addOffset(7, phoneOffset);
          fbb.addInt64(8, object.verification_code);
          fbb.addInt64(9, object.enable);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UserModel(
              photo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              userName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              email: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              phone: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              verification_code: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              enable: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              token: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              status: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              idInstall: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    UserPreferenceModel: EntityDefinition<UserPreferenceModel>(
        model: _entities[4],
        toOneRelations: (UserPreferenceModel object) => [],
        toManyRelations: (UserPreferenceModel object) => {},
        getId: (UserPreferenceModel object) => object.id,
        setId: (UserPreferenceModel object, int id) {
          object.id = id;
        },
        objectToFB: (UserPreferenceModel object, fb.Builder fbb) {
          final themeOffset =
              object.theme == null ? null : fbb.writeString(object.theme!);
          final languageOffset = object.language == null
              ? null
              : fbb.writeString(object.language!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, themeOffset);
          fbb.addOffset(2, languageOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UserPreferenceModel(
              theme: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              language: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ChatModel] entity fields to define ObjectBox queries.
class ChatModel_ {
  /// see [ChatModel.id]
  static final id = QueryIntegerProperty<ChatModel>(_entities[0].properties[0]);

  /// see [ChatModel.idChat]
  static final idChat =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[1]);

  /// see [ChatModel.idConversation]
  static final idConversation =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[2]);

  /// see [ChatModel.idSender]
  static final idSender =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[3]);

  /// see [ChatModel.idReceiver]
  static final idReceiver =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[4]);

  /// see [ChatModel.text]
  static final text =
      QueryStringProperty<ChatModel>(_entities[0].properties[5]);

  /// see [ChatModel.sendStatus]
  static final sendStatus =
      QueryStringProperty<ChatModel>(_entities[0].properties[6]);

  /// see [ChatModel.date]
  static final date =
      QueryStringProperty<ChatModel>(_entities[0].properties[7]);
}

/// [ConversationModel] entity fields to define ObjectBox queries.
class ConversationModel_ {
  /// see [ConversationModel.id]
  static final id =
      QueryIntegerProperty<ConversationModel>(_entities[1].properties[0]);

  /// see [ConversationModel.idConversation]
  static final idConversation =
      QueryIntegerProperty<ConversationModel>(_entities[1].properties[1]);

  /// see [ConversationModel.fullName]
  static final fullName =
      QueryStringProperty<ConversationModel>(_entities[1].properties[2]);

  /// see [ConversationModel.image]
  static final image =
      QueryStringProperty<ConversationModel>(_entities[1].properties[3]);

  /// see [ConversationModel.message]
  static final message =
      QueryStringProperty<ConversationModel>(_entities[1].properties[4]);

  /// see [ConversationModel.date]
  static final date =
      QueryStringProperty<ConversationModel>(_entities[1].properties[5]);

  /// see [ConversationModel.messageCout]
  static final messageCout =
      QueryIntegerProperty<ConversationModel>(_entities[1].properties[6]);

  /// see [ConversationModel.idReceiver]
  static final idReceiver =
      QueryIntegerProperty<ConversationModel>(_entities[1].properties[7]);
}

/// [Note] entity fields to define ObjectBox queries.
class Note_ {
  /// see [Note.id]
  static final id = QueryIntegerProperty<Note>(_entities[2].properties[0]);

  /// see [Note.text]
  static final text = QueryStringProperty<Note>(_entities[2].properties[1]);

  /// see [Note.date]
  static final date = QueryIntegerProperty<Note>(_entities[2].properties[2]);
}

/// [UserModel] entity fields to define ObjectBox queries.
class UserModel_ {
  /// see [UserModel.id]
  static final id = QueryIntegerProperty<UserModel>(_entities[3].properties[0]);

  /// see [UserModel.userName]
  static final userName =
      QueryStringProperty<UserModel>(_entities[3].properties[1]);

  /// see [UserModel.email]
  static final email =
      QueryStringProperty<UserModel>(_entities[3].properties[2]);

  /// see [UserModel.token]
  static final token =
      QueryStringProperty<UserModel>(_entities[3].properties[3]);

  /// see [UserModel.status]
  static final status =
      QueryStringProperty<UserModel>(_entities[3].properties[4]);

  /// see [UserModel.idInstall]
  static final idInstall =
      QueryStringProperty<UserModel>(_entities[3].properties[5]);

  /// see [UserModel.photo]
  static final photo =
      QueryStringProperty<UserModel>(_entities[3].properties[6]);

  /// see [UserModel.phone]
  static final phone =
      QueryStringProperty<UserModel>(_entities[3].properties[7]);

  /// see [UserModel.verification_code]
  static final verification_code =
      QueryIntegerProperty<UserModel>(_entities[3].properties[8]);

  /// see [UserModel.enable]
  static final enable =
      QueryIntegerProperty<UserModel>(_entities[3].properties[9]);
}

/// [UserPreferenceModel] entity fields to define ObjectBox queries.
class UserPreferenceModel_ {
  /// see [UserPreferenceModel.id]
  static final id =
      QueryIntegerProperty<UserPreferenceModel>(_entities[4].properties[0]);

  /// see [UserPreferenceModel.theme]
  static final theme =
      QueryStringProperty<UserPreferenceModel>(_entities[4].properties[1]);

  /// see [UserPreferenceModel.language]
  static final language =
      QueryStringProperty<UserPreferenceModel>(_entities[4].properties[2]);
}
