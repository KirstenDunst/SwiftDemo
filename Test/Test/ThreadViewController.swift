//
//  ThreadViewController.swift
//  Test
//
//  Created by CSX on 2017/10/9.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit

class ThreadViewController: UIViewController {

//    使用public公开对外的属性调用，默认不写或者private表明私有
    public var indexA = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSString.init(format: "上一界面传来的：%d",indexA) as String
        self.view.backgroundColor = UIColor.white
        
        createView()
        // Do any additional setup after loading the view.
    }

    func createView(){
//        体验数据的传输方法处理
        let label = UILabel.init(frame: CGRect(x:10,y:74,width:200,height:50))
        label.text = labelForBack(a: 2) as String
        label.backgroundColor = UIColor.init(red: 56/255.0, green: 127/255.0, blue: 230/255.0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        let threadBtn = UIButton.init(type: .system)
        threadBtn.frame = CGRect(x:10,y:250,width:200,height:50)
        threadBtn.addTarget(self, action: #selector(threadTarch), for: .touchUpInside)
        threadBtn.setBackgroundImage(imageWithColor(color: UIColor.init(red: 56/255.0, green: 127/255.0, blue: 230/255.0, alpha: 1)), for: .normal)
        threadBtn.setTitleColor(UIColor.red, for: .normal)
        threadBtn.setTitle("多线程处理按钮", for: .normal)
        self.view.addSubview(threadBtn)
        
    }
    
    func labelForBack(a:Int) -> NSString {
        return NSString.init(format: "输入的int数据：%d", a)
    }
    
    
//       多线程数据处理方法调用
    @objc func threadTarch(){
        
//        1.异步串行队列。（依次执行一个个任务，执行完之后再执行下一个）
        let queue = DispatchQueue.init(label: "这是一个队列标记名字")
        queue.async {
            let date = NSDate()
            print("串行asycn1:" + date.description)
            Thread.sleep(until: NSDate.init(timeIntervalSinceNow: 1) as Date)  //停止1秒
        }
        queue.async {
            let date = NSDate()
            print("串行asycn2:" + date.description)
            Thread.sleep(until: NSDate.init(timeIntervalSinceNow: 1) as Date)  //停止1秒
        }
        queue.async {
            let date = NSDate()
            print("串行asycn3:" + date.description)
            Thread.sleep(until: NSDate.init(timeIntervalSinceNow: 1) as Date)  //停止1秒
        }
        
        
//        DispatchQos用于描述队列优先级， 从高到低分为userInteractive,userInitiated,default,utility,background， 默认是default。
        
//        2.异步并行队列。（多个任务同时开始执行，谁先执行完只根据任务本身有关，不按顺序关系）
        /*
         label 队列的标识符，方便调试
         qos 队列的quality of service。用来指明队列的“重要性”，后文会详细讲到。
         attributes 队列的属性。类型是DispatchQueue.Attributes,是1个结构体，遵守了协议OptionSet。意味着你可以这样传入第1个参数[.option1,.option2].(一般.concurrent，用来表示并行队列)
         autoreleaseFrequency。顾名思义，自动释放频率。有些队列是会在履行完任务后自动释放的，有些比如Timer等是不会自动释放的，是需要手动释放。
         */
        let conqueue = DispatchQueue.init(label: "这是一个并行队列", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
        conqueue.async {
            let date = Date()
            print("并行async1 \(date.description)")
            Thread.sleep(forTimeInterval: 1)   //停止1秒
        }
        conqueue.async {   //同步方法会阻塞UI，造成不显示控件或无点击事件，但仍然是顺序执行
            let date = Date()
            print("并行async2 \(date.description)")
            Thread.sleep(forTimeInterval: 1)
        }
        conqueue.async {
            let date = Date()
            print("并行async3 \(date.description)")
            Thread.sleep(forTimeInterval: 1)
        }
        
        
        
//        3.设置运行时间asyncAfter函数可以设置延迟一段时间后运行闭包，功能类似于定时器。
        let time = DispatchTime.now() + 3
        conqueue.asyncAfter(deadline: time, execute: {
            let date = Date()
            print("并行asyncAfter \(date.description)")
        })
        
        
        
//        4.DispatchGroup的作用就是监听一个或多个DispatchQueue任务结束的触发事件， 类似于Java的wait/notifyAll。
        let group = DispatchGroup()
        let queue1 = DispatchQueue(label: "queue1")
        queue1.async(group: group) {
            Thread.sleep(forTimeInterval: 1)   //停止1秒
            let date = Date()
            print("检测队列执行之后才执行async1 \(date.description)")
        }
        let queue2 = DispatchQueue(label: "queue2")
        queue2.async(group: group) {
            Thread.sleep(forTimeInterval: 3)
            let date = Date()
            print("检测队列执行之后才执行asycn2 \(date.description)")
        }
        let queue3 = DispatchQueue(label: "queue3")
        queue3.async(group: group){
            Thread.sleep(forTimeInterval: 1)
            let date = Date()
            print("检测队列执行之后才执行async3 \(date.description)")
        }
        let date1 = Date()
        print("检测队列执行之后才执行date1: \(date1.description)")
        group.wait()    //等待group的任务都执行完成后向下执行
        let date2 = Date()
        print("检测队列执行之后才执行date2: \(date2.description)")
//        将3个DispatchQueue的任务添加到DispatchGroup中，  date1先打印出来， 等到async1、async2、async3都执行完成后才打印date2。
        
        
        
        
        
        
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
    
//    绘制颜色转换成图片的格式的方法
    func imageWithColor(color:UIColor) -> UIImage {
        let  rect =  CGRect(x:0.0,y:0.0,width:1.0,height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
