//
//  pickupViewController.swift
//  tapngo
//
//  Created by Mohammed Arshad on 04/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import SWRevealViewController
import CoreData
import Alamofire
import NVActivityIndicatorView
import SocketIO
import DateTimePicker
import GooglePlaces
import Kingfisher
import CoreLocation

class PickupViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UIGestureRecognizerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    struct Car:Equatable {
        static func == (lhs: Car, rhs: Car) -> Bool {
            return lhs.id == rhs.id
        }
        var id: Int!
        var bearing:Double!
        var latitude:Double!
        var longitude:Double!
        var type: Int!
    }


//    enum LocationPoint: String
//    {
//        case pickUp
//        case drop
//    }
    struct FavouriteLocation {
        enum FavouriteType {
            case home
            case work
            case other
        }
        var title: String!
        var type:FavouriteType = .home
        var place: String!
        var latitude: String!
        var longitude: String!
    }

    @IBOutlet weak var mapview: GMSMapView!
//    var mapViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet var pickupfromlbl: UILabel!
    @IBOutlet weak var fromAddrtf: UITextField!
    @IBOutlet weak var pickupview: UIView!
    var pickUpViewLeading: NSLayoutConstraint!
    var pickUpViewTrailing: NSLayoutConstraint!
    @IBOutlet var pickupviewfaviv: UIImageView!
    @IBOutlet var pickupviewfavbtn: UIButton!
//    @IBOutlet weak var searchview: UIView!
//    @IBOutlet weak var searchtfdview: UIView!

    @IBOutlet var dropatlbl: UILabel!
    @IBOutlet weak var toAddrtf: UITextField!
    @IBOutlet weak var dropview: UIView!
    var dropViewLeading: NSLayoutConstraint!
    var dropViewTrailing: NSLayoutConstraint!
    @IBOutlet var dropviewfaviv: UIImageView!
    @IBOutlet var dropviewfavbtn: UIButton!
//    @IBOutlet weak var searchlistTbv: UITableView!

    @IBOutlet weak var tripview: UIView!

    @IBOutlet weak var rideview: UIView!

    @IBOutlet weak var providerdetailsview: UIView!

//    @IBOutlet weak var searchviewheaderLbl: UILabel!

    var menuButton: UIBarButtonItem!
    var locationManager: CLLocationManager!
    var locValue:CLLocationCoordinate2D!
    let geoCoder = CLGeocoder()
//    var pickUpMarker = GMSMarker()
//    var dropMarker = GMSMarker()
    var stateMarker = GMSMarker()
    var tapGesture1: UITapGestureRecognizer!
    var tap: UITapGestureRecognizer!

    var droploctap: UITapGestureRecognizer!
    var pickuploctap: UITapGestureRecognizer!

    let helperObject = APIHelper()

    var globalCamera = GMSCameraPosition()
    //var tapGesture: UITapGestureRecognizer=UITapGestureRecognizer!
    var pickUpLat: String! = ""
    var pickUpLong: String! = ""

    var currentuserid: String! = ""
    var currentusertoken: String! = ""

    var currentfav: String! = ""

    var firsttime: String! = ""

    var location=CLLocation()

    var arr=NSArray()
//    var placenamearray=NSMutableArray()
//    var favlistidarray=NSMutableArray()
//    var placeaddressarray=NSMutableArray()
//    var addressarray=NSMutableArray()
//    var isfavouritearray=NSMutableArray()

//    var cellselectedarray=NSMutableArray()


    var descrarr = NSArray()
    var soslistarray = NSArray()
    var jsonString = NSString()
    var jsonString1 = NSString()
    var jsonString11 = NSString()
    var activityView: NVActivityIndicatorView!
    let appdel = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var viewDottedLines: UIView!
    @IBOutlet var favouriteview: UIView!
    @IBOutlet var favouriteviewhomeLbl: UILabel!
    @IBOutlet var favouriteviewhomeBtn: UIButton!
    @IBOutlet var favouriteviewworkLbl: UILabel!
    @IBOutlet var favouriteviewworkBtn: UIButton!
    @IBOutlet var favouriteviewotherLbl: UILabel!
    @IBOutlet var favouriteviewotherBtn: UIButton!
    @IBOutlet var favouriteviewotherTfd: UITextField!
    @IBOutlet var favouriteviewfavImv: UIImageView!
    @IBOutlet var favouriteviewaddressLbl: UILabel!
    @IBOutlet weak var favSepView1: UIView!
    @IBOutlet weak var favSepView2: UIView!
    @IBOutlet var favouriteviewcancelBtn: UIButton!
    @IBOutlet var favouriteviewsaveBtn: UIButton!

    var selectedFavLocation = FavouriteLocation()


//    var selectedcartypeid = String()

    @IBOutlet var lblGettingAddress: UILabel!
    @IBOutlet var imagedownArrowPickup: UIImageView!
    @IBOutlet var imageDottedLine: UIImageView!
    @IBOutlet var imageMarkerDottedline: UIImageView!
    @IBOutlet weak var imagex: UIImageView!
//    @IBOutlet weak var searchTfd: UITextField!

    @IBOutlet var pickupcolorview: UIView!

    @IBOutlet var dropcolorview: UIView!

   // let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.18: 3001")! as URL)

   // let socket = SocketIOClient(socketURL: NSURL(string: "http://tapngo.online: 3001")! as URL)

    //let socket = SocketIOClient(socketURL: APIHelper.socketUrl)
    
    let socket = SocketIOClient(socketURL: APIHelper.socketUrl,
                                config: SocketIOClientConfiguration(arrayLiteral: .reconnects(true),.reconnectAttempts(-1),.nsp("/home")))

    var red, green, blue: Double!

//    var providertypesarray=NSMutableArray()
    var carModels: [CarModel] = []
    var selectedCarModel: CarModel!
//    var carsarray = NSMutableArray()
//    var carslatarray = NSMutableArray()
//    var carslonarray = NSMutableArray()
//    var carsbearingarray = NSMutableArray()
    @IBOutlet weak var collectionvw: UICollectionView!

    var pickuplat = Double()
    var pickuplon = Double()

    var droplat = Double()
    var droplon = Double()

    var tripstatusdata = String()

    @IBOutlet weak var rideBtnsBgView: UIView!
    @IBOutlet var ridenowBtn: UIButton!
    @IBOutlet var ridelaterbtn: UIButton!

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!, bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    let favOtherBtn = UIButton(type: .custom), favWorkBtn = UIButton(type: .custom), favHomeBtn = UIButton(type: .custom)
//    var currentLocationPoint:LocationPoint = .pickUp
    var selectedPickUpLocation:SearchLocation!
    var selectedDropLocation:SearchLocation!
    var pickUpLocationSelectedClousure:((SearchLocation) -> Void)?
    var dropLocationSelectedClousure:((SearchLocation) -> Void)?


    var mapViewWillMoveGesture = false
