//
//  paymentvcCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 06/11/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit

class paymentvcCell: UITableViewCell {

    var layoutDic = [String:AnyObject]()
    @IBOutlet weak var cardImv: UIImageView!
    @IBOutlet weak var cardnumbeLbl: UILabel!
    @IBOutlet weak var cardSelectionBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//
        cardImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardImv"] = cardImv
        cardnumbeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardnumbeLbl"] = cardnumbeLbl
        cardSelectionBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardSelectionBtn"] = cardSelectionBtn
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["deleteBtn"] = deleteBtn
        deleteBtn.imageView?.contentMode = .scaleAspectFit
        deleteBtn.setImage(UIImage(named: "deletecardicon"), for: .normal)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cardImv(25)]-(15)-[cardnumbeLbl]-(5)-[cardSelectionBtn(18)]-(7)-[deleteBtn(40)]-(5)-|", options: [APIHelper.appLanguageDirection,.alignAllCenterY], metrics: nil, views: layoutDic))
        cardImv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        cardnumbeLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cardSelectionBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[deleteBtn(40)]|", options: [], metrics: nil, views: layoutDic))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "", options: [], metrics: nil, views: layoutDic))
    }

}
