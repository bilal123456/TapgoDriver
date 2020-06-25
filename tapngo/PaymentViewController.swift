//
//  paymentvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/11/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreData
import BraintreeDropIn
import Braintree

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cardselectedimagearray = NSMutableArray()
    var cardselectedimagearraydum = NSMutableArray()
    var cardidarray = NSArray()
    var cardnumberarray = NSArray()
    var cardtypearray = NSArray()
    var cardisdefaultarray = NSArray()

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerhintLbl: UILabel!

    @IBOutlet weak var addmoneyImv: UIImageView!
    @IBOutlet weak var addmoneyBtn: UIButton!

    @IBOutlet weak var addcardImv: UIImageView!
    @IBOutlet weak var addcardBtn: UIButton!

    @IBOutlet weak var selectpaymentLbl: UILabel!
    @IBOutlet weak var selectpaymentTbv: UITableView!

    var userTokenstr: String=""
    var defaultcardid: String=""

    var userId: String=""
    var activityView: NVActivityIndicatorView!
    let helperObject = APIHelper()
    let appdel=UIApplication.shared.delegate as!AppDelegate

    var nonceTokenstr: String=""

    var paymentId=""
    var paymentCardType=""
    var paymentEndingStr=""

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment"
        self.navigationItem.backBtnString = ""
        cardselectedimagearray = ["pin_client_org","pin_client_org","pin_client_org", "pin_client_org"]
        cardselectedimagearraydum = ["pin_client_org","pin_client_org","pin_client_org", "pin_client_org"]
        self.getUser()
        self.getcardlistdetails()
        self.setUpViews()
    }

    func setUpViews() {
        self.headerLbl.font = UIFont.appTitleFont(ofSize: 20)
        self.headerhintLbl.font = UIFont.appFont(ofSize: 14)
        self.addmoneyBtn.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.addcardBtn.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.selectpaymentLbl.font = UIFont.appFont(ofSize: 14)

        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        headerhintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerhintLbl"] = headerhintLbl
        addmoneyImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addmoneyImv"] = addmoneyImv
        addmoneyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addmoneyBtn"] = addmoneyBtn
        addcardImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addcardImv"] = addcardImv
        addcardBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addcardBtn"] = addcardBtn
        selectpaymentLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["selectpaymentLbl"] = selectpaymentLbl
        selectpaymentTbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["selectpaymentTbv"] = selectpaymentTbv
        selectpaymentTbv.tableFooterView = UIView()

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {

            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        headerLbl.topAnchor.constraint(equalTo: self.top, constant: 25).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerLbl(30)]-(20)-[headerhintLbl(20)]-(30)-[addmoneyBtn(30)]-(25)-[addcardBtn(30)]-(40)-[selectpaymentLbl(20)]-(30)-[selectpaymentTbv]", options: [], metrics: nil, views: layoutDic))
        selectpaymentTbv.bottomAnchor.constraint(equalTo: self.bottom).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[headerLbl(150)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[headerhintLbl(200)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[addmoneyImv(35)]-(30)-[addmoneyBtn(150)]", options: [.alignAllCenterY], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[addcardImv(35)]-(30)-[addcardBtn(150)]", options: [.alignAllCenterY], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[selectpaymentLbl(200)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[selectpaymentTbv]-(30)-|", options: [], metrics: nil, views: layoutDic))

    }


    //--------------------------------------
    // MARK: - Back button Action
    //--------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        self.performSegue(withIdentifier: "seguefrompaymenttohome", sender: self)
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

    // MARK: - Get nonce token

    func getpaymenttoken() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            let url = helperObject.BASEURL + helperObject.Getnoncetoken
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.nonceTokenstr=(JSON.value(forKey: "client_token") as! String)
                            self.showDropIn()
                        } else {
                            self.view.showToast("Response failed in getting nonce token")
                        }
                }
            }
        }
    }

    @IBAction func addcardBtnAction() {
        self.getpaymenttoken()
    }

    func showDropIn() {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: self.nonceTokenstr, request: request) { (controller, result, error) in
            if (error != nil) {
                print("ERROR",error!)
            }
            else if (result?.isCancelled == true) {
                print("CANCELLED")
            }
            else if let result = result {
                print(result)
                self.paymentId=(result.paymentMethod?.nonce)!
                self.paymentCardType=(result.paymentMethod?.type)!
                self.paymentEndingStr=result.paymentMethod!.localizedDescription
                self.addpaymentcard()
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }

    @IBAction func addmoneyBtnAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "walletvc") as! WalletViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        self.performSegue(withIdentifier: "seguefrompaymenttowallet", sender: self)
    }

    func addpaymentcard() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            UIApplication.shared.beginIgnoringInteractionEvents()
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            paramDict["payment_id"]=self.paymentId
            paramDict["last_number"]=self.paymentEndingStr
            paramDict["card_type"]=self.paymentCardType
            let url = helperObject.BASEURL + helperObject.addpaymentcard
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    if let result = response.result.value {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        let JSON = result as! NSDictionary
                        print(JSON)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.view.showToast((JSON.value(forKey: "success_message") as! String))
                            self.getcardlistdetails()
                        } else {
                            self.view.showToast("Response fail")
                        }
                    }
            }
        }
    }

    // MARK: - Card list

    func getcardlistdetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            UIApplication.shared.beginIgnoringInteractionEvents()
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
                            UIApplication.shared.endIgnoringInteractionEvents()
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            let arr=(JSON.value(forKey: "payment") as! NSArray)
                            if (arr.count>0) {
                                self.cardnumberarray=(arr.value(forKey: "last_number") as! NSArray)
                                self.self.cardidarray=(arr.value(forKey: "card_id") as! NSArray)
                                self.cardtypearray=(arr.value(forKey: "card_type") as! NSArray)
                                self.cardisdefaultarray=(arr.value(forKey: "is_default") as! NSArray)
                                if(self.cardnumberarray.count>0)
                                {
                                    self.selectpaymentTbv.isHidden=false
                                    self.selectpaymentLbl.isHidden=false
                                    self.selectpaymentTbv.reloadData()
                                }
                            } else {
                                self.view.showToast("No cards available")
                                self.selectpaymentTbv.isHidden=true
                                self.selectpaymentLbl.isHidden=true
                            }
                        } else if(theSuccess == false) {
                            UIApplication.shared.endIgnoringInteractionEvents()
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

    // MARK: - Tableview delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardnumberarray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentcell", for: indexPath)as! paymentvcCell
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
            self.selectpaymentTbv.frame=CGRect(x:self.selectpaymentTbv.frame.origin.x, y:self.selectpaymentTbv.frame.origin.y, width:self.selectpaymentTbv.frame.size.width, height:CGFloat(self.cardnumberarray.count*40))
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
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.view.showToast((JSON.value(forKey: "success_message") as! String))
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
                        //  to get JSON return value
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
                                self.view.showToast("Something went wrong. Please try again")
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

    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let i=sender.tag
        if(cardisdefaultarray.object(at: i) as! Bool == true) {
            print("Default card")
            self.alert(message: "Default card cannot be deleted", title: "TapnGo")
        } else {
            print("Not a default card")
            let alertController = UIAlertController(title: "TapnGo", message: "Are you sure you want to delete.", preferredStyle: UIAlertController.Style.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                UIApplication.shared.beginIgnoringInteractionEvents()
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
                                UIApplication.shared.endIgnoringInteractionEvents()
                                let JSON = response.result.value as! NSDictionary
                                print(JSON)
                                self.view.showToast((JSON.value(forKey: "success_message") as! String))
                                let idstr=(self.cardidarray.object(at: i) as! NSInteger)
                                if(self.appdel.defaultcardid==String(idstr))
                                {
                                    self.appdel.defaultcardid=""
                                }
                                self.getcardlistdetails()
                            } else if(theSuccess == false) {
                                UIApplication.shared.endIgnoringInteractionEvents()
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

    // MARK: - Loading indicator

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

    // MARK: - Alertview

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
