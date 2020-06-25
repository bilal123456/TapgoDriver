//
//  searchlistTableViewCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 22/12/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {


    var layoutDic = [String:AnyObject]()
    var placenameLbl = UILabel()
    var placeImv = UIImageView()
    var placeaddLbl = UILabel()
    var favDeleteBtn = UIButton()
    var favDeleteBtnAction:(()->Void)?


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews() {
        selectionStyle = .none
        placenameLbl.font = UIFont.appFont(ofSize: 17)
        placeaddLbl.font = UIFont.appFont(ofSize: 12)
        placenameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placenameLbl"] = placenameLbl
        addSubview(placenameLbl)
        placeImv.contentMode = .scaleAspectFit
        placeImv.image = UIImage(named: "favicon")
        placeImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placeImv"] = placeImv
        addSubview(placeImv)
        placeaddLbl.translatesAutoresizingMaskIntoConstraints = false
        placeaddLbl.numberOfLines = 0
        placeaddLbl.lineBreakMode = .byWordWrapping
        layoutDic["placeaddLbl"] = placeaddLbl
        addSubview(placeaddLbl)
        favDeleteBtn.imageView?.contentMode = .scaleAspectFit
        favDeleteBtn.setImage(UIImage(named: "deletecardicon"), for: .normal)
        favDeleteBtn.adjustsImageWhenHighlighted = false
        favDeleteBtn.addTarget(self, action: #selector(favDeleteBtnTapped(_:)), for: .touchUpInside)
        favDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favDeleteBtn"] = favDeleteBtn
        addSubview(favDeleteBtn)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[placeImv(12)]-(15)-[placenameLbl]-(10)-[favDeleteBtn(17)]-(20)-|", options: [], metrics: nil, views: layoutDic))
        placeImv.heightAnchor.constraint(equalToConstant: 12).isActive = true
        placeImv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[placenameLbl(21)]-(3)-[placeaddLbl(>=15)]-(5)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        favDeleteBtn.heightAnchor.constraint(equalToConstant: 17).isActive = true
        favDeleteBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    @objc func favDeleteBtnTapped(_ sender: UIButton) {
        if let action = favDeleteBtnAction {
            action()
        }
    }
    
}
