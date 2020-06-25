//
//  Forgotpasswordvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 07/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
//import CountryPicker
import NVActivityIndicatorView

class Forgotpasswordvc: UIViewController,UITextFieldDelegate {//, CountryPickerDelegate {
//    @IBOutlet weak var countrycodeBtn: UIButton!
//    @IBOutlet weak var flagIv: UIImageView!
//    @IBOutlet weak var countrycodeTfd: UITextField!
    @IBOutlet weak var hintLbl: UILabel!
//    @IBOutlet weak var phonenumberlineVw: UIView!
    @IBOutlet weak var phonenumberTfd: RJKCountryPickerTextField!
//    @IBOutlet weak var CountryCodePicker: CountryPicker!
    @IBOutlet weak var phonenumberLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var activityView: NVActivityIndicatorView!
    var usertoken = ""
    var loginmthd = ""
    
    let helperObject = APIHelper()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Forgot password"
        self.sendBtn.layer.cornerRadius=10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
        loginmthd = "email"

        self.setUpViews()
       
    }
    

    func setUpViews() {
        self.top = self.view.topAnchor
        phonenumberLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["phonenumberLbl"] = phonenumberLbl

        phonenumberTfd.delegate = self
        self.phonenumberTfd.leftViewMode = .never
        self.phonenumberTfd.rightViewMode = .never
        self.phonenumberTfd.autocorrectionType = .no
        self.phonenumberTfd.autocapitalizationType = .none
        self.phonenumberTfd.keyboardType = .emailAddress
        self.phonenumberTfd.autocorrectionType = .no
        self.phonenumberTfd.autocapitalizationType = .none

        phonenumberTfd.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["phonenumberTfd"] = phonenumberTfd

        sendBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["sendBtn"] = sendBtn

        
        hintLbl.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["hintLbl"] = hintLbl

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[phonenumberLbl(30)]-(35)-[phonenumberTfd(30)]-(20)-[hintLbl(20)]-(>=20)-[sendBtn(40)]-(30)-|", options: [], metrics: nil, views: layoutDic))



        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[phonenumberTfd]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[phonenumberLbl]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[sendBtn(120)]", options: [], metrics: nil, views: layoutDic))
        sendBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[hintLbl]-(30)-|", options: [], metrics: nil, views: layoutDic))

        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        
        self.phonenumberLbl.font = UIFont.appTitleFont(ofSize: 20)
//        self.countrycodeTfd.font = UIFont.appFont(ofSize: 14)
        self.phonenumberTfd.font = UIFont.appFont(ofSize: 14)
        self.hintLbl.font = UIFont.appFont(ofSize: 12)
        self.sendBtn.backgroundColor = .themeColor
        self.sendBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.sendBtn.setTitleColor(.secondaryColor, for: .normal)
        self.sendBtn.layer.cornerRadius = self.sendBtn.bounds.height/2
        phonenumberTfd.addBorder(edges: .bottom)
//        helperObject.drawbottomborder(tfd: self.phonenumberTfd)
//        helperObject.drawbottomborder(tfd: self.countrycodeTfd)
    }


    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Hide!")
