//
//  menuViewController.swift
//  tapngo
//
//  Created by Mohammed Arshad on 05/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import NVActivityIndicatorView
import CoreData
import Kingfisher

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var window: UIWindow?
    var menuNameArray:Array = [String]()
    var menuImgArray:Array = [String]()
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var userId: String=""
    var profilepicktureurl=String()

    let helperObject = APIHelper()

    var imageDownloaded = UIImage()
    var imageDownloadeddata: NSData? = nil

    var activityView: NVActivityIndicatorView!
    

    var userTokenstr: String=""
    @IBOutlet weak var sidemenutopview: UIView!

    @IBOutlet weak var menulistTableview: UITableView!
    @IBOutlet weak var profilepictureiv: UIImageView!
    @IBOutlet weak var profileusernamelbl: UILabel!

    @IBOutlet weak var profileemaillbl: UILabel!
    //func getUserDetails()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!


    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArray = ["Profile".localize(), "Home".localize(), "Payment".localize(), "Wallet".localize(), "Referral".localize(), "Complaints".localize(), "SOS".localize(), "Settings".localize(), "History".localize(), "Logout".localize()]
        menuImgArray=["sidemenuprofile", "sidemenuhome", "sidemenupayment", "sidemenuwallet", "sidemenureferral", "sidemenucomplaints", "sidemenusos", "sidemenusettings", "sidemenuhistory", "sidemenulogout"]

        menulistTableview.reloadData()
        menulistTableview.tableFooterView = UIView()
        self.getUser()
        self.getuser1()
        self.setprofilepict()
        print(self.appdel.pictureurl)
        self.profilepictureiv.layer.masksToBounds=true
        self.profilepictureiv.layer.cornerRadius=self.profilepictureiv.layer.frame.width/2
        self.menulistTableview.separatorStyle=UITableViewCell.SeparatorStyle.none
        self.setUpViews()
        // Do any additional setup after loading the view.
    }

    func viewDidAppear(animated: Bool) {
        //getUserDetails()
//        UITableView_Auto_Height();
    }

    func setUpViews() {
        self.profileusernamelbl.font = UIFont.appFont(ofSize: 20)
        self.profileemaillbl.font = UIFont.appFont(ofSize: 16)
        self.sidemenutopview.backgroundColor = .themeColor
        self.view.backgroundColor = .themeColor

//            .themeColor
//        self.profileusernamelbl.textColor = .themeColor
//        self.profileemaillbl.textColor = .themeColor

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }

        sidemenutopview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sidemenutopview"] = sidemenutopview
        menulistTableview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["menulistTableview"] = menulistTableview
        profilepictureiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profilepictureiv"] = profilepictureiv
        profileusernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profileusernamelbl"] = profileusernamelbl
        profileemaillbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profileemaillbl"] = profileemaillbl

        sidemenutopview.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[sidemenutopview(190)][menulistTableview]|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sidemenutopview]|", options: [], metrics: nil, views: layoutDic))
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profilepictureiv(70)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profileusernamelbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profileemaillbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        profileusernamelbl.widthAnchor.constraint(equalToConstant: self.revealViewController().rearViewRevealWidth-40).isActive = true
        profileemaillbl.widthAnchor.constraint(equalToConstant: self.revealViewController().rearViewRevealWidth-40).isActive = true
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[profilepictureiv(70)]-(10)-[profileusernamelbl(30)]-(10)-[profileemaillbl(30)]-(10)-|", options: [], metrics: nil, views: layoutDic))

    }
    
    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getuser1() {
        guard let outData = UserDefaults.standard.data(forKey: "tableViewData") else{
            return
        }
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData)

        if let userdict: NSDictionary=dict as? NSDictionary {
        profilepicktureurl=userdict.value(forKey: "profile_pic") as! String
        let fn=userdict.value(forKey: "firstname") as? String
        let ln=userdict.value(forKey: "lastname") as? String
        let name = fn! + " " + ln!
        self.profileusernamelbl.text=name
        self.profileemaillbl.text = userdict.value(forKey: "email") as? String
        }
    }

    func getUser() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let array_users = try getContext1().fetch(fetchRequest)
            for user in array_users as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
