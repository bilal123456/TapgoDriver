//
//  referralvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/11/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreData

class ReferralViewController: UIViewController {
    var window: UIWindow?
    @IBOutlet weak var headrLbl: UILabel!
    @IBOutlet weak var headerhintLbl: UILabel!
    @IBOutlet weak var earnedreferralamount: UILabel!
    @IBOutlet weak var referralcodeheaderLbl: UILabel!
    @IBOutlet weak var referralcodevw: UIView!
    @IBOutlet weak var referralcodeImw: UIImageView!
    @IBOutlet weak var referralcodeLbl: UILabel!
    @IBOutlet weak var referralcodeshareBtn: UIButton!
    @IBOutlet weak var sharetogetbonLbl: UILabel!

    var userTokenstr: String = ""
    var userId: String = ""
    var activityView: NVActivityIndicatorView!
    let helperObject = APIHelper()
    
    var currency = ""
    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!, bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Referral"
        self.referralcodevw.layer.borderWidth=0.5
        self.getUser()
        self.getreferraldetails()
        self.setUpViews()
    }

    func setUpViews() {
        self.headrLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.headerhintLbl.font = UIFont.appFont(ofSize: 14)
        self.earnedreferralamount.font = UIFont.appFont(ofSize: 32)
        self.earnedreferralamount.textColor = .themeColor
        self.referralcodeheaderLbl.font = UIFont.appFont(ofSize: 14)
        self.referralcodeLbl.font = UIFont.appTitleFont(ofSize: 15)

        self.sharetogetbonLbl.font = UIFont.appFont(ofSize: 14)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        headrLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headrLbl"] = headrLbl
        headerhintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerhintLbl"] = headerhintLbl
        earnedreferralamount.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["earnedreferralamount"] = earnedreferralamount
        referralcodeheaderLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodeheaderLbl"] = referralcodeheaderLbl
        referralcodevw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodevw"] = referralcodevw
        referralcodeImw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodeImw"] = referralcodeImw
        referralcodeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodeLbl"] = referralcodeLbl
        referralcodeshareBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["referralcodeshareBtn"] = referralcodeshareBtn
        sharetogetbonLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sharetogetbonLbl"] = sharetogetbonLbl

        headrLbl.topAnchor.constraint(equalTo: self.top, constant: 25).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headrLbl(30)]-(20)-[headerhintLbl(20)]-(>=20)-[earnedreferralamount(100)]-(>=20)-[referralcodeheaderLbl(20)]-(30)-[referralcodevw(40)]-(20)-[sharetogetbonLbl(20)]-(50)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[headrLbl(200)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[headerhintLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        earnedreferralamount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        earnedreferralamount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        earnedreferralamount.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[referralcodeheaderLbl]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[referralcodevw]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[sharetogetbonLbl]-(30)-|", options: [], metrics: nil, views: layoutDic))
        referralcodevw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[referralcodeImw(30)]-(10)-[referralcodeLbl]-(10)-[referralcodeshareBtn(20)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        referralcodeImw.heightAnchor.constraint(equalToConstant: 20).isActive = true
        referralcodeImw.centerYAnchor.constraint(equalTo: referralcodevw.centerYAnchor)
        //        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "", options: [], metrics: nil, views: layoutDic))
    }

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let users = try getContext1().fetch(fetchRequest)
            print ("num of users = \(users.count)")
            print("Users=\(users)")
            for user in users as [NSManagedObject] {
                userId = (String(describing: user.value(forKey: "id")!))
                userTokenstr = (String(describing: user.value(forKey: "token")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }


    //--------------------------------------
    // MARK: - Back button Action
    //--------------------------------------
    
    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
        //        self.performSegue(withIdentifier: "seguefromreferraltohome", sender: self)
    }

    func getreferraldetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            let url = helperObject.BASEURL + helperObject.GetReferralCodeURL
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Referral Details",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            self.referralcodeLbl.text=(JSON.value(forKey: "code") as! String)
                            self.currency=(JSON.value(forKey: "currency") as? String)!
                            let amt=(JSON.value(forKey: "earned") as! NSNumber)
                            self.earnedreferralamount.text=self.currency + " "+amt.stringValue
                        } else if(theSuccess == false) {
                            print("Response Fail")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Unable to fetch referral Details.")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

    // MARK: - NVActivityIndicatorview

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
//        activityView.startAnimating()
//    }
//
//    func stopLoadingIndicator() {
//        activityView.stopAnimating()
//    }

    // MARK: - Sharing

    @IBAction func shareTextButton(_ sender: Any) {
        let strin="Take a look at TapnGo. Please take a note of your Referral code. The Code is  " + self.referralcodeLbl.text!
        print(strin)
        let activityViewController = UIActivityViewController(activityItems: [strin as Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
