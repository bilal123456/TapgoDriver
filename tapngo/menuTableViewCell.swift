//
//  menuTableViewCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 05/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {
    var layoutDic = [String:AnyObject]()
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var gradientlineimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        lblname.font = UIFont.appFont(ofSize: lblname.font!.pointSize)

        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["img"] = img
        lblname.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblname"] = lblname
        lblname.textAlignment = APIHelper.appTextAlignment

        gradientlineimg.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gradientlineimg"] = gradientlineimg

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[img(25)]-(9)-[gradientlineimg(1)]|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[gradientlineimg(220)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[img(25)]-(10)-[lblname(190)]", options: [APIHelper.appLanguageDirection,.alignAllBottom,.alignAllTop], metrics: nil, views: layoutDic))
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "", options: [], metrics: nil, views: layoutDic))

    }

}
