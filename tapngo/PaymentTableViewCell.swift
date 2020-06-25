//
//  paymentTableViewCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 08/02/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    var paymentypeLbl = UILabel()
    var paymenttypeIv = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        paymentypeLbl.font = UIFont.appFont(ofSize: 17)
        paymentypeLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(paymentypeLbl)
        paymenttypeIv.contentMode = .scaleAspectFit
        paymenttypeIv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(paymenttypeIv)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[paymenttypeIv(30)]-(20)-[paymentypeLbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: ["paymentypeLbl":paymentypeLbl,"paymenttypeIv":paymenttypeIv]))
        paymenttypeIv.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        paymenttypeIv.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }


}
