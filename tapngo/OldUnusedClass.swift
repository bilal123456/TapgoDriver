////
////  ViewController.swift
////  tapngo
////
////  Created by Mohammed Arshad on 03/10/17.
////  Copyright © 2017 Mohammed Arshad. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//
//class OldUnusedClass: UIViewController, UITextFieldDelegate
//{
//    @IBOutlet weak var passwordtextField: UITextField!
//    @IBOutlet weak var emailtextField: UITextField!
//
//    private var viewmodel=initialViewModel()
//    private var user11=user()
//    let appdel=UIApplication.shared.delegate as!AppDelegate
//    var responsedict = NSDictionary()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title="Tap n Go"
//
//        
//        
//        let myColor = UIColor.lightGray
//
//        self.emailtextField.layer.borderWidth=0.5
//        self.emailtextField.layer.borderColor=myColor.cgColor
//
//        self.passwordtextField.layer.borderWidth=0.5
//        self.passwordtextField.layer.borderColor=myColor.cgColor
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//
//    @IBAction func loginAction(sender:UIButton!) {
//        viewmodel.updateusername(emailaddr: self.emailtextField.text!)
//        viewmodel.updatepassword(passwor: self.passwordtextField.text!)
//        viewmodel.validate()
//        if appdel.validatestatus=="invalid"
//        {
//            let alertController = UIAlertController(title: "Alert", message: appdel.errmsg, preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(OKAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else
//        {
//            self.Login()
//        }
//    }
//
//    func Login() {
//        
//        if ConnectionCheck.isConnectedToNetwork()
//        {
//            print("Connected")
//            let device_token = "9831A4BD4834E9844ED171DA7729AC202D950FABF7C353F910431639AA8C46E4"
//            let device_type = "ios";
//            let emailaddr = "natc@gmail.com";
//            let login_by =  "manual";
//            let password = "1234567890";
//            var paramDict = Dictionary<String, Any>()
//            paramDict["device_token"] = device_token
//            paramDict["device_type"] = device_type
//            paramDict["email"] = emailaddr
//            paramDict["login_by"] = login_by
//            paramDict["password"] = password
//            
//            let url = "http://cliquetaximoz.com/taxi/public/user/login"
//            
//            Alamofire.request(url, method:.post, parameters: paramDict, headers: nil)
//                .responseJSON
//                { response in
//                    
//                    print(response.response as Any) // URL response
//                    print(response.result.value as AnyObject)   // result of response serialization
//                    //  to get JSON return value
//                    if let result = response.result.value
//                    {
//                        let JSON = result as! NSDictionary
//                        print("Response for Login",JSON)
//                        print(JSON.value(forKey: "success") as! Bool)
//                        
//                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
//                        if(theSuccess == true)
//                        {
//                            let JSON = response.result.value as! NSDictionary
//                            print(JSON)
//                            let UserDetails = JSON.value(forKey: "user") as! NSDictionary
//                            print(UserDetails)
//                            self.appdel.loginuserid=UserDetails.value(forKey: "id") as! String
//                            self.appdel.loginusertoken=UserDetails.value(forKey: "token") as! String
//                            self.appdel.loginusername=UserDetails.value(forKey: "first_name") as! String
//                            self.appdel.loginuserprofpic=UserDetails.value(forKey: "picture") as! String
//                            //                        print(UserDetails.value(forKey: "user_name") as! String)
//                            //self.redirect()
//                        }
//                        else if(theSuccess == false)
//                        {
//                            print("Response Fail")
//                        }
//                    }
//            }
//
//        }
//        else
//        {
//            print("disConnected")
//           
//        }
//       
//    }
//
//
////    func redirect()
////    {
////        performSegue(withIdentifier: "segueToLogin", sender: self)
//////        let stb:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//////        let pickupvc=stb.instantiateViewController(withIdentifier: "puvc")
//////        self.navigationController?.pushViewController(pickupvc, animated:true)
////    }
//
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing. {
//        return true
//    }
//
//    public func textFieldDidBeginEditing(_ textField: UITextField) // became first responder {
//
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        let newstring=textField.text! as String
////        if textField==self.emailtextField
////        {
////            viewmodel.updateusername(emailaddr: newstring)
////        }
////        else if textField==self.passwordtextField
////        {
////            viewmodel.updatepassword(passwor: newstring)
////        }
//        return true
//    }
//
////    func textFieldShouldReturn(_ textField: UITextField) -> Bool
////    {
////        // User finished typing (hit return): hide the keyboard.
////        if(textField==self.emailtextField)
////        {
////            passwordtextField .becomeFirstResponder()
////        }
////        else
////        {
////            textField.resignFirstResponder()
////        }
////        return true
////    }
//}
//
