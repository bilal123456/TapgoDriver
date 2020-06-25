//
//  UIKit Extensions.swift
//  TapNGo Driver
//
//  Created by Admin on 27/03/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

extension UIView {    
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.themeColor, thickness: CGFloat = 1, leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) -> Void {
        func border() -> UIView {
            let border = UIView()
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["top": top]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",options: [],metrics: nil,views: ["top": top]))
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["left": left]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",options: [],metrics: nil,views: ["left": left]))
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["right": right]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",options: [],metrics: nil,views: ["right": right]))
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["bottom": bottom]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[bottom]-(rightPadding)-|",options: [],metrics: ["leftPadding": leftPadding,"rightPadding":rightPadding],views: ["bottom": bottom]))
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addLoader(_ color: UIColor = .black)->CALayer {
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let blackLayer = CALayer()
        blackLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        blackLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(blackLayer)
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.5 //* 10
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        blackLayer.add(animation, forKey: "position")
        
        let anim = CABasicAnimation(keyPath: "bounds")
        anim.duration = 0.25 //* 10
        anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 10, height: 3))
        anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 150, height: 3))
        blackLayer.add(anim, forKey: "bounds")
        return blackLayer
    }
}
extension UIColor {
    class var themeColor: UIColor {
        return UIColor(red: 225.0/255.0, green: 124.0/255.0, blue: 0.0/255.0, alpha: 1.0)
//
    }
    static let secondaryColor = UIColor.black//(red: 255.0/255.0, green: 124.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let colorPrimary = UIColor(red: 0/255.0, green: 162.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let colorPrimaryDark = UIColor(red: 0/255.0, green: 131.0/255.0, blue: 197.0/255.0, alpha: 1.0)
}
@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
extension UIImage {
    static func ==(lhs: UIImage, rhs: UIImage)->Bool {
        if let lhsData = lhs.pngData(), let rhsData = rhs.pngData() {
            return lhsData == rhsData
        }
        return false
    }
}

extension String {
    var isBlank:Bool {
        get {
            return trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    var isValidEmail:Bool {
        get {
            return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}").evaluate(with:self)
        }
    }
    var isValidPhoneNumber:Bool {
        get {
            return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{6,14}$").evaluate(with:self)
        }
    }
}

extension UIFont {
    class func appTitleFont(ofSize:CGFloat)->UIFont {
        return UIFont(name: APIHelper.appTilteFontName, size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
    class func appBoldTitleFont(ofSize:CGFloat)->UIFont {
        return UIFont(name: APIHelper.appTilteBoldFontName, size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
    class func appFont(ofSize:CGFloat)->UIFont {
        return UIFont(name: APIHelper.appFontName, size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
    class func appBoldFont(ofSize:CGFloat)->UIFont {
        return UIFont(name: APIHelper.appBoldFontName, size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
}

extension UIViewController {
    func showAlert(_ title : String , message: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont.appBoldTitleFont(ofSize: 18)]
        let messageFont = [NSAttributedString.Key.font: UIFont.appFont(ofSize: 15)]
        let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        let ok = UIAlertAction(title: "OK".localize(), style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.appFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        toastLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastLabel.superview!.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastLabel.superview!.bottomAnchor, constant: -200).isActive = true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
extension UINavigationItem {
    var backBtnString: String {
        get { return "" }
        set { self.backBarButtonItem = UIBarButtonItem(title: newValue, style: .plain, target: nil, action: nil) }
    }
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
//Haversine function to get bearing between 2 locations
extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radiansBearing)
    }
}
public class AnimatedPolyLine: GMSPolyline {
    var animationPolyline = GMSPolyline()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    private var repeats:Bool!
    override init() {
        super.init()
    }
    deinit {
        print("de init called")
    }
    convenience init(_ points: String,repeats:Bool) {
        self.init()
        self.repeats = repeats
        self.path = GMSPath.init(fromEncodedPath: points)!
        self.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.strokeWidth = 3.0
        //        self.mapView = map
        //        self.polyline.map = self.mapView
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        let count = self.path!.count()
        print(count)
        //        let localTimeIntervalCal = (count < 280) ? Double(Double(300 - count)/10000): 0.002
        let interval = count < 200 ? 0.001 : 0.000001
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
    }
    @objc func animatePolylinePath(_ sender:Timer) {
        print(Date())        
        if (self.i < (self.path?.count())!) {
            self.animationPath.add((self.path?.coordinate(at: self.i))!)
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.map
            self.i += 1
        } else {
            if self.repeats {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
            else {
                sender.invalidate()
                if self.timer != nil
                {
                    self.timer = nil
                }
            }
        }

    }
}
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
