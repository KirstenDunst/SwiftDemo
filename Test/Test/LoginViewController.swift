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

    //MARK: 记录UITextView的原始高度
    var bgView = UIView()
    
    var textViewHeight: CGFloat!
    var scroll = UIScrollView()
    var loginBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "自动布局"
        createViewFrame()
    }
    
    func createViewFrame(){
        scroll = UIScrollView.init()
        scroll.delegate = self as? UIScrollViewDelegate
//        scroll.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height)
        self.view.addSubview(scroll)
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
        
        bgView = UIView.init()
        scroll.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(40)
            make.left.equalTo(scroll)
            //                这里使用right属性的时候内容会根据内容来设定长度，不会默认设置据右边设定的长度
            make.width.equalTo(scroll)
            make.height.equalTo(44+44+10)
        }
        let arr = NSArray.init(objects: "ic_user","ic_passward")
        let arrPlaceholder = NSArray.init(objects: "请输入账号","请输入密码")
        for index in 0...1 {
            let view = UIView.init()
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.layer.borderWidth = 1;
            view.backgroundColor = UIColor.red
            bgView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(bgView).offset(54*index)
                make.left.equalTo(bgView).offset(38)
//                这里使用right属性的时候内容会根据内容来设定长度，不会默认设置据右边设定的长度
                make.width.equalTo(bgView).offset(-38*2)
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
        
        
        loginBtn = UIButton.init(type: .system)
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
        //获取原始位置
        textViewHeight = scroll.frame.origin.y
        
        scroll.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(close)))
        
////        接受键盘的通知，键盘
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    //MARK: 当键盘显示时
    @objc func handleKeyboardDisShow(notification: NSNotification) {
        //得到键盘frame
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        
        let height = keyboardRec?.size.height
        
        //让textView bottom位置在键盘顶部
        UIView.animate(withDuration: 0.1) {
            var frame = self.bgView.frame
//            减去的64是导航栏的高度，减去的40是键盘上面的联想词的占有高度
            frame.origin.y = height!-64-40
//            self.bgView.frame = frame
            self.scroll.contentOffset = CGPoint.init(x: 0, y: height!-64-40)
        }
    }
    
//    //MARK: 输入框enter回车事件
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        //让textView bottom位置还原
//        UITextView.animate(withDuration: 0.1, animations: {
//            var frame = scroll.frame
//            frame.origin.y = self.textViewHeight
//            self.textView.frame = frame
//        })
//        return true
//    }


//    deinit {
//        //移除监听
//        NotificationCenter.default.removeObserver(self)
//    }
//
////    键盘弹出方法处理集
//    @objc func keyboardWillShow(note: NSNotification) {
//        let userInfo = note.userInfo!
//        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//
//        let deltaY = keyBoardBounds.size.height
//        let animations:(() -> Void) = {
//            //键盘的偏移量
//            scroll.contentOffset = CGPoint.init(x: 0, y: loginBtn.frame.size.)
//            //self.tableView.transform = CGAffineTransformMakeTranslation(0 , -deltaY)
//        }
//
//        if duration > 0 {
//            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
//
//            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
//
//        }else{
//            animations()
//        }
//    }
//
////    键盘消失方法处理集
//    @objc func keyboardWillHidden(note: NSNotification) {
//        let userInfo  = note.userInfo!
//        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//
//        let animations:(() -> Void) = {
//            //键盘的偏移量
//            //self.tableView.transform = CGAffineTransformIdentity
//        }
//        if duration > 0 {
//            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
//
//            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
//        }else{
//            animations()
//        }
//    }
    
    
    @objc func btnClick(sender:UIButton?) {
            print("提交登陆")
        }
    
    @objc func close() {
//        偏移量复位
        self.scroll.contentOffset = CGPoint.init(x: 0, y: 0)
//        键盘响应取消
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*，
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
