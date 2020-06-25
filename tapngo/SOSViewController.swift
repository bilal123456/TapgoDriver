//
//  sosvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import NVActivityIndicatorView
import Contacts

class SOSViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//changes sos
   /* struct contactStruct
    {
        let givenname:String
        let familyname:String
        let number:String
    }

    struct SelectedArray {
        var name:String
        var number:String

    }*/


    var window1: UIWindow?
    let helperObject = APIHelper()
    var activityView: NVActivityIndicatorView!
    var currentuserid: String! = ""
    var currentusertoken: String! = ""
    let appdel=UIApplication.shared.delegate as!AppDelegate
    @IBOutlet weak var sosheadinglbl: UILabel!
    @IBOutlet weak var soshintlbl: UILabel!
    @IBOutlet weak var soslisttbv: UITableView!

//    var viewPopUp = UIView()
//    var tableContacts = UITableView()


    var soslistarray=NSArray()
    var sosnamearray=NSMutableArray()
    var sosnumberarray=NSMutableArray()
    var sosidarray=NSMutableArray()

    var latstr: String! = ""
    var lngstr: String! = ""

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    //changes sos
   /* var contactStore = CNContactStore()
    var contacts = [contactStruct]()
    var selectArray = [SelectedArray]()*/

    override func viewDidLoad() {
        super.viewDidLoad()

        //changes sos
       /* navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(btnContactPressed))*/


        latstr = UserDefaults.standard.string(forKey: "firstlat")
        lngstr = UserDefaults.standard.string(forKey: "firstlong")
        self.title="SOS"
        self.soslisttbv.separatorStyle=UITableViewCell.SeparatorStyle.none
        self.soslisttbv.isScrollEnabled=false
        self.soslisttbv.allowsSelection=false
        self.getUser()
        self.getsoslists()
        self.setUpViews()
        // Do any additional setup after loading the view.
    }

    func setUpViews() {
        self.sosheadinglbl.font = UIFont.appTitleFont(ofSize: 20)
        self.soshintlbl.font = UIFont.appFont(ofSize: 14)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        sosheadinglbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sosheadinglbl"] = sosheadinglbl
        soshintlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["soshintlbl"] = soshintlbl
        soslisttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["soslisttbv"] = soslisttbv
        soslisttbv.estimatedRowHeight = 85
        soslisttbv.rowHeight = UITableView.automaticDimension
        soslisttbv.separatorStyle = .none

//        viewPopUp.backgroundColor = UIColor.black
//        viewPopUp.alpha = 0.6
//        viewPopUp.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["viewPopUp"] = viewPopUp
//        self.navigationController?.view.addSubview(viewPopUp)
//        viewPopUp.isHidden = true


//        tableContacts.backgroundColor = UIColor.clear
//        tableContacts.delegate = self
//        tableContacts.dataSource = self
//        tableContacts.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["tableContacts"] = tableContacts
//        self.viewPopUp.addSubview(tableContacts)



        sosheadinglbl.topAnchor.constraint(equalTo: self.top, constant: 35).isActive = true
        soslisttbv.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[sosheadinglbl(25)]-(20)-[soshintlbl(50)]-(20)-[soslisttbv]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosheadinglbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[soshintlbl]-(16)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[soslisttbv]|", options: [], metrics: nil, views: layoutDic))

        // changes sos
     /*   self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewPopUp]|", options: [], metrics: nil, views: layoutDic))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewPopUp]|", options: [], metrics: nil, views: layoutDic))

        self.viewPopUp.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[tableContacts]-32-|", options: [], metrics: nil, views: layoutDic))
         self.viewPopUp.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-74-[tableContacts]-32-|", options: [], metrics: nil, views: layoutDic))*/


    }

    // changes sos

 /*   @objc func btnContactPressed() {
        viewPopUp.isHidden = false

        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success{
                print("authorization succeed")
            }
        }
        fetchcontacts()
    }

    func fetchcontacts()
    {
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,]as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contactStore.enumerateContacts(with: request) { (contact, stoppingpointer) in
            let name = contact.givenName
            let familyname = contact.familyName

            if let number = contact.phoneNumbers.first?.value.stringValue {
                let contactToAppend = contactStruct(givenname: name, familyname: familyname, number: number)

                self.contacts.append(contactToAppend)
            }


        }
         print(self.contacts)
        tableContacts.reloadData()
    }*/


