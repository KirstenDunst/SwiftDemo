//
//  RXObservableCreateVC.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2020/1/15.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXObservableCreateVC: UIViewController {

    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //Observable 作为 Rx 的根基
         /*
         1，Observable<T>
         Observable<T> 这个类就是Rx 框架的基础，我们可以称它为可观察序列。它的作用就是可以异步地产生一系列的 Event（事件），即一个 Observable<T> 对象会随着时间推移不定期地发出 event(element : T) 这样一个东西。
         而且这些 Event 还可以携带数据，它的泛型 <T> 就是用来指定这个Event携带的数据的类型。
         有了可观察序列，我们还需要有一个Observer（订阅者）来订阅它，这样这个订阅者才能收到 Observable<T> 不时发出的 Event。
         **/
        
        let btn: UIButton = UIButton()
        btn.setTitle("创建Observable序列", for: .normal)
        btn.addTarget(self, action: #selector(base_knowledge), for: .touchUpInside)
        btn.backgroundColor = .cyan
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 50))
        }
    }
    
    //基础知识 //创建Observable序列
    @objc private func base_knowledge(){
        switch (self.index%13){
        case 0:
            //1.just()方法，  该方法通过传入一个默认值来初始化
            //下面样例我们显式地标注出了 observable 的类型为 Observable<Int>，即指定了这个 Observable所发出的事件携带的数据类型必须是 Int 类型的。
            _ = Observable<Int>.just(5)
        case 1:
            //2，of() 方法  该方法可以接受可变数量的参数（必需要是同类型的）
            //下面样例中我没有显式地声明出 Observable 的泛型类型，Swift 也会自动推断类型。
            _ = Observable.of("A", "B", "C")
        case 2:
            //3.from() 方法  该方法需要一个数组参数。
            //下面样例中数据里的元素就会被当做这个 Observable 所发出 event携带的数据内容，最终效果同上面饿 of()样例是一样的。
            _ = Observable.from(["A", "B", "C"])
        case 3:
            //4，empty() 方法  该方法创建一个空内容的 Observable 序列。
            _ = Observable<Int>.empty()
        case 4:
            //5，never() 方法。该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
            _ = Observable<Int>.never()
        case 5:
            //6，error() 方法。该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
            enum MyError: Error {
                case A
                case B
            }
            _ = Observable<Int>.error(MyError.A)
        case 6:
            //7，range() 方法。该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列。
            //下面样例中，两种方法创建的 Observable 序列都是一样的。
            //使用range()
            _ = Observable.range(start: 1, count: 5)
            //使用of()
            _ = Observable.of(1, 2, 3 ,4 ,5)
        case 7:
            //8，repeatElement() 方法。该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
            _ = Observable.repeatElement(1)
        case 8:
            //9，generate() 方法  该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
            //下面样例中，两种方法创建的 Observable 序列都是一样的。
            //使用generate()方法
            _ = Observable.generate(
                initialState: 0,
                condition: { $0 <= 10 },
                iterate: { $0 + 2 }
            )
            //使用of()方法
            _ = Observable.of(0 , 2 ,4 ,6 ,8 ,10)
        case 9:
            //10，create() 方法  该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。
            //下面是一个简单的样例。为方便演示，这里增加了订阅相关代码（关于订阅我之后会详细介绍的）。
            //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
            //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
            let observable = Observable<String>.create{observer in
                //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
                observer.onNext("hangge.com")
                //对订阅者发出了.completed事件
                observer.onCompleted()
                //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
                return Disposables.create()
            }
            //订阅测试
            observable.subscribe {
                print($0)
            }
        case 10:
            //11，deferred() 方法  该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
            //下面是一个简单的演示样例：
            //用于标记是奇数、还是偶数
            var isOdd = true
            //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
            let factory : Observable<Int> = Observable.deferred {
                //让每次执行这个block时候都会让奇、偶数进行交替
                isOdd = !isOdd
                //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
                if isOdd {
                    return Observable.of(1, 3, 5 ,7)
                }else {
                    return Observable.of(2, 4, 6, 8)
                }
            }
            //第1次订阅测试
            factory.subscribe { event in
                print("\(isOdd)", event)
            }
            //第2次订阅测试
            factory.subscribe { event in
                print("\(isOdd)", event)
            }
        case 11:
            //12，interval() 方法  这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
            //下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
            let observable1 = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            observable1.subscribe { event in
                print(event)
            }
        case 12:
            //13，timer() 方法  这个方法有两种用法，一种是创建的 Observable序列在经过设定的一段时间后，产生唯一的一个元素。
            //5秒种后发出唯一的一个元素0
            let observable2 = Observable<Int>.timer(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            observable2.subscribe { event in
                print(event)
            }
            //（2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
            //延时5秒种后，每隔1秒钟发出一个元素
            let observable3 = Observable<Int>.timer(RxTimeInterval.seconds(5), period: RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            observable3.subscribe { event in
                print(event)
            }
        default:
            print("默认操作")
        }
        
        self.index += 1
        
        
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
