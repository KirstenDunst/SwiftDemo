//
//  LoginViewController.swift
//  Test
//
//  Created by CSX on 2017/9/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "自动布局"
        createViewFrame()
    }
    
    func createViewFrame(){
        let scroll = UIScrollView.init()
        scroll.delegate = self as? UIScrollViewDelegate
//        scroll.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height)
        self.view.addSubview(scroll)
        scroll.isPagingEnabled = true
        scroll.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        
        let image = UIImage.init(named: "ic_logo")
        let iconImageView = UIImageView.init(image: image)
        scroll.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(scroll)
            make.centerY.equalTo(scroll.snp.top).offset(167)
            make.width.equalTo((image?.size.width)!)
            make.height.equalTo((image?.size.height)!)
        }
        
        
        let arr = NSArray.init(objects: "ic_user","ic_passward")
        let arrPlaceholder = NSArray.init(objects: "请输入账号","请输入密码")
        for index in 0...1 {
            let view = UIView.init()
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1;
            view.backgroundColor = UIColor.red
            scroll.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.bottom).offset(40+54*index)
                make.left.equalTo(scroll).offset(38)
//                这里使用right属性的时候内容会根据内容来设定长度，不会默认设置据右边设定的长度
                make.width.equalTo(scroll).offset(-38*2)
                make.height.equalTo(44)
            })
            let imageView = UIImageView.init(image: UIImage.init(named: arr[index] as! String))
            view.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.top.equalTo(view)
                make.left.equalTo(view)
                make.bottom.equalTo(view)
                make.right.equalTo(view.snp.left).offset(41)
            })
            let textfield = UITextField.init()
            textfield.placeholder = arrPlaceholder[index] as? String
            view.addSubview(textfield)
            textfield.snp.makeConstraints({ (make) in
                make.top.equalTo(view)
                make.left.equalTo(imageView.snp.right).offset(5)
                make.bottom.equalTo(view)
                make.right.equalTo(view)
            })
        }
        
        let loginBtn = UIButton.init(type: .system)
        loginBtn.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setBackgroundImage(UIImage.init(named: "back"), for: .normal)
        loginBtn.layer.cornerRadius = 4
        loginBtn.layer.masksToBounds = true
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        scroll.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(40+54+44+50)
            make.left.equalTo(scroll).offset(38)
            make.width.equalTo(scroll).offset(-38*2)
            make.height.equalTo(44)
        }
        
        let agreeLabel = UILabel.init()
        agreeLabel.textAlignment = NSTextAlignment.center
        agreeLabel.text = "*测试协议合同《稍后作链接富文本》"
        agreeLabel.font = UIFont.systemFont(ofSize: 12)
        scroll.addSubview(agreeLabel)
        agreeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(scroll)
            make.centerY.equalTo(loginBtn.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(300)
        }
        
//        设置协议的文字距离最底端100像素
//        CGSize.init(width: self.view.frame.size.width, height: agreeLabel.frame.origin.y+20+100)
        scroll.contentSize = CGSize.init(width: self.view.frame.size.width, height:700)
        
        
    }
    
    @objc func btnClick(sender:UIButton?) {
            print("提交登陆")
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
