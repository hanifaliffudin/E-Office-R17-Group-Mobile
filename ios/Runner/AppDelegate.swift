import UIKit
import Flutter
import Firebase

import UserNotifications
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()   // <- Do this
    GeneratedPluginRegistrant.register(with: self) // <- Do this
      
      
      
      
      // [START set_messaging_delegate]
      //Messaging.messaging().delegate = self
      // [END set_messaging_delegate]
      // Register for remote notifications. This shows a permission dialog on first run, to
      // show the dialog at a more appropriate time move this registration accordingly.
      // [START register_for_notifications]
      if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }

      application.registerForRemoteNotifications()

      // [END register_for_notifications]
      
      
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
