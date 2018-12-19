//
//  ViewController.swift
//  仿京东地址选择
//
//  Created by 张海峰 on 2017/12/12.
//  Copyright © 2017年 张海峰. All rights reserved.
//
//这是一个自定义仿京东地址选择器。Swift版本，（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
//OC版本地址：https://github.com/FighterLightning/ZHFJDAddressOC.git
/*该demo的使用须知:
 1.下载该demo。把ProvinceModel.swift（必须），ZHFAddTitleAddressView.swift(必须) 拖进项目
 2.pod 'Chrysan', :git => 'https://github.com/Harley-xk/Chrysan.git' //第三方加载框（根据需求进行添加）
 pod 'Alamofire'//网络请求
 pod 'ObjectMapper' //字典转模型
 3.把以下代码添加进自己的控制器方可使用，网络请求看ZHFAddTitleAddressView.swift头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
  该demo地址：https://github.com/FighterLightning/ZHFJDAddress.git
  简书地址：https://www.jianshu.com/p/0269071219af
 */
import UIKit
class ViewController: UIViewController,ZHFAddTitleAddressViewDelegate {
    @IBOutlet weak var addressBtn: UIButton!
     lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    //如果是网络请求修改地址，在需要修改的地址的titleIDMarr赋值后设置这一块UI
    func setUI()  {
        //这是用户的ID
        addTitleAddressView.title = "选择地址"
        addTitleAddressView.userID = 7
        addTitleAddressView.delegate = self
        addTitleAddressView.defaultHeight = 350
        if addTitleAddressView.titleIDMarr.count > 0 {
            addTitleAddressView.isChangeAddress = true
        }
        else{
            addTitleAddressView.isChangeAddress = false
        }
        self.view.addSubview(addTitleAddressView.initAddressView())
        
    }
    @IBAction func addressBtnClick(_ sender: UIButton) {
         addTitleAddressView.addAnimate()
    }
    func cancelBtnClick(titleAddress: String, titleID: String) {
        addressBtn.setTitle(titleAddress, for: UIControlState.normal)
        print("打印的对应省市县的id\(titleID)")
        }
}


