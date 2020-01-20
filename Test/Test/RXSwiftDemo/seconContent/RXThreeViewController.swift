//
//  RXThreeViewController.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2020/1/20.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXThreeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //Subjects 基本介绍
        /*
        （1）Subjects 既是订阅者，也是 Observable：

         说它是订阅者，是因为它能够动态地接收新的值。
         说它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者。
         （2）一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。他们之间既有各自的特点，也有相同之处：

         首先他们都是 Observable，他们的订阅者都能收到他们发出的新的 Event。
         直到 Subject 发出 .complete 或者 .error 的 Event 后，该 Subject 便终结了，同时它也就不会再发出.next事件。
         对于那些在 Subject 终结后再订阅他的订阅者，也能收到 subject发出的一条 .complete 或 .error的 event，告诉这个新的订阅者它已经终结了。
         他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的旧 Event，如果能的话又能收到多少个。
         （3）Subject 常用的几个方法：

         onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个.next 事件。
         onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
         onCompleted()：是 on(.completed)的简便写法。该方法相当于 subject 接收到一个 .completed 事件。
         **/
        
        //1.PublishSubject
        PublishSubjectFunc()
        
  
        //2.BehaviorSubject
        BehaviorSubjectFunc()


        //3.ReplaySubject
        ReplaySubjectFunc()


        //4.Variable
        VariableFunc()
        
    }
    
    private func PublishSubjectFunc() {
        /*（1）基本介绍
        PublishSubject是最普通的 Subject，它不需要初始值就能创建。
        PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
        */
        let subject = PublishSubject<String>()
        //由于当前没有任何订阅者，所以这条消息不会打印到控制台
        subject.onNext("111")
        
        //第一次订阅
        subject.subscribe(onNext: { (string) in
            print("第一次订阅：",string)
        }, onError: { (error) in
            print("第一次订阅失败：", error)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
            }).disposed(by: disposeBag)
        
        //当前有第一个订阅者，则该信息会打印到控制台
        subject.onNext("222")
        
        //第二次订阅
        subject.subscribe(onNext: { (string) in
            print("第二次订阅：", string)
        }, onError: { (error) in
            print("第二次订阅失败：", error)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
            }).disposed(by: disposeBag)
        
        //当前有两个订阅者，则该信息会打印到控制台
        subject.onNext("333")
        //让subject结束
        subject.onCompleted()
        //完成之后发出的.next事件
        subject.onNext("444")
        
        //subject完成之后他的所有订阅（包括结束后的订阅），都能收到subject的complete事件
        subject.subscribe(onNext: { (string) in
            print("第三次订阅：", string)
        }, onError: { (error) in
            print("第三次订阅失败：", error)
        }, onCompleted: {
            print("第三次订阅：onCompleted")
            }).disposed(by: disposeBag)
        
        
        
        /*结果打印：
         第一次订阅： 222
         第一次订阅： 333
         第二次订阅： 333
         第一次f订阅：onCompleted
         第二次订阅：onCompleted
         第三次订阅：onCompleted
         **/
    }
    
    private func BehaviorSubjectFunc() {
        /*
        （1）基本介绍

         BehaviorSubject 需要通过一个默认初始值来创建。
         当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
         **/
        let behaviorSubject = BehaviorSubject(value: "111")
        behaviorSubject.subscribe { (event) in
            print("第一次订阅：",event)
        }.disposed(by: disposeBag)
        
        //发送next事件
        behaviorSubject.onNext("222")
        //发送error事件
        behaviorSubject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        //第二次订阅subject
        behaviorSubject.subscribe { (event) in
            print("第二次订阅：", event)
        }.disposed(by: disposeBag)
        
        
        
        /*结果打印：
         第一次订阅： next(111)
         第一次订阅： next(222)
         第一次订阅： error(Error Domain=local Code=0 "(null)")
         第二次订阅： error(Error Domain=local Code=0 "(null)")
         **/
    }
    
    
    private func ReplaySubjectFunc() {
        /*
         （1）基本介绍

         ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
         比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个.next 的 event。
         如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event外，还会收到那个终结的 .error 或者 .complete 的event。
         **/
        
        //创建一个bufferSize为2的ReplaySubject
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        //连续发送3个next事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第一次订阅
        subject.subscribe { (event) in
            print("第一次订阅：", event)
        }.disposed(by: disposeBag)
        
        //在发送一个next信号
        subject.onNext("444")
        
        //第二次订阅
        subject.subscribe { (event) in
            print("第二次订阅：", event)
        }.disposed(by: disposeBag)
        
        //发送结束
        subject.onCompleted()
        
        //第三次订阅
        subject.subscribe { (event) in
            print("第三次订阅：", event)
        }.disposed(by: disposeBag)
        
        
        
        /*结果打印：
         第一次订阅： next(222)
         第一次订阅： next(333)
         第一次订阅： next(444)
         第二次订阅： next(333)
         第二次订阅： next(444)
         第一次订阅： completed
         第二次订阅： completed
         第三次订阅： next(333)
         第三次订阅： next(444)
         第三次订阅： completed
         **/
    }
    
    
    private func VariableFunc() {
        /*
         （1）基本介绍 (Variable is deprecated. Please use `BehaviorRelay` as a replacement.)

         Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
         Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
         不同的是，Variable 还会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete的 event，不需要也不能手动给 Variables 发送 completed或者 error 事件来结束它。
         简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
         注意：
         Variables 本身没有 subscribe() 方法，但是所有 Subjects 都有一个 asObservable() 方法。我们可以使用这个方法返回这个 Variable 的 Observable 类型，拿到这个 Observable 类型我们就能订阅它了。
         **/
        
        //创建一个初始值为111的Variable
        let variable = Variable("111")
        //修改value值
        variable.value = "222"
        
        //第一次订阅
        variable.asObservable().subscribe { (event) in
            print("第一次订阅：", event)
        }.disposed(by: disposeBag)
        
        //修改value值
        variable.value = "333"
        
        //第二次订阅
        variable.asObservable().subscribe { (event) in
            print("第二次订阅：", event)
        }.disposed(by: disposeBag)
        
        //修改value的值
        variable.value = "444"
        
        
        
        /*结果打印：
         第一次订阅： next(222)
         第一次订阅： next(333)
         第二次订阅： next(333)
         第一次订阅： next(444)
         第二次订阅： next(444)
         第一次订阅： completed
         第二次订阅： completed
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
