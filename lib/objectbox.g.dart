// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/ChatModel.dart';
import 'models/ContactModel.dart';
import 'models/ConversationModel.dart';
import 'models/NoteModel.dart';
import 'models/SuratModel.dart';
import 'models/UserModel.dart';
import 'models/UserPreferenceModel.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 8545207845013479679),
      name: 'ChatModel',
      lastPropertyId: const IdUid(17, 1344865564871643261),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6787654913477320832),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1551803597755199288),
            name: 'idChat',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5438929904957573701),
            name: 'idChatFriends',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3874054106611177564),
            name: 'idSender',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3226758187122381575),
            name: 'idReceiver',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8959784928608343338),
            name: 'idReceiversGroup',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7995652828133619497),
            name: 'delivered',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 2661004623660279738),
            name: 'read',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3513970685961854208),
            name: 'reply',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 3168672465412237041),
            name: 'tipe',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 1010661106066567316),
            name: 'content',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4539408035342182764),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 7583734201132911294),
            name: 'sendStatus',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 5439230035164061236),
            name: 'date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 6142441164736144040),
            name: 'idRoom',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 8715671368957970015),
            name: 'nameSender',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 1344865564871643261),
            name: 'readDB',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 809924002299303207),
      name: 'ContactModel',
      lastPropertyId: const IdUid(7, 6603394789764896708),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2354852877057924196),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 717101756368192223),
            name: 'userId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6085836598401249653),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6037396541718342597),
            name: 'userName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2370028828191938852),
            name: 'photo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4521585135174361971),
            name: 'select',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6603394789764896708),
            name: 'phone',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 2654284281993313534),
      name: 'ConversationModel',
      lastPropertyId: const IdUid(13, 8204507196677600301),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8223511450883926390),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3864726649437921943),
            name: 'idReceiver',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6376279831486347704),
            name: 'statusReceiver',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1724834308802504556),
            name: 'photoProfile',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7767890843233508726),
            name: 'fullName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1757543234773971374),
            name: 'image',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2481217502380125609),
            name: 'message',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3450087208211086611),
            name: 'date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 8246280883109281975),
            name: 'messageCout',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2949018244159245976),
            name: 'roomId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 3960583577149566736),
            name: 'idReceiversGroup',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7588542004990021558),
            name: 'select',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 8204507196677600301),
            name: 'exited',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 1347771217512160246),
      name: 'Note',
      lastPropertyId: const IdUid(3, 2231019184562705726),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8554398302121139322),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7792458466627635686),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2231019184562705726),
            name: 'date',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 482287716579701402),
      name: 'UserModel',
      lastPropertyId: const IdUid(12, 2666899128845317677),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3819766976394870339),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 769146633078252544),
            name: 'userId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2240058942075360076),
            name: 'fcmToken',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1372291323764360586),
            name: 'photo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 4635557706629164512),
            name: 'userName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6873017685322297243),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2090403142729828773),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6049542046117687891),
            name: 'verification_code',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 9075600564856532606),
            name: 'enable',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2308217109749124294),
            name: 'token',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2361755993786315467),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 2666899128845317677),
            name: 'idInstall',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 5814450654016316997),
      name: 'UserPreferenceModel',
      lastPropertyId: const IdUid(3, 4330669021005113861),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5432194735903576231),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5444514287801597900),
            name: 'theme',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4330669021005113861),
            name: 'language',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 2414097441055247438),
      name: 'SuratModel',
      lastPropertyId: const IdUid(11, 4059827562741519930),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6624613082801306069),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3165271609872564211),
            name: 'idSurat',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7462045052997472340),
            name: 'namaSurat',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5560650516689580981),
            name: 'perihal',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7524955658646734150),
            name: 'nomorSurat',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2579944011491187558),
            name: 'tglBuat',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 445444101354249879),
            name: 'tglSelesai',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3922386874057685126),
            name: 'pengirim',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6284682870865015995),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 6241234338860606637),
            name: 'kategori',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 4059827562741519930),
            name: 'url',
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
      lastEntityId: const IdUid(7, 2414097441055247438),
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
          final idReceiversGroupOffset = object.idReceiversGroup == null
              ? null
              : fbb.writeString(object.idReceiversGroup!);
          final tipeOffset =
              object.tipe == null ? null : fbb.writeString(object.tipe!);
          final contentOffset =
              object.content == null ? null : fbb.writeString(object.content!);
          final textOffset = fbb.writeString(object.text);
          final sendStatusOffset = fbb.writeString(object.sendStatus);
          final dateOffset = fbb.writeString(object.date);
          final nameSenderOffset = object.nameSender == null
              ? null
              : fbb.writeString(object.nameSender!);
          fbb.startTable(18);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idChat);
          fbb.addInt64(2, object.idChatFriends);
          fbb.addInt64(3, object.idSender);
          fbb.addInt64(4, object.idReceiver);
          fbb.addOffset(5, idReceiversGroupOffset);
          fbb.addInt64(6, object.delivered);
          fbb.addInt64(7, object.read);
          fbb.addInt64(8, object.reply);
          fbb.addOffset(9, tipeOffset);
          fbb.addOffset(10, contentOffset);
          fbb.addOffset(11, textOffset);
          fbb.addOffset(12, sendStatusOffset);
          fbb.addOffset(13, dateOffset);
          fbb.addInt64(14, object.idRoom);
          fbb.addOffset(15, nameSenderOffset);
          fbb.addInt64(16, object.readDB);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ChatModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              idChat: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              idChatFriends: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              idSender: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              nameSender: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 34),
              idReceiver: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              idReceiversGroup: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              idRoom: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 32),
              delivered: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              read: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              readDB: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 36),
              reply: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              tipe: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 22),
              content: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 24),
              text: const fb.StringReader().vTableGet(buffer, rootOffset, 26, ''),
              sendStatus: const fb.StringReader().vTableGet(buffer, rootOffset, 28, ''),
              date: const fb.StringReader().vTableGet(buffer, rootOffset, 30, ''));

          return object;
        }),
    ContactModel: EntityDefinition<ContactModel>(
        model: _entities[1],
        toOneRelations: (ContactModel object) => [],
        toManyRelations: (ContactModel object) => {},
        getId: (ContactModel object) => object.id,
        setId: (ContactModel object, int id) {
          object.id = id;
        },
        objectToFB: (ContactModel object, fb.Builder fbb) {
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          final userNameOffset = object.userName == null
              ? null
              : fbb.writeString(object.userName!);
          final photoOffset =
              object.photo == null ? null : fbb.writeString(object.photo!);
          final phoneOffset =
              object.phone == null ? null : fbb.writeString(object.phone!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.userId);
          fbb.addOffset(2, emailOffset);
          fbb.addOffset(3, userNameOffset);
          fbb.addOffset(4, photoOffset);
          fbb.addBool(5, object.select);
          fbb.addOffset(6, phoneOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ContactModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              userId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              email: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              userName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              photo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              phone: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              select: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 14, false));

          return object;
        }),
    ConversationModel: EntityDefinition<ConversationModel>(
        model: _entities[2],
        toOneRelations: (ConversationModel object) => [],
        toManyRelations: (ConversationModel object) => {},
        getId: (ConversationModel object) => object.id,
        setId: (ConversationModel object, int id) {
          object.id = id;
        },
        objectToFB: (ConversationModel object, fb.Builder fbb) {
          final statusReceiverOffset = fbb.writeString(object.statusReceiver);
          final photoProfileOffset = object.photoProfile == null
              ? null
              : fbb.writeString(object.photoProfile!);
          final fullNameOffset = object.fullName == null
              ? null
              : fbb.writeString(object.fullName!);
          final imageOffset =
              object.image == null ? null : fbb.writeString(object.image!);
          final messageOffset =
              object.message == null ? null : fbb.writeString(object.message!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          final idReceiversGroupOffset = object.idReceiversGroup == null
              ? null
              : fbb.writeString(object.idReceiversGroup!);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idReceiver);
          fbb.addOffset(2, statusReceiverOffset);
          fbb.addOffset(3, photoProfileOffset);
          fbb.addOffset(4, fullNameOffset);
          fbb.addOffset(5, imageOffset);
          fbb.addOffset(6, messageOffset);
          fbb.addOffset(7, dateOffset);
          fbb.addInt64(8, object.messageCout);
          fbb.addInt64(9, object.roomId);
          fbb.addOffset(10, idReceiversGroupOffset);
          fbb.addBool(11, object.select);
          fbb.addBool(12, object.exited);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ConversationModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              idReceiver: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              statusReceiver:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 8, ''),
              photoProfile: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              fullName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              image: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              message: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              date: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              messageCout: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              roomId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              idReceiversGroup: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              select: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 26, false),
              exited: const fb.BoolReader().vTableGet(buffer, rootOffset, 28, false));

          return object;
        }),
    Note: EntityDefinition<Note>(
        model: _entities[3],
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
        model: _entities[4],
        toOneRelations: (UserModel object) => [],
        toManyRelations: (UserModel object) => {},
        getId: (UserModel object) => object.id,
        setId: (UserModel object, int id) {
          object.id = id;
        },
        objectToFB: (UserModel object, fb.Builder fbb) {
          final fcmTokenOffset = object.fcmToken == null
              ? null
              : fbb.writeString(object.fcmToken!);
          final photoOffset =
              object.photo == null ? null : fbb.writeString(object.photo!);
          final userNameOffset = object.userName == null
              ? null
              : fbb.writeString(object.userName!);
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          final phoneOffset =
              object.phone == null ? null : fbb.writeString(object.phone!);
          final tokenOffset =
              object.token == null ? null : fbb.writeString(object.token!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final idInstallOffset = object.idInstall == null
              ? null
              : fbb.writeString(object.idInstall!);
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.userId);
          fbb.addOffset(2, fcmTokenOffset);
          fbb.addOffset(3, photoOffset);
          fbb.addOffset(4, userNameOffset);
          fbb.addOffset(5, emailOffset);
          fbb.addOffset(6, phoneOffset);
          fbb.addInt64(7, object.verification_code);
          fbb.addInt64(8, object.enable);
          fbb.addOffset(9, tokenOffset);
          fbb.addOffset(10, statusOffset);
          fbb.addOffset(11, idInstallOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = UserModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              userId: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              fcmToken: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              photo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              userName: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              email: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 14),
              phone: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              verification_code: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              enable: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              token: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              status: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              idInstall: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26));

          return object;
        }),
    UserPreferenceModel: EntityDefinition<UserPreferenceModel>(
        model: _entities[5],
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
        }),
    SuratModel: EntityDefinition<SuratModel>(
        model: _entities[6],
        toOneRelations: (SuratModel object) => [],
        toManyRelations: (SuratModel object) => {},
        getId: (SuratModel object) => object.id,
        setId: (SuratModel object, int id) {
          object.id = id;
        },
        objectToFB: (SuratModel object, fb.Builder fbb) {
          final idSuratOffset =
              object.idSurat == null ? null : fbb.writeString(object.idSurat!);
          final namaSuratOffset = object.namaSurat == null
              ? null
              : fbb.writeString(object.namaSurat!);
          final perihalOffset =
              object.perihal == null ? null : fbb.writeString(object.perihal!);
          final nomorSuratOffset = object.nomorSurat == null
              ? null
              : fbb.writeString(object.nomorSurat!);
          final tglBuatOffset =
              object.tglBuat == null ? null : fbb.writeString(object.tglBuat!);
          final tglSelesaiOffset = object.tglSelesai == null
              ? null
              : fbb.writeString(object.tglSelesai!);
          final pengirimOffset = object.pengirim == null
              ? null
              : fbb.writeString(object.pengirim!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final kategoriOffset = object.kategori == null
              ? null
              : fbb.writeString(object.kategori!);
          final urlOffset =
              object.url == null ? null : fbb.writeString(object.url!);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, idSuratOffset);
          fbb.addOffset(2, namaSuratOffset);
          fbb.addOffset(3, perihalOffset);
          fbb.addOffset(4, nomorSuratOffset);
          fbb.addOffset(5, tglBuatOffset);
          fbb.addOffset(6, tglSelesaiOffset);
          fbb.addOffset(7, pengirimOffset);
          fbb.addOffset(8, statusOffset);
          fbb.addOffset(9, kategoriOffset);
          fbb.addOffset(10, urlOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SuratModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              idSurat: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              namaSurat: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              perihal: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              nomorSurat: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 12),
              tglSelesai: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              pengirim: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              status: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              kategori: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              url: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24))
            ..tglBuat = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 14);

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

  /// see [ChatModel.idChatFriends]
  static final idChatFriends =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[2]);

  /// see [ChatModel.idSender]
  static final idSender =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[3]);

  /// see [ChatModel.idReceiver]
  static final idReceiver =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[4]);

  /// see [ChatModel.idReceiversGroup]
  static final idReceiversGroup =
      QueryStringProperty<ChatModel>(_entities[0].properties[5]);

  /// see [ChatModel.delivered]
  static final delivered =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[6]);

  /// see [ChatModel.read]
  static final read =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[7]);

  /// see [ChatModel.reply]
  static final reply =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[8]);

  /// see [ChatModel.tipe]
  static final tipe =
      QueryStringProperty<ChatModel>(_entities[0].properties[9]);

  /// see [ChatModel.content]
  static final content =
      QueryStringProperty<ChatModel>(_entities[0].properties[10]);

  /// see [ChatModel.text]
  static final text =
      QueryStringProperty<ChatModel>(_entities[0].properties[11]);

  /// see [ChatModel.sendStatus]
  static final sendStatus =
      QueryStringProperty<ChatModel>(_entities[0].properties[12]);

  /// see [ChatModel.date]
  static final date =
      QueryStringProperty<ChatModel>(_entities[0].properties[13]);

  /// see [ChatModel.idRoom]
  static final idRoom =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[14]);

  /// see [ChatModel.nameSender]
  static final nameSender =
      QueryStringProperty<ChatModel>(_entities[0].properties[15]);

  /// see [ChatModel.readDB]
  static final readDB =
      QueryIntegerProperty<ChatModel>(_entities[0].properties[16]);
}

