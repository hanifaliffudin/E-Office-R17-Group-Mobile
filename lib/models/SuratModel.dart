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
      });
}