//    var imageMarkerBottomPos: NSLayoutConstraint!

    @objc func resetTripDetails() {
        //RESET PICKUP, DROP & CAR MODEL DETAILS AFTER COMPLETING A TRIP
        guard let dropViewIndex = self.view.subviews.index(of: self.dropview), let pickUpViewIndex = self.view.subviews.index(of: self.pickupview) else {
            return
        }
        if dropViewIndex > pickUpViewIndex {
            self.pickuptapDetected(UITapGestureRecognizer())
        }


        if let firstModel = self.carModels.first {
            self.selectedCarModel = firstModel
            self.collectionvw.reloadData()
        }
        self.selectedDropLocation = nil
        self.toAddrtf.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager=CLLocationManager()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startMonitoringSignificantLocationChanges()

         NotificationCenter.default.addObserver(self, selector: #selector(resetTripDetails), name: Notification.Name(rawValue: "Trip Completed"), object: nil)

        //Closure performed On Pickup Location Selectoin in Search/Favourite
        self.pickUpLocationSelectedClousure = { selectedSearchLoc in
            self.fromAddrtf.text = selectedSearchLoc.placeId
            self.selectedPickUpLocation = selectedSearchLoc
            if selectedSearchLoc.locationType == .googleSearch {
//                self.getCoordinatesFromPlaceId(selectedSearchLoc.googlePlaceId!, completion: { locCoordinate in
//                    self.selectedPickUpLocation.latitude = locCoordinate.latitude
//                    self.selectedPickUpLocation.longitude = locCoordinate.longitude
//                    self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: locCoordinate.latitude, longitude: locCoordinate.longitude))
//                })
                self.getCoordFromGoogle(selectedSearchLoc.googlePlaceId!, completion: { (location) in
                    self.selectedPickUpLocation?.latitude = location.latitude
                    self.selectedPickUpLocation?.longitude = location.longitude
                    self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                })
            }
            else {
                let locCoordinate = CLLocationCoordinate2D(latitude: selectedSearchLoc.latitude, longitude: selectedSearchLoc.longitude)
                self.mapview.animate(toLocation: locCoordinate)
            }
        }
        //Closure performed On Drop Location Selectoin in Search/Favourite
        self.dropLocationSelectedClousure = { selectedSearchLoc in
            guard let dropViewIndex = self.view.subviews.index(of: self.dropview), let pickUpViewIndex = self.view.subviews.index(of: self.pickupview) else {
                return
            }
            if dropViewIndex < pickUpViewIndex {
                self.pickUpViewLeading.constant = 25
                self.pickUpViewTrailing.constant = -25
                self.dropViewLeading.constant = 15
                self.dropViewTrailing.constant = -15
                self.dropviewfavbtn.isHidden = false
                self.dropviewfaviv.isHidden = false
                self.pickupviewfaviv.isHidden = true
                self.pickupviewfavbtn.isHidden = true
                self.view.layoutSubviews()
                self.dropview.backgroundColor = UIColor.white
                self.pickupview.backgroundColor = UIColor(red: 238/255, green: 239/255, blue: 234/255, alpha: 0.8)
                self.view.layoutIfNeeded()
                self.view.bringSubviewToFront(self.dropview)
            }
            self.toAddrtf.text = selectedSearchLoc.placeId
            self.selectedDropLocation = selectedSearchLoc
            if selectedSearchLoc.locationType == .googleSearch {
//                self.getCoordinatesFromPlaceId(selectedSearchLoc.googlePlaceId!, completion: { locCoordinate in
//                    self.selectedDropLocation.latitude = locCoordinate.latitude
//                    self.selectedDropLocation.longitude = locCoordinate.longitude
//                    self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: locCoordinate.latitude, longitude: locCoordinate.longitude))
//                })
                self.getCoordFromGoogle(selectedSearchLoc.googlePlaceId!, completion: { (location) in
                    self.selectedDropLocation?.latitude = location.latitude
                    self.selectedDropLocation?.longitude = location.longitude
                    DispatchQueue.main.async(execute: {
                        self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    })

                })
            }
            else {
                let locCoordinate = CLLocationCoordinate2D(latitude: selectedSearchLoc.latitude, longitude: selectedSearchLoc.longitude)
                self.mapview.animate(toLocation: locCoordinate)
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
        self.mapview.isMyLocationEnabled = true
        self.mapview.settings.myLocationButton = true

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22.0
//        button.backgroundColor = .themeColor
        button.imageView?.tintColor = UIColor.secondaryColor
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.menuButton = UIBarButtonItem(customView: button)

        self.navigationItem.leftBarButtonItem = self.menuButton
        self.navigationItem.backBtnString = ""


        tripstatusdata="first"
        self.getUser()

        //FIXME:- RJK Fix me
//        if(self.appdel.isdriverstarted=="1") {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tripViewController") as! tripViewController
//            vc.navigationItem.hidesBackButton = true
//            vc.selectedCarModel = self.selectedCarModel
//            self.navigationController?.pushViewController(vc, animated: true)
//        }

        self.pickupview.layer.cornerRadius=5
        self.dropview.layer.cornerRadius=5
        self.pickupcolorview.layer.cornerRadius=5
        self.dropcolorview.layer.cornerRadius=5
        firsttime="true"




        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.viewDottedLines.isHidden=true
        self.imageDottedLine.isHidden=true
//        self.imageMarkerDottedline.isHidden=true
        self.imagex.isHidden=true

        self.tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(PickupViewController.droptapDetected(_:)))
        self.tapGesture1.delegate = self
        dropview.addGestureRecognizer(self.tapGesture1)

        self.tap = UITapGestureRecognizer(target: self, action: #selector(PickupViewController.pickuptapDetected(_:)))
        self.tap.delegate = self
        pickupview.addGestureRecognizer(self.tap)

//        self.droploctap = UITapGestureRecognizer(target: self, action: #selector(pickupViewController.droploctapDetected(_:)))
//        self.droploctap.delegate = self

//        self.pickuploctap = UITapGestureRecognizer(target: self, action: #selector(pickupViewController.pickuploctapDetected(_:)))
//        self.pickuploctap.delegate = self
//
//        self.pickupview.addGestureRecognizer(self.pickuploctap)
//        self.getfavouritelistApi()

        self.updateStatus()

        if self.appdel.cancelledrequest=="YES" {
            self.appdel.cancelledrequest = "NO"
            self.view.showToast("Request cancelled.")
        }
        if(self.appdel.tripscheduled=="Yes") {
            self.appdel.tripscheduled = "No"
            self.view.showToast("Trip Scheduled")
        }
        self.setUpViews()
    }

    func setUpViews() {

        self.dropviewfavbtn.isHidden = true
        self.dropviewfaviv.isHidden = true
        self.pickupviewfaviv.isHidden = false
        self.pickupviewfavbtn.isHidden = false
        self.pickupfromlbl.font = UIFont.appFont(ofSize: 12)
        self.dropatlbl.font = UIFont.appFont(ofSize: 12)
        self.fromAddrtf.font = UIFont.appFont(ofSize: 14)
        self.toAddrtf.font = UIFont.appFont(ofSize: 14)

        self.favouriteviewhomeLbl.font = UIFont.appFont(ofSize: 15)
        self.favouriteviewworkLbl.font = UIFont.appFont(ofSize: 15)
        self.favouriteviewotherLbl.font = UIFont.appFont(ofSize: 15)
        self.favouriteviewotherTfd.font = UIFont.appFont(ofSize: 14)
        self.favouriteviewaddressLbl.font = UIFont.appFont(ofSize: 14)
        favouriteviewaddressLbl.textAlignment = .center
        self.favouriteviewcancelBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.favouriteviewsaveBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)

        self.ridelaterbtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.ridenowBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.ridelaterbtn.setTitleColor(.themeColor, for: .normal)
        self.ridelaterbtn.setTitle(self.ridelaterbtn.titleLabel?.text!.uppercased(), for: .normal)
        self.ridenowBtn.setTitle(self.ridenowBtn.titleLabel?.text!.uppercased(), for: .normal)
        self.ridenowBtn.setTitleColor(.themeColor, for: .normal)
        self.ridenowBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)

//        self.searchviewheaderLbl.font = UIFont.appTitleFont(ofSize: 17)
//        self.searchTfd.font = UIFont.appFont(ofSize: 14)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        pickupfromlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupfromlbl"] = pickupfromlbl
        fromAddrtf.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fromAddrtf"] = fromAddrtf
        pickupview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupview"] = pickupview
        pickupviewfaviv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupviewfaviv"] = pickupviewfaviv
        pickupviewfaviv.contentMode = .scaleAspectFit
        pickupviewfavbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupviewfavbtn"] = pickupviewfavbtn
//        searchview.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["searchview"] = searchview
//        searchtfdview.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["searchtfdview"] = searchtfdview
        dropatlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropatlbl"] = dropatlbl
        toAddrtf.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["toAddrtf"] = toAddrtf
        dropview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropview"] = dropview
        dropviewfaviv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropviewfaviv"] = dropviewfaviv
        dropviewfavbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropviewfavbtn"] = dropviewfavbtn
//        searchlistTbv.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["searchlistTbv"] = searchlistTbv
        providerdetailsview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["providerdetailsview"] = providerdetailsview
//        searchviewheaderLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["searchviewheaderLbl"] = searchviewheaderLbl
        viewDottedLines.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewDottedLines"] = viewDottedLines

        favouriteview = UIView()
        favouriteview.isHidden = true
        favouriteview.backgroundColor = .white
        self.view.addSubview(favouriteview)
        favouriteview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteview"] = favouriteview
        favouriteview.subviews.forEach { $0.removeFromSuperview() }


        favHomeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        favHomeBtn.adjustsImageWhenDisabled = false
        favHomeBtn.adjustsImageWhenHighlighted = false
        favHomeBtn.addTarget(self, action: #selector(favviewhomeBtnaction), for: .touchUpInside)
        favHomeBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        favHomeBtn.imageView?.contentMode = .scaleAspectFit
        favHomeBtn.setTitle("Home".localize(), for: .normal)
        favHomeBtn.setTitleColor(.black, for: .normal)
        favHomeBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favHomeBtn"] = favHomeBtn
        favviewhomeBtnaction()

        favWorkBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        favWorkBtn.adjustsImageWhenDisabled = false
        favWorkBtn.adjustsImageWhenHighlighted = false
        favWorkBtn.addTarget(self, action: #selector(favviewworkBtnaction), for: .touchUpInside)
        favWorkBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        favWorkBtn.imageView?.contentMode = .scaleAspectFit
        favWorkBtn.setTitle("Work".localize(), for: .normal)
        favWorkBtn.setTitleColor(.black, for: .normal)
        favWorkBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favWorkBtn"] = favWorkBtn

        favOtherBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        favOtherBtn.adjustsImageWhenDisabled = false
        favOtherBtn.adjustsImageWhenHighlighted = false
        favOtherBtn.addTarget(self, action: #selector(favviewotherBtnaction), for: .touchUpInside)
        favOtherBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        favOtherBtn.imageView?.contentMode = .scaleAspectFit
        favOtherBtn.setTitle("Other".localize(), for: .normal)
        favOtherBtn.setTitleColor(.black, for: .normal)
        favOtherBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favOtherBtn"] = favOtherBtn

        let favBtnsBgView = UIView()
        favBtnsBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favBtnsBgView"] = favBtnsBgView
        favBtnsBgView.addSubview(favHomeBtn)
        favBtnsBgView.addSubview(favWorkBtn)
        favBtnsBgView.addSubview(favOtherBtn)

        let favStackView = UIStackView(arrangedSubviews: [favBtnsBgView,favouriteviewotherTfd])
        favStackView.distribution = .fillProportionally
        favStackView.alignment = .fill
        favStackView.axis = .vertical
        favStackView.spacing = 10
        favStackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favStackView"] = favStackView

        favouriteview.addSubview(favStackView)
        favouriteview.addSubview(favSepView1)
        favouriteview.addSubview(favSepView2)
        favouriteview.addSubview(favouriteviewfavImv)
        favouriteview.addSubview(favouriteviewaddressLbl)
        favouriteview.addSubview(favouriteviewcancelBtn)
        favouriteview.addSubview(favouriteviewsaveBtn)

        favSepView1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favSepView1"] = favSepView1
        favSepView2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favSepView2"] = favSepView2
        favouriteviewotherTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteviewotherTfd"] = favouriteviewotherTfd
        favouriteviewfavImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteviewfavImv"] = favouriteviewfavImv
        favouriteviewaddressLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteviewaddressLbl"] = favouriteviewaddressLbl
        favouriteviewcancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteviewcancelBtn"] = favouriteviewcancelBtn
        favouriteviewsaveBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favouriteviewsaveBtn"] = favouriteviewsaveBtn

        lblGettingAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblGettingAddress"] = lblGettingAddress
        imagedownArrowPickup.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imagedownArrowPickup"] = imagedownArrowPickup
        imageDottedLine.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imageDottedLine"] = imageDottedLine
        imageMarkerDottedline.contentMode = .bottom
//        self.imageMarkerDottedline.isHidden = true
        self.imageMarkerDottedline.image = UIImage(named: "pickup_pin")

        imageMarkerDottedline.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imageMarkerDottedline"] = imageMarkerDottedline
        imagex.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imagex"] = imagex
//        searchTfd.translatesAutoresizingMaskIntoConstraints = false
//        layoutDic["searchTfd"] = searchTfd
        pickupcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupcolorview"] = pickupcolorview
        dropcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropcolorview"] = dropcolorview
        collectionvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["collectionvw"] = collectionvw
        rideBtnsBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rideBtnsBgView"] = rideBtnsBgView
        ridenowBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridenowBtn"] = ridenowBtn
        ridelaterbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridelaterbtn"] = ridelaterbtn

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapview]|", options: [], metrics: nil, views: layoutDic))

        pickupview.topAnchor.constraint(equalTo: self.top, constant: 25).isActive = true

        self.pickUpViewLeading = pickupview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        self.pickUpViewLeading.isActive = true
        self.view.addConstraint(self.pickUpViewLeading)
        self.pickUpViewTrailing = pickupview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
        self.pickUpViewTrailing.isActive = true
        self.view.addConstraint(self.pickUpViewTrailing)
        self.dropViewLeading = dropview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25)
        self.dropViewLeading.isActive = true
        self.view.addConstraint(self.dropViewLeading)
        self.dropViewTrailing = dropview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25)
        self.dropViewTrailing.isActive = true
        self.view.addConstraint(self.dropViewTrailing)


        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pickupview(60)]", options: [], metrics: nil, views: layoutDic))
        dropview.topAnchor.constraint(equalTo: self.top, constant: 55).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dropview(60)]", options: [], metrics: nil, views: layoutDic))
        rideBtnsBgView.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[rideBtnsBgView]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[providerdetailsview(80)][rideBtnsBgView(48)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
            rideBtnsBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(1)-[ridelaterbtn]-(1)-[ridenowBtn(==ridelaterbtn)]-(1)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        rideBtnsBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(1)-[ridenowBtn]-(1)-|", options: [], metrics: nil, views: layoutDic))
        providerdetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionvw]|", options: [], metrics: nil, views: layoutDic))
        providerdetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionvw]|", options: [], metrics: nil, views: layoutDic))


        //PICKUPVIEW
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[pickupcolorview(7)]-(10)-[pickupfromlbl]-(10)-[pickupviewfavbtn(35)]|", options: [], metrics: nil, views: layoutDic))
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[fromAddrtf]-(10)-[pickupviewfavbtn]", options: [], metrics: nil, views: layoutDic))
        pickupviewfaviv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pickupviewfaviv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pickupviewfaviv.centerXAnchor.constraint(equalTo: pickupviewfavbtn.centerXAnchor).isActive = true
        pickupviewfaviv.centerYAnchor.constraint(equalTo: fromAddrtf.centerYAnchor).isActive = true
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[pickupfromlbl(20)]-(0)-[fromAddrtf(30)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        pickupcolorview.heightAnchor.constraint(equalToConstant: 7).isActive = true
        pickupcolorview.centerYAnchor.constraint(equalTo: pickupfromlbl.centerYAnchor).isActive = true
        pickupview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pickupviewfavbtn]|", options: [], metrics: nil, views: layoutDic))

        //DROPVIEW

        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[dropcolorview(7)]-(10)-[dropatlbl]-(10)-[dropviewfavbtn(35)]|", options: [], metrics: nil, views: layoutDic))
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[toAddrtf]-(10)-[dropviewfavbtn]", options: [], metrics: nil, views: layoutDic))
        dropviewfaviv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dropviewfaviv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dropviewfaviv.centerXAnchor.constraint(equalTo: dropviewfavbtn.centerXAnchor).isActive = true
        dropviewfaviv.centerYAnchor.constraint(equalTo: toAddrtf.centerYAnchor).isActive = true
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[dropatlbl(20)]-(0)-[toAddrtf(30)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        dropcolorview.heightAnchor.constraint(equalToConstant: 7).isActive = true
        dropcolorview.centerYAnchor.constraint(equalTo: dropatlbl.centerYAnchor).isActive = true
        dropview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dropviewfavbtn]|", options: [], metrics: nil, views: layoutDic))


        imageMarkerDottedline.widthAnchor.constraint(equalToConstant: 23).isActive = true
        imageMarkerDottedline.heightAnchor.constraint(equalToConstant: 41).isActive = true
        imageMarkerDottedline.centerXAnchor.constraint(equalTo: self.mapview.centerXAnchor).isActive = true
       // imageMarkerDottedline.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
         imageMarkerDottedline.centerYAnchor.constraint(equalTo: self.mapview.centerYAnchor, constant: 0).isActive = true