/// [ContactModel] entity fields to define ObjectBox queries.
class ContactModel_ {
  /// see [ContactModel.id]
  static final id =
      QueryIntegerProperty<ContactModel>(_entities[1].properties[0]);

  /// see [ContactModel.userId]
  static final userId =
      QueryIntegerProperty<ContactModel>(_entities[1].properties[1]);

  /// see [ContactModel.email]
  static final email =
      QueryStringProperty<ContactModel>(_entities[1].properties[2]);

  /// see [ContactModel.userName]
  static final userName =
      QueryStringProperty<ContactModel>(_entities[1].properties[3]);

  /// see [ContactModel.photo]
  static final photo =
      QueryStringProperty<ContactModel>(_entities[1].properties[4]);

  /// see [ContactModel.select]
  static final select =
      QueryBooleanProperty<ContactModel>(_entities[1].properties[5]);

  /// see [ContactModel.phone]
  static final phone =
      QueryStringProperty<ContactModel>(_entities[1].properties[6]);
}

/// [ConversationModel] entity fields to define ObjectBox queries.
class ConversationModel_ {
  /// see [ConversationModel.id]
  static final id =
      QueryIntegerProperty<ConversationModel>(_entities[2].properties[0]);

  /// see [ConversationModel.idReceiver]
  static final idReceiver =
      QueryIntegerProperty<ConversationModel>(_entities[2].properties[1]);

