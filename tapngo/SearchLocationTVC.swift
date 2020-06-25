//
//  ViewController.swift
//  UISearchController
//
//  Created by Anupam Chugh on 25/05/17.
//  Copyright © 2017 JournalDev.com. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GooglePlaces
import NVActivityIndicatorView
import GoogleMaps

class SearchLocationTVC: UITableViewController{

    var currentuserid: String!
    var currentusertoken: String!

    var layoutDic: [String:AnyObject] = [:]
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>!
    var favouriteLocationList: [SearchLocation] = []
    var searchLocationList: [SearchLocation] = []
    var currentLocationType:LocationType = .favourite
    var selectedLocation:((SearchLocation) -> Void)?


    //    var models = [Model]()
    //    var filteredModels = [Model]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.searchController.navigationController?.navigationBar.shadowImage = nil
        self.searchController.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.searchController.navigationController?.navigationBar.isTranslucent = false

        self.getFavouriteListApi()

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black


        tableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        searchController.isActive = true
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .themeColor
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true

        tableView.tableHeaderView = searchController.searchBar


    }
    func deleteFavourite(_ favourite: SearchLocation) {
        if ConnectionCheck.isConnectedToNetwork() {
            self.searchController.searchBar.resignFirstResponder()
            print("Connected")
            var paramDict = Dictionary<String, Any>()
            paramDict["id"] = currentuserid
            paramDict["token"] = currentusertoken
            paramDict["favid"] = favourite.id
            print(paramDict)
            let url = APIHelper().BASEURL + APIHelper().deletefav
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in

                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Response for Login",JSON)
                        print(JSON.value(forKey: "success") as! Bool)
                        let theSuccess = (JSON.value(forKey: "success") as! Bool)
                        if(theSuccess == true) {
//                            self.getFavouriteListApi()
                            self.view.showToast(JSON.value(forKey: "success_message") as! String)
                            self.favouriteLocationList.remove(at: self.favouriteLocationList.index(where: { $0 == favourite })!)
                            self.tableView.reloadData()
                        } else {
                            self.view.showToast("Something went wrong. Favourite not Deleted.")
                        }
                    } else {
                        self.view.showToast("Something went wrong.")
                    }
            }
        }
    }
    func getFavouriteListApi() {

        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: NVActivityIndicatorType.ballClipRotate, color: UIColor.themeColor), nil)
            var paramDict = Dictionary<String, Any>()
            paramDict["id"] = currentuserid
            paramDict["token"] = currentusertoken
            print(paramDict)
            let url = APIHelper().BASEURL + APIHelper().getfavouritelist
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                .responseJSON { response in
                    print(response.response as Any) // URL response
                    print(response.result.value as AnyObject)
                    if let result = response.result.value {
                        //                        FavouriteLocation
                        if let JSON = result as? [String:AnyObject] {
                            if let status = JSON["success"] as? Bool, status {
                                if let favPlaces = JSON["favplace"] as? [[String:AnyObject]]
                                {
                                    self.favouriteLocationList = favPlaces.map({ SearchLocation($0) })
                                    self.tableView.reloadData()
                                }
                            } else {
                                self.view.showToast("Some thing went wrong.")
//                                /
                            }
                        }
                    }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        }

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLocationType == .favourite ? favouriteLocationList.count : searchLocationList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as! SearchListTableViewCell

        if currentLocationType == .favourite {
            cell.placenameLbl.text = favouriteLocationList[indexPath.row].nickName
            cell.placeaddLbl.text = favouriteLocationList[indexPath.row].placeId
            cell.favDeleteBtn.isHidden = false
            cell.favDeleteBtnAction = {
                self.deleteFavourite(self.favouriteLocationList[indexPath.row])
            }
        } else {
            cell.placenameLbl.text = searchLocationList[indexPath.row].nickName
            cell.placeaddLbl.text = searchLocationList[indexPath.row].placeId
            cell.favDeleteBtn.isHidden = true
            cell.favDeleteBtnAction = nil
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation?(currentLocationType == .favourite ? favouriteLocationList[indexPath.row] : searchLocationList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }



}

