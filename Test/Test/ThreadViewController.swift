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
        
        let arr = NSArray.init(objects: "异步串行","异步并行","延时执行","多线程完成监听","信号量","barrier屏障","UserData合并数据的变化")
        for index in 0...arr.count-1 {
            let threadBtn = UIButton.init(type: .system)
            threadBtn.frame = CGRect(x:10,y:150+index*60,width:200,height:50)
            threadBtn.tag = index+100
            threadBtn.addTarget(self, action: #selector(threadTarch(sender:)), for: .touchUpInside)
            threadBtn.setBackgroundImage(imageWithColor(color: UIColor.init(red: 56/255.0, green: 127/255.0, blue: 230/255.0, alpha: 1)), for: .normal)
            threadBtn.setTitleColor(UIColor.red, for: .normal)
            threadBtn.setTitle(arr[index] as? String, for: .normal)
            self.view.addSubview(threadBtn)
        }
    }
    
    func labelForBack(a:Int) -> NSString {
        return NSString.init(format: "输入的int数据：%d", a)
    }
    
    
//       多线程数据处理方法调用
    @objc func threadTarch(sender:UIButton){
        
        switch sender.tag-100 {
        case 0:
            do {
//            异步串行队列
               sericalAsycn()
            }
        case 1:
            do {
//            异步并行队列
               parallelAsycn()
            }
        case 2:
            do {
//            延时执行
               waitAsycn()
            }
        case 3:
            do {
//            多线程完成之后的监听
               waitForComplete()
            }
        case 4:
            do {
//            信号量检测
               semaphoreDetail()
            }
        case 5:
            do{
//            barrier翻译过来就是屏障
              Barrier()
            }
        case 6:
            do
            {
//                合并数据的变化
                UserData()
            }
        default:
            break
            
        }
        
    }
    
//    异步串行队列
    func sericalAsycn() {
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
    }
    