  /// see [ConversationModel.statusReceiver]
  static final statusReceiver =
      QueryStringProperty<ConversationModel>(_entities[2].properties[2]);

  /// see [ConversationModel.photoProfile]
  static final photoProfile =
      QueryStringProperty<ConversationModel>(_entities[2].properties[3]);

  /// see [ConversationModel.fullName]
  static final fullName =
      QueryStringProperty<ConversationModel>(_entities[2].properties[4]);

  /// see [ConversationModel.image]
  static final image =
      QueryStringProperty<ConversationModel>(_entities[2].properties[5]);

  /// see [ConversationModel.message]
  static final message =
      QueryStringProperty<ConversationModel>(_entities[2].properties[6]);

  /// see [ConversationModel.date]
  static final date =
      QueryStringProperty<ConversationModel>(_entities[2].properties[7]);

  /// see [ConversationModel.messageCout]
  static final messageCout =
      QueryIntegerProperty<ConversationModel>(_entities[2].properties[8]);

  /// see [ConversationModel.roomId]
  static final roomId =
      QueryIntegerProperty<ConversationModel>(_entities[2].properties[9]);

  /// see [ConversationModel.idReceiversGroup]
  static final idReceiversGroup =
      QueryStringProperty<ConversationModel>(_entities[2].properties[10]);

