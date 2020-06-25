//
//  cancelledhistoryvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/03/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData
import Alamofire
import GoogleMaps

class CancelledHistoryVC: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapview: GMSMapView!

    @IBOutlet var starratingBtn1: UIButton!
    @IBOutlet var starratingBtn2: UIButton!
    @IBOutlet var starratingBtn3: UIButton!
    @IBOutlet var starratingBtn4: UIButton!
    @IBOutlet var starratingBtn5: UIButton!

    @IBOutlet var driverprofilepicture: UIImageView!

    @IBOutlet var drivernamelbl: UILabel!

    @IBOutlet var tripstatusimageview: UIImageView!

    @IBOutlet var pickupaddrlbl: UILabel!
    @IBOutlet var dropupaddrlbl: UILabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var invoiceImgView: UIImageView!

    var historydict = NSDictionary()

    var activityView: NVActivityIndicatorView!

    let appdel=UIApplication.shared.delegate as!AppDelegate

    let helperObject = APIHelper()

    var userTokenstr : String=""
    var userId: String=""

    var marker = GMSMarker()
    var desmarker = GMSMarker()

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="History Details"
        self.getUser()
        self.gethistorydetails()
        self.setUpViews()
    }

    //------------------------------------------
    // MARK: - Back button navigation
    //------------------------------------------

    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func setUpViews()
    {
        self.pickupaddrlbl.font = UIFont.appFont(ofSize: 14)
        self.dropupaddrlbl.font = UIFont.appFont(ofSize: 14)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        starratingBtn1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn1"] = starratingBtn1
        starratingBtn2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn2"] = starratingBtn2
        starratingBtn3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn3"] = starratingBtn3
        starratingBtn4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn4"] = starratingBtn4
        starratingBtn5.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn5"] = starratingBtn5
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverprofilepicture"] = driverprofilepicture
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivernamelbl"] = drivernamelbl
        tripstatusimageview.contentMode = .scaleAspectFit
        tripstatusimageview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripstatusimageview"] = tripstatusimageview
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator1"] = separator1
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupaddrlbl"] = pickupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropupaddrlbl"] = dropupaddrlbl
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceImgView"] = invoiceImgView
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator2"] = separator2

        mapview.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[mapview(150)]-(20)-[driverprofilepicture(50)]-(10)-[separator1(1)]-(15)-[pickupaddrlbl(40)]-(5)-[dropupaddrlbl(10)]-(15)-[separator2(1)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[driverprofilepicture]-(>=10)-[tripstatusimageview]", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[driverprofilepicture(50)]-(15)-[drivernamelbl]-(15)-[tripstatusimageview(40)]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[driverprofilepicture]-(15)-[starratingBtn1(17)]", options: [APIHelper.appLanguageDirection,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[starratingBtn1][starratingBtn2(17)][starratingBtn3(17)][starratingBtn4(17)][starratingBtn5(17)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(30)]-(5)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[invoiceImgView]-(5)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator1]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator2]|", options: [], metrics: nil, views: layoutDic))
    }

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        //create a fetch request, telling it about the entity
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

    //--------------------------------------
    // MARK: - Populating map info
    //--------------------------------------

    func setupmap() {
        let latdouble=self.historydict.value(forKey: "pick_latitude")
        let longdouble=self.historydict.value(forKey: "pick_longitude")

        let destlatdouble=self.historydict.value(forKey: "drop_latitude")
        let destlondouble=self.historydict.value(forKey: "drop_longitude")

        let camera = GMSCameraPosition.camera(withLatitude: latdouble! as! CLLocationDegrees, longitude: longdouble! as! CLLocationDegrees, zoom: 14)
        mapview.camera=camera

        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
        marker.icon = UIImage(named: "pickup_pin")
        marker.appearAnimation = .pop
        marker.map = mapview

        desmarker.position = CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees)
        desmarker.icon = UIImage(named: "destination_pin")
        desmarker.appearAnimation = .pop
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
//        let driverdict = self.historydict.value(forKey: "driver") as! NSDictionary
        self.driverprofilepicture.layer.masksToBounds=true
        self.driverprofilepicture.layer.cornerRadius=self.driverprofilepicture.layer.frame.width/2

//        self.driverprofilepicture.downloadImageFrom111(link: driverdict.value(forKey: "profile_pic") as! String, contentMode: UIViewContentMode.scaleToFill)
//
//        let fnstr=driverdict.value(forKey: "firstname") as! String
//        let lnstr=driverdict.value(forKey: "lastname") as! String
//        let namestr : String = fnstr + " " + lnstr
//        self.drivernamelbl.text = namestr

//        let driverreview = driverdict.value(forKey: "review")
//        let strr : String=driverreview as! String
//        var strint=Int()
//        strint = Int(Float(strr)!)
//        print(strr)
//        if(strint==1)
//        {
//            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn2.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//        }
//        else if(strint==2)
//        {
//            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//        }
//        else if(strint==3)
//        {
//            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//        }
//        else if(strint==4)
//        {
//            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//        }
//        else if(strint==5)
//        {
//            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            self.starratingBtn5.setBackgroundImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//        }

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
    // MARK: - Alert - custom
    //--------------------------------------

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


