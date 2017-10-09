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
        let arr = NSArray.init(objects: "测试demo","登录界面","多线程","数据库处理")
        
        
        for index in 0...arr.count-1{
            let button = UIButton(frame:CGRect(x:10, y:100+100*index, width:100, height:30))
            button.setTitle(arr[index] as? String, for: UIControlState.normal)
            button.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
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
            navigationController?.pushViewController(ThreadViewController(), animated: true)
        case 3:
         navigationController?.pushViewController(DataBaseViewController(), animated: true)
        default:
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