//        CountryCodePicker.isHidden = true
    }

    @IBAction func countrycodeBtnAction() {
//        self.CountryCodePicker.isHidden=false
    }

    @IBAction func sendBtnAction() {
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
        var errmsg = ""
        if phonenumberTfd.selectedCountry.dialCode == nil {
            errmsg="Please choose your Country Code"
        } else if (self.phonenumberTfd.text?.count==0) {
            errmsg="Please enter your email or Phone Number"
        }
        if errmsg.count>0 {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.alert(message: errmsg, title: "ALERT")
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")
                let paramDict = Dictionary<String, Any>()
                let url = helperObject.BASEURL + helperObject.TokenGeneraterURL
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                    .responseJSON { response in
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)   // result of response serialization
                        //  to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Temp token",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                self.usertoken = JSON.value(forKey: "token") as! String
                                self.getpassword()
                            } else if(theSuccess == false) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                print("Response Fail")
                                self.alert(message: "Response Fail", title: "ALERT")
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

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (textField==self.phonenumberTfd) {
//            if ((textField.text?.count)!>0) {
//                let searchTerm=self.phonenumberTfd.text!
//                let characterset = CharacterSet(charactersIn: "0123456789")
//                if searchTerm.rangeOfCharacter(from: characterset.inverted) != nil {
//                    print("string contains special characters")
//                    self.phonenumberTfd.leftViewMode = .never
//                    self.phonenumberTfd.rightViewMode = .never
//                    loginmthd="email"
//                }
//                else {
//                    if APIHelper.appLanguageDirection == .directionLeftToRight {
//                        self.phonenumberTfd.leftViewMode = .always
//                        self.phonenumberTfd.rightViewMode = .never
//                    } else {
//                        self.phonenumberTfd.rightViewMode = .always
//                        self.phonenumberTfd.leftViewMode = .never
//                    }
//
//
//
////                    self.phonenumberTfd.frame=CGRect(x: 100, y:self.phonenumberTfd.frame.origin.y, width:self.phonenumberTfd.frame.size.width, height:self.phonenumberTfd.frame.size.height)
//                    loginmthd="mobile"
//                }
//            }
//        }
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phonenumberTfd {
            if let text = textField.text as NSString? {
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                if txtAfterUpdate.count==0 {
                    if APIHelper.appTextAlignment == .left {
                        self.phonenumberTfd.leftViewMode = .never
                    } else {
                        self.phonenumberTfd.rightViewMode = .never
                    }
                    
                }
                if txtAfterUpdate.count>0 {
                    let searchTerm = txtAfterUpdate
                    let characterset = CharacterSet(charactersIn: "0123456789")
                    if searchTerm.rangeOfCharacter(from: characterset.inverted) != nil {
                        print("string contains special characters")
                        loginmthd = "email"
                        if APIHelper.appTextAlignment == .left {
                            self.phonenumberTfd.leftViewMode = .never
                        } else {
                            self.phonenumberTfd.rightViewMode = .never
                        }
                    } else {
                        if APIHelper.appTextAlignment == .left {
                            self.phonenumberTfd.leftViewMode = .always
                        } else {
                            self.phonenumberTfd.rightViewMode = .always
                        }
                        loginmthd = "mobile"
                    }
                }
            }
        }
        return true
    }

    func doneButtonAction() {
        self.phonenumberTfd.resignFirstResponder()
//        CountryCodePicker.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
//        CountryCodePicker.isHidden = true
    }

    func getpassword() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["token"]=self.usertoken

            if loginmthd == "mobile" {
                if let dialCode = self.phonenumberTfd.selectedCountry.dialCode {
                    var phNumber = self.phonenumberTfd.text!
                    print(phNumber)
                    while phNumber.starts(with: "0") {
                        phNumber = String(phNumber.dropFirst())
                        print(phNumber)
                    }
                    paramDict["phone_number"] = dialCode + phNumber
                }
            } else {
                paramDict["phone_number"] = self.phonenumberTfd.text!
            }
            let url = helperObject.BASEURL + helperObject.ForgetPasswordURL
            print(paramDict, url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                print(response.response as Any) // URL response
                print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("Response for Forgot Password",JSON)
                    print(JSON.value(forKey: "success") as! Bool)
                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                    if(theSuccess == true) {
                        let JSON = response.result.value as! NSDictionary
                        print(JSON)
                        self.appdel.isfromforgotpassword="YES"
                        self.appdel.emailpnfromforgotpassword=self.phonenumberTfd.text!
//                        let image = self.flagIv.image
//                        let imageData: Data = UIImagePNGRepresentation(image!)!
//                        self.appdel.fpfldata=imageData as NSData
                        self.appdel.fpphonenumber=self.phonenumberTfd.text!
                        self.appdel.fpcountrycode=self.phonenumberTfd.selectedCountry.dialCode
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        self.navigationController?.view.showToast("password sent to you")
                        self.navigationController?.popViewController(animated: true)
                    } else if(theSuccess == false) {
                        print("Response Fail")
                        let JSON = response.result.value as! NSDictionary
                        print(JSON)
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT")
                    }
                }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

//    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage)
//    {
//        print("Coutry Code = ",phoneCode)
//        self.countrycodeTfd.text=phoneCode
//        let image = flag
//        self.flagIv.image = image
//    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // NVActivityIndicatorview

//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: .ballClipRotate, color: .black, padding: 0.0)
//            // add subview
//            view.addSubview(activityView)
//            // autoresizing mask
//            activityView.translatesAutoresizingMaskIntoConstraints = false
//            // constraints
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
