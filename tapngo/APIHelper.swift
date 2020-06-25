//
//  APIHelper.swift
//  tapngo
//
//  Created by Spextrum on 29/11/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import Alamofire
import IQKeyboardManagerSwift
import Localize

class APIHelper: NSObject {
//    let colorPrimary : UIColor = UIColor(red: 0/255, green: 162/255, blue: 255/255, alpha: 1)
//    let colorPrimaryDark : UIColor = UIColor(red: 0/255, green: 131/255, blue: 197/255, alpha: 1)

    static let appTilteFontName = "Laksaman"
    static let appTilteBoldFontName = "Laksaman"
    static let appFontName = "Padauk-Regular"
    static let appBoldFontName = "Padauk-Bold"

    static var appLanguageDirection: NSLayoutConstraint.FormatOptions {
        get { return currentAppLanguage == "ar" ? .directionRightToLeft : .directionLeftToRight }
    }
    static var appTextAlignment: NSTextAlignment {
        get { return currentAppLanguage == "ar" ? .right : .left }
    }
    static var appSemanticContentAttribute: UISemanticContentAttribute {
        get { return currentAppLanguage == "ar" ? .forceRightToLeft : .forceLeftToRight }
    }
    static var currentAppLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "currentLanguage") ?? "en"
        }
        set {
            Localize.shared.update(language: newValue)
            Localize.update(language: newValue)
            UserDefaults.standard.set(newValue, forKey: "currentLanguage")
            UserDefaults.standard.synchronize()
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localize()            
        }
    }

    var activityView: NVActivityIndicatorView!
    var defaultcardid=""
    // Application Base URL

//    let BASEURL = "http://192.168.1.18/tapngo/public/v1/"
//    static let socketUrl = URL(string: "http://192.168.1.18:3002")!

    let BASEURL = "http://35.176.117.118/tapngo/public/v1/"
    static let socketUrl = URL(string: "http://35.176.117.118:3001")!

    let autocomplete_URl="https://maps.googleapis.com/maps/api/place/autocomplete/json?"

    // Other URL Suffixes
    let Header = ["Accept": "application/json"]
    
    let LoginURL                                = "user/login"
    let SendOTPURL                              = "user/sendotp"
    let ResendOTPURL                            = "user/resendotp"
    let ValidateOTPURL                          = "user/otpvalidate"
    let RegisterURL                             = "user/signup"
    let GetRequestURL                           = "user/getrequest"
    let GiveRatingURL                           = "user/rating"
    let ApplicationPagesURL                     = "application/pages"
    let DriverUpdateProfileURL                  = "user/update"
    let GetVehicleTypeURL                       = "application/types"
    let DriverHistoryURL                        = "user/history"
    let ForgetPasswordURL                       = "user/forgotpassword"
    let CreateRideNowRequestURL                 = "user/createrequest"
    let LogoutURL                               = "user/logout"
    let TokenGeneraterURL                       = "user/temptoken"
    let GetReferralCodeURL                      = "user/getreferral"
    let SocialLoginUniqueIDVerificationURL      = "user/social_unique_id_check"
    let AddMoneyToWalletURL                     = "user/addwallet"
    let Getcardlist                             = "user/cardlist"
    let Makecarddefault                         = "user/carddefault"
    let Getnoncetoken                           = "application/client_token"
    let addpaymentcard                          = "user/addcard"
    let getwalletAmount                         = "user/getwallet"
    let deletepaymentcard                       = "user/deletecard"
    let applyreferral                           = "user/referralcheck"
    let addfavourite                            = "user/addfav"
    let getfavouritelist                        = "user/listfav"
    let deletefav                               = "user/deletefav"
    let getcomplaintlist                        = "compliants/list"
    let savecomplaint                           = "compliants/user"
    let getreqinprogress                        = "user/requestInprogress"
    let updateprofile                           = "user/profile"
    let geteta                                  = "application/eta"
    let createrequest                           = "user/createrequest"
    let canceltrip                              = "user/request/cancel"
    let applypromo                              = "user/promocode/check"
    let getsoslist                              = "user/zonesos"
    let getsosUserlist                          = "user/sos"

    let ratingreview                            = "user/review"

    let gethistorydata                          = "user/historyList"
    let gethistorydetails                       = "user/historySingle"
    let cancelschedule                          = "user/ridelatercancel"
    let scheduleride                            = "user/ridelater"
    let cancelReasonList                        = "cancellation/list"
    let privacyPolicy                 = "privacy_policy"

    // ***** Reusable Functions *****

    func CheckTextFieldEmpty(Textfield: UITextField! ,Message: String,DesiredView : UIViewController!) {
        if(Textfield.text == "") {
            let alertController = UIAlertController(title: "Alert", message: Message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            DesiredView.present(alertController, animated: true, completion: nil)
        }
    }

//    func drawbottomborder(tfd: UITextField) {
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = self.colorPrimary.cgColor
//        border.frame = CGRect(x: 0, y: tfd.frame.size.height - width, width:  tfd.frame.size.width, height: width)
//
//        border.borderWidth = width
//        tfd.borderStyle = UITextBorderStyle.none
//        tfd.layer.addSublayer(border)
//        tfd.layer.masksToBounds = true
//    }


}
enum TripStatus:Int
{
    case driverstarted = 1
    case driverarrived = 2
    case tripstarted = 3
    case completed = 4
}
