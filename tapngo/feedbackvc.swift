                //
//  feedbackvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 31/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import NVActivityIndicatorView
import UserNotifications


class feedbackvc: UIViewController, UITextViewDelegate {

    let appdel=UIApplication.shared.delegate as!AppDelegate

    @IBOutlet weak var workInProgressLbl: UILabel!
    @IBOutlet weak var invoiceLineImgView: UIImageView!
    @IBOutlet weak var invoiceLineImgView2: UIImageView!
    @IBOutlet weak var invoiceLineImgView3: UILabel!
    @IBOutlet weak var commentViewSep1: UILabel!
    @IBOutlet weak var commentViewSep2: UILabel!
    @IBOutlet weak var invoiceview: UIView!
    @IBOutlet weak var timeIv: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var distanceIv: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
//    @IBOutlet weak var lineview1: UIView!
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
    @IBOutlet weak var totheaderlbl: UILabel!
    @IBOutlet weak var totLbl: UILabel!
    @IBOutlet weak var ratingcommentsview: UIView!
    @IBOutlet weak var driverratingIv: UIImageView!
    @IBOutlet weak var drivernameLbl: UILabel!
    @IBOutlet weak var starratingbutton1: UIButton!
    @IBOutlet weak var starratingbutton2: UIButton!
    @IBOutlet weak var starratingbutton3: UIButton!
    @IBOutlet weak var starratingbutton4: UIButton!
    @IBOutlet weak var starratingbutton5: UIButton!
    @IBOutlet weak var commentsTv: UITextView!
    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var cuttedlineIv: UIImageView!

    var lblextraAmount = UILabel()
    var lblExtraAmntHeader = UILabel()

    var currency = ""

    var tripdetailsdict=NSDictionary()

    var billdict=NSMutableDictionary()
    var driverdict=NSMutableDictionary()

    var profilepicktureurl=String()

    var rating=Int()

    var currentuserid: String! = ""
    var currentusertoken: String! = ""

    var activityView: NVActivityIndicatorView!
    let helperObject = APIHelper()
    var window1: UIWindow?

    var tripcurrency = ""
    var tripbaseprice = ""
    var tripdistanceprice = ""
    var trippriceperdistance = ""
    var triptimeprice = ""
    var trippricepertime = ""
    var tripwaitingprice = ""
    var tripreferralamount = ""
    var trippromoamount = ""
    var tripservicetax = ""
    var triptotal = ""
    var triptime = ""
    var tripdistance = ""
    var tripextraAmount = ""

    var invoiceviewstatus = ""

    var tripresumefirstname = ""
    var tripresumelastname = ""
    var tripresumedriverprofilepicture = ""

    var triprequestid = ""

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Invoice"
        self.navigationItem.setHidesBackButton(true, animated:true)


