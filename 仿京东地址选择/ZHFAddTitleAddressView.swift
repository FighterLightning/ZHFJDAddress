//
//  ZHFAddTitleAddressView.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/8.
//  Copyright © 2017年 张海峰. All rights reserved.
//

/*
 这个视图你需要修改的地方为：
 func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger)
 该方法里的代码，已写清楚
 一个是模拟数据。
 二是网络请求数据。
 （因本人网络请求是局域网，所以网络请求的思路已在方法里写明，三个url，
 三个字典，修改成自己的即可使用。）
 */

import UIKit
import Chrysan
import YYModel
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
protocol ZHFAddTitleAddressViewDelegate {
    func cancelBtnClick( titleAddress: String,titleID: String)
}
class ZHFAddTitleAddressView: UIView {
  var delegate: ZHFAddTitleAddressViewDelegate?
  var userID :NSInteger = 0
  var defaultHeight: CGFloat = 200
  var title: String = "所在地区"
  var isclick: Bool = false  //判断是滚动还是点击
  var addAddressView: UIView =  UIView()
    lazy var provinceMarr:NSMutableArray = NSMutableArray() //省
    lazy var cityMarr:NSMutableArray = NSMutableArray() //市
    lazy var countyMarr:NSMutableArray = NSMutableArray() //县
    var titleScrollView :UIScrollView = UIScrollView()
    var contentScrollView :UIScrollView = UIScrollView()
    var radioBtn :UIButton = UIButton()
    var lineLabel :UILabel = UILabel()
    let titleScrollViewH :CGFloat = 37
    var titleMarr : NSMutableArray = NSMutableArray()
    lazy  var titleIDMarr : NSMutableArray = NSMutableArray()
    var tableViewMarr : NSMutableArray = NSMutableArray()
    lazy var titleBtns : NSMutableArray = NSMutableArray()
    //初始化这个地址视图
    func initAddressView() -> UIView {
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnAndcancelBtnClick))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        //设置添加地址的View
        addAddressView.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: defaultHeight)
        addAddressView.backgroundColor = UIColor.white
        self.addSubview(addAddressView)
        let titleLabel: UILabel = UILabel.init(frame: CGRect.init(x: 40, y: 10, width: ScreenWidth - 80, height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        addAddressView.addSubview(titleLabel)
        let cancelBtn:UIButton = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x:addAddressView.frame.maxX - 40, y: 10, width: 30, height: 30)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: UIControlEvents.touchUpInside)
        addAddressView.addSubview(cancelBtn)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        self.isHidden = false
        UIView.animate(withDuration:0.2, animations: {
             self.addAddressView.frame.origin.y = ScreenHeight - self.defaultHeight
        }, completion: nil)
    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        UIView.animate(withDuration:0.2, animations: {
            self.addAddressView.frame.origin.y = ScreenHeight
        }) { (_) in
            self.isHidden = true
            var titleAddress :String = ""
            var titleID :String = ""
            var count: NSInteger = 0
            let str = self.titleMarr[self.titleMarr.count - 1] as! String
            if (str == "请选择") {
                count = self.titleMarr.count - 1
            }
            else{
                count = self.titleMarr.count
            }
            for i in 0 ..< count{
                titleAddress =  "\(titleAddress) \(self.titleMarr[i])"
                if i == count - 1 {
                    titleID = "\(titleID)\(self.titleIDMarr[i])"
                }
                else{
                    titleID = "\(titleID)\(self.titleIDMarr[i])="
                }
            }
             self.delegate?.cancelBtnClick(titleAddress: titleAddress, titleID: titleID)
        }
    }
}
extension ZHFAddTitleAddressView :UIScrollViewDelegate{
    func setupTitleScrollView(){
       //TitleScrollView和分割线
        titleScrollView.frame = CGRect.init(x: 0, y: 50, width: ScreenWidth, height: titleScrollViewH)
        addAddressView.addSubview(titleScrollView)
        let lineView : UIView = UIView.init(frame: CGRect.init(x: 0, y: titleScrollView.frame.maxY, width: ScreenWidth, height: 0.5))
        lineView.backgroundColor = UIColor.gray
        addAddressView.addSubview(lineView)
        
    }
    func setupContentScrollView(){
        //ContentScrollView
        let y : CGFloat = titleScrollView.frame.maxY + 1
        contentScrollView.frame = CGRect.init(x: 0, y: y, width: ScreenWidth, height: defaultHeight - y)
        addAddressView.addSubview(contentScrollView)
        contentScrollView.delegate = self;
        contentScrollView.isPagingEnabled = true;
        contentScrollView.bounces = false;
    }
    //设置所有title
    func setupAllTitle( selectId: NSInteger ) {
        for view in titleScrollView.subviews {
            view.removeFromSuperview()
        }
         self.titleBtns.removeAllObjects()
        let btnH :CGFloat = self.titleScrollViewH
        lineLabel.backgroundColor = UIColor.red
        titleScrollView.addSubview(lineLabel)
        var x : CGFloat = 10
        for i in 0 ..< self.titleMarr.count {
            let title : String = (titleMarr[i] as? String)!
            let titlelenth : CGFloat = CGFloat(title.count * 15)
            let titleBtn :UIButton = UIButton.init(type:UIButtonType.custom)
            titleBtn.setTitle(title, for: UIControlState.normal)
            titleBtn.tag = i
            titleBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            titleBtn.setTitleColor(UIColor.red, for: UIControlState.selected)
           titleBtn.isSelected = false
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            titleBtn.frame = CGRect.init(x: x, y: 0, width: titlelenth, height: btnH)
             x  = (titlelenth + 10) + x
            titleBtn.addTarget(self, action: #selector(titleBtnClick), for: UIControlEvents.touchUpInside)
            self.titleBtns.add(titleBtn)
            if i == selectId {
                titleBtnClick(titleBtn: titleBtn)
            }
            titleScrollView.addSubview(titleBtn)
            titleScrollView.contentSize = CGSize.init(width: x, height: 0)
            titleScrollView.showsHorizontalScrollIndicator = false;
            contentScrollView.contentSize = CGSize.init(width: CGFloat(self.titleMarr.count) * ScreenWidth, height: 0)
            contentScrollView.showsHorizontalScrollIndicator = false;
        }
    }
    @objc func titleBtnClick(titleBtn: UIButton)  {
        radioBtn.isSelected = false
        titleBtn.isSelected = true
        setupOneTableView(btnTag :titleBtn.tag)
        let x :CGFloat  = CGFloat(titleBtn.tag) * ScreenWidth;
        self.contentScrollView.contentOffset = CGPoint.init(x: x, y: 0);
        lineLabel.frame = CGRect.init(x: titleBtn.frame.minX, y: titleScrollViewH - 3, width: titleBtn.frame.size.width, height: 3)
        radioBtn = titleBtn;
        isclick = true
    }
    func setupOneTableView(btnTag: NSInteger){
        let contentView : UITableView = self.tableViewMarr[btnTag] as! UITableView
        if btnTag == 0 {
          self.getAddressMessageData(addressID: 1, provinceIdOrCityId: 0)
        }
        if (contentView.superview != nil) {
            return
        }
        let x : CGFloat = CGFloat(btnTag) * ScreenWidth
        contentView.frame = CGRect.init(x: x, y: 0, width: ScreenWidth, height: contentScrollView.bounds.size.height)
        contentView.delegate = self
        contentView.dataSource = self
        self.contentScrollView.addSubview(contentView)
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leftI :NSInteger  = NSInteger(scrollView.contentOffset.x / ScreenWidth);
        if CGFloat(scrollView.contentOffset.x / ScreenWidth) != CGFloat(leftI){
            isclick = false
        }
        if isclick == false {
            if CGFloat(scrollView.contentOffset.x / ScreenWidth) == CGFloat(leftI)  {
                let titleBtn :UIButton  = titleBtns[leftI] as! UIButton
                titleBtnClick(titleBtn: titleBtn)
            }
        }
    }
}
// tableView代理处理
extension ZHFAddTitleAddressView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.provinceMarr.count
        }
        else if tableView.tag == 1 {
            return self.cityMarr.count
        }
        else if tableView.tag == 2{
            return self.countyMarr.count
        }
        else{
           return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let AddressAdministerCellIdentifier  = "AddressAdministerCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: AddressAdministerCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: AddressAdministerCellIdentifier)
        }
        if tableView.tag == 0 {
            let provinceModel: ProvinceModel = self.provinceMarr[indexPath.row] as! ProvinceModel
            cell?.textLabel?.text = "\(provinceModel.province_name!)"
        }
        else if tableView.tag == 1 {
           let cityModel: CityModel = self.cityMarr[indexPath.row] as! CityModel
           cell?.textLabel?.text = "\(cityModel.city_name!)"
        }
        else if tableView.tag == 2{
            let countyModel: CountyModel = self.countyMarr[indexPath.row] as! CountyModel
            cell?.textLabel?.text = "\(countyModel.county_name!)"
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = UIColor.gray
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 || tableView.tag == 1 {
            if tableView.tag == 0{
                let provinceModel: ProvinceModel = self.provinceMarr[indexPath.row] as! ProvinceModel
                //1. 修改选中ID
                if self.titleIDMarr.count > 0{
                    self.titleIDMarr.replaceObject(at: tableView.tag, with: provinceModel.id)
                }
                else{
                    self.titleIDMarr.add(provinceModel.id)
                }
                //2.修改标题
                self.titleMarr.replaceObject(at: tableView.tag, with: provinceModel.province_name!)
                //请求网络 添加市区
                self.getAddressMessageData(addressID: 2 ,provinceIdOrCityId: provinceModel.id)
                
            }
            else if tableView.tag == 1 {
                let cityModel: CityModel = self.cityMarr[indexPath.row] as! CityModel
                self.titleMarr.replaceObject(at: tableView.tag, with: cityModel.city_name!)
                //1. 修改选中ID
                if self.titleIDMarr.count > 1{
                    self.titleIDMarr.replaceObject(at: tableView.tag, with: cityModel.id)
                }
                else{
                    self.titleIDMarr.add(cityModel.id)
                }
                //网络请求，添加县城
                self.getAddressMessageData(addressID: 3 ,provinceIdOrCityId: cityModel.id)
            }
        }
        else if tableView.tag == 2 {
            let countyModel: CountyModel = self.countyMarr[indexPath.row] as! CountyModel
            titleMarr.replaceObject(at: tableView.tag, with: countyModel.county_name!)
            //1. 修改选中ID
            if self.titleIDMarr.count > 2{
                self.titleIDMarr.replaceObject(at: tableView.tag, with: countyModel.id)
            }
            else{
                self.titleIDMarr.add(countyModel.id)
            }
            setupAllTitle(selectId: tableView.tag)
            self.tapBtnAndcancelBtnClick()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
//防止手势冲突
extension ZHFAddTitleAddressView:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" || touch.view == addAddressView || touch.view == titleScrollView {
            return false
        }
        return true
    }
}

