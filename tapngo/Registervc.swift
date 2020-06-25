//
//  Registervc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
//import CountryPicker
import CoreData
import NVActivityIndicatorView
import Kingfisher

class Registervc: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

//    @IBOutlet weak var pickerview: UIView!
//    @IBOutlet weak var CountryCodePicker: CountryPicker!
//Profile_placeholder
    @IBOutlet weak var halfbgImv: UIImageView!
    @IBOutlet weak var profilepicBtn: UIButton!
    @IBOutlet weak var registrationLbl: UILabel!
    @IBOutlet weak var firstnameTfd: JVFloatLabeledTextField!
    @IBOutlet weak var lastnameTfd: JVFloatLabeledTextField!
    @IBOutlet weak var emailTfd: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTfd: UITextField!
    @IBOutlet weak var phonenumberTfd: RJKCountryPickerTextField!
    let termsBtn = UIButton()
    let termsLbl = UILabel()
    let termsLblBtn = UIButton()
    @IBOutlet weak var signupBtn: UIButton!
    
    let helperObject = APIHelper()

    var activityView: NVActivityIndicatorView!
    var imageselected=""as String

    let appdel=UIApplication.shared.delegate as!AppDelegate

    let picker = UIImagePickerController()

    var layoutDic: [String: AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Register"
//        self.countrycodeTfd.text=self.appdel.countrycode
        self.phonenumberTfd.text=self.appdel.phonenumber
        self.signupBtn.layer.cornerRadius=10

        profilepicBtn.imageView?.contentMode = .scaleToFill
        

        if (self.appdel.socialmediatype=="google") {
            self.firstnameTfd.text=self.appdel.googleuserfirstname
            self.lastnameTfd.text=self.appdel.googleuserlastname
            self.emailTfd.text=self.appdel.googleuseremail
            self.emailTfd.floatingLabel.isHidden=true
            self.firstnameTfd.floatingLabel.isHidden=true
            self.lastnameTfd.floatingLabel.isHidden=true
            self.phonenumberTfd.isUserInteractionEnabled=true
            if self.appdel.googleProfilePic != ""
            {
                let profilePictureURL = URL(string: self.appdel.googleProfilePic)!
                let resource = ImageResource(downloadURL: profilePictureURL)
                self.profilepicBtn.kf.setImage(with: resource, for: .normal)
            }
        } else if self.appdel.socialmediatype == "facebook" {
            self.firstnameTfd.text=self.appdel.facebookuserfirstname
            self.lastnameTfd.text=self.appdel.facebookuserlastname
            self.emailTfd.text=self.appdel.facebookuseremail
            self.emailTfd.floatingLabel.isHidden=true
            self.firstnameTfd.floatingLabel.isHidden=true
            self.lastnameTfd.floatingLabel.isHidden=true
            self.phonenumberTfd.isUserInteractionEnabled=true
            if self.appdel.facebookuserprofileurl.count > 0 {
                let profilePictureURL = URL(string: self.appdel.facebookuserprofileurl)!
                let resource = ImageResource(downloadURL: profilePictureURL)
                self.profilepicBtn.kf.setImage(with: resource, for: .normal)
            }
        }
//        CountryCodePicker.countryPickerDelegate = self
//        CountryCodePicker.showPhoneNumbers = true
        self.addDoneButtonOnKeyboard()
        self.setUpViews()
    }

    func setUpViews() {
        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        halfbgImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["halfbgImv"] = halfbgImv
        profilepicBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profilepicBtn"] = profilepicBtn
        registrationLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["registrationLbl"] = registrationLbl
        firstnameTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["firstnameTfd"] = firstnameTfd
        lastnameTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lastnameTfd"] = lastnameTfd
        emailTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["emailTfd"] = emailTfd
        passwordTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["passwordTfd"] = passwordTfd
        phonenumberTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["phonenumberTfd"] = phonenumberTfd
        signupBtn.setTitleColor(.secondaryColor, for: .normal)
        signupBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["signupBtn"] = signupBtn

        termsBtn.isSelected = false
        termsBtn.setImage(UIImage(named: "unselectbox"), for: .normal)
        termsBtn.setImage(UIImage(named: "selectbox"), for: .selected)
        termsBtn.addTarget(self, action: #selector(termsbtnPressed(_ :)), for: .touchUpInside)
        termsBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["termsBtn"] = termsBtn
        self.view.addSubview(termsBtn)
        
        let stringOne = "Accept Terms and Conditions and Privacy Policy"
        let stringTwo = "Terms and Conditions and Privacy Policy"
        let range = (stringOne as NSString).range(of: stringTwo)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
        termsLbl.attributedText = attributedText
        
       // termsLbl.text = "Accept Terms and Conditions and Privacy Policy"
       // termsLbl.textColor = .blue
        termsLbl.numberOfLines = 0
        termsLbl.lineBreakMode = .byWordWrapping
        termsLbl.font = UIFont.appFont(ofSize: 14)
        termsLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["termsLbl"] = termsLbl
        self.view.addSubview(termsLbl)
        
        termsLblBtn.addTarget(self, action: #selector(termsAndConditionPressed(_ :)), for: .touchUpInside)
        termsLblBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["termsLblBtn"] = termsLblBtn
        self.view.addSubview(termsLblBtn)

        halfbgImv.topAnchor.constraint(equalTo: self.top, constant: 0).isActive = true
        self.halfbgImv.heightAnchor.constraint(equalToConstant: self.view.frame.height / 6.0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[halfbgImv]|", options: [], metrics: nil, views: layoutDic))
        self.profilepicBtn.widthAnchor.constraint(equalToConstant: self.view.frame.height / 7.0).isActive = true
        self.profilepicBtn.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7.0).isActive = true
        self.profilepicBtn.centerXAnchor.constraint(equalTo: halfbgImv.centerXAnchor).isActive = true
        self.profilepicBtn.centerYAnchor.constraint(equalTo: halfbgImv.bottomAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[profilepicBtn]-(15)-[registrationLbl(20)]-(15)-[firstnameTfd(30)]-(15)-[emailTfd]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[phonenumberTfd]-(20)-[termsLbl(50)]-(>=10)-[signupBtn(40)]", options: [], metrics: nil, views: layoutDic))//.alignAllCenterX
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[emailTfd(30)]-(15)-[passwordTfd(30)]-(15)-[phonenumberTfd(30)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[termsBtn(20)]-(10)-[termsLbl]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[registrationLbl(150)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[firstnameTfd]-(8)-[lastnameTfd(==firstnameTfd)]-(16)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[emailTfd]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.signupBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.signupBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        signupBtn.bottomAnchor.constraint(equalTo: self.bottom, constant: -20).isActive = true
        
       termsLblBtn.leadingAnchor.constraint(equalTo: self.termsLbl.leadingAnchor, constant: 0).isActive = true
        termsLblBtn.trailingAnchor.constraint(equalTo: self.termsLbl.trailingAnchor, constant: 0).isActive = true
        termsLblBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        termsLblBtn.centerYAnchor.constraint(equalTo: self.termsLbl.centerYAnchor, constant: 0).isActive = true

        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        self.signupBtn.layer.cornerRadius = signupBtn.bounds.height/2

        self.registrationLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.firstnameTfd.font = UIFont.appFont(ofSize: 14)
        self.lastnameTfd.font = UIFont.appFont(ofSize: 14)
        self.emailTfd.font = UIFont.appFont(ofSize: 14)
        self.passwordTfd.font = UIFont.appFont(ofSize: 14)
        self.phonenumberTfd.font = UIFont.appFont(ofSize: 14)
        self.signupBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.signupBtn.backgroundColor = .themeColor

        self.emailTfd.addBorder(edges: .bottom)
        self.passwordTfd.addBorder(edges: .bottom)
        self.firstnameTfd.addBorder(edges: .bottom)
        self.lastnameTfd.addBorder(edges: .bottom)
        self.phonenumberTfd.addBorder(edges: .bottom)
    }
    
    @objc func termsAndConditionPressed(_ sender: UIButton) {
        let vc = TermsNConditionsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func termsbtnPressed(_ sender: UIButton) {

        if termsBtn.isSelected == false {
            termsBtn.isSelected = true
        }else {
            termsBtn.isSelected = false
        }

    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "ALERT",message: "CAM_NOT_AVAILABLE",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style: .default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func profileImageBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            print("User click Photos button")
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            else {
                self.noCamera()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            print("User click Cancel button")
            //controller.present(self.picker, animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        profilepicBtn.setImage(selectedImage, for: .normal)
        print(selectedImage)
        self.imageselected="YES"
        picker.dismiss(animated: true, completion: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func ccTfdAction() {
//        self.pickerview.isHidden=false
    }


    func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }


    @IBAction func signupBtnAction() {
        if (self.appdel.socialmediatype=="google") {
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var errmsg = ""
            if (self.firstnameTfd.text?.count==0) {
                errmsg="Please enter the First Name"
            }
            else if (self.lastnameTfd.text?.count==0) {
                errmsg="Please enter the Last Name"
            }
            else if (self.emailTfd.text?.count==0) {
                errmsg="Please enter the Email ID"
            }
            else if (self.passwordTfd.text?.count==0) {
                errmsg="Please enter the Password"
            }
            else if termsBtn.isSelected == false {
                errmsg="Accept our terms and conditions to continue"
            }
            if errmsg.count>0 {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                UIApplication.shared.endIgnoringInteractionEvents()
                self.alert(message: errmsg, title: "ALERT")
            }
            else {
                if ConnectionCheck.isConnectedToNetwork() {
                    print("Connected")
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "ZZZZZ"
                   // dateFormat.timeZone = TimeZone.current.identifier
                    let zone = dateFormat.string(from: Date())
                    
                    var paramDict = Dictionary<String, Any>()
                    paramDict["firstname"]=self.firstnameTfd.text!
                    paramDict["lastname"]=self.lastnameTfd.text!
                    paramDict["email"]=self.emailTfd.text!
                    paramDict["phone_number"]=self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
                    let phonenumber = self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
                    appdel.phonenumberforsocialreg=phonenumber
                    paramDict["password"]=self.passwordTfd.text!
                    paramDict["login_method"]="google"
                    paramDict["login_by"]="ios"
                    paramDict["profile_pic"]=""
                    paramDict["device_token"]=appdel.DeviceToken
                    paramDict["social_unique_id"]=self.appdel.googleuserid
                    paramDict["country_code"]=self.phonenumberTfd.selectedCountry.dialCode!

                    paramDict["time_zone"]=TimeZone.current.identifier//"+05:30"
                    paramDict["country"]=self.phonenumberTfd.selectedCountry.isoCode!  //self.appdel.countryabbrcode
                    
                    let URL = try! URLRequest(url: helperObject.BASEURL + helperObject.RegisterURL, method: .post, headers: ["Accept": "application/json", "Content-Language": "en"])
                    
                    print("Paremeters =",paramDict)
                    
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(self.profilepicBtn.imageView!.image!.pngData()!, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                        
                        for (key, value) in paramDict {
                            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                        
                    }, with: URL, encodingCompletion: {
                        encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON
                                { response in
                                    debugPrint("SUCCESS RESPONSE: \(response)")
                                    
                                    let JSON = response.result.value as! NSDictionary
                                    print(JSON)
                                    print("Response for Login",JSON)
                                    print(JSON.value(forKey: "success") as! Bool)
                                    
                                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                    if(theSuccess == true) {
                                        let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                        self.StoreUserDetails(User_Details: userdetails)
                                        let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                        UserDefaults.standard.set(data, forKey: "tableViewData")
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        self.redirect()
                                    }
                                    if(theSuccess == false) {
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        let JSON = response.result.value as! NSDictionary
                                        print("Response Fail")
                                        self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT" )
                                    }
                            }
                        case .failure(let encodingError):
                            // hide progressbas here
                            print("ERROR RESPONSE: \(encodingError)")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.alert(message:  encodingError as! String, title: "ALERT" )
                        }
                    })
                }
                else {
                    print("disConnected")
                    self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
                }
            }
        } else if (self.appdel.socialmediatype=="facebook") {
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var errmsg = ""
            if (self.firstnameTfd.text?.count==0) {
                errmsg="Please enter the First Name"
            }
            else if (self.lastnameTfd.text?.count==0) {
                errmsg="Please enter the Last Name"
            }
            else if (self.emailTfd.text?.count==0) {
                errmsg="Please enter the Email ID"
            }
            else if (self.passwordTfd.text?.count==0) {
                errmsg="Please enter the Password"
            }
            if errmsg.count>0 {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                UIApplication.shared.endIgnoringInteractionEvents()
                self.alert(message: errmsg, title: "ALERT")
            }
            else {
                if ConnectionCheck.isConnectedToNetwork() {
                    print("Connected")
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "ZZZZZ"
                    
                    let zone = dateFormat.string(from: Date())
                    
                    var paramDict = Dictionary<String, Any>()
                    paramDict["firstname"]=self.firstnameTfd.text!
                    paramDict["lastname"]=self.lastnameTfd.text!
                    paramDict["email"]=self.emailTfd.text!
                    paramDict["phone_number"]=self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
                    let phonenumber = self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
                    appdel.phonenumberforsocialreg=phonenumber
                    paramDict["password"]=self.passwordTfd.text!
                    paramDict["login_method"]="facebook"
                    paramDict["login_by"]="ios"
                    paramDict["profile_pic"]=""
                    paramDict["device_token"]=appdel.DeviceToken
                    paramDict["social_unique_id"]=self.appdel.facebookuserid
                    paramDict["country_code"]=self.phonenumberTfd.selectedCountry.dialCode!

                    paramDict["time_zone"]=TimeZone.current.identifier//"+05:30"
                    paramDict["country"]=self.phonenumberTfd.selectedCountry.isoCode
                    let URL = try! URLRequest(url: helperObject.BASEURL + helperObject.RegisterURL, method: .post, headers: ["Accept": "application/json", "Content-Language": "en"])
                    print("Parameters =",paramDict)
                    guard let image = self.profilepicBtn.imageView?.image else {
                        return
                    }
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(image.pngData()!, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                    for (key, value) in paramDict {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    }, with: URL, encodingCompletion: {
                        encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON
                                { response in
                                    debugPrint("SUCCESS RESPONSE: \(response)")
                                    
                                    let JSON = response.result.value as! NSDictionary
                                    print(JSON)
                                    print("Response for Login",JSON)
                                    print(JSON.value(forKey: "success") as! Bool)
                                    
                                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                    if(theSuccess == true) {
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                        let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                        UserDefaults.standard.set(data, forKey: "tableViewData")
                                        self.StoreUserDetails(User_Details: userdetails)
                                        self.redirect()
                                    }
                                    if(theSuccess == false) {
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        let JSON = response.result.value as! NSDictionary
                                        print("Response Fail")
                                        self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT" )
                                    }
                            }
                        case .failure(let encodingError):
                            print("ERROR RESPONSE: \(encodingError)")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.alert(message:  encodingError as! String, title: "ALERT" )
                        }
                    })
                }
                else {
                    print("disConnected")
                    
                    self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
                }
            }
        } else {
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var errmsg = ""
            if (self.firstnameTfd.text?.count==0) {
                errmsg="Please enter the First Name"
            }
            else if (self.lastnameTfd.text?.count==0) {
                errmsg="Please enter the Last Name"
            }
            else if (self.emailTfd.text?.count==0) {
                errmsg="Please enter the Email ID"
            }
            else if (self.passwordTfd.text?.count==0) {
                errmsg="Please enter the Password"
            }
            if errmsg.count>0 {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                UIApplication.shared.endIgnoringInteractionEvents()
                self.alert(message: errmsg, title: "ALERT")
            }
            else {
                if ConnectionCheck.isConnectedToNetwork() {
                    print("Connected")
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "ZZZZZ"
                    
                    let zone = dateFormat.string(from: Date())
                    
                    var paramDict = Dictionary<String, Any>()
                    paramDict["firstname"]=self.firstnameTfd.text!
                    paramDict["lastname"]=self.lastnameTfd.text!
                    paramDict["email"]=self.emailTfd.text!
                    paramDict["phone_number"]=self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
                    paramDict["password"]=self.passwordTfd.text!
                    paramDict["login_method"]="manual"
                    paramDict["login_by"]="ios"
                    paramDict["profile_pic"]=""
                    paramDict["device_token"]=appdel.DeviceToken
                    paramDict["social_unique_id"]=self.appdel.googleuserid
                    paramDict["country_code"]=self.phonenumberTfd.selectedCountry.dialCode!
                    paramDict["time_zone"]=TimeZone.current.identifier//"+05:30"
                    paramDict["country"]=self.phonenumberTfd.selectedCountry.isoCode
                    let URL = try! URLRequest(url: helperObject.BASEURL + helperObject.RegisterURL, method: .post, headers: ["Accept": "application/json", "Content-Language": "en"])
                    print("Paremeters =",paramDict)
                    let myPicture = self.profilepicBtn.imageView!.image
                    let myThumb1 = myPicture?.resized(withPercentage: 0.5)
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(myThumb1!.pngData()!, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                        for (key, value) in paramDict {
                            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                        
                    }, with: URL, encodingCompletion: {
                        encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON
                                { response in
                                    debugPrint("SUCCESS RESPONSE: \(response)")
                                    let JSON = response.result.value as! NSDictionary
                                    print(JSON)
                                    print("Response for Login",JSON)
                                    print(JSON.value(forKey: "success") as! Bool)
                                    
                                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                    if(theSuccess == true) {
                                        let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                        self.StoreUserDetails(User_Details: userdetails)
                                        let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                        UserDefaults.standard.set(data, forKey: "tableViewData")
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        self.appdel.x="1"
                                        UserDefaults.standard.set("", forKey: "Imagesaved")
                                        self.redirect()
                                    }
                                    if(theSuccess == false) {
                                        let JSON = response.result.value as! NSDictionary
                                        print("Response Fail")
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT" )
                                    }
                            }
                        case .failure(let encodingError):
                            // hide progressbas here
                            print("ERROR RESPONSE: \(encodingError)")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.alert(message:  encodingError as! String, title: "ALERT" )
                        }
                    })
                }
                else {
                    print("disConnected")
                    self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
                }
            }
        }
    }

    @available(iOS 10.0, *)
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        pickerview.isHidden = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if(textField==self.firstnameTfd) {
            let maxLength = 15
            let currentString: NSString = self.firstnameTfd.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if( textField==self.lastnameTfd) {
            let maxLength = 15
            let currentString: NSString = self.lastnameTfd.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }

    func StoreUserDetails (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let z : Int = Int((User_Details.value(forKey: "id") as? NSNumber)!)
        let mynewString = String(z)
        print("My New ID",mynewString)

        //set the entity values
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

//    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//        print("Coutry Code = ",phoneCode)
//        self.countrycodeTfd.text=phoneCode
//        self.appdel.countryabbrcode=countryCode
//        let image = flag
//        self.flagIV.image = image
//    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }


    func redirect() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyrefferralVC") as! ApplyrefferralVC
        self.navigationController?.pushViewController(vc, animated: true)
//        self.performSegue(withIdentifier: "seguefromregistertorefferral", sender: self)
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

    func addDoneButtonOnKeyboard() {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        doneToolbar.barStyle = UIBarStyle.blackTranslucent
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(Forgotpasswordvc.doneButtonAction))
//
//        let items = NSMutableArray()
//        items.add(flexSpace)
//        items.add(done)
//
//        doneToolbar.items = items as? [UIBarButtonItem]
//        doneToolbar.sizeToFit()
//
//        self.phonenumberTfd.inputAccessoryView = doneToolbar
    }

    func doneButtonAction() {
        self.phonenumberTfd.resignFirstResponder()
//        pickerview.isHidden = true
    }

}
