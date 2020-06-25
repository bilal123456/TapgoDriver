//
//  cancellistTableViewCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 01/02/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit

class CancelListTableViewCell: UITableViewCell {


    var cancelReasonLbl = UILabel()
    var cancelReasonSelectView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         setUpViews()
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    func setUpViews() {
        cancelReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        cancelReasonLbl.font = UIFont.appFont(ofSize: 15)
        addSubview(cancelReasonLbl)

        cancelReasonSelectView.translatesAutoresizingMaskIntoConstraints = false
        cancelReasonSelectView.layer.borderWidth = 0.5
        cancelReasonSelectView.layer.cornerRadius = 15
        addSubview(cancelReasonSelectView)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cancelReasonLbl]-(10)-[cancelReasonSelectView(30)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: ["cancelReasonLbl": cancelReasonLbl,"cancelReasonSelectView": cancelReasonSelectView]))
        cancelReasonLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

}
