import 'package:objectbox/objectbox.dart';

@Entity()
class SuratModel {
  int id;
  String? idSurat;
  String? namaSurat;
  String? perihal;
  String? nomorSurat;
  String? tglBuat;
  String? tglSelesai;
  String? pengirim;
  String? status;
  String? kategori;
  String? url;

  SuratModel(
      {
        this.id = 0,
        this.idSurat,
        this.namaSurat,
        this.perihal,
        this.nomorSurat,
        this.tglBuat,
        this.tglSelesai,
        this.pengirim,
        this.status,
        this.kategori,
        this.url,
      });
}
