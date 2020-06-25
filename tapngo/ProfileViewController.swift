//
//  profilevc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import NVActivityIndicatorView
import Kingfisher

class ProfileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    let containerView = UIView()

    @IBOutlet weak var profIv: UIImageView!

    @IBOutlet weak var profpicBtn: UIButton!

    @IBOutlet weak var profeditBtn: UIButton!
    @IBOutlet weak var profbasicsetLbl: UILabel!
    @IBOutlet weak var profbasicsetVw: UIView!

    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var firstnameTfd: UITextField!
    @IBOutlet weak var lastnameLbl: UILabel!
    @IBOutlet weak var lastnameTfd: UITextField!

    @IBOutlet weak var profchangepwdLbl: UILabel!
    @IBOutlet weak var profchangepwdVw: UIView!

    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordTfd: UITextField!
    @IBOutlet weak var newpasswordLbl: UILabel!
    @IBOutlet weak var newpasswordTfd: UITextField!
    @IBOutlet weak var confirmpasswordLbl: UILabel!
    @IBOutlet weak var confirmpasswordTfd: UITextField!


    @IBOutlet weak var profcontsetLbl: UILabel!
    @IBOutlet weak var profcontsetVw: UIView!

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTfd: UITextField!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var phoneTfd: UITextField!

    @IBOutlet weak var profupdateBtn: UIButton!

    var usertype : String! = ""

    let appdel=UIApplication.shared.delegate as!AppDelegate

    var window1: UIWindow?
    let helperObject = APIHelper()
    var activityView: NVActivityIndicatorView!
    var currentuserid: String! = ""
    var currentusertoken: String! = ""

    var profilepicktureurl=String()
    var imageselected=""as String
    let picker = UIImagePickerController()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Profile"