//    func setUpViews()
//    {
//        self.top = self.view.topAnchor
//        sosheadinglbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["sosheadinglbl"] = sosheadinglbl
//        soshintlbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["soshintlbl"] = soshintlbl
//        soslisttbv.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["soslisttbv"] = soslisttbv
//    }

    func customformat() {
        self.sosheadinglbl.text = "SOS".localize()
        self.soshintlbl.text = "hinttext".localize()
    }

    func getsoslists() {
        if ConnectionCheck.isConnectedToNetwork() {
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            print("Connected")
            sosnamearray=NSMutableArray()
            sosnumberarray=NSMutableArray()
            sosidarray=NSMutableArray()
            var paramDict = Dictionary<String, Any>()
            paramDict["id"]=currentuserid
            paramDict["token"]=currentusertoken
            paramDict["latitude"]=latstr
            paramDict["longitude"]=lngstr
            print(paramDict)
            let url = helperObject.BASEURL + helperObject.getsoslist
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for SOS list",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.soslistarray=(JSON.value(forKey: "sos") as! NSArray)
                            for array in self.soslistarray {
                                self.sosidarray.add((array as AnyObject).value(forKey: "id") as? NSNumber! as Any)
                                self.sosnamearray.add((array as AnyObject).value(forKey: "name") as! NSString)
                                self.sosnumberarray.add((array as AnyObject).value(forKey: "number") as! NSString)
                                print(self.sosnumberarray)
                            }
                            if(self.soslistarray.count>0) {
                                self.soslisttbv.isHidden=false
                                self.soslisttbv.reloadData()
                            } else {
                                self.soslisttbv.isHidden=true
                            }
                        } else {

                        }
                    }
            }
        } else {
            self.alert(message: "Internet not connected")
        }
    }


    //--------------------------------------
    // MARK: - Fetch User data
    //--------------------------------------

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            let array_users = try getContext().fetch(fetchRequest)
            print ("num of users = \(array_users.count)")
            print("Users=\(array_users)")
            for user in array_users as [NSManagedObject] {
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
//        self.performSegue(withIdentifier: "seguefromsostohome", sender: self)
    }

    //--------------------------------------
    // MARK: - Table view Delegates
    //--------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tableView == soslisttbv) {
            return sosnamearray.count
        }
        // changes sos