//网络请求*****你只需要修改这个方法里的内容就可使用
extension ZHFAddTitleAddressView {
    //本地添加（所有的省都对应的有市，市对应的有县）
    func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger){
        switch addressID {
        case 1:
            self.provinceMarr.removeAllObjects()
            for i in 0 ..< 64{
                let dic1 : [String : Any] = [ "id":"\(i)",
                        "province_name" : "第\(i)省" ]
                let provinceModel:ProvinceModel  =
                    ProvinceModel.yy_model(with: dic1)!
                self.provinceMarr.add(provinceModel)
            }
        case 2:
            self.cityMarr.removeAllObjects()
            for i in 0 ..< 30{
                let dic1 : [String : Any] = [ "id":"\(i)",
                    "city_name" : "第\(i)市" ]
                let cityModel:CityModel  =
                    CityModel.yy_model(with: dic1)!
                self.cityMarr.add(cityModel)
            }
            if self.tableViewMarr.count >= 2{
                self.titleMarr.replaceObject(at: 1, with: "请选择")
                if self.tableViewMarr.count > 2{
                    self.titleMarr.removeLastObject()
                    self.tableViewMarr.removeLastObject()
                }
            }
            else{
                let tableView2: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableViewStyle.plain)
                tableView2.separatorStyle = UITableViewCellSeparatorStyle.none
                tableView2.tag = 1
                self.tableViewMarr.add(tableView2)
                self.titleMarr.add("请选择")
            }
            self.setupAllTitle(selectId: 1)
        case 3:
            self.countyMarr.removeAllObjects()
            for i in 0 ..< 5{
                let dic1 : [String : Any] = [ "id":"\(i)",
                    "county_name" : "\(i)县" ]
                let countyModel:CountyModel  =
                    CountyModel.yy_model(with: dic1)!
                self.countyMarr.add(countyModel)
            }
            if self.tableViewMarr.count > 2{
                self.titleMarr.replaceObject(at: 2, with: "请选择")
            }
            else{
                let tableView2: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableViewStyle.plain)
                tableView2.separatorStyle = UITableViewCellSeparatorStyle.none
                tableView2.tag = 2
                self.tableViewMarr.add(tableView2)
                self.titleMarr.add("请选择")
            }
            self.setupAllTitle(selectId: 2)
            
        default:
            break;
        }
        if self.tableViewMarr.count >= addressID{
            let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
            tableView1.reloadData()
        }
    }
    // 以下是网络请求方法
