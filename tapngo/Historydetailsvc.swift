//
//  Historydetailsvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 19/02/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData
import Alamofire
import GoogleMaps
import Kingfisher

class Historydetailsvc: UIViewController, GMSMapViewDelegate {
    @IBOutlet var scrollview: UIScrollView!
    var containerView = UIView()

    @IBOutlet weak var mapview: GMSMapView!

    @IBOutlet var starratingBtn1: UIButton!
    @IBOutlet var starratingBtn2: UIButton!
    @IBOutlet var starratingBtn3: UIButton!
    @IBOutlet var starratingBtn4: UIButton!
    @IBOutlet var starratingBtn5: UIButton!

    @IBOutlet var driverprofilepicture: UIImageView!
    @IBOutlet var tripstatusimageview: UIImageView!
    @IBOutlet var triptypeiconiv: UIImageView!
    @IBOutlet var drivernamelbl: UILabel!

    @IBOutlet var totalamtlbl: UILabel!
    @IBOutlet var distancelbl: UILabel!
    @IBOutlet var timelbl: UILabel!

    @IBOutlet var pickupaddrlbl: UILabel!
    @IBOutlet var dropupaddrlbl: UILabel!

    @IBOutlet var billdetailslbl: UILabel!

    @IBOutlet weak var bpheaderlbl: UILabel!
    @IBOutlet weak var bpLbl: UILabel!

    @IBOutlet weak var dcheaderlbl: UILabel!
    @IBOutlet weak var dcLbl: UILabel!
    @IBOutlet weak var dchintLbl: UILabel!

    @IBOutlet weak var tcheaderlbl: UILabel!
    @IBOutlet weak var tcLbl: UILabel!
    @IBOutlet weak var tchintLbl: UILabel!

    @IBOutlet weak var wpheaderlbl: UILabel!
    @IBOutlet weak var wpLbl: UILabel!

    @IBOutlet weak var rbheaderlbl: UILabel!
    @IBOutlet weak var rbLbl: UILabel!

    @IBOutlet weak var pbheaderlbl: UILabel!
    @IBOutlet weak var pbLbl: UILabel!

    @IBOutlet weak var stheaderlbl: UILabel!
    @IBOutlet weak var stLbl: UILabel!

    var additionalAmntHeader = UILabel()
    var additionalAmount = UILabel()


    @IBOutlet weak var totheaderlbl: UILabel!
    @IBOutlet weak var totLbl: UILabel!

    @IBOutlet weak var paymentamtlbl: UILabel!
    @IBOutlet weak var paymenttypeheaderLbl: UILabel!
    @IBOutlet weak var paymenttypeLbl: UILabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator3: UIView!
    @IBOutlet weak var separator4: UIView!
    @IBOutlet weak var separator5: UIView!
    @IBOutlet weak var historyImgView: UIImageView!
    @IBOutlet weak var invoiceImgView: UIImageView!
    @IBOutlet weak var listBgView: UIView!
    @IBOutlet weak var zigzagImgView: UIImageView!
    
    var window1: UIWindow?
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

