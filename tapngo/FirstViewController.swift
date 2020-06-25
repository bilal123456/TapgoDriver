//
//  firstvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 10/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBOutlet weak var bgIv: UIImageView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    var layoutDic: [String: AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    let helperObject = APIHelper()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.title = "TapNGo"
        self.navigationItem.backBtnString = ""

        if ConnectionCheck.isConnectedToNetwork() {
            print("Yes Connected")
        } else {
            print("Not Connected")
        }
        UserDefaults.standard.set("LocalizableSpanish", forKey: "TranslationDocumentName")
        LocalizeHelper().LocalizationSetLanguage("es")
        self.signinBtn.setTitle("Login".localize(), for: .normal)
        self .setUpViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func setUpViews() {
        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }
        bgIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bgIv"] = bgIv
        signinBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["signinBtn"] = signinBtn
        signupBtn.translatesAutoresizingMaskIntoConstraints=false
        layoutDic["signupBtn"] = signupBtn
//        bgIv.topAnchor.constraint(equalTo: self.top).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgIv]|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bgIv]-(0)-|", options: [], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[signinBtn]-(20)-[signupBtn(==signinBtn)]-(20)-|", options: [.directionLeftToRight,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[signinBtn(45)]", options: [], metrics: nil, views: layoutDic))
        signinBtn.bottomAnchor.constraint(equalTo: self.bottom, constant: -20).isActive = true

        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()

        self.signinBtn.backgroundColor = .themeColor
        self.signinBtn.setTitleColor(.secondaryColor, for: .normal)
        self.signinBtn.titleLabel?.font = UIFont.appFont(ofSize: 16)
        self.signinBtn.layer.cornerRadius = self.signinBtn.bounds.height/2

        self.signupBtn.backgroundColor = .themeColor
        self.signupBtn.setTitleColor(.secondaryColor, for: .normal)
        self.signupBtn.titleLabel?.font = UIFont.appFont(ofSize: 16)
        self.signupBtn.layer.cornerRadius = self.signupBtn.bounds.height/2

        bgIv.backgroundColor = .white
        bgIv.contentMode = .scaleAspectFit
        bgIv.image = UIImage(named: "Splash")
    }
    
    @IBAction func signinBtntapped() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Loginvc") as? LoginViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func signupBtntapped() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Initialvc") as? Initialvc
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
