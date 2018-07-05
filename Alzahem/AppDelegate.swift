//
//  AppDelegate.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import Firebase
import UserNotifications


/// Global Realm instance shared by the whole app (see `RealmFunctions`).
let uiRealm = try! Realm()

/// Application entry point. Responsible for bootstrapping third-party SDKs
/// (Firebase, push notifications, IQKeyboardManager), applying global UIKit
/// appearance, seeding default `UserDefaults` values, choosing the root view
/// controller based on the onboarding flag, and pre-fetching remote config /
/// home-slider data.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Root navigation controller (retained for programmatic navigation).
    public var mainRootNav: UINavigationController?
    /// Convenience handle to the main storyboard.
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var window: UIWindow?
    var entries : NSDictionary!
    /// Cached home-screen product slider payload.
    var obj:NSArray = []
    /// Key used to read the message id out of an FCM push payload.
    let gcmMessageIDKey = "gcm.message_id"

    
    override init()
    {
        super.init()
        // Register for push and configure Firebase as early as possible.
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
//        Database.database().isPersistenceEnabled = false
    }
    
    
    public func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Apply the saved localization (swaps the main bundle) and enable the
        // keyboard-avoidance helper globally.
        Localizer.DoTheExchange()
        IQKeyboardManager.shared.enable = true
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.gray]
        UINavigationBar.appearance().tintColor = UIColor.gray
  
        //GEDinarOne-Light
        //Lato-Regular
        
        //let shadow = NSShadow()
        var font : UIFont = MyTools.tools.appFontEn(size: 18)
        if Language.currentLanguage().contains("ar") {
          font  = MyTools.tools.appFontAr(size: 18)
        }
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: font]

        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor =  MyTools.tools.colorWithHexString("2B9BBF")

        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        
        if ((UserDefaults.standard.value(forKey: "CurrencyId")) == nil)
        {
            UserDefaults.standard.set(1, forKey: "CurrencyId")
        }
      
        if ((UserDefaults.standard.value(forKey: "CurrencyName")) == nil)
        {
            UserDefaults.standard.set("KWD", forKey: "CurrencyName")
        }
        
        
         // Choose the initial screen: returning users (the "isFirst" flag is
         // already set) go straight to the main tab bar, first-time users see
         // the onboarding/auth flow.
         if ((UserDefaults.standard.value(forKey: "isFirst")) != nil)
         {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "rootNavigationViewController") as? rootNavigationViewController
            if let window = self.window
            {
                window.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }
         }
         else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewController(withIdentifier: "rootNav") as? UINavigationController
            if let window = self.window {
                window.rootViewController = rootController
            }
        }

        
        
        
        self.SetupConfig()
        self.loadData()
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //self.loadData()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    func setupView()
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TTabBarViewController") as? TTabBarViewController
            if let window = self.window
            {
                window.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewController(withIdentifier: "rootNav") as? UINavigationController
            if let window = self.window {
                window.rootViewController = rootController
                //self.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    /// Pre-fetches the home screen so the product slider is cached in
    /// `UserDefaults` before the user reaches it.
    func loadData()
    {
        self.obj = []
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetHome()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status  = JSON["status"] as! String
                            if(status == "success")
                            {
                                
                                let product_slider = JSON["product_slider"] as! NSArray
                                self.obj = product_slider
                                let ns = UserDefaults.standard
                                ns.setValue(self.obj, forKey: "slider")
                                ns.synchronize()
                            }
                            else
                            {
                            }
                        }
                    }
                    else
                    {
                       
                    }
            }
        }
        else
        {
        }
    }
    
    /// Fetches remote key/value config and mirrors every entry into
    /// `UserDefaults` so screens can read settings synchronously.
    func SetupConfig()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                            for (key,value) in JSON {
                                print("\(key) = \(value)")
                                let val = value as? String ?? ""
                                let ns = UserDefaults.standard
                                ns.setValue(val, forKey: key as! String)
                                ns.synchronize()
                        }
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        }
        else
        {
            
        }
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        //clicked
        let state = UIApplication.shared.applicationState
        if state == .active {
            if let aps = userInfo["aps"] as? [String:Any] {
                
            }
        }
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    
    
    /// Hands the APNs token to Firebase and caches the resulting FCM token in
    /// `UserDefaults` under "deviceToken" for later registration with the API.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
        
        if InstanceID.instanceID().token() != nil
        {
            let fcmToken = InstanceID.instanceID().token() as! String
            UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
            print(fcmToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //        Messaging.messaging().subscribe(toTopic: "/topics/testTopic")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
    {
        
    }
}


