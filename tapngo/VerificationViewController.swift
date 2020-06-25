//
//  Verificationvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
import PinCodeTextField
import NVActivityIndicatorView

class VerificationViewController: UIViewController {

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    @IBOutlet weak var halfbckgrndIv: UIImageView!
    @IBOutlet weak var lockIv: UIImageView!
    @IBOutlet weak var waithintLbl: UILabel!
    @IBOutlet weak var hintLbl: UILabel!
    @IBOutlet weak var editnoBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var otpTfd: PinCodeTextField!
    @IBOutlet weak var verifyotpBtn: UIButton!
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var activityView: NVActivityIndicatorView!
    var usertoken=""
    var otptoken = ""
    let helperObject = APIHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Verification"
        self.otpTfd.text = ""
        self.otpTfd.delegate = self
        if(appdel.socialmediatype == "facebook" || appdel.socialmediatype == "google") {
            self.getTemptoken()
        }
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
        halfbckgrndIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["halfbckgrndIv"] = halfbckgrndIv
        lockIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lockIv"] = lockIv
        waithintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["waithintLbl"] = waithintLbl
        hintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["hintLbl"] = hintLbl
        otpTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["otpTfd"] = otpTfd
        verifyotpBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["verifyotpBtn"] = verifyotpBtn
        editnoBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["editnoBtn"] = editnoBtn
        resendBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["resendBtn"] = resendBtn

        halfbckgrndIv.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[halfbckgrndIv]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[halfbckgrndIv(150)]", options: [], metrics: nil, views: layoutDic))
        lockIv.heightAnchor.constraint(equalToConstant: 120).isActive = true
        lockIv.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lockIv.centerYAnchor.constraint(equalTo: halfbckgrndIv.bottomAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lockIv(120)]-(20)-[waithintLbl(30)]-(5)-[hintLbl(20)]-(10)-[otpTfd(30)]-(30)-[verifyotpBtn(40)]-(>=10)-[editnoBtn(30)]", options: [], metrics: nil, views: layoutDic))
        verifyotpBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        editnoBtn.bottomAnchor.constraint(equalTo: self.bottom, constant: -30).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[editnoBtn(120)]-(>=10)-[resendBtn(120)]-(15)-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        verifyotpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        otpTfd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        otpTfd.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[waithintLbl]-(15)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[hintLbl]-(15)-|", options: [], metrics: nil, views: layoutDic))
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        self.waithintLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.hintLbl.font = UIFont.appFont(ofSize: 14)
        self.otpTfd.font = UIFont.appFont(ofSize: 20)
        self.otpTfd.textColor = .themeColor
        self.verifyotpBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.verifyotpBtn.backgroundColor = .themeColor
        self.verifyotpBtn.setTitleColor(.secondaryColor, for: .normal)
        self.verifyotpBtn.layer.cornerRadius = self.verifyotpBtn.bounds.height/2
        self.editnoBtn.setTitleColor(.secondaryColor, for: .normal)
        self.resendBtn.setTitleColor(.secondaryColor, for: .normal)
    }

    func getTemptoken() {
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
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
                            print("Response for Temptoken",JSON)
                            print(JSON.value(forKey: "success") as! Bool)

                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                self.usertoken = JSON.value(forKey: "token") as! String
                                self.getotp()
                            } else if(theSuccess == false) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
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


    func getotp() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            let phonenumber = appdel.phonenumberforsocialreg
            let token=self.usertoken
            let url = helperObject.BASEURL + helperObject.SendOTPURL
            paramDict["phone_number"]=phonenumber
            paramDict["token"]=token
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in

                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Send OTP",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            if (JSON["user"] != nil) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.alert(message: JSON.value(forKey: "success_message") as! String, title: "ALERT")
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.otptoken = JSON.value(forKey: "token") as! String
                                self.appdel.otptoken=self.otptoken
                                self.performSegue(withIdentifier: "seguetoverifyOTP", sender: self)
                            }
                        } else if(theSuccess == false) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            print("Response Fail")
                            self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT")
                        }
                    }
            }

        } else {
            print("disConnected")

            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
        
    }




    @IBAction func verifyOTPbtnAction() {
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
        UIApplication.shared.beginIgnoringInteractionEvents()
        var errmsg = ""
        if (self.otpTfd.text == "") {
            errmsg="Please enter the OTP which is sent to your Phone Number"
        }
        if errmsg.count>0 {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            UIApplication.shared.endIgnoringInteractionEvents()
            self.alert(message: errmsg, title: "ALERT")
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["token"]=self.appdel.otptoken
                paramDict["otp_key"]=self.otpTfd.text!
                let url = helperObject.BASEURL + helperObject.ValidateOTPURL
                
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)   // result of response serialization
                        //  to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for OTP validate",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                UIApplication.shared.endIgnoringInteractionEvents()
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                if(self.appdel.socialmediatype=="google" || self.appdel.socialmediatype=="facebook")
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyrefferralVC") as! ApplyrefferralVC
                                    self.navigationController?.pushViewController(vc, animated: true)
//                                    self.performSegue(withIdentifier: "seguefromotptoapplyrefferral", sender: self)
                                }
                                else
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Registervc") as! Registervc
                                    self.navigationController?.pushViewController(vc, animated: true)
//                                    self.performSegue(withIdentifier: "seguetoRegister", sender: self)
                                }
                            } else if(theSuccess == false) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                UIApplication.shared.endIgnoringInteractionEvents()
                                print("Response Fail")
                                self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT")
                            }
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.alert(message: "Response Error", title: "ALERT")
                        }
                }
            }
            else {
                print("disConnected")
                
                self.alert(message: "No Internet Connection")
            }
        }
    }

    @IBAction func resendOTPbtnAction() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            UIApplication.shared.beginIgnoringInteractionEvents()
            var paramDict = Dictionary<String, Any>()
            paramDict["token"]=self.appdel.otptoken
            
            let url = helperObject.BASEURL + helperObject.ResendOTPURL
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Resend OTP",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            UIApplication.shared.endIgnoringInteractionEvents()
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                        } else if(theSuccess == false) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            UIApplication.shared.endIgnoringInteractionEvents()
                            print("Response Fail")
                            self.alert(message: JSON.value(forKey: "error_message") as! String, title: "ALERT")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "No Internet Connection")
        }
    }

    @IBAction func editnumberbtnAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension VerificationViewController: PinCodeTextFieldDelegate {
    @nonobjc func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    @nonobjc func textFieldDidBeginEditing(_ textField: PinCodeTextField) {

    }

    func textFieldValueChanged(_ textField: PinCodeTextField) {
        print("value changed: \(textField.text!)")
    }

    @nonobjc func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    @nonobjc func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        print(otpTfd.text!)
        if(otpTfd.text=="") {
            
        }
        return true

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

