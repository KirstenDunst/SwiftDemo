//
//  LoginViewController.swift
//  Test
//
//  Created by CSX on 2017/9/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//




/*
 swift 进行cocoapods下载第三方处理的时候需要添加上use_frameworkes!(由于swift使用的是静态库文件.frameworke)
 eg:

 platform :ios, '11.0'
 use_frameworks!
 
 target 'Test' do
 pod 'Kingfisher'
 pod 'Alamofire'
 pod 'SnapKit'
 end
 
 
 在下载的时候如果遇到提示例如：
 [!] The `Paopao [Debug]` target overrides the `OTHER_LDFLAGS` build setting defined in `Pods/Target Support Files/Pods/Pods.debug.xcconfig'. This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.
 
 [!] The `Paopao [Release]` target overrides the `PODS_ROOT` build setting defined in `Pods/Target Support Files/Pods/Pods.release.xcconfig'. This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.
 的话。需要在这个工程里面修改一下相关的配置，如果不做处理的时候运行会有很多的地方报错！
 
 这种警告是不能忽视的，它带来的直接后果就是无法通过编译。
 
 而产生此警告的原因是项目 Target 中的一些设置，CocoaPods 也做了默认的设置，如果两个设置结果不一致，就会造成问题。
 
 我想要使用 CocoaPods 中的设置，分别在我的项目中定义`PODS_ROOT` 和 `Other Linker Flags`的地方，把他们的值用`$(inherited)`替换掉，进入终端，执行
 
 pod update
 警告没了，回到 Xcode，build通过。
 （网上还流行另外一种简单粗暴的方法
 点击项目文件 project.xcodeproj，右键`显示包内容`，用文本编辑器打开`project.pbxproj`，删除`OTHER_LDFLAGS`的地方，保存，回到 Xcode，编译通过。）
 
 */


import UIKit
import SnapKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.title = "我的"
//        createView(a: 12)
        createViewOne();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createView(a:Int) -> Int {
        return (a+12)
    }

    func createViewOne() {
//        创建uiimageview的控件
        let image:UIImage = UIImage.init(named: "123")!
        let imageView = UIImageView.init(image: image)
        imageView.frame = CGRect(x:20,y:120,width:image.size.width,height:image.size.height)
        imageView.layer.cornerRadius = image.size.width/2;
        imageView.layer.masksToBounds = true;
        self.view.addSubview(imageView)
        
        
//        使用SnapKit进行控件的代码约束
       imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
        
        

        
//        使用系统自带的请求封装的方法进行网络请求处理
        CSHTTPTool.share.getWithPath(path: "http://appapi.zongs365.com/api/home/machine/9001000015/goodsdetial", paras: nil, success: { (data) in
            print("成功","\n", data)
        }) { (error) in
            print("失败", error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
