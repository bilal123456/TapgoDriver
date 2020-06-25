
//  Settingsvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 08/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import NVActivityIndicatorView
import Localize

class Settingsvc: UIViewController {

    var window1: UIWindow?
    let helperObject = APIHelper()
    var userTokenstr: String=""
    var userId: String=""

    let headerlbl = UILabel()
    let languageBtn = UIButton(type: .custom)
//    @IBOutlet weak var languagelbl: UILabel!
//    @IBOutlet weak var languageIv: UIImageView!


    let languagePopUpView = PopUpTableView()
    var layoutDic = [String:AnyObject]()
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var currentLayoutDirection = APIHelper.appLanguageDirection//TO REDRAW VIEWS IF DIRECTION IS CHANGED



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            self.languagePopUpView.optionsListTblView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.getUser()
        self.setUpViews()
    }

    func customformat() {
    }

    func setUpViews() {



        if #available(iOS 11.0, *) {
            self.top = self.view.safeAreaLayoutGuide.topAnchor
            self.bottom = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            self.top = self.topLayoutGuide.bottomAnchor
            self.bottom = self.bottomLayoutGuide.topAnchor
        }

        headerlbl.text = "General".localize()
        headerlbl.font = UIFont.appTitleFont(ofSize: 20)
        headerlbl.textColor = .black
        headerlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerlbl"] = headerlbl
        headerlbl.textAlignment = APIHelper.appTextAlignment
        headerlbl.removeFromSuperview()
        self.view.addSubview(headerlbl)


        languageBtn.translatesAutoresizingMaskIntoConstraints = false
        languageBtn.addTarget(self, action: #selector(languagebtnAction), for: .touchUpInside)
        layoutDic["languageBtn"] = languageBtn
        languageBtn.setImage(UIImage(named: "language"), for: .normal)
        languageBtn.contentHorizontalAlignment = .right
        languageBtn.semanticContentAttribute = .forceRightToLeft
        languageBtn.setTitle("Language / en".localize(), for: .normal)
        languageBtn.setTitleColor(.black,for: .normal)
        languageBtn.titleLabel?.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        languageBtn.titleLabel?.font = UIFont.appFont(ofSize: 16)
        languageBtn.removeFromSuperview()
        self.view.addSubview(languageBtn)




        headerlbl.topAnchor.constraint(equalTo: self.top, constant: 35).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerlbl(30)]-(35)-[languageBtn(30)]", options: [], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[headerlbl(150)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(25)-[languageBtn]-(25)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        let btnWidth = languageBtn.bounds.width
        let titleWidth = languageBtn.titleLabel!.bounds.width
        let imgWidth = languageBtn.imageView!.bounds.width
        languageBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: btnWidth-(titleWidth+imgWidth))
        languagePopUpView.optionsList = Localize.shared.availableLanguages.map({
            let locale = NSLocale(localeIdentifier: $0)
            if let name = locale.displayName(forKey: NSLocale.Key.identifier, value: $0) {
                return (text: name,identifier:$0)
            } else {
                return (text:Localize.shared.displayNameForLanguage($0),identifier:$0)
            }
        })
        languagePopUpView.selectedOption = languagePopUpView.optionsList?.first(where: { $1 == APIHelper.currentAppLanguage })
        languagePopUpView.tableTitle = "Select Language".localize().uppercased(with: Locale(identifier: APIHelper.currentAppLanguage))
        languagePopUpView.translatesAutoresizingMaskIntoConstraints = false
        languagePopUpView.delegate = self
        layoutDic["languagePopUpView"] = languagePopUpView
        languagePopUpView.removeFromSuperview()
        self.navigationController?.view.addSubview(languagePopUpView)
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[languagePopUpView]|", options: [], metrics: nil, views: layoutDic))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[languagePopUpView]|", options: [], metrics: nil, views: layoutDic))

        self.title = "Settings".localize().uppercased(with: Locale(identifier: APIHelper.currentAppLanguage))
//        languageTitleBtn.contentHorizontalAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .left : .right
//        languageTitleBtn.setTitleColor(.black, for: .normal)
    }




    //------------------------------------------
    // MARK: - Back button navigation
    //------------------------------------------

    @IBAction func backAction() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
//        self.performSegue(withIdentifier: "seguefromsettingstohome", sender: self)
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
    // MARK: - Table view Delegates
    //--------------------------------------
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.languagearray.count
//    }
//
//    // create a cell for each table view row
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "languagecell", for: indexPath) as! settingsTableViewCell
//        cell.langlbl.text=self.languagearray[indexPath.row] as? String
//        cell.langlbl.font = UIFont.appFont(ofSize: 18)
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        self.languagelbl.text=self.languagearray[indexPath.row] as? String
//        self.selectlanguageview.isHidden=true
//    }

    @IBAction func languagebtnAction() {
//        let vc = SearchLocationTVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        self.languagePopUpView.isHidden = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Settingsvc:PopUpTableViewDelegate {
    func popUpTableView(_ popUpTableView: PopUpTableView, didSelectOption option: Option, atIndex index: Int) {
        APIHelper.currentAppLanguage = option.identifier
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).textAlignment = APIHelper.appTextAlignment
        self.languageBtn.setTitle("Language / ".localize() + option.identifier , for: .normal)
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        let btnWidth = languageBtn.bounds.width
        let titleWidth = languageBtn.titleLabel!.bounds.width
        let imgWidth = languageBtn.imageView!.bounds.width
        languageBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: btnWidth-(titleWidth+imgWidth))
        if currentLayoutDirection != APIHelper.appLanguageDirection {
            self.setUpViews()
            currentLayoutDirection = APIHelper.appLanguageDirection
        }
    }
}