//                print("\(String(describing: user.value(forKey: "firstname")))")
//                let USER_NAME = (String(describing: user.value(forKey: "firstname")!))
                userId = (String(describing: user.value(forKey: "id")!))
                userTokenstr = (String(describing: user.value(forKey: "token")!))
                //print(String(describing: user.value(forKey: "profilepictureurl")!))
                //profilepicktureurl = (String(describing: user.value(forKey: "profilepictureurl")!))
//                self.profileusernamelbl.text = USER_NAME
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

//    func UITableView_Auto_Height()
//    {
//        if(self.menulistTableview.contentSize.height < self.menulistTableview.frame.height){
//            var frame: CGRect = self.menulistTableview.frame;
//            frame.size.height = self.menulistTableview.contentSize.height;
//            self.menulistTableview.frame = frame;
//        }
//    }

    func setprofilepict() {
        if let url = URL(string:profilepicktureurl) {
            let resource = ImageResource(downloadURL: url)
            self.profilepictureiv.kf.indicatorType = .activity
            self.profilepictureiv.kf.setImage(with: resource)
        } else {
            self.profilepictureiv.image=UIImage(named: "Profile_placeholder")
        }
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func StoreUserDetails (imgData: NSData) {
        let context = getContext()
        let user = Profilepicture(context: getContext())
        //changing
      //  user.imageData = imgData
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    func deleteUser() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Userdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
                //                  self.appDelegate.checkLogin()
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
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
//
//        activityView.startAnimating()
//    }
//
//    func stopLoadingIndicator() {
//        activityView.stopAnimating()
//    }

    // MARK: - Tableview delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath)as! menuTableViewCell
        tableView.backgroundColor = cell.backgroundColor
        cell.selectionStyle = .none
        cell.lblname.font = UIFont.appFont(ofSize: 16)
        cell.gradientlineimg.backgroundColor = .themeColor
        cell.lblname.text! = menuNameArray[indexPath.row]
        cell.img.image = UIImage(named: menuImgArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.revealViewController().revealToggle(animated: true)
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "profilevc") as! ProfileViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetoprofile", sender: self)

        }
        if indexPath.row==1 {
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//            self.window?.rootViewController = mainViewController
//            self.window?.makeKeyAndVisible()
        }
        if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "paymentvc") as! PaymentViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetopayments", sender: self)
        }
        if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "walletvc") as! WalletViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetowallet", sender: self)
        }
        if indexPath.row == 4 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "referralvc") as! ReferralViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetoreferral", sender: self)
        }
        if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "complaintsvc") as! complaintsvc
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetocomplaints", sender: self)
        }
        if indexPath.row == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "sosvc") as! SOSViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetosos", sender: self)
        }
        if indexPath.row == 7 {
            let vc = Settingsvc()
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetosettings", sender: self)
        }
        if indexPath.row == 8 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "historyvc") as! HistoryViewController
            (self.revealViewController().frontViewController as! UINavigationController).pushViewController(vc, animated: true)
//            self.performSegue(withIdentifier: "seguetohistory", sender: self)
        }
        if indexPath.row==9 {
            let dialogMessage = UIAlertController(title: "Tapngo", message: "Are you sure you want to logout", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

                self.logoutapicall()
                })

            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    func logoutapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            let url = helperObject.BASEURL + helperObject.LogoutURL
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
                            self.deleteUser()
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let firstvc = self.storyboard?.instantiateViewController(withIdentifier: "firstvc") as! FirstViewController
                            let mainViewController = UINavigationController(rootViewController: firstvc)
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainViewController = storyboard.instantiateViewController(withIdentifier: "InitialNavID") as! UINavigationController
                            self.window?.rootViewController = mainViewController
                            self.window?.makeKeyAndVisible()
                        } else if(theSuccess == false) {
                            let errcodestr=(JSON.value(forKey: "error_code") as! String)
//                            print(def)
//                            let errcodestr=String(def)
                            if(errcodestr=="609" || errcodestr=="606") {
                                self.deleteUser()
                                self.window = UIWindow(frame: UIScreen.main.bounds)
                                let firstvc = self.storyboard?.instantiateViewController(withIdentifier: "firstvc") as! FirstViewController
                                let mainViewController = UINavigationController(rootViewController: firstvc)
                                self.window?.rootViewController = mainViewController
                                self.window?.makeKeyAndVisible()
                            } else {
                                print("Response Fail")
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.alert(message: "Response Fail")
                            }
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }
}