//    func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger) {
//        var addressUrl =  String()
//        var parameters : NSDictionary =  NSDictionary()
//        switch addressID {
//        case 1:
//            //获取省份的URL
//            addressUrl = "getProvinceAddressUrl"
//            //请求省份需要传递的参数
//            parameters = ["user_id" : userID]
//        case 2:
//            //获取市区的URL
//            addressUrl = "getCityAddressUrl"
//            //请求市区需要传递的参数
//            parameters = ["province_id" : "5",
//            "user_id" : userID]
//        case 3:
//            //获取县的URL
//            addressUrl = "getCountyAddressUrl"
//            //请求县需要传递的参数
//            parameters = ["city_id" : "4",
//                          "user_id" : userID]
//        default:
//            break;
//        }
//        //第三方加载工具
//        self.addAddressView.chrysan.show()
//        //网络请求
//        NetworkTools.shareInstance.request(methodType: .POST, urlString:addressUrl, parameters: parameters as! [String : AnyObject]) { (result, error) in
//            self.addAddressView.chrysan.hide()
//            if result != nil
//            {
//                let dic = result as! NSDictionary
//                let code : NSInteger = dic["code"] as! NSInteger
//                if code == 200{
//                    switch addressID {
//                    case 1:
//                        //拿到省列表
//                       let  provinceArr: NSArray = dic["data"] as! NSArray
//                       self.case1(provinceArr: provinceArr)
//                    case 2:
//                        //拿到市列表
//                        let  cityArr: NSArray = dic["data"] as! NSArray
//                        self.case2(cityArr: cityArr)
//
//                    case 3:
//                        //拿到县列表
//                        let  countyArr: NSArray = dic["data"] as! NSArray
//                        self.case3(countyArr: countyArr)
//                    default:
//                        break;
//                    }
//                    if self.tableViewMarr.count >= addressID{
//                        let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
//                        tableView1.reloadData()
//                    }
//                }
//                else{
//                   self.addAddressView.chrysan.showMessage(dic["msg"] as! String, hideDelay: 2.0)
//                }
//            }
//            else{
//                self.addAddressView.chrysan.showMessage(error as! String, hideDelay: 2.0)
//            }
//        }
//    }
}
/*下面这个主要是逻辑分析和数据处理
 只需要找到 ProvinceModel类，把其属性修改成你需要的即可
 以下方法：对没有下一级的情况，进行了逻辑判断（建议不要随意更改。）
 */
