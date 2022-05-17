class ContactGroupModel{
  int id;
  int? userId;
  String? email;
  String? userName;
  String? photo;
  String? phone;
  bool select = false;

  ContactGroupModel(
      {
        this.id = 0,
        this.userId,
        this.email,
        this.userName,
        this.photo,
        this.phone,
        this.select = false,
      }
      );
}