//        else if(tableView == tableContacts) {
//            return contacts.count
//        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init()

        if(tableView == soslisttbv) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "soslistcell", for: indexPath) as! SOSListTableViewCell
            cell.shadowView.layer.cornerRadius = 5.0
            cell.shadowView.addShadow()

            cell.soscallBtn.addTarget(self, action: #selector(callsos(_ :)), for: .touchUpInside)

            cell.sosnameLbl.text=self.sosnamearray[indexPath.row] as? String
            cell.sosnumberLbl.text=self.sosnumberarray[indexPath.row] as? String
            cell.sosnameLbl.font = UIFont.appFont(ofSize: 14)
            cell.sosnumberLbl.font = UIFont.appFont(ofSize: 14)
            if(sosnamearray.count<=3) {
               // self.soslisttbv.frame=CGRect(x: self.soslisttbv.frame.origin.x, y: self.soslisttbv.frame.origin.y, width: self.soslisttbv.frame.size.width, height: CGFloat(self.sosnamearray.count*110))
                self.soslisttbv.isScrollEnabled=false
            } else {
                self.soslisttbv.isScrollEnabled=true
            }
            return cell
        }

        // changes sos
      /*  else if(tableView == tableContacts) {
            tableContacts.allowsMultipleSelection = true

           var cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableViewCell")

            if(cell == nil){
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactListTableViewCell")
            }
            cell?.selectionStyle = .none
            let contactTodisplay = contacts[indexPath.row]
            cell?.textLabel?.text = contactTodisplay.givenname
            cell?.detailTextLabel?.text = contactTodisplay.number
            return cell!
        }*/


       return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(tableView == soslisttbv) {
            let phonenumber: String = sosnumberarray[indexPath.row] as! String
            if let phoneCallURL = URL(string: "tel://"+"\(phonenumber)") {
                let application: UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        // changes sos
       /* else if(tableView == tableContacts) {
            let cell = tableContacts.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark

           // let name = contacts[indexPath.row].givenname
            //let number = contacts[indexPath.row].number
           // let contacttoAdd = SelectedArray(name: name, number: number)
           // self.selectArray.append(contacttoAdd)
           // print("array list",selectArray)

            let name = contacts[indexPath.row]
            print(name)
            var dict = [String: AnyObject]()
            dict["name"] = name.givenname as AnyObject
            dict["phone_number"] = name.number as AnyObject
            print(dict)

        }*/
    }

//changesd sos
 /*   func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(tableView == tableContacts) {
            let cell = tableContacts.cellForRow(at: indexPath)
            cell?.accessoryType = .none

            selectArray.remove(at: indexPath.row)
            print("array removed list",selectArray)

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tableContacts) {
            return 100.0
        }
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == tableContacts) {
        let viewHeader = UIView()
        let lblHeader = UILabel()
        viewHeader.addSubview(lblHeader)
        lblHeader.text = "select your contacts"
        lblHeader.textAlignment = .center
        lblHeader.textColor = UIColor.white
        lblHeader.backgroundColor = UIColor.red
        lblHeader.frame = CGRect(x: 0, y: 8, width: self.tableContacts.frame.size.width, height: 40)
        return viewHeader
        }
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(tableView == tableContacts) {
        let viewFooter = UIView()
        let btnCancel = UIButton()
        let btnAdd = UIButton()
        viewFooter.frame = CGRect(x: 0, y: 0, width: self.tableContacts.frame.size.width, height: 40)
        viewFooter.backgroundColor = UIColor.white

        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.translatesAutoresizingMaskIntoConstraints = false

        viewFooter.addSubview(btnCancel)
        viewFooter.addSubview(btnAdd)

            btnAdd.setTitle("ADD", for: .normal)
            btnAdd.backgroundColor = UIColor.red
            btnAdd.addTarget(self, action: #selector(btnAddContactPopupPressed), for: .touchUpInside)
            btnAdd.setTitleColor(UIColor.white, for: .normal)
            btnCancel.setTitle("CANCEL", for: .normal)
            btnCancel.backgroundColor = UIColor.red
            btnCancel.addTarget(self, action: #selector(btnCancelPopupPressed), for: .touchUpInside)
            btnCancel.setTitleColor(UIColor.white, for: .normal)

            viewFooter.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnCancel]-8-[btnAdd(==btnCancel)]|", options: [], metrics: nil, views: ["btnCancel":btnCancel,"btnAdd":btnAdd]))
            viewFooter.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnCancel(40)]|", options: [], metrics: nil, views: ["btnCancel":btnCancel,"btnAdd":btnAdd]))
            viewFooter.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnAdd(40)]|", options: [], metrics: nil, views: ["btnCancel":btnCancel,"btnAdd":btnAdd]))

        return viewFooter
        }
        return UIView.init()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }

    @objc func btnAddContactPopupPressed() {
        addContactsAPI()
    }

    @objc func btnCancelPopupPressed() {

        viewPopUp.isHidden = true

    }*/

    @objc func callsos(_ sender : UIButton) {
        print("call")
        let i: Int=sender.tag
        let phonenumber: String = sosnumberarray[i] as! String
        if let phoneCallURL = URL(string: "tel://"+"\(phonenumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
// changes sos
//    func addContactsAPI() {
//
//        if ConnectionCheck.isConnectedToNetwork() {
//             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
//            print("Connected")
//            sosnamearray=NSMutableArray()
//            sosnumberarray=NSMutableArray()
//            sosidarray=NSMutableArray()
//            var paramDict = Dictionary<String, Any>()
//            paramDict["id"]=currentuserid
//            paramDict["token"]=currentusertoken
//
//
//            let array = self.selectArray.map({ $0.name })
//            let data = try? JSONSerialization.data(withJSONObject: array, options: [])
//            let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//
//            paramDict["name"]=string
//            paramDict["phone_number"]=self.selectArray.map({ $0.number })
//            print(paramDict)
//            let url = helperObject.BASEURL + helperObject.getsosUserlist
//            print(url)
//            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                .responseJSON { response in
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                    print(response.response as Any) // URL response
//                    print(response.result.value as AnyObject)
//
//            }
//        } else {
//            self.alert(message: "Internet not connected")
//        }
//
//    }

}