extension ZHFAddTitleAddressView{
    func case1(provinceArr: NSArray ) {
        if provinceArr.count > 0{
            self.provinceMarr.removeAllObjects()
            for i in 0 ..< provinceArr.count{
                let dic1 : [String : Any] = provinceArr[i] as! [String : Any]
                let provinceModel:ProvinceModel  =
                    ProvinceModel.yy_model(with: dic1)!
                self.provinceMarr.add(provinceModel)
            }
        }
        else{
            self.tapBtnAndcancelBtnClick()
        }
    }
    func case2(cityArr: NSArray ) {
        if cityArr.count > 0{
            self.cityMarr.removeAllObjects()
            for i in 0 ..< cityArr.count{
                let dic1 : [String : Any] = cityArr[i] as! [String : Any]
                let cityModel:CityModel  =
                    CityModel.yy_model(with: dic1)!
                self.cityMarr.add(cityModel)
            }
            if self.tableViewMarr.count >= 2{
                self.titleMarr.replaceObject(at: 1, with: "请选择")
                if self.tableViewMarr.count > 2{
                    self.titleMarr.removeLastObject()
                    self.tableViewMarr.removeLastObject()
                }
            }
            else{
                let tableView2: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableViewStyle.plain)
                tableView2.separatorStyle = UITableViewCellSeparatorStyle.none
                tableView2.tag = 1
                self.tableViewMarr.add(tableView2)
                self.titleMarr.add("请选择")
            }
            self.setupAllTitle(selectId: 1)
        }
        else{
            //没有对应的市
            if self.tableViewMarr.count > 2{
                self.titleMarr.removeLastObject()
                self.tableViewMarr.removeLastObject()
            }
            if self.tableViewMarr.count == 2{
                self.titleMarr.removeLastObject()
                self.tableViewMarr.removeLastObject()
            }
            self.setupAllTitle(selectId: 0)
            self.tapBtnAndcancelBtnClick()
        }
    }
    func case3(countyArr: NSArray ) {
        if countyArr.count > 0{
            self.countyMarr.removeAllObjects()
            for i in 0 ..< countyArr.count{
                let dic1 : [String : Any] = countyArr[i] as! [String : Any]
                let countyModel:CountyModel  =
                    CountyModel.yy_model(with: dic1)!
                self.countyMarr.add(countyModel)
            }
            if self.tableViewMarr.count > 2{
                self.titleMarr.replaceObject(at: 2, with: "请选择")
            }
            else{
                let tableView2: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: UITableViewStyle.plain)
                tableView2.separatorStyle = UITableViewCellSeparatorStyle.none
                tableView2.tag = 2
                self.tableViewMarr.add(tableView2)
                self.titleMarr.add("请选择")
            }
            self.setupAllTitle(selectId: 2)
        }
        else{
            //没有对应的县
            if self.tableViewMarr.count > 2{
                self.titleMarr.removeLastObject()
                self.tableViewMarr.removeLastObject()
            }
            self.setupAllTitle(selectId: 1)
            self.tapBtnAndcancelBtnClick()
        }
    }
}

