
//
//  scheduletripviewcontroller.swift
//  tapngo
//
//  Created by Mohammed Arshad on 08/03/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreData
import GoogleMaps
import GooglePlaces

class ScheduleTripViewVontroller: UIViewController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var window1: UIWindow?
    var currentuserid: String! = ""
    var currentusertoken: String! = ""
    var activityView: NVActivityIndicatorView!
    let helperObject = APIHelper()

    var marker = GMSMarker()

    var desmarker = GMSMarker()
    var drivermarker = GMSMarker()
    var tapGesture1: UISwipeGestureRecognizer!
    var tapGesture11: UISwipeGestureRecognizer!
    var locationManager: CLLocationManager!

    var location=CLLocation()
    let geoCoder = CLGeocoder()

    var pickUpLat: String! = ""
    var pickUpLong: String! = ""

    var currency = ""

    @IBOutlet var pickupview: UIView!
    @IBOutlet var pickupcolorview: UIView!
    @IBOutlet var pickupaddrLbl: UILabel!

    @IBOutlet var dropview: UIView!
    @IBOutlet var dropcolorview: UIView!
    @IBOutlet var dropaddrLbl: UILabel!
    @IBOutlet weak var changeDropBtn: UIButton!

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet var pickuptimeinfoview: UIView!
    @IBOutlet var pickuptimeimageview: UIImageView!
    @IBOutlet var pickuptimeheaderlbl: UILabel!
    @IBOutlet var pickuptimelbl: UILabel!

    @IBOutlet var etapaymentview: UIView!
    @IBOutlet var etaview: UIView!
    @IBOutlet weak var etaViewBtn: UIView!
    @IBOutlet var etaLbl: UILabel!
    @IBOutlet var selectedcarnameLbl: UILabel!
    @IBOutlet var paymenttypeLbl: UILabel!
    @IBOutlet var  paymenttypeIv: UIImageView!
    @IBOutlet var paymenttypeselectbtn: UIButton!
    @IBOutlet var paymenttypeselectiv: UIImageView!

//    paymentView
    @IBOutlet var paymentviewheaderlbl: UILabel!
    var paymentViewCloseBtn = UIButton()
    @IBOutlet var paymentview: UIView!
    @IBOutlet var paymenttbv: UITableView!

     @IBOutlet var confirmbookingbtn: UIButton!

    let appdel = UIApplication.shared.delegate as!AppDelegate

    @IBOutlet weak var mapview: GMSMapView!

    var paymenttypearray = NSMutableArray()
    var paymenttypeimagearray = NSMutableArray()

    var selectedpaymentoption=Int()

    @IBOutlet var gestureview: UIView!

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

    var arr = NSArray()
    var descrarr = NSArray()

    @IBOutlet var faredetailsview: UIView!
    @IBOutlet weak var fareDetailsUL1: UIView!
    @IBOutlet weak var fareDetailsUL2: UIView!

    @IBOutlet var faredetailsviewheaderlbl: UILabel!
    @IBOutlet var gotitbtn: UIButton!
    @IBOutlet var getfaredetailsbtn: UIButton!
    @IBOutlet var ridefareheaderlbl: UILabel!
    @IBOutlet var ridefarelbl: UILabel!
    @IBOutlet var taxheaderlbl: UILabel!
    @IBOutlet var taxlbl: UILabel!
    @IBOutlet var totalheaderlbl: UILabel!
    @IBOutlet var totallbl: UILabel!
    @IBOutlet var notehintlbl: UILabel!
    @IBOutlet var hintlbl: UILabel!

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
    var selectedCarModel: CarModel!
    var selectedPickUpLocation:SearchLocation!
    var selectedDropLocation:SearchLocation!
    var dropLocationSelectedClousure:((SearchLocation) -> Void)?
    var animatedPolyline:AnimatedPolyLine!
    var pickUpMarker: GMSMarker!
    var dropMarker: GMSMarker!
    
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()



        self.dropLocationSelectedClousure = { selectedSearchLoc in
            print(selectedSearchLoc)
            self.selectedDropLocation = selectedSearchLoc
            self.dropaddrLbl.text = self.selectedDropLocation.placeId
            if selectedSearchLoc.locationType == .googleSearch {
                self.getCoordinatesFromPlaceId(selectedSearchLoc.googlePlaceId!, completion: { locCoordinate in
                    self.selectedDropLocation.latitude = locCoordinate.latitude
                    self.selectedDropLocation.longitude = locCoordinate.longitude
                    self.drawRouteOnMap(false)
                })
            }
            else {
                self.drawRouteOnMap(false)
            }
        }


        if(self.appdel.selectedcartypename.count>0) {
            self.title=self.appdel.selectedcartypename
        }
        self.pickupaddrLbl.text=self.appdel.fromaddr
        self.dropaddrLbl.text=self.appdel.toaddr
        self.dropview.layer.cornerRadius=5
        self.dropcolorview.layer.cornerRadius=5
        self.pickupcolorview.layer.cornerRadius=5
        self.getUser()
        self.mapview.camera = GMSCameraPosition.camera(withTarget: self.selectedPickUpLocation.coordinate, zoom: 16)
        self.drawRouteOnMap(false)
        self.getetaapicall()
        let time = self.appdel.scheduletime
        self.pickuptimelbl.text = self.appdel.displaydate + " " + time
        self.selectedcarnameLbl.text = self.selectedCarModel.name
        paymenttypearray=["Cash", "Card", "Wallet"]
        paymenttypeimagearray=["paymentcash", "addcardicon", "paymentwallet"]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.gestureview.addGestureRecognizer(tapGesture)
        self.setUpViews()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
