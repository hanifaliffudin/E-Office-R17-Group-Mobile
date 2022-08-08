abstract class BaseConfigUtil {
  String get eOfficeUrl;
  String get apiChatUrl;
  String get wssChatUrl;
  String get wssOpenKey;
  String get apiKeyCore;
  String get apiKeyEoffice;
}

class DevConfigUtil implements BaseConfigUtil {
  @override
  String get eOfficeUrl => 'https://eoffice.digiprimatera.co.id';
  @override
  String get apiChatUrl => 'https://chat.dev.r17.co.id';
  @override
  String get wssChatUrl => 'wss://chat.dev.r17.co.id:443/wss';
  // String get wssChatUrl => 'ws://192.168.100.101:3000';
  @override
  String get wssOpenKey => '2K0LJBnj7BK17sdlH65jh58B33Ky1V2bY5Tcr09Ex8e76wZ54eRc4dF1H2G7vG570J9H8465GJzz';
  @override
  String get apiKeyCore => '1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3Pzz';
  @override
  String get apiKeyEoffice => '1w1r23DWe3afiu823fsd723jFHiukjw3872uGWhi2gf2f8y2IWE7fH73s98uJF23iofnEge35IE3iuh2hufniEfwwueHU23fewEFufiuh52fsdF3aeAas82zz';
}

class ProdConfigUtil implements BaseConfigUtil {
  @override
  String get eOfficeUrl => 'https://eoffice.digiprimatera.co.id';
  @override
  String get apiChatUrl => 'https://chat.digiprimatera.co.id';
  @override
  String get wssChatUrl => 'wss://chat.digiprimatera.co.id:443/wss';
  @override
  String get wssOpenKey => '2K0LJBnj7BK17sdlH65jh58B33Ky1V2bY5Tcr09Ex8e76wZ54eRc4dF1H2G7vG570J9H8465GJzzzz';
  @override
  String get apiKeyCore => '1Hw3G9UYOhounou0679y3*OhouH978%hOtfr57fRtug#9UI8nl7iU4Yt5vR6Fb87tLRB5u3g4Hi92983huiU3g5bkH5BVGv3daf2F5e2Ae4k6F5vblUwIJD9W7ryiuBL24Lbv3Pzzzz';
  @override
  String get apiKeyEoffice => '1w1r23DWe3afiu823fsd723jFHiukjw3872uGWhi2gf2f8y2IWE7fH73s98uJF23iofnEge35IE3iuh2hufniEfwwueHU23fewEFufiuh52fsdF3aeAas82zzzz';
}