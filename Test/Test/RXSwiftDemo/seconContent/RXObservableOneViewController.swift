//
//  RXObservableOneViewController.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2020/1/19.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RXObservableOneViewController: UIViewController {
    let  disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //直接在 subscribe、bind 方法中创建观察者
        //1.就是之前的subscribe(onNext:）来订阅的信号处理
        
        view.addSubview(label)
        //2.在 bind 方法中创建
        //下面代码我们创建一个定时生成索引数的 Observable 序列，并将索引数不断显示在 label 标签上：
        //Observable序列（每隔一秒发出一个索引数）
        let observable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable.map { (number) -> String in
            return "当前索引数：\(number)"
        }.bind {[weak self] (text) in
            self?.label.text = text
        }.disposed(by: disposeBag)
        
        
        
        
        
        
        //使用 AnyObserver 创建观察者
        //AnyObserver 可以用来描叙任意一种观察者。
        /*
         1，配合 subscribe 方法使用
         比如上面第一个样例我们可以改成如下代码：
         **/
        let observer: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print("错误信息：" + error.localizedDescription)
            case .completed:
                print("发送完毕")
            }
        }
        let observable1 = Observable.of("A","B","C")
        observable1.subscribe(observer).disposed(by: disposeBag)
        /*
         2，配合 bindTo 方法使用
         **/
        let observable2 = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable2.map { (number) -> String in
            return "当前索引数\(number)"
        }.bind(to: observer).disposed(by: disposeBag)
        
        
        
        
        
        //使用 Binder 创建观察者
        /*1，基本介绍
        （1）相较于AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：

        不会处理错误事件
        确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
        （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。

        2，使用样例
        （1）在上面序列数显示样例中，label 标签的文字显示就是一个典型的 UI 观察者。它在响应事件时，只会处理 next 事件，而且更新 UI 的操作需要在主线程上执行。那么这种情况下更好的方案就是使用 Binder。

        （2）上面的样例我们改用 Binder 会简单许多：
        */
        view.addSubview(labelOne)
        let observerOne: Binder<String> = Binder(labelOne) { (view, text) in
            //收到索引数后显示在label上
            view.text = text
        }
        //Observable序列（每个一秒钟发出一个索引数）
        let observable3 = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable3.map { (number) -> String in
            return "当前索引数：\(number)"
            }.bind(to: observerOne).disposed(by: disposeBag)
        
        
    }

    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 150, height: 50))
        return label
    }()
    lazy var labelOne: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 200, width: 150, height: 50))
        return label
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