//        imageMarkerBottomPos.isActive = true
//        self.view.addConstraint(imageMarkerBottomPos)
//        nt(equalTo: self.mapview.centerYAnchor).isActive = true


        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[favouriteview]-(20)-|", options: [], metrics: nil, views: layoutDic))

        favouriteview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        favouriteview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[favStackView]-(15)-[favouriteviewaddressLbl(>=30)]-(5)-[favSepView1(0.5)]-(5)-[favouriteviewsaveBtn(30)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        favBtnsBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[favHomeBtn]-(>=5)-[favWorkBtn(==favHomeBtn)]-(>=5)-[favOtherBtn(==favHomeBtn)]-(25)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        favBtnsBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[favHomeBtn(25)]-(0)-|", options: [], metrics: nil, views: layoutDic))
//        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[favHomeBtn]-(>=5)-[favWorkBtn(==favHomeBtn)]-(>=5)-[favOtherBtn(==favHomeBtn)]-(25)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        favouriteview.addConstraint(NSLayoutConstraint.init(item: favHomeBtn, attribute: .centerX, relatedBy: .equal, toItem: favouriteview, attribute: .centerX, multiplier: 0.5, constant: 0))
        favouriteview.addConstraint(NSLayoutConstraint.init(item: favWorkBtn, attribute: .centerX, relatedBy: .equal, toItem: favouriteview, attribute: .centerX, multiplier: 1, constant: 0))
        favouriteview.addConstraint(NSLayoutConstraint.init(item: favOtherBtn, attribute: .centerX, relatedBy: .equal, toItem: favouriteview, attribute: .centerX, multiplier: 1.5, constant: 0))


        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[favStackView]-(15)-|", options: [], metrics: nil, views: layoutDic))
        let hght = favouriteviewotherTfd.heightAnchor.constraint(equalToConstant: 30)
        hght.priority = UILayoutPriority(rawValue: 250)
        hght.isActive = true
        favouriteviewotherTfd.addConstraint(hght)
        favouriteviewaddressLbl.numberOfLines = 0
        favouriteviewaddressLbl.lineBreakMode = .byWordWrapping
        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[favouriteviewfavImv(20)]-(10)-[favouriteviewaddressLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        favouriteviewfavImv.centerYAnchor.constraint(equalTo: favouriteviewaddressLbl.centerYAnchor).isActive = true
        favouriteviewfavImv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[favouriteviewfavImv(20)]-(10)-[favouriteviewaddressLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[favSepView1]-(10)-|", options: [], metrics: nil, views: layoutDic))
        favouriteview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[favouriteviewcancelBtn]-(5)-[favSepView2(1)]-(5)-[favouriteviewsaveBtn(==favouriteviewcancelBtn)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllBottom,.alignAllTop], metrics: nil, views: layoutDic))



//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "", options: [], metrics: nil, views: layoutDic))
    }

    @IBAction func selectDateTimeBtnTapped(_ sender: Any) {
        var errmsg=String()
        if(self.fromAddrtf.text?.count==0) {
            errmsg="Please choose pickup location"
        } else if(self.toAddrtf.text?.count==0) {
            errmsg="Please choose drop location"
        } else if self.selectedCarModel == nil {
            errmsg="Please choose car type"
        }
        if(errmsg.count>0) {
            self.alert(message: errmsg)
        } else             {
            self.appdel.pickuplat=pickuplat
            self.appdel.pickuplon=pickuplon
            self.appdel.droplat=droplat
            self.appdel.droplon=droplon
            self.appdel.fromaddr=self.fromAddrtf.text!
            self.appdel.toaddr=self.toAddrtf.text!
            let min = Date().addingTimeInterval(60*30)//30 mins
            let max = Date().addingTimeInterval(60 * 60 * 24 * 31)
            let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
            picker.show()
            //picker.show(minimumDate: min, maximumDate: max)
            picker.highlightColor = UIColor.red
            picker.darkColor = UIColor.black
            picker.doneButtonTitle = "!! DONE !!"
            picker.darkColor.withAlphaComponent(1.0)
            picker.tintColor = UIColor.black
            picker.todayButtonTitle = "Today"
            picker.is12HourFormat = true
            picker.dateFormat = "YYYY-MM-dd hh:mm aa"
            picker.completionHandler = { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd hh:mm aa"
                print("The date and Time is: ",formatter.string(from: date))

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateStr: String = dateFormatter.string(from: date)
                print("The date is: ",dateStr)

                let displaydateFormatter = DateFormatter()
                displaydateFormatter.dateFormat = "MMM dd, yyyy"
                let displaydateStr: String = displaydateFormatter.string(from: date)
                print("The date is: ", displaydateStr)
                self.appdel.displaydate=displaydateStr

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm aa"
                let timeStr: String = timeFormatter.string(from: date)
                print("The time is: ",timeStr)

                // current time with date

                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm aa"
                let dateInFormat = dateFormatter1.string(from: NSDate() as Date)
                let curdate=dateFormatter1.date(from: dateInFormat)
                print("the current date and time is: ", curdate!)

                // picked time with date

                let datetimestring = dateStr + " " + timeStr
                let pickdate=dateFormatter1.date(from: datetimestring)
                print("The picked date and time is: ", pickdate!)
                // Difference

                let distancebetweendates :TimeInterval=pickdate! .timeIntervalSince(curdate!)
                print("The difference is: ", distancebetweendates)
                let minutesbetween=distancebetweendates/60
                print("The minutes between dates is", minutesbetween)

                if(minutesbetween<30) {
                    print("Less then 30 minutes")
                    self.view.showToast("Time should be greater than 30 mins")
                }
                else {
                    print("greater then 30 minutes")
                    self.appdel.scheduletime=timeStr
                    self.appdel.scheduledate=dateStr
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "scheduletripviewcontroller") as! ScheduleTripViewVontroller
                    vc.selectedDate = date
                    vc.selectedCarModel = self.selectedCarModel
                    vc.selectedPickUpLocation = self.selectedPickUpLocation
                    vc.selectedDropLocation = self.selectedDropLocation
                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.performSegue(withIdentifier: "seguefrompickuptoscheduletrip", sender: self)
                }
            }
        }
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func updateStatus() {

        let lbl = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 20, width: UIScreen.main.bounds.width/2, height: 20))
        socket.on(clientEvent: .statusChange) { (dataArr, _) in
            guard let status = dataArr.first as? SocketIOClientStatus else {
                return
            }
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            if !window.subviews.contains(lbl) {
                window.addSubview(lbl)
            }
            lbl.isHidden = false
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = true
            lbl.backgroundColor = .red
            lbl.textColor = .black
            switch status {
            case .connected: lbl.text = "socket connected"
            case .notConnected: lbl.text = "socket notConnected";self.socket.reconnect()
            case .connecting: lbl.text = "socket connecting"
            case .disconnected: lbl.text = "socket disconnected"
            }
        }
    }

    func connectsocket() {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        guard let location = AppLocationManager.shared.locationManager.location?.coordinate else {
            return
        }

        let bearing1 = AppLocationManager.shared.locationManager.heading?.magneticHeading

        jsonObject.setValue( location.latitude, forKey: "lat")
        jsonObject.setValue(location.latitude, forKey: "lng")
        jsonObject.setValue(bearing1, forKey: "bearing")
        jsonObject.setValue(currentuserid, forKey: "id")

        let jsonData: NSData
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            self.jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
            print("json string = \(self.jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        addHandlers1()
        self.socket.connect()
       self.updateStatus()
    }

    func addHandlers1() {
        //socket.nsp = "/home
        self.socket.on("connect") {data, ack in
            print("socket connected")
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
            if(self.pickupview.frame.width>self.dropview.frame.width) {
                self.socket.emit("start_connect", self.jsonString11)
                print("start connect jsonString", self.jsonString11)
            }

            // emitting for sending location
            
            let jsonObject1: NSMutableDictionary = NSMutableDictionary()
            if(self.locValue==nil) {
            }
            else {
                let bearing = AppLocationManager.shared.locationManager.heading?.magneticHeading
            jsonObject1.setValue( self.locValue.latitude, forKey: "lat")
            jsonObject1.setValue(self.locValue.longitude, forKey: "lng")
            jsonObject1.setValue(bearing, forKey: "bearing")
            jsonObject1.setValue(self.currentuserid, forKey: "id")

            let jsonData1: NSData
            do {
                jsonData1 = try JSONSerialization.data(withJSONObject: jsonObject1, options: JSONSerialization.WritingOptions()) as NSData
                self.jsonString1 = NSString(data: jsonData1 as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
                print("json string = \(self.jsonString1)")
            }
            catch _ {
                print ("JSON Failure")
            }

                if(self.pickupview.frame.width>self.dropview.frame.width) {
                    self.socket.emit("set_location", self.jsonString1)
                }
            }
            // Emitting for types


            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            if(self.locValue==nil) {
            }
            else {
                jsonObject.setValue( self.locValue.latitude, forKey: "lat")
                jsonObject.setValue(self.locValue.longitude, forKey: "lng")
                jsonObject.setValue(self.currentuserid, forKey: "id")
                let jsonData: NSData
                do {
                jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
                self.jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
                print("json string = \(self.jsonString)")
                }
                catch _ {
                    print ("JSON Failure")
                }
                self.socket.emit("types", self.jsonString)
            }
            self.gettypesdata()
            self.socket.on("types") {data, ack in
                print("Message for you! \(data[0])")
                if(self.pickupview.frame.width>self.dropview.frame.width) {
                    self.socket.emit("set_location", self.jsonString)
                }
            }

            self.socket.on("trip_status"){
                data, ack in
                print("trips for you! \(data[0])")
                let JSON = data[0] as! NSDictionary
                print(JSON)
                if(self.tripstatusdata=="first") {
                    self.appdel.tripJSON=JSON
                    self.tripstatusdata="second"
                }
            }
        }
    }

    func emitinglocation() {
        let jsonObject1: NSMutableDictionary = NSMutableDictionary()

        jsonObject1.setValue(self.locValue.latitude, forKey: "lat")
        jsonObject1.setValue(self.locValue.longitude, forKey: "lng")
        jsonObject1.setValue("22.0", forKey: "bearing")
        jsonObject1.setValue(self.currentuserid, forKey: "id")
        let jsonData1: NSData
        do {
            jsonData1 = try JSONSerialization.data(withJSONObject: jsonObject1, options: JSONSerialization.WritingOptions()) as NSData
            self.jsonString1 = NSString(data: jsonData1 as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
            print("json string = \(self.jsonString1)")
        } catch _ {
            print ("JSON Failure")
        }
        if(self.pickupview.frame.width>self.dropview.frame.width) {
            self.socket.emit("set_location", self.jsonString1)
        }
    }

    func gettypesdata() {
        self.socket.on("types") {
            data, ack in
            print("Types for you! \(data[0])")
            let JSON = data[0] as! NSDictionary
            print(JSON)
            let theSuccess = (JSON.value(forKey: "success") as! Bool)

            if(theSuccess == true) {
                if let types = JSON.value(forKey: "types") as? [[String:AnyObject]] {
                    self.carModels = types.map({ CarModel($0) })
                }
                if self.selectedCarModel == nil, let firstCarModel = self.carModels.first {
                    self.selectedCarModel = firstCarModel
                    self.providerdetailsview.isHidden=false

                }
                self.collectionvw.reloadData()

//                self.providertypesarray=NSMutableArray()
//                self.cellselectedarray=NSMutableArray()
//                self.providertypesarray=(JSON.value(forKey: "types") as! NSArray as! NSMutableArray)
//                if(self.providertypesarray.count>0) {
//                    for array in self.providertypesarray {
//                        print(array)
//                        self.cellselectedarray.add("NO")
//                    }
//                }
//                print(self.providertypesarray)
//                if(self.providertypesarray.count>0) {
//                    self.providerdetailsview.isHidden=false
//                    self.collectionvw.alwaysBounceVertical=true
//                    if(self.pickupview.frame.width>self.dropview.frame.width) {
//                        self.collectionvw.reloadData()
//                    }
//
//                }
            }
        }
        self.socket.on("get_cars") {
            data, ack in
            print("Cars for you! \(data[0])")
            let JSON = data[0] as! NSDictionary
            print(JSON)
            let theSuccess = (JSON.value(forKey: "success") as! Bool)

            if(theSuccess == true) {
                let carDetails = (JSON.value(forKey: "cars") as! [[String:AnyObject]])//.mfap({ Car(id: <#T##Int!#>, bearing: <#T##Double!#>, latitude: <#T##Double!#>, longitude: <#T##Double!#>, type: <#T##Int!#>)
//                })
                print("RJK CARS COUNT IS \(carDetails.count)")
                self.mapview.clear()
                for carDetail in carDetails {
                    if let lat = carDetail["latitude"] as? Double, let lon = carDetail["longitude"] as? Double {
                        let markerPosition = CLLocationCoordinate2DMake(lat, lon)
                        let marker = GMSMarker(position: markerPosition)
                        marker.icon = UIImage(named: "pin_driver")
                        marker.userData="D pin"
                        marker.map = self.mapview
                    }
                }
            }
        }
    }

//    func getcars()
//    {
//        self.socket.on("get_cars") {
//            data, ack in
//            print("Cars for you! \(data[0])")
//            let JSON = data[0] as! NSDictionary
//            print(JSON)
//            let theSuccess = (JSON.value(forKey: "success") as! Bool)
//
//            if(theSuccess == true)
//            {
//                self.carsarray=NSMutableArray()
//                self.state_marker.map=nil
//                self.carsarray=(JSON.value(forKey: "cars") as! NSArray as! NSMutableArray)
//                for array in self.carsarray
//                {
//                    let lat=((array as AnyObject).value(forKey: "latitude") as! Double)
//                    let lon=((array as AnyObject).value(forKey: "longitude") as! Double)
//                    let markerPosition = CLLocationCoordinate2DMake(lat, lon)
//                    self.state_marker = GMSMarker(position: markerPosition)
//                    self.state_marker.icon = UIImage(named: "samplecaricon1.png")
//                    self.state_marker.userData="D pin"
//                    self.state_marker.map = self.mapview
//                }
//            }
//        }
//    }

    @IBAction func pickuptapDetected(_ sender: UITapGestureRecognizer) {
        guard let dropViewIndex = self.view.subviews.index(of: dropview), let pickUpViewIndex = self.view.subviews.index(of: pickupview) else {
            return
        }
        if pickUpViewIndex < dropViewIndex {
            UIView.animate(withDuration: 0.25) {
                self.pickUpViewLeading.constant = 15
                self.pickUpViewTrailing.constant = -15
                self.dropViewLeading.constant = 25
                self.dropViewTrailing.constant = -25
                self.dropviewfavbtn.isHidden = true
                self.dropviewfaviv.isHidden = true
                self.pickupviewfaviv.isHidden = false
                self.pickupviewfavbtn.isHidden = false
                self.view.layoutSubviews()
                self.pickupview.backgroundColor=UIColor.white
                self.dropview.backgroundColor=UIColor(red: 238/255, green: 239/255, blue: 234/255, alpha: 0.8)
                self.view.layoutIfNeeded()
            }
            self.view.bringSubviewToFront(self.pickupview)

            if let pickupLoc = self.selectedPickUpLocation {
                self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: pickupLoc.latitude, longitude: pickupLoc.longitude))
            } else if let currentLoc = self.locationManager.location {
                self.mapview.animate(toLocation: currentLoc.coordinate)
            }


        } else {
//            self.currentLocationPoint = .pickUp
            let vc = SearchLocationTVC()
            vc.title = "Enter Your Pickup Location".localize()
            vc.searchController.searchBar.text = ""
            vc.searchController.searchBar.placeholder = "Enter Your Pickup Location".localize()
            vc.currentuserid = currentuserid
            vc.currentusertoken = currentusertoken
            vc.selectedLocation = self.pickUpLocationSelectedClousure//Clousure
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func droptapDetected(_ sender: UITapGestureRecognizer) {
        guard let dropViewIndex = self.view.subviews.index(of: dropview), let pickUpViewIndex = self.view.subviews.index(of: pickupview) else {
            return
        }
        if dropViewIndex < pickUpViewIndex, let dropLoc = self.selectedDropLocation {

            UIView.animate(withDuration: 0.25) {
                self.pickUpViewLeading.constant = 25
                self.pickUpViewTrailing.constant = -25
                self.dropViewLeading.constant = 15
                self.dropViewTrailing.constant = -15
                self.dropviewfavbtn.isHidden = false
                self.dropviewfaviv.isHidden = false
                self.pickupviewfaviv.isHidden = true
                self.pickupviewfavbtn.isHidden = true
                self.view.layoutSubviews()
                self.dropview.backgroundColor = UIColor.white
                self.pickupview.backgroundColor = UIColor(red: 238/255, green: 239/255, blue: 234/255, alpha: 0.8)
                self.view.layoutIfNeeded()
            }
            self.view.bringSubviewToFront(self.dropview)
            if dropLoc.latitude != nil {
                self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: dropLoc.latitude, longitude: dropLoc.longitude))
            }
        } else {
//            self.currentLocationPoint = .drop
            let vc = SearchLocationTVC()
            vc.title = "Enter Your Drop Location".localize()
            vc.searchController.searchBar.text = ""
            vc.searchController.searchBar.placeholder = "Enter Your Drop Location".localize()
            vc.currentuserid = currentuserid
            vc.currentusertoken = currentusertoken
            vc.selectedLocation = self.dropLocationSelectedClousure
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

//    @IBAction func closesearchviewTap(_ sender: UIButton)
//    {
//        self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        self.searchTfd.resignFirstResponder()
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations:
//            {
//                self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//
//        }, completion: {_ in
//            self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//            self.searchview.isHidden=true
//            self.menuButton.isEnabled=true
//        })
//    }

//    @IBAction func droploctapDetected(_ sender: UITapGestureRecognizer)
//    {
//
//        return
//
//
//        self.searchTfd.text = ""
////        self.searchlistTbv.isHidden = true
////        self.getfavouritelistApi()
//        self.searchview.frame = CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        self.view.bringSubview(toFront: self.searchview)
//        self.searchviewheaderLbl.text = "Enter Your Drop Location"
//        self.searchview.isHidden = false
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations:
//            {
//                self.searchview.frame = CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//
//        }, completion: {_ in
//
//            self.searchview.frame = CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//            self.menuButton.isEnabled = false
//            self.searchTfd.becomeFirstResponder()
//        })
//    }

    @IBAction func pickuploctapDetected(_ sender: UITapGestureRecognizer) {


        return


//
//        self.searchTfd.text = ""
//        self.searchlistTbv.isHidden=true
//        self.getfavouritelistApi()
//        self.searchview.frame=CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        self.view.bringSubview(toFront: self.searchview)
//        self.searchviewheaderLbl.text = "Enter Your Pickup Location"
//        self.searchview.isHidden=false
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations:
//            {
//                self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//
//        }, completion: {_ in
//
//            self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//            self.menuButton.isEnabled=false
//            self.searchTfd.becomeFirstResponder()
//        })
    }

//    func callgoogleapi()
//    {
//        if ConnectionCheck.isConnectedToNetwork()
//        {
//            print("Connected")
//
//            if(self.searchTfd.text!.count>0)
//            {
//                var paramDict = Dictionary<String, Any>()
//                paramDict["input"]=self.searchTfd.text
//                paramDict["key"]="AIzaSyCpmkjIlSYKYL-0rtDLSWf4VIOjJgSnG6Q"
//                paramDict["location"]="0.000000,0.000000"
//                paramDict["radius"]="500"
//                paramDict["sensor"]="false"
//
//                print(paramDict)
//                let url = helperObject.autocomplete_URl
//                print(url)
//                Alamofire.request(url, method: .get, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                    .responseJSON
//                    { response in
//                        print(response.response as Any) // URL response
//                        print(response.result.value as AnyObject)   // result of response serialization
//                        if let result = response.result.value
//                        {
//                            let JSON = result as! NSDictionary
//                            self.arr = JSON.value(forKey: "predictions") as! NSArray
//                            print("Response for Login",JSON)
//                            if(self.arr.count>0)
//                            {
//                                self.searchlistTbv.reloadData()
//                            }
//                        }
//                }
//            }
//        }
//        else
//        {
//            print("disConnected")
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

//        self.locationManager=CLLocationManager()
//        locationManager.delegate=self
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
//        self.locationManager.startUpdatingLocation()
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startMonitoringSignificantLocationChanges()
        self.connectsocket()
        self.getrequestinprogress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false

//        self.navigationController?.navigationBar.isHidden = false
        self.socket.disconnect()
    }

    func getrequestinprogress() {
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

                            self.soslistarray=NSMutableArray()
                            self.soslistarray=(JSON.value(forKey: "sos") as! NSArray)

                            if(self.soslistarray.count>0) {
                                self.appdel.sosarray=self.soslistarray
                            }

                            guard let statusdict = JSON["request"] as? [String:AnyObject] else {
                                return
                            }

                            if let requestid=((statusdict as AnyObject).value(forKey: "id")) as? Int {
                            self.appdel.requestid=requestid
                            }
                            if let billrespdict=((statusdict as AnyObject).value(forKey: "bill") ) as? NSDictionary {
                                print(billrespdict)
                                self.appdel.billdict=billrespdict.mutableCopy() as! NSMutableDictionary
                            }
                            if let driverrespdict=((statusdict as AnyObject).value(forKey: "driver") ) as? NSDictionary {
                                print(driverrespdict)
                                self.appdel.driverdict=driverrespdict.mutableCopy() as! NSMutableDictionary
                            }

                            print(statusdict)
                            if(statusdict.count>0)
                            {
                                if let status = RequestStatus(statusdict) {
                                    switch status {
                                    case .driverStarted,.driverArrived,.tripStart:
                                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "tripViewController") as? tripViewController {
                                            vc.navigationItem.hidesBackButton = true
                                           // vc.tripstatusfromripdict=statusdict
                                            self.appdel.tripJSON = JSON as NSDictionary
                                            print("appdel.tripJson is",self.appdel.tripJSON)
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    case .completed,.paid:
                                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedbackvc") as? feedbackvc
                                        {
                                            vc.navigationItem.hidesBackButton = true
                                           // vc.tripinvoicedetdict=statusdict
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    case .userRated,.cancelled:
                                        break
                                    }
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

    func getaddress(_ position:CLLocationCoordinate2D,completion:@escaping (String)->()) {
        let userLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            addressDict.forEach { print($0) }
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
                let address = formattedAddress.joined(separator: ", ")
                completion(address)
            }
        })
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.view.bringSubviewToFront(imageMarkerDottedline)
        self.mapViewWillMoveGesture = gesture
        print(gesture)


        guard let dropViewIndex = self.view.subviews.index(of: dropview), let pickUpViewIndex = self.view.subviews.index(of: pickupview) else {
            return
        }
        if dropViewIndex < pickUpViewIndex {
//            self.dropMarker.map = nil
            self.imageMarkerDottedline.image = UIImage(named: "pickup_pin")
            self.dropview.isHidden=true
            self.imagedownArrowPickup.image = UIImage(named: "PickupDownArrow")
        } else {
//            self.pickUpMarker.map = nil
            self.pickupview.isHidden=true
            self.imageMarkerDottedline.image = UIImage(named: "destination_pin")
            self.imagedownArrowPickup.image = UIImage(named: "dropdownarrow")
        }

//        mapViewBottomConstraint.constant = 0
        self.mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        UIView.animate(withDuration: 0.25) {
//
//            self.imageMarkerBottomPos.constant = 0
//            self.view.layoutIfNeeded()
//        }
//        self.viewDottedLines.isHidden=false
        self.providerdetailsview.isHidden = true
        self.rideBtnsBgView.isHidden = true

//        self.imageDottedLine.isHidden=false

//        self.imagex.isHidden=false
//        pickUpMarker.map = nil
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.imageMarkerDottedline.isHidden = false
//        }

        print("Map Dragging")
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.view.bringSubviewToFront(imageMarkerDottedline)
        guard let dropViewIndex = self.view.subviews.index(of: dropview), let pickUpViewIndex = self.view.subviews.index(of: pickupview) else {
            return
        }

        if dropViewIndex < pickUpViewIndex && self.mapViewWillMoveGesture {
            self.selectedPickUpLocation = SearchLocation(position.target)
            self.getaddress(position.target) { address in
                self.selectedPickUpLocation.placeId = address
                self.fromAddrtf.text = self.selectedPickUpLocation.placeId
            }
        } else if dropViewIndex > pickUpViewIndex && self.mapViewWillMoveGesture {
            self.selectedDropLocation = SearchLocation(position.target)
            self.getaddress(position.target) { address in
                self.selectedDropLocation.placeId = address
                self.toAddrtf.text = self.selectedDropLocation.placeId
            }
        }
        self.pickupview.isHidden = false
        self.dropview.isHidden=false
        self.providerdetailsview.isHidden = false
        self.rideBtnsBgView.isHidden = false
        self.imageDottedLine.isHidden=true
        self.imagex.isHidden=true

        self.mapview.padding = UIEdgeInsets(top: 128, left: 0, bottom: 128, right: 0)

        let locationMapChange = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        locValue = locationMapChange.coordinate
//        print(locValue.latitude)
//        print(locValue.longitude)
//        self.selectedFavLocation.latitude = String(locValue.latitude)
//        self.selectedFavLocation.longitude = String(locValue.longitude)
//        marker.map = nil
//
//        let markerPosition = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
//        marker = GMSMarker(position: markerPosition)
//        if(self.pickupview.frame.width>self.dropview.frame.width)
//        {
//            marker.icon = UIImage(named: "pickup_pin")
//            pickuplat=locValue.latitude
//            pickuplon=locValue.longitude
//            self.emitinglocation()
//        }
//        else
//        {
//            marker.icon = UIImage(named: "destination_pin")
//            droplat=locValue.latitude
//            droplon=locValue.longitude
//        }
//        marker.map = self.mapview

//        geoCoder.reverseGeocodeLocation(locationMapChange, completionHandler: { placemarks, error in
//            guard let addressDict = placemarks?[0].addressDictionary else {
//                return
//            }
//            addressDict.forEach { print($0) }
//            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String]
//            {
//                print(formattedAddress)
//                print(formattedAddress.joined(separator: ", "))
//                if(self.pickupview.frame.width>self.dropview.frame.width)
//                {
//                    self.fromAddrtf.text = formattedAddress.joined(separator: ", ")
//                }
//                else
//                {
//                    self.toAddrtf.text = formattedAddress.joined(separator: ", ")
//                }
//                if(self.favouriteview.isHidden==false)
//                {
//                    self.favouriteviewaddressLbl.text=formattedAddress.joined(separator: ", ")
//                }
//            }
//            if let locationName = addressDict["Name"] as? String
//            {
//                print(locationName)
//            }
//            if let street = addressDict["Thoroughfare"] as? String
//            {
//                print(street)
//            }
//            if let city = addressDict["City"] as? String
//            {
//                print(city)
//            }
//            if let zip = addressDict["ZIP"] as? String
//            {
//                print(zip)
//            }
//            if let country = addressDict["Country"] as? String
//            {
//                print(country)
//            }
//        })
//        navigationController?.navigationBar.isHidden = false
        self.imageDottedLine.isHidden=true
//        self.imageMarkerDottedline.isHidden=true
        self.imagex.isHidden=true
        self.locationManager.stopUpdatingLocation()
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        print(self.locValue.latitude)
        jsonObject.setValue( self.locValue.latitude, forKey: "lat")
        jsonObject.setValue(self.locValue.longitude, forKey: "lng")
        jsonObject.setValue(self.currentuserid, forKey: "id")
        let jsonData: NSData
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            self.jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String as String as NSString
            print("json string = \(self.jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        self.socket.emit("types", self.jsonString)
    }

    func updatecameraloc() {
        CATransaction.begin()
        CATransaction.setValue(0.4, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 14)
        self.mapview.animate(to: camera)
        CATransaction.commit()


//        mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 20)
//        pickUpMarker.position = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
//        pickUpMarker.map = mapview
        self.selectedFavLocation.latitude = String(locValue.latitude)
        self.selectedFavLocation.longitude = String(locValue.longitude)

        self.view.bringSubviewToFront(self.imageDottedLine)
        self.view.bringSubviewToFront(self.viewDottedLines)
            if (pickupview.frame.width>dropview.frame.width) {
                self.view.bringSubviewToFront(self.dropview)
                self.view.bringSubviewToFront(self.pickupview)
            }
            else {
                self.view.bringSubviewToFront(self.pickupview)
                self.view.bringSubviewToFront(self.dropview)
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        location = locations.last!

        if self.selectedPickUpLocation == nil {
            self.selectedPickUpLocation = SearchLocation(location.coordinate)
            self.getaddress(location.coordinate) { address in
                self.selectedPickUpLocation.placeId = address
                self.fromAddrtf.text = self.selectedPickUpLocation.placeId

            }
        }
        let camera = GMSCameraPosition.camera(withLatitude: self.location.coordinate.latitude, longitude: self.location.coordinate.longitude, zoom: 14)
        self.mapview.camera = camera
        print("Location: \(location)")
        pickUpLat = "\(location.coordinate.latitude)"
        pickUpLong="\(location.coordinate.longitude)"
        let latdouble=Double(pickUpLat)
        let longdouble=Double(pickUpLong)

        UserDefaults.standard.set(pickUpLat, forKey: "firstlat")
        UserDefaults.standard.set(pickUpLong, forKey: "firstlong")

            if (pickupview.frame.width>dropview.frame.width) {
                let camera = GMSCameraPosition.camera(withLatitude: latdouble!, longitude: longdouble!, zoom: 14)
                mapview.camera=camera

//                mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 20)
//                pickUpMarker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
//                pickUpMarker.map = mapview
            }
//        self.getaddress(location.coordinate, completion: { address in
//            self.fromAddrtf.text = address
//        })


        self.view.bringSubviewToFront(self.imageDottedLine)
        self.view.bringSubviewToFront(self.viewDottedLines)

            if (pickupview.frame.width>dropview.frame.width) {
                self.view.bringSubviewToFront(self.dropview)
                self.view.bringSubviewToFront(self.pickupview)
            }
            else {
                self.view.bringSubviewToFront(self.pickupview)
                self.view.bringSubviewToFront(self.dropview)
            }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error.localizedDescription")
    }

    //--------------------------------------
    // MARK: - Table view Delegates
    //--------------------------------------
    
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.placenamearray.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! SearchListTableViewCell
//        cell.placenameLbl.font = UIFont.appBoldFont(ofSize: 15)
//        cell.placeaddLbl.font = UIFont.appFont(ofSize: 11)
//        if(self.isfavouritearray[indexPath.row] as? String == "YES")
//        {
////            cell.favdeleteBtn.isHidden=false
////            cell.favdeleteimv.isHidden=false
////            cell.favdeleteBtn.tag=indexPath.row
////            cell.favdeleteBtn.addTarget(self, action: #selector(pickupViewController.deleteBtnAction(_:)), for: UIControlEvents.touchUpInside)
//        }
//        else
//        {
////            cell.favdeleteBtn.isHidden=true
////            cell.favdeleteimv.isHidden=true
//        }
//        cell.placenameLbl.text = self.placenamearray[indexPath.row] as? String
//        cell.placeaddLbl.text = self.placeaddressarray[indexPath.row] as? String
//        return cell
//    }

//    @IBAction func deleteBtnAction(_ sender: UIButton)
//    {
//        if ConnectionCheck.isConnectedToNetwork()
//        {
//            self.searchTfd.resignFirstResponder()
//            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//
//            if activityView == nil
//            {
//                activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
//                self.searchview.bringSubview(toFront: activityView)
//                searchview.addSubview(activityView)
//                activityView.translatesAutoresizingMaskIntoConstraints = false
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
//                            self.getfavouritelistApi()
//                            self.view.showToast(JSON.value(forKey: "success_message") as! String)
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

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if let text = textField.text as NSString?
//        {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//            print(txtAfterUpdate)
//            if ConnectionCheck.isConnectedToNetwork()
//            {
//                print("Connected")
//                if(txtAfterUpdate.count>0)
//                {
//                    var paramDict = Dictionary<String, Any>()
//                    paramDict["input"]=txtAfterUpdate
//                    paramDict["key"]="AIzaSyCpmkjIlSYKYL-0rtDLSWf4VIOjJgSnG6Q"
//                    paramDict["location"]="0.000000,0.000000"
//                    paramDict["radius"]="500"
//                    paramDict["sensor"]="false"
//                    print(paramDict)
//                    let url = helperObject.autocomplete_URl
//                    print(url)
//                    Alamofire.request(url, method: .get, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
//                        .responseJSON
//                        { response in
//                            print(response.response as Any) // URL response
//                            print(response.result.value as AnyObject)   // result of response serialization
//                            if let result = response.result.value
//                            {
//                                let JSON = result as! NSDictionary
//                                self.arr = JSON.value(forKey: "predictions") as! NSArray
//                                if(self.arr.count>0)
//                                {
//                                    self.descrarr=self.arr.value(forKey: "description") as! NSArray
//                                    self.placenamearray=NSMutableArray()
//                                    self.placeaddressarray=NSMutableArray()
//                                    self.addressarray=NSMutableArray()
//                                    self.isfavouritearray=NSMutableArray()
//                                    for str in self.descrarr
//                                    {
//                                        print(str)
//                                        self.addressarray.add(str)
//                                        self.isfavouritearray.add("NO")
//                                        let website: String = str as! String
//                                        if ( website.range(of: ",") != nil)
//                                        {
//                                            let arr2 = website.components(separatedBy: ",")
//                                            print(arr2)
//                                            self.placenamearray.add(arr2[0])
//
//                                            let index = website.range(of: ",")?.lowerBound
//
//                                            var addstr=website.substring(from: index!)
//                                            addstr.remove(at: addstr.startIndex)// "ora"
//                                            print(addstr)
//                                            self.placeaddressarray.add(addstr)
//                                        }
//                                        else
//                                        {
//                                            self.placenamearray.add(website)
//                                            self.placeaddressarray.add("")
//                                        }
//                                    }
//                                    if(self.arr.count>0)
//                                    {
//                                        self.searchlistTbv.isHidden=false
//                                        self.searchlistTbv .reloadData()
//                                    }
//                                }
//                            }
//                    }
//                }
//                else
//                {
//                    self.searchlistTbv.isHidden=true
//                }
//            }
//            else
//            {
//                print("disConnected")
//            }
//        }
//        return true
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        if self.searchviewheaderLbl.text == "Enter Your Drop Location"
//        {
//            self.toAddrtf.text=self.addressarray[indexPath.row] as? String
//            self.searchTfd.resignFirstResponder()
//            self.searchview.isHidden=true
//            self.getcoord(self.toAddrtf.text!)
//        }
//        else
//        {
//            self.fromAddrtf.text=self.addressarray[indexPath.row] as? String
//            self.searchTfd.resignFirstResponder()
//            self.searchview.isHidden=true
//            self.getcoord(self.fromAddrtf.text!)
//        }
//        self.menuButton.isEnabled=true
//    }

    func getcoord(_ str : String) {
        let correctedAddress: String! = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=" + correctedAddress + "&sensor=false&key=AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")
        print(url!)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let dic = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
            print(dic)
            if (dic.object(forKey: "results") != nil) {
                let arrayAddresses = dic.object(forKey: "results") as! NSArray
                print("The arrayAddresses is: ",arrayAddresses)
                if arrayAddresses.count > 0 {
                    self.fromAddrtf.text = ((arrayAddresses.object(at: 0) as AnyObject).value(forKey: "formatted_address") as! String)
                    let dictLocation: NSDictionary = (((arrayAddresses.object(at: 0) as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location") as AnyObject) as! NSDictionary
                    let latNum: NSNumber = dictLocation.value(forKey: "lat") as! NSNumber
                    let lngNum: NSNumber = dictLocation.value(forKey: "lng") as! NSNumber
                    print("latNum: \(latNum)")
                    print("lngNum: \(lngNum)")
                    self.locValue.latitude=CLLocationDegrees(latNum)
                    self.locValue.longitude=CLLocationDegrees(lngNum)
                    self.updatecameraloc()
                }
            }
        }
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

    func getCoordFromGoogle(_ placeId:String,completion:@escaping (CLLocationCoordinate2D)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            let url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(placeId)&key=AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k"
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value as? [String:AnyObject] {
                        if let status = result["status"] as? String, status == "OK" {
                            if let results = result["results"] as? [[String:AnyObject]] {
                                print(results)
                                if let result = results.first {
                                    print(result)
                                    if let geo = result["geometry"] as? [String:AnyObject],let loc = geo["location"]as? [String:AnyObject] {
                                        if let lat = loc["lat"] as? Double,let long = loc["lng"] as? Double {
                                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                            completion(coord)
                                        }
                                        //                                        if let lat = loc["lat"] as? String,let long = loc["lng"] as? String {
                                        //
                                        //                                        }

                                    }
                                }
                            }
                        }
                    }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        } else {
            print("disConnected")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//    @IBAction func clearBtnAction()
//    {
////        self.searchTfd.text = ""
////        self.searchlistTbv.isHidden=true
//    }


    //--------------------------------------
    // MARK: - Favourite Place
    //--------------------------------------

    @IBAction func favouritepBtnAction() {
        if(pickupview.frame.size.width>self.dropview.frame.size.width) {
            if(fromAddrtf.text=="") {
                self.alert(message: "Please choose your favourite place.")
            }
            else {
                self.view.bringSubviewToFront(self.favouriteview)
                self.favouriteviewaddressLbl.text=self.fromAddrtf.text
                self.favouriteview.isHidden=false
            }
        } else {
            if(toAddrtf.text=="") {
                self.alert(message: "Please choose your favourite place.")
            }
            else {
                self.view.bringSubviewToFront(self.favouriteview)
                self.favouriteviewaddressLbl.text=self.toAddrtf.text
                self.favouriteview.isHidden=false
            }
        }
        self.favouriteviewhomeBtn .backgroundColor=UIColor.white
        self.favouriteviewworkBtn .backgroundColor=UIColor.white
        self.favouriteviewotherBtn .backgroundColor=UIColor.white
        self.favouriteviewotherTfd.text = ""
    }

    @IBAction func favouriteviewCancelBtnAction() {
        self.favouriteviewotherTfd.text = ""
        self.favouriteview.isHidden=true
    }

    @IBAction func favouritepSaveBtnAction() {
            self.favouriteview.isHidden=true
            switch self.selectedFavLocation.type {
                case .home:
                    self.selectedFavLocation.title = "Home".localize()
                case .work:
                    self.selectedFavLocation.title = "Work".localize()
                case .other:
                    self.selectedFavLocation.title = self.favouriteviewotherTfd.text
            }
            self.savefavouriteapicall()
    }

    func savefavouriteapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            paramDict["id"]=currentuserid
            paramDict["token"]=currentusertoken
            paramDict["nickName"] = self.selectedFavLocation.title
            paramDict["placeId"] = self.selectedFavLocation.place
            paramDict["latitude"] = self.selectedFavLocation.latitude
            paramDict["longitude"] = self.selectedFavLocation.longitude

            print(paramDict)
            let url = helperObject.BASEURL + helperObject.addfavourite
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
                            self.view.showToast(JSON.value(forKey: "success_message") as! String)
                        } else {
                            self.view.showToast("Something went wrong. Try again")
                        }
                    }
            }
        } else {
            print("disConnected")
        }
    }

    @IBAction func favviewhomeBtnaction() {
        favouriteviewotherTfd.isHidden = true

        favHomeBtn.setImage(UIImage(named: "favselectedicon"), for: .normal)
        favWorkBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)
        favOtherBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)

        self.selectedFavLocation.type = .home
        self.selectedFavLocation.place = self.favouriteviewaddressLbl.text

    }

    @IBAction func favviewworkBtnaction() {
        favouriteviewotherTfd.isHidden = true

        favHomeBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)
        favWorkBtn.setImage(UIImage(named: "favselectedicon"), for: .normal)
        favOtherBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)

        self.selectedFavLocation.type = .work
        self.selectedFavLocation.place = self.favouriteviewaddressLbl.text

    }

    @IBAction func favviewotherBtnaction() {
        favouriteviewotherTfd.isHidden = false

        favHomeBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)
        favWorkBtn.setImage(UIImage(named: "favunselectedicon"), for: .normal)
        favOtherBtn.setImage(UIImage(named: "favselectedicon"), for: .normal)

        self.selectedFavLocation.place = self.favouriteviewaddressLbl.text
        self.selectedFavLocation.type = .other
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
//            self.mapview.bringSubview(toFront: activityView)
//            mapview.addSubview(activityView)
//            activityView.translatesAutoresizingMaskIntoConstraints = false
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
    // MARK: - Collectionview delegates
    //--------------------------------------

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath as IndexPath) as! providertypesCollectionViewCell
        myCell.backgroundColor = UIColor.white
        myCell.typeNameLbl.font = UIFont.appFont(ofSize: 12)
        myCell.typeNameLbl.adjustsFontSizeToFitWidth = true
        myCell.typeNameLbl.minimumScaleFactor = 0.1
        myCell.etaLbl.font = UIFont.appFont(ofSize: 12)

        myCell.typeImageView.kf.indicatorType = .activity
        myCell.typeImageView.kf.setImage(with: self.carModels[indexPath.row].iconResource)
       // if(self.pickupview.frame.width>self.dropview.frame.width) {
            myCell.etaLbl.text = self.carModels[indexPath.row].duration
      //  }
        myCell.typeNameLbl.text = self.carModels[indexPath.row].name

        if let selectedModel = self.selectedCarModel, selectedModel == self.carModels[indexPath.row] {
            myCell.selectedImageView.isHidden = false
        } else {
            myCell.selectedImageView.isHidden = true
        }
        return myCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCarModel = self.carModels[indexPath.row]
