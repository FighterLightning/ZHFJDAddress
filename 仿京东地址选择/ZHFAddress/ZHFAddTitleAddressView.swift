//
//  ZHFAddTitleAddressView.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/8.
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
/*
 这个视图你需要修改的地方为：
 func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger)
 该方法里的代码，已写清楚
 一个是模拟数据。
 二是网络请求数据。
 */

import UIKit
import ObjectMapper
import Chrysan
import Moya
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
@objc protocol ZHFAddTitleAddressViewDelegate {
    func cancelBtnClick( titleAddress: String,titleID: String)
}
class ZHFAddTitleAddressView: UIView {
  let AddressAdministerCellIdentifier  = "AddressAdministerCellIdentifier"
  weak var delegate: ZHFAddTitleAddressViewDelegate?
  var defaultHeight: CGFloat = 200
  var title: String = "所在地区"
  var isclick: Bool = false  //判断是滚动还是点击
  var addAddressView: UIView =  UIView()
  lazy var provinceMarr:NSMutableArray = NSMutableArray() //省
  lazy var cityMarr:NSMutableArray = NSMutableArray() //市
  lazy var countyMarr:NSMutableArray = NSMutableArray() //县
  lazy var townMarr:NSMutableArray = NSMutableArray() //乡镇
  var titleScrollView :UIScrollView = UIScrollView()
    var contentScrollView :UIScrollView = UIScrollView()
    var radioBtn :UIButton = UIButton()
    var lineLabel :UILabel = UILabel()
    let titleScrollViewH :CGFloat = 37
    var titleMarr : NSMutableArray = NSMutableArray()
    lazy  var titleIDMarr : NSMutableArray = NSMutableArray()
    var tableViewMarr : NSMutableArray = NSMutableArray()
    var resultArr: [NSDictionary] = [NSDictionary]()//本地数组
    lazy var titleBtns : NSMutableArray = NSMutableArray()
    var PCCTID: NSInteger = 0 //省市区ID
    var isChangeAddress :Bool = true //这个属性如果是新增地址的时候设置成false
    var scroolToRow = 0 //确定在更改地址的时候能滚到对应的位置请求到下一级
    //初始化这个地址视图
    func initAddressView() -> UIView {
        //初始化本地数据（如果是网络请求请注释掉-----
        let imagePath: String = Bundle.main.path(forResource: "location", ofType: "txt")!
        var string : String = String()
        do {
            let string1: String  = try String.init(contentsOfFile: imagePath, encoding: String.Encoding.utf8)
            string = string1
        }catch { }
        let  resData : Data = string.data(using: String.Encoding.utf8)!
        do {
            let resultArr1  = try JSONSerialization.jsonObject(with: resData as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            resultArr = resultArr1 as! [NSDictionary]
        }catch { }
        //------到这里
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isHidden = true
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
        let cancelBtn:UIButton = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x:addAddressView.frame.maxX - 40, y: 10, width: 30, height: 30)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        addAddressView.addSubview(cancelBtn)
        self.addTableViewAndTitle(tableViewTag: 0)
        //1.添加标题滚动视图
        setupTitleScrollView()
        //2.添加内容滚动视图
        setupContentScrollView()
        setupAllTitle(selectId: 0)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        self.isHidden = false
        UIView.animate(withDuration:0.2, animations: {
             self.addAddressView.frame.origin.y = ScreenHeight - self.defaultHeight
        }, completion: nil)
    }
    //取消按钮被点击
    @objc func cancelBtnClicked(){
        UIView.animate(withDuration:0.2, animations: {
            self.addAddressView.frame.origin.y = ScreenHeight
        }) { (_) in
            self.isHidden = true
        }
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
            let titleBtn :UIButton = UIButton.init(type:.custom)
            titleBtn.setTitle(title, for: .normal)
            titleBtn.tag = i
            titleBtn.setTitleColor(UIColor.black, for: .normal)
            titleBtn.setTitleColor(UIColor.red, for: .selected)
            titleBtn.isSelected = false
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            titleBtn.frame = CGRect.init(x: x, y: 0, width: titlelenth, height: btnH)
            x  = (titlelenth + 10) + x
            titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
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
        let x :CGFloat  = CGFloat(titleBtn.tag) * ScreenWidth
        lineLabel.frame = CGRect.init(x: titleBtn.frame.minX, y: titleScrollViewH - 3, width: titleBtn.frame.size.width, height: 3)
        UIView.animate(withDuration: 0.25) {
            self.contentScrollView.contentOffset = CGPoint.init(x: x, y: 0)
        }
       // self.contentScrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)//使用这个动画效果会出现bug
        radioBtn = titleBtn
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
        else if tableView.tag == 3{
            return self.townMarr.count
        }
        else{
           return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell :AddressCell = tableView.dequeueReusableCell(withIdentifier: AddressAdministerCellIdentifier, for: indexPath) as! AddressCell
        if cell.isEqual(nil){
            cell = AddressCell.init(style: .default, reuseIdentifier: AddressAdministerCellIdentifier)
        }
        if tableView.tag == 0 {
            let provinceModel: ProvinceModel = self.provinceMarr[indexPath.row] as! ProvinceModel
            cell.titleString = provinceModel.province_name!
            self.PCCTID = provinceModel.id
        }
        else if tableView.tag == 1 {
           let cityModel: CityModel = self.cityMarr[indexPath.row] as! CityModel
            cell.titleString = cityModel.city_name!
            self.PCCTID = cityModel.id
        }
        else if tableView.tag == 2{
            let countyModel: CountyModel = self.countyMarr[indexPath.row] as! CountyModel
            cell.titleString = countyModel.county_name!
            self.PCCTID = countyModel.id
        }
        else if tableView.tag == 3{
            let townModel: TownModel = self.townMarr[indexPath.row] as! TownModel
            cell.titleString = townModel.town_name!
            self.PCCTID = townModel.id
        }
        if titleIDMarr.count > tableView.tag{
            let  pcctId :NSInteger = titleIDMarr[tableView.tag] as! NSInteger
            if self.PCCTID == pcctId{
              cell.isChangeRed = true
                if isChangeAddress == true
                {
                    self.tableView(tableView, didSelectRowAt: NSIndexPath.init(row: indexPath.row, section: 0) as IndexPath)
                }
            }
            else{
                cell.isChangeRed = false
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChangeAddress == false {
            //先刷新当前选中的tableView
            let tableView: UITableView  = self.tableViewMarr[tableView.tag] as! UITableView
            tableView.reloadData()
        }
        if tableView.tag == 0 || tableView.tag == 1 || tableView.tag == 2 {
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
                //添加市区
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
                //添加县城
                self.getAddressMessageData(addressID: 3 ,provinceIdOrCityId: cityModel.id)
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
                //添加乡镇
                self.getAddressMessageData(addressID: 4 ,provinceIdOrCityId: countyModel.id)
            }
        }
        else if tableView.tag == 3 {
            let townModel: TownModel = self.townMarr[indexPath.row] as! TownModel
            titleMarr.replaceObject(at: tableView.tag, with: townModel.town_name!)
            //1. 修改选中ID
            if self.titleIDMarr.count > 3{
                self.titleIDMarr.replaceObject(at: tableView.tag, with: townModel.id)
            }
            else{
                self.titleIDMarr.add(townModel.id)
            }
            setupAllTitle(selectId: tableView.tag)
            if isChangeAddress == false{
                self.tapBtnAndcancelBtnClick()
            }
            else{
                isChangeAddress = false
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    //添加tableView和title
    func addTableViewAndTitle(tableViewTag: NSInteger){
        let tableView2:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 200), style: .plain)
        tableView2.separatorStyle = .none
        tableView2.tag = tableViewTag
        tableView2.register(AddressCell.self, forCellReuseIdentifier: AddressAdministerCellIdentifier)
        self.tableViewMarr.add(tableView2)
        self.titleMarr.add("请选择")
    }
    //改变title
    func changeTitle(replaceTitleMarrIndex:NSInteger){
        self.titleMarr.replaceObject(at: replaceTitleMarrIndex, with: "请选择")
        let index :NSInteger = self.titleMarr.index(of: "请选择")
        let count:NSInteger = self.titleMarr.count
        let loc: NSInteger = index + 1
        let range:NSInteger = count - index
        self.titleMarr.removeObjects(in: NSRange.init(location: loc, length: range - 1))
        self.tableViewMarr.removeObjects(in: NSRange.init(location: loc, length: range - 1))
    }
    //移除多余的title和tableView,收回选择器
    func removeTitleAndTableViewCancel(index:NSInteger){
        let indexsubOne:NSInteger = index - 1
        if (self.tableViewMarr.count >= index){
            self.titleMarr.removeObjects(in: NSRange.init(location: index, length: self.titleMarr.count - index))
            self.tableViewMarr.removeObjects(in: NSRange.init(location: index, length: self.tableViewMarr.count - index))
        }
        self.setupAllTitle(selectId: indexsubOne)
        if isChangeAddress == false{
            self.tapBtnAndcancelBtnClick()
        }
        else{
            isChangeAddress = false
        }
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
//本地添加（所有的省对应的有市，市对应的有县）有些只有一级，有的两级，有的三级，已做过没有下一级回收判断
extension ZHFAddTitleAddressView {
    func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger){
        switch addressID {
        case 1:
            self.case1()
        case 2:
            self.case2(selectedID: provinceIdOrCityId)
        case 3:
            self.case3(selectedID: provinceIdOrCityId)
        case 4:
            self.case4(selectedID: provinceIdOrCityId)
        default:
            break;
        }
        if self.tableViewMarr.count >= addressID{
            let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
            tableView1.reloadData()
            tableView1.layoutIfNeeded()
            if self.isChangeAddress == true{
                //保证列表刷新之后才进行滚动处理
                DispatchQueue.main.async {
                 if tableView1.numberOfRows(inSection: 0) >= self.scroolToRow{
                    tableView1.scrollToRow(at: NSIndexPath.init(row: self.scroolToRow, section: 0) as IndexPath, at: .bottom, animated: false)
                   }
                }
            }
        }
    }
    func case1() {
        self.provinceMarr.removeAllObjects()
          var j = -1 //设置这个的主要原因是因为 resultArr 是包含省市区的数组
        if resultArr.count > 0 {
            for i in 0 ..< resultArr.count{
                let dic : NSDictionary = resultArr[i]
                if (dic["parentid"] as! String == "0"){
                    j = j + 1
                    let dic1: [String : Any] = [
                        //记得把字符串类型转换成Int类型，否则用ObjectMapper转模型是id会出错
                        "id":(dic["id"] as! NSString).intValue,
                        "province_name":dic["name"]!
                    ];
                    let provinceModel:ProvinceModel  =
                        ProvinceModel(JSON: dic1)!
                    if self.titleIDMarr.count > 0{
                        let provinceID = self.titleIDMarr[0] as! NSInteger
                        if provinceModel.id == provinceID{
                            self.scroolToRow = j
                        }
                    }
                    self.provinceMarr.add(provinceModel)
                }
            }
        }
        else{
            if isChangeAddress == false{
                self.tapBtnAndcancelBtnClick()
            }
            else{
                isChangeAddress = false
            }
        }
    }
    func case2(selectedID: NSInteger) {
        self.cityMarr.removeAllObjects()
         var j = -1 //设置这个的主要原因是因为 resultArr 是包含省市区的数组
        for i in 0 ..< resultArr.count{
            let dic : NSDictionary = resultArr[i]
             if (dic["parentid"] as! String == "\(selectedID)") {
                j = j + 1
                let dic1: [String : Any] = [
                    //记得把字符串类型转换成Int类型，否则用ObjectMapper转模型是id会出错
                    "id":(dic["id"] as! NSString).intValue,
                    "city_name":dic["name"]!];
                let cityModel:CityModel  =
                    CityModel(JSON: dic1)!
                if self.titleIDMarr.count > 1{
                    let cityID = self.titleIDMarr[1] as! NSInteger
                    if cityModel.id == cityID{
                        self.scroolToRow = j
                    }
                }
                self.cityMarr.add(cityModel)
            }
        }
        if (self.cityMarr.count > 0) {
           changeRefreshTitle(titleTag: 1)
        }
        else{
            //没有对应的市
            self.removeTitleAndTableViewCancel(index: 1)
        }
    }
    func case3(selectedID: NSInteger) {
        self.countyMarr.removeAllObjects()
        var j = -1 //设置这个的主要原因是因为 resultArr 是包含省市区的数组
        for i in 0 ..< resultArr.count{
            let dic : NSDictionary = resultArr[i]
            if (dic["parentid"] as! String == "\(selectedID)") {
                j = j + 1
                let dic1: [String : Any] = [
                    //记得把字符串类型转换成Int类型，否则用ObjectMapper转模型是id会出错
                    "id":(dic["id"] as! NSString).intValue,
                    "county_name":dic["name"]!];
                let countyModel:CountyModel  =
                     CountyModel(JSON: dic1)!
                if self.titleIDMarr.count > 2{
                    let countyID = self.titleIDMarr[2] as! NSInteger
                    if countyModel.id == countyID{
                        self.scroolToRow = j
                    }
                }
                self.countyMarr.add(countyModel)
            }
        }
        if (self.countyMarr.count > 0) {
           changeRefreshTitle(titleTag: 2)
        }
        else{
            //没有对应的县
            self.removeTitleAndTableViewCancel(index: 2)
        }
    }
    func case4(selectedID: NSInteger) {
        self.townMarr.removeAllObjects()
        var j = -1 // 设置这个的主要原因是因为 resultArr 是包含省市区的数组
        for i in 0 ..< resultArr.count{
            let dic : NSDictionary = resultArr[i]
            if (dic["parentid"] as! String == "\(selectedID)") {
                j = j + 1
                let dic1: [String : Any] = [
                    //记得把字符串类型转换成Int类型，否则用ObjectMapper转模型是id会出错
                    "id":(dic["id"] as! NSString).intValue,
                    "town_name":dic["name"]!];
                let townModel:TownModel  =
                     TownModel(JSON: dic1)!
                if self.titleIDMarr.count > 3{
                    let townID = self.titleIDMarr[3] as! NSInteger
                    if townModel.id == townID{
                        self.scroolToRow = j
                    }
                }
                self.townMarr.add(townModel)
            }
        }
        if (self.townMarr.count > 0) {
            changeRefreshTitle(titleTag: 3)
        }
        else{//没有对应的乡镇
            self.removeTitleAndTableViewCancel(index: 3)
          }
    }
    func changeRefreshTitle(titleTag: NSInteger){
        if (self.tableViewMarr.count >= titleTag + 1){
            self.changeTitle(replaceTitleMarrIndex: titleTag)
        }
        else{
            self.addTableViewAndTitle(tableViewTag: titleTag)
        }
        self.setupAllTitle(selectId: titleTag)
    }
}
//网络请求*****你只需要修改这个方法里的内容就可使用
// 以下是网络请求方法
//extension ZHFAddTitleAddressView{
//        func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger) {
//            var addressUrl =  String()
//            var parameters : [String : Any] =  [String : Any]()
//            switch addressID {
//            case 1:
//                //获取省份的URL
//                addressUrl = "getProvinceAddressUrl"
//                //请求省份需要传递的参数
//                parameters = ["user_id" : userID]
//            case 2:
//                //获取市区的URL
//                addressUrl = "getCityAddressUrl"
//                //请求市区需要传递的参数
//                parameters = ["province_id" : "5",
//                "user_id" : userID]
//            case 3:
//                //获取县的URL
//                addressUrl = "getCountyAddressUrl"
//                //请求县需要传递的参数
//                parameters = ["city_id" : "4",
//                              "user_id" : userID]
//            case 4:
//                //获取乡镇的URL
//                addressUrl = "getTownAddressUrl"
//                //请求县需要传递的参数
//                parameters = ["county_id" : "3",
//                              "user_id" : userID]
//            default:
//                break;
//            }
//            //转菊花
//            self.addAddressView.chrysan.show()
//            //网络请求/
//            ZHFNetwork.request(target: .HaveParameters(pathStr: addressUrl, parameters: parameters), success: { (result) in
//                self.addAddressView.chrysan.hide()
//                if result != nil
//                {
//                    let dic = result as! NSDictionary
//                    let code : NSInteger = dic["code"] as! NSInteger
//                    if code == 200{
//                        switch addressID {
//                        case 1:
//                            //拿到省列表
//                            let  provinceArr: NSArray = dic["data"] as! NSArray
//                            self.case1(provinceArr: provinceArr)
//                            break;
//                        case 2:
//                            //拿到市列表
//                            let  cityArr: NSArray = dic["data"] as! NSArray
//                            self.case2(cityArr: cityArr)
//                            break;
//                        case 3:
//                            //拿到县列表
//                            let  countyArr: NSArray = dic["data"] as! NSArray
//                            self.case3(countyArr: countyArr)
//                            break;
//                        case 4:
//                            //拿到乡镇列表
//                            let  townArr: NSArray = dic["data"] as! NSArray
//                            self.case4(townArr: townArr)
//                            break;
//                        default:
//                            break;
//                        }
//                        if self.tableViewMarr.count >= addressID{
//                            let tableView1: UITableView  = self.tableViewMarr[addressID - 1] as! UITableView
//                            tableView1.reloadData()
//                            tableView1.layoutIfNeeded()
//                            if self.isChangeAddress == true{
//                                //保证列表刷新之后才进行滚动处理
//                                DispatchQueue.main.async {
//                                    if tableView1.numberOfRows(inSection: 0) >= self.scroolToRow{
//                                    tableView1.scrollToRow(at: NSIndexPath.init(row: self.scroolToRow, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
//                                  }
//                               }
//                            }
//                        }
//                    }
//                    else{
//                        self.addAddressView.chrysan.showMessage(dic["msg"] as! String, hideDelay: 2.0)
//                    }
//                }
//            },  error1: { (statusCode) in
//                //服务器报错等问题 (常见问题404 ，地址错误)
//                self.addAddressView.chrysan.showPlainMessage("请求错误！错误码：\(statusCode)", hideDelay: 2)
//            }) { (error) in
//                //没有网络等问题 （网络超时，没有网，地址错误）
//                self.addAddressView.chrysan.showPlainMessage("请求失败！错误信息：\(error.errorDescription!)", hideDelay: 2)
//            }
//    }
///*下面这个主要是逻辑分析和数据处理
// 只需要找到 ProvinceModel类，把其属性修改成你需要的即可
// 以下方法：对没有下一级的情况，进行了逻辑判断（建议不要随意更改。）
// */
//    func case1(provinceArr: NSArray ) {
//        self.provinceMarr.removeAllObjects()
//        if provinceArr.count > 0{
//            self.provinceMarr.removeAllObjects()
//            for i in 0 ..< provinceArr.count{
//                let dic1 : [String : Any] = provinceArr[i] as! [String : Any]
//                let provinceModel:ProvinceModel = ProvinceModel(JSON: dic1)!
//                if self.titleIDMarr.count > 0{
//                    let provinceID = self.titleIDMarr[0] as! NSInteger
//                    if provinceModel.id == provinceID{
//                        self.scroolToRow = i
//                    }
//                }
//                self.provinceMarr.add(provinceModel)
//            }
//        }
//            //没有数据
//        else{
//            if isChangeAddress == false{
//                self.tapBtnAndcancelBtnClick()
//            }
//            else{
//                isChangeAddress = false
//            }
//        }
//    }
//    func case2(cityArr: NSArray) {
//        self.cityMarr.removeAllObjects()
//        if cityArr.count > 0{
//            self.cityMarr.removeAllObjects()
//            for i in 0 ..< cityArr.count{
//                let dic1 : [String : Any] = cityArr[i] as! [String : Any]
//                let cityModel:CityModel = CityModel(JSON: dic1)!
//                if self.titleIDMarr.count > 1{
//                    let cityID = self.titleIDMarr[1] as! NSInteger
//                    if cityModel.id == cityID{
//                        self.scroolToRow = i
//                    }
//                }
//                self.cityMarr.add(cityModel)
//            }
//            changeRefreshTitle(titleTag: 1)
//        }
//        else{
//            //没有对应的市
//            self.removeTitleAndTableViewCancel(index: 1)
//        }
//    }
//    func case3(countyArr: NSArray ) {
//        if countyArr.count > 0{
//            self.countyMarr.removeAllObjects()
//            for i in 0 ..< countyArr.count{
//                let dic1 : [String : Any] = countyArr[i] as! [String : Any]
//                let countyModel:CountyModel  = CountyModel(JSON: dic1)!
//                if self.titleIDMarr.count > 2{
//                    let countyID = self.titleIDMarr[2] as! NSInteger
//                    if countyModel.id == countyID{
//                        self.scroolToRow = i
//                    }
//                }
//                self.countyMarr.add(countyModel)
//            }
//            changeRefreshTitle(titleTag: 2)
//        }
//        else{
//            //没有对应的县
//            self.removeTitleAndTableViewCancel(index: 2)
//        }
//    }
//    func case4(townArr: NSArray) {
//        self.townMarr.removeAllObjects()
//        if townArr.count > 0{
//            for i in 0 ..< townArr.count{
//                let dic1 : [String : Any] = townArr[i] as! [String : Any]
//                let townModel:TownModel  = TownModel(JSON: dic1)!
//                if self.titleIDMarr.count > 3{
//                    let townID = self.titleIDMarr[3] as! NSInteger
//                    if townModel.id == townID{
//                        self.scroolToRow = i
//                    }
//                }
//                self.townMarr.add(townModel)
//            }
//            changeRefreshTitle(titleTag: 3)
//        }
//        else{//没有对应的乡镇
//            self.removeTitleAndTableViewCancel(index: 3)
//        }
//    }
//    func changeRefreshTitle(titleTag: NSInteger){
//        if (self.tableViewMarr.count >= titleTag + 1){
//            self.changeTitle(replaceTitleMarrIndex: titleTag)
//        }
//        else{
//            self.addTableViewAndTitle(tableViewTag: titleTag)
//        }
//        self.setupAllTitle(selectId: titleTag)
//    }
//}
//
