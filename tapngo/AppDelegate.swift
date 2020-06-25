   //
//  AppDelegate.swift
//  tapngo
//
//  Created by Mohammed Arshad on 03/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import CoreData
import Google
import GoogleMaps
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GooglePlaces
import GoogleSignIn
import NVActivityIndicatorView
import SWRevealViewController
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var activityView: NVActivityIndicatorView!
    var USER_NAME = String()
    var validatestatus = ""
    var errmsg = ""
    var loginuserid = ""
    var loginusertoken = ""
    var loginusername = ""
    var loginuserprofpic = ""
    var otptoken = ""
    var phonenumber = ""
    var countrycode = ""
    var countryabbrcode = ""
    var socialmediatype = ""
    var x = ""

    var fromaddr = ""
    var toaddr = ""
    
    //Forgot password
    var isfromforgotpassword = ""
    var emailpnfromforgotpassword = ""
    var fpemailaddress = ""
    var fpphonenumber = ""
    var fpcountrycode = ""
    var fpflagiv = ""
    var loginmthd = ""
    var fpfldata: NSData? = nil
    var data: NSData? = nil
    var DeviceToken = String()
    var pictureurl = ""

    //Social media
    var fromlogtosoc = ""
    var fromregtosoc = ""
    var googleuserfirstname = ""
    var googleuserlastname = ""
    var googleuserid = ""
    var googleuseremail = ""
    var googleProfilePic = ""
    var facebookuserfirstname = ""
    var facebookuserlastname = ""
    var facebookuserid = ""
    var facebookuseremail = ""
    var facebookuserprofileurl = ""
    var menupicturedata: NSData? = nil

    var defaultcardid = ""
    var phonenumberforsocialreg = ""

    var sosarray=NSArray()

//    var selectedcartypeidd = Double()

//    var selectedcartypeid = ""
    var selectedcartypename = ""

    var pickuplat = Double()
    var pickuplon = Double()

    var droplat = Double()
    var droplon = Double()

    var cancelledrequest = String()

    var billdict: NSMutableDictionary = NSMutableDictionary()
    var driverdict: NSMutableDictionary = NSMutableDictionary()
    var tripdistance = ""
    var triptime = ""

    var requestid=Int()

    var iscompleted = String()
    var istripstarted = String()
    var isdriverstarted = String()
    var isdriverarrived = String()

//    var trippickuploc = String()
//    var trippickuplat = String()
//    var trippickuplon = String()
//    var tripdroploc = String()
//    var tripdroplat = String()
//    var tripdroplon = String()
    var historyrequestid = String()

    var scheduletime = String()
    var scheduledate = String()
    var displaydate = String()
    var tripscheduled = String()
    var tripJSON: NSDictionary = NSDictionary()

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        // set the type as sound or badge
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            // Enable or disable features based on authorization

        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        center.removeAllDeliveredNotifications()

        // status bar text color
//        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true

//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: UIBarMetrics.default)
        //navigation bar color
        
        UINavigationBar.appearance().barTintColor = .themeColor//UIColor(red: 0/255, green: 131/255, blue: 197/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Laksaman", size: 20)!]

        application.registerForRemoteNotifications()

        GIDSignIn.sharedInstance().clientID = "863024895355-51d36f1f74d8s0icj8b6th0ag02h1o7q.apps.googleusercontent.com"

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        GMSServices.provideAPIKey("AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")
        GMSPlacesClient.provideAPIKey("AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")

//        GMSServices.provideAPIKey("AIzaSyCpmkjIlSYKYL-0rtDLSWf4VIOjJgSnG6Q")
//        GMSPlacesClient.provideAPIKey("AIzaSyCpmkjIlSYKYL-0rtDLSWf4VIOjJgSnG6Q")
        

