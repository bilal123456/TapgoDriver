//
//  SocialmediaViewController.swift
//  tapngo
//
//  Created by Mohammed Arshad on 10/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Alamofire
import GooglePlaces
import GoogleSignIn
import Google
import CoreData
import NVActivityIndicatorView
import SWRevealViewController

class SocialmediaViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var phonenumberBtn: UIButton!
    @IBOutlet weak var phonenumberview: UIView!
    @IBOutlet weak var phonenumberLbl: UILabel!
    @IBOutlet weak var phonenumberTfd: UITextField!
    var socialmediaid = ""
    var fbUserDetails : NSDictionary = NSDictionary()
    let appdel=UIApplication.shared.delegate as!AppDelegate
    @IBOutlet var googleLoginBtn: UIButton!
    @IBOutlet var facebookLoginBtn: UIButton!

    var activityView: NVActivityIndicatorView!
    
    let helperObject = APIHelper()

    var googleUserName = String()
    var googleUserGivenName = String()
    var googleUserEmail = String()
    var googleUserProfile = String()
    var googleUserId = String()
    var googleUserTokenId = String()
    var googleUserFamilyName = String()
    var googleUserProfilePicture=""

    var fbUserFName = String()
    var fbUserLName = String()
    var fbUserEmail = String()
    var fbUserProfile = String()
    var fbUserId = String()
    var fbUserName = String()

    var socialmediaphonenumber=""
    var socialmediacountrycode = ""

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Social Login"
        self.navigationItem.backBtnString = ""
        if self.appdel.fromlogtosoc == "TRUE" {
            self.title = "Social Login"
        } else if self.appdel.fromregtosoc == "TRUE" {
             self.title = "Social Register"
        }
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
       // assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        self.setUpViews()
    }

    func setUpViews() {
        self.top = self.view.topAnchor
        facebookLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["facebookLoginBtn"] = facebookLoginBtn
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["googleLoginBtn"] = googleLoginBtn


        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[facebookLoginBtn(100)]-(>=0)-[googleLoginBtn(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: layoutDic))

        facebookLoginBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        facebookLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.addConstraint(NSLayoutConstraint.init(item: facebookLoginBtn, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.6, constant: 0))

        googleLoginBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        googleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.addConstraint(NSLayoutConstraint.init(item: googleLoginBtn, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.3, constant: 0))
    }

    @IBAction func googleloginBtnTapped(_ sender: Any) {
        print("Google Login Tapped")
       //  NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }

    //PRAGMA MARK: - Google Login

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            googleUserId = user.userID                  // For client-side use only!
            googleUserTokenId = user.authentication.idToken // Safe to send to the server
            googleUserName = user.profile.name
            googleUserGivenName = user.profile.givenName
            googleUserFamilyName = user.profile.familyName
            googleUserEmail = user.profile.email
            print("\(googleUserId)  \(googleUserTokenId) \(googleUserName)  \(googleUserGivenName) \(googleUserFamilyName)  \(googleUserEmail)");
            if user.profile.hasImage {
                let picUrl = user.profile.imageURL(withDimension: 100)
                googleUserProfilePicture = picUrl!.absoluteString
                print(picUrl!)
            }
            self.checkSocialmediaid()
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func checkSocialmediaid() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["social_unique_id"]=googleUserId
            
            let url = helperObject.BASEURL + helperObject.SocialLoginUniqueIDVerificationURL
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            let userDetails=JSON.value(forKey: "user") as! NSDictionary
                            let presentedStatus=userDetails.value(forKey: "is_presented") as! Bool
                            if(presentedStatus==true) {
                                if(self.appdel.fromlogtosoc=="TRUE")
                                {
                                    self.appdel.fromlogtosoc="FALSE"
                                    var paramDict = Dictionary<String, Any>()
                                    paramDict["username"]=""
                                    paramDict["password"]=""
                                    paramDict["device_token"]=self.appdel.DeviceToken
                                    paramDict["login_method"]="google"
                                    paramDict["login_by"]="ios"
                                    paramDict["social_unique_id"]=self.googleUserId
                                    print(paramDict)
                                    let url = self.helperObject.BASEURL + self.helperObject.LoginURL
                                    print(url)
                                    Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                                        .responseJSON
                                        { response in
                                            print(response.response as Any) // URL response
                                            print(response.result.value as AnyObject)   // result of response serialization
                                            //  to get JSON return value
                                            if let result = response.result.value
                                            {
                                                let JSON = result as! NSDictionary
                                                print("Response for Login",JSON)
                                                print(JSON.value(forKey: "success") as! Bool)
                                                
                                                let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                                if(theSuccess == true)
                                                {
                                                    let JSON = response.result.value as! NSDictionary
                                                    print(JSON)
                                                    let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                                    let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                                    UserDefaults.standard.set(data, forKey: "tableViewData")
                                                    self.appdel.loginusername=userdetails.value(forKey: "firstname") as! String
                                                    self.StoreUserDetails(User_Details: userdetails)
                                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                                   //
                                                    self.redirect()
                                                    
                                                }
                                                else if(theSuccess == false)
                                                {
                                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                                    let error_desc=(JSON.value(forKey: "error_message") as! String)
                                                    self.alert(message: error_desc, title: "ALERT")
                                                }
                                            }
                                    }
                                }
                                else
                                {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    self.alert(message: "User Already registered", title: "ALERT")
                                }
                            } else {
                                if(self.appdel.fromregtosoc=="TRUE")
                                {
                                    self.appdel.fromregtosoc="FALSE"
                                    self.appdel.socialmediatype="google"
                                    self.appdel.googleuserid=self.googleUserId
                                    self.appdel.googleuseremail=self.googleUserEmail
                                    self.appdel.googleuserfirstname=self.googleUserGivenName
                                    self.appdel.googleuserlastname=self.googleUserFamilyName
                                    self.appdel.googleProfilePic = self.googleUserProfilePicture
                                    self.appdel.x="1"
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Registervc") as! Registervc
                                    self.navigationController?.pushViewController(vc, animated: true)
//                                    self.performSegue(withIdentifier: "seguefromsocialtoRegister", sender: self)
                                }
                                else
                                {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    self.alert(message: "User not registered. Please register.", title: "ALERT")
                                }
                            }
                        } else if(theSuccess == false) {
                            print("Response Fail")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "No Internet Connection")
        }
    }

    func redirect() {
        let revealVC = SWRevealViewController()
        revealVC.panGestureRecognizer().isEnabled = false
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        revealVC.rearViewController = menuVC
        revealVC.rightViewController = menuVC
        let pickupVC = storyboard?.instantiateViewController(withIdentifier: "pickupViewController") as! PickupViewController
        revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
        self.present(revealVC, animated: true, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")// as! SWRevealViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//        performSegue(withIdentifier: "seguesociallogintoHome", sender: self)
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
        
    func StoreUserDetails (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let z : Int = Int((User_Details.value(forKey: "id") as? NSNumber)!)
        let mynewString = String(z)
        print("My New ID",mynewString)

        let user = Userdetails(context: getContext())
        user.firstname = (User_Details.value(forKey: "firstname") as! String)
        user.id = mynewString
        print("Hello ID",mynewString)
        print("Hello UserToken",User_Details.value(forKey: "token") as! String)
        user.token = (User_Details.value(forKey: "token") as! String)
        user.profilepictureurl = (User_Details.value(forKey: "profile_pic") as! String)
        self.appdel.pictureurl = (User_Details.value(forKey: "profile_pic") as! String)
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
    }

    @IBAction func facebookloginButtonClicked() {
        // NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
        FBSDKLoginManager().logOut()
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile","user_friends"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed: ", err!)
                return
            }
            self.showEmailAddress()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        } else {
            showEmailAddress()
        }
    }

    func showEmailAddress() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, last_name, picture.type(large)"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request: ", error!)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                self.alert(message: "User cancelled the request", title: "ALERT")
                return
            }
            else {
                let data: [String:AnyObject] = result as! [String : AnyObject]
                print(data)
                self.fbUserDetails = result as! NSDictionary
                print(self.fbUserDetails)
                if (self.fbUserDetails["email"] != nil) {
                    self.fbUserEmail = self.fbUserDetails.value(forKey: "email") as! String
                }
                else {
                    self.fbUserEmail=""
                }
                self.fbUserId = self.fbUserDetails.value(forKey: "id") as! String

                if (self.fbUserDetails["name"] != nil) {
                    self.fbUserName = self.fbUserDetails.value(forKey: "name") as! String
                }
                else {
                    self.fbUserName=""
                }
                if (self.fbUserDetails["first_name"] != nil) {
                    self.fbUserFName = self.fbUserDetails.value(forKey: "first_name") as! String
                }
                else {
                    self.fbUserFName=""
                }
                if (self.fbUserDetails["last_name"] != nil) {
                    self.fbUserLName = self.fbUserDetails.value(forKey: "last_name") as! String
                }
                else {
                    self.fbUserLName=""
                }
                self.fbUserProfile = ((self.fbUserDetails.value(forKey: "picture") as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "url") as! String
                print(self.fbUserId)
                print(self.fbUserEmail)
                print(self.fbUserName)
                print(self.fbUserFName)
                print(self.fbUserLName)
                print(self.fbUserProfile)
            }
            print(result!)
            self.fbloginAction()
        }
    }


    func fbloginAction() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["social_unique_id"]=fbUserId
            
            let url = helperObject.BASEURL + helperObject.SocialLoginUniqueIDVerificationURL
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            let userDetails=JSON.value(forKey: "user") as! NSDictionary
                            let presentedStatus=userDetails.value(forKey: "is_presented") as! Bool
                            if(presentedStatus==true) {
                                if(self.appdel.fromlogtosoc=="TRUE")
                                {
                                    self.appdel.fromlogtosoc="FALSE"
                                    var paramDict = Dictionary<String, Any>()
                                    paramDict["username"]=""
                                    paramDict["password"]=""
                                    paramDict["device_token"]=self.appdel.DeviceToken
                                    paramDict["login_method"]="google"
                                    paramDict["login_by"]="ios"
                                    paramDict["social_unique_id"]=self.fbUserId
                                    
                                    print(paramDict)
                                    let url = self.helperObject.BASEURL + self.helperObject.LoginURL
                                    print(url)
                                    Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                                        .responseJSON
                                        { response in
                                            print(response.response as Any) // URL response
                                            print(response.result.value as AnyObject)   // result of response serialization
                                            //  to get JSON return value
                                            if let result = response.result.value
                                            {
                                                let JSON = result as! NSDictionary
                                                print("Response for Login",JSON)
                                                print(JSON.value(forKey: "success") as! Bool)
                                                
                                                let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                                if(theSuccess == true)
                                                {
                                                    let JSON = response.result.value as! NSDictionary
                                                    print(JSON)
                                                    let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                                    print("Data from server: %@", userdetails)

                                                    let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                                    UserDefaults.standard.set(data, forKey: "tableViewData")
                                                    self.appdel.loginusername=userdetails.value(forKey: "firstname") as! String
                                                    self.StoreUserDetails(User_Details: userdetails)
                                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                                    UserDefaults.standard.set("", forKey: "Imagesaved")
                                                    self.redirect()
                                                    
                                                }
                                                else if(theSuccess == false)
                                                {
                                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                                    let error_desc=(JSON.value(forKey: "error_message") as! String)
                                                    self.alert(message: error_desc, title: "ALERT")
                                                }
                                            }
                                    }
                                }
                                else
                                {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    self.alert(message: "User Already registered", title: "ALERT")
                                }
                            } else {
                                if(self.appdel.fromregtosoc=="TRUE")
                                {
                                    self.appdel.fromregtosoc = "FALSE"
                                    self.appdel.socialmediatype = "facebook"
                                    self.appdel.facebookuserid = self.fbUserId
                                    self.appdel.facebookuseremail = self.fbUserEmail
                                    self.appdel.facebookuserfirstname = self.fbUserFName
                                    self.appdel.facebookuserlastname = self.fbUserLName
                                    self.appdel.facebookuserprofileurl = self.fbUserProfile
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Registervc") as! Registervc
                                    self.navigationController?.pushViewController(vc, animated: true)
//                                    self.performSegue(withIdentifier: "seguefromsocialtoRegister", sender: self)
                                }
                                else
                                {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    self.alert(message: "User not registered. Please register.", title: "ALERT")
                                }
                            }
                        } else if(theSuccess == false) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            print("Response Fail")
                        }
                }
            }
        } else {
            print("disConnected")
            self.alert(message: "No Internet Connection")
        }
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // NVActivityIndicatorview

//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//            // add subview
//            view.addSubview(activityView)
//            // autoresizing mask
//            activityView.translatesAutoresizingMaskIntoConstraints = false
//            // constraints
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
//        }
//
//        activityView.startAnimating()
//    }
//
//    func stopLoadingIndicator() {
//        activityView.stopAnimating()
//    }

}
