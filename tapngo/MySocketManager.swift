//
//  AppSocketManager.swift
//  TapNGo Driver
//
//  Created by Admin on 13/04/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

@objc protocol MySocketManagerDelegate {

    @objc optional func typesResponseReceived(_ response:[String:AnyObject])
    @objc optional func getCarsResponseReceived(_ response:[String:AnyObject])
    @objc optional func tripStatusResponseReceived(_ response:[String:AnyObject])
    @objc optional func cancelledRequestResponseReceived(_ response:[String:AnyObject])
    @objc optional func requestHandlerResponseReceived(_ response:[String:AnyObject])
}

class MySocketManager: NSObject {

    weak var socketDelegate:MySocketManagerDelegate?

    let lbl = UITextView(frame: CGRect(x: UIScreen.main.bounds.width/4, y: 20, width: UIScreen.main.bounds.width/2, height: 120))
    static let shared = MySocketManager()
    let socket = SocketIOClient(socketURL: APIHelper.socketUrl,
                                config: SocketIOClientConfiguration(arrayLiteral: .reconnects(true),.reconnectAttempts(-1),.nsp("/home")))

    private override init() {
        super.init()
        self.updateStatus()
    }
    func updateStatus() {
        socket.on(clientEvent: .statusChange) { (dataArr, _) in
            guard let status = dataArr.first as? SocketIOClientStatus else {
                return
            }
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            if !window.subviews.contains(self.lbl) {
                window.addSubview(self.lbl)
            }
            self.lbl.isHidden = true
            self.lbl.textAlignment = .center
            self.lbl.isUserInteractionEnabled = true
            self.lbl.backgroundColor = .red
            self.lbl.textColor = .black
            switch status {
            case .connected: self.lbl.text = "socket connected"
            case .notConnected: self.lbl.text = "socket notConnected";self.socket.reconnect()
            case .connecting: self.lbl.text = "socket connecting"
            case .disconnected: self.lbl.text = "socket disconnected"
            }
        }
    }

//    func establishConnection() {
//
//        socket.on("connect") { [unowned self] data, _ in
//            print("socket connected")
//           // self.addObservers()
//            guard let id = APIHelper.shared.userDetails?.id else {
//                return
//            }
//            let jsonObject = ["id":id]
//
//            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) {
//                if let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {
//                    print("json string = \(jsonStr)")
//                    self.socket.emit("start_connect", jsonStr)
//
//                    guard let currentLoc = AppLocationManager.shared.locationManager.location else {
//                        return
//                    }
//                    MySocketManager.shared.emitTypes(currentLoc.coordinate.latitude, long: currentLoc.coordinate.longitude)
//                }
//            }
//        }
//        socket.connect()
//    }
//    func emitTypes(_ lat:Double, long:Double) {
//        let jsonObject = ["lat":lat,"lng":long,"id":APIHelper.shared.userDetails?.id] as [String:Any]
//        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) {
//            if let jsonString = String(data: jsonData as Data, encoding: String.Encoding.utf8) {
//                print("json string = \(jsonString)")
//                socket.emit("types", jsonString)
//            }
//        }
//    }
//    func addObservers() {
//        socket.on("types") { data, _ in
//            guard let response = data.first as? [String:AnyObject] else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.socketDelegate?.typesResponseReceived?(response)
//            }
//        }
//        socket.on("get_cars") { data, _ in
//            guard let response = data.first as? [String:AnyObject] else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.socketDelegate?.getCarsResponseReceived?(response)
//            }
//        }
//        socket.on("trip_status") { data, _ in
//            guard let response = data.first as? [String:AnyObject] else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.socketDelegate?.tripStatusResponseReceived?(response)
//            }
//        }
//        socket.on("cancelled_request") { data, _ in
//            guard let response = data.first as? [String:AnyObject] else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.socketDelegate?.cancelledRequestResponseReceived?(response)
//            }
//        }
//        socket.on("request_handler") { data, _ in
//            guard let response = data.first as? [String:AnyObject] else {
//                return
//            }
//            DispatchQueue.main.async {
//                self.socketDelegate?.requestHandlerResponseReceived?(response)
//            }
//        }
//    }

}