//        navigationController?.navigationBar.isHidden = false
        self.initialsetup()
        self.getUser()
        self.profcontsetVw.layer.masksToBounds=true
        self.profbasicsetVw.layer.masksToBounds=true
        self.profchangepwdVw.layer.masksToBounds=true
        self.profcontsetVw.layer.cornerRadius=5
        self.profbasicsetVw.layer.cornerRadius=5
        self.profchangepwdVw.layer.cornerRadius=5
        self.profIv.layer.masksToBounds=true
        self.profupdateBtn.layer.masksToBounds=true
        self.profupdateBtn.layer.cornerRadius=5
        self.profIv.layer.cornerRadius=self.profIv.frame.size.width/2
        self.imageselected="NO"
        self.setUpViews()
        // Do any additional setup after loading the view.
    }

    func setUpViews() {
        profcontsetVw.isHidden = true
        profbasicsetVw.isHidden = true
        profchangepwdVw.isHidden = true
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.addSubview(containerView)
        [profIv,
        profpicBtn,
        profeditBtn,
        profbasicsetLbl,
        profbasicsetVw,
        firstnameLbl,
        firstnameTfd,
        lastnameLbl,
        lastnameTfd,
        profchangepwdLbl,
        profchangepwdVw,
        passwordLbl,
        passwordTfd,
        newpasswordLbl,
        newpasswordTfd,
        confirmpasswordLbl,
        confirmpasswordTfd,
        profcontsetLbl,
        profcontsetVw,
        emailLbl,
        emailTfd,
        phoneLbl,
        phoneTfd,
        profupdateBtn].forEach {
            $0?.removeFromSuperview()
            containerView.addSubview($0!)

        }



        self.profeditBtn.setTitleColor(.themeColor, for: .normal)
        self.profeditBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.profbasicsetLbl.font = UIFont.appTitleFont(ofSize: 15)
        self.firstnameLbl.font = UIFont.appFont(ofSize: 14)
        self.firstnameTfd.font = UIFont.appFont(ofSize: 13)
        self.firstnameTfd.textColor = .themeColor
        self.lastnameLbl.font = UIFont.appFont(ofSize: 14)
        self.lastnameTfd.font = UIFont.appFont(ofSize: 13)
        self.lastnameTfd.textColor = .themeColor
        self.profchangepwdLbl.font = UIFont.appTitleFont(ofSize: 15)
        self.passwordLbl.font = UIFont.appFont(ofSize: 14)
        self.passwordTfd.font = UIFont.appFont(ofSize: 13)
        self.passwordTfd.textColor = .themeColor
        self.newpasswordLbl.font = UIFont.appFont(ofSize: 14)
        self.newpasswordTfd.font = UIFont.appFont(ofSize: 13)
        self.newpasswordTfd.textColor = .themeColor
        self.confirmpasswordLbl.font = UIFont.appFont(ofSize: 14)
        self.confirmpasswordTfd.font = UIFont.appFont(ofSize: 13)
        self.confirmpasswordTfd.textColor = .themeColor
        self.profcontsetLbl.font = UIFont.appTitleFont(ofSize: 15)
        self.emailLbl.font = UIFont.appFont(ofSize: 14)
        self.emailTfd.font = UIFont.appFont(ofSize: 13)
        self.emailTfd.textColor = .themeColor
        self.phoneLbl.font = UIFont.appFont(ofSize: 14)
        self.phoneTfd.font = UIFont.appFont(ofSize: 13)
        self.phoneTfd.textColor = .themeColor
        self.profupdateBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.profupdateBtn.backgroundColor = .themeColor

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {

            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollView"] = scrollView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["containerView"] = containerView
        profIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profIv"] = profIv
        profpicBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profpicBtn"] = profpicBtn
        profeditBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profeditBtn"] = profeditBtn
        profbasicsetLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profbasicsetLbl"] = profbasicsetLbl
        profbasicsetVw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profbasicsetVw"] = profbasicsetVw
        firstnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["firstnameLbl"] = firstnameLbl
        firstnameTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["firstnameTfd"] = firstnameTfd
        lastnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lastnameLbl"] = lastnameLbl
        lastnameTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lastnameTfd"] = lastnameTfd
        profchangepwdLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profchangepwdLbl"] = profchangepwdLbl
        profchangepwdVw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profchangepwdVw"] = profchangepwdVw
        passwordLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["passwordLbl"] = passwordLbl
        passwordTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["passwordTfd"] = passwordTfd
        newpasswordLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["newpasswordLbl"] = newpasswordLbl
        newpasswordTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["newpasswordTfd"] = newpasswordTfd
        confirmpasswordLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["confirmpasswordLbl"] = confirmpasswordLbl
        confirmpasswordTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["confirmpasswordTfd"] = confirmpasswordTfd
        profcontsetLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profcontsetLbl"] = profcontsetLbl
        profcontsetVw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profcontsetVw"] = profcontsetVw
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["emailLbl"] = emailLbl
        emailTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["emailTfd"] = emailTfd
        phoneLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["phoneLbl"] = phoneLbl
        phoneTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["phoneTfd"] = phoneTfd
        profupdateBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profupdateBtn"] = profupdateBtn

        scrollView.topAnchor.constraint(equalTo: self.top, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottom, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: layoutDic))

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        containerHgt.priority = UILayoutPriority(rawValue: 250)
        containerHgt.isActive = true

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[profpicBtn(100)]-(10)-[profeditBtn(30)]-(10)-[profbasicsetLbl(20)]-(15)-[firstnameLbl(50)]-(1)-[lastnameLbl(50)]-(10)-[profchangepwdLbl(20)]-(10)-[passwordLbl(50)]-(1)-[newpasswordLbl(50)]-(1)-[confirmpasswordLbl(50)]-(10)-[profcontsetLbl(20)]-(10)-[emailLbl(50)]-(1)-[phoneLbl(50)]-(20)-[profupdateBtn(30)]-(20)-|", options: [], metrics: nil, views: layoutDic))
        profIv.topAnchor.constraint(equalTo: profpicBtn.topAnchor).isActive = true
        profIv.widthAnchor.constraint(equalTo: profpicBtn.heightAnchor).isActive = true
        profIv.heightAnchor.constraint(equalTo: profpicBtn.heightAnchor).isActive = true
        profIv.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profpicBtn.widthAnchor.constraint(equalTo: profpicBtn.heightAnchor).isActive = true
        profpicBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[profeditBtn(70)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profbasicsetLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[firstnameLbl(125)]-(1)-[firstnameTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[lastnameLbl(125)]-(1)-[lastnameTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profchangepwdLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[passwordLbl(125)]-(1)-[passwordTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[newpasswordLbl(125)]-(1)-[newpasswordTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[confirmpasswordLbl(125)]-(1)-[confirmpasswordTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profcontsetLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[emailLbl(125)]-(1)-[emailTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[phoneLbl(125)]-(1)-[phoneTfd]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        profupdateBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profupdateBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true


        [firstnameLbl,lastnameLbl,passwordLbl,newpasswordLbl,confirmpasswordLbl,emailLbl,phoneLbl].forEach { $0?.textAlignment = APIHelper.appTextAlignment
            $0?.backgroundColor = .white
        }
        [firstnameTfd,lastnameTfd,passwordTfd,newpasswordTfd,confirmpasswordTfd,emailTfd,phoneTfd].forEach { $0?.textAlignment = APIHelper.appTextAlignment
            $0?.backgroundColor = .white
        }

        //self.profupdateBtn.setTitleColor(.themeColor, for: .normal)


//        self.top = self.view.topAnchor
//
//        profIv.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["profIv"] = profIv
    }

    func initialsetup() {
        //self.profeditBtn.setTitleColor(UIColor.blue, for: .normal)
        self.firstnameTfd.isUserInteractionEnabled=false
        self.lastnameTfd.isUserInteractionEnabled=false
        self.passwordTfd.isUserInteractionEnabled=false
        self.newpasswordTfd.isUserInteractionEnabled=false
        self.confirmpasswordTfd.isUserInteractionEnabled=false
        self.emailTfd.isUserInteractionEnabled=false
        self.phoneTfd.isUserInteractionEnabled=false
        self.profpicBtn.isUserInteractionEnabled=false
        self.profupdateBtn.isHidden=true
        self.scrollView.contentSize=CGSize(width : self.view.frame.size.width, height : self.profcontsetVw.frame.origin.y+self.profcontsetVw.frame.size.height+50)

        passwordTfd.placeholder = "**********"
        newpasswordTfd.placeholder = "**********"
        confirmpasswordTfd.placeholder = "**********"


        let outData = UserDefaults.standard.data(forKey: "tableViewData")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!)
        
        let profiledatadict : NSDictionary = dict as! NSDictionary
        print(profiledatadict)
        self.firstnameTfd.text=profiledatadict.value(forKey: "firstname") as? String
        self.lastnameTfd.text=profiledatadict.value(forKey: "lastname") as? String
        self.emailTfd.text=profiledatadict.value(forKey: "email") as? String
        self.phoneTfd.text=profiledatadict.value(forKey: "phone") as? String
        self.profilepicktureurl=(profiledatadict.value(forKey: "profile_pic") as? String)!
        usertype=(profiledatadict.value(forKey: "login_method") as? String)!
        self.setprofilepict()
    }

    
    //--------------------------------------
    // MARK: - Fetch User data
    //--------------------------------------

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            print("Users=\(array_users)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(String(describing: user.value(forKey: "firstname")))")
                let USER_NAME = (String(describing: user.value(forKey: "firstname")!))
                print(USER_NAME)
                currentuserid = (String(describing: user.value(forKey: "id")!))
                currentusertoken = (String(describing: user.value(forKey: "token")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }


    //--------------------------------------
    // MARK: - Alertview
    //--------------------------------------

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }


    //--------------------------------------
    // MARK: - NVActivityIndicatorview
    //--------------------------------------

//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//            // add subview
//            self.view.bringSubview(toFront: activityView)
//            self.view.addSubview(activityView)
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

    //--------------------------------------
    // MARK: - Back button Action
    //--------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        self.performSegue(withIdentifier: "seguefromprofiletohome", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setprofilepict() {
        if(profilepicktureurl.count>0) {
            self.profIv.contentMode = .scaleToFill
            self.profIv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: URL(string:profilepicktureurl)!)
            self.profIv.kf.setImage(with: resource)
//            downloadImageFrome(link: profilepicktureurl, contentMode: UIViewContentMode.scaleToFill)
//            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//            indicator.center = self.profIv.center
//            self.scrollView.addSubview(indicator)
//            self.scrollView.bringSubview(toFront: indicator)
//            indicator.startAnimating()
//
//            let profilePictureURL = URL(string: profilepicktureurl)!
//            let session = URLSession(configuration: .default)
//            let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
//                // The download has finished.
//                if let e = error
//                {
//                    print("Error downloading cat picture: \(e)")
//                }
//                else
//                {
//                    // No errors found.
//                    // It would be weird if we didn't have a response, so check for that too.
//                    if let res = response as? HTTPURLResponse
//                    {
//                        print("Downloaded cat picture with response code \(res.statusCode)")
//                        if let imageData = data
//                        {
//                            //DispatchQueue.global(qos: .background).async
//                            DispatchQueue.main.sync
//                            {
//                                    indicator.stopAnimating()
//                                    let image = UIImage(data: imageData)
//                                    self.profIv.image=image
//                            }
//                        }
//                        else
//                        {
//                            indicator.stopAnimating()
//                            self.alert(message: "Couldn't get image: Image is nil")
//                        }
//                    }
//                    else
//                    {
//                        indicator.stopAnimating()
//                        self.alert(message: "Couldn't get response code for some reason")
//                    }
//                }
//            }
//            downloadPicTask.resume()
        } else {
            self.profIv.image=UIImage(named: "Profile_placeholder")
        }
    }

    @IBAction func editbtnAction() {
        self.profeditBtn.isEnabled=false
        self.profeditBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.firstnameTfd.isUserInteractionEnabled=true
        self.lastnameTfd.isUserInteractionEnabled=true
        self.firstnameTfd.becomeFirstResponder()
        self.passwordTfd.isUserInteractionEnabled=true
        self.newpasswordTfd.isUserInteractionEnabled=true
        self.confirmpasswordTfd.isUserInteractionEnabled=true

//        if(usertype=="facebook" || usertype=="google")
//        {
//            self.passwordTfd.isUserInteractionEnabled=false
//            self.newpasswordTfd.isUserInteractionEnabled=false
//            self.confirmpasswordTfd.isUserInteractionEnabled=false
//        }
//        else
//        {
//            self.passwordTfd.isUserInteractionEnabled=true
//            self.newpasswordTfd.isUserInteractionEnabled=true
//            self.confirmpasswordTfd.isUserInteractionEnabled=true
//        }
        
        self.profpicBtn.isUserInteractionEnabled=true
        self.profupdateBtn.isHidden=false
        self.scrollView.contentSize=CGSize(width : self.view.frame.size.width, height : self.profupdateBtn.frame.origin.y+self.profupdateBtn.frame.size.height+50)
    }

    @IBAction func updatebtnAction() {
        var errmsg = ""
        if(self.firstnameTfd.text?.count==0) {
            errmsg="Please enter your firstname."
        } else if (self.lastnameTfd.text?.count==0) {
            errmsg="Please enter your lastname."
        } else if ((self.passwordTfd.text?.count)!>0) {
            if((self.passwordTfd.text?.count)!<8) {
                errmsg="Password must be 8 characters long"
            }
            else if(self.newpasswordTfd.text?.count==0) {
                errmsg="Please Enter your new password."
            }
            else if((self.newpasswordTfd.text?.count)!<8) {
                errmsg="New Password must be 8 characters long"
            }
            else if(self.confirmpasswordTfd.text?.count==0) {
                errmsg="Please Enter your confirm password."
            }
            else if((self.confirmpasswordTfd.text?.count)!<8) {
                errmsg="Confirm Password must be 8 characters long"
            }
            else if(!(self.confirmpasswordTfd.text == self.newpasswordTfd.text)) {
                errmsg="New password and Confirm password does not match"
            }
        } else if ((self.newpasswordTfd.text?.count)!>0) {
            if((self.newpasswordTfd.text?.count)!<8) {
                errmsg="New Password must be 8 characters long"
            }
            else if(self.passwordTfd.text?.count==0) {
                errmsg="Please Enter your password."
            }
            else if((self.passwordTfd.text?.count)!<8) {
                errmsg="Password must be 8 characters long"
            }
            else if(self.confirmpasswordTfd.text?.count==0) {
                errmsg="Please Enter your confirm password."
            }
            else if((self.confirmpasswordTfd.text?.count)!<8) {
                errmsg="Confirm Password must be 8 characters long"
            }
        } else if ((self.confirmpasswordTfd.text?.count)!>0) {
            if((self.confirmpasswordTfd.text?.count)!<8) {
                errmsg="Password must be 8 characters long"
            }
            else if(self.passwordTfd.text?.count==0) {
                errmsg="Please Enter your password."
            }
            else if((self.passwordTfd.text?.count)!<8) {
                errmsg="Password must be 8 characters long"
            }
            else if(self.newpasswordTfd.text?.count==0) {
                errmsg="Please Enter your new password."
            }
            else if((self.newpasswordTfd.text?.count)!<8) {
                errmsg="New Password must be 8 characters long"
            }
        }
        if(errmsg.count>0) {
            self.alert(message: errmsg)
        } else {
            self.updateprofileapicall()
        }
    }

    func updateprofileapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            if(self.imageselected=="YES") {
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                paramDict["firstname"]=self.firstnameTfd.text
                paramDict["lastname"]=self.lastnameTfd.text
                if((passwordTfd.text?.count)!>0) {
                    paramDict["new_password"]=self.newpasswordTfd.text
                    paramDict["old_password"]=self.passwordTfd.text
                }
                let URL = try! URLRequest(url: helperObject.BASEURL + helperObject.updateprofile, method: .post, headers: ["Accept": "application/json", "Content-Language": "en"])

                print("Paremeters =",paramDict)

                let myPicture = self.profIv.image
                var myThumb1 = myPicture?.resized(withPercentage: 0.5)
                let imgdata=myThumb1!.pngData()
                print([imgdata?.count])
                var myThumb2=UIImage()
                if((imgdata?.count)!>1999999) {
                    myThumb2 = (myThumb1?.resized(withPercentage: 0.5))!
                    let imgdata1=myThumb2.pngData()
                    print([imgdata1?.count])
                    myThumb1=myThumb2
                }
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(myThumb1!.pngData()!, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")

                for (key, value) in paramDict {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }

                }, with: URL, encodingCompletion:{
                        encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON
                                { response in
                                    debugPrint("SUCCESS RESPONSE: \(response)")
                                    let JSON = response.result.value as! NSDictionary
                                    print(JSON)
                                    print("Response for Update profile",JSON)
                                    print(JSON.value(forKey: "success") as! Bool)

                                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                                    if(theSuccess == true) {
                                        self.profeditBtn.isEnabled=true
                                        self.profeditBtn.setTitleColor(UIColor.orange, for: .normal)
                                        let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                        let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                        UserDefaults.standard.set(data, forKey: "tableViewData")
                                        self.view.showToast(JSON.value(forKey: "success_message") as! String)
                                        self.initialsetup()
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                    }
                                    if(theSuccess == false) {
                                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                        let JSON = response.result.value as! NSDictionary
                                        print("Response Fail")
                                        self.view.showToast(JSON.value(forKey: "error_message") as! String)
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
                     NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                    print("Connected")
                    var paramDict = Dictionary<String, Any>()
                    paramDict["id"]=currentuserid
                    paramDict["token"]=currentusertoken
                    paramDict["firstname"]=self.firstnameTfd.text
                    paramDict["lastname"]=self.lastnameTfd.text
                    if((passwordTfd.text?.count)!>0) {
                        paramDict["new_password"]=self.newpasswordTfd.text
                        paramDict["old_password"]=self.passwordTfd.text
                    }
                    print(paramDict)
                    let url = helperObject.BASEURL + helperObject.updateprofile
                    print(url)
                    Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for update Profile",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                self.profeditBtn.isEnabled=true
                                self.profeditBtn.setTitleColor(UIColor.orange, for: .normal)
                                let userdetails=JSON.value(forKey: "user") as! NSDictionary
                                let data = NSKeyedArchiver.archivedData(withRootObject: userdetails)
                                UserDefaults.standard.set(data, forKey: "tableViewData")
                                self.view.showToast(JSON.value(forKey: "success_message") as! String)
                            self.initialsetup()
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print("Response Fail")
                            self.view.showToast(JSON.value(forKey: "error_message") as! String)
                        }
                    }
                }
            }
        } else {
            self.alert(message: "Internet not connected")
        }
    }

    func noCamera() {
        let alertVC = UIAlertController(
            title: "ALERT",
            message: "CAM_NOT_AVAILABLE",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
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
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        profIv.image = selectedImage
        print(selectedImage)
        self.imageselected="YES"
        picker.dismiss(animated: true, completion: nil)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func StoreUserDetails (User_Details: NSDictionary) {
        let context = getContext()
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

        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
            return true
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if(textField==self.firstnameTfd) {
            let maxLength = 15
            let currentString: NSString = firstnameTfd.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if( textField==self.lastnameTfd) {
            let maxLength = 15
            let currentString: NSString = lastnameTfd.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


