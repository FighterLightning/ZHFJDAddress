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
 1.下载该demo。把ProvinceModel.swift（必须），ZHFAddTitleAddressView.swift(必须) NetworkTools.swift(可用自己封装的)拖进项目
 2.pod 'Chrysan', :git => 'https://github.com/Harley-xk/Chrysan.git' //第三方加载框（根据需求进行添加）
 pod 'AFNetworking'//网络请求
 pod 'YYModel' //字典转模型
 3.把以下代码添加进自己的控制器方可使用，网络请求看ZHFAddTitleAddressView.swift头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
  该demo地址：https://github.com/FighterLightning/ZHFJDAddress.git
 */
import UIKit

class ViewController: UIViewController,ZHFAddTitleAddressViewDelegate {
    @IBOutlet weak var addressBtn: UIButton!
     lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI()  {
        //这是用户的ID
        addTitleAddressView.userID = 7
        addTitleAddressView.delegate = self
        addTitleAddressView.defaultHeight = 350
        let tableView: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableViewStyle.plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tag = 0
        addTitleAddressView.tableViewMarr.add(tableView)
        addTitleAddressView.titleMarr.add("请选择")
        //1.添加标题滚动视图
        addTitleAddressView.setupTitleScrollView()
        //2.添加内容滚动视图
        addTitleAddressView.setupContentScrollView()
        addTitleAddressView.setupAllTitle(selectId: 0)
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


