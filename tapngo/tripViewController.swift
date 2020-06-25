

//
//  tripViewController.swift
//  tapngo
//
//  Created by Mohammed Arshad on 11/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reservedpickUpLat.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView
import Alamofire
import SocketIO
import Kingfisher

class tripViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    var lbl = UITextView()

    struct CancellationList:Codable {
        var success:Bool
        var successMessage:String
        var reason:[CancelReason]
    }
    struct CancelReason:Codable {
        var id:Int
        var cancellationFeeName:String
    }

    var cancelReasonList:[CancelReason]?
    var selectedCancelReason: CancelReason?

    var window1: UIWindow?
    var currentuserid: String! = ""
    var currentusertoken: String! = ""
    var activityView: NVActivityIndicatorView!
    let helperObject = APIHelper()
    var paymenttypearray=NSMutableArray()
    var paymenttypeimagearray=NSMutableArray()
    var marker = GMSMarker()
    var drivermarker = GMSMarker()
    var tapGesture1: UISwipeGestureRecognizer!
    var tapGesture11: UISwipeGestureRecognizer!
    var locationManager: CLLocationManager!
    var locValue:CLLocationCoordinate2D!
    var location=CLLocation()
    let geoCoder = CLGeocoder()

    var pickUpLat: String! = ""
    var pickUpLong: String! = ""

    var selectedpaymentoption=Int()

    @IBOutlet weak var mapview: GMSMapView!

    @IBOutlet var selectedcarnameLbl: UILabel!


    var jsonString11 = NSString()
    var jsonString1 = NSString()
    var jsonString = NSString()
    var driverphonenumber = NSString()
    var pathdrawn = NSString()
    

    @IBOutlet var confirmbookingbtn: UIButton!


//    etapaymentview
    @IBOutlet var etapaymentview: UIView!
    @IBOutlet var etaview: UIView!
    @IBOutlet var etaLbl: UILabel!
    @IBOutlet var  paymenttypeIv: UIImageView!
    @IBOutlet var paymenttypeLbl: UILabel!
    @IBOutlet var paymenttypeselectbtn: UIButton!
    @IBOutlet weak var etaViewBtn: UIButton!
    @IBOutlet weak var downArrowImgView: UIImageView!

    //pickupview
    @IBOutlet var pickupview: UIView!
    @IBOutlet var pickupcolorview: UIView!
    @IBOutlet var pickupaddrLbl: UILabel!

    //dropview
    @IBOutlet var dropview: UIView!
    @IBOutlet var dropcolorview: UIView!
    @IBOutlet var dropaddrLbl: UILabel!
    @IBOutlet weak var changeDropBtn: UIButton!

    //waitingView
    @IBOutlet var waitingfordriverview: UIView!
    @IBOutlet weak var waitingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var waitingfordriverLbl: UILabel!
    @IBOutlet var waitingfordrivercancelBtn: UIButton!
//promodetailsView
    @IBOutlet var promodetailsView: UIView!
    @IBOutlet var promodetailsViewheaderlbl: UILabel!
    @IBOutlet var promodetailsViewTfd: UITextField!
    @IBOutlet var promodetailsViewapplyBtn: UIButton!
    @IBOutlet var promodetailsViewcancelBtn: UIButton!


    let appdel=UIApplication.shared.delegate as!AppDelegate

    var tripstatustimer: Timer!
    var requestdetailsdict=NSDictionary()

    var requestdetailsarray=NSMutableArray()

//    @IBOutlet weak var searchview: UIView!
//    @IBOutlet weak var searchtfdview: UIView!
//
//    @IBOutlet weak var searchlistTbv: UITableView!
//    @IBOutlet weak var searchviewheaderLbl: UILabel!
//
//    @IBOutlet weak var searchTfd: UITextField!

    var placenamearray = NSMutableArray()
    var favlistidarray = NSMutableArray()
    var placeaddressarray = NSMutableArray()
    var addressarray = NSMutableArray()
    var isfavouritearray = NSMutableArray()

    var arr=NSArray()
    var descrarr=NSArray()
    //let socket = SocketIOClient(socketURL: NSURL(string: "http://tapngo.online: 3001")! as URL)

//    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.18: 3001")! as URL)

    //let socket = SocketIOClient(socketURL: APIHelper.socketUrl)
    let socket = SocketIOClient(socketURL: APIHelper.socketUrl,
                                config: SocketIOClientConfiguration(arrayLiteral: .reconnects(true),.reconnectAttempts(-1),.nsp("/home")))

//    @IBOutlet weak var cancelview: UIView!
//    @IBOutlet weak var cancellbl: UILabel!

//    @IBOutlet weak var callview: UIView!
//    @IBOutlet weak var calllbl: UILabel!

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!

    @IBOutlet weak var promoview: UIView!
    @IBOutlet weak var promoSep1: UIView!
    @IBOutlet weak var promoSep2: UIView!



    //driverstatusview
    @IBOutlet var driverstatusview: UIView!
    @IBOutlet var drivernamelbl: UILabel!
    @IBOutlet var driverprofilepicture: UIImageView!
    @IBOutlet var drivervehicletypelbl: UILabel!
    @IBOutlet var drivervehiclenumberlbl: UILabel!
    @IBOutlet var starratingBtn1: UIButton!
    @IBOutlet var starratingBtn2: UIButton!
    @IBOutlet var starratingBtn3: UIButton!
    @IBOutlet var starratingBtn4: UIButton!
    @IBOutlet var starratingBtn5: UIButton!
    @IBOutlet weak var driverStatusSepartor: UIView!



    @IBOutlet var tripstatusview: UIView!
    @IBOutlet var tripstatuscolorview: UIView!
    @IBOutlet var tripstatuslbl: UILabel!

    var requestid = NSString()

    @IBOutlet var canceldetailsview: UIView!
    @IBOutlet weak var canceldetailsheaderlbl: UILabel!
    @IBOutlet weak var cancelViewSeparator: UIView!
    @IBOutlet weak var canceldetailslisttbv: UITableView!
    @IBOutlet var canceldetailsviewcancelbtn: UIButton!
    @IBOutlet var canceldetailsviewdontcancelbtn: UIButton!

    var cancelreasonaray=NSMutableArray()

    var cellselectedarray=NSMutableArray()
    var dummyarray=NSMutableArray()
    var cancelreasonstring: String! = ""
    var cancelreasonDigit:Int!

    @IBOutlet var distancelbl: UILabel!
    @IBOutlet var distanceheaderlbl: UILabel!

    @IBOutlet var promolbl: UILabel!
    @IBOutlet var promoheaderlbl: UILabel!
    @IBOutlet var promobtn: UIButton!

    @IBOutlet var paylbl: UILabel!
    @IBOutlet var payheaderlbl: UILabel!
    var i=Int()



    var dropLatStr: String! = ""
    var dropLongStr: String! = ""

    var drivermarkerLatStr: String! = ""
    var drivermarkerLongStr: String! = ""
    var drivermarkerBearing: String! = ""

    var drivermarkerLong=Double()
    var drivermarkerLat=Double()
    var drivermarkerrBearing: Double?

    var drivermarkerpickLong=Double()
    var drivermarkerpickLat=Double()

    var polyline = GMSPolyline()

    var ddd = ""

    @IBOutlet var gestureview: UIView!
    var currency = ""

    var tripresumefirstname = ""
    var tripresumelastname = ""
    var tripresumephonenumber = ""
    var tripresumedriverprofilepicture = ""
    var tripresumedrivercarnumber = ""
    var tripresumedrivercarmodel = ""
    var tripresumedriverreview = ""

    var tripetaoriginlat = ""
    var tripetaoriginlon = ""
    var tripetadestlat = ""
    var tripetadestlon = ""
    var tripetavehicletypeid = ""

    var tripcompleted = ""


    var tripdetailsdict=NSDictionary()
//paymentview
    var paymentview = UIView()
    var paymentviewheaderlbl = UILabel()
    var paymentViewCloseBtn = UIButton()
    var paymenttbv = UITableView()


//faredetailsview
    @IBOutlet var faredetailsview: UIView!
    @IBOutlet var farederailsviewheaderlbl: UILabel!
    @IBOutlet weak var fareDetailsUL1: UIView!
    @IBOutlet var getfaredetailsbtn: UIButton!
    @IBOutlet var ridefarelbl: UILabel!
    @IBOutlet var taxheaderlbl: UILabel!
    @IBOutlet var taxlbl: UILabel!
    @IBOutlet weak var fareDetailsUL2: UIView!
    @IBOutlet var totalheaderlbl: UILabel!
    @IBOutlet var totallbl: UILabel!
    @IBOutlet var noteHintLb: UILabel!
    @IBOutlet var hintlbllbl: UILabel!
    @IBOutlet var gotitbtn: UIButton!
//faredetview
    @IBOutlet var faredetview: UIView!
    @IBOutlet var bfheaderlbl: UILabel!
    @IBOutlet var bflbl: UILabel!
    @IBOutlet var rateperkmheaderlbl: UILabel!
    @IBOutlet var rateperkmlbl: UILabel!
    @IBOutlet var ridetimechargeheaderlbl: UILabel!
    @IBOutlet var ridetimechargelbl: UILabel!
    @IBOutlet var taxesextralbl: UILabel!
    @IBOutlet var faredetbtn: UIButton!
    @IBOutlet var gitbtn: UIButton!

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var selectedPickUpLocation:SearchLocation?
    var selectedDropLocation:SearchLocation?
    var dropLocationSelectedClousure:((SearchLocation) -> Void)?
    var animatedPolyline:AnimatedPolyLine!
    var pickUpMarker: GMSMarker?
    var dropMarker: GMSMarker?
    var selectedCarModel: CarModel!

    var totalstr:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.drawRouteOnMap(false)

        self.dropLocationSelectedClousure = { selectedSearchLoc in
            print(selectedSearchLoc)
            self.selectedDropLocation = selectedSearchLoc
            if let selectedDropLocationplaceId = self.selectedDropLocation?.placeId {
                self.dropaddrLbl.text = selectedDropLocationplaceId
            }

            if selectedSearchLoc.locationType == .googleSearch {
                self.getCoordinatesFromPlaceId(selectedSearchLoc.googlePlaceId!, completion: { locCoordinate in

                    self.selectedDropLocation?.latitude = locCoordinate.latitude
                    self.selectedDropLocation?.longitude = locCoordinate.longitude
                    self.drawRouteOnMap(false)
                })
            }
            else {
                self.drawRouteOnMap(false)
            }
        }


//        do {
//
//            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
//                self.mapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//                print("Unable to find mapStyle.json")
//            }
//        } catch {
//            print("One or more of the map styles failed to load. \(error)")
//        }



//        let bounds = GMSCoordinateBounds(coordinate: self.selectedPickUpLocation.coordinate, coordinate: self.selectedDropLocation.coordinate)
//        mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
//        mapview.animate(toBearing: self.selectedPickUpLocation.coordinate.bearing(to: self.selectedDropLocation.coordinate)-40)
//        self.fetchMapData()
//        self.pathdrawn="YES"
        self.setUpViews()
        if(self.appdel.tripJSON.count>0)
        {
            cancelreasonaray=["Expected ashorter waiting time", "Long walk to pickup point", "Unable to contact driver", "Driver denied duty", "Cab is not moving in my direction", "My reason is not listed"]
            paymenttypeimagearray=["paymentcash", "addcardicon", "paymentwallet"]
            cellselectedarray=["NO", "NO", "NO", "NO", "NO", "NO"]
            dummyarray=["NO", "NO", "NO", "NO", "NO", "NO"]
            self.dropview.layer.borderWidth=0.2
            self.dropview.layer.borderColor=UIColor.lightGray.cgColor

            self.tripstatuscolorview.layer.borderWidth=0.2
            self.tripstatuscolorview.layer.cornerRadius=self.tripstatuscolorview.frame.size.width/2
            ddd="first"
            self.promodetailsViewTfd.layer.borderWidth=0.2
            self.promodetailsViewTfd.layer.cornerRadius=5
            self.promodetailsViewTfd.layer.borderColor = UIColor.lightGray.cgColor
            self.promodetailsViewTfd.leftViewMode = .always
            self.promodetailsViewTfd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            self.dropview.layer.cornerRadius=5
            self.dropcolorview.layer.cornerRadius=5
            self.pickupcolorview.layer.cornerRadius=5
            self.etaview.layer.cornerRadius=5

//            if(self.appdel.selectedcartypename.count>0)
//            {
//                self.title=self.appdel.selectedcartypename
//            }
            self.pickupaddrLbl.text=self.appdel.fromaddr
            self.dropaddrLbl.text=self.appdel.toaddr
            self.getUser()
            //self.getetaapicall()
            paymenttypearray=["Cash", "Card", "Wallet"]
            if self.selectedCarModel != nil {
                if let carName = self.selectedCarModel.name {
                    self.selectedcarnameLbl.text = carName
                }
            }
//            self.selectedcarnameLbl.text = self.selectedCarModel.name!
//            self.getfavouritelistApi()
            self.connectsocket()

//            self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
//            self.tapGesture1.delegate = self
//            self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
//            self.driverstatusview.addGestureRecognizer(self.tapGesture1)
//
//            self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
//            self.tapGesture11.delegate = self
//            self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
//            self.tripstatusview.addGestureRecognizer(self.tapGesture1)
//
//
//            let swipeRightOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightswipedetected))
//            swipeRightOrange.direction = .right
//            self.tripstatusview.addGestureRecognizer(swipeRightOrange)
//
//            let swipeLeftOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftswipedetected))
//            swipeLeftOrange.direction = .left
//            self.driverstatusview.addGestureRecognizer(swipeLeftOrange)

            self.tripstatuscolorview.backgroundColor=UIColor.green
            i=0
            let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            print(timer)

            starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            
            self.paymenttbv.separatorStyle=UITableViewCell.SeparatorStyle.none
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
            self.gestureview.addGestureRecognizer(tapGesture)
            
            self.gettripstatus()
            self.drawRouteOnMap(false)
            
        } else {
                    cancelreasonaray=["Expected ashorter waiting time", "Long walk to pickup point", "Unable to contact driver", "Driver denied duty", "Cab is not moving in my direction", "My reason is not listed"]
                    paymenttypeimagearray=["paymentcash", "addcardicon", "paymentwallet"]
                    cellselectedarray=["NO", "NO", "NO", "NO", "NO", "NO"]
                    dummyarray=["NO", "NO", "NO", "NO", "NO", "NO"]
                    self.dropview.layer.borderWidth=0.2
                    self.dropview.layer.borderColor=UIColor.lightGray.cgColor
                    self.tripstatuscolorview.layer.borderWidth=0.2
                    self.tripstatuscolorview.layer.cornerRadius=self.tripstatuscolorview.frame.size.width/2
                    ddd="first"
                    self.promodetailsViewTfd.layer.cornerRadius = 5
                    self.promodetailsViewTfd.leftViewMode = .always
                    self.promodetailsViewTfd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
                    self.dropview.layer.cornerRadius=5
                    self.dropcolorview.layer.cornerRadius=5
                    self.pickupcolorview.layer.cornerRadius=5
                    self.etaview.layer.cornerRadius=5
            //        if(self.appdel.selectedcartypename.count>0)
            //        {
            //            self.title=self.appdel.selectedcartypename
            //        }
                    self.pickupaddrLbl.text=self.appdel.fromaddr
                    self.dropaddrLbl.text=self.appdel.toaddr
                    self.getUser()
                    self.getetaapicall()
                    paymenttypearray=["Cash", "Card", "Wallet"]
                        if self.selectedCarModel != nil {
                            if let carName = self.selectedCarModel.name {
                                self.selectedcarnameLbl.text = carName
                            }
                        }
                   // self.selectedcarnameLbl.text = self.selectedCarModel.name
            //        self.getfavouritelistApi()
                    self.connectsocket()
            
            //        self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
            //        self.tapGesture1.delegate = self
            //        self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
            //        self.driverstatusview.addGestureRecognizer(self.tapGesture1)
            //
            //        self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
            //        self.tapGesture11.delegate = self
            //        self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
            //        self.tripstatusview.addGestureRecognizer(self.tapGesture1)
            //
            //        let swipeRightOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightswipedetected))
            //        swipeRightOrange.direction = .right
            //        self.tripstatusview.addGestureRecognizer(swipeRightOrange)
            //        let swipeLeftOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftswipedetected))
            //        swipeLeftOrange.direction = .left
            //        self.driverstatusview.addGestureRecognizer(swipeLeftOrange)
                    self.tripstatuscolorview.backgroundColor=UIColor.green
                    i=0
                    let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    print(timer)
            starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.paymenttbv.separatorStyle=UITableViewCell.SeparatorStyle.none
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
                    self.gestureview.addGestureRecognizer(tapGesture)
            
        }
