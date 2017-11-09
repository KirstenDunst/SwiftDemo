//
//  ViewController.swift
//  Test
//
//  Created by CSX on 2017/9/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试"
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white;
        let arr = NSArray.init(objects: "测试demo","登录界面","多线程","数据库处理","动画处理")
        
        for index in 0...arr.count-1{
            let button = UIButton(frame:CGRect(x:10, y:100+100*index, width:100, height:30))
            button.setTitle(arr[index] as? String, for: UIControlState.normal)
            button.setBackgroundImage(creatImageWithColor(color: .lightGray), for: .normal)
            button.setTitleColor(UIColor.red, for: UIControlState.normal)
            button.tag = index + 1000
            button.addTarget(self, action: #selector(kip(btn:)), for:
                .touchUpInside)
            self.view.addSubview(button)
        }
        
    }
    
    @objc func kip(btn:UIButton?){
        switch (btn?.tag)!-1000 {
        case 0:
            navigationController?.pushViewController(DemoViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(LoginViewController(), animated: true)
        case 2:
            let threadVC = ThreadViewController()
            threadVC.indexA = 1
            navigationController?.pushViewController(threadVC, animated: true)
        case 3:
            navigationController?.pushViewController(DataBaseViewController(), animated: true)
        case 4:
            navigationController?.pushViewController(AnimationViewController(), animated: true)
        default:
            return
        }
        
    }
    
//    将颜色转为image对象
    func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x:0.0, y:0.0, width:1.0, height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

