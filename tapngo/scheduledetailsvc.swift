//
//  scheduledetailsvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 07/03/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView
import Alamofire
import GoogleMaps
import Kingfisher

class scheduledetailsvc: UIViewController {

    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet var profIv: UIImageView!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet var ridelbl: UILabel!
    @IBOutlet var typeiconIv: UIImageView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet var addressIv: UIImageView!
    @IBOutlet var pickupaddrlbl: UILabel!
    @IBOutlet var dropupaddrlbl: UILabel!
    @IBOutlet weak var separator3: UIView!
    @IBOutlet var cancelBtn: UIButton!

    let helperObject = APIHelper()

    var userTokenstr: String=""
    var userId: String=""

    var currency: String=""
    var historydict = NSDictionary()
    var billdict = NSDictionary()
    var activityView: NVActivityIndicatorView!
    let appdel=UIApplication.shared.delegate as!AppDelegate

    var pickUpLat: String! = ""
    var pickUpLong: String! = ""

    var marker = GMSMarker()
    var desmarker = GMSMarker()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var selectedCarModel: CarModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Schedule Details"
        self.getUser()
        self.getscheduledetails()
        self.setUpViews()
        // Do any additional setup after loading the view.
    }

    func setUpViews()
    {

        self.ridelbl.font = UIFont.appFont(ofSize: 15)
        self.pickupaddrlbl.font = UIFont.appFont(ofSize: 14)
        self.dropupaddrlbl.font = UIFont.appFont(ofSize: 14)
        self.cancelBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.cancelBtn.setTitleColor(.themeColor, for: .normal)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        profIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profIv"] = profIv
        ridelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridelbl"] = ridelbl
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator1"] = separator1
        typeiconIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["typeiconIv"] = typeiconIv
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupaddrlbl"] = pickupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropupaddrlbl"] = dropupaddrlbl
        addressIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addressIv"] = addressIv
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator2"] = separator2
        separator3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator3"] = separator3
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelBtn"] = cancelBtn

        mapview.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mapview(150)]-(20)-[profIv(50)]-(10)-[separator1(1)]-(10)-[typeiconIv(40)]-(10)-[separator2(1)]-(15)-[pickupaddrlbl(40)]-(5)-[dropupaddrlbl(10)]-(15)-[separator3(1)]-(>=10)-[cancelBtn(40)]", options: [], metrics: nil, views: layoutDic))
        cancelBtn.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[typeiconIv(40)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cancelBtn]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profIv(50)]-(15)-[ridelbl]-(15)-|", options: [.alignAllCenterY], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[addressIv(30)]-(5)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[addressIv]-(5)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        addressIv.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor).isActive = true
        addressIv.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator1]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator2]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator3]|", options: [], metrics: nil, views: layoutDic))
    }
    
    //------------------------------------------
    // MARK: - Back button navigation
    //------------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
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

    func getscheduledetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            paramDict["request_id"]=self.appdel.historyrequestid
            let url = helperObject.BASEURL + helperObject.gethistorydetails
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
                            self.historydict=JSON.value(forKey: "request") as! NSDictionary
                            print(self.historydict)
                            self.setupmap()
                            self.setupdata()
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

    func setupmap() {
        let latdouble=self.historydict.value(forKey: "pick_latitude")
        let longdouble=self.historydict.value(forKey: "pick_longitude")

        let destlatdouble=self.historydict.value(forKey: "drop_latitude")
        let destlondouble=self.historydict.value(forKey: "drop_longitude")

        let camera = GMSCameraPosition.camera(withLatitude: latdouble! as! CLLocationDegrees, longitude: longdouble! as! CLLocationDegrees, zoom: 14)
        mapview.camera=camera

        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
        marker.map = mapview

        desmarker.position = CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees)
        desmarker.map = mapview

        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: mapview.camera.target.latitude, longitude: mapview.camera.target.longitude))
        path.add(CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees))
        var bounds = GMSCoordinateBounds()

        for index in 0...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        self.mapview.animate(with: GMSCameraUpdate.fit(bounds))
    }

    //--------------------------------------
    // MARK: - Populating history info
    //--------------------------------------

    func setupdata() {
        self.profIv.layer.masksToBounds=true
        self.profIv.layer.cornerRadius=self.profIv.layer.frame.width/2

        if let url = URL(string:historydict.value(forKey: "type_icon") as! String)
        {
            self.typeiconIv.contentMode = .scaleToFill
            self.typeiconIv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            self.typeiconIv.kf.setImage(with: resource)
        }
//        self.typeiconIv.downloadImageFrom122(link: , contentMode: UIViewContentMode.scaleToFill)

        //pickup and drop address

        self.pickupaddrlbl.text=historydict.value(forKey: "pick_location") as? String
        self.dropupaddrlbl.text=historydict.value(forKey: "drop_location") as? String
    }


    //--------------------------------------
    // MARK: - NVActivityIndicatorview
    //--------------------------------------

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

    //--------------------------------------
    // MARK: - Alert-custom
    //--------------------------------------

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func cancelschedulerequest() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            let idstr: String=userId
            let numberFromString = Int(idstr)
            paramDict["id"]=numberFromString
            paramDict["token"]=userTokenstr
            paramDict["request_id"]=self.appdel.historyrequestid
            let url = helperObject.BASEURL + helperObject.cancelschedule
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
                            self.navigationController?.view.showToast("Schedule Cancelled")
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "scheduledetailsvc") as! scheduledetailsvc
//                            self.navigationController?.pushViewController(vc, animated: true)
//                            self.performSegue(withIdentifier: "seguefromcancelledtohistory", sender: self)
                            //self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popToRootViewController(animated: true)
                        } else if(theSuccess == false) {
                            print("Response Fail")
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Unable to cancel scheduled trip request.")
                        }
                    }
            }
        } else {
            print("disConnected")
            self.alert(message: "Please Check Your Internet Connection", title: "No Internet")
        }

    }
}