  /// see [ConversationModel.select]
  static final select =
      QueryBooleanProperty<ConversationModel>(_entities[2].properties[11]);

  /// see [ConversationModel.exited]
  static final exited =
      QueryBooleanProperty<ConversationModel>(_entities[2].properties[12]);
}

/// [Note] entity fields to define ObjectBox queries.
class Note_ {
  /// see [Note.id]
  static final id = QueryIntegerProperty<Note>(_entities[3].properties[0]);

  /// see [Note.text]
  static final text = QueryStringProperty<Note>(_entities[3].properties[1]);

  /// see [Note.date]
  static final date = QueryIntegerProperty<Note>(_entities[3].properties[2]);
}

/// [UserModel] entity fields to define ObjectBox queries.
class UserModel_ {
  /// see [UserModel.id]
  static final id = QueryIntegerProperty<UserModel>(_entities[4].properties[0]);

  /// see [UserModel.userId]
  static final userId =
      QueryIntegerProperty<UserModel>(_entities[4].properties[1]);

  /// see [UserModel.fcmToken]
  static final fcmToken =
      QueryStringProperty<UserModel>(_entities[4].properties[2]);

  /// see [UserModel.photo]
  static final photo =
      QueryStringProperty<UserModel>(_entities[4].properties[3]);

