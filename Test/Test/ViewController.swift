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
        let button = UIButton(frame:CGRect(x:10, y:150, width:100, height:30))
        button.setTitle("测试demo", for: UIControlState.normal)
        button.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        button.addTarget(self, action: #selector(kip(btn:)), for:
            .touchUpInside)
        self.view.addSubview(button)
        
        let loginBtn = UIButton.init(frame: CGRect(x:10,y:250,width:100,height:30))
        loginBtn.setTitle("登录页面", for: .normal)
        loginBtn.setTitleColor(UIColor.red, for: .normal)
        loginBtn.addTarget(self, action: #selector(login(btn:)), for: .touchUpInside)
        self.view.addSubview(loginBtn)
        
    }
    
    @objc func kip(btn:UIButton?){
        navigationController?.pushViewController(DemoViewController(), animated: true)
    }
    
    @objc func login(btn:UIButton){
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

