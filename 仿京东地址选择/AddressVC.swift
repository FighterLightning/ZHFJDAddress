//
//  AddressVC.swift
//  仿京东地址选择
//
//  Created by 张海峰 on 2018/12/21.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class AddressVC: UIViewController,ZHFAddTitleAddressViewDelegate {
     lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()
    var isEdit: Bool = false //判断是否是编辑地址
    var addressBtn: UIButton!
    override func viewWillDisappear(_ animated: Bool) {
        // 因为是通过 UIApplication.shared.keyWindow?.addSubview添加的，记得移除一下
        addTitleAddressView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addressBtn = UIButton.init(type: .custom)
        addressBtn.frame = CGRect.init(x: 0, y: 200, width: ScreenWidth, height: 40)
        addressBtn.backgroundColor = UIColor.lightGray
        addressBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(addressBtn)
        if isEdit == true { //编辑状态
            self.title = "编辑地址"
            //编辑地址要是需要直接跳到当前地址位置,需要传对应titleIDMarr = [省ID，市ID，县ID，乡ID]
            addTitleAddressView.titleIDMarr = [44,4405,440513,440513100]
            addressBtn.setTitle("广东省 汕头市 潮阳区 海门镇",for: .normal)
            //编辑地址是地址UI一定要在赋值地址ID之后
            setUI()
        }
        else{
            self.title = "新增地址"
            addressBtn.setTitle("请选择地址", for: .normal)
            setUI()
        }
    }
    func setUI()  {
        addTitleAddressView.title = "选择地址"
        addTitleAddressView.delegate = self
        addTitleAddressView.defaultHeight = 350
        if addTitleAddressView.titleIDMarr.count > 0 {
            addTitleAddressView.isChangeAddress = true
        }
        else{
            addTitleAddressView.isChangeAddress = false
        }
        UIApplication.shared.keyWindow?.addSubview(addTitleAddressView.initAddressView())
    }
    @objc func btnClick(){
        addTitleAddressView.addAnimate()
    }
    func cancelBtnClick(titleAddress: String, titleID: String) {
        if titleID == "" {
            addressBtn.setTitle("请选择选择", for:  .normal)
        }
        else{
            addressBtn.setTitle(titleAddress, for: .normal)
            print("打印的对应省市县的id\(titleID)")
        }
    }
}
