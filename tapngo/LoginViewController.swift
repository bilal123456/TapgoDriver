//
//  Loginvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
//import CountryPicker
import NVActivityIndicatorView
import SWRevealViewController

class LoginViewController: UIViewController, UITextFieldDelegate {//CountryPickerDelegate,

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var logoappnameImage: UIImageView!
//    @IBOutlet weak var CountryCodePicker: CountryPicker!

    @IBOutlet weak var orloginiwthLbl: UILabel!
    @IBOutlet weak var socialmediaBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotpwdBtn: UIButton!

    @IBOutlet weak var passwordlineVw: UIView!
    @IBOutlet weak var passwordTfd: UITextField!

    @IBOutlet weak var emailTfd: RJKCountryPickerTextField!
    @IBOutlet weak var emaillineVw: UIView!

//    @IBOutlet weak var countrycodeTfd: UITextField!
//    @IBOutlet weak var countrycodeBtn: UIButton!
//    @IBOutlet weak var flagIv: UIImageView!

    let helperObject = APIHelper()
    var xConstraint: NSLayoutConstraint!
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var loginmthd = ""
    var activityView: NVActivityIndicatorView!
    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    var loginBtnWidth: NSLayoutConstraint!
    var loginBtnBottomSpace: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Login"
        self.navigationItem.backBtnString = ""
        self.emailTfd.leftViewMode = .never
        self.emailTfd.keyboardType = .emailAddress
        self.loginBtn.layer.cornerRadius=10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
//        CountryCodePicker.countryPickerDelegate = self
//        CountryCodePicker.showPhoneNumbers = true
        self.setUpViews()
    }

    func setUpViews() {
        self.top = self.view.topAnchor

        logoappnameImage.contentMode = .scaleAspectFit
        logoappnameImage.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["logoappnameImage"] = logoappnameImage
        loginLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["loginLbl"] = loginLbl
        emailTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["emailTfd"] = emailTfd
        passwordTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["passwordTfd"] = passwordTfd
        forgotpwdBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["forgotpwdBtn"] = forgotpwdBtn
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["loginBtn"] = loginBtn
        orloginiwthLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["orloginiwthLbl"] = orloginiwthLbl
        socialmediaBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["socialmediaBtn"] = socialmediaBtn


//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(130)-[logoappnameImage(70)]-(65)-[loginLbl(30)]-(25)-[emailTfd(30)]-(25)-[passwordTfd(30)]-(20)-[forgotpwdBtn(30)]-|", options: [], metrics: nil, views: layoutDic))

//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[loginBtn(40)]-(20)-[orloginiwthLbl(20)]-(15)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logoappnameImage(70)]-(>=10)-[loginLbl(30)]-(25)-[emailTfd(30)]-(25)-[passwordTfd(30)]-(20)-[forgotpwdBtn(30)]-(15)-[loginBtn(40)]-(20)-[socialmediaBtn(20)]-(>=10)-|", options: [], metrics: nil, views: layoutDic))
        logoappnameImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[logoappnameImage(240)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraint(NSLayoutConstraint.init(item: logoappnameImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.5, constant: 0))
        loginLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[loginLbl(120)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[emailTfd]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[passwordTfd]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[passwordTfd]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[forgotpwdBtn(150)]-(30)-|", options: [], metrics: nil, views: layoutDic))
        socialmediaBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 37).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[orloginiwthLbl(70)]-(4)-[socialmediaBtn(70)]", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
//        loginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        loginBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        loginBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        loginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        emailTfd.addBorder(edges: .bottom)
        passwordTfd.addBorder(edges: .bottom)
//        helperObject.drawbottomborder(tfd: self.emailTfd)
//        helperObject.drawbottomborder(tfd: self.passwordTfd)



        self.loginLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.emailTfd.font = UIFont.appFont(ofSize: 14)
//        self.countrycodeTfd.font = UIFont.appFont(ofSize: 14)
        self.passwordTfd.font = UIFont.appFont(ofSize: 14)
        self.forgotpwdBtn.titleLabel?.font = UIFont.appFont(ofSize: 13)
        self.forgotpwdBtn.titleLabel?.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        self.forgotpwdBtn.contentHorizontalAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        self.forgotpwdBtn.setTitleColor(.black, for: .normal)
        self.loginBtn.backgroundColor = .themeColor
        self.loginBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.loginBtn.setTitleColor(.secondaryColor, for: .normal)
        self.loginBtn.layer.cornerRadius = self.loginBtn.bounds.height/2
        self.orloginiwthLbl.font = UIFont.appFont(ofSize: 11)
        self.socialmediaBtn.titleLabel?.font = UIFont.appFont(ofSize: 11)
        self.socialmediaBtn .setTitleColor(.themeColor, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.endIgnoringInteractionEvents()
        if(self.appdel.isfromforgotpassword=="YES") {
            self.emailTfd.leftViewMode = .never
//            self.flagIv.isHidden=false
//            self.countrycodeBtn.isHidden=false
//            self.countrycodeTfd.isHidden=false
//            self.emailTfd.frame=CGRect(x:self.countrycodeBtn.frame.origin.x+self.countrycodeBtn.frame.size.width+5, y:self.emailTfd.frame.origin.y, width:self.emailTfd.frame.size.width, height:self.emailTfd.frame.size.height)
            loginmthd="email"
//            self.countrycodeTfd.text=self.appdel.fpcountrycode
           // self.emailTfd.text=self.appdel.fpphonenumber
//            let data=self.appdel.fpfldata
//            let imagePt = UIImage(data: (data!) as Data)
//            self.flagIv.image=imagePt
//            self.appdel.isfromforgotpassword="NO"
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(LoginViewController.doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.emailTfd.inputAccessoryView = doneToolbar
    }

    func removeDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.emailTfd.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.emailTfd.resignFirstResponder()
    }

    // pragma mark text field delegates

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField==self.passwordTfd) {
//            CountryCodePicker.isHidden = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField==self.emailTfd) {
            if ((textField.text?.count)!>0) {
                let searchTerm=self.emailTfd.text!
                let characterset = CharacterSet(charactersIn: "0123456789")
                if searchTerm.rangeOfCharacter(from: characterset.inverted) != nil {
                    loginmthd="email"
                }
                else {
                    self.emailTfd.leftViewMode = .always
//                    self.flagIv.isHidden=false
//                    self.countrycodeBtn.isHidden=false
//                    self.countrycodeTfd.isHidden=false
//                    self.emailTfd.frame=CGRect(x:self.countrycodeBtn.frame.origin.x+self.countrycodeBtn.frame.size.width+5 , y:self.emailTfd.frame.origin.y, width:self.emailTfd.frame.size.width, height:self.emailTfd.frame.size.height)
                    loginmthd="mobile"
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }

//    func redirectpage(_ segueid : NSString)
//    {
//        performSegue(withIdentifier: segueid as String, sender: self)
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField==self.emailTfd) {
            if let text = textField.text as NSString? {
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                if(txtAfterUpdate.count==0) {
                    self.emailTfd.leftViewMode = .never
//                    self.flagIv.isHidden=true
//                    self.countrycodeBtn.isHidden=true
//                    self.countrycodeTfd.isHidden=true
//                    self.emailTfd.frame=CGRect(x:self.flagIv.frame.origin.x , y:self.emailTfd.frame.origin.y, width:self.emailTfd.frame.size.width, height:self.emailTfd.frame.size.height)
                }
                if(txtAfterUpdate.count>0) {
                    let searchTerm=txtAfterUpdate
                    let characterset = CharacterSet(charactersIn: "0123456789")
                    if searchTerm.rangeOfCharacter(from: characterset.inverted) != nil {
                        print("string contains special characters")
                        loginmthd="email"
                        self.emailTfd.leftViewMode = .never
//                        self.flagIv.isHidden=true
//                        self.countrycodeBtn.isHidden=true
//                        self.countrycodeTfd.isHidden=true
//                        self.emailTfd.frame=CGRect(x:self.flagIv.frame.origin.x , y:self.emailTfd.frame.origin.y, width:self.emailTfd.frame.size.width, height:self.emailTfd.frame.size.height)
                    } else {
                        self.emailTfd.leftViewMode = .always
//                        self.flagIv.isHidden=false
//                        self.countrycodeBtn.isHidden=false
////                        self.countrycodeTfd.isHidden=false
//                        self.emailTfd.frame=CGRect(x:self.countrycodeBtn.frame.origin.x+self.countrycodeBtn.frame.size.width+5 , y:self.emailTfd.frame.origin.y, width:self.emailTfd.frame.size.width, height:self.emailTfd.frame.size.height)
                        loginmthd="mobile"
                    }
                }
            }
        }
        return true
    }

    @IBAction func ccTfdAction() {
//        self.CountryCodePicker.isHidden=false
    }
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Hide!")
//        CountryCodePicker.isHidden = true
    }

    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func loginbtnAction() {
        var errmsg = ""
        let emailstr=self.emailTfd.text
        if(loginmthd=="mobile") {
            if (self.emailTfd.text?.count==0) {
                errmsg="Please enter your Email or phone number"
            }
            else if emailTfd.selectedCountry.dialCode == nil {
                errmsg="Please select your country code"
            }
            else if (self.passwordTfd.text?.count==0) {
                errmsg="Please enter your Password"
            }
        } else if(loginmthd=="email") {
            if (self.emailTfd.text?.count==0) {
                errmsg="Please enter your Email or phone number"
            }
            else if (!self.isValidEmail(testStr: emailstr!)) {
                errmsg="Please enter a valid Email"
            }
            else if (self.passwordTfd.text?.count==0) {
                errmsg="Please enter your Password"
            }
        }
        if errmsg.count>0 {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            UIApplication.shared.endIgnoringInteractionEvents()
            self.alert(message: errmsg, title: "ALERT")
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
              //   NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                if loginmthd == "mobile" {
                    paramDict["username"] = self.emailTfd.selectedCountry.dialCode! + self.emailTfd.text!
                } else {
                    paramDict["username"] = self.emailTfd.text!
                }
                paramDict["password"] = self.passwordTfd.text!
                paramDict["device_token"] = appdel.DeviceToken == "" ? "asdfasndfinisndfsd" : appdel.DeviceToken
                paramDict["login_method"] = "manual"
                paramDict["login_by"] = "ios"
                paramDict["social_unique_id"] = ""
                print(paramDict)
                let url = helperObject.BASEURL + helperObject.LoginURL
                print(url)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        print(response.response as Any)
                        print(response.result.value as AnyObject)
                        //  to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Login",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                UserDefaults.standard.set(data, forKey: "tableViewData")
                                self.appdel.loginusername=userdetails.value(forKey: "firstname") as! String
                                self.StoreUserDetails(User_Details: userdetails)
                                UserDefaults.standard.set("", forKey: "Imagesaved")
                                self.redirect()
                            } else if(theSuccess == false) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                let error_desc=(JSON.value(forKey: "error_message") as! String)
                                self.alert(message: error_desc, title: "ALERT")
                            }
                        }
                }
            }
            else {
                print("disConnected")
                self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
            }
        }
    }

    func SetBackgroundImage() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "Splash")?.draw(in: self.view.bounds)

        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
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
        print(User_Details.value(forKey: "profile_pic") as! String)
        print(User_Details.value(forKey: "profile_pic") as! String)
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

    @IBAction func socialloginBtnpresed() {
        self.appdel.fromlogtosoc="TRUE"
//        self.redirectpage("seguefromlogintosocialmedia")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialmediaViewController") as! SocialmediaViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func redirect() {
        self.appdel.x="1"

        let revealVC = SWRevealViewController()
        revealVC.panGestureRecognizer().isEnabled = false
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        revealVC.rearViewController = menuVC
        revealVC.rightViewController = menuVC
        let pickupVC = storyboard?.instantiateViewController(withIdentifier: "pickupViewController") as! PickupViewController
        revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
        self.present(revealVC, animated: true, completion: nil)


//        performSegue(withIdentifier: "seguelogintoHome", sender: self)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")// as! SWRevealViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func forgotpasswordbtnAction() {
        self.passwordTfd.text = ""
//        performSegue(withIdentifier: "seguelogintoForgotPassword", sender: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Forgotpasswordvc") as! Forgotpasswordvc
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

//    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//        print("Coutry Code = ",phoneCode)
//
////        self.countrycodeTfd.text=phoneCode
//        let image = flag
////        self.flagIv.image = image
//    }

    // NVActivityIndicatorview
//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//            view.addSubview(activityView)
//            activityView.translatesAutoresizingMaskIntoConstraints = false
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
//        }
//        activityView.startAnimating()
//    }
//
//    func stopLoadingIndicator() {
//        activityView.stopAnimating()
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
