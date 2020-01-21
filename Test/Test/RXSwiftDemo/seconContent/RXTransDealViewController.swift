//
//  RXTransDealViewController.swift
//  Test
//
//  Created by 曹世鑫 on 2020/1/20.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//变换操作符：buffer、map、flatMap（已废弃->改用compactMap）、scan等
class RXTransDealViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        /*
         变换操作（Transforming Observables）
         变换操作指的是对原始的 Observable 序列进行一些转换，类似于 Swift 中 CollectionType 的各种转换。
         **/
        
        
        //buffer
        bufferFunc()


        //window
        windowFunc()


        //map
        mapFunc()


        //flatmap
        flatMapFunc()


        //concatMap
        concatMapFunc()


        //scan
        scanFunc()

        
        //groupBy
        groupByFunc()
        
    }
    
    
    
    private func bufferFunc() {
        /*
        （1）基本介绍
        
        buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
        该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
        **/
        
        let subject = PublishSubject<String>()
        
        //每缓冲3个元素则组合起来一起发出
        //如果一秒钟不够3个也会发出（有几个发几个，一个都没有发空数组[]）
        subject.buffer(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance).subscribe { (event) in
            print("结果：", event)
        }.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        /*结果打印：
         结果： next(["a", "b", "c"])
         结果： next(["1", "2", "3"])
         结果： next([])
         结果： next([])
         结果： next([])
         结果： next([])
         结果： next([])
         **/
        
    }
    
    private func windowFunc() {
        /*
         （1）基本介绍

         window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
         同时 buffer要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
         **/
        let subject = PublishSubject<String>()
        
        //每3个元素作为一个子Observable发出
        subject.window(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance).subscribe(onNext: { (event) in
            print("subscribe:\(event)")
            event.asObservable().subscribe { (cellEvent) in
                print("cellEvent:\(cellEvent)")
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        /*结果打印
         subscribe:RxSwift.AddRef<Swift.String>
         cellEvent:next(a)
         cellEvent:next(b)
         cellEvent:next(c)
         cellEvent:completed
         subscribe:RxSwift.AddRef<Swift.String>
         cellEvent:next(1)
         cellEvent:next(2)
         cellEvent:next(3)
         cellEvent:completed
         subscribe:RxSwift.AddRef<Swift.String>
         cellEvent:completed
         subscribe:RxSwift.AddRef<Swift.String>
         cellEvent:completed
         subscribe:RxSwift.AddRef<Swift.String>
         cellEvent:completed
         **/
        
    }
    
    private func mapFunc() {
        /*
         （1）基本介绍

         该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
         **/
        Observable.of(1,2,3).map { (number) -> Int in
            return number * 10
        }.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        /*打印结果
         10
         20
         30
         **/
    }
    
    
    private func flatMapFunc() {
        /*
         （1）基本介绍

         map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
         而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
         这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
         **/
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().flatMap { (event) -> BehaviorSubject<String> in
            return event
        }.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        
        /*结果打印
         next(A)
         next(B)
         next(1)
         next(2)
         next(C)
         **/
    }
    
    private func concatMapFunc() {
        /*
         （1）基本介绍

         concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
         **/
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().concatMap { (event) -> BehaviorSubject<String> in
            return event
        }.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted()
        
        /*结果打印
         next(A)
         next(B)
         next(C)
         next(2)
         */
    }
    
    
    private func scanFunc() {
        /*
         （1）基本介绍

         scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
         **/
        Observable.of(1,2,3,4,5).scan(0) { (acum, elem) -> Int in
            return acum + elem
        }.subscribe { (event) in
            print(event.element)
        }.disposed(by: disposeBag)

        /*结果打印
         1
         3
         6
         10
         15
         **/
    }
    
    
    private func groupByFunc() {
        /*
         （1）基本介绍

         groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
         也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
         **/
        
        //将奇数和偶数分成两组
        Observable<Int>.of(0,1,2,3,4,5,6,7).groupBy { (element) -> String in
            return element % 2 == 0 ? "偶数" : "奇数"
        }.subscribe { (event) in
            switch event {
            case .next(let group):
                group.asObservable().subscribe { (event) in
                    print("Key:\(group.key)  event:\(event)")
                }.disposed(by: self.disposeBag)
            default :
                print("~~")
            }
        }.disposed(by: disposeBag)
        
        /*结果打印
         Key:偶数  event:next(0)
         Key:奇数  event:next(1)
         Key:偶数  event:next(2)
         Key:奇数  event:next(3)
         Key:偶数  event:next(4)
         Key:奇数  event:next(5)
         Key:偶数  event:next(6)
         Key:奇数  event:next(7)
         Key:奇数  event:completed
         Key:偶数  event:completed
         ~~
         **/
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
