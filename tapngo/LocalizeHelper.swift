//
//  LanguageTableViewCell.swift
//  TaxiAppz
//
//  Created by Mohammed Arshad on 26/08/17.
//  Copyright © 2017 nPlus. All rights reserved.
//

import Foundation

class LocalizeHelper: NSObject {
    private lazy var __once:() = {() -> Void in
            singleLocalSystem = LocalizeHelper()
        }()
    class func sharedLocalSystem() -> LocalizeHelper {
        let singleLocalSystem: AnyObject? = nil
       // var onceToken: Int = 0
        return singleLocalSystem! as! LocalizeHelper
    }

    func localizedStringForKey(_ key: String) -> String {
        if myBundle == nil {
            myBundle = Bundle.main
        }
        return myBundle!.localizedString(forKey: key, value: "", table: nil)
    }
    
    func localizedStringForDynamicText(_ key: String,name: String,name1: String) -> String {
        if myBundle == nil {
            myBundle = Bundle.main
        }
        var text: String?
        if name1 == "" {
             text = String(format: NSLocalizedString(key, tableName: nil, bundle: myBundle!, value: "", comment: ""),name)
        } else {
            text = String(format: NSLocalizedString(key, tableName: nil, bundle: myBundle!, value: "", comment: ""),name,name1)
        }
     return text!
    }

    func setNewLanguage(_ selectedLanguage : String) {
        let path: String = Bundle.main.path(forResource: selectedLanguage as String, ofType: "lproj")!
        myBundle = Bundle(path:path)
            if myBundle == nil {
                myBundle = Bundle.main
        }
    }

    func changeLanguage(_ newLanguage : String) {
    }
    
    func LocalizationSetLanguage(_ lang : NSString) {
        setNewLanguage(lang as String)
    }
}

    var singleLocalSystem: LocalizeHelper? = nil
    var myBundle: Bundle? = nil