//        else
//        {
//
//            if (self.appdel.isdriverstarted=="1" && self.appdel.isdriverarrived=="0" && self.appdel.istripstarted=="0" && self.appdel.iscompleted=="0") {
//                self.navigationItem.leftBarButtonItem = nil
////                self.title="TapnGo"
//                self.tripstatuslbl.text = "Driver Accepted"
//                self.gettripdata()
//                self.getdriverdatadata()
//                self.waitingfordriverview.isHidden=true
//                self.etapaymentview.isHidden=true
//                self.pickupview.isHidden=true
//                self.dropview.isHidden=true
//                self.confirmbookingbtn.isHidden=true
//                self.promoview.isHidden=false
////                self.cancelview.isHidden=false
//                self.cancelBtn.isHidden=false
////                self.callview.isHidden=false
//                self.callBtn.isHidden = false
//                if(self.pathdrawn=="") {
//                    self.fetchMapData()
//                    self.pathdrawn="YES"
//                }
//
//
////                if(self.tripstatusview.isHidden==true) {
////                    self.driverstatusview.isHidden=false
////                }
////                else {
////                    self.driverstatusview.isHidden=true
////                }
////
////                self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
////                self.tapGesture1.delegate = self
////                self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
////                self.driverstatusview.addGestureRecognizer(self.tapGesture1)
////
////                self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
////                self.tapGesture11.delegate = self
////                    self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
////                self.tripstatusview.addGestureRecognizer(self.tapGesture1)
//
//
//            let fnstr=tripresumefirstname
//            let lnstr=tripresumelastname
//            let namestr: String = fnstr + " " + lnstr
//            self.drivernamelbl.text = namestr
//
//            let driverphonenumber1=tripresumephonenumber
//            self.driverphonenumber=driverphonenumber1 as NSString
//
//            if(tripresumedriverprofilepicture.count>0) {
////                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
////                indicator.center = self.driverprofilepicture.center
////                self.view.addSubview(indicator)
////                indicator.startAnimating()
//                let profilePictureURL = URL(string: tripresumedriverprofilepicture)!
//                let resource = ImageResource(downloadURL: profilePictureURL)
//                self.driverprofilepicture.kf.indicatorType = .activity
//                self.driverprofilepicture.kf.setImage(with: resource)
//
////                let session = URLSession(configuration: .default)
////                let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
////                    // The download has finished.
////                    if let e = error {
////                        print("Error downloading cat picture: \(e)")
////                    } else {
////                        if (response as? HTTPURLResponse) != nil {
////                            if let imageData = data {
////                                DispatchQueue.global(qos: .background).async {
////                                        indicator.stopAnimating()
////                                        let image = UIImage(data: imageData)
////                                        self.driverprofilepicture.image=image
////                                }
////                            } else {
////                                indicator.stopAnimating()
////                                self.alert(message: "Couldn't get image: Image is nil")
////                            }
////                        } else {
////                            indicator.stopAnimating()
////                            self.alert(message: "Couldn't get response code for some reason")
////                        }
////                    }
////                }
////                downloadPicTask.resume()
//            }
//
//                self.drivervehicletypelbl.text=tripresumedrivercarmodel
//                self.drivervehiclenumberlbl.text=tripresumedrivercarnumber
//
//                let strr: String=tripresumedriverreview
//                var strint=Int()
//                strint = Int(Float(strr)!)
//                print(strr)
//                if(strint==1) {
//                    self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn2.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                }
//                else if(strint==2) {
//                    self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                }
//                else if(strint==3) {
//                    self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                    self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                } else if(strint==4) {
//                    self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                }
//                else if(strint==5) {
//                    self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                    self.starratingBtn5.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                }
//        }
//        else if (self.appdel.isdriverstarted=="1" && self.appdel.isdriverarrived=="1" && self.appdel.istripstarted=="0" && self.appdel.iscompleted=="0")
//        {
//            self.navigationItem.leftBarButtonItem = nil
////            self.title="TapnGo"
//            self.tripstatuslbl.text = "Driver Arrived"
//            self.gettripdata()
//            self.getdriverdatadata()
//            self.waitingfordriverview.isHidden=true
//            self.etapaymentview.isHidden=true
//            self.pickupview.isHidden=true
//            self.dropview.isHidden=true
//            self.confirmbookingbtn.isHidden=true
//            self.promoview.isHidden=false
////            self.cancelview.isHidden=false
//            self.cancelBtn.isHidden=false
////            self.callview.isHidden=false
//            self.callBtn.isHidden = false
//            if(self.pathdrawn=="") {
//                self.fetchMapData()
//                self.pathdrawn="YES"
//            }
//
////            if(self.tripstatusview.isHidden==true) {
////                self.driverstatusview.isHidden=false
////            }
////            else {
////                self.driverstatusview.isHidden=true
////            }
////
////            self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
////            self.tapGesture1.delegate = self
////            self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
////            self.driverstatusview.addGestureRecognizer(self.tapGesture1)
////
////            self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
////            self.tapGesture11.delegate = self
////            self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
////            self.tripstatusview.addGestureRecognizer(self.tapGesture1)
//
//
//            let fnstr=tripresumefirstname
//            let lnstr=tripresumelastname
//            let namestr: String = fnstr + " " + lnstr
//            self.drivernamelbl.text = namestr
//
//            let driverphonenumber1=tripresumephonenumber
//            self.driverphonenumber=driverphonenumber1 as NSString
//
//            if(tripresumedriverprofilepicture.count>0) {
////                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
////                indicator.center = self.driverprofilepicture.center
////                self.view.addSubview(indicator)
////                indicator.startAnimating()
//                let profilePictureURL = URL(string: tripresumedriverprofilepicture)!
//                self.driverprofilepicture.kf.indicatorType = .activity
//                let resource = ImageResource(downloadURL: profilePictureURL)
//                self.driverprofilepicture.kf.setImage(with: resource)
//
////                let session = URLSession(configuration: .default)
////                let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
////                    // The download has finished.
////                    if let e = error {
////                        print("Error downloading cat picture: \(e)")
////                    } else {
////                        if (response as? HTTPURLResponse) != nil {
////                            if let imageData = data {
////                                DispatchQueue.global(qos: .background).async {
////                                        indicator.stopAnimating()
////                                        let image = UIImage(data: imageData)
////                                        self.driverprofilepicture.image=image
////                                }
////                            } else {
////                                indicator.stopAnimating()
////                                self.alert(message: "Couldn't get image: Image is nil")
////                            }
////                        } else {
////                            indicator.stopAnimating()
////                            self.alert(message: "Couldn't get response code for some reason")
////                        }
////                    }
////                }
////                downloadPicTask.resume()
//            }
//
//            self.drivervehicletypelbl.text=tripresumedrivercarmodel
//            self.drivervehiclenumberlbl.text=tripresumedrivercarnumber
//
//            let strr: String=tripresumedriverreview
//            var strint=Int()
//            strint = Int(Float(strr)!)
//            print(strr)
//            if(strint==1) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==2) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==3) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==4) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==5) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            }
//        }
//        else if (self.appdel.isdriverstarted=="1" && self.appdel.isdriverarrived=="1" && self.appdel.istripstarted=="1" && self.appdel.iscompleted=="0")
//        {
//            self.navigationItem.leftBarButtonItem = nil
////            self.title="TapnGo"
//            self.tripstatuslbl.text = "Trip Started"
//            self.gettripdata()
//            self.getdriverdatadata()
//            self.waitingfordriverview.isHidden=true
//            self.etapaymentview.isHidden=true
//            self.pickupview.isHidden=true
//            self.dropview.isHidden=true
//            self.confirmbookingbtn.isHidden=true
//            self.promoview.isHidden=false
////            self.cancelview.isHidden=false
//            self.cancelBtn.isHidden=false
////            self.callview.isHidden=false
//            self.callBtn.isHidden = false
//            if(self.pathdrawn=="") {
//                self.fetchMapData()
//                self.pathdrawn="YES"
//            }
//
////            if(self.tripstatusview.isHidden==true) {
////                self.driverstatusview.isHidden=false
////            }
////            else {
////                self.driverstatusview.isHidden=true
////            }
////
////            self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
////            self.tapGesture1.delegate = self
////            self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
////            self.driverstatusview.addGestureRecognizer(self.tapGesture1)
////
////            self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
////            self.tapGesture11.delegate = self
////            self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
////            self.tripstatusview.addGestureRecognizer(self.tapGesture1)
//
//
//            let fnstr=tripresumefirstname
//            let lnstr=tripresumelastname
//            let namestr: String = fnstr + " " + lnstr
//            self.drivernamelbl.text = namestr
//
//            let driverphonenumber1=tripresumephonenumber
//            self.driverphonenumber=driverphonenumber1 as NSString
//
//            if(tripresumedriverprofilepicture.count>0) {
////                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
////                indicator.center = self.driverprofilepicture.center
////                self.view.addSubview(indicator)
////                indicator.startAnimating()
//                let profilePictureURL = URL(string: tripresumedriverprofilepicture)!
//                self.driverprofilepicture.kf.indicatorType = .activity
//                let resource = ImageResource(downloadURL: profilePictureURL)
//                self.driverprofilepicture.kf.setImage(with: resource)
//
////
////                let session = URLSession(configuration: .default)
////                let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
////                    // The download has finished.
////                    if let e = error {
////                        print("Error downloading cat picture: \(e)")
////                    } else {
////                        if (response as? HTTPURLResponse) != nil {
////                            if let imageData = data {
////                                DispatchQueue.global(qos: .background).async {
////                                        indicator.stopAnimating()
////                                        let image = UIImage(data: imageData)
////                                        self.driverprofilepicture.image=image
////                                }
////                            } else {
////                                indicator.stopAnimating()
////                                self.alert(message: "Couldn't get image: Image is nil")
////                            }
////                        } else {
////                            indicator.stopAnimating()
////                            self.alert(message: "Couldn't get response code for some reason")
////                        }
////                    }
////                }
////                downloadPicTask.resume()
//            }
//            self.drivervehicletypelbl.text=tripresumedrivercarmodel
//            self.drivervehiclenumberlbl.text=tripresumedrivercarnumber
//            let strr: String=tripresumedriverreview
//            var strint=Int()
//            strint = Int(Float(strr)!)
//            print(strr)
//            if(strint==1) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==2) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==3) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==4) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "blank_stare"), for: UIControlState.normal)
//            }
//            else if(strint==5) {
//                self.starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn2.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn3.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn4.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//                self.starratingBtn5.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//            }
//            self.promoview.isUserInteractionEnabled=false
////            self.cancelview.isUserInteractionEnabled=false
//            self.cancelBtn.isEnabled = false
//            self.promolbl.backgroundColor=UIColor.lightGray
//            self.promoheaderlbl.backgroundColor=UIColor.lightGray
////            self.cancelview.backgroundColor=UIColor.lightGray
//            self.cancelBtn.backgroundColor = .lightGray
//        }
//        else if (self.appdel.isdriverstarted=="1" && self.appdel.isdriverarrived=="1" && self.appdel.istripstarted=="1" && self.appdel.iscompleted=="1")
//        {
//            tripcompleted="yes"
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedbackvc") as! feedbackvc
//            self.navigationController?.pushViewController(vc, animated: true)
////            self.performSegue(withIdentifier: "seguefromtriptofeedback", sender: self)
//        }
//        cancelreasonaray=["Expected ashorter waiting time", "Long walk to pickup point", "Unable to contact driver", "Driver denied duty", "Cab is not moving in my direction", "My reason is not listed"]
//        paymenttypeimagearray=["paymentcash", "addcardicon", "paymentwallet"]
//        cellselectedarray=["NO", "NO", "NO", "NO", "NO", "NO"]
//        dummyarray=["NO", "NO", "NO", "NO", "NO", "NO"]
//        self.dropview.layer.borderWidth=0.2
//        self.dropview.layer.borderColor=UIColor.lightGray.cgColor
//        self.tripstatuscolorview.layer.borderWidth=0.2
//        self.tripstatuscolorview.layer.cornerRadius=self.tripstatuscolorview.frame.size.width/2
//        ddd="first"
//        self.promodetailsViewTfd.layer.cornerRadius = 5
//        self.promodetailsViewTfd.leftViewMode = .always
//        self.promodetailsViewTfd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        self.dropview.layer.cornerRadius=5
//        self.dropcolorview.layer.cornerRadius=5
//        self.pickupcolorview.layer.cornerRadius=5
//        self.etaview.layer.cornerRadius=5
////        if(self.appdel.selectedcartypename.count>0)
////        {
////            self.title=self.appdel.selectedcartypename
////        }
//        self.pickupaddrLbl.text=self.appdel.fromaddr
//        self.dropaddrLbl.text=self.appdel.toaddr
//        self.getUser()
//        self.getetaapicall()
//        paymenttypearray=["Cash", "Card", "Wallet"]
//            if self.selectedCarModel != nil {
//                if let carName = self.selectedCarModel.name {
//                    self.selectedcarnameLbl.text = carName
//                }
//            }
//       // self.selectedcarnameLbl.text = self.selectedCarModel.name
////        self.getfavouritelistApi()
//        self.connectsocket()
//
////        self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
////        self.tapGesture1.delegate = self
////        self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
////        self.driverstatusview.addGestureRecognizer(self.tapGesture1)
////
////        self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
////        self.tapGesture11.delegate = self
////        self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
////        self.tripstatusview.addGestureRecognizer(self.tapGesture1)
////
////        let swipeRightOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightswipedetected))
////        swipeRightOrange.direction = .right
////        self.tripstatusview.addGestureRecognizer(swipeRightOrange)
////        let swipeLeftOrange: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftswipedetected))
////        swipeLeftOrange.direction = .left
////        self.driverstatusview.addGestureRecognizer(swipeLeftOrange)
//        self.tripstatuscolorview.backgroundColor=UIColor.green
//        i=0
//        let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//        print(timer)
//        starratingBtn1.setImage(UIImage(named: "fill_star"), for: UIControlState.normal)
//        self.paymenttbv.separatorStyle=UITableViewCellSeparatorStyle.none
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
//        self.gestureview.addGestureRecognizer(tapGesture)
//        }
 //       self.setUpViews()
    }
    
    func updateStatus() {
        
         lbl = UITextView(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 20, width: UIScreen.main.bounds.width/2, height: 120))
        socket.on(clientEvent: .statusChange) { (dataArr, _) in
            guard let status = dataArr.first as? SocketIOClientStatus else {
                return
            }
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            if !window.subviews.contains(self.lbl) {
                window.addSubview(self.lbl)
            }
            self.lbl.isHidden = false
            self.lbl.textAlignment = .center
            self.lbl.isUserInteractionEnabled = true
            self.lbl.backgroundColor = .red
            self.lbl.textColor = .black
            switch status {
            case .connected: self.lbl.text = "socket connected"
            case .notConnected: self.lbl.text = "socket notConnected";self.socket.reconnect()
            case .connecting: self.lbl.text = "socket connecting"
            case .disconnected: self.lbl.text = "socket disconnected"
            }
        }
    }

    func setUpViews() {
        self.pickupaddrLbl.font = UIFont.appFont(ofSize: 13)
        self.dropaddrLbl.font = UIFont.appFont(ofSize: 13)
        self.etaLbl.font = UIFont.appFont(ofSize: 15)
        self.selectedcarnameLbl.font = UIFont.appFont(ofSize: 15)
        self.paymentviewheaderlbl.font = UIFont.appBoldFont(ofSize: 18)
        self.paymenttypeLbl.font = UIFont.appFont(ofSize: 15)
        self.etaview.backgroundColor = .themeColor
        self.confirmbookingbtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.confirmbookingbtn.setTitleColor(.themeColor, for: .normal)

//        self.searchviewheaderLbl.font = UIFont.appTitleFont(ofSize: 17)
//        self.searchTfd.font = UIFont.appFont(ofSize: 14)

        self.farederailsviewheaderlbl.font = UIFont.appBoldFont(ofSize: 16)

        self.getfaredetailsbtn.titleLabel?.font = UIFont.appFont(ofSize: 13)
//        self.ridefareheaderlbl.font = UIFont.appFont(ofSize: 13)
        self.ridefarelbl.font = UIFont.appFont(ofSize: 14)
        self.taxheaderlbl.font = UIFont.appFont(ofSize: 13)
        self.taxlbl.font = UIFont.appFont(ofSize: 14)
        self.totalheaderlbl.font = UIFont.appFont(ofSize: 17)
        self.totallbl.font = UIFont.appFont(ofSize: 14)
        self.noteHintLb.font = UIFont.appFont(ofSize: 14)
        self.hintlbllbl.font = UIFont.appFont(ofSize: 14)
        self.gotitbtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.gotitbtn.setTitleColor(.themeColor, for: .normal)

        self.bfheaderlbl.font = UIFont.appFont(ofSize: 14)
        self.bflbl.font = UIFont.appFont(ofSize: 14)
        self.rateperkmheaderlbl.font = UIFont.appFont(ofSize: 14)
        self.rateperkmlbl.font = UIFont.appFont(ofSize: 14)
        self.ridetimechargeheaderlbl.font = UIFont.appFont(ofSize: 14)
        self.ridetimechargelbl.font = UIFont.appFont(ofSize: 14)
        self.taxesextralbl.font = UIFont.appFont(ofSize: 14)
        self.faredetbtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.faredetbtn.setTitleColor(.themeColor, for: .normal)
        self.gitbtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.gitbtn.setTitleColor(.themeColor, for: .normal)

        //ConfirmBooking

        waitingfordriverLbl.font = UIFont.appFont(ofSize: 25)
        waitingfordrivercancelBtn.titleLabel?.font = UIFont.appFont(ofSize: 20)
        self.waitingfordrivercancelBtn.backgroundColor = .themeColor

        //trip

        self.drivernamelbl.font = UIFont.appFont(ofSize: 15)
        self.drivervehicletypelbl.font = UIFont.appFont(ofSize: 12)
        self.drivervehiclenumberlbl.font = UIFont.appFont(ofSize: 11)

        self.drivervehicletypelbl.textColor = .themeColor
        self.drivervehiclenumberlbl.textColor = .themeColor

        self.tripstatuslbl.font = UIFont.appFont(ofSize: 15)

        //cancel
        self.cancelBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.callBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)

        self.distanceheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.distanceheaderlbl.textColor = .themeColor
        self.distancelbl.font = UIFont.appFont(ofSize: 13)
        self.promolbl.font = UIFont.appFont(ofSize: 15)
        self.promolbl.textColor = .themeColor
        self.promoheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.payheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.payheaderlbl.textColor = .themeColor
        self.paylbl.font = UIFont.appFont(ofSize: 13)

