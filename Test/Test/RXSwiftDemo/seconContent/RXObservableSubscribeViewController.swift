//
//  RXObservableSubscribeViewController.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2020/1/17.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXObservableSubscribeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //订阅Observable发出的Event
        //使用subscribe()订阅Observable对象
        let observable = Observable.of("A","B","C")
        //1.订阅发送的event
        observable.subscribe { (event) in
            
//            print(event)
            //上述打印结果 next(A),next(B),next(C),completed
            
            //print(event.element)
            //上述打印结果 Optional("A"),Optional("B"),Optional("C"),nil
            
        }
        
        
        //2.事件的生命周期
        observable.do(onNext: { (element) in
            print("Intercepted Next：", element)
        }, afterNext: { (nextStr) in
            print("afterNextElement：", nextStr)
        }, onError: { (error) in
            print("Intercepted Error：", error)
        }, afterError: { (error) in
            print("After Error：", error)
        }, onCompleted: {
            print("Intercepted Completed")
        }, afterCompleted: {
             print("Intercepted afterCompleted")
        }, onSubscribe: {
            print("onSubscribe")
        }, onSubscribed: {
            print("onSubscribed")
        }) {
            print("disposed")
        }
        
        
        
        //3.Observable 的销毁（Dispose）
        /*
         1，Observable 从创建到终结流程
         （1）一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它。

         （2）而 Observable 序列激活之后要一直等到它发出了.error或者 .completed的 event 后，它才被终结。

         2，dispose() 方法
         （1）使用该方法我们可以手动取消一个订阅行为。

         （2）如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose()方法把这个订阅给销毁掉，防止内存泄漏。

         （3）当一个订阅行为被dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了。下面是一个简单的使用样例。
         **/
        let observableOne = Observable.of("A","B","C")
        let subscriptionOne = observableOne.subscribe { (event) in
            print(event)
        }
        //调用这个订阅的dispose()方法
        subscriptionOne.dispose()
        
        /*
         3，DisposeBag
         （1）除了 dispose()方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁：

         我们可以把一个 DisposeBag对象看成一个垃圾袋，把用过的订阅行为都放进去。
         而这个DisposeBag 就会在自己快要dealloc 的时候，对它里面的所有订阅行为都调用 dispose()方法。
         （2）下面是一个简单的使用样例。
         **/
        let disposeBag = DisposeBag()
        
        //第一个Observable，及其订阅
        let observable1 = Observable.of("A","B","C")
        observable1.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        //第二个Observable，及其订阅
        let observalble2 = Observable.of(1,2,3)
        observalble2.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