    var destlatdouble = Double()
    var destlondouble = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="History Details"
        scrollview.contentSize=CGSize(width : 320, height : 1000)
        self.getUser()
        self.gethistorydetails()
        self.setUpViews()
        // Do any additional setup after loading the view.
    }

    func setUpViews() {
        self.drivernamelbl.font = UIFont.appFont(ofSize: 15)
        self.totalamtlbl.font = UIFont.appFont(ofSize: 12)
        self.distancelbl.font = UIFont.appFont(ofSize: 12)
        self.timelbl.font = UIFont.appFont(ofSize: 12)
        self.pickupaddrlbl.font = UIFont.appFont(ofSize: 13)
        self.dropupaddrlbl.font = UIFont.appFont(ofSize: 13)

        self.billdetailslbl.font = UIFont.appFont(ofSize: 15)

        bpheaderlbl.font = UIFont.appFont(ofSize: 15)
        bpLbl.font = UIFont.appFont(ofSize: 15)

        dcheaderlbl.font = UIFont.appFont(ofSize: 15)
        dcLbl.font = UIFont.appFont(ofSize: 15)
        dchintLbl.font = UIFont.appFont(ofSize: 15)

        tcheaderlbl.font = UIFont.appFont(ofSize: 15)
        tcLbl.font = UIFont.appFont(ofSize: 15)
        tchintLbl.font = UIFont.appFont(ofSize: 15)

        wpheaderlbl.font = UIFont.appFont(ofSize: 15)
        wpLbl.font = UIFont.appFont(ofSize: 15)

        rbheaderlbl.font = UIFont.appFont(ofSize: 15)
        rbLbl.font = UIFont.appFont(ofSize: 15)

        pbheaderlbl.font = UIFont.appFont(ofSize: 15)
        pbLbl.font = UIFont.appFont(ofSize: 15)

        stheaderlbl.font = UIFont.appFont(ofSize: 15)
        stLbl.font = UIFont.appFont(ofSize: 15)

        additionalAmntHeader.font = UIFont.appFont(ofSize: 15)
        additionalAmount.font = UIFont.appFont(ofSize: 15)


        totheaderlbl.font = UIFont.appBoldFont(ofSize: 20)
        totLbl.font = UIFont.appBoldFont(ofSize: 20)

        paymentamtlbl.font = UIFont.appFont(ofSize: 15)
        paymenttypeheaderLbl.font = UIFont.appFont(ofSize: 15)
        paymenttypeLbl.font = UIFont.appFont(ofSize: 15)

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }

        scrollview.addSubview(containerView)
        [mapview,driverprofilepicture,separator1,triptypeiconiv,separator2,historyImgView,separator3,pickupaddrlbl,dropupaddrlbl,separator4,billdetailslbl,listBgView,zigzagImgView,paymenttypeheaderLbl,paymenttypeLbl,paymentamtlbl,starratingBtn1,starratingBtn2,starratingBtn3,starratingBtn4,starratingBtn5,tripstatusimageview,drivernamelbl,invoiceImgView,totalamtlbl,timelbl,distancelbl].forEach { $0!.removeFromSuperview();containerView.addSubview($0!) }

        [bpheaderlbl,bpLbl,dcheaderlbl,dcLbl,dchintLbl,tcheaderlbl,tcLbl,tchintLbl,wpheaderlbl,wpLbl,rbheaderlbl,rbLbl,pbheaderlbl,pbLbl,stheaderlbl,stLbl,totheaderlbl,totLbl].forEach { $0!.removeFromSuperview();listBgView.addSubview($0!) }



        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollview"] = scrollview
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["containerView"] = containerView
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        starratingBtn1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn1"] = starratingBtn1
        starratingBtn1.imageView?.contentMode = .scaleAspectFit
        starratingBtn2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn2"] = starratingBtn2
        starratingBtn2.imageView?.contentMode = .scaleAspectFit
        starratingBtn3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn3"] = starratingBtn3
        starratingBtn3.imageView?.contentMode = .scaleAspectFit
        starratingBtn4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn4"] = starratingBtn4
        starratingBtn4.imageView?.contentMode = .scaleAspectFit
        starratingBtn5.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingBtn5"] = starratingBtn5
        starratingBtn5.imageView?.contentMode = .scaleAspectFit
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverprofilepicture"] = driverprofilepicture
        tripstatusimageview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripstatusimageview"] = tripstatusimageview
        triptypeiconiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["triptypeiconiv"] = triptypeiconiv
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivernamelbl"] = drivernamelbl
        totalamtlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalamtlbl"] = totalamtlbl
        distancelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["distancelbl"] = distancelbl
        timelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["timelbl"] = timelbl
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pickupaddrlbl"] = pickupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dropupaddrlbl"] = dropupaddrlbl
        bpheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bpheaderlbl"] = bpheaderlbl
        bpLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bpLbl"] = bpLbl
        dcheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dcheaderlbl"] = dcheaderlbl
        dcLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dcLbl"] = dcLbl
        dchintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dchintLbl"] = dchintLbl
        tcheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tcheaderlbl"] = tcheaderlbl
        tcLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tcLbl"] = tcLbl
        tchintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tchintLbl"] = tchintLbl
        wpheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["wpheaderlbl"] = wpheaderlbl
        wpLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["wpLbl"] = wpLbl
        rbheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rbheaderlbl"] = rbheaderlbl
        rbLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["rbLbl"] = rbLbl
        pbheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pbheaderlbl"] = pbheaderlbl
        pbLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pbLbl"] = pbLbl
        stheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stheaderlbl"] = stheaderlbl
        stLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stLbl"] = stLbl

        additionalAmntHeader.text = "Additional charge".localize()
        additionalAmntHeader.textColor = UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        additionalAmntHeader.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["additionalAmntHeader"] = additionalAmntHeader
        listBgView.addSubview(additionalAmntHeader)
        additionalAmount.textColor = UIColor(red: 184.0/255.0, green: 184.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        additionalAmount.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["additionalAmount"] = additionalAmount
        listBgView.addSubview(additionalAmount)


        totheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totheaderlbl"] = totheaderlbl
        totLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totLbl"] = totLbl
        paymentamtlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymentamtlbl"] = paymentamtlbl
        paymenttypeheaderLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeheaderLbl"] = paymenttypeheaderLbl
        paymenttypeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["paymenttypeLbl"] = paymenttypeLbl
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator1"] = separator1
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator2"] = separator2
        separator3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator3"] = separator3
        separator4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator4"] = separator4
        separator5.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["separator5"] = separator5
        historyImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["historyImgView"] = historyImgView
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceImgView"] = invoiceImgView
        billdetailslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["billdetailslbl"] = billdetailslbl
        listBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["listBgView"] = listBgView
        zigzagImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["zigzagImgView"] = zigzagImgView

        scrollview.topAnchor.constraint(equalTo: self.top).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollview]", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [], metrics: nil, views: layoutDic))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        let containerViewHgt = containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        containerViewHgt.priority = UILayoutPriority(rawValue: 250)
        containerViewHgt.isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapview(150)]-(20)-[driverprofilepicture(50)]-(10)-[separator1(1)]-(10)-[triptypeiconiv(40)]-(10)-[separator2(1)]-(10)-[historyImgView(40)]-(10)-[separator3(1)]-(15)-[pickupaddrlbl(40)]-(5)-[dropupaddrlbl(40)]-(10)-[separator4(1)]-(15)-[billdetailslbl(20)]-(5)-[listBgView(355)][zigzagImgView(10)]-(10)-[paymenttypeheaderLbl(25)]-(10)-[paymenttypeLbl(20)]-(20)-|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[driverprofilepicture(50)]-(15)-[drivernamelbl]", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[drivernamelbl]-(15)-[tripstatusimageview(40)]-(30)-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDic))
        drivernamelbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tripstatusimageview.heightAnchor.constraint(equalTo: tripstatusimageview.widthAnchor).isActive = true
        tripstatusimageview.centerYAnchor.constraint(equalTo: driverprofilepicture.centerYAnchor).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[driverprofilepicture]-(15)-[starratingBtn1(17)]", options: [APIHelper.appLanguageDirection,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[starratingBtn1][starratingBtn2(17)][starratingBtn3(17)][starratingBtn4(17)][starratingBtn5(17)]", options: [APIHelper.appLanguageDirection,.alignAllBottom,.alignAllTop], metrics: nil, views: layoutDic))
        starratingBtn1.heightAnchor.constraint(lessThanOrEqualTo: starratingBtn1.widthAnchor).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[driverprofilepicture(50)]-(15)-[drivernamelbl]", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator1]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[triptypeiconiv(40)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator2]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[historyImgView(40)]-(15)-[totalamtlbl(==timelbl)]-(15)-[distancelbl(==timelbl)]-(15)-[timelbl]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator3]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(30)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(30)]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDic))
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator4]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[billdetailslbl(150)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[listBgView]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[zigzagImgView]|", options: [], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[paymenttypeheaderLbl(150)]", options: [APIHelper.appLanguageDirection,], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(24)-[paymenttypeLbl(100)]-(>=20)-[paymentamtlbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))


        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[bpheaderlbl(20)]-(10)-[dcheaderlbl(20)]-(5)-[dchintLbl(20)]-(10)-[tcheaderlbl(20)]-(5)-[tchintLbl(20)]-(10)-[wpheaderlbl(20)]-(10)-[rbheaderlbl(20)]-(10)-[pbheaderlbl(20)]-(10)-[stheaderlbl(20)]-(10)-[additionalAmntHeader(20)]-(15)-[separator5(1)]-(15)-[totheaderlbl(20)]-(15)-|", options: [], metrics: nil, views: layoutDic))

        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[bpheaderlbl]-(10)-[bpLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[dcheaderlbl]-(10)-[dcLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[dchintLbl]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[tcheaderlbl]-(10)-[tcLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[tchintLbl]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[wpheaderlbl]-(10)-[wpLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[rbheaderlbl]-(10)-[rbLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[pbheaderlbl]-(10)-[pbLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[stheaderlbl]-(10)-[stLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[additionalAmntHeader]-(10)-[additionalAmount(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator5]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        listBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[totheaderlbl]-(10)-[totLbl(90)]-(50)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))





        drivernamelbl.textAlignment = APIHelper.appTextAlignment
        totalamtlbl.textAlignment = APIHelper.appTextAlignment
        distancelbl.textAlignment = APIHelper.appTextAlignment
        timelbl.textAlignment = APIHelper.appTextAlignment
        pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        billdetailslbl.textAlignment = APIHelper.appTextAlignment
        bpheaderlbl.textAlignment = APIHelper.appTextAlignment
        bpLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        dcheaderlbl.textAlignment = APIHelper.appTextAlignment
        dcLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        dchintLbl.textAlignment = APIHelper.appTextAlignment
        tcheaderlbl.textAlignment = APIHelper.appTextAlignment
        tcLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        tchintLbl.textAlignment = APIHelper.appTextAlignment
        wpheaderlbl.textAlignment = APIHelper.appTextAlignment
        wpLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        rbheaderlbl.textAlignment = APIHelper.appTextAlignment
        rbLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        pbheaderlbl.textAlignment = APIHelper.appTextAlignment
        pbLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        stheaderlbl.textAlignment = APIHelper.appTextAlignment
        stLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        additionalAmntHeader.textAlignment = APIHelper.appTextAlignment
        additionalAmount.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        totheaderlbl.textAlignment = APIHelper.appTextAlignment
        totLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        paymentamtlbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        paymenttypeheaderLbl.textAlignment = APIHelper.appTextAlignment
        paymenttypeLbl.textAlignment = APIHelper.appTextAlignment

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
    // MARK: - Populating mapinfo
    //--------------------------------------

    func setupmap() {
        let latdouble=self.historydict.value(forKey: "pick_latitude")
        let longdouble=self.historydict.value(forKey: "pick_longitude")

        if let destlatdouble1=self.historydict.value(forKey: "drop_latitude") as? Double {
            self.destlatdouble = destlatdouble1
        }
        if let destlondouble1=self.historydict.value(forKey: "drop_longitude") as? Double {
            self.destlondouble = destlondouble1
        }

        let camera = GMSCameraPosition.camera(withLatitude: latdouble! as! CLLocationDegrees, longitude: longdouble! as! CLLocationDegrees, zoom: 14)
        mapview.camera=camera

        marker.position = CLLocationCoordinate2D(latitude: (mapview.camera.target.latitude), longitude: (mapview.camera.target.longitude))
        marker.icon = UIImage(named: "pickup_pin")
        marker.map = mapview

        desmarker.position = CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees)
        desmarker.icon = UIImage(named: "destination_pin")
        desmarker.map = mapview

        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: latdouble as! CLLocationDegrees, longitude: longdouble as! CLLocationDegrees), coordinate: CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees))
        self.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
        self.mapview.animate(toBearing: CLLocationCoordinate2D(latitude: latdouble as! CLLocationDegrees, longitude: longdouble as! CLLocationDegrees).bearing(to: CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees))-90)
//        let path = GMSMutablePath()
//        path.add(CLLocationCoordinate2D(latitude: mapview.camera.target.latitude, longitude: mapview.camera.target.longitude))
//        path.add(CLLocationCoordinate2D(latitude: destlatdouble as! CLLocationDegrees, longitude: destlondouble as! CLLocationDegrees))
//        var bounds = GMSCoordinateBounds()
//
//        for index in 0...path.count() {
//            bounds = bounds.includingCoordinate(path.coordinate(at: index))
//        }
//        self.mapview.animate(with: GMSCameraUpdate.fit(bounds))
    }

    //--------------------------------------
    // MARK: - Populating history info
    //--------------------------------------

    func setupdata() {
        let iscompl=historydict.value(forKey: "is_completed") as! Bool
        if(iscompl == true) {
            self.tripstatusimageview.isHidden=false
        } else {
            self.tripstatusimageview.isHidden=true
        }
        let driverdict = self.historydict.value(forKey: "driver") as! NSDictionary
        self.driverprofilepicture.layer.masksToBounds=true
        self.driverprofilepicture.layer.cornerRadius=self.driverprofilepicture.layer.frame.width/2

        if let url = URL(string:driverdict.value(forKey: "profile_pic") as! String)
        {
            let rosource = ImageResource(downloadURL: url)
            self.driverprofilepicture.kf.setImage(with: rosource)
            self.driverprofilepicture.kf.indicatorType = .activity
            self.driverprofilepicture.contentMode = .scaleToFill
        }


        let fnstr=driverdict.value(forKey: "firstname") as! String
        let lnstr=driverdict.value(forKey: "lastname") as! String
        let namestr : String = fnstr + " " + lnstr
        self.drivernamelbl.text = namestr

//        let driverreview = driverdict.value(forKey: "review")
        let driverreview = "\((driverdict as AnyObject).value(forKey: "review")!)"
        let strr : String=driverreview 
        var strint=Int()
        strint = Int(Float(strr)!)
        print(strr)
        if(strint==1) {
            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn2.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        } else if(strint==2) {
            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        } else if(strint==3) {
            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        } else if(strint==4) {
            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        } else if(strint==5) {
            self.starratingBtn1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
            self.starratingBtn5.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        }

        if let url = URL(string: historydict.value(forKey: "type_icon") as! String)
        {
            let rosource = ImageResource(downloadURL: url)
            self.triptypeiconiv.kf.setImage(with: rosource)
            self.triptypeiconiv.kf.indicatorType = .activity
            self.triptypeiconiv.contentMode = .scaleToFill
        }

        //total

        billdict = self.historydict.value(forKey: "bill") as! NSDictionary
        self.currency=(billdict.value(forKey: "currency") as? String)!
        let iscan=historydict.value(forKey: "is_cancelled") as! Bool
        if (iscan==true) {

        } else {
            let def2=(billdict.value(forKey: "total") as! Double)
            print(def2)
            let st=String(format: "%.2f", def2)
            let totalstr=self.currency + " " + st
            self.totalamtlbl.text=totalstr

        //pickup and drop address

            self.pickupaddrlbl.text=historydict.value(forKey: "pick_location") as? String
            self.dropupaddrlbl.text=historydict.value(forKey: "drop_location") as? String

        //time

            let time=historydict.value(forKey: "time") as! Double
            let timestr = String(time)
            self.timelbl.text=timestr + " Min"

        //distance

            let distance=historydict.value(forKey: "distance") as! Double
            print(distance)
            if (distance>0) {
                let myStringToTwoDecimals = String(format: "%.2f", distance)
                self.distancelbl.text=myStringToTwoDecimals + " kms"
            }
            else {
                self.distancelbl.text=String(distance) + " kms"
            }

        // bill details

            self.currency=(billdict.value(forKey: "currency") as? String)!

            let baseprice=billdict.value(forKey: "base_price") as! Double
            let bpst=String(format: "%.2f", baseprice)
            self.bpLbl.text = self.currency + bpst

            let distancecost=billdict.value(forKey: "distance_price") as! Double
            let dcst=String(format: "%.2f", distancecost)
            self.dcLbl.text = self.currency + dcst

            let priceperdistance=billdict.value(forKey: "price_per_distance") as! Double
            let ppdst=String(format: "%.1f", priceperdistance)
            self.dchintLbl.text=self.currency + ppdst + " / Km"

            let timecost=billdict.value(forKey: "time_price") as! Double
            let tcst=String(format: "%.2f", timecost)
            self.tcLbl.text = self.currency + tcst

            let pricepertime=billdict.value(forKey: "price_per_time") as! Double
            let pptst=String(format: "%.1f", pricepertime)
            self.tchintLbl.text=self.currency + pptst + " / Min"

            let waitingprice=billdict.value(forKey: "waiting_price") as! Double
            let wpst=String(format: "%.2f", waitingprice)
            self.wpLbl.text = self.currency + wpst

            let referralbonus=billdict.value(forKey: "referral_amount") as! Double
            let rbst=String(format: "%.2f", referralbonus)
            self.rbLbl.text = self.currency + rbst

            let promobonus=billdict.value(forKey: "promo_amount") as! Double
            let pbst=String(format: "%.2f", promobonus)
            self.pbLbl.text = self.currency + pbst

            let servicetax=billdict.value(forKey: "service_tax") as! Double
            let stst=String(format: "%.2f", servicetax)
            self.stLbl.text = self.currency + stst


            if let extraamount=billdict.value(forKey: "extra_amount") as? Double {
                let eamnt=String(format: "%.2f", extraamount)
                self.additionalAmount.text = self.currency + eamnt
            }

            let total=billdict.value(forKey: "total") as! Double
            let totst=String(format: "%.2f", total)
            self.totLbl.text = self.currency + totst

            self.paymentamtlbl.text = self.currency + totst

            let paymenttype=historydict.value(forKey: "payment_opt") as! Int
            if(paymenttype==0) {
                self.paymenttypeLbl.text = "CARD"
            }
            else if(paymenttype==1) {
                self.paymenttypeLbl.text = "CASH"
            }
            else if(paymenttype==2) {
                self.paymenttypeLbl.text = "WALLET"
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
//            view.addSubview(activityView)
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

    //--------------------------------------
    // MARK: - Alert-custom
    //--------------------------------------

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