//        canceldetails
        self.canceldetailsheaderlbl.font = UIFont.appFont(ofSize: 20)
        canceldetailsviewcancelbtn.titleLabel?.font = UIFont.appFont(ofSize: 18)
        self.canceldetailsviewcancelbtn.setTitleColor(.themeColor, for: .normal)
        canceldetailsviewdontcancelbtn.titleLabel?.font = UIFont.appFont(ofSize: 18)
        self.canceldetailsviewdontcancelbtn.setTitleColor(.themeColor, for: .normal)

        // Promodetailsview
        self.promodetailsViewheaderlbl.font = UIFont.appFont(ofSize: 17)
        self.promodetailsViewTfd.font = UIFont.appFont(ofSize: 15)
        promodetailsViewapplyBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.promodetailsViewapplyBtn.setTitleColor(.themeColor, for: .normal)
        promodetailsViewcancelBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.promodetailsViewcancelBtn.setTitleColor(.themeColor, for: .normal)

        let backBtn = UIButton()
        backBtn.backgroundColor = .themeColor
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.imageView?.tintColor = .secondaryColor
        layoutDic["backBtn"] = backBtn
        backBtn.setImage(UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.insertSubview(backBtn, belowSubview: waitingfordriverview)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[backBtn(40)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[backBtn(40)]", options: [], metrics: nil, views: layoutDic))

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        selectedcarnameLbl.textAlignment = .center
        selectedcarnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["selectedcarnameLbl"] = selectedcarnameLbl

        //paymentview
        paymenttbv.register(PaymentTableViewCell.self, forCellReuseIdentifier: "paymentTableViewCell")
        self.view.addSubview(paymentview)
        paymentview.backgroundColor = .white
        paymentview.isHidden = true
        paymentview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentview"] = paymentview

        paymentview.addSubview(paymentViewCloseBtn)
        paymentViewCloseBtn.backgroundColor = .red
        paymentViewCloseBtn.setTitle("Close", for: .normal)
        paymentViewCloseBtn.addTarget(self, action: #selector(paymentviewclosebtnAction), for: .touchUpInside)
        paymentViewCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentViewCloseBtn"] = paymentViewCloseBtn

        paymentview.addSubview(paymentviewheaderlbl)
        paymentviewheaderlbl.textAlignment = .center
        paymentviewheaderlbl.textColor = .black
        paymentviewheaderlbl.text = "Select Payment"
        paymentviewheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentviewheaderlbl"] = paymentviewheaderlbl

        paymenttbv.delegate = self
        paymenttbv.dataSource = self
        paymenttbv.reloadData()
        paymentview.addSubview(paymenttbv)
        paymenttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttbv"] = paymenttbv


        paymenttypeselectbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeselectbtn"] = paymenttypeselectbtn
        confirmbookingbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["confirmbookingbtn"] = confirmbookingbtn
        paymenttypeLbl.sizeToFit()
        paymenttypeLbl.textAlignment = .center
        paymenttypeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeLbl"] = paymenttypeLbl
        paymenttypeIv.contentMode = .scaleAspectFit
        paymenttypeIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeIv"] = paymenttypeIv
        pickupview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupview"] = pickupview

        etaview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaview"] = etaview
        etaLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaLbl"] = etaLbl
        etapaymentview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etapaymentview"] = etapaymentview

        pickupcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupcolorview"] = pickupcolorview
        pickupaddrLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupaddrLbl"] = pickupaddrLbl
        etaViewBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaViewBtn"] = etaViewBtn
        downArrowImgView.contentMode = .scaleAspectFit
        downArrowImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["downArrowImgView"] = downArrowImgView

        //dropview
        dropview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropview"] = dropview
        dropcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropcolorview"] = dropcolorview
        dropaddrLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropaddrLbl"] = dropaddrLbl
        changeDropBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["changeDropBtn"] = changeDropBtn

        //waitingfordriverview
        waitingfordriverview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["waitingfordriverview"] = waitingfordriverview
        waitingActivityIndicator.startAnimating()
        waitingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["waitingActivityIndicator"] = waitingfordriverview
        waitingfordriverLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["waitingfordriverLbl"] = waitingfordriverLbl
        waitingfordrivercancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["waitingfordrivercancelBtn"] = waitingfordrivercancelBtn

        // Promodetailsview
        promodetailsView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promodetailsView"] = promodetailsView
        promodetailsViewheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promodetailsViewheaderlbl"] = promodetailsViewheaderlbl
        promodetailsViewTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promodetailsViewTfd"] = promodetailsViewTfd
        promodetailsViewapplyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promodetailsViewapplyBtn"] = promodetailsViewapplyBtn
        promodetailsViewcancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promodetailsViewcancelBtn"] = promodetailsViewcancelBtn


        cancelBtn.setImage(UIImage(named: "cancel"), for: .normal)
//        cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
//        if APIHelper.appLanguageDirection == .directionLeftToRight {
//            cancelBtn.semanticContentAttribute = .forceRightToLeft
//        } else {
//            cancelBtn.semanticContentAttribute = .forceLeftToRight
//        }
        
       
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.backgroundColor = .white
        cancelBtn.isHidden = true
        layoutDic["cancelBtn"] = cancelBtn
        cancelBtn.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.titleLabel?.centerYAnchor.constraint(equalTo: self.cancelBtn.centerYAnchor, constant: 0).isActive = true
        cancelBtn.titleLabel?.leadingAnchor.constraint(equalTo: self.cancelBtn.leadingAnchor, constant: 10).isActive = true
        cancelBtn.titleLabel?.contentMode = .right
        
        cancelBtn.imageView?.centerYAnchor.constraint(equalTo: self.cancelBtn.centerYAnchor, constant: 0).isActive = true
        cancelBtn.imageView?.trailingAnchor.constraint(equalTo: self.cancelBtn.trailingAnchor, constant: -10).isActive = true
        cancelBtn.imageView?.contentMode = .right
        
        callBtn.setImage(UIImage(named: "calltrip"), for: .normal)
       
        callBtn.backgroundColor = .white
        callBtn.isHidden = true
        callBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["callBtn"] = callBtn
        
        callBtn.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        callBtn.titleLabel?.centerYAnchor.constraint(equalTo: self.callBtn.centerYAnchor, constant: 0).isActive = true
        callBtn.titleLabel?.leadingAnchor.constraint(equalTo: self.callBtn.leadingAnchor, constant: 10).isActive = true
        callBtn.titleLabel?.contentMode = .right

        callBtn.imageView?.centerYAnchor.constraint(equalTo: self.callBtn.centerYAnchor, constant: 0).isActive = true
        callBtn.imageView?.trailingAnchor.constraint(equalTo: self.callBtn.trailingAnchor, constant: -10).isActive = true
        callBtn.imageView?.contentMode = .right

        promoview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promoview"] = promoview

        canceldetailsheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["canceldetailsheaderlbl"] = canceldetailsheaderlbl

        driverstatusview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverstatusview"] = driverstatusview
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivernamelbl"] = drivernamelbl
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverprofilepicture"] = driverprofilepicture
        drivervehicletypelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivervehicletypelbl"] = drivervehicletypelbl
        drivervehiclenumberlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivervehiclenumberlbl"] = drivervehiclenumberlbl
        starratingBtn1.imageView?.contentMode = .scaleAspectFit
        starratingBtn1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn1"] = starratingBtn1
        starratingBtn2.imageView?.contentMode = .scaleAspectFit
        starratingBtn2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn2"] = starratingBtn2
        starratingBtn3.imageView?.contentMode = .scaleAspectFit
        starratingBtn3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn3"] = starratingBtn3
        starratingBtn4.imageView?.contentMode = .scaleAspectFit
        starratingBtn4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn4"] = starratingBtn4
        starratingBtn5.imageView?.contentMode = .scaleAspectFit
        starratingBtn5.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn5"] = starratingBtn5
        driverStatusSepartor.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverStatusSepartor"] = driverStatusSepartor


        tripstatusview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripstatusview"] = tripstatusview
        tripstatuscolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripstatuscolorview"] = tripstatuscolorview
        tripstatuslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripstatuslbl"] = tripstatuslbl
//        tripStatusBackBtn.imageView?.contentMode = .scaleAspectFit
//        tripStatusBackBtn.setImage(UIImage(named: "Back"), for: .normal)
//        tripStatusBackBtn.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["tripStatusBackBtn"] = tripStatusBackBtn

        canceldetailsview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["canceldetailsview"] = canceldetailsview
        cancelViewSeparator.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelViewSeparator"] = cancelViewSeparator

        canceldetailslisttbv.register(CancelListTableViewCell.self, forCellReuseIdentifier: "CancelListTableViewCell")
        canceldetailslisttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["canceldetailslisttbv"] = canceldetailslisttbv
        canceldetailsviewcancelbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["canceldetailsviewcancelbtn"] = canceldetailsviewcancelbtn
        canceldetailsviewdontcancelbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["canceldetailsviewdontcancelbtn"] = canceldetailsviewdontcancelbtn

        //promoview
        promoSep1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promoSep1"] = promoSep1
        promoSep2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promoSep2"] = promoSep2
        distancelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["distancelbl"] = distancelbl
        distanceheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["distanceheaderlbl"] = distanceheaderlbl
        promolbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promolbl"] = promolbl
        promoheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promoheaderlbl"] = promoheaderlbl
        promobtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["promobtn"] = promobtn
        paylbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paylbl"] = paylbl
        payheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["payheaderlbl"] = payheaderlbl

        gestureview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gestureview"] = gestureview

        //faredetailsview
        fareDetailsUL1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fareDetailsUL1"] = fareDetailsUL1
//        lockImgView.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["lockImgView"] = lockImgView
        fareDetailsUL2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fareDetailsUL2"] = fareDetailsUL2
        faredetailsview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["faredetailsview"] = faredetailsview
        gotitbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gotitbtn"] = gotitbtn

        getfaredetailsbtn.imageView?.contentMode = .scaleAspectFit
        getfaredetailsbtn.setTitle("Fare Details", for: .normal)
        getfaredetailsbtn.setTitleColor(.black, for: .normal)
        getfaredetailsbtn.setImage(UIImage(named: "Lock"), for: .normal)
        getfaredetailsbtn.contentHorizontalAlignment = .right
        getfaredetailsbtn.semanticContentAttribute = .forceRightToLeft
        getfaredetailsbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["getfaredetailsbtn"] = getfaredetailsbtn

        farederailsviewheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["farederailsviewheaderlbl"] = farederailsviewheaderlbl
        ridefarelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridefarelbl"] = ridefarelbl
        taxheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["taxheaderlbl"] = taxheaderlbl
        taxlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["taxlbl"] = taxlbl
        totalheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalheaderlbl"] = totalheaderlbl
        totallbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totallbl"] = totallbl
        noteHintLb.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["notehintlbllbl"] = noteHintLb
        hintlbllbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["hintlbllbl"] = hintlbllbl

//faredetview
        faredetview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["faredetview"] = faredetview
        bfheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bfheaderlbl"] = bfheaderlbl
        bflbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bflbl"] = bflbl
        rateperkmheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rateperkmheaderlbl"] = rateperkmheaderlbl
        rateperkmlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rateperkmlbl"] = rateperkmlbl
        ridetimechargeheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridetimechargeheaderlbl"] = ridetimechargeheaderlbl
        ridetimechargelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridetimechargelbl"] = ridetimechargelbl
        taxesextralbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["taxesextralbl"] = taxesextralbl
        faredetbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["faredetbtn"] = faredetbtn
        gitbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gitbtn"] = gitbtn


        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[confirmbookingbtn]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[etapaymentview(65)][confirmbookingbtn(40)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        confirmbookingbtn.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        pickupview.topAnchor.constraint(equalTo: self.top, constant: 64).isActive = true
//        pickupview.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[pickupview]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pickupview(50)]", options: [], metrics: nil, views: layoutDic))
        dropview.topAnchor.constraint(equalTo: pickupview.bottomAnchor, constant: -10).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dropview(50)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[dropview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paymentview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[paymentview(160)]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[waitingfordriverview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[waitingfordriverview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[promoview]-(10)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[callBtn(50)]-(10)-[promoview(70)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cancelBtn]-(10)-[callBtn(==cancelBtn)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        promoview.bottomAnchor.constraint(equalTo: self.bottom, constant: -10).isActive = true
//        (equalTo: self.bottom).isActive = true

        tripstatusview.topAnchor.constraint(equalTo: self.top, constant: 148).isActive = true
        tripstatusview.heightAnchor.constraint(equalToConstant: 60).isActive = true
        driverstatusview.topAnchor.constraint(equalTo: self.top, constant: 84).isActive = true
        driverstatusview.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[tripstatusview(260)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[driverstatusview(260)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        canceldetailsview.heightAnchor.constraint(equalToConstant: 400).isActive = true
        canceldetailsview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[canceldetailsview]-(10)-|", options: [], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[promodetailsView]|", options: [], metrics: nil, views: layoutDic))
        promodetailsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gestureview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[gestureview]|", options: [], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[faredetview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        faredetview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[faredetailsview]-(10)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.heightAnchor.constraint(equalToConstant: 320).isActive = true
        faredetailsview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true


//        faredetailsview
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[farederailsviewheaderlbl(20)]-(10)-[fareDetailsUL1(1)]-(19)-[getfaredetailsbtn(20)]-(10)-[taxheaderlbl(20)]-(10)-[fareDetailsUL2(1)]-(9)-[totalheaderlbl(20)]-(15)-[notehintlbllbl(45)]-(0)-[hintlbllbl(65)]-(5)-[gotitbtn(40)]|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[farederailsviewheaderlbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[fareDetailsUL1]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[getfaredetailsbtn]-(10)-[ridefarelbl(==getfaredetailsbtn)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[taxheaderlbl]-(10)-[taxlbl(==taxheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[fareDetailsUL2]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[totalheaderlbl]-(10)-[totallbl(==totalheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[notehintlbllbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[hintlbllbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gotitbtn]|", options: [], metrics: nil, views: layoutDic))
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        faredetailsview.layoutIfNeeded()
        faredetailsview.setNeedsLayout()
        backBtn.layer.cornerRadius = backBtn.bounds.width/2
        let btnWidth = getfaredetailsbtn.bounds.width
        let titleWidth = getfaredetailsbtn.titleLabel!.bounds.width
        let imgWidth = getfaredetailsbtn.imageView!.bounds.width
        print(btnWidth)//172.0
        print(titleWidth)//63.6666666666667
        print(imgWidth)//50.0
        getfaredetailsbtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: btnWidth-(titleWidth+imgWidth))


//        faredetview
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[bfheaderlbl(20)]-(10)-[rateperkmheaderlbl(20)]-(10)-[ridetimechargeheaderlbl(20)]-(20)-[taxesextralbl(20)]-(10)-[faredetbtn(40)]|", options: [], metrics: nil, views: layoutDic))
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[bfheaderlbl]-(10)-[bflbl(==bfheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[rateperkmheaderlbl]-(10)-[rateperkmlbl(==rateperkmheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[ridetimechargeheaderlbl]-(10)-[ridetimechargelbl(==ridetimechargeheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[taxesextralbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[faredetbtn]-(1)-[gitbtn(==faredetbtn)]-(0)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

        //promodetailsView
        promodetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[promodetailsViewheaderlbl(30)]-(20)-[promodetailsViewTfd(40)]-(30)-[promodetailsViewapplyBtn(40)]-(30)-|", options: [], metrics: nil, views: layoutDic))
        promodetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[promodetailsViewheaderlbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        promodetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[promodetailsViewTfd]-(20)-|", options: [], metrics: nil, views: layoutDic))
        promodetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[promodetailsViewapplyBtn]-(10)-[promodetailsViewcancelBtn(==promodetailsViewapplyBtn)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

        //promoview
        promoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[distanceheaderlbl]-(5)-[promoSep1(1)]-(5)-[promoheaderlbl(==distanceheaderlbl)]-(5)-[promoSep2(1)]-(5)-[payheaderlbl(==distanceheaderlbl)]-(15)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        promoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[distanceheaderlbl(25)]-(2)-[distancelbl(25)]-(3)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        promoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[promoheaderlbl(25)]-(2)-[promolbl(25)]-(3)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        promoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[payheaderlbl(25)]-(2)-[paylbl(25)]-(3)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        promobtn.leadingAnchor.constraint(equalTo: promoheaderlbl.leadingAnchor).isActive = true
        promobtn.trailingAnchor.constraint(equalTo: promoheaderlbl.trailingAnchor).isActive = true
        promobtn.topAnchor.constraint(equalTo: promoheaderlbl.topAnchor).isActive = true
        promobtn.bottomAnchor.constraint(equalTo: promolbl.bottomAnchor).isActive = true

        //pickupview
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[pickupcolorview(10)]-(20)-[pickupaddrLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[pickupaddrLbl(30)]", options: [], metrics: nil, views: layoutDic))
        pickupcolorview.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pickupcolorview.centerYAnchor.constraint(equalTo: pickupaddrLbl.centerYAnchor).isActive = true

        //dropView
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[changeDropBtn]|", options: [], metrics: nil, views: layoutDic))
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[changeDropBtn]|", options: [], metrics: nil, views: layoutDic))
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[dropcolorview(10)]-(20)-[dropaddrLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[dropaddrLbl(30)]", options: [], metrics: nil, views: layoutDic))
        dropcolorview.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropcolorview.centerYAnchor.constraint(equalTo: dropaddrLbl.centerYAnchor).isActive = true

        //paymentview
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[paymentviewheaderlbl(30)]-(10)-[paymenttbv]|", options: [], metrics: nil, views: layoutDic))
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[paymentViewCloseBtn(30)]", options: [], metrics: nil, views: layoutDic))

        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[paymentviewheaderlbl]-(10)-[paymentViewCloseBtn(60)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        paymentviewheaderlbl.centerXAnchor.constraint(equalTo: paymentview.centerXAnchor).isActive = true
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paymenttbv]|", options: [], metrics: nil, views: layoutDic))

//        waitingfordriverview
        waitingfordriverview.addConstraint(NSLayoutConstraint.init(item: waitingfordriverLbl, attribute: .centerY, relatedBy: .equal, toItem: waitingfordriverview, attribute: .centerY, multiplier: 1.5, constant: 0))
        waitingfordriverLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        waitingfordriverview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[waitingfordriverLbl]-(30)-|", options: [], metrics: nil, views: layoutDic))
        waitingfordriverview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[waitingfordrivercancelBtn]-(10)-|", options: [], metrics: nil, views: layoutDic))
        waitingfordriverview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[waitingfordrivercancelBtn(40)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        waitingActivityIndicator.centerXAnchor.constraint(equalTo: waitingfordriverview.centerXAnchor).isActive = true
        waitingActivityIndicator.centerYAnchor.constraint(equalTo: waitingfordriverview.centerYAnchor).isActive = true

        //etapaymentview
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[etaview]-(10)-[paymenttypeselectbtn(==etaview)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[etaview]-(5)-|", options: [], metrics: nil, views: layoutDic))
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[paymenttypeIv(20)]-(3)-[paymenttypeLbl]-(3)-[downArrowImgView(25)]", options: [APIHelper.appLanguageDirection,.alignAllCenterY], metrics: nil, views: layoutDic))
        paymenttypeLbl.centerYAnchor.constraint(equalTo: paymenttypeselectbtn.centerYAnchor).isActive = true
        paymenttypeLbl.centerXAnchor.constraint(equalTo: paymenttypeselectbtn.centerXAnchor).isActive = true
        paymenttypeIv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymenttypeLbl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        downArrowImgView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[etaViewBtn]|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[etaViewBtn]|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[etaLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(3)-[etaLbl]-(3)-[selectedcarnameLbl(==etaLbl)]-(3)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
//        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "", options: [], metrics: nil, views: layoutDic))

            //tripstatusview
        tripstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tripstatuscolorview(20)]-(10)-[tripstatuslbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        tripstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[tripstatuslbl(40)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        tripstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[tripstatuscolorview(20)]-(20)-|", options: [], metrics: nil, views: layoutDic))

//        driverstatusview
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[driverprofilepicture(40)]-(10)-[starratingBtn1]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[starratingBtn1(16)]-(4)-[starratingBtn2(16)]-(4)-[starratingBtn3(16)]-(4)-[starratingBtn4(16)]-(4)-[starratingBtn5(16)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[starratingBtn5]-(5)-[driverStatusSepartor(1)]-(5)-[drivervehiclenumberlbl(88)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[driverprofilepicture(40)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[drivernamelbl(20)]-(7)-[starratingBtn1(22)]-(6)-|", options: [.alignAllLeading], metrics: nil, views: layoutDic))
        drivernamelbl.trailingAnchor.constraint(equalTo: starratingBtn5.trailingAnchor).isActive = true
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[driverStatusSepartor]-(10)-|", options: [], metrics: nil, views: layoutDic))
        driverstatusview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[drivervehicletypelbl]-(5)-[drivervehiclenumberlbl(==drivervehicletypelbl)]-(5)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))


//        canceldetailsview
        canceldetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[canceldetailsheaderlbl(30)]-(5)-[cancelViewSeparator(1)]-(5)-[canceldetailslisttbv(300)]-(5)-[canceldetailsviewcancelbtn(45)]|", options: [], metrics: nil, views: layoutDic))
        canceldetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[canceldetailsheaderlbl]|", options: [], metrics: nil, views: layoutDic))
        canceldetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cancelViewSeparator]|", options: [], metrics: nil, views: layoutDic))
        canceldetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[canceldetailslisttbv]|", options: [], metrics: nil, views: layoutDic))
        canceldetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[canceldetailsviewdontcancelbtn]-(1)-[canceldetailsviewcancelbtn(==canceldetailsviewdontcancelbtn)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

    }

    func gettripdata() {
        //create a fetch request, telling it about the entity
            let fetchRequest: NSFetchRequest<Tripdetails> = Tripdetails.fetchRequest()
            do {
                //go get the results
                let array_users = try getContext().fetch(fetchRequest)
                //I like to check the size of the returned results!
                print ("num of users = \(array_users.count)")
                //You need to convert to NSManagedObject to use 'for' loops
                for user in array_users as [NSManagedObject] {
                    print("\(String(describing: user))")
                    tripetaoriginlat = (String(describing: user.value(forKey: "trippicklat")!))
                    tripetaoriginlon = (String(describing: user.value(forKey: "trippicklon")!))
                    tripetadestlat = (String(describing: user.value(forKey: "tripdroplat")!))
                    tripetadestlon = (String(describing: user.value(forKey: "tripdroplon")!))
                    
//                    tripetavehicletypeid = (String(describing: user.value(forKey: "tripvehicletypeid")!))
//                    self.appdel.selectedcartypeidd = Double(tripetavehicletypeid)!
                    self.appdel.pickuplat = Double(tripetaoriginlat)!
                    self.appdel.pickuplon = Double(tripetaoriginlon)!
                    self.appdel.droplat = Double(tripetadestlat)!
                    self.appdel.droplon = Double(tripetadestlon)!
                }
            }
            catch {
                print("Error with request: \(error)")
            }
    }

    func getdriverdatadata() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Driverdetails> = Driverdetails.fetchRequest()
        do
        {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
                //get the Key Value pairs (although there may be a better way to do that...
                tripresumefirstname = (String(describing: user.value(forKey: "driverfirstname")!))
                tripresumelastname = (String(describing: user.value(forKey: "driverlastname")!))
                tripresumephonenumber = (String(describing: user.value(forKey: "driverphonenumber")!))
                tripresumedriverprofilepicture = (String(describing: user.value(forKey: "driverprofilepict")!))
                tripresumedrivercarnumber = (String(describing: user.value(forKey: "drivercarnumber")!))
                tripresumedrivercarmodel = (String(describing: user.value(forKey: "drivercarmodel")!))
                tripresumedriverreview = (String(describing: user.value(forKey: "driverreview")!))
            }
        }
        catch
        {
            print("Error with request: \(error)")
        }
    }


     @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Hide!")
        self.paymentview.isHidden = true
        self.gestureview.isHidden = true
    }

     @objc func update() {
        if (i==0)
        {
            self.tripstatuscolorview.backgroundColor=UIColor.white
            i=1
        }
        else
        {
            self.tripstatuscolorview.backgroundColor=UIColor.green
            i=0
        }
    }

//    func leftswipedetected(gesture: UISwipeGestureRecognizer) {
//        self.tripstatusview.isHidden=false
//        self.driverstatusview.isHidden=true
//    }
//
//    func rightswipedetected(gesture: UISwipeGestureRecognizer) {
//        self.tripstatusview.isHidden=true
//        self.driverstatusview.isHidden=false
//    }


    override func viewWillAppear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true

        self.locationManager=CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()

        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: Notification.Name("TripCancelledNotification"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.isTranslucent = false
    }

    @objc func methodOfReceivedNotification(notification: Notification)
    {
        guard let pushcancelleddatadict = notification.userInfo as? [String:AnyObject] else {
            return
        }
        print("Cancelled by User notification", pushcancelleddatadict)
        let JSON = pushcancelleddatadict// as! [String:AnyObject]
        print(JSON)

        if let isCancelled = JSON["is_cancelled"] as? Bool, isCancelled
        {
            self.view.showToast("Trip cancelled by Driver, Please Try Again".localize())
            self.deletetrip()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func connectsocket() {
        
        self.addHandlers1()
        self.socket.connect()
        updateStatus()
    }

    func addHandlers1() {
       // socket.nsp = "/home"
        self.socket.on("connect") {data, ack in
            print("socket connected in trip screen")

            let jsonObject11: NSMutableDictionary = NSMutableDictionary()

            jsonObject11.setValue( self.currentuserid, forKey: "id")

            let jsonData11: NSData
            do {
                jsonData11 = try JSONSerialization.data(withJSONObject: jsonObject11, options: JSONSerialization.WritingOptions()) as NSData
                self.jsonString11 = NSString(data: jsonData11 as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
                print("json string = \(self.jsonString11)")
            }
            catch _ {
                print ("JSON Failure")
            }
            self.socket.emit("start_connect", self.jsonString11)

//            let jsonObject1: NSMutableDictionary = NSMutableDictionary()
//
            guard (AppLocationManager.shared.locationManager.location?.coordinate) != nil else {
                return
            }
//
//            let bearing1 = AppLocationManager.shared.locationManager.heading?.magneticHeading
//
//
//            jsonObject1.setValue( location, forKey: "lat")
//            jsonObject1.setValue(location, forKey: "lng")
//            jsonObject1.setValue(bearing1, forKey: "bearing")
//            jsonObject1.setValue(self.currentuserid, forKey: "id")
//
//            let jsonData1: NSData
//            do {
//                jsonData1 = try JSONSerialization.data(withJSONObject: jsonObject1, options: JSONSerialization.WritingOptions()) as NSData
//                self.jsonString1 = NSString(data: jsonData1 as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
//                print("json string = \(self.jsonString1)")
//            }
//            catch _ {
//                print ("JSON Failure")
//            }

//            let jsonObject: NSMutableDictionary = NSMutableDictionary()
//
//            jsonObject.setValue( location, forKey: "lat")
//            jsonObject.setValue(location, forKey: "lng")
//            jsonObject.setValue(self.currentuserid, forKey: "id")
//            //let jsonData: NSData
//            do {
//                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) { //as NSData
//                self.jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
//                print("json string = \(self.jsonString)")
//                }
//            }
//            catch _ {
//                print ("JSON Failure")
//            }
//            self.socket.emit("types", self.jsonString)
           self.gettripstatus()
          self.gettripcancelstatus()
//            self.socket.on("types") {data, ack in
//                print("Message for you! \(data[0])")
//                self.socket.emit("set_location", self.jsonString)
//            }
        }
    }

    func gettripstatus() {
       if(self.appdel.tripJSON.count>0)
        {
            print("trips for you!", self.appdel.tripJSON)
            let JSON = self.appdel.tripJSON
           // let requestrespdict = self.appdel.tripJSON
           // print(JSON)
            self.lbl.text = "\(JSON)"
            if let requestrespdict=(JSON.value(forKey: "request") ) {
                print(requestrespdict)

                if let lat = ((requestrespdict as AnyObject).value(forKey: "pick_latitude") as? Double), let long = ((requestrespdict as AnyObject).value(forKey: "pick_longitude") as? Double), let loc = ((requestrespdict as AnyObject).value(forKey: "pick_location") as? String){
                    self.selectedPickUpLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
                    self.selectedPickUpLocation?.placeId = loc
                }
                if let lat = ((requestrespdict as AnyObject).value(forKey: "drop_latitude") as? Double), let long = ((requestrespdict as AnyObject).value(forKey: "drop_longitude") as? Double), let loc = ((requestrespdict as AnyObject).value(forKey: "drop_location") as? String) {
                    self.selectedDropLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
                    self.selectedDropLocation?.placeId = loc
                }


                if(((requestrespdict as AnyObject).value(forKey: "is_driver_started") as! Bool) == true) {
                    self.appdel.tripJSON=NSDictionary()
                    self.navigationItem.leftBarButtonItem = nil
//                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_driver_arrived") as! Bool) == false  && ((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == false && ((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = requestrespdict as! NSDictionary
                        self.StoreUserDetails(User_Details: self.tripdetailsdict)
                    }
                    let reqid=(requestrespdict as! NSDictionary).value(forKey: "id") as! NSInteger
                    self.requestid=String(reqid) as NSString

                    self.tripstatuslbl.text = "Driver Accepted"
                    if(self.pathdrawn=="") {
                        self.fetchMapData()
                        self.pathdrawn="YES"
                    }

                    if let driverarray=(requestrespdict as AnyObject).value(forKey: "driver") {
                        if((driverarray as AnyObject).count>0) {
                            let fnstr=(driverarray as AnyObject).value(forKey: "firstname") as! String
                            let lnstr=(driverarray as AnyObject).value(forKey: "lastname") as! String
                            let namestr: String = fnstr + " " + lnstr
                            self.drivernamelbl.text = namestr

                            let driverphonenumber1=(driverarray as AnyObject).value(forKey: "phone_number") as! String
                            self.driverphonenumber=driverphonenumber1 as NSString

                            if(((driverarray as AnyObject).value(forKey: "profile_pic") as! String).count>0) {
//                                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//                                indicator.center = self.driverprofilepicture.center
//                                self.view.addSubview(indicator)
//                                indicator.startAnimating()
                                let profilePictureURL = URL(string: (driverarray as AnyObject).value(forKey: "profile_pic") as! String)!
                                self.driverprofilepicture.kf.indicatorType = .activity
                                let resource = ImageResource(downloadURL: profilePictureURL)
                                self.driverprofilepicture.kf.setImage(with: resource)

//                                let session = URLSession(configuration: .default)
//                                let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
//                                    // The download has finished.
//                                    if let e = error {
//                                        print("Error downloading cat picture: \(e)")
//                                    }
//                                    else {
//                                        if (response as? HTTPURLResponse) != nil
//                                        {
//                                            if let imageData = data
//                                            {
//                                                DispatchQueue.global(qos: .background).async
//                                                    {
//                                                        indicator.stopAnimating()
//                                                        let image = UIImage(data: imageData)
//                                                        self.driverprofilepicture.image=image
//                                                }
//                                            }
//                                            else
//                                            {
//                                                indicator.stopAnimating()
//                                                self.alert(message: "Couldn't get image: Image is nil")
//                                            }
//                                        }
//                                        else
//                                        {
//                                            indicator.stopAnimating()
//                                            self.alert(message: "Couldn't get response code for some reason")
//                                        }
//                                    }
//                                }
//                                downloadPicTask.resume()
                            }
                            if let vehtype = ((driverarray as AnyObject).value(forKey: "car_model")) {
                                print(vehtype)
                                self.drivervehicletypelbl.text=(driverarray as AnyObject).value(forKey: "car_model") as? String
                                self.drivervehiclenumberlbl.text=(driverarray as AnyObject).value(forKey: "car_number") as? String
                            }
                            if let starrat = ((driverarray as AnyObject).value(forKey: "review")) {
                                print(starrat)
                                let strr = "\((driverarray as AnyObject).value(forKey: "review")!)"
                                var strint=Int()
                                strint = Int(Float(strr)!)
                                print(strr)
                                if(strint==1)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==2)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==3)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==4)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==5)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                }
                            }
                        }
                    }
                    self.waitingfordriverview.isHidden=true
                    self.etapaymentview.isHidden=true
                    self.pickupview.isHidden=true
                    self.dropview.isHidden=true
                    self.confirmbookingbtn.isHidden=true
                    self.promoview.isHidden=false
//                    self.cancelview.isHidden=false
                    self.cancelBtn.isHidden = false
//                    self.callview.isHidden=false
                    self.callBtn.isHidden = false

                    self.driverstatusview.isHidden=false
                    self.tripstatusview.isHidden=false

//                    if(self.tripstatusview.isHidden==true) {
//                        self.driverstatusview.isHidden=false
//                    } else {
//                        self.driverstatusview.isHidden=true
//                    }

//                    self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
//                    self.tapGesture1.delegate = self
//                    self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
//                    self.driverstatusview.addGestureRecognizer(self.tapGesture1)
//
//                    self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
//                    self.tapGesture11.delegate = self
//                    self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
//                    self.tripstatusview.addGestureRecognizer(self.tapGesture1)
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_driver_arrived") as! Bool) == true) {
                    self.navigationItem.leftBarButtonItem = nil
                    //                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == false && ((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = JSON
                        self.StoreUserDetails1(User_Details: self.tripdetailsdict)
                    }
                    self.tripstatuslbl.text = "Driver Arrived"
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == true) {
                    self.navigationItem.leftBarButtonItem = nil
                    //                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = JSON
                        self.StoreUserDetails1(User_Details: self.tripdetailsdict)
                    }
                    self.tripstatuslbl.text = "Trip Started"
                    self.promoview.isUserInteractionEnabled=false
                    //                    self.cancelview.isUserInteractionEnabled=false
                    self.cancelBtn.isEnabled = false
                    self.promolbl.backgroundColor=UIColor.lightGray
                    self.promoheaderlbl.backgroundColor=UIColor.lightGray
                    //                    self.cancelview.backgroundColor=UIColor.lightGray
                    self.cancelBtn.backgroundColor = .lightGray
                    if  let distance=(requestrespdict as AnyObject).value(forKey: "distancee") as? Double {
                        print(distance)
                        if (distance>0)
                        {
                            let myStringToTwoDecimals = String(format: "%.2f", distance)
                            self.distancelbl.text=myStringToTwoDecimals
                        }
                        else
                        {
                            self.distancelbl.text=String(distance)
                        }
                    }
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == true) {
                    self.tripdetailsdict = JSON
                    self.StoreUserDetails2(User_Details: self.tripdetailsdict)
                    if let tripdistanc = ((requestrespdict as AnyObject).value(forKey: "distance")) as? String {
                        self.appdel.tripdistance=tripdistanc
                    }
                    //self.appdel.tripdistance=((requestrespdict as AnyObject).value(forKey: "distance")) as! String
                    let time=((requestrespdict as AnyObject).value(forKey: "time")) as! Int
                    self.appdel.triptime=String(time)
                    let requestid=((requestrespdict as AnyObject).value(forKey: "id")) as! Int
                    self.appdel.requestid=requestid
                    if let billrespdict=((requestrespdict as AnyObject).value(forKey: "bill") ) {
                        print(billrespdict)
                        self.appdel.billdict=billrespdict as! NSMutableDictionary
                    }
                    if let driverrespdict=((requestrespdict as AnyObject).value(forKey: "driver") ) {
                        print(driverrespdict)
                        self.appdel.driverdict=driverrespdict as! NSMutableDictionary
                    }
                    // self.performSegue(withIdentifier: "seguefromtriptofeedback", sender: self)
                    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedbackvc") as! feedbackvc
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
           // }

            }
        }


        self.socket.on("trip_status"){ data, ack in
            print("trips for you! \(data[0])")
            
//            var JSON = NSDictionary()
//            let jsonstr=data[0] as! NSString
//            //letjsonstr = "\(data[0]!)"
//            let data = jsonstr.data(using: String.Encoding.utf8.rawValue)
//            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]

//            JSON = (json as? NSDictionary)!
            let JSON = data[0] as! NSDictionary
//            let data1 = try JSONSerialization.data(withJSONObject: JSON, options: [])
//            if let string = String(data: data1, encoding: String.Encoding.utf8) {
              self.lbl.text = "\(JSON)"
//            }
            print(JSON)
            if let requestrespdict=(JSON.value(forKey: "request")) {
                print(requestrespdict)
                
                if let lat = ((requestrespdict as AnyObject).value(forKey: "pick_latitude") as? Double), let long = ((requestrespdict as AnyObject).value(forKey: "pick_longitude") as? Double), let loc = ((requestrespdict as AnyObject).value(forKey: "pick_location") as? String){
                    self.selectedPickUpLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
                    self.selectedPickUpLocation?.placeId = loc
                }
                if let lat = ((requestrespdict as AnyObject).value(forKey: "drop_latitude") as? Double), let long = ((requestrespdict as AnyObject).value(forKey: "drop_longitude") as? Double), let loc = ((requestrespdict as AnyObject).value(forKey: "drop_location") as? String) {
                    self.selectedDropLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
                    self.selectedDropLocation?.placeId = loc
                }
                
                
                if(((requestrespdict as AnyObject).value(forKey: "is_driver_started") as! Bool) == true) {
                    self.navigationItem.leftBarButtonItem = nil
//                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_driver_arrived") as! Bool) == false  && ((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == false && ((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = requestrespdict as! NSDictionary
                        self.StoreUserDetails(User_Details: self.tripdetailsdict)
                    }
                    let reqid=(requestrespdict as! NSDictionary).value(forKey: "id") as! NSInteger
                    self.requestid=String(reqid) as NSString
                    self.tripstatuslbl.text = "Driver Accepted"
                    if(self.pathdrawn=="") {
                        self.fetchMapData()
                        self.pathdrawn="YES"
                    }
                     if let driverarray=(requestrespdict as AnyObject).value(forKey: "driver")
                     {
                        if((driverarray as AnyObject).count>0) {
                            let fnstr=(driverarray as AnyObject).value(forKey: "firstname") as! String
                            let lnstr=(driverarray as AnyObject).value(forKey: "lastname") as! String
                            let namestr: String = fnstr + " " + lnstr
                            self.drivernamelbl.text = namestr
                            let driverphonenumber1=(driverarray as AnyObject).value(forKey: "phone_number") as! String
                            self.driverphonenumber=driverphonenumber1 as NSString
                            if(((driverarray as AnyObject).value(forKey: "profile_pic") as! String).count>0) {
//                                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//                                indicator.center = self.driverprofilepicture.center
//                                self.view.addSubview(indicator)
//                                indicator.startAnimating()
                            let profilePictureURL = URL(string: (driverarray as AnyObject).value(forKey: "profile_pic") as! String)!
                            self.driverprofilepicture.kf.indicatorType = .activity
                            let resource = ImageResource(downloadURL: profilePictureURL)
                            self.driverprofilepicture.kf.setImage(with: resource)

//                                let session = URLSession(configuration: .default)
//                                let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
//                                    // The download has finished.
//                                    if let e = error {
//                                        print("Error downloading cat picture: \(e)")
//                                    }
//                                    else {
//                                        if (response as? HTTPURLResponse) != nil
//                                        {
//                                            if let imageData = data
//                                            {
//                                                DispatchQueue.global(qos: .background).async
//                                                    {
//                                                        indicator.stopAnimating()
//                                                        let image = UIImage(data: imageData)
//                                                        self.driverprofilepicture.image=image
//                                                }
//                                            }
//                                            else
//                                            {
//                                                indicator.stopAnimating()
//                                                self.alert(message: "Couldn't get image: Image is nil")
//                                            }
//                                        }
//                                        else
//                                        {
//                                            indicator.stopAnimating()
//                                            self.alert(message: "Couldn't get response code for some reason")
//                                        }
//                                    }
//                                }
//                                downloadPicTask.resume()
                            }
                            if let vehtype = ((driverarray as AnyObject).value(forKey: "car_model")) {
                                print(vehtype)
                                self.drivervehicletypelbl.text=(driverarray as AnyObject).value(forKey: "car_model") as? String
                                self.drivervehiclenumberlbl.text=(driverarray as AnyObject).value(forKey: "car_number") as? String
                            }
                            if let starrat = ((driverarray as AnyObject).value(forKey: "review")) {
                                print(starrat)
                                let strr = "\((driverarray as AnyObject).value(forKey: "review")!)"
                                var strint=Int()
                                strint=Int(Float(strr)!)
                                if(strint==1)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==2)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==3)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==4)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
                                }
                                else if(strint==5)
                                {
                                    self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                    self.starratingBtn5.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
                                }
                            }
                        }
                    }
                    self.waitingfordriverview.isHidden=true
                    self.etapaymentview.isHidden=true
                    self.pickupview.isHidden=true
                    self.dropview.isHidden=true
                    self.confirmbookingbtn.isHidden=true
                    self.promoview.isHidden=false
//                    self.cancelview.isHidden=false
                    self.cancelBtn.isHidden = false
//                    self.callview.isHidden=false
                    self.callBtn.isHidden = false


                    self.driverstatusview.isHidden=false
                    self.tripstatusview.isHidden=false
//                    if(self.tripstatusview.isHidden==true) {
//                        self.driverstatusview.isHidden=false
//                    } else {
//                        self.driverstatusview.isHidden=true
//                    }
//                    self.tapGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.rightswipedetected(gesture:)))
//                    self.tapGesture1.delegate = self
//                    self.tapGesture1.direction=UISwipeGestureRecognizerDirection.left
//                    self.driverstatusview.addGestureRecognizer(self.tapGesture1)
//
//                    self.tapGesture11 = UISwipeGestureRecognizer(target: self, action: #selector(tripViewController.leftswipedetected(gesture:)))
//                    self.tapGesture11.delegate = self
//                    self.tapGesture11.direction=UISwipeGestureRecognizerDirection.right
//                    self.tripstatusview.addGestureRecognizer(self.tapGesture1)
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_driver_arrived") as! Bool) == true) {
                    self.navigationItem.leftBarButtonItem = nil
//                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == false && ((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = JSON 
                        self.StoreUserDetails1(User_Details: self.tripdetailsdict)
                    }
                    self.tripstatuslbl.text = "Driver Arrived"
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_trip_start") as! Bool) == true) {
                    self.navigationItem.leftBarButtonItem = nil
//                    self.title="TapnGo"
                    if(((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == false) {
                        self.tripdetailsdict = JSON
                        self.StoreUserDetails1(User_Details: self.tripdetailsdict)
                    }
                    self.tripstatuslbl.text = "Trip Started"
                    self.promoview.isUserInteractionEnabled=false
//                    self.cancelview.isUserInteractionEnabled=false
                    self.cancelBtn.isEnabled = false
                    self.promolbl.backgroundColor=UIColor.lightGray
                    self.promoheaderlbl.backgroundColor=UIColor.lightGray
//                    self.cancelview.backgroundColor=UIColor.lightGray
                    self.cancelBtn.backgroundColor = .lightGray
                    if  let distance=(requestrespdict as AnyObject).value(forKey: "distancee") as? Double {
                        print(distance)
                        if (distance>0)
                        {
                            let myStringToTwoDecimals = String(format: "%.2f", distance)
                            self.distancelbl.text=myStringToTwoDecimals
                        }
                        else
                        {
                            self.distancelbl.text=String(distance)
                        }
                    }
                }
                if(((requestrespdict as AnyObject).value(forKey: "is_completed") as! Bool) == true) {
                    self.tripdetailsdict = JSON
                    self.StoreUserDetails2(User_Details: self.tripdetailsdict)
                    if let tripdistanc = ((requestrespdict as AnyObject).value(forKey: "distance")) as? String {
                        self.appdel.tripdistance=tripdistanc
                    }
                    //self.appdel.tripdistance=((requestrespdict as AnyObject).value(forKey: "distance")) as! String
                    let time=((requestrespdict as AnyObject).value(forKey: "time")) as! Int
                    self.appdel.triptime=String(time)
                    let requestid=((requestrespdict as AnyObject).value(forKey: "id")) as! Int
                    self.appdel.requestid=requestid
                    if let billrespdict=((requestrespdict as AnyObject).value(forKey: "bill") ) {
                        print(billrespdict)
                        self.appdel.billdict=billrespdict as! NSMutableDictionary
                    }
                    if let driverrespdict=((requestrespdict as AnyObject).value(forKey: "driver") ) {
                        print(driverrespdict)
                        self.appdel.driverdict=driverrespdict as! NSMutableDictionary
                    }
                   // self.performSegue(withIdentifier: "seguefromtriptofeedback", sender: self)
                    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedbackvc") as! feedbackvc
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
            else {
               
                let requestrespdict = data[0] as! NSDictionary
                 self.lbl.text = "\(requestrespdict)"
                print(requestrespdict)
                if((requestrespdict.value(forKey: "trip_start") as! String)=="1")
                {
                    self.tripstatuslbl.text = "Trip Started";
                }
                let distance=requestrespdict.value(forKey: "distancee") as! Double
                print(distance)
                if (distance>0)
                {
                    let myStringToTwoDecimals = String(format: "%.2f", distance)
                    self.distancelbl.text=myStringToTwoDecimals
                }
                else
                {
                    self.distancelbl.text=String(distance)
                }
                if let drivermarkbear = (requestrespdict.value(forKey: "bearing") as? String) {
                    self.drivermarkerBearing=drivermarkbear
                    self.drivermarkerrBearing=Double(drivermarkbear)
                    
                }
                if let drivermarkbear = (requestrespdict.value(forKey: "bearing") as? Double) {
                    //self.drivermarkerBearing=drivermarkbear
                    self.drivermarkerrBearing=drivermarkbear
                }
               // self.drivermarkerBearing=(requestrespdict.value(forKey: "bearing") as! String)
               // self.drivermarkerrBearing=Double(self.drivermarkerBearing)!

                self.drivermarkerLong = (requestrespdict.value(forKey: "lng") as! Double)
                self.drivermarkerLat = (requestrespdict.value(forKey: "lat") as! Double)

                if(self.ddd == "first")
                {
                    self.drivermarkerpickLat=self.drivermarkerLat
                    self.drivermarkerpickLong=self.drivermarkerLong
                    self.ddd="second"
                }
                self.appdel.droplat=self.drivermarkerLat
                self.appdel.droplon=self.drivermarkerLong
                self.fetchMapData1()
                self.addmarkers()
            
            }
        }

        self.socket.on("cancelled_request"){
            data, ack in
            print("Rejected by drivers \(data[0])")
            let JSON = data[0] as! NSDictionary
            print(JSON)

            let reqid=JSON.value(forKey: "is_cancelled") as! NSInteger
            if(reqid==1) {
                self.waitingfordriverview.isHidden=true
                self.view.showToast((JSON.value(forKey: "success_message") as! String))
                self.deletedriver()
                self.deletetrip()
                self.deletetripbill()
                self.deleteinvoiceviewed()
                self.navigationController?.popToRootViewController(animated: true)
//                self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                self.window1?.rootViewController = mainViewController
//                self.window1?.makeKeyAndVisible()
            }
        }
    }

    func gettripcancelstatus() {
        self.socket.on("request_handler"){
            data, ack in
            print("Cancelled by driver \(data[0])")
            let JSON = data[0] as! NSDictionary
            print(JSON)
            let reqid=JSON.value(forKey: "is_cancelled") as! NSInteger
            if(reqid==1) {
                self.waitingfordriverview.isHidden=true
                self.view.showToast((JSON.value(forKey: "success_message") as! String))
                        self.deletedriver()
                        self.deletetrip()
                        self.deletetripbill()
                        self.deleteinvoiceviewed()
                self.navigationController?.popToRootViewController(animated: true)
//                self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                self.window1?.rootViewController = mainViewController
//                self.window1?.makeKeyAndVisible()
            }
        }
    }

    @IBAction func changedroplocBtnAction() {
        let vc = SearchLocationTVC()
        vc.title = "Enter Your Drop Location".localize()
        vc.searchController.searchBar.text = ""
        vc.searchController.searchBar.placeholder = "Enter Your Drop Location".localize()
        vc.currentuserid = currentuserid
        vc.currentusertoken = currentusertoken
        vc.selectedLocation = self.dropLocationSelectedClousure
        self.navigationController?.pushViewController(vc, animated: true)

//        self.searchview.isHidden=false
//        self.searchTfd.text = ""
//        self.searchlistTbv.isHidden=true
////        self.getfavouritelistApi()
//        self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        self.view.bringSubview(toFront: self.searchview)
//        self.searchview.isHidden=false
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations:
//            {
//                self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//
//        }, completion: {_ in
//
//            self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        })
    }

    @IBAction func backAction() {
        self.navigationController?.popToRootViewController(animated: true)
//        self.window1 = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//        self.window1?.rootViewController = mainViewController
//        self.window1?.makeKeyAndVisible()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField==self.promodetailsViewTfd)
        {
            self.promodetailsViewTfd.resignFirstResponder()
        }
        return true
    }

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
        let fetchRequest: NSFetchRequest<Userdetails> = Userdetails.fetchRequest()
        do
        {
            //go get the results
            let array_users = try getContext1().fetch(fetchRequest)
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
        }
        catch
        {
            print("Error with request: \(error)")
        }
    }


    func getetaapicall() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if(self.tripcompleted=="yes") {

            }
            else {
                if activityView == nil {
                    activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                    // add subview
                    self.view.bringSubviewToFront(activityView)
                    self.view.addSubview(activityView)
                    // autoresizing mask
                    activityView.translatesAutoresizingMaskIntoConstraints = false
                // constraints
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
                }
               // activityView.startAnimating()
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                if self.selectedCarModel == nil {
                    paramDict["type_id"] = tripetavehicletypeid
                } else {
                    paramDict["type_id"] = self.selectedCarModel.id
                }
                paramDict["olat"] = self.selectedPickUpLocation?.latitude
                paramDict["olng"] = self.selectedPickUpLocation?.longitude
                paramDict["dlat"] = self.selectedDropLocation?.latitude
                paramDict["dlng"] = self.selectedDropLocation?.longitude

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.geteta
                print(url)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            if let currency = JSON.value(forKey: "currency") as? String {
                                self.currency = currency
                            }
                            let def2=(JSON.value(forKey: "total") as! String)
                            self.totalstr=self.currency + " " + def2
                            self.etaLbl.text=self.totalstr

                            self.totallbl.text=self.totalstr

                            let def12=(JSON.value(forKey: "ride_fare") as! String)
                            print(def12)
                            let totalstr1=self.currency + " " + def12
                            self.ridefarelbl.text=totalstr1

                            let def13=(JSON.value(forKey: "tax_amount") as! String)
                            print(def13)
                            let totalstr2=self.currency + " " + def13
                            self.taxlbl.text=totalstr2

                            let bp=(JSON.value(forKey: "base_price") as! Double)
                            print(bp)
                            let bpst=String(format: "%.2f", bp)
                            let bpstr=self.currency + " " + bpst
                            self.bflbl.text=bpstr

                            let rpk=(JSON.value(forKey: "price_per_distance") as! Double)
                            print(rpk)
                            let rpkst=String(format: "%.2f", rpk)
                            let rpkstr=self.currency + " " + rpkst
                            self.rateperkmlbl.text=rpkstr

                            let rtc=(JSON.value(forKey: "price_per_time") as! Double)
                            print(rtc)
                            let rtcst=String(format: "%.2f", rtc)
                            let rtcstr=self.currency + " " + rtcst
                            self.ridetimechargelbl.text=rtcstr
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Something went wrong. Try again")
                        }
                    }
                }
            }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }


    func getCancelReasonList() {

        if ConnectionCheck.isConnectedToNetwork()
        {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
            let url = helperObject.BASEURL + helperObject.cancelReasonList
            var paramDict = Dictionary<String, Any>()
            paramDict["id"]=currentuserid
            paramDict["token"]=currentusertoken
            paramDict["user_type"] = "1"
            print("URL for cancelReasonList =",url)
            print("params for cancelReasonList =",paramDict)

            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    if case .failure(let error) = response.result
                    {
                        print(error.localizedDescription)
                    }
                    else if case .success = response.result
                    {
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            if let response = try? decoder.decode(CancellationList.self, from: data) {
                                self.cancelReasonList = response.reason
                                self.canceldetailslisttbv.reloadData()
                                if response.reason.isEmpty {
                                    //TODO:- change message
                                    self.view.showToast("")
                                }
                            }
                        }
                    }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        }
        else
        {
            print("disConnected")
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }

    //--------------------------------------
    // MARK: - NVActivityIndicatorview
    //--------------------------------------

//    func showLoadingIndicator() {
//        if activityView == nil
//        {
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

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.mapview.isMyLocationEnabled = true
        mapview.padding = UIEdgeInsets(top: 150, left: 0, bottom: 150, right: 0)
        print("Map Dragging")
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapview.isMyLocationEnabled = true
        mapview.settings.myLocationButton = true
        mapview.padding = UIEdgeInsets(top: 150, left: 0, bottom: 150, right: 0)

        let locationMapChange = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        locValue = locationMapChange.coordinate
        print(locValue.latitude)
        print(locValue.longitude)

        marker.map = nil

        let markerPosition = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        marker = GMSMarker(position: markerPosition)
        marker.icon = nil //UIImage(named: "destination_pin")
        //marker.map = self.mapview
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.startUpdatingLocation()
        location = locations.last!
        print("Location: \(location)")
        pickUpLat = "\(location.coordinate.latitude)"
        pickUpLong="\(location.coordinate.longitude)"
        _=Double(pickUpLat)
        _=Double(pickUpLong)

//        let camera = GMSCameraPosition.camera(withLatitude: latdouble!, longitude: longdouble!, zoom: 15)
//        mapview.camera=camera
        mapview.isMyLocationEnabled = true

        mapview.settings.myLocationButton = true
        mapview.padding = UIEdgeInsets(top: 150, left: 0, bottom: 150, right: 0)

        // Creates a marker in the center of the map.

        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
        marker.icon = nil
    }

    @IBAction func paymenttypeselectBtnaction() {
        paymenttbv.reloadData()
        self.gestureview.isHidden = false
        self.paymentview.isHidden=false
        self.view.bringSubviewToFront(self.paymentview)
    }

    @IBAction func paymentviewclosebtnAction() {
        self.paymentview.isHidden=true
    }

    //--------------------------------------
    // MARK: - Table view Delegates
    //--------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == paymenttbv
        {
            return self.paymenttypearray.count
        }
        else if tableView == canceldetailslisttbv
        {
           // return self.cancelreasonaray.count
            return (cancelReasonList ?? []).count
        }
        else
        {
            return self.placenamearray.count
        }
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == paymenttbv
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTableViewCell") as! PaymentTableViewCell

            cell.paymentypeLbl.text = self.paymenttypearray[indexPath.row] as? String
            cell.paymenttypeIv.image = UIImage(named: self.paymenttypeimagearray[indexPath.row] as! String)
            return cell
        }
        if tableView == canceldetailslisttbv
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CancelListTableViewCell") as! CancelListTableViewCell
//            cell.cancelReasonLbl.text = self.cancelreasonaray[indexPath.row] as? String
//            if(cellselectedarray[indexPath.row] as! String == "YES") {
//                cell.cancelReasonSelectView.backgroundColor=UIColor.orange
//            }
//            else {
//                cell.cancelReasonSelectView.backgroundColor=UIColor.white
//            }
            cell.cancelReasonLbl.text = self.cancelReasonList![indexPath.row].cancellationFeeName

            if self.cancelReasonList![indexPath.row].id == self.selectedCancelReason?.id {
                cell.cancelReasonSelectView.backgroundColor = UIColor.themeColor
            } else {
                cell.cancelReasonSelectView.backgroundColor = UIColor.white
            }
            return cell
        }
        return UITableViewCell()
//        }
//        else
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell1", for: indexPath) as! SearchListTableViewCell
//            cell.placenameLbl.font = UIFont.appBoldFont(ofSize: 15)
//            cell.placeaddLbl.font = UIFont.appFont(ofSize: 11)
//            if(self.isfavouritearray[indexPath.row] as? String == "YES")
//            {
////                cell.favdeleteBtn.isHidden=false
////                cell.favdeleteimv.isHidden=false
////                cell.favdeleteBtn.tag=indexPath.row
////                cell.favdeleteBtn.addTarget(self, action: #selector(pickupViewController.deleteBtnAction(_:)), for: UIControlEvents.touchUpInside)
//            }
//            else
//            {
////                cell.favdeleteBtn.isHidden=true
////                cell.favdeleteimv.isHidden=true
//            }
//            if(placenamearray.count>0)
//            {
//                cell.placenameLbl.text=self.placenamearray[indexPath.row] as? String
//                cell.placeaddLbl.text=self.placeaddressarray[indexPath.row] as? String
//            }
//            return cell
//        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == paymenttbv
        {
            self.paymenttypeLbl.text=self.paymenttypearray[indexPath.row] as? String
            self.paymenttypeLbl.sizeToFit()
            self.paymentview.isHidden=true
            self.gestureview.isHidden = true
            if self.paymenttypeLbl.text == "Cash" {
                selectedpaymentoption=1
                paymenttypeIv.image=UIImage(named: "paymentcash")
            }
            else if self.paymenttypeLbl.text == "Card" {
                selectedpaymentoption=0
                paymenttypeIv.image=UIImage(named: "addcardicon")
            }
            else if self.paymenttypeLbl.text == "Wallet" {
                selectedpaymentoption=2
                paymenttypeIv.image=UIImage(named: "paymentwallet")
            }
        }
        else if tableView == canceldetailslisttbv
        {
//            cancelreasonstring=cancelreasonaray[indexPath.row] as! String
//            cancelreasonDigit = indexPath.row
//            dummyarray[indexPath.row]="YES"
//            cellselectedarray=dummyarray
//            dummyarray=["NO", "NO", "NO", "NO", "NO", "NO"]
//            self.canceldetailslisttbv.reloadData()

            self.selectedCancelReason = cancelReasonList![indexPath.row]
            self.canceldetailslisttbv.reloadData()
        }
        else
        {
//            self.dropaddrLbl.text=self.addressarray[indexPath.row] as? String
//            self.searchTfd.resignFirstResponder()
//            self.searchview.isHidden=true
//            self.getcoord(self.dropaddrLbl.text!)
            //self.getcoord(self.toAddrtf.text!)
        }
    }

    func getcoord(_ str: String) {
        let address = str
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            self.appdel.droplat=location.coordinate.latitude
            self.appdel.droplon=location.coordinate.longitude
            //self.updatecameraloc()
            self.getetaapicall()
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

    @IBAction func confirmbookingbtnAction() {
        if(self.paymenttypeLbl.text=="Payment")
        {
            self.alert(message: "Please choose Payment method")
        }
        else
        {
            if ConnectionCheck.isConnectedToNetwork() {
                if activityView == nil {
                    activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                    // add subview
                    self.view.bringSubviewToFront(activityView)
                    self.view.addSubview(activityView)
                    // autoresizing mask
                    activityView.translatesAutoresizingMaskIntoConstraints = false
                    // constraints
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
                }
               // activityView.startAnimating()
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                if self.selectedCarModel == nil {
                    paramDict["type"] = tripetavehicletypeid
                } else {
                    paramDict["type"] = self.selectedCarModel.id
                }
                paramDict["platitude"]=self.appdel.pickuplat
                paramDict["plongitude"]=self.appdel.pickuplon
                paramDict["dlatitude"]=self.appdel.droplat
                paramDict["dlongitude"]=self.appdel.droplon
                paramDict["paymentOpt"]=selectedpaymentoption
                paramDict["dlocation"]=self.appdel.toaddr
                paramDict["plocation"]=self.appdel.fromaddr
                paramDict["driver_eta"]=self.totalstr

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.createrequest
                print(url)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("Response for Login",JSON)
                            print(JSON.value(forKey: "success") as! Bool)
                            let theSuccess = (JSON.value(forKey: "success") as! Bool)
                            if(theSuccess == true) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.waitingfordriverview.isHidden=false
                                let requestrespdict=(JSON.value(forKey: "request"))
                                let reqid=(requestrespdict as! NSDictionary).value(forKey: "id") as! NSInteger
                                self.requestid=String(reqid) as NSString
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast((JSON.value(forKey: "error_message") as! String))
                            }
                        }
                }
            }
        }
    }

    @IBAction func waitingfordrivercancelbtnAction() {
        self.cancelrequestapicall()
    }

    func getrequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["id"]=currentuserid
            paramDict["token"]=currentusertoken
            print(paramDict)
            let url = helperObject.BASEURL + helperObject.getreqinprogress
            print(url)

            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.requestdetailsdict=(JSON.value(forKey: "request")  as! NSDictionary)
                            print(self.requestdetailsdict)
                            if(self.requestdetailsdict.count>0) {
                                let reqstatusdriverstarted=self.requestdetailsdict.value(forKey: "is_driver_started") as! Int
                                if(reqstatusdriverstarted == 1)
                                {
                                    self.waitingfordriverview.isHidden=true
                                    self.alert(message: "Driver Accepted")
                                }
                            }
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Something went wrong. Try again")
                        }
                    }
            }
        }
    }

//    @IBAction func closesearchviewTap(_ sender: UIButton)
//    {
//        self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations:
//            {
//                self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//
//        }, completion: {_ in
//            self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//            self.searchview.isHidden=true
//        })
//    }

//    @IBAction func clearBtnAction()
//    {
//        self.searchTfd.text = ""
//        //self.searchlistTbv.isHidden=true
//    }

//    func getfavouritelistApi()
//    {
//        if ConnectionCheck.isConnectedToNetwork()
//        {
//            if activityView == nil
//            {
//                activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//                // add subview
//                self.searchview.bringSubview(toFront: activityView)
//                searchview.addSubview(activityView)
//                // autoresizing mask
//                activityView.translatesAutoresizingMaskIntoConstraints = false
//                // constraints
//                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
//                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
//            }
//            activityView.startAnimating()
//            print("Connected")
//            var paramDict = Dictionary<String, Any>()
//            paramDict["id"]=currentuserid
//            paramDict["token"]=currentusertoken
//            print(paramDict)
//            let url = helperObject.BASEURL + helperObject.getfavouritelist
//            print(url)
//            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                .responseJSON
//                { response in
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                    print(response.response as Any) // URL response
//                    print(response.result.value as AnyObject)
//                    if let result = response.result.value
//                    {
//                        let JSON = result as! NSDictionary
//                        print("Response for Login",JSON)
//                        print(JSON.value(forKey: "success") as! Bool)
//                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
//                        if(theSuccess == true)
//                        {
//                            self.placenamearray=NSMutableArray()
//                            self.placeaddressarray=NSMutableArray()
//                            self.addressarray=NSMutableArray()
//                            self.isfavouritearray=NSMutableArray()
//                            self.favlistidarray=NSMutableArray()
//                            var favouritelistarray=NSArray()
//
//                            favouritelistarray=(JSON.value(forKey: "favplace") as! NSArray)
//                            if(favouritelistarray.count>0)
//                            {
//                                for array in favouritelistarray
//                                {
//                                    print(array)
//                                    self.placenamearray.add((array as AnyObject).value(forKey: "nickName") as! NSString)
//                                    self.placeaddressarray.add((array as AnyObject).value(forKey: "placeId") as! NSString)
//                                    self.favlistidarray.add((array as AnyObject).value(forKey: "id") as? NSNumber! as Any)
//                                    self.addressarray.add((array as AnyObject).value(forKey: "placeId") as! NSString)
//                                    self.isfavouritearray.add("YES")
//                                }
//                            }
//                            if(self.placenamearray.count>0)
//                            {
//                                self.searchlistTbv.isHidden=false
//                                self.searchlistTbv.reloadData()
//                            }
//                            else
//                            {
//                                self.searchlistTbv.isHidden=true
//                            }
//                        }
//                        else
//                        {
//                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                            self.view.showToast("Something went wrong.")
//
//                        }
//                    }
//            }
//        }
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField==promodetailsViewTfd)
        {
        }
//        else
//        {
//            if let text = textField.text as NSString?
//            {
//                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//                print(txtAfterUpdate)
//                if ConnectionCheck.isConnectedToNetwork()
//                {
//                    print("Connected")
//                    if(txtAfterUpdate.count>0)
//                    {
//                        var paramDict = Dictionary<String, Any>()
//                        paramDict["input"]=txtAfterUpdate
//                        paramDict["key"]="AIzaSyCpmkjIlSYKYL-0rtDLSWf4VIOjJgSnG6Q"
//                        paramDict["location"]="0.000000,0.000000"
//                        paramDict["radius"]="500"
//                        paramDict["sensor"]="false"
//
//                        print(paramDict)
//                        let url = helperObject.autocomplete_URl
//                        print(url)
//                        Alamofire.request(url, method: .get, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                        .responseJSON
//                        { response in
//                            print(response.response as Any) // URL response
//                            print(response.result.value as AnyObject)   // result of response serialization
//                            //  to get JSON return value
//                            if let result = response.result.value
//                            {
//                                let JSON = result as! NSDictionary
//                                self.arr = JSON.value(forKey: "predictions") as! NSArray
//                                self.descrarr=self.arr.value(forKey: "description") as! NSArray
//                                self.placenamearray=NSMutableArray()
//                                self.placeaddressarray=NSMutableArray()
//                                self.addressarray=NSMutableArray()
//                                self.isfavouritearray=NSMutableArray()
//                                for str in self.descrarr
//                                {
//                                    print(str)
//                                    self.addressarray.add(str)
//                                    self.isfavouritearray.add("NO")
//                                    let website: String = str as! String
//                                    if ( website.range(of: ",") != nil)
//                                    {
//                                        let arr2 = website.components(separatedBy: ",")
//                                        print(arr2)
//                                        self.placenamearray.add(arr2[0])
//
//                                        let index = website.range(of: ",")?.lowerBound
//
//                                        var addstr=website.substring(from: index!)
//                                        addstr.remove(at: addstr.startIndex)// "ora"
//                                        print(addstr)
//                                        self.placeaddressarray.add(addstr)
//                                    }
//                                    else
//                                    {
//                                        self.placenamearray.add(website)
//                                        self.placeaddressarray.add("")
//                                    }
//                                }
//                                if(self.arr.count>0)
//                                {
//                                    self.searchlistTbv.isHidden=false
//                                    self.searchlistTbv .reloadData()
//                                }
//                            }
//                        }
//                    }
//                    else
//                    {
//                        self.searchlistTbv.isHidden=true
//                    }
//                }
//                else
//                {
//                    print("disConnected")
//                }
//            }
//        }
        return true
    }

//    @IBAction func deleteBtnAction(_ sender: UIButton)
//    {
//        if ConnectionCheck.isConnectedToNetwork()
//        {
//            self.searchTfd.resignFirstResponder()
//            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//            if activityView == nil
//            {
//                activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//                // add subview
//                self.searchview.bringSubview(toFront: activityView)
//                searchview.addSubview(activityView)
//                // autoresizing mask
//                activityView.translatesAutoresizingMaskIntoConstraints = false
//                // constraints
//                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
//                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
//            }
//            activityView.startAnimating()
//            let i=sender.tag
//            print("Connected")
//            var paramDict = Dictionary<String, Any>()
//            paramDict["id"]=currentuserid
//            paramDict["token"]=currentusertoken
//            paramDict["favid"]=favlistidarray[i];
//            print(paramDict)
//            let url = helperObject.BASEURL + helperObject.deletefav
//            print(url)
//            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                .responseJSON
//                { response in
//
//                    print(response.response as Any) // URL response
//                    print(response.result.value as AnyObject)
//                    if let result = response.result.value
//                    {
//                        let JSON = result as! NSDictionary
//                        print("Response for Login",JSON)
//                        print(JSON.value(forKey: "success") as! Bool)
//                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
//                        if(theSuccess == true)
//                        {
//                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                            indicator.stopAnimating()
////                            self.getfavouritelistApi()
//                            self.view.showToast((JSON.value(forKey: "success_message") as! String))
//                            self.searchlistTbv.reloadData()
//                        }
//                        else
//                        {
//                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                            indicator.stopAnimating()
//                            self.view.showToast("Something went wrong. Favourite not Deleted.")
//                        }
//                    }
//                    else
//                    {
//                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//                        indicator.stopAnimating()
//                        self.view.showToast("Something went wrong.")
//                    }
//            }
//        }
//    }

    //--------------------------------------
    // MARK: - Cancel trip and request
    //--------------------------------------

@IBAction func canceltripbtnAction() {
    if cancelReasonList == nil {
        self.getCancelReasonList()
    }
    self.canceldetailsview.isHidden=false
    self.view.bringSubviewToFront(canceldetailsview)
    self.promoview.isUserInteractionEnabled=false
}

@IBAction func canceldetailsviewdontcancelbtnAction() {
    self.canceldetailsview.isHidden=true
    self.promoview.isUserInteractionEnabled=true
}

@IBAction func canceldetailsviewcancelbtnAction() {
    self.canceltripapicall()
}

func cancelrequestapicall() {
    if ConnectionCheck.isConnectedToNetwork() {
        if activityView == nil
        {
            activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                // add subview
            self.view.bringSubviewToFront(activityView)
            self.view.addSubview(activityView)
                // autoresizing mask
            activityView.translatesAutoresizingMaskIntoConstraints = false
                // constraints
            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        }
       //activityView.startAnimating()
         NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
        print("Connected")
        var paramDict = Dictionary<String, Any>()
        paramDict["id"]=currentuserid
        paramDict["token"]=currentusertoken
        paramDict["request_id"]=requestid
        paramDict["reason"]="0"

        print(paramDict)
        let url = helperObject.BASEURL + helperObject.canceltrip
        print(url)
        Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
            .responseJSON
        { response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            print(response.response as Any) // URL response
            print(response.result.value as AnyObject)
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print("Response for Login",JSON)
                print(JSON.value(forKey: "success") as! Bool)
                let theSuccess = (JSON.value(forKey: "success") as! Bool)
                if(theSuccess == true) {
                    self.waitingfordriverview.isHidden=true
                    self.navigationController?.popToRootViewController(animated: true)
//                    self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                    self.window1?.rootViewController = mainViewController
//                    self.window1?.makeKeyAndVisible()
                    self.appdel.cancelledrequest = "YES"
                }
                else {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    if((JSON.value(forKey: "error_message") as! String) == "Trip already cancelled") {
                        self.waitingfordriverview.isHidden=true
                        self.navigationController?.popToRootViewController(animated: true)
//                        self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                        self.window1?.rootViewController = mainViewController
//                        self.window1?.makeKeyAndVisible()
                        self.view.showToast((JSON.value(forKey: "error_message") as! String))
                    } else {
                        self.view.showToast("Something went wrong. Unable to cancel the request.")
                    }
                }
            }
        }
    }
}

func canceltripapicall() {
    if self.selectedCancelReason != nil {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if activityView == nil {
                activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
            // add subview
                self.view.bringSubviewToFront(activityView)
            self.view.addSubview(activityView)
            // autoresizing mask
            activityView.translatesAutoresizingMaskIntoConstraints = false
            // constraints
            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        }
       // activityView.startAnimating()
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
        print("Connected")
        var paramDict = Dictionary<String, Any>()
        paramDict["id"]=currentuserid
        paramDict["token"]=currentusertoken
        paramDict["request_id"]=requestid
        paramDict["reason"] = self.selectedCancelReason?.id     //cancelreasonDigit  //cancelreasonstring

        print(paramDict)
        let url = helperObject.BASEURL + helperObject.canceltrip
        print(url)
        Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
            .responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                print(response.response as Any) // URL response
                print(response.result.value as AnyObject)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("Response for Login",JSON)
                    print(JSON.value(forKey: "success") as! Bool)
                    let theSuccess = (JSON.value(forKey: "success") as! Bool)
                    if(theSuccess == true) {
                        self.waitingfordriverview.isHidden=true
                        self.etapaymentview.isHidden=false
                        self.pickupview.isHidden=false
                        self.dropview.isHidden=false
                        self.confirmbookingbtn.isHidden=false
                        self.promoview.isHidden=true
//                        self.cancelview.isHidden=true
                        self.cancelBtn.isHidden = true
//                        self.callview.isHidden=true
                        self.callBtn.isHidden = true
                        self.driverstatusview.isHidden=true

                        self.deletedriver()
                        self.deletetrip()
                        self.deletetripbill()
                        self.deleteinvoiceviewed()
                        self.navigationController?.popToRootViewController(animated: true)
//                        self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                        self.window1?.rootViewController = mainViewController
//                        self.window1?.makeKeyAndVisible()
                    } else {
//                        self.deletedriver()
//                        self.deletetrip()
//                        self.deletetripbill()
//                        self.deleteinvoiceviewed()
                        if((JSON.value(forKey: "error_message") as! String) == "Trip already cancelled") {
                            self.waitingfordriverview.isHidden=true
                            self.etapaymentview.isHidden=false
                            self.pickupview.isHidden=false
                            self.dropview.isHidden=false
                            self.confirmbookingbtn.isHidden=false
                            self.promoview.isHidden=true
//                            self.cancelview.isHidden=true
                            self.cancelBtn.isHidden = true
//                            self.callview.isHidden=true
                            self.callBtn.isHidden = true
                            self.driverstatusview.isHidden=true
                            self.view.showToast(JSON.value(forKey: "error_message") as! String)
                            self.navigationController?.popToRootViewController(animated: true)
//                            self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                            self.window1?.rootViewController = mainViewController
//                            self.window1?.makeKeyAndVisible()
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast("Something went wrong. Unable to cancel trip.")
                        }
                    }
                }
            }
        }
    }
    else {
        self.view.showToast("Please choose a reason from the list to cancel. ")
    }
}

    //--------------------------------------
    // MARK: - DRAWING PATH
    //--------------------------------------

    func fetchMapData() {
        dropLatStr = String(self.appdel.droplat)
        dropLongStr = String(self.appdel.droplon)
        pickUpLat = String(self.appdel.pickuplat)
        pickUpLong = String(self.appdel.pickuplon)

        let origin = "\(Double(pickUpLat!)!),\(Double(pickUpLong!)!)"
        let destination = "\(Double(dropLatStr)!),\(Double(dropLongStr)!)"
        let googleServerKey = "AIzaSyDi13ALJBmh7aHD2uWsLSQ9UKDbJTcMRiM"
        let googleMapKey = "AIzaSyC3eJf_zgG-SUTnchsyfs3nQAgUqAl2mZw"
        print("origin",origin)
        print("destination",destination)
        print("googleServerKey",googleServerKey)
        print("googleMapKey",googleMapKey)
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleMapKey)"
        Alamofire.request(url).responseJSON { response in
                if let JSON = response.result.value {
                    let mapResponse: [String: AnyObject] = JSON as! [String: AnyObject]
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    let polypoints = (overviewPolyline["points"] as? String) ?? ""
                    let line  = polypoints
                    self.addPolyLine(encodedString: line)
                    //self.isDrawPathInMap = true
                }
                else {
                    print("FAILURE")
                    //self.isDrawPathInMap = false
                }
        }
    }

    func addPolyLine(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3
        polyline.strokeColor = .black
        polyline.map = mapview
        mapview.settings.myLocationButton = false

        //let zoomLevel: Double = 19.5 + log2(2)
//        let globalCamera = GMSCameraPosition.camera(withLatitude: Double(dropLatStr)!, longitude: Double(dropLongStr)!, zoom: 15)
//        self.mapview.camera = globalCamera
    }


    //--------------------------------------
    // MARK: - PROMO
    //--------------------------------------

    @IBAction func promobtnAction() {
        self.promodetailsView.isHidden = false
        self.promodetailsViewTfd.text = ""
        self.promodetailsViewTfd.becomeFirstResponder()
    }

    @IBAction func promoApplybtnAction() {
        self.promodetailsViewTfd.resignFirstResponder()
        if(promodetailsViewTfd.text?.count==0)
        {
            self.alert(message: "Please enter the promo code to apply")
        }
        else
        {
            self.promoapplyapicall()
        }
    }

    @IBAction func promoCancelbtnAction() {
        self.promodetailsViewTfd.resignFirstResponder()
        self.promodetailsView.isHidden=true
    }

    @IBAction func promoapplyapicall() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            if activityView == nil {
                activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                // add subview
//                self.searchview.bringSubview(toFront: activityView)
//                searchview.addSubview(activityView)
                self.view.bringSubviewToFront(activityView)
                self.view.addSubview(activityView)
                // autoresizing mask
                activityView.translatesAutoresizingMaskIntoConstraints = false
                // constraints
                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
            }
            ///activityView.startAnimating()
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["id"]=currentuserid
            paramDict["token"]=currentusertoken
            paramDict["promo_code"]=self.promodetailsViewTfd.text
            paramDict["request_id"]=requestid
            print(paramDict)
            let url = helperObject.BASEURL + helperObject.applypromo
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.view.showToast((JSON.value(forKey: "success_message") as! String))
                            self.promodetailsView.isHidden=true
                        } else {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.view.showToast((JSON.value(forKey: "error_message") as! String))

                        }
                    }
            }
        }
    }

    //--------------------------------------
    // MARK: - Call Action
    //--------------------------------------

    @IBAction func callBtnAction() {
        if let phoneCallURL = URL(string: "tel://"+"\(driverphonenumber)")
            //if let phoneCallURL = URL(string: "tel://123456789")
        {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    func addmarkers() {
        drivermarker.position = CLLocationCoordinate2D(latitude: drivermarkerLat, longitude: drivermarkerLong)
        drivermarker.icon=UIImage(named: "pin_driver")
        if let rotate = self.drivermarkerrBearing {
            drivermarker.rotation=rotate//self.drivermarkerrBearing
        }
        drivermarker.map = mapview
    }

    func fetchMapData1() {
        dropLatStr = String(self.appdel.droplat)
        dropLongStr = String(self.appdel.droplon)
        pickUpLat = String(drivermarkerpickLat)
        pickUpLong = String(drivermarkerpickLong)

        let origin = "\(Double(pickUpLat!)!),\(Double(pickUpLong!)!)"
        let destination = "\(Double(dropLatStr)!),\(Double(dropLongStr)!)"
        let googleServerKey = "AIzaSyDi13ALJBmh7aHD2uWsLSQ9UKDbJTcMRiM"
        let googleMapKey = "AIzaSyC3eJf_zgG-SUTnchsyfs3nQAgUqAl2mZw"
        print("origin",origin)
        print("destination",destination)
        print("googleServerKey",googleServerKey)
        print("googleMapKey",googleMapKey)
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleMapKey)"
        Alamofire.request(url).responseJSON
        { response in
            if let JSON = response.result.value {
                let mapResponse: [String: AnyObject] = JSON as! [String: AnyObject]
                let routesArray = (mapResponse["routes"] as? Array) ?? []
                let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                let polypoints = (overviewPolyline["points"] as? String) ?? ""
                let line  = polypoints
                self.addPolyLine1(encodedString: line)
            }
            else {
                print("FAILURE")
            }
        }
    }

    func addPolyLine1(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.strokeColor = .blue
        polyline.map = mapview
        mapview.settings.myLocationButton = false
        let globalCamera = GMSCameraPosition.camera(withLatitude: Double(dropLatStr)!, longitude: Double(dropLongStr)!, zoom: 15)
        self.mapview.camera = globalCamera
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func StoreUserDetails (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let driverdetail = Driverdetails(context: getContext())

        let tripdetaildriverdict = User_Details.value(forKey: "driver") as! NSDictionary

        let z: Int = Int((tripdetaildriverdict.value(forKey: "id") as? NSNumber)!)
        let mynewString = String(z)
        print("My New ID", mynewString)

        let rev = "\(tripdetaildriverdict.value(forKey: "review")!)"
        let revstring = String(rev)
        print("My New ID", revstring)

        let y=tripdetaildriverdict.value(forKey: "latitude") as! Double
        let lat = String(y)

        let x: Double = tripdetaildriverdict.value(forKey: "longitude") as! Double
        let lon = String(x)

        driverdetail.drivercarmodel = (tripdetaildriverdict.value(forKey: "car_model") as! String)
        driverdetail.drivercarnumber = (tripdetaildriverdict.value(forKey: "car_number") as! String)
        driverdetail.driveremail = (tripdetaildriverdict.value(forKey: "email") as! String)
        driverdetail.driverfirstname = (tripdetaildriverdict.value(forKey: "firstname") as! String)
        driverdetail.driverid = mynewString
        driverdetail.driverlastname = (tripdetaildriverdict.value(forKey: "lastname") as! String)
        driverdetail.driverlat = lat
        driverdetail.driverlon = lon
        driverdetail.driverphonenumber = (tripdetaildriverdict.value(forKey: "phone_number") as! String)
        driverdetail.driverprofilepict = (tripdetaildriverdict.value(forKey: "profile_pic") as! String)
        driverdetail.driverreview = revstring

        let trip = Tripdetails(context: getContext())

        let dlat = User_Details.value(forKey: "drop_latitude") as! Double
        let drlat = String(dlat)

        let dlon: Double = User_Details.value(forKey: "drop_longitude") as! Double
        let drlon = String(dlon)

        trip.tripdroplat = drlat
        trip.tripdroplon = drlon
        trip.tripdroploc = (User_Details.value(forKey: "drop_location") as! String)

        let tid: Int = Int((User_Details.value(forKey: "id") as? NSNumber)!)
        let tripidd = String(tid)
        trip.tripid = tripidd

        let tic: Int = Int((User_Details.value(forKey: "is_completed") as? NSNumber)!)
        let tripic = String(tic)
        trip.tripiscompleted = tripic


        let tids: Int = Int((User_Details.value(forKey: "is_driver_started") as? NSNumber)!)
        let tripids = String(tids)
        trip.tripisdriverstarted = tripids


        let tida: Int = Int((User_Details.value(forKey: "is_driver_arrived") as? NSNumber)!)
        let tripida = String(tida)
        trip.tripisdriverarrived = tripida


        let tits: Int = Int((User_Details.value(forKey: "is_trip_start") as? NSNumber)!)
        let tripits = String(tits)
        trip.tripistripstarted = tripits

        let tpo: Int = Int((User_Details.value(forKey: "payment_opt") as? NSNumber)!)
        let trippo = String(tpo)
        trip.trippaymentoption = trippo

        let plat = User_Details.value(forKey: "pick_latitude") as! Double
        let pilat = String(plat)

        let plon: Double = User_Details.value(forKey: "pick_longitude") as! Double
        let pilon = String(plon)
        trip.trippicklat = pilat
        trip.trippicklon = pilon
        trip.trippickloc = (User_Details.value(forKey: "pick_location") as! String)
        trip.tripstarttime = (User_Details.value(forKey: "trip_start_time") as! String)

//        let tvti: Int = Int((User_Details.value(forKey: "type") as? NSNumber)!)
//        let tripvti = String(tvti)
//        trip.tripvehicletypeid = tripvti

        //save the object
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch
        {
            
        }
    }

    func StoreUserDetails1 (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let trip = Tripdetails(context: getContext())

        let requestdetailsdict = User_Details.value(forKey: "request") as! NSDictionary


        let dlat=requestdetailsdict.value(forKey: "drop_latitude") as! Double
        let drlat = String(dlat)

        let dlon: Double = requestdetailsdict.value(forKey: "drop_longitude") as! Double
        let drlon = String(dlon)

        trip.tripdroplat = drlat
        trip.tripdroplon = drlon
        trip.tripdroploc = (requestdetailsdict.value(forKey: "drop_location") as! String)

        let tid: Int = Int((requestdetailsdict.value(forKey: "id") as? NSNumber)!)
        let tripidd = String(tid)
        trip.tripid = tripidd

        let tic: Int = Int((requestdetailsdict.value(forKey: "is_completed") as? NSNumber)!)
        let tripic = String(tic)
        trip.tripiscompleted = tripic


        let tids: Int = Int((requestdetailsdict.value(forKey: "is_driver_started") as? NSNumber)!)
        let tripids = String(tids)
        trip.tripisdriverstarted = tripids


        let tida: Int = Int((requestdetailsdict.value(forKey: "is_driver_arrived") as? NSNumber)!)
        let tripida = String(tida)
        trip.tripisdriverarrived = tripida


        let tits: Int = Int((requestdetailsdict.value(forKey: "is_trip_start") as? NSNumber)!)
        let tripits = String(tits)
        trip.tripistripstarted = tripits

        let tpo: Int = Int((requestdetailsdict.value(forKey: "payment_opt") as? NSNumber)!)
        let trippo = String(tpo)
        trip.trippaymentoption = trippo

        
        let plat=requestdetailsdict.value(forKey: "pick_latitude") as! Double
        let pilat = String(plat)

        let plon: Double = requestdetailsdict.value(forKey: "pick_longitude") as! Double
        let pilon = String(plon)
        trip.trippicklat = pilat
        trip.trippicklon = pilon
        if let trippic = (requestdetailsdict.value(forKey: "pick_location") as? String) {
            trip.trippickloc = trippic
        }
       // trip.trippickloc = (requestdetailsdict.value(forKey: "pick_location") as! String)
        trip.tripstarttime = (requestdetailsdict.value(forKey: "trip_start_time") as! String)

//        let tvti: Int = Int((requestdetailsdict.value(forKey: "type") as? NSNumber)!)
//        let tripvti = String(tvti)
//        trip.tripvehicletypeid = tripvti

        guard let userdetailsdict = User_Details.value(forKey: "user") as? NSDictionary  else {
            return }

        trip.useremail = (userdetailsdict.value(forKey: "email") as? String)
        trip.userfirstname = (userdetailsdict.value(forKey: "firstname") as? String)

        let uidd: Int = Int((userdetailsdict.value(forKey: "id") as? NSNumber)!)
        let useridd = String(uidd)
        trip.userid = useridd

        trip.userlastname = (userdetailsdict.value(forKey: "lastname") as? String)
        trip.userprofilepic = (userdetailsdict.value(forKey: "profile_pic") as? String)
        trip.userphonenumber = (userdetailsdict.value(forKey: "phone_number") as? String)

        //save the object
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch
        {
            
        }
    }

    func StoreUserDetails2 (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let driverdetail = Driverdetails(context: getContext())

        let requestdict = User_Details.value(forKey: "request") as! NSDictionary

        let tripdetaildriverdict=requestdict.value(forKey: "driver") as! NSDictionary

        let z: Int = Int((tripdetaildriverdict.value(forKey: "id") as? NSNumber)!)
        let mynewString = String(z)
        print("My New ID",mynewString)

        let rev = "\(tripdetaildriverdict.value(forKey: "review")!)"
        let revstring = String(rev)
        print("My New ID", revstring)

        driverdetail.driveremail = (tripdetaildriverdict.value(forKey: "email") as! String)
        driverdetail.driverfirstname = (tripdetaildriverdict.value(forKey: "firstname") as! String)
        driverdetail.driverid = mynewString
        driverdetail.driverlastname = (tripdetaildriverdict.value(forKey: "lastname") as! String)
        driverdetail.driverphonenumber = (tripdetaildriverdict.value(forKey: "phone_number") as! String)
        driverdetail.driverprofilepict = (tripdetaildriverdict.value(forKey: "profile_pic") as! String)
        driverdetail.driverreview = revstring

        let trip = Tripdetails(context: getContext())
        let requestdetailsdict = User_Details.value(forKey: "request") as! NSDictionary

        let tid: Int = Int((requestdetailsdict.value(forKey: "id") as? NSNumber)!)
        let tripidd = String(tid)
        trip.tripid = tripidd

        let tic: Int = Int((requestdetailsdict.value(forKey: "is_completed") as? NSNumber)!)
        let tripic = String(tic)
        trip.tripiscompleted = tripic

        let tids: Int = Int((requestdetailsdict.value(forKey: "is_driver_started") as? NSNumber)!)
        let tripids = String(tids)
        trip.tripisdriverstarted = tripids

        let tida: Int = Int((requestdetailsdict.value(forKey: "is_driver_arrived") as? NSNumber)!)
        let tripida = String(tida)
        trip.tripisdriverarrived = tripida

        let tits: Int = Int((requestdetailsdict.value(forKey: "is_trip_start") as? NSNumber)!)
        let tripits = String(tits)
        trip.tripistripstarted = tripits

        let tpo: Int = Int((requestdetailsdict.value(forKey: "payment_opt") as? NSNumber)!)
        let trippo = String(tpo)
        trip.trippaymentoption = trippo

        let tripbill = Tripbilldetails(context: getContext())
        let tripbilldict=requestdict.value(forKey: "bill") as! NSDictionary

        let bd: Double = tripbilldict.value(forKey: "base_distance") as! Double
        let basedist = String(format: "%.2f", bd)

        let bp: Double = tripbilldict.value(forKey: "base_price") as! Double
        let basepri = String(format: "%.2f", bp)

        tripbill.basedistance=basedist

        tripbill.baseprice=basepri

        tripbill.currency = (tripbilldict.value(forKey: "currency") as! String)

        let dp: Double = tripbilldict.value(forKey: "distance_price") as! Double
        let distancepri = String(format: "%.2f", dp)

        tripbill.distanceprice=distancepri

        let da: Double = tripbilldict.value(forKey: "driver_amount") as! Double
        let driveramt = String(format: "%.2f", da)

        tripbill.driveramount=driveramt

        let ppd: Double = tripbilldict.value(forKey: "price_per_distance") as! Double
        let priceperdist = String(format: "%.2f", ppd)

        tripbill.priceperdistance=priceperdist

        let ppt: Double = tripbilldict.value(forKey: "price_per_time") as! Double
        let pricepertime = String(format: "%.2f", ppt)

        tripbill.pricepertime=pricepertime

        let proamt: Double = tripbilldict.value(forKey: "promo_amount") as! Double
        let promoamt = String(format: "%.2f", proamt)

        tripbill.promoamount=promoamt

        let refamt: Double = tripbilldict.value(forKey: "referral_amount") as! Double
        let refferalamt = String(format: "%.2f", refamt)

        tripbill.referralamount=refferalamt

        let servfee: Double = tripbilldict.value(forKey: "service_fee") as! Double
        let servicefee = String(format: "%.2f", servfee)

        tripbill.servicefee=servicefee

        let servtax: Double = tripbilldict.value(forKey: "service_tax") as! Double
        let servicetax = String(format: "%.2f", servtax)

        tripbill.servicetax=servicetax

        if let extraAmnt: Double = tripbilldict.value(forKey: "extra_amount") as? Double {
        let extraAmount = String(format: "%.2f", extraAmnt)

        tripbill.additionalamount=extraAmount
        }

        tripbill.servicetaxpercentage = String((tripbilldict.value(forKey: "service_tax_percentage") as! Double))

        if let shbl: Double = tripbilldict.value(forKey: "show_bill") as? Double {
        let showbill = String(shbl)

        tripbill.showbill=showbill
        }

        if let timpri: Double = tripbilldict.value(forKey: "time_price") as? Double {
        let timeprice = String(format: "%.2f", timpri)

        tripbill.timeprice=timeprice
        }

        if let tot: Double = tripbilldict.value(forKey: "total") as? Double {
        let total = String(format: "%.2f", tot)

        tripbill.total=total
        }

        if let wp: Double = tripbilldict.value(forKey: "waiting_price") as? Double {
        let waitingprice = String(format: "%.2f", wp)

        tripbill.waitingprice=waitingprice
        }

        let wamt: Double = tripbilldict.value(forKey: "wallet_amount") as! Double
        let walletamount = String(format: "%.2f", wamt)

        tripbill.walletamount=walletamount

        if let distance = requestdict.value(forKey: "distance") as? String {
            tripbill.distance = distance
        }

        //tripbill.distance = (requestdict.value(forKey: "distance") as! String)

        let tim: Double = requestdict.value(forKey: "time") as! Double
        let time = String(format: "%.2f", tim)

        tripbill.time=time

        //save the object
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        catch
        {
            
        }
    }

    func deletedriver() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Driverdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
                //                  self.appDelegate.checkLogin()
            }
            catch let error {
                print("ERROR DELETING: \(error)")
            }
        }
    }

    func deletetrip() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tripdetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
                //                  self.appDelegate.checkLogin()
            }
            catch let error {
                print("ERROR DELETING: \(error)")
            }
        }
    }


    func deletetripbill() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tripbilldetails")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
                //                  self.appDelegate.checkLogin()
            }
            catch let error {
                print("ERROR DELETING: \(error)")
            }
        }
    }

    func deleteinvoiceviewed() {
        do {
            let context = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Invoiceviewed")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                print("Deleted!")
                //                  self.appDelegate.checkLogin()
            }
            catch let error {
                print("ERROR DELETING: \(error)")
            }
        }
    }



    // Btn Actions

    @IBAction func gotitBtnaction() {
        self.faredetailsview.isHidden=true
        gestureview.isHidden=true
    }

    @IBAction func gitBtnaction() {
        self.faredetailsview.isHidden=true
        gestureview.isHidden=true
        self.faredetview.isHidden=true
    }


    @IBAction func getfaredetailsBtnaction() {
        self.faredetailsview.isHidden=false
        gestureview.isHidden=false
    }

    @IBAction func faredetailsBtnaction() {
        self.faredetailsview.isHidden=false
        gestureview.isHidden=false
        self.faredetview.isHidden=true
    }

    @IBAction func detfareBtnaction() {
        self.faredetailsview.isHidden=true
        gestureview.isHidden=false
        self.faredetview.isHidden=false
    }
    func getCoordinatesFromPlaceId(_ placeId: String, completion:@escaping (CLLocationCoordinate2D)->()) {
        GMSPlacesClient().lookUpPlaceID(placeId) { (place, error) in
            guard error == nil else {
                return
            }
            if let coordinate = place?.coordinate {
                completion(coordinate)
            }
        }
    }
