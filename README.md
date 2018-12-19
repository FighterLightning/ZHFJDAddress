# ZHFJDAddress
### 这是一个自定义仿京东地址选择器--Swift版本（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
OC版本地址：

`
https://github.com/FighterLightning/ZHFJDAddressOC.git

---


 
 ![](./仿京东地址选择/1.gif)     ![](./仿京东地址选择/2.gif)



#### Demo的使用须知:
 1. 下载该demo。把ProvinceModel.swift（必须），ZHFAddTitleAddressView.swift(必须) AddressCell.swift(必须) NetworkTools.swift(网络请求类，本地数据不需要，对Moya做简单的处理可自写)拖进项目

 2. 在 Podfile 中添加:
 * `pod 'Moya'`//网络请求
 
 * `pod 'ObjectMapper'`//字典转模型

 * `pod 'Chrysan', :git => 'https://github.com/Harley-xk/Chrysan.git'`//第三方加载框（根据需求进行添加）
 	
3. 你主要需要关注的是ZHFAddTitleAddressView.m 这个方法

 func getAddressMessageData(addressID: NSInteger, provinceIdOrCityId: NSInteger)
这个方法。addressID 决定的是展现那个tableView,  provinceIdOrCityId这个决定要请求的是省市区还是乡镇。

#### 代码思路分析:
看这个地址选择器的大致框架是UIScrollView与UITableView结合的附带一个展示头的东西.主要就是逻辑展示问题。
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
通过对这个点击方法里 self.titleMarr（ 存放选中地址名字的可变数组）  
 self.titleIDMarr （存放选中地址ID的可变数组）  
 进行增加，删除，替换。    
然后获得下一级数据（同时判断是否有下一级，没有直接回收地址选择器）  
把当前地址展示，同时把ID传入控制器。  
 
# PS

 如果感觉有帮助，感谢fork star！
 该demo地址：
 
 `
 https://github.com/FighterLightning/ZHFJDAddress.git
