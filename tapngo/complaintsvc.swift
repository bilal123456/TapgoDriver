//
//  complaintsvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 29/12/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import NVActivityIndicatorView

class complaintsvc: UIViewController, UITextViewDelegate {


    let helperObject = APIHelper()
    var complaintlistarray = NSArray()
    var complaintlistnamearray = NSMutableArray()
    var complaintlistidarray = NSMutableArray()
    var activityView: NVActivityIndicatorView!

    @IBOutlet weak var halfbgiv: UIImageView!
    @IBOutlet weak var formbtn: UIButton!
//    @IBOutlet weak var complaintlisttfd: UITextField!
//    @IBOutlet weak var complaintview: UIView!
//    @IBOutlet weak var complaintlistdownarrowiv: UIImageView!
//    @IBOutlet weak var complaintlistdownarrowbtn: UIButton!
//    @IBOutlet weak var complaintlistTbv: UITableView!
    @IBOutlet weak var complainttxtvw: UITextView!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var commentslbl: UILabel!
    @IBOutlet weak var complaintsavebtn: UIButton!

    var userTokenstr: String=""
    var userId: String=""
    var selcomplaintid = Int()
    var latstr: String! = ""
    var lngstr: String! = ""
    var adminkey: String! = ""

    var selectedComplaintType:Option!
    let complaintTypeBtn = UIButton(type: .custom)
    let complaintsPopUpView = PopUpTableView()
    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        latstr = UserDefaults.standard.value(forKey: "firstlat") as! String
        lngstr = UserDefaults.standard.value(forKey: "firstlong") as! String
        self.getUser()
        self.getcomplaintlist()
        self.title="Complaints"
        self.complainttxtvw.layer.borderWidth=0.5
        self.complainttxtvw.layer.cornerRadius=5
//        self.complaintview.layer.borderWidth=0.5
//        self.complaintview.layer.cornerRadius=5
        self.complaintsavebtn.layer.borderWidth=0.5
        self.complaintsavebtn.layer.cornerRadius=5
        self.setUpViews()
    }

    func customformat() {
        self.headerlbl.text = "Complaint".localize()
        complaintTypeBtn.setTitle("Choose your Complaint type".localize(), for: .normal)
        complaintTypeBtn.setTitleColor(.lightGray, for: .normal)
        self.commentslbl.text = "Comments".localize()
        self.complaintsavebtn.setTitle("Save".localize(), for: .normal)
    }

    func setUpViews() {


        complaintTypeBtn.layer.borderWidth = 0.5
        complaintTypeBtn.layer.cornerRadius = 5
        complaintTypeBtn.translatesAutoresizingMaskIntoConstraints = false
        complaintTypeBtn.addTarget(self, action: #selector(complaintTypeBtnAction), for: .touchUpInside)
        layoutDic["complaintTypeBtn"] = complaintTypeBtn
        complaintTypeBtn.setImage(UIImage(named: "downarrow"), for: .normal)
        complaintTypeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        complaintTypeBtn.contentHorizontalAlignment = .right
        complaintTypeBtn.semanticContentAttribute = .forceRightToLeft
        complaintTypeBtn.setTitle("Choose your complaint type".localize(), for: .normal)
        complaintTypeBtn.setTitleColor(.black,for: .normal)
        complaintTypeBtn.titleLabel?.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        complaintTypeBtn.titleLabel?.font = UIFont.appFont(ofSize: 16)
        self.view.addSubview(complaintTypeBtn)


        self.headerlbl.font = UIFont.appTitleFont(ofSize: 20)
        self.complaintTypeBtn.titleLabel?.font = UIFont.appFont(ofSize: 14)
        self.commentslbl.font = UIFont.appFont(ofSize: 15)
        self.complainttxtvw.font = UIFont.appFont(ofSize: 15)
        self.complaintsavebtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.complaintsavebtn.backgroundColor = .themeColor
        self.complaintsavebtn.setTitleColor(.secondaryColor, for: .normal)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        halfbgiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["halfbgiv"] = halfbgiv
        formbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["formbtn"] = formbtn
        formbtn.imageView?.contentMode = .scaleAspectFit
        complainttxtvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["complainttxtvw"] = complainttxtvw
        headerlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerlbl"] = headerlbl
        commentslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["commentslbl"] = commentslbl
        complaintsavebtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["complaintsavebtn"] = complaintsavebtn

        halfbgiv.topAnchor.constraint(equalTo: self.top, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[halfbgiv(100)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[halfbgiv]|", options: [], metrics: nil, views: layoutDic))
        formbtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        formbtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        formbtn.centerXAnchor.constraint(equalTo: halfbgiv.centerXAnchor).isActive = true
        formbtn.centerYAnchor.constraint(equalTo: halfbgiv.bottomAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[formbtn]-(20)-[headerlbl(30)]-(10)-[complaintTypeBtn(30)]-(20)-[commentslbl(30)]-(15)-[complainttxtvw(100)]-(>=20)-[complaintsavebtn(40)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[headerlbl(180)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[complaintTypeBtn]-(20)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[commentslbl(180)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[complainttxtvw]-(20)-|", options: [], metrics: nil, views: layoutDic))
        complaintsavebtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        complaintsavebtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        complaintsavebtn.bottomAnchor.constraint(equalTo: self.bottom, constant: -20).isActive = true


        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        let btnWidth = complaintTypeBtn.bounds.width
        let titleWidth = complaintTypeBtn.titleLabel!.bounds.width
        let imgWidth = complaintTypeBtn.imageView!.bounds.width
        complaintTypeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: btnWidth-(titleWidth+imgWidth+10))

        self.complaintsavebtn.layer.cornerRadius = self.complaintsavebtn.bounds.height/2

        complaintsPopUpView.translatesAutoresizingMaskIntoConstraints = false
        complaintsPopUpView.delegate = self
        layoutDic["complaintsPopUpView"] = complaintsPopUpView
        complaintsPopUpView.removeFromSuperview()
        self.navigationController?.view.addSubview(complaintsPopUpView)
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[complaintsPopUpView]|", options: [], metrics: nil, views: layoutDic))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[complaintsPopUpView]|", options: [], metrics: nil, views: layoutDic))
    }

    //------------------------------------------
    // MARK: - Back button navigation
    //------------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        self.performSegue(withIdentifier: "seguefromcomplaintstohome", sender: self)
    }

    //------------------------------------------
    // MARK: - Getting user data from coredata
    //------------------------------------------

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

    //--------------------------------------
    // MARK: - Complaint save btn Action
    //--------------------------------------

    @IBAction func savebtnAction() -> Void {
        var errmsg=""
        if selectedComplaintType == nil {
            errmsg="Please choose complaint type".localize()
        } else if self.complainttxtvw.text.count == 0 {
            errmsg="Please enter complaint description".localize()
        }
        if(errmsg.count>0) {
            self.alert(message: errmsg)
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"] = userId
                paramDict["token"] = userTokenstr
                paramDict["title"] = Int(selectedComplaintType.identifier)!
                paramDict["description"] = self.complainttxtvw.text
                paramDict["admin_key"] = self.adminkey
                print(paramDict)
                let url = helperObject.BASEURL + helperObject.savecomplaint
                print(url)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        self.selectedComplaintType = nil
                        self.complaintTypeBtn.setTitle("Choose your Complaint type".localize(), for: .normal)
                        self.complaintTypeBtn.setTitleColor(.lightGray, for: .normal)
                        self.complainttxtvw.text = ""
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Saving Complaint",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                self.view.showToast(JSON.value(forKey: "success_message") as! String)
//                                self.view.showToast()
                            } else {
                                self.view.showToast(JSON.value(forKey: "error_message") as! String)
                            }
                        }
                }
            }
            else {
                self.alert(message: "Internet not connected")
            }
        }
    }

    //--------------------------------------
    // MARK: - Tableview Delegates
    //--------------------------------------

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.complaintlistarray.count
//    }

    // create a cell for each table view row
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "complaintlistcell", for: indexPath)
//        cell.textLabel?.font = UIFont.appFont(ofSize: 15)
//        cell.textLabel?.text=complaintlistnamearray[indexPath.row] as? String
//
//        self.complaintlistTbv.frame=CGRect(x: self.complaintlistTbv.frame.origin.x, y: self.complaintlistTbv.frame.origin.y, width:self.complaintlistTbv.frame.size.width, height: CGFloat(self.complaintlistarray.count*30))
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        self.complaintlisttfd.text=self.complaintlistnamearray[indexPath.row] as? String
//        self.complaintlistTbv.isHidden=true
//        selcomplaintid=self.complaintlistidarray[indexPath.row] as! Int
//    }
    @objc func complaintTypeBtnAction() {
        if let list = complaintsPopUpView.optionsList, list.isEmpty {
            self.showAlert("Alert".localize(), message: "No Complaint Types Available")
        } else {
            complaintsPopUpView.isHidden = false
        }
    }
    @IBAction func downbtnAction() {
//        if(self.complaintlistTbv.isHidden==true)
//        {
//            self.complaintlistTbv.isHidden=false
//        }
//        else
//        {
//            self.complaintlistTbv.isHidden=true
//        }
    }

    //--------------------------------------
    // MARK: - Get Complaint list
    //--------------------------------------

    func getcomplaintlist() {
        if ConnectionCheck.isConnectedToNetwork() {
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["type"]="1"
            paramDict["id"]=userId
            paramDict["token"]=userTokenstr
            paramDict["latitude"]=latstr
            paramDict["longitude"]=lngstr
            print(paramDict)
            let url = helperObject.BASEURL + helperObject.getcomplaintlist
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                print(response.response as Any) // URL response
                print(response.result.value as AnyObject)
                self.complaintlistarray=NSMutableArray()
                self.complaintlistnamearray=NSMutableArray()
                self.complaintlistidarray=NSMutableArray()
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("Response for Complaint list",JSON)
                    print(JSON.value(forKey: "success") as! Bool)
                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                    if(theSuccess == true) {
                        self.adminkey=JSON.value(forKey: "admin_key") as! String
                        self.complaintlistarray=(JSON.value(forKey: "complaint_list") as! NSArray)


                        self.complaintsPopUpView.optionsList = (self.complaintlistarray as! [[String:AnyObject]]).map({
                            (text:$0["title"] as! String,identifier: String($0["id"] as! Int))
                        })
                        self.complaintsPopUpView.tableTitle = "Select Complaint Type".localize().uppercased(with: Locale(identifier: APIHelper.currentAppLanguage))
//                        self.languagePopUpView.isHidden = false

//
//                        for array in self.complaintlistarray
//                        {
//                            print(array)
//                            self.complaintlistidarray.add((array as AnyObject).value(forKey: "id") as? NSNumber! as Any)
//                            self.complaintlistnamearray.add((array as AnyObject).value(forKey: "title") as! NSString)
//                        }
//                        if(self.complaintlistnamearray.count>0)
//                        {
//                            self.complaintlistTbv.reloadData()
//                        }
//                        else
//                        {
//
//                        }
                    } else {

                    }
                }
            }
        } else {
            self.alert(message: "Internet not connected")
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
//
//    func showLoadingIndicator() {
//        if activityView == nil {
//            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//            // add subview
//            self.view.bringSubview(toFront: activityView)
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

    //--------------------------------------
    // MARK: - Textview delegates
    //--------------------------------------

    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        let newText = (self.complainttxtvw.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 200
    }
}
extension complaintsvc:PopUpTableViewDelegate {
    func popUpTableView(_ popUpTableView: PopUpTableView, didSelectOption option: Option, atIndex index: Int) {
        print(option)
        selectedComplaintType = option
        self.complaintTypeBtn.setTitle(option.text, for: .normal)
        self.complaintTypeBtn.setTitleColor(.black, for: .normal)
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        let btnWidth = complaintTypeBtn.bounds.width
        let titleWidth = complaintTypeBtn.titleLabel!.bounds.width
        let imgWidth = complaintTypeBtn.imageView!.bounds.width
        complaintTypeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: btnWidth-(titleWidth+imgWidth+10))
    }
}
