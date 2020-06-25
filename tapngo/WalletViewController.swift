//
//  walletvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/11/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreData

class WalletViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var cardselectedimagearray = NSMutableArray()
    var cardselectedimagearraydum = NSMutableArray()
    var cardidarray = NSArray()
    var cardnumberarray = NSArray()
    var cardtypearray = NSArray()
    var cardisdefaultarray = NSArray()

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerhintLbl: UILabel!
    @IBOutlet weak var walletamtLbl: UILabel!
    @IBOutlet weak var plusamtLbl: UILabel!
    @IBOutlet weak var moneyTfd: UITextField!

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!

    @IBOutlet weak var addamtbtn: UIButton!
    @IBOutlet weak var selectpaymentcardlbl: UILabel!
    @IBOutlet weak var cardlisttbv: UITableView!

    let helperObject = APIHelper()
    
    var userTokenstr: String=""
    var userId: String=""
    var amounttoadd: String=""
    var activityView: NVActivityIndicatorView!
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var defaultcardid: String=""
    var currency = ""

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Wallet"
        self.getUser()
        self.getwalletAmt()
        self.getcardlistdetails()
        self.addamtbtn.layer.cornerRadius=5
        cardselectedimagearray=["pin_client_org","pin_client_org","pin_client_org"]
        cardselectedimagearraydum=["pin_client_org","pin_client_org","pin_client_org"]
        self.setUpViews()
    }

    func setUpViews() {
        self.headerLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.headerhintLbl.font = UIFont.appFont(ofSize: 14)
        self.walletamtLbl.font = UIFont.appFont(ofSize: 20)
        self.walletamtLbl.textColor = .themeColor
        self.plusamtLbl.font = UIFont.appFont(ofSize: 25)
        self.moneyTfd.font = UIFont.appTitleFont(ofSize: 15)

        self.btn1.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.btn2.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.btn3.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.btn4.titleLabel?.font = UIFont.appFont(ofSize: 14)

        self.selectpaymentcardlbl.font = UIFont.appFont(ofSize: 14)

        self.moneyTfd.addBorder(edges: .bottom)

        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        headerhintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerhintLbl"] = headerhintLbl
        walletamtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletamtLbl"] = walletamtLbl
        plusamtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["plusamtLbl"] = plusamtLbl
        moneyTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["moneyTfd"] = moneyTfd
        btn1.layer.borderWidth = 1.0
        btn1.layer.borderColor = UIColor.themeColor.cgColor
        btn1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn1"] = btn1
        btn2.layer.borderWidth = 0.0
        btn2.layer.borderColor = UIColor.themeColor.cgColor
        btn2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn2"] = btn2
        btn3.layer.borderWidth = 0.0
        btn3.layer.borderColor = UIColor.themeColor.cgColor
        btn3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn3"] = btn3
        btn4.layer.borderWidth = 0.0
        btn4.layer.borderColor = UIColor.themeColor.cgColor
        btn4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn4"] = btn4
        addamtbtn.titleLabel?.font = UIFont.appFont(ofSize: 14)
        addamtbtn.backgroundColor = .themeColor
        addamtbtn.setTitleColor(.secondaryColor, for: .normal)
        addamtbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addamtbtn"] = addamtbtn
        selectpaymentcardlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["selectpaymentcardlbl"] = selectpaymentcardlbl
        cardlisttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardlisttbv"] = cardlisttbv
        cardlisttbv.tableFooterView = UIView()

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {

            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }

        headerLbl.topAnchor.constraint(equalTo: self.top, constant: 25).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerLbl(30)]-(20)-[headerhintLbl(20)]-(30)-[walletamtLbl(30)]-(30)-[btn1(30)]-(30)-[addamtbtn(30)]-(30)-[selectpaymentcardlbl(20)]-(15)-[cardlisttbv]", options: [], metrics: nil, views: layoutDic))
        cardlisttbv.bottomAnchor.constraint(equalTo: self.bottom).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[headerLbl(150)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[headerhintLbl]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[walletamtLbl(110)]-(10)-[plusamtLbl(20)]-(10)-[moneyTfd(110)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        plusamtLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btn1(40)]-(20)-[btn2(40)]-(20)-[btn3(40)]-(20)-[btn4(40)]", options: [.alignAllCenterY], metrics: nil, views: layoutDic))
        self.view.addConstraint(NSLayoutConstraint.init(item: btn2, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: -30))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[addamtbtn(60)]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[selectpaymentcardlbl(200)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[cardlisttbv]-(30)-|", options: [], metrics: nil, views: layoutDic))




//        self.addamtbtn.setTitleColor(.themeColor, for: .normal)


//        self.top = self.view.topAnchor
//        headerLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["headerLbl"] = headerLbl
    }


    //--------------------------------------
    // MARK: - Back button Action
    //--------------------------------------
    
    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        popToRootViewController(animated: true)
//         self.performSegue(withIdentifier: "seguefromwallettohome", sender: self)
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

    @IBAction func ohBtnAction() -> Void {
        btn1.layer.borderWidth = 1.0
        [btn2,btn3,btn4].forEach { $0?.layer.borderWidth = 0.0 }
        self.moneyTfd.text=self.currency + " 5"
        amounttoadd="5"
    }

    @IBAction func twBtnAction() -> Void {
        btn2.layer.borderWidth = 1.0
        [btn1,btn3,btn4].forEach { $0?.layer.borderWidth = 0.0 }
        self.moneyTfd.text=self.currency + " 10"
        amounttoadd="10"
    }

    @IBAction func fhBtnAction() -> Void {
        btn3.layer.borderWidth = 1.0
        [btn1,btn2,btn4].forEach { $0?.layer.borderWidth = 0.0 }
        self.moneyTfd.text=self.currency + " 20"
        amounttoadd="20"
    }

    @IBAction func thBtnAction() -> Void {
        btn4.layer.borderWidth = 1.0
        [btn1,btn2,btn3].forEach { $0?.layer.borderWidth = 0.0 }
        self.moneyTfd.text=self.currency + " 30"
        amounttoadd="30"
    }

    // MARK: - Get Wallet Amount

    func getwalletAmt() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            let url = helperObject.BASEURL + helperObject.getwalletAmount
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        if let JSON = result as? NSDictionary {
                            if let theSuccess = (JSON.value(forKey: "success") as? Bool) {
                        if(theSuccess == true) {
                            if let currency = JSON.value(forKey: "currency") as? String {
                                self.currency = currency
                            }
                            if let i=(JSON.value(forKey: "amount_balance") as? Double) {
                                let amtstring=String(format:"%.2f", i)
                                print(amtstring)
                            self.walletamtLbl.text=self.currency + " " + amtstring
                            }
                        } else {
                            self.view.showToast("Error in getting wallet amount.")
                        }
                        }
                        }
                    }
            }
        } else {
            self.alert(message: "No Internet. Please check your internet connection.")
        }
    }

    // MARK: - Tableview delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardnumberarray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentcardcell", for: indexPath)as! paymentvcCell
        cell.cardnumbeLbl.font = UIFont.appFont(ofSize: 18)
        cell.cardnumbeLbl.text=(cardnumberarray.object(at: indexPath.row) as! String)

            let defaultval=(cardisdefaultarray.object(at: indexPath.row)as! Bool)
            if( defaultval == true) {
                let img=UIImage(named: "selectedtickicon")
                cell.cardSelectionBtn .setImage(img, for: .normal)
                cell.cardImv.image=UIImage(named: "addcardicon")
                let def=(cardidarray.object(at: indexPath.row) as! NSInteger)
                appdel.defaultcardid=String(def)
            }
            else {
                let img=UIImage(named: "Unselectedtickicon")
                cell.cardSelectionBtn .setImage(img, for: .normal)
                cell.cardImv.image=UIImage(named: "unselectedcardicon")
            }
        cell.deleteBtn.tag=indexPath.row
        if(cardnumberarray.count<4) {
            self.cardlisttbv.frame=CGRect(x:self.cardlisttbv.frame.origin.x, y:self.cardlisttbv.frame.origin.y, width:self.cardlisttbv.frame.size.width, height:CGFloat(self.cardnumberarray.count*40))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let def=(cardidarray.object(at: indexPath.row) as! NSInteger)
        defaultcardid=String(def)
        appdel.defaultcardid=String(def)
        self.makecarddefaultapicall()
    }

    func makecarddefaultapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            paramDict["card_id"]=defaultcardid
            let url = helperObject.BASEURL + helperObject.Makecarddefault
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.view.showToast(JSON.value(forKey: "success_message") as! String)
                            self.getcardlistdetails()
                        } else {
                            self.view.showToast("Someting went wrong")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                var paramDict = Dictionary<String, Any>()
                let idstr: String=userId
                let numberFromString = Int(idstr)
                paramDict["id"]=numberFromString
                paramDict["token"]=userTokenstr
                paramDict["card_id"]=cardidarray.object(at: indexPath.row)
                let url = helperObject.BASEURL + helperObject.deletepaymentcard
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)   // result of response serialization
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Login",JSON)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                self.view.showToast("Card deleted successfully")
                                let idstr=(self.cardidarray.object(at: indexPath.row) as! NSInteger)
                                if(self.appdel.defaultcardid==String(idstr))
                                {
                                    self.appdel.defaultcardid=""
                                }
                                self.getcardlistdetails()
                            } else if(theSuccess == false) {
                                print("Response Fail")
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast("Something went wrong. Please try again.")
                            }
                        }
                }
            }
            else {
                print("disConnected")

                self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
            }
        } else if editingStyle == .insert {
            
        }
    }

    @IBAction func addmoneyBtnAction() -> Void {
        UIApplication.shared.beginIgnoringInteractionEvents()
        if(self.moneyTfd.text?.count==0) {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.alert(message: "Please enter an Amount")
        } else if(self.cardlisttbv.isHidden==true) {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.alert(message: "Please add a card")
        } else if(self.appdel.defaultcardid=="") {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.alert(message: "Please select a card")
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")

                let amtstr=self.moneyTfd.text! as NSString
                if(amtstr.contains(self.currency)) {
                    let fullNameArr : [String] = amtstr.components(separatedBy: " ")
                    amounttoadd=fullNameArr[1]
                }
                else {
                    amounttoadd=self.moneyTfd.text! as String
                }
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                var paramDict = Dictionary<String, Any>()
                let idstr: String=userId
                let numberFromString = Int(idstr)
                paramDict["id"]=numberFromString
                paramDict["token"]=userTokenstr
                paramDict["card_id"]=appdel.defaultcardid
                paramDict["amount"]=amounttoadd

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.AddMoneyToWalletURL
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
                            UIApplication.shared.endIgnoringInteractionEvents()
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            self.view.showToast("Amount added Successfully.")
                            self.moneyTfd.text = ""
                            self.getwalletAmt()
                        } else if(theSuccess == false) {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Response Fail.")
                        }
                    }
                }
            }
            else {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.alert(message: "No Internet Connection")
            }
        }
    }