//    异步并行队列
    func parallelAsycn() {
        //        DispatchQos用于描述队列优先级， 从高到低分为userInteractive,userInitiated,default,utility,background， 默认是default。
        
        //        2.异步并行队列。（多个任务同时开始执行，谁先执行完只根据任务本身有关，不按顺序关系）
        /*
         label 队列的标识符，方便调试
         qos 队列的quality of service。用来指明队列的“重要性”，(原先的GCD只有四个优先级，high，default，low，background
         然而现在的GCD有六个优先级，background，utility，default，userInitiated，userInteractive，unspecified)（重要性依次降低：userInteractive>default>unspecified>userInitiated>utility>background）
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
        
    }
    
    
    
//    延时处理
    func waitAsycn() {
        let conqueue = DispatchQueue.init(label: "这是一个并行队列", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
//        3.设置运行时间asyncAfter函数可以设置延迟一段时间后运行闭包，功能类似于定时器。
        print("延时处理")
        let time = DispatchTime.now() + 3
        conqueue.asyncAfter(deadline: time, execute: {
            let date = Date()
            print("延时3秒asyncAfter \(date.description)")
        })
        
    }
    
    
    
//    事件监听处理
    func waitForComplete() {
        
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
    
    
    
    
//    信号量处理
    func semaphoreDetail() {
        
        //        5.信号量
        let semaphore = DispatchSemaphore(value: 2)
        let conqueue4 = DispatchQueue(label: "com.leo.concurrentQueue", qos: .default, attributes: .concurrent)
        
        conqueue4.async {
            semaphore.wait()
            self.usbTask(label: "1", cost: 2, complete: {
                semaphore.signal()
            })
        }
        
        conqueue4.async {
            semaphore.wait()
            self.usbTask(label: "2", cost: 2, complete: {
                semaphore.signal()
            })
        }
        
        conqueue4.async {
            semaphore.wait()
            self.usbTask(label: "3", cost: 1, complete: {
                semaphore.signal()
            })
        }
        
    }
    func usbTask(label:String, cost:UInt32, complete:@escaping ()->()){
        NSLog("Start usb task%@",label)
        sleep(cost)
        NSLog("End usb task%@",label)
        complete()
    }
    
    
    
    
    /*  barrier翻译过来就是屏障。在1个并行queue里，很多时候，我们提交1个新的任务需要这样做。
         queue里之前的任务履行完了新任务才开始
         新任务开始后提交的任务都要等待新任务履行终了才能继续履行
         以barrier flag提交的任务能够保证其在并行队列履行的时候，是唯1的1个任务。（只对自己创建的队列有效，对gloablQueue无效）
         典型的场景就是往NSMutableArray里addObject。
     */
    func Barrier() {
        let concurrentQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
        concurrentQueue.async {
            self.readDataTask(label: "1", cost: 3)
        }
        
        concurrentQueue.async {
            self.readDataTask(label: "2", cost: 3)
        }
        concurrentQueue.async(flags: .barrier, execute: {
            NSLog("Task from barrier 1 begin")
            sleep(3)
            NSLog("Task from barrier 1 end")
        })
        
        concurrentQueue.async {
            self.readDataTask(label: "3", cost: 3)
        }
    }
//    履行的效果就是：barrier任务提交后，等待前面所有的任务都完成了才履行本身。barrier任务履行完了后，再履行后续履行的任务。
    func readDataTask(label:String, cost:UInt32) {
        NSLog("Start usb task%@",label)
        sleep(cost)
        NSLog("End usb task%@",label)
    }
    
    
    
    
    
    
 /* UserData
    DispatchSource中UserData部份也是强有力的工具，这部份包括两个协议，两个协议都是用来合并数据的变化，只不过1个是依照+(加)的方式，1个是依照|(位与)的方式。
    DispatchSourceUserDataAdd
    DispatchSourceUserDataOr
    在使用这两种Source的时候，GCD会帮助我们自动的将这些改变合并，然后在适当的时候（target queue空闲）的时候，去回调EventHandler,从而避免了频繁的回调致使CPU占用过量。
 */
//    比如，对DispatchSourceUserDataAdd你可以这么使用，
    func UserData() {
        let userData = DispatchSource.makeUserDataAddSource()
        var globalData:UInt = 0
        userData.setEventHandler {
            let pendingData = userData.data
            globalData = globalData + pendingData
            print("Add \(pendingData) to global and current global is \(globalData)")
        }
        userData.resume()
        let serialQueue = DispatchQueue(label: "com")
        serialQueue.async {
            for index in 1...1000{
                userData.add(data: 1)
            }
            for index in 1...1000{
                userData.add(data: 1)
            }
        }
    }
    
    
    
    
    
    /*
    Synchronization
    通常，在多线程同时会对1个变量(比如NSMutableArray)进行读写的时候，我们需要斟酌到线程的同步。举个例子：比如线程1在对NSMutableArray进行addObject的时候，线程2如果也想addObject,那末它必须等到线程1履行终了后才可以履行。
    实现这类同步有很多种机制：
     
    比如用互斥锁：
    let lock = NSLock()
    lock.lock()
    //Do something
    lock.unlock()
    使用锁有1个不好的地方就是：lock和unlock要配对使用，不然极容易锁住线程，没有释放掉。
     
     
    使用GCD，队列同步有另外1种方式 - sync，将属性的访问同步到1个queue上去，就可以保证在多线程同时访问的时候，线程安全。
    class MyData{
        private var privateData:Int = 0
        private let dataQueue = DispatchQueue(label: "com.leo.dataQueue")
        var data:Int{
            get{
                return dataQueue.sync{ privateData }
            }
            set{
                dataQueue.sync { privateData = newValue}
            }
        }
    }
    */
    
    
    
    
    
    /*
     死锁
     GCD对线程进行了很好的封装，但是依然又可能出现死锁。所谓死锁，就是线程之间相互等待对方履行，才能继续履行，致使进入了1个死循环的状态。
     
     
     最简单的死锁，在main线程上sync自己。
     DispatchQueue.main.sync {
     print("You can not see this log")
     }
     缘由也比较好理解，在调用sync的时候，main队列被阻塞，等到代码块履行终了才会继续履行。由于main被阻塞，就致使了代码块没法履行，进而构成死锁。
     
     
     还有1种死锁，简单的代码以下
     queueA.sync {
        queueB.sync {
           queueC.sync {
               queueA.sync {
 
               }
           }
        }
     }
     死锁的缘由很简单，构成了1个相互阻塞的环。
    */
    
    
    
    
    
    
    
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