//        self.deletedriver()
//        self.deletetrip()
//        self.deletetripbill()
//        self.deleteinvoiceviewed()

        self.getUsers()
        self.gettripdata()
        self.checkLogin()
        return true
    }

    func deletedriver() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Driverdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    func deletetrip() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tripdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    func deletetripbill() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tripbilldetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    func deleteinvoiceviewed() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoiceviewed")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                            sourceApplication: sourceApplication,
                                                                        annotation: annotation)

        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)

        return googleDidHandle || facebookDidHandle
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //        DeviceToken = deviceTokenString
        print("APNs device token: \(deviceTokenString)")
        DeviceToken = deviceTokenString
    }

    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        print("Notification resp: ", userInfo)
        self.performActions(userInfo)
         UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground: .
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "tapngo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    @available(iOS 9.0, *)
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])

        let googleDidHandle =  GIDSignIn.sharedInstance().handle(url,
                                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return handled || googleDidHandle
    }

    func checkLogin() {
        print("userIdStr is: ",USER_NAME)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "feedbackvc") as! feedbackvc
//        self.window?.rootViewController = vc
//        self.window?.makeKeyAndVisible()
//        return
        if USER_NAME != "" {
            let revealVC = SWRevealViewController()
            revealVC.panGestureRecognizer().isEnabled = false
            let menuVC = storyboard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
            revealVC.rearViewController = menuVC
            revealVC.rightViewController = menuVC

            print(iscompleted)
            print(istripstarted)
            print(isdriverstarted)
            print(isdriverarrived)


            let pickupVC = storyboard.instantiateViewController(withIdentifier: "pickupViewController") as! PickupViewController
            revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
            self.window?.rootViewController = revealVC
            self.window?.makeKeyAndVisible()
        } else {
            let firstvc = storyboard.instantiateViewController(withIdentifier: "firstvc") as! FirstViewController
            let mainViewController = UINavigationController(rootViewController: firstvc)
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }

    }

    func getContext()->NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUsers() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let array_users = try getContext().fetch(fetchRequest)
            print ("num of users = \(array_users.count)")
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
                print("\(String(describing: user.value(forKey: "firstname")))")
                USER_NAME = (String(describing: user.value(forKey: "firstname")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

    func gettripdata() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Tripdetails> = Tripdetails.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
               // billdict = user.v
                //get the Key Value pairs (although there may be a better way to do that...
                iscompleted = (String(describing: user.value(forKey: "tripiscompleted")!))
                istripstarted = (String(describing: user.value(forKey: "tripistripstarted")!))
                isdriverstarted = (String(describing: user.value(forKey: "tripisdriverstarted")!))
                isdriverarrived = (String(describing: user.value(forKey: "tripisdriverarrived")!))

//                tripdroploc = (String(describing: user.value(forKey: "tripisdriverarrived")!))
//                tripdroplat = (String(describing: user.value(forKey: "tripisdriverarrived")!))
//                tripdroplon = (String(describing: user.value(forKey: "tripisdriverarrived")!))
//
//                trippickuploc = (String(describing: user.value(forKey: "tripisdriverarrived")!))
//                trippickuplat = (String(describing: user.value(forKey: "tripisdriverarrived")!))
//                trippickuplon = (String(describing: user.value(forKey: "tripisdriverarrived")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
}

//   extension AppDelegate:LogoutDelegate
//   {
//    func logedOut() {
//        self.checkLogin()
//    }
//   }

   extension AppDelegate:UNUserNotificationCenterDelegate
   {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userdict=notification.request.content.userInfo
        print(userdict)
        self.performActions(userdict)
        completionHandler([.alert,.sound,.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        print("\(response.notification.request.content.userInfo)")

    }


    func performActions(_ userdict: [AnyHashable:Any]) {

        guard let aps = userdict[AnyHashable("aps")] as? [String:AnyObject],
            let apsdata = userdict[AnyHashable("data")] as? [String:AnyObject],
            let title = aps["alert"] as? String else {
                return
        }

        if title == "Trip cancelled by Driver, Please Try Again"
        {
            if let pushcancelleddatadict = apsdata["body"] as? [String:AnyObject] {
                print(pushcancelleddatadict)
                NotificationCenter.default.post(name: Notification.Name("TripCancelledNotification"), object: nil, userInfo: pushcancelleddatadict)
            }
        }
    }

   }
