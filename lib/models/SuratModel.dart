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
  String? editor;
  String? status;
  String? kategori;
  String? url;
  int? tipeSurat;
  String? approver;
  String? penerima;
  bool isSelected = false;
  int? isMeterai = 0;
  String? jenisSurat;

  SuratModel(
      {
        this.id = 0,
        this.idSurat,
        this.namaSurat,
        this.perihal,
        this.nomorSurat,
        this.tglBuat,
        this.tglSelesai,
        this.editor,
        this.status,
        this.kategori,
        this.url,
        this.tipeSurat,
        this.approver,
        this.penerima,
        this.isSelected = false,
        this.isMeterai = 0,
        this.jenisSurat,
      });
}
