//
//  ApplyrefferralVC.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/12/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreData
import SWRevealViewController

class ApplyrefferralVC: UIViewController {
    let helperObject = APIHelper()
    var userTokenstr: String=""
    var userId: String=""
    var activityView: NVActivityIndicatorView!
    let appdel=UIApplication.shared.delegate as!AppDelegate
    @IBOutlet weak var referralcodeTfd: UITextField!
    @IBOutlet weak var referralhintLbl: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUser()
        self.title="Apply referral"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.setUpViews()
    }


    @IBAction func skipBtnAction() {
        self.redirect()
    }

    @IBAction func applyBtnAction() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            if(self.referralcodeTfd.text?.count==0) {
                self.alert(message: "Please enter the referral code to apply.")
            }
            else {
                var paramDict = Dictionary<String, Any>()
                let idstr: String=userId
                let numberFromString = Int(idstr)
                paramDict["id"]=numberFromString
                paramDict["token"]=userTokenstr
                paramDict["referral_code"]=self.referralcodeTfd.text

                let url = helperObject.BASEURL + helperObject.applyreferral
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
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            self.view.showToast(JSON.value(forKey: "success_message") as! String)
                            self.redirect()
                        } else if(theSuccess == false) {
                            print("Response Fail")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.alert(message: JSON.value(forKey: "error_message") as! String)
                        }
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
        if let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuViewController") as? MenuViewController {
            revealVC.rearViewController = menuVC
            revealVC.rightViewController = menuVC
            if let pickupVC = storyboard?.instantiateViewController(withIdentifier: "pickupViewController") as? PickupViewController {
                revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
                self.present(revealVC, animated: true, completion: nil)
            }
        }
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") //as! SWRevealViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//       self.performSegue(withIdentifier: "seguefromrefferraltoHome", sender: self)
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

    func setUpViews() {

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        referralcodeTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodeTfd"] = referralcodeTfd
        referralhintLbl.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["referralhintLbl"] = referralhintLbl
        skipBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["skipBtn"] = skipBtn
        applyBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["applyBtn"] = applyBtn


           referralcodeTfd.topAnchor.constraint(equalTo: self.top, constant: 40).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[referralcodeTfd(30)]-(30)-[referralhintLbl(150)]-(>=10)-[skipBtn(40)]", options: [], metrics: nil, views: layoutDic))
        skipBtn.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[skipBtn][applyBtn(==skipBtn)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[referralcodeTfd]-(20)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[referralhintLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))


        self.referralcodeTfd.font = UIFont.appFont(ofSize: 14)
        self.referralhintLbl.font = UIFont.appFont(ofSize: 14)
        self.skipBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.skipBtn.backgroundColor = .black
        self.applyBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.applyBtn.backgroundColor = .themeColor

        self.referralcodeTfd.addBorder(edges: .bottom)
        
    }

    func stopLoadingIndicator() {
        activityView.stopAnimating()
    }

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let array_users = try getContext1().fetch(fetchRequest)
            print ("num of users = \(array_users.count)")
            print("Users=\(array_users)")
            for user in array_users as [NSManagedObject] {
                userId = (String(describing: user.value(forKey: "id")!))
                userTokenstr = (String(describing: user.value(forKey: "token")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: "TAPNGO", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