//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//            view.addSubview(activityView)
//            activityView.translatesAutoresizingMaskIntoConstraints = false
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

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: "TAPNGO", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func getcardlistdetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            let url = helperObject.BASEURL + helperObject.Getcardlist
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            let arr=(JSON.value(forKey: "payment") as! NSArray)
                            if (arr.count>0) {
                                self.cardnumberarray=(arr.value(forKey: "last_number") as! NSArray)
                                self.self.cardidarray=(arr.value(forKey: "card_id") as! NSArray)
                                self.cardtypearray=(arr.value(forKey: "card_type") as! NSArray)
                                self.cardisdefaultarray=(arr.value(forKey: "is_default") as! NSArray)
                                for arr1 in arr
                                {
                                    let theSuccess1 = (arr1 as AnyObject).value(forKey: "is_default") as! Bool
                                    if(theSuccess1 == true) {
                                        let g = ((arr1 as AnyObject).value(forKey: "card_id") as! NSNumber)
                                        self.appdel.defaultcardid=String(describing: g)
                                    }
                                }
                                if(self.cardnumberarray.count>0)
                                {
                                    self.cardlisttbv.isHidden=false
                                    self.cardlisttbv.reloadData()
                                    self.selectpaymentcardlbl.isHidden=false
                                }
                            } else {
                                self.view.showToast("No cards available")
                                self.appdel.defaultcardid=""
                                self.cardlisttbv.isHidden=true
                                self.selectpaymentcardlbl.isHidden=true
                            }
                        } else if(theSuccess == false) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Response Fail")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let i=sender.tag
        if(cardisdefaultarray.object(at: i) as! Bool == true) {
            print("Default card")
            self.alert(message: "Default card cannot be deleted", title: "TapnGo")
        } else {
            let alertController = UIAlertController(title: "TapnGo", message: "Are you sure you want to delete.", preferredStyle: UIAlertController.Style.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
                if ConnectionCheck.isConnectedToNetwork() {
                    print("Connected")
                     NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                    var paramDict = Dictionary<String, Any>()
                    let idstr: String=self.userId
                    let numberFromString = Int(idstr)
                    paramDict["id"]=numberFromString
                    paramDict["token"]=self.userTokenstr
                    paramDict["card_id"]=self.cardidarray.object(at: i)
                    let url = self.helperObject.BASEURL + self.helperObject.deletepaymentcard
                    Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                        .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)   // result of response serialization
                        //  to get JSON return value
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Login",JSON)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                self.view.showToast(JSON.value(forKey: "success_message") as! String)
                                let idstr=(self.cardidarray.object(at: i) as! NSInteger)
                                if(self.appdel.defaultcardid==String(idstr))
                                {
                                    self.appdel.defaultcardid=""
                                }
                                self.getcardlistdetails()
                            } else if(theSuccess == false) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast("Response Fail")
                            }
                        }
                    }
                }
                else {
                    print("disConnected")
                    self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                print("Cancel")
                alertController .dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString: NSString = moneyTfd.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


