//
//  AddressCell.swift
//  仿京东地址选择
//
//  Created by 张海峰 on 2018/6/14.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    var titleLabel: UILabel = UILabel()
    var selectImage: UIImageView = UIImageView()
    var titleString: String = ""{
        didSet{
            titleLabel.text = titleString
            let sizeNew : CGSize =  titleString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: titleLabel.font])
            // 重新设置frame
            titleLabel.frame = CGRect.init(x: 20, y: 0, width: sizeNew.width, height: self.frame.size.height)
            selectImage.frame = CGRect.init(x: titleLabel.frame.maxX + 5, y: (self.frame.size.height - 20)/2, width: 15, height: 15)
        }
    }
    var isChangeRed: Bool = false{
        didSet{
            if isChangeRed == true{
                titleLabel.textColor = UIColor.red
                selectImage.isHidden = false
            }
            else{
                titleLabel.textColor = UIColor.gray
                selectImage.isHidden = true
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //  创建UI方法
        creatUI()
    }
    //  这个方法也是必须要实现的，和重写初始化方法在一起实现。
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 创建UI的方法 title和 对号。
    func creatUI()
    {
        titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 30, height: 40))
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.gray
        self.addSubview(titleLabel)
        selectImage = UIImageView.init()
        selectImage.image  = UIImage.init(named: "right")
        selectImage.isHidden = true
        self.addSubview(selectImage)
    }
}
