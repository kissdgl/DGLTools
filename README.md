# DGLTools


##目录

#### 1.UIImage相关
* UIImage+GetColor.h
  * 框架: UIKit
  * 功能: 获取某个像素点的颜色
* UIImage+Render.h
  * 框架: UIKit
  * 功能: 提供一个不渲染图片的方法
* UIImageView+Download.h
  * 框架: SDWebImage
  * 功能: 封装SDWebImage, 可根据网络状态下载不同尺寸的图片

#### 2.定位相关
* LocationTools.swift
  * 框架: CoreLoation
  * 功能: 获取用户当前位置

#### 3.动画相关
* PhotoBrowserAnimator.swift
  * 框架: UIKit
  * 功能: 类似于相册的自定义转场动画

#### 4.二维码
* QRCodeManager.swift QRCodeManager.h
  * 框架: AVFoundation, CoreImage, 
  * 功能: 1.生成二维码 2.识别二维码 3.扫描二维码

#### 5.网络请求工具类
* DGLHttpTool.h
  * 框架: AFNetworking
  * 功能: 对AFNetworking的简单封装, 发送get/post请求

#### 6.自定义视频播放器
* VideoPlayView.h
  * 框架: AVFoundation
  * 功能: 一个简单的视频播放器

#### 7.自定义布局
* DGLWaterflowLayout.h
  * 框架: UIKit
  * 功能: 自定义流水布局

* DGLFlowLayout.h
  * 框架: UIKit
  * 功能: 自定义布局,实现滑动collectionView时cell的缩放

#### 8.左右TableView
* LRTableView.swift
  * 框架: UIKit
  * 功能: tableView的二级联动, 以及数据传递

#### 9.Encrypt加密
* EncryptionTools.h, NSString+Hash.h, RSACryptor.h
  * 框架: Foundation
  * 功能: MD5, SHA1, SHA256, DES, AES, RAC

#### 10.File相关
* DGLFileManager.h
  * 框架: Foundation
  * 功能: 1.获取文件夹尺寸 2.删除文件夹下所有文件

#### 11.NSDictionnary
* NSDictionary+PropertyCode.h
  * 框架: Foundation
  * 功能: 根据字典转换为模型的属性代码

#### 12.SQLite_FMDB封装
* SQLiteManager.swift
  * 框架: FMDB
  * 功能: 实现sqlite语句实现数据库的增删查改

#### 13.UIColor
* UIColor+Hex.h
  * 框架: UIKit
  * 功能: 十六进制颜色转换, 能识别三种格式(@“#123456”、 @“0X123456”、 @“123456”)

#### 14.UIView相关
* UIView+Frame.h
  * 框架: UIKit
  * 功能: 可直接对frame等进行赋值

#### 15.字典转模型
* UIView+Frame.h
  * 框架: NSObject+Model.h
  * 功能: 使用Runtime和KVC实现快速字典转模型


#### 16.DGLCSVTool

* DGLCSVTool.h
  * 框架: Foundation
  * 功能: 将内容用',' 分隔开 然后写入csv文件会自动以',' 切换表格

#### 17.DGLPDFDrawer

* DGLPDFDrawer.h
  * 框架:CoreGraphics/CoreText
  * 功能:将文字或者图片绘制到当前的context 并生成PDF文件

#### 18.JsonTool

* AUTJsonManager.h
  * 框架:Foundation
  * 功能:两个方法, 将json格式字符串转换为字典 将字典转换为json字符串


#### 19.收集打印日志

* DGLLog.h
  * 框架:Foundation
  * 功能:将C++与OC的输出日志写入file并储存

#### 20.常用正则表达式

* NSString+Regex.h
  * 框架:Foundation
  * 功能:常用正则表达式, 手机,邮件格式判断等

#### 21.绘制动态折线图

* UILiveDataGraphView.h
  * 框架:CoreGraphics
  * 功能:根据动态添加的数据数组来绘制折线图 可根据数据的变化来动态显示

#### 22.绘制仪表盘

* DGLGaugeView.h
  * 框架:UIKit
  * 功能:根据传入数据动态显示仪表盘 可转动








​	


