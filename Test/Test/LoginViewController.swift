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
import Kingfisher

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
        let imageView = UIImageView.init()
        imageView.frame = CGRect(x:20,y:120,width:200,height:200)
        imageView.layer.cornerRadius = 200/2;
        imageView.layer.masksToBounds = true;
        self.view.addSubview(imageView)
//        imageView.image = UIImage.init(named: "123")!
        
        
        
        
        
        
        
//        使用Kingfisher加载网络图片
//         imageView.kf.setImage(with: <#T##Resource?#>, placeholder: <#T##Placeholder?#>, options: <#T##KingfisherOptionsInfo?#>, progressBlock: <#T##DownloadProgressBlock?##DownloadProgressBlock?##(Int64, Int64) -> ()#>, completionHandler: <#T##CompletionHandler?##CompletionHandler?##(Image?, NSError?, CacheType, URL?) -> ()#>)
//        在这里，Resource只是一个协议，由cacheKey和downloadURL组成的，kingfisher默认是将url作为cacheKey
//        默认情况，kingfisher先从内存中去，再去硬盘中取，如果都没有，才会下载，但是如果不想使用缓存，就要用KingfisherOptionsInfo这个来设定了
        //       在这里，options参数，是一个存了KingfisherOptionsInfoItem枚举值的数组，这里，要写KingfisherOptionsInfoItem的枚举值，可以写多个，这里，fade是一个动画（淡出显示的动画），forceRefresh这个是每次都从网络获取，还有很多可以自己进库文件看。     kf.setImage返回的是一个task任务（类似系统的session任务），这个任务是可以取消的（不过一般这个也没用到过）
//        progressBlock是下载进度，completionHandler是完成回调。
//        https://images4.c-ctrip.com/target/fd/headphoto/g3/M08/F4/72/CggYG1aXR_eABX1TAAAfVBzkWIY988_C_180_180.jpg
        imageView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506591366147&di=ae58e9937b8e0916bd29c0b6622b0b8d&imgtype=0&src=http%3A%2F%2Fwww.pp3.cn%2Fuploads%2F1304%2F188.jpg")!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, nil, imageURL) in
            //下载完成需要进行的操作
            print("下载完成")
        })
        
        
        
        
        
        
        
        
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