//        selectedcartypeid = String(self.selectedCarModel.id)
//        self.appdel.selectedcartypeid = selectedcartypeid
//        self.appdel.selectedcartypeidd = Double(selectedcartypeid)
        self.appdel.selectedcartypename = self.selectedCarModel.name
        self.collectionvw.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    @IBAction func ridenowbtnaction() {
        var errmsg=String()
        if(self.fromAddrtf.text?.count==0) {
            errmsg="Please choose pickup location"
        } else if(self.toAddrtf.text?.count==0) {
            errmsg="Please choose drop location"
        } else if self.selectedCarModel == nil {
            errmsg="Please choose car type"
        }
        if(errmsg.count>0) {
            self.alert(message: errmsg)
        } else {
            self.appdel.pickuplat = self.selectedPickUpLocation.latitude
            self.appdel.pickuplon = self.selectedPickUpLocation.longitude
            self.appdel.droplat = self.selectedDropLocation.latitude
            self.appdel.droplon = self.selectedDropLocation.longitude
            self.appdel.fromaddr = self.fromAddrtf.text!
            self.appdel.toaddr = self.toAddrtf.text!
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tripViewController") as! tripViewController
            vc.navigationItem.hidesBackButton = true
            print(self.selectedPickUpLocation)
            vc.selectedPickUpLocation = self.selectedPickUpLocation
            vc.selectedDropLocation = self.selectedDropLocation
            vc.selectedCarModel = self.selectedCarModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func act(sender: UIButton) {
        let stb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ilvc=stb.instantiateViewController(withIdentifier: "ilvc")
        self.navigationController?.pushViewController(ilvc, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}



struct CarModel:Equatable
{
    static func == (lhs: CarModel, rhs: CarModel) -> Bool {
        return lhs.id == rhs.id
    }
    var duration:String!
    var iconUrlStr:String!
    var id:Int!
    var name:String!
    var paymentType:[String]!
    var iconResource:ImageResource!

    init(_ dict:[String:AnyObject]) {
        if let duration = dict["duration"] as? String {
            self.duration = duration
        }
        if let iconUrlStr = dict["icon"] as? String {
            self.iconUrlStr = iconUrlStr
            if let url = URL(string: iconUrlStr)
            {
                self.iconResource = ImageResource(downloadURL: url)
            }
        }

        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let paymentType = dict["payment_type"] as? [String] {
            self.paymentType = paymentType
        }

    }
}
