//
//  Initialvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
//import CountryPicker
import NVActivityIndicatorView

class Initialvc: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logoappnameIv: UIImageView!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var phonenumberTfd: RJKCountryPickerTextField!
//    @IBOutlet weak var countrycodeTfd: UITextField!
//    @IBOutlet weak var countrycodeBtn: UIButton!
//    @IBOutlet weak var CountryCodePicker: CountryPicker!
//    @IBOutlet weak var flagIv: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var hintLbl: UILabel!
    @IBOutlet weak var socialmediaBtn: UIButton!

    var activityView: NVActivityIndicatorView!

    var usertoken = ""
    var otptoken = ""
    let appdel = UIApplication.shared.delegate as! AppDelegate
    let helperObject = APIHelper()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tap n Go"//"Tap n Go"
        self.navigationItem.backBtnString = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.setUpViews()
    }
    

    func setUpViews() {

        self.nextBtn.backgroundColor = .themeColor
        self.headerlbl.font = UIFont.appTitleFont(ofSize: 20)
        self.phonenumberTfd.font = UIFont.appFont(ofSize: 14)
        self.hintLbl.font = UIFont.appFont(ofSize: 12)
        self.socialmediaBtn.titleLabel?.font = UIFont.appFont(ofSize: 12)
        self.socialmediaBtn.setTitleColor(.themeColor, for: .normal)
        phonenumberTfd.addBorder(edges: .bottom)

        self.top = self.view.topAnchor

        logoappnameIv.contentMode = .scaleAspectFit
        logoappnameIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["logoappnameIv"] = logoappnameIv
        headerlbl.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["headerlbl"] = headerlbl
        phonenumberTfd.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["phonenumberTfd"] = phonenumberTfd

        nextBtn.imageView?.tintColor = .secondaryColor
        nextBtn.setImage(UIImage(named:"rightarrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextBtn.backgroundColor = .themeColor
        nextBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["nextBtn"] = nextBtn

        hintLbl.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["hintLbl"] = hintLbl
        socialmediaBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["socialmediaBtn"] = socialmediaBtn

        logoappnameIv.widthAnchor.constraint(equalToConstant: 240).isActive = true
        logoappnameIv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        logoappnameIv.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.addConstraint(NSLayoutConstraint.init(item: logoappnameIv, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.6, constant: 0))

        self.view.addConstraint(NSLayoutConstraint.init(item: headerlbl, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.2, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerlbl(30)]-(20)-[phonenumberTfd(40)]-(15)-[socialmediaBtn(20)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[headerlbl]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[phonenumberTfd]-(3)-[nextBtn(35)]-(30)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[hintLbl(85)]-(4)-[socialmediaBtn(70)]", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        socialmediaBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 37).isActive = true

    }


    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Hide!")
//        CountryCodePicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        CountryCodePicker.isHidden = true
    }

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

    @IBAction func nextBtnAction() {
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
//        self.CountryCodePicker.isHidden=true
        var errmsg = ""
//        let imageData: Data = UIImagePNGRepresentation(self.flagIv.image!)!
//         self.appdel.data=imageData as NSData
        if phonenumberTfd.selectedCountry.dialCode == nil {
            errmsg="Please select ur countrycode"
        } else if (self.phonenumberTfd.text?.count==0) {
            errmsg="Please enter the phone number"
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
    }

    func getotp() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            let phonenumber = self.phonenumberTfd.selectedCountry.dialCode!+self.phonenumberTfd.text!
            let token=self.usertoken
            self.appdel.phonenumber=self.phonenumberTfd.text!
            self.appdel.countrycode=self.phonenumberTfd.selectedCountry.dialCode!
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
//                            self.performSegue(withIdentifier: "seguetoverifyOTP", sender: self)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Verificationvc") as! VerificationViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else if(theSuccess == false) {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        let JSON = response.result.value as! NSDictionary
                        print(JSON)
                        print("Response Fail")
                        if JSON.value(forKey: "error_code") as! Int == 702 {
                            self.navigationController?.view.showToast(JSON.value(forKey: "error_message") as! String)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Verificationvc") as! VerificationViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

    @IBAction func ccTfdAction() {
//        self.CountryCodePicker.isHidden=false
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

//    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage)
//    {
//        print("Coutry Code = ",phoneCode)
//        self.appdel.countryabbrcode=countryCode
//        self.countrycodeTfd.text=phoneCode
//        let image = flag
//        self.flagIv.image = image
//    }

    @IBAction func socialloginBtnpresed() {
        self.appdel.fromregtosoc="TRUE"
//        self.performSegue(withIdentifier: "segueinitialtosociallogin", sender: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialmediaViewController") as! SocialmediaViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.phonenumberTfd.inputAccessoryView = doneToolbar
    }

   @objc func doneButtonAction() {
        self.phonenumberTfd.resignFirstResponder()
//        CountryCodePicker.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//class ActivityIndicator: NVActivityIndicatorView {
//    let bgView = UIView()
//    static let sharedInstance = ActivityIndicator(frame: .zero, type: .ballClipRotate, color: .themeColor, padding: 0.0)
//    private override init(frame: CGRect, type: NVActivityIndicatorType?, color: UIColor?, padding: CGFloat?) {
//        super.init(frame: frame, type: type, color: color, padding: padding)
//        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//        if let window = UIApplication.shared.keyWindow {
//            window.addSubview(bgView)
//            window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgView]|", options: [], metrics: nil, views: ["bgView": bgView]))
//            window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgView]|", options: [], metrics: nil, views: ["bgView": bgView]))
//            window.addSubview(self)
//            self.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            self.widthAnchor.constraint(equalToConstant: 100).isActive = true
//            self.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
//            self.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
//        }
//    }
//    override func startAnimating() {
//        super.startAnimating()
//        if let window = UIApplication.shared.keyWindow {
//            bgView.isHidden = false
//            window.isUserInteractionEnabled = false
//        }
//    }
//    override func stopAnimating() {
//        super.stopAnimating()
//        if let window = UIApplication.shared.keyWindow {
//            bgView.isHidden = true
//            window.isUserInteractionEnabled = true
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
