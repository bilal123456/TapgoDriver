//
//  soslistTableViewCell.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit

class SOSListTableViewCell: UITableViewCell {

//    var layoutDic = [String:AnyObject]()
//    @IBOutlet weak var sosnameLbl: UILabel!
////    @IBOutlet weak var soscallImv: UIImageView!
//    @IBOutlet weak var sosnumberLbl: UILabel!
//
//    @IBOutlet weak var soscallBtn: UIButton!
//    @IBOutlet weak var shadowView: UIView!
//    @IBOutlet weak var titleBgView: UIView!
//    @IBOutlet weak var numBgView: UIView!

    var shadowView = UIView()
    var titleBgView = UIView()
    var sosnameLbl = UILabel()
    var numBgView = UIView()
    var sosnumberLbl = UILabel()
    var soscallBtn = UIButton()
    var layoutDic = [String:AnyObject]()

    
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
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }


    func setUpViews() {

        sosnameLbl.font = UIFont.appFont(ofSize: sosnameLbl.font!.pointSize)
        sosnumberLbl.font = UIFont.appFont(ofSize: sosnumberLbl.font!.pointSize)


        shadowView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["shadowView"] = shadowView
        self.addSubview(shadowView)

        titleBgView.backgroundColor = .lightGray
        shadowView.addSubview(titleBgView)
        sosnameLbl.textColor = .white
        titleBgView.addSubview(sosnameLbl)
        numBgView.backgroundColor = .white
        shadowView.addSubview(numBgView)
        numBgView.addSubview(sosnumberLbl)
        soscallBtn.imageView?.contentMode = .scaleAspectFit
        soscallBtn.contentHorizontalAlignment = .fill
        soscallBtn.contentVerticalAlignment = .fill
        soscallBtn.imageView?.tintColor = UIColor.themeColor
        soscallBtn.setImage(UIImage(named:"callsosimage")?.withRenderingMode(.alwaysTemplate), for: .normal)
       // soscallBtn.setImage(UIImage(named: "callsosimage"), for: .normal)
        numBgView.addSubview(soscallBtn)
        titleBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["titleBgView"] = titleBgView
        sosnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sosnameLbl"] = sosnameLbl
        numBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["numBgView"] = numBgView
        sosnumberLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sosnumberLbl"] = sosnumberLbl
        soscallBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["soscallBtn"] = soscallBtn

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[shadowView]-(20)-|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[shadowView]-(20)-|", options: [], metrics: nil, views: layoutDic))
        shadowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleBgView]|", options: [], metrics: nil, views: layoutDic))
        shadowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleBgView(30)][numBgView(50)]|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        titleBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[sosnameLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        titleBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sosnameLbl]|", options: [], metrics: nil, views: layoutDic))
        numBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[sosnumberLbl]-(10)-[soscallBtn(30)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        numBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[sosnumberLbl(30)]-(10)-|", options: [], metrics: nil, views: layoutDic))

        sosnameLbl.textAlignment = APIHelper.appTextAlignment
        sosnumberLbl.textAlignment = APIHelper.appTextAlignment
    }



}