//        self.searchlistTbv.isHidden = true
//        self.getfavouritelistApi()
//        self.searchview.frame = CGRect(x: 320, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        self.view.bringSubview(toFront: self.searchview)
//        self.searchview.isHidden = false
//        UIView.animate(withDuration: 0.5, delay: 0.3, options: .transitionCurlUp, animations: {
//                self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        }, completion: {_ in
//            self.searchview.frame=CGRect(x: 0, y:self.searchview.frame.origin.y, width:self.searchview.frame.size.width, height:self.searchview.frame.size.height)
//        })
    }



    func setUpViews() {
        self.pickupaddrLbl.font = UIFont.appFont(ofSize: 15)
        self.dropaddrLbl.font = UIFont.appFont(ofSize: 14)
        self.etaLbl.font = UIFont.appFont(ofSize: 15)
        self.selectedcarnameLbl.font = UIFont.appFont(ofSize: 15)
        self.paymentviewheaderlbl.font = UIFont.appBoldFont(ofSize: 18)
        self.paymenttypeLbl.font = UIFont.appFont(ofSize: 15)
        self.etaview.backgroundColor = .themeColor

        self.pickuptimeheaderlbl.font = UIFont.appFont(ofSize: 13)
        self.pickuptimelbl.font = UIFont.appFont(ofSize: 13)

        self.ridefareheaderlbl.font = UIFont.appFont(ofSize: 13)
        self.ridefarelbl.font = UIFont.appFont(ofSize: 14)
        self.taxheaderlbl.font = UIFont.appFont(ofSize: 13)
        self.taxlbl.font = UIFont.appFont(ofSize: 14)
        self.totalheaderlbl.font = UIFont.appFont(ofSize: 17)
        self.totallbl.font = UIFont.appFont(ofSize: 14)
        self.notehintlbl.font = UIFont.appFont(ofSize: 14)
        self.hintlbl.font = UIFont.appFont(ofSize: 14)
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

        pickupview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupview"] = pickupview
        pickupcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupcolorview"] = pickupcolorview
        pickupaddrLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupaddrLbl"] = pickupaddrLbl

        dropview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropview"] = dropview
        dropcolorview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropcolorview"] = dropcolorview
        dropaddrLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropaddrLbl"] = dropaddrLbl
        changeDropBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["changeDropBtn"] = changeDropBtn

        //pickuptimeinfoview
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separatorView"] = separatorView
        pickuptimeinfoview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickuptimeinfoview"] = pickuptimeinfoview
        pickuptimeimageview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickuptimeimageview"] = pickuptimeimageview
        pickuptimeheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickuptimeheaderlbl"] = pickuptimeheaderlbl
        pickuptimelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickuptimelbl"] = pickuptimelbl


        etapaymentview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etapaymentview"] = etapaymentview
        etaview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaview"] = etaview
        etaViewBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaViewBtn"] = etaViewBtn
        etaLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["etaLbl"] = etaLbl
        selectedcarnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["selectedcarnameLbl"] = selectedcarnameLbl
        paymenttypeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeLbl"] = paymenttypeLbl
        paymenttypeIv.contentMode = .scaleAspectFit
        paymenttypeIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeIv"] = paymenttypeIv
        paymenttypeselectbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeselectbtn"] = paymenttypeselectbtn
        paymenttypeselectiv.contentMode = .scaleAspectFit
        paymenttypeselectiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeselectiv"] = paymenttypeselectiv

        //paymentview
        paymentviewheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentviewheaderlbl"] = paymentviewheaderlbl
        paymentview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentview"] = paymentview
        paymenttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttbv"] = paymenttbv
        paymentview.addSubview(paymentViewCloseBtn)
        paymentViewCloseBtn.setTitle("Close".localize(), for: .normal)
        paymentViewCloseBtn.setTitleColor(.white, for: .normal)
        paymentViewCloseBtn.backgroundColor = etaview.backgroundColor
        paymentViewCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentViewCloseBtn"] = paymentViewCloseBtn

        confirmbookingbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["confirmbookingbtn"] = confirmbookingbtn
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        gestureview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gestureview"] = gestureview

        faredetailsview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["faredetailsview"] = faredetailsview
        fareDetailsUL1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fareDetailsUL1"] = fareDetailsUL1
        fareDetailsUL2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fareDetailsUL2"] = fareDetailsUL2
        faredetailsviewheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["faredetailsviewheaderlbl"] = faredetailsviewheaderlbl
        gotitbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gotitbtn"] = gotitbtn
        getfaredetailsbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["getfaredetailsbtn"] = getfaredetailsbtn
        ridefareheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ridefareheaderlbl"] = ridefareheaderlbl
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
        notehintlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["notehintlbl"] = notehintlbl
        hintlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["hintlbl"] = hintlbl

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


        let backBtn = UIButton()
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.imageView?.tintColor = .themeColor
        layoutDic["backBtn"] = backBtn
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.setImage(UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(backBtn)

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[backBtn(44)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[backBtn(44)]", options: [], metrics: nil, views: layoutDic))

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[confirmbookingbtn]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[etapaymentview(65)][separatorView(1)][pickuptimeinfoview(40)][confirmbookingbtn(40)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        confirmbookingbtn.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        pickupview.topAnchor.constraint(equalTo: self.top, constant: 50).isActive = true
        //        pickupview.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[pickupview]-(30)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pickupview(50)]", options: [], metrics: nil, views: layoutDic))
        dropview.topAnchor.constraint(equalTo: pickupview.bottomAnchor, constant: -10).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dropview(50)]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[dropview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paymentview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[paymentview(160)]|", options: [], metrics: nil, views: layoutDic))



        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gestureview]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[gestureview]|", options: [], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[faredetview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        faredetview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[faredetailsview]-(10)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.heightAnchor.constraint(equalToConstant: 320).isActive = true
        faredetailsview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        //paymentview
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[paymentviewheaderlbl(30)]-(10)-[paymenttbv]|", options: [], metrics: nil, views: layoutDic))
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[paymentViewCloseBtn(30)]", options: [], metrics: nil, views: layoutDic))

        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[paymentviewheaderlbl]-(10)-[paymentViewCloseBtn(60)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        paymentviewheaderlbl.centerXAnchor.constraint(equalTo: paymentview.centerXAnchor).isActive = true
        paymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paymenttbv]|", options: [], metrics: nil, views: layoutDic))

        //etapaymentview
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[etaview]-(10)-[paymenttypeselectbtn(==etaview)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[etaview]-(5)-|", options: [], metrics: nil, views: layoutDic))
        etapaymentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[paymenttypeIv(20)]-(8)-[paymenttypeLbl]-(8)-[paymenttypeselectiv(25)]", options: [APIHelper.appLanguageDirection,.alignAllCenterY], metrics: nil, views: layoutDic))
        paymenttypeLbl.centerYAnchor.constraint(equalTo: paymenttypeselectbtn.centerYAnchor).isActive = true
        paymenttypeLbl.centerXAnchor.constraint(equalTo: paymenttypeselectbtn.centerXAnchor).isActive = true
        paymenttypeIv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        paymenttypeLbl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        paymenttypeselectiv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[etaViewBtn]|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[etaViewBtn]|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[etaLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        etaview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(3)-[etaLbl]-(3)-[selectedcarnameLbl(==etaLbl)]-(3)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))

        //        faredetailsview
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[faredetailsviewheaderlbl(20)]-(10)-[fareDetailsUL1(1)]-(19)-[getfaredetailsbtn(20)]-(10)-[taxheaderlbl(20)]-(10)-[fareDetailsUL2(1)]-(9)-[totalheaderlbl(20)]-(15)-[notehintlbl(45)]-(0)-[hintlbl(65)]-(5)-[gotitbtn(40)]|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[faredetailsviewheaderlbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[fareDetailsUL1]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[getfaredetailsbtn]-(10)-[ridefarelbl(==getfaredetailsbtn)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[taxheaderlbl]-(10)-[taxlbl(==taxheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[fareDetailsUL2]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[totalheaderlbl]-(10)-[totallbl(==totalheaderlbl)]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[notehintlbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[hintlbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        faredetailsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[gotitbtn]|", options: [], metrics: nil, views: layoutDic))
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        faredetailsview.layoutIfNeeded()
        faredetailsview.setNeedsLayout()
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

//        pickuptimeinfoview

        pickuptimeinfoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[pickuptimeimageview(30)]-(10)-[pickuptimeheaderlbl]-(10)-[pickuptimelbl(==pickuptimeheaderlbl)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        pickuptimeinfoview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[pickuptimeimageview(30)]-(5)-|", options: [], metrics: nil, views: layoutDic))


    }

    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Please Hide!")
        self.paymentview.isHidden = true
        self.gestureview.isHidden = true
    }

    @IBAction func paymenttypeselectBtnaction() {
        self.gestureview.isHidden = false
        self.paymentview.isHidden=false
        self.view.bringSubviewToFront(self.paymentview)
    }

    @IBAction func paymentviewclosebtnAction() {
        self.paymentview.isHidden=true
    }

    func getContext1() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getUser() {
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

//    func setupmap() {
//        let latdouble=self.appdel.pickuplat
//        let longdouble=self.appdel.pickuplon
//
//        let destlatdouble=self.appdel.droplat
//        let destlondouble=self.appdel.droplon
//
//        let camera = GMSCameraPosition.camera(withLatitude: latdouble , longitude: longdouble , zoom: 12)
//        mapview.camera=camera
//
//        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
//        marker.icon = UIImage(named: "pickup_pin")
//        marker.map = mapview
//
//        desmarker.position = CLLocationCoordinate2D(latitude: destlatdouble , longitude: destlondouble )
//        desmarker.icon = UIImage(named: "destination_pin")
//        desmarker.map = mapview
//    }

    func getetaapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
                if activityView == nil {
                    activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                    // add subview
                    self.view.bringSubviewToFront(activityView)
                    self.view.addSubview(activityView)
                    // autoresizing mask
                    activityView.translatesAutoresizingMaskIntoConstraints = false
                    // constraints
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
                }
                //activityView.startAnimating()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                paramDict["type_id"] = self.selectedCarModel.id
                paramDict["olat"] = self.selectedPickUpLocation.latitude!
                paramDict["olng"] = self.selectedPickUpLocation.longitude!
                paramDict["dlat"] = self.selectedDropLocation.latitude!
                paramDict["dlng"] = self.selectedDropLocation.longitude!

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.geteta
                print(url)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        print(response.response as Any) // URL response
                        print(response.result.value as AnyObject)
                        if let result = response.result.value {
                            let JSON = result as! [String:AnyObject]
                            print("Response for Login",JSON)
                            print(JSON["success"] as! Bool)
                            let theSuccess = (JSON["success"] as! Bool)
                            if(theSuccess == true) {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.currency=(JSON["currency"] as? String)!
                                let def2=(JSON["total"] as! String)
                                let totalstr=self.currency + " " + def2
                                self.etaLbl.text = totalstr

                                self.totallbl.text=totalstr

                                let def12=(JSON["ride_fare"] as! String)
                                print(def12)
                                let totalstr1=self.currency + " " + def12
                                self.ridefarelbl.text=totalstr1

                                let def13=(JSON["tax_amount"] as! String)
                                print(def13)
                                let totalstr2=self.currency + " " + def13
                                self.taxlbl.text=totalstr2

                                let bp=(JSON["base_price"] as! Double)
                                print(bp)
                                let bpst=String(format: "%.2f", bp)
                                let bpstr=self.currency + " " + bpst
                                self.bflbl.text=bpstr

                                let rpk=(JSON["price_per_distance"] as! Double)
                                print(rpk)
                                let rpkst=String(format: "%.2f", rpk)
                                let rpkstr=self.currency + " " + rpkst
                                self.rateperkmlbl.text=rpkstr

                                let rtc=(JSON["price_per_time"] as! Double)
                                print(rtc)
                                let rtcst=String(format: "%.2f", rtc)
                                let rtcstr=self.currency + " " + rtcst
                                self.ridetimechargelbl.text=rtcstr

                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast(JSON["error_message"] as! String)
                            }
                        }
                }

        }
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
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
//            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
//        }
//        activityView.startAnimating()
//    }
//
//    func stopLoadingIndicator() {
//        activityView.stopAnimating()
//    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.startUpdatingLocation()
        location = locations.last!
        print("Location: \(location)")
        pickUpLat = "\(location.coordinate.latitude)"
        pickUpLong="\(location.coordinate.longitude)"
        let latdouble=Double(pickUpLat)
        let longdouble=Double(pickUpLong)

        let camera = GMSCameraPosition.camera(withLatitude: latdouble!, longitude: longdouble!, zoom: 15)
        mapview.camera=camera
        mapview.isMyLocationEnabled = true

        mapview.settings.myLocationButton = true
//        mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 20)

        // Creates a marker in the center of the map.

        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
        marker.icon = nil
    }

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        self.window1 = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//        self.window1?.rootViewController = mainViewController
//        self.window1?.makeKeyAndVisible()
    }

    //--------------------------------------
    // MARK: - Table view Delegates
    //--------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return self.paymenttypearray.count

    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            var cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as? PaymentTableViewCell
            if cell == nil {
              //  cell = PaymentTableViewCell()
            }
            cell?.paymentypeLbl.font = UIFont.appFont(ofSize: 17)
            cell?.paymentypeLbl.text = self.paymenttypearray[indexPath.row] as? String
            cell?.paymenttypeIv.image = UIImage(named: self.paymenttypeimagearray[indexPath.row] as! String)
            return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.paymenttypeLbl.text=self.paymenttypearray[indexPath.row] as? String
            self.paymentview.isHidden=true
            self.gestureview.isHidden = true
            if(self.paymenttypeLbl.text=="Cash") {
                selectedpaymentoption=1
                paymenttypeIv.image=UIImage(named: "paymentcash")
            }
            else if(self.paymenttypeLbl.text=="Card") {
                selectedpaymentoption=0
                paymenttypeIv.image=UIImage(named: "addcardicon")
            }
            else if(self.paymenttypeLbl.text=="Wallet") {
                selectedpaymentoption=2
                paymenttypeIv.image=UIImage(named: "paymentwallet")
            }
    }

    func getcoord(_ str : String) {
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
            self.getetaapicall()
        }
    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text as NSString? {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//            print(txtAfterUpdate)
//            if ConnectionCheck.isConnectedToNetwork() {
//                if(txtAfterUpdate.count>0) {
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
//                            .responseJSON { response in
//                        print(response.response as Any) // URL response
//                        print(response.result.value as AnyObject)   // result of response serialization
//                        if let result = response.result.value {
//                            let JSON = result as! NSDictionary
//                            self.arr = JSON.value(forKey: "predictions") as! NSArray
//                                    self.descrarr=self.arr.value(forKey: "description") as! NSArray
//                                    self.placenamearray = NSMutableArray()
//                                    self.placeaddressarray = NSMutableArray()
//                                    self.addressarray = NSMutableArray()
//                                    self.isfavouritearray = NSMutableArray()
//                                    for str in self.descrarr {
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
//                                    if(self.arr.count>0) {
//                                        self.searchlistTbv.isHidden=false
//                                        self.searchlistTbv .reloadData()
//                                    }
//                                }
//                        }
//                    } else {
//                        self.searchlistTbv.isHidden=true
//                    }
//                }
//                else {
//                    print("disConnected")
//                }
//        }
//        return true
//    }


    @IBAction func confirmbookinfbtnAction() {
        self.appdel.toaddr=self.dropaddrLbl.text!
        if(self.paymenttypeLbl.text=="Payment") {
            self.alert(message: "Please choose Payment method")
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                print("Connected")
                if activityView == nil {
                    activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.black, padding: 0.0)
                    // add subview
                    self.view.bringSubviewToFront(activityView)
                    self.view.addSubview(activityView)
                    // autoresizing mask
                    activityView.translatesAutoresizingMaskIntoConstraints = false
                    // constraints
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
                    view.addConstraint(NSLayoutConstraint(item: activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
                }
              //  activityView.startAnimating()
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor ), nil)
                let dateAsString = self.appdel.scheduletime //"6: 35 PM"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let date = dateFormatter.date(from: dateAsString)
                print("12 hour format",date as Any)

                dateFormatter.dateFormat = "HH:mm"
                let date24 = dateFormatter.string(from: date!)
                print("The twenty four hour time is: ",date24)

                let finaldatetime = self.appdel.scheduledate + " " + date24
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "ZZZZZ"

                guard let selecteddate = self.selectedDate else {
                    return
                }
                
                let zone = dateFormat.string(from: selecteddate)

                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                paramDict["type"] = self.selectedCarModel.id
                paramDict["platitude"] = self.selectedPickUpLocation.latitude
                paramDict["plongitude"] = self.selectedPickUpLocation.longitude
                paramDict["dlatitude"] = self.selectedDropLocation.latitude
                paramDict["dlongitude"] = self.selectedDropLocation.longitude
                paramDict["paymentOpt"] = selectedpaymentoption
                paramDict["timezone"] = zone//"+05:30"
                paramDict["datetime"] = finaldatetime
                paramDict["dlocation"] = self.selectedDropLocation.placeId
                paramDict["plocation"] = self.selectedPickUpLocation.placeId

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.scheduleride
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
                                self.appdel.tripscheduled="Yes"
                                self.navigationController?.view.showToast("Trip Registered Successfully")
                                self.navigationController?.popToRootViewController(animated: true)
//                                self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                                self.window1?.rootViewController = mainViewController
//                                self.window1?.makeKeyAndVisible()
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast(JSON.value(forKey: "error_message") as! String)
                            }
                        }
                }
            }
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
    func drawRouteOnMap(_ repeatAnimation:Bool) {

        self.mapview.clear()
        let bounds = GMSCoordinateBounds(coordinate: self.selectedPickUpLocation.coordinate, coordinate: self.selectedDropLocation.coordinate)
        self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        self.mapview.animate(toBearing: self.selectedPickUpLocation.coordinate.bearing(to: self.selectedDropLocation.coordinate)-40)
        self.addMarakers()

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.selectedPickUpLocation.latitude!),\(self.selectedPickUpLocation.longitude!)&destination=\(self.selectedDropLocation.latitude!),\(self.selectedDropLocation.longitude!)&sensor=true&mode=driving&key=AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
                    if let routes = json["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                        print(points)
                        DispatchQueue.main.async {
                            self.animatedPolyline = AnimatedPolyLine(points,repeats:repeatAnimation)
                            let bounds = GMSCoordinateBounds(path: self.animatedPolyline.path!)
                            self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)))
                            self.animatedPolyline.map = self.mapview
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    func addMarakers() {
        pickUpMarker = nil
        pickUpMarker = GMSMarker(position: self.selectedPickUpLocation.coordinate)
        pickUpMarker.icon = UIImage(named: "pickup_pin")
        pickUpMarker.appearAnimation = .pop
        pickUpMarker.map = mapview

        dropMarker = nil
        dropMarker = GMSMarker(position: self.selectedDropLocation.coordinate)
        dropMarker.icon = UIImage(named: "destination_pin")
        dropMarker.appearAnimation = .pop
        dropMarker.map = mapview
        self.mapview.animate(toViewingAngle: 45)
    }
}
