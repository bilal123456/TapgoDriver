//
//  initialviewModel.swift
//  tapngo
//
//  Created by Mohammed Arshad on 03/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class initialViewModel {
    var user1=user()
    var emailadd = ""
    var password = ""
    let appdel=UIApplication.shared.delegate as!AppDelegate
    var JSON=NSDictionary()

    func validate() {
        var errmsg = ""

        if (user1.emailaddr.isEmpty || user1.password.isEmpty) {
            errmsg="Username and password are required"
        } else if (user1.emailaddr.count<3) {
            errmsg="Username needs to be atleast 3 characters long"
        } else if (user1.password.count<3) {
            errmsg="Password needs to be atleast 3 characters long"
        }
        if errmsg.count>0 {
            appdel.validatestatus="invalid"
            appdel.errmsg=errmsg
        } else {
            appdel.validatestatus="valid"
        }
    }
}

extension initialViewModel {
    func updateusername(emailaddr: String) {
        user1.emailaddr=emailaddr
    }

    func updatepassword(passwor: String) {
        user1.password=passwor
    }
}
