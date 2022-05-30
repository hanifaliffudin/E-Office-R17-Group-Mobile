import 'package:objectbox/objectbox.dart';

@Entity()
class NewsModel {
  int id;
  int? idNews;
  int? idUploader;
  String? text;
  String? image;
  String? video;
  String? file;
  String? created_at;
  String? updated_at;
  int count_like = 0;
  bool? status_like = false;
  String? nameUploader;
  String? comments;

  NewsModel(
      {
        this.id = 0,
        this.idNews,
        this.idUploader,
        this.text,
        this.image,
        this.video,
        this.file,
        this.created_at,
        this.updated_at,
        this.count_like = 0,
        this.status_like = false,
        this.nameUploader,
        this.comments,
      });
}