  /// see [UserModel.userName]
  static final userName =
      QueryStringProperty<UserModel>(_entities[4].properties[4]);

  /// see [UserModel.email]
  static final email =
      QueryStringProperty<UserModel>(_entities[4].properties[5]);

  /// see [UserModel.phone]
  static final phone =
      QueryStringProperty<UserModel>(_entities[4].properties[6]);

  /// see [UserModel.verification_code]
  static final verification_code =
      QueryIntegerProperty<UserModel>(_entities[4].properties[7]);

  /// see [UserModel.enable]
  static final enable =
      QueryIntegerProperty<UserModel>(_entities[4].properties[8]);

  /// see [UserModel.token]
  static final token =
      QueryStringProperty<UserModel>(_entities[4].properties[9]);

  /// see [UserModel.status]
  static final status =
      QueryStringProperty<UserModel>(_entities[4].properties[10]);

  /// see [UserModel.idInstall]
  static final idInstall =
      QueryStringProperty<UserModel>(_entities[4].properties[11]);
}

/// [UserPreferenceModel] entity fields to define ObjectBox queries.
class UserPreferenceModel_ {
  /// see [UserPreferenceModel.id]
  static final id =
      QueryIntegerProperty<UserPreferenceModel>(_entities[5].properties[0]);

  /// see [UserPreferenceModel.theme]
  static final theme =
      QueryStringProperty<UserPreferenceModel>(_entities[5].properties[1]);

  /// see [UserPreferenceModel.language]
  static final language =
      QueryStringProperty<UserPreferenceModel>(_entities[5].properties[2]);
}

/// [SuratModel] entity fields to define ObjectBox queries.
class SuratModel_ {
  /// see [SuratModel.id]
  static final id =
      QueryIntegerProperty<SuratModel>(_entities[6].properties[0]);

  /// see [SuratModel.idSurat]
  static final idSurat =
      QueryStringProperty<SuratModel>(_entities[6].properties[1]);

  /// see [SuratModel.namaSurat]
  static final namaSurat =
      QueryStringProperty<SuratModel>(_entities[6].properties[2]);

  /// see [SuratModel.perihal]
  static final perihal =
      QueryStringProperty<SuratModel>(_entities[6].properties[3]);

  /// see [SuratModel.nomorSurat]
  static final nomorSurat =
      QueryStringProperty<SuratModel>(_entities[6].properties[4]);

  /// see [SuratModel.tglBuat]
  static final tglBuat =
      QueryStringProperty<SuratModel>(_entities[6].properties[5]);

  /// see [SuratModel.tglSelesai]
  static final tglSelesai =
      QueryStringProperty<SuratModel>(_entities[6].properties[6]);

  /// see [SuratModel.pengirim]
  static final pengirim =
      QueryStringProperty<SuratModel>(_entities[6].properties[7]);

  /// see [SuratModel.status]
  static final status =
      QueryStringProperty<SuratModel>(_entities[6].properties[8]);

  /// see [SuratModel.kategori]
  static final kategori =
      QueryStringProperty<SuratModel>(_entities[6].properties[9]);

  /// see [SuratModel.url]
  static final url =
      QueryStringProperty<SuratModel>(_entities[6].properties[10]);
}
