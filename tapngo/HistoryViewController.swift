//
//  historyvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 15/02/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let helperObject = APIHelper()

    var userTokenstr = ""
    var userId = ""

    var ghdsucmsg = ""
    var page = Int()
    var activityView: NVActivityIndicatorView!
    var vehicleimagearray = NSMutableArray()
    var tripstarttimearray = NSMutableArray()
    var vehicletypearray = NSMutableArray()
    var triprequestidarray = NSMutableArray()
    var tripreqidarray = NSMutableArray()
    var currencyarray = NSMutableArray()
    var totaltripcostarray = NSMutableArray()
    var trippickuploactionarray = NSMutableArray()
    var tripdroploactionarray = NSMutableArray()
    var driverimagearray = NSMutableArray()
    var tripiscancelledarray = NSMutableArray()
    var tripiscompletedarray = NSMutableArray()
    var laterarray = NSMutableArray()
    @IBOutlet weak var historytbv: UITableView!

    @IBOutlet weak var noitemsfoundiv: UIImageView!

    let appdel=UIApplication.shared.delegate as!AppDelegate

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBtnString = ""

        self.getUser()
        self.title="History"
//        page=1
       // self.gethistorydetails()

        self.setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        page=1
        self.gethistorydetails()
        self.getUser()
    }
    func setUpViews() {
        historytbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["historytbv"] = historytbv
        noitemsfoundiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["noitemsfoundiv"] = noitemsfoundiv

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        historytbv.topAnchor.constraint(equalTo: self.top).isActive = true
        historytbv.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[historytbv]|", options: [], metrics: nil, views: layoutDic))
        noitemsfoundiv.widthAnchor.constraint(equalToConstant: 180).isActive = true
        noitemsfoundiv.heightAnchor.constraint(equalToConstant: 110).isActive = true
        noitemsfoundiv.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noitemsfoundiv.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true


    }


    //------------------------------------------
    // MARK: - Back button navigation
    //------------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") //as! SWRevealViewController
        //        self.navigationController?.pushViewController(vc!, animated: true)
        //        self.performSegue(withIdentifier: "seguefromhistorytohome", sender: self)
    }

    //------------------------------------------
    // MARK: - Getting user data from coredata
    //------------------------------------------

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext1().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            print("Users=\(array_users)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...

                userId = (String(describing: user.value(forKey: "id")!))
                userTokenstr = (String(describing: user.value(forKey: "token")!))
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

    //--------------------------------------
    // MARK: - Getting history details
    //--------------------------------------

    func gethistorydetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            paramDict["page"]=page
            let url = helperObject.BASEURL + helperObject.gethistorydata
            print(paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        if let successMsg = JSON.value(forKey: "success_message") as? String {
                            self.ghdsucmsg = successMsg
                        }
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            let JSON = response.result.value as! NSDictionary
                            print(JSON)
                            let historyarray=JSON.value(forKey: "history") as! NSArray

                            for array in historyarray {
                                if(((array as AnyObject).value(forKey: "later") as! Int) == 1)
                                {
                                    self.vehicletypearray.add((array as AnyObject).value(forKey: "type_name") as! NSString)

                                    let def22=((array as AnyObject).value(forKey: "id") as! Int)
                                    let st22=String(format: "%d", def22)
                                    self.tripreqidarray.add(st22)

                                    self.triprequestidarray.add((array as AnyObject).value(forKey: "request_id") as! NSString)

                                    self.tripstarttimearray.add((array as AnyObject).value(forKey: "trip_start_time") as! NSString)
                                    self.currencyarray.add((array as AnyObject).value(forKey: "currency") as! NSString)
                                    self.trippickuploactionarray.add((array as AnyObject).value(forKey: "pick_location") as! NSString)
                                    if let dropLocation = (array as AnyObject).value(forKey: "drop_location") as? NSString {

                                        self.tripdroploactionarray.add(dropLocation)
                                    } else {
                                        self.tripdroploactionarray.add("")
                                    }
                                    self.driverimagearray.add("")
                                    self.vehicleimagearray.add((array as AnyObject).value(forKey: "type_icon") as! NSString)
                                    self.tripiscancelledarray.add((array as AnyObject).value(forKey: "is_cancelled") as! Bool)
                                    self.tripiscompletedarray.add((array as AnyObject).value(forKey: "is_completed") as! Bool)

                                    let def2=((array as AnyObject).value(forKey: "later") as! Int)
                                    let st2=String(def2)
                                    self.laterarray.add(st2)

                                    let st = ""
                                    self.totaltripcostarray.add(st)
                                }
                                else
                                {
                                    self.vehicletypearray.add((array as AnyObject).value(forKey: "type_name") as! NSString)

                                    let def22=((array as AnyObject).value(forKey: "id") as! Int)
                                    let st22=String(format: "%d", def22)
                                    self.tripreqidarray.add(st22)

                                    self.triprequestidarray.add((array as AnyObject).value(forKey: "request_id") as! NSString)

                                    self.tripstarttimearray.add((array as AnyObject).value(forKey: "trip_start_time") as! NSString)
                                    self.currencyarray.add((array as AnyObject).value(forKey: "currency") as! NSString)
                                    // self.trippickuploactionarray.add((array as AnyObject).value(forKey: "pick_location") as! NSString)

                                    if let pickLocation = (array as AnyObject).value(forKey: "pick_location") as? NSString {

                                        self.trippickuploactionarray.add(pickLocation)
                                    } else {
                                        self.trippickuploactionarray.add("")
                                    }

                                    if let dropLocation = (array as AnyObject).value(forKey: "drop_location") as? NSString {

                                        self.tripdroploactionarray.add(dropLocation)
                                    } else {
                                        self.tripdroploactionarray.add("")
                                    }


                                    self.driverimagearray.add((array as AnyObject).value(forKey: "driver_profile_pic") as! NSString)
                                    self.vehicleimagearray.add((array as AnyObject).value(forKey: "type_icon") as! NSString)
                                    self.tripiscancelledarray.add((array as AnyObject).value(forKey: "is_cancelled") as! Bool)
                                    self.tripiscompletedarray.add((array as AnyObject).value(forKey: "is_completed") as! Bool)

                                    let def2=((array as AnyObject).value(forKey: "total") as! Double)
                                    let st=String(format: "%.2f", def2)
                                    self.totaltripcostarray.add(st)

                                    let def12=((array as AnyObject).value(forKey: "later") as! Int)
                                    let st2=String(def12)
                                    self.laterarray.add(st2)
                                }
                            }
                            if(self.vehicletypearray.count>0) {
                                self.historytbv.isHidden=false
                                self.noitemsfoundiv.isHidden=true
                                self.historytbv.reloadData()
                            } else {
                                self.historytbv.isHidden=true
                                self.noitemsfoundiv.isHidden=false
                            }
                        } else if(theSuccess == false) {
                            print("Response Fail")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Unable to fetch History Details.")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }
    }

    //------------------------------------------
    // MARK: - NVActivityIndicatorview
    //------------------------------------------

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

    //------------------------------------------
    // MARK: - Alert - Custom
    //------------------------------------------

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //--------------------------------------
    // MARK: - Table view Delegates
    //--------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vehicletypearray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryTableViewCell

        cell.triptimelbl.font = UIFont.appFont(ofSize: 15)
        cell.vehicletypelbl.font = UIFont.appFont(ofSize: 14)
        cell.schedulelbl.font = UIFont.appFont(ofSize: 14)
        cell.tripcostlbl.font = UIFont.appFont(ofSize: 14)
        cell.tripreqidlbl.font = UIFont.appFont(ofSize: 14)
        cell.fromaddrlbl.font = UIFont.appFont(ofSize: 13)
        cell.toaddrlbl.font = UIFont.appFont(ofSize: 13)

        cell.vehicletypelbl.text=self.vehicletypearray[indexPath.row] as? String
        cell.tripreqidlbl.text=self.triprequestidarray[indexPath.row] as? String

        cell.tripcvancelledimageIv.layer.masksToBounds=true
        cell.tripcvancelledimageIv.layer.cornerRadius=cell.driverimageIv.layer.frame.width/2

        let tripCompltd = self.tripiscompletedarray[indexPath.row]as? Bool
        let tripcan=self.tripiscancelledarray[indexPath.row] as? Bool
        if(tripcan==true) {
            cell.tripcostlbl.isHidden=true
            cell.tripcvancelledimageIv.isHidden=false
        } else {
            cell.tripcostlbl.isHidden=false
            cell.tripcvancelledimageIv.isHidden=true
        }
        if(self.laterarray[indexPath.row] as! String == "1") {
            cell.schedulelbl.isHidden=false
            if(tripcan==true) {
                cell.schedulelbl.isHidden=true
            }
            else if(tripCompltd == true){
                cell.schedulelbl.isHidden=true
            }
            else {
                cell.schedulelbl.isHidden=false
            }
            cell.tripcostlbl.isHidden=true
        } else {
            cell.schedulelbl.isHidden=true
            if(tripcan==true) {
                cell.tripcostlbl.isHidden=true
            }
            else {
                cell.tripcostlbl.isHidden=false
            }
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"


        if let tripstarttimearray = self.tripstarttimearray[indexPath.row] as? String {
            if let date: Date = dateFormatterGet.date(from: tripstarttimearray) {
                cell.triptimelbl.text=dateFormatter.string(from: date)
            }
        }
        if let time = self.tripstarttimearray[indexPath.row] as? String {
        cell.triptimelbl.text = time
        }


        //        if let date: Date? = dateFormatterGet.date(from: (self.tripstarttimearray[indexPath.row] as? String)) {
        //            cell.triptimelbl.text=dateFormatter.string(from: date!)
        //        }
        // print(dateFormatter.string(from: date!))

        //self.tripstarttimearray[indexPath.row] as? String
        cell.fromaddrlbl.text=self.trippickuploactionarray[indexPath.row] as? String
        print(self.tripdroploactionarray[indexPath.row] as? String)
        print(tripdroploactionarray)
        print(tableView.numberOfRows(inSection: 0))
        if let toAddress = self.tripdroploactionarray[indexPath.row] as? String{
            cell.toaddrlbl.text = toAddress
        }

        let totalstr=(self.currencyarray[indexPath.row] as? String)! + " " + (self.totaltripcostarray[indexPath.row] as? String)!
        cell.tripcostlbl.text=totalstr

        //        cell.driverimageIv.image = UIImage(named: "Profile_placeholder")  //set placeholder image first.

        cell.driverimageIv.contentMode = .scaleToFill
        cell.vehicleimageIv.contentMode = .scaleAspectFit

        if let url = URL(string:driverimagearray[indexPath.row] as! String)
        {
            cell.driverimageIv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            cell.driverimageIv.kf.setImage(with: resource, placeholder: UIImage(named: "Profile_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        if let vehicleImageUrl = URL(string:vehicleimagearray[indexPath.row] as! String)
        {
            cell.vehicleimageIv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: vehicleImageUrl)
            cell.vehicleimageIv.kf.setImage(with: resource)
        }
        //        cell..downloadImageFrom(link: vehicleimagearray[indexPath.row] as! String, contentMode: UIViewContentMode.scaleAspectFit)
        cell.driverimageIv.layer.masksToBounds=true
        cell.driverimageIv.layer.cornerRadius=cell.driverimageIv.layer.frame.width/2
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if(ghdsucmsg=="user_history_not_found") {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        } else {
            if(indexPath.row==vehicletypearray.count-1) {
                page=page+1
                self.gethistorydetails()
            }
        }
        if(tripdroploactionarray.count<4) {
            self.historytbv.frame=CGRect(x:self.historytbv.frame.origin.x, y:self.historytbv.frame.origin.y, width:self.historytbv.frame.size.width, height:CGFloat(self.tripdroploactionarray.count*150))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.appdel.historyrequestid=self.tripreqidarray[indexPath.row] as! String
        if(self.laterarray[indexPath.row] as! String == "1" && self.tripiscompletedarray[indexPath.row] as? Bool == true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Historydetailsvc") as! Historydetailsvc
            self.navigationController?.pushViewController(vc, animated: true)
            //            self.performSegue(withIdentifier: "seguefromhistorytohistorydetails", sender: self)
        } else if(self.laterarray[indexPath.row] as! String == "1" && self.tripiscancelledarray[indexPath.row] as? Bool == false) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "scheduledetailsvc") as! scheduledetailsvc
            self.navigationController?.pushViewController(vc, animated: true)
            //            self.performSegue(withIdentifier: "seguefromhistorytoscheduleddetails", sender: self)
        } else {
            let cancelstatus=self.tripiscancelledarray[indexPath.row] as? Bool
            if(cancelstatus == true) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "cancelledhistoryvc") as! CancelledHistoryVC
                self.navigationController?.pushViewController(vc, animated: true)
                //                self.performSegue(withIdentifier: "seguefromhistorytocancelledhistorydetails", sender: self)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Historydetailsvc") as! Historydetailsvc
                self.navigationController?.pushViewController(vc, animated: true)
                //                self.performSegue(withIdentifier: "seguefromhistorytohistorydetails", sender: self)
            }
        }
    }
}