        if (self.appdel.isdriverstarted=="1" && self.appdel.isdriverarrived=="1" && self.appdel.istripstarted=="1" && self.appdel.iscompleted=="1") {
            self.gettripbilldata()

            self.getinvoiceviewstatus()


            let baseprice=tripbaseprice
            //let st=String(format: "%.2f", baseprice)
            self.bpLbl.text = tripcurrency + baseprice

            let distancecost=tripdistanceprice
            //let dcst=String(format: "%.2f", distancecost)
            self.dcLbl.text = tripcurrency + distancecost

            let priceperdistance=trippriceperdistance
            //let ppdst=String(format: "%.1f", priceperdistance)
            self.dchintLbl.text=tripcurrency + priceperdistance + " / Km"

            let timecost=triptimeprice
            //let tcst=String(format: "%.2f", timecost)
            self.tcLbl.text = tripcurrency + timecost

            let pricepertime=trippricepertime
            //let pptst=String(format: "%.1f", pricepertime)
            self.tchintLbl.text=tripcurrency + pricepertime + " / Min"

            let waitingprice=tripwaitingprice
            //let wpst=String(format: "%.2f", waitingprice)
            self.wpLbl.text = tripcurrency + waitingprice

            let referralbonus=tripreferralamount
            //let rbst=String(format: "%.2f", referralbonus)
            self.rbLbl.text = tripcurrency + referralbonus

            let promobonus=trippromoamount
            //let pbst=String(format: "%.2f", promobonus)
            self.pbLbl.text = tripcurrency + promobonus

            let servicetax=tripservicetax
            //let stst=String(format: "%.2f", servicetax)
            self.stLbl.text = tripcurrency + servicetax

            let extraamount=tripextraAmount
            //let stst=String(format: "%.2f", servicetax)
            self.lblextraAmount.text = tripcurrency + extraamount


            let total=triptotal
            //let totst=String(format: "%.2f", total)
            self.totLbl.text = tripcurrency + total

            if(triptime == "0.00" || triptime == "0" ) {
                self.timeLbl.text = "0" + " Min"
            }
            else {
                self.timeLbl.text=triptime + " Mins"
            }
            //let td=String(format: "%.03f", tripdistance)
            self.distanceLbl.text=tripdistance + " Km"

            self.getdriverdetails()

            self.drivernameLbl.text=tripresumefirstname + " " + tripresumelastname

            profilepicktureurl=tripresumedriverprofilepicture

            if(profilepicktureurl.count>0) {
                self.setprofilepict()
            }
            rating=0
            self.gettripdetails()
            self.appdel.requestid=Int(triprequestid)!

            if(invoiceviewstatus=="Yes") {
                self.invoiceview.isHidden=true
                self.ratingcommentsview.isHidden=false
                self.confirmbutton.isHidden=true
                self.cuttedlineIv.isHidden=true
                self.tripdetailsdict = NSDictionary()
            }
        } else {
            self.navigationItem.setHidesBackButton(true, animated:true)
            print(self.appdel.billdict)

            billdict=self.appdel.billdict
            if let currency = billdict.value(forKey: "currency") as? String {
                self.currency = currency
            }

            if let baseprice=billdict.value(forKey: "base_price") as? Double {
            let st=String(format: "%.2f", baseprice)
            self.bpLbl.text = self.currency + st
            }

            if let distancecost=billdict.value(forKey: "distance_price") as? Double {
            let dcst=String(format: "%.2f", distancecost)
            self.dcLbl.text = self.currency + dcst
            }

            if let priceperdistance=billdict.value(forKey: "price_per_distance") as? Double {
            let ppdst=String(format: "%.1f", priceperdistance)
            self.dchintLbl.text=self.currency + ppdst + " / Km"
            }

            if let timecost=billdict.value(forKey: "time_price") as? Double {
            let tcst=String(format: "%.2f", timecost)
            self.tcLbl.text = self.currency + tcst
            }

            if let pricepertime=billdict.value(forKey: "price_per_time") as? Double {
            let pptst=String(format: "%.1f", pricepertime)
            self.tchintLbl.text=self.currency + pptst + " / Min"
            }

            if let waitingprice=billdict.value(forKey: "waiting_price") as? Double {
            let wpst=String(format: "%.2f", waitingprice)
            self.wpLbl.text = self.currency + wpst
            }

            if let referralbonus=billdict.value(forKey: "referral_amount") as? Double {
            let rbst=String(format: "%.2f", referralbonus)
            self.rbLbl.text = self.currency + rbst
            }

            if let promobonus=billdict.value(forKey: "promo_amount") as? Double {
            let pbst=String(format: "%.2f", promobonus)
            self.pbLbl.text = self.currency + pbst
            }

            if let servicetax=billdict.value(forKey: "service_tax") as? Double {
            let stst=String(format: "%.2f", servicetax)
            self.stLbl.text = self.currency + stst
            }

            if let extraAmount=billdict.value(forKey: "extra_amount") as? Double {
            let eamnt=String(format: "%.2f", extraAmount)
            print(eamnt)
            self.lblextraAmount.text = self.currency + eamnt
            }

            if let extraAmount=billdict.value(forKey: "extra_amount") as? String {
                let eamnt=String(format: "%.2f", extraAmount)
                print(extraAmount)
                self.lblextraAmount.text = self.currency + extraAmount
            }


            if let total=billdict.value(forKey: "total") as? Double {
            let totst=String(format: "%.2f", total)
            self.totLbl.text = self.currency + totst
            }

            if let total=billdict.value(forKey: "total") as? String {
                let totst=String(format: "%.2f", total)
                self.totLbl.text = self.currency + total
            }



            if(self.appdel.triptime == "0") {
                self.timeLbl.text=self.appdel.triptime + " Min"
            }
            else {
                self.timeLbl.text=self.appdel.triptime + " Mins"
            }
            //let td=String(format: "%.3f", self.appdel.tripdistance)
            self.distanceLbl.text=self.appdel.tripdistance + " Km"

            print(self.appdel.driverdict)
            driverdict=self.appdel.driverdict
            if(self.appdel.driverdict.count>0) {
                self.drivernameLbl.text=(driverdict.value(forKey: "firstname") as! String) + " " + (driverdict.value(forKey: "lastname") as! String)
            }

            if let profilepicktureur = driverdict.value(forKey: "profile_pic") as? String {
                profilepicktureurl = profilepicktureur
            }
           // profilepicktureurl=driverdict.value(forKey: "profile_pic") as! String

            if(profilepicktureurl.count>0) {
                self.setprofilepict()
            }
            rating=0
        }
        self.driverratingIv.layer.masksToBounds=true
        self.driverratingIv.layer.cornerRadius=self.driverratingIv.frame.size.width/2
        self.commentsTv.layer.borderWidth=0.5
        self.commentsTv.layer.cornerRadius=5
        self.getUser()
         self.setUpViews()