extension SearchLocationTVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar, textDidChange: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.currentLocationType = .favourite
            self.tableView.reloadData()
            return
        } else {
            if ConnectionCheck.isConnectedToNetwork() {
                self.currentLocationType = .googleSearch
                guard let location = AppLocationManager.shared.locationManager.location?.coordinate else {
                    return
                }
               // let placesClient = GMSPlacesClient()
//                let filter = GMSAutocompleteFilter()
//                filter.type = .establishment
//                filter.country = Locale.current.regionCode
//                placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error) in
//                    guard error == nil else {
//                        self.currentLocationType = .favourite
//                        return
//                    }
//                    if let searchResults = results
//                    {
//                        self.searchLocationList = searchResults.map({ SearchLocation($0.placeID!, title: $0.attributedPrimaryText.string, address: $0.attributedFullText.string) })
//                    }
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
 //               }
                var paramDict = Dictionary<String, Any>()
                paramDict["input"] = searchText
                paramDict["key"] = "AIzaSyDiEj97FycvkydgDaVzYHVDcEZjnLSfP4k"
                paramDict["location"] = "\(location.latitude),\(location.longitude)"
                paramDict["radius"] = "500"
                paramDict["sensor"] = "false"
                print(paramDict)
                let url = APIHelper().autocomplete_URl
                print(url)
                Alamofire.request(url, method: .get, parameters: paramDict, headers: ["Accept": "application/json", "Content-Language": "en"])
                    .responseJSON { response in
                        if let result = response.result.value as? [String:AnyObject] {
                            if let status = result["status"] as? String, status == "OK" {
                                if let predictions = result["predictions"] as? [[String:AnyObject]] {
                                    self.searchLocationList = predictions.compactMap({
                                        if let googlePlaceId = $0["place_id"] as? String,
                                            let address = $0["description"] as? String,
                                            let structuredFormat = $0["structured_formatting"] as? [String:AnyObject],
                                            let title = structuredFormat["main_text"] as? String {
                                            return SearchLocation(googlePlaceId,title:title,address: address)
                                        }
                                        return nil
                                    })
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            } else if let status = result["status"] as? String {
                                self.currentLocationType = .googleSearch
                                self.searchLocationList = []
                                self.tableView.reloadData()
                                print(status)
                            }
                        }
                }
            }
        }
    }

}


//Common Model for Favourite & Google Search Location
struct SearchLocation:Equatable {
    static func == (lhs: SearchLocation, rhs: SearchLocation) -> Bool {
        return lhs.id == rhs.id && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.nickName == rhs.nickName && lhs.placeId == rhs.placeId && lhs.googlePlaceId == rhs.googlePlaceId
    }
    var coordinate:CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    var id: Int!
    var latitude:Double!
    var longitude:Double!
    var nickName: String!
    var placeId: String!
    var googlePlaceId: String!
    var locationType:LocationType!

    init(_ dict: [String:AnyObject]) {
        self.id = dict["id"] as? Int
        if let latitude = dict["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dict["longitude"] as? Double {
            self.longitude = longitude
        }
        self.nickName = dict["nickName"] as? String
        self.placeId = dict["placeId"] as? String
        self.locationType = .favourite
    }

    init(_ googlePlaceId: String,title: String,address: String) {
        self.googlePlaceId = googlePlaceId
        self.nickName = title
        self.placeId = address
        self.locationType = .googleSearch
    }
    init(_ target:CLLocationCoordinate2D) {
        self.latitude = target.latitude
        self.longitude = target.longitude
        self.locationType = .reverseGeoCode
    }
}
enum LocationType {
    case favourite
    case googleSearch
    case reverseGeoCode
}