//    func drawRouteOnMap(_ repeatAnimation:Bool) {
//
//        self.mapview.clear()
//        if let selectedPickUpLocation = self.selectedPickUpLocation?.coordinate,let selectedDropLocation = self.selectedDropLocation?.coordinate {
//            let bounds = GMSCoordinateBounds(coordinate: selectedPickUpLocation, coordinate: selectedDropLocation)
//             self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
//        }
//        //let bounds = GMSCoordinateBounds(coordinate: self.selectedPickUpLocation.coordinate, coordinate: self.selectedDropLocation?.coordinate)
//
//       // self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
//
//       // print(self.selectedPickUpLocation.coordinate.bearing(to: self.selectedDropLocation.coordinate))
////        self.mapview.animate(toBearing: self.selectedDropLocation.coordinate.bearing(to: self.selectedPickUpLocation.coordinate)-40)
//        self.addMarakers()
//
//        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.selectedPickUpLocation?.latitude!),\(self.selectedPickUpLocation?.longitude!)&destination=\(self.selectedDropLocation?.latitude!),\(self.selectedDropLocation?.longitude!)&sensor=true&mode=driving&key=AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")!
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard error == nil, let data = data else {
//                print(error!.localizedDescription)
//                return
//            }
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
//                        if let routes = json["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
//                            print(points)
//                            DispatchQueue.main.async {
//                                self.animatedPolyline = AnimatedPolyLine(points,repeats:repeatAnimation)
//                                let bounds = GMSCoordinateBounds(path: self.animatedPolyline.path!)
//                                self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
//                                self.animatedPolyline.map = self.mapview
//                            }
//                        }
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }.resume()
//    }
    
    func drawRouteOnMap(_ repeatAnimation:Bool) {
        guard let selectedPickUpLocation = self.selectedPickUpLocation, let selectedDropLocation = self.selectedDropLocation else {
            return
        }
    
        self.mapview.clear()
        if let pickUpCoordinate = self.selectedPickUpLocation?.coordinate, let dropCoordinate = self.selectedDropLocation?.coordinate {
            let bounds = GMSCoordinateBounds(coordinate: pickUpCoordinate, coordinate: dropCoordinate)
            self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
            print(pickUpCoordinate.bearing(to: dropCoordinate))
            self.mapview.animate(toBearing: dropCoordinate.bearing(to: pickUpCoordinate)-40)
        }
        self.addMarakers()
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(selectedPickUpLocation.latitude!),\(selectedPickUpLocation.longitude!)&destination=\(selectedDropLocation.latitude!),\(selectedDropLocation.longitude!)&sensor=true&mode=driving&key=AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")!
        
        Alamofire.request(url).responseJSON { response in
            if case .failure(let error) = response.result
            {
                print(error.localizedDescription)
            }
            else if case .success = response.result
            {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String
                {
                    if status == "OK"
                    {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                            print(points)
                            DispatchQueue.main.async {
                                self.animatedPolyline = AnimatedPolyLine(points,repeats:repeatAnimation)
                                if let path = self.animatedPolyline?.path {
                                    let bounds = GMSCoordinateBounds(path: path)
                                    self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
                                }
                                self.animatedPolyline?.map = self.mapview
                            }
                        }
                    }
                    else
                    {
                        self.view.showToast(status)
                    }
                }
            }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
        
    }
    func addMarakers() {
        pickUpMarker = nil
        if let selectedPickUpLocation = self.selectedPickUpLocation?.coordinate {
             pickUpMarker = GMSMarker(position: selectedPickUpLocation)
        }
       // pickUpMarker = GMSMarker(position: self.selectedPickUpLocation?.coordinate)
        pickUpMarker?.icon = UIImage(named: "pickup_pin")
        pickUpMarker?.appearAnimation = .pop
        pickUpMarker?.map = mapview

        dropMarker = nil
        if let selectedDropLocation = self.selectedDropLocation?.coordinate {
            dropMarker = GMSMarker(position: selectedDropLocation)
        }
        //dropMarker = GMSMarker(position: self.selectedDropLocation?.coordinate)
        dropMarker?.icon = UIImage(named: "destination_pin")
        dropMarker?.appearAnimation = .pop
        dropMarker?.map = mapview
        self.mapview.animate(toViewingAngle: 45)
    }
}

enum RequestStatus {

    case cancelled
    case completed
    case driverArrived
    case driverStarted
    case paid
    case tripStart
    case userRated

    init?(_ dict: [String:AnyObject]) {

        if let isCancelled = dict["is_cancelled"] as? Bool, isCancelled {
            self = .cancelled
        }
        else if let isUserRated = dict["is_user_rated"] as? Bool, isUserRated {
            self = .userRated
        }
        else if let isPaid = dict["is_paid"] as? Bool, isPaid {
            self = .paid
        }
        else if let isCompleted = dict["is_completed"] as? Bool, isCompleted {
            self = .completed
        }
        else if let isTripStart = dict["is_trip_start"] as? Bool, isTripStart {
            self = .tripStart
        }
        else if let isDriverArrived = dict["is_driver_arrived"] as? Bool, isDriverArrived {
            self = .driverArrived
        }
        else if let isDriverStarted = dict["is_driver_started"] as? Bool, isDriverStarted {
            self = .driverStarted
        }
        else {
            return nil
        }
    }
}

