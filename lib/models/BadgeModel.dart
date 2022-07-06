import 'package:objectbox/objectbox.dart';

@Entity()
class BadgeModel {
  int id;
  int badgeInbox = 0;
  int badgeNeedSign = 0;
  int badgeNeedApprove = 0;
  int badgeMeterai = 0;

  BadgeModel(
      {
        this.id = 0,
        this.badgeInbox = 0,
        this.badgeNeedSign = 0,
        this.badgeNeedApprove = 0,
        this.badgeMeterai = 0,
      });
}