        // Do any additional setup after loading the view.
    }

    func setUpViews() {
        self.timeLbl.font = UIFont.appFont(ofSize: 15)
        self.distanceLbl.font = UIFont.appFont(ofSize: 15)

        self.bpheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.bpLbl.font = UIFont.appFont(ofSize: 15)
        self.dcheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.dcLbl.font = UIFont.appFont(ofSize: 15)
        self.dchintLbl.font = UIFont.appFont(ofSize: 12)
        self.tcheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.tcLbl.font = UIFont.appFont(ofSize: 15)
        self.tchintLbl.font = UIFont.appFont(ofSize: 12)
        self.wpheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.wpLbl.font = UIFont.appFont(ofSize: 15)
        self.rbheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.rbheaderlbl.textColor = .themeColor
        self.rbLbl.font = UIFont.appFont(ofSize: 15)
        self.rbLbl.textColor = .themeColor
        self.pbheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.pbheaderlbl.textColor = .themeColor
        self.pbLbl.font = UIFont.appFont(ofSize: 15)
        self.pbLbl.textColor = .themeColor
        self.stheaderlbl.font = UIFont.appFont(ofSize: 15)
        self.stheaderlbl.textColor = .themeColor
        self.lblExtraAmntHeader.font = UIFont.appFont(ofSize: 15)
        self.lblExtraAmntHeader.textColor = .themeColor
        self.stLbl.font = UIFont.appFont(ofSize: 15)
        self.stLbl.textColor = .themeColor
        self.lblextraAmount.font = UIFont.appFont(ofSize: 15)
        self.lblextraAmount.textColor = .themeColor
        self.totheaderlbl.font = UIFont.appBoldFont(ofSize: 20)
        self.totLbl.font = UIFont.appBoldFont(ofSize: 20)

        self.confirmbutton.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.confirmbutton.backgroundColor = .themeColor

        self.drivernameLbl.font = UIFont.appFont(ofSize: 15)
        self.commentsTv.font = UIFont.appFont(ofSize: 14)

        self.submitbutton.titleLabel?.font = UIFont.appFont(ofSize: 15)
        self.submitbutton.backgroundColor = .themeColor

        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }

        workInProgressLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["workInProgressLbl"] = workInProgressLbl
        invoiceLineImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceLineImgView"] = invoiceLineImgView
        invoiceLineImgView2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceLineImgView2"] = invoiceLineImgView2
        invoiceLineImgView3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceLineImgView3"] = invoiceLineImgView3
        commentViewSep1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["commentViewSep1"] = commentViewSep1
        commentViewSep2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["commentViewSep2"] = commentViewSep2
        invoiceview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceview"] = invoiceview
        timeIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["timeIv"] = timeIv
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["timeLbl"] = timeLbl
        distanceIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["distanceIv"] = distanceIv
        distanceLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["distanceLbl"] = distanceLbl
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

        lblextraAmount.textAlignment = .right
        lblextraAmount.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblextraAmount"] = lblextraAmount
        invoiceview.addSubview(lblextraAmount)
        self.lblExtraAmntHeader.text = "Additional charge".localize()
        lblExtraAmntHeader.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblExtraAmntHeader"] = lblExtraAmntHeader
        invoiceview.addSubview(lblExtraAmntHeader)

        totheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totheaderlbl"] = totheaderlbl
        totLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totLbl"] = totLbl
        ratingcommentsview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ratingcommentsview"] = ratingcommentsview
        driverratingIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverratingIv"] = driverratingIv
        drivernameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["drivernameLbl"] = drivernameLbl
        starratingbutton1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingbutton1"] = starratingbutton1
        starratingbutton2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingbutton2"] = starratingbutton2
        starratingbutton3.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingbutton3"] = starratingbutton3
        starratingbutton4.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingbutton4"] = starratingbutton4
        starratingbutton5.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["starratingbutton5"] = starratingbutton5
        commentsTv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["commentsTv"] = commentsTv
        confirmbutton.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["confirmbutton"] = confirmbutton
        submitbutton.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["submitbutton"] = submitbutton
        cuttedlineIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cuttedlineIv"] = cuttedlineIv

        workInProgressLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[workInProgressLbl]-(20)-|", options: [], metrics: nil, views: layoutDic))
        workInProgressLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[submitbutton]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[confirmbutton]|", options: [], metrics: nil, views: layoutDic))
        confirmbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmbutton.bottomAnchor.constraint(equalTo: self.bottom).isActive = true
        submitbutton.bottomAnchor.constraint(equalTo: self.bottom).isActive = true

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[ratingcommentsview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        ratingcommentsview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[commentViewSep1(4)]-(6)-[driverratingIv(80)]-(15)-[drivernameLbl(20)]-(15)-[starratingbutton3(25)]-(10)-[commentsTv(75)]-(6)-[commentViewSep2(4)]|", options: [.alignAllCenterX], metrics: nil, views: layoutDic))
        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[commentViewSep1]|", options: [], metrics: nil, views: layoutDic))
        driverratingIv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[drivernameLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[starratingbutton1(25)]-(2)-[starratingbutton2(25)]-(2)-[starratingbutton3(25)]-(2)-[starratingbutton4(25)]-(2)-[starratingbutton5(25)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[commentsTv]-(10)-|", options: [], metrics: nil, views: layoutDic))
        ratingcommentsview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[commentViewSep2]|", options: [], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[invoiceview]-(20)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[invoiceview][cuttedlineIv(10)]", options: [], metrics: nil, views: layoutDic))
        invoiceview.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[invoiceLineImgView3(2)]-(9)-[timeLbl(20)]-(6)-[invoiceLineImgView(2)]-(15)-[bpheaderlbl(20)]-(15)-[dcheaderlbl(20)]-(5)-[dchintLbl(20)]-(10)-[tcheaderlbl(20)]-(15)-[tchintLbl(20)]-(10)-[wpheaderlbl(20)]-(25)-[rbheaderlbl(20)]-(10)-[pbheaderlbl(20)]-(10)-[stheaderlbl(20)]-(10)-[lblExtraAmntHeader(20)]-(15)-[invoiceLineImgView2(2)]-(15)-[totheaderlbl(25)]-(15)-|", options: [], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[invoiceLineImgView3]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[timeIv(15)]-(12)-[timeLbl]-(8)-[distanceIv(15)]-(15)-[distanceLbl(60)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllCenterY], metrics: nil, views: layoutDic))
        timeIv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        distanceIv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        distanceLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[invoiceLineImgView]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bpheaderlbl]-(10)-[bpLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[dcheaderlbl]-(10)-[dcLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[dchintLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tcheaderlbl]-(10)-[tcLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tchintLbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[wpheaderlbl]-(10)-[wpLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[rbheaderlbl]-(10)-[rbLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[pbheaderlbl]-(10)-[pbLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[stheaderlbl]-(10)-[stLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[lblExtraAmntHeader]-(10)-[lblextraAmount(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[invoiceLineImgView2]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        invoiceview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[totheaderlbl]-(10)-[totLbl(90)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

    }

    func customformat() {
        self.bpheaderlbl.text = "Base Price".localize()
        self.dcheaderlbl.text = "Distance Cost".localize()
        self.tcheaderlbl.text = "Time Cost".localize()
        self.wpheaderlbl.text = "Waiting Price".localize()
        self.rbheaderlbl.text = "Referral Bonus".localize()
        self.pbheaderlbl.text = "Promo Bonus".localize()
        self.stheaderlbl.text = "Service Tax".localize()
        self.lblExtraAmntHeader.text = "Additional charge".localize()
        self.totheaderlbl.text = "Total".localize()
        self.confirmbutton.setTitle("CONFIRM".localize(), for: .normal)
        self.submitbutton.setTitle("SUBMIT".localize(), for: .normal)
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

    func gettripbilldata() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Tripbilldetails> = Tripbilldetails.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
                //get the Key Value pairs (although there may be a better way to do that...
                tripcurrency = (String(describing: user.value(forKey: "currency")!))
                tripbaseprice = (String(describing: user.value(forKey: "baseprice")!))
                tripdistanceprice = (String(describing: user.value(forKey: "distanceprice")!))
                trippriceperdistance = (String(describing: user.value(forKey: "priceperdistance")!))
                triptimeprice = (String(describing: user.value(forKey: "timeprice")!))
                trippricepertime = (String(describing: user.value(forKey: "pricepertime")!))
                tripwaitingprice = (String(describing: user.value(forKey: "waitingprice")!))
                tripreferralamount = (String(describing: user.value(forKey: "referralamount")!))
                trippromoamount = (String(describing: user.value(forKey: "promoamount")!))
                tripservicetax = (String(describing: user.value(forKey: "servicetax")!))
                triptotal = (String(describing: user.value(forKey: "total")!))
                triptime = (String(describing: user.value(forKey: "time")!))
                if let tripdistanc = user.value(forKey: "distance") {
                    tripdistance = (String(describing: tripdistanc))
                }
               // tripdistance = (String(describing: user.value(forKey: "distance")!))
                tripextraAmount = (String(describing: user.value(forKey: "additionalamount")!))


            }
        } catch {
            print("Error with request: \(error)")
        }
    }


    @IBAction func confirmbtnAction() {
        self.invoiceview.isHidden=true
        self.ratingcommentsview.isHidden=false
        self.confirmbutton.isHidden=true
        self.cuttedlineIv.isHidden=true
        self.tripdetailsdict = NSDictionary()
        self.StoreUserDetails(User_Details: self.tripdetailsdict)
        self.title="Feedback"
    }

    @IBAction func starrating1btnAction() {
        self.starratingbutton1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton2.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        rating=1
    }

    @IBAction func starrating2btnAction() {
        self.starratingbutton1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton3.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        rating=2
    }

    @IBAction func starrating3btnAction() {
        self.starratingbutton1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton4.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        self.starratingbutton5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        rating=3
    }

    @IBAction func starrating4btnAction() {
        self.starratingbutton1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton5.setBackgroundImage(UIImage(named: "blank_stare"), for: UIControl.State.normal)
        rating=4
    }

    @IBAction func starrating5btnAction() {
        self.starratingbutton1.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton2.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton3.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton4.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        self.starratingbutton5.setBackgroundImage(UIImage(named: "fill_star"), for: UIControl.State.normal)
        rating=5
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 100
    }

    func setprofilepict() {
        if(profilepicktureurl.count>0) {
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.center = self.driverratingIv.center
            view.addSubview(indicator)
            indicator.startAnimating()

            let profilePictureURL = URL(string: profilepicktureurl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: profilePictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                }
                else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            DispatchQueue.main.async {
                                    indicator.stopAnimating()
                                    let image = UIImage(data: imageData)
                                    self.driverratingIv.image=image
                                    
                            }
                        } else {
                            indicator.stopAnimating()
                            self.alert(message: "Couldn't get image: Image is nil")
                        }
                    } else {
                        indicator.stopAnimating()
                        self.alert(message: "Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        } else {
            self.driverratingIv.image=UIImage(named: "Profile_placeholder")
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
    // MARK: - Review submit
    //--------------------------------------

    @IBAction func submitbuttonAction() {
        var errmsg=String()
        if(rating==0) {
            errmsg="Rate the driver to proceed."
        } else if(self.commentsTv.text.count==0) {
            errmsg="Comments cannot be left empty."
        }
        if(errmsg.count>0) {
            self.alert(message: errmsg)
        } else {
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
                activityView.startAnimating()
                print("Connected")
                var paramDict = Dictionary<String, Any>()
                paramDict["id"]=currentuserid
                paramDict["token"]=currentusertoken
                paramDict["request_id"]=self.appdel.requestid
                paramDict["rating"]=rating
                paramDict["comment"]=self.commentsTv.text

                print(paramDict)
                let url = helperObject.BASEURL + helperObject.ratingreview
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
                                self.tripdetailsdict = NSDictionary()
                                self.StoreUserDetails1(User_Details: self.tripdetailsdict)
                                self.deletedriver()
                                self.deletetrip()
                                self.deletetripbill()
                                self.deleteinvoiceviewed()
                                self.appdel.isdriverstarted="0"
                                self.appdel.isdriverarrived="0"
                                self.appdel.istripstarted="0"
                                self.appdel.iscompleted="0"
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Trip Completed"), object: nil)
                                let center  = UNUserNotificationCenter.current()
                                UIApplication.shared.applicationIconBadgeNumber = 0
                                center.removeAllDeliveredNotifications()
                                self.navigationController?.popToRootViewController(animated: true)


//                                self.window1 = UIWindow(frame: UIScreen.main.bounds)
//                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//                                self.window1?.rootViewController = mainViewController
//                                self.window1?.makeKeyAndVisible()
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                self.view.showToast("Something went wrong.")
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

    //--------------------------------------
    // MARK: - Getting context
    //--------------------------------------

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    //--------------------------------------
    // MARK: - Saving trip context
    //--------------------------------------

    func StoreUserDetails (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let invoiceviewstatus = Invoiceviewed(context: getContext())
        invoiceviewstatus.invoiceviewed="Yes"
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    func StoreUserDetails1 (User_Details: NSDictionary) {
        let context = getContext()
        print("userDictionary is: ",User_Details)

        let triprating = Triprated(context: getContext())
        triprating.triprated="Yes"
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {

        }
    }

    //--------------------------------------
    // MARK: - Fetching trip context
    //--------------------------------------

    func getinvoiceviewstatus() {
        let fetchRequest: NSFetchRequest<Invoiceviewed> = Invoiceviewed.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
                //get the Key Value pairs (although there may be a better way to do that...
                invoiceviewstatus = (String(describing: user.value(forKey: "invoiceviewed")!))
            }
        } catch {
            print("Error with request: \(error)")
        }

    }

    func getdriverdetails() {
        let fetchRequest: NSFetchRequest<Driverdetails> = Driverdetails.fetchRequest()
        do {
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
                tripresumedriverprofilepicture = (String(describing: user.value(forKey: "driverprofilepict")!))
            }
        } catch {
            print("Error with request: \(error)")
        }

    }

    func gettripdetails() {
        let fetchRequest: NSFetchRequest<Tripdetails> = Tripdetails.fetchRequest()
        do {
            //go get the results
            let array_users = try getContext().fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of users = \(array_users.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_users as [NSManagedObject] {
                print("\(String(describing: user))")
                //get the Key Value pairs (although there may be a better way to do that...
                triprequestid = (String(describing: user.value(forKey: "tripid")!))
            }
        } catch {
            print("Error with request: \(error)")
        }

    }

    //--------------------------------------
    // MARK: - Deleteing trip context
    //--------------------------------------


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
                print("ERROR DELETING : \(error)")
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
                print("ERROR DELETING : \(error)")
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
                print("ERROR DELETING : \(error)")
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
                print("ERROR DELETING : \(error)")
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
