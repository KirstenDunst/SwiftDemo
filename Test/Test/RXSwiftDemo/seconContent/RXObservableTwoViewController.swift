//
//  RXObservableTwoViewController.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2020/1/20.
//  Copyright © 2020 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXObservableTwoViewController: UIViewController {
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        /*自定义可绑定属性
        有时我们想让 UI 控件创建出来后默认就有一些观察者，而不必每次都为它们单独去创建观察者。比如我们想要让所有的 UIlabel 都有个 fontSize 可绑定属性，它会根据事件值自动改变标签的字体大小。
        */
        view.addSubview(titleLabel)
        
        //这里我们通过对 UILabel 进行扩展，增加了一个fontSize 可绑定属性。
        let observable = Observable<Int>.interval(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        observable.map { (number) -> CGFloat in
            return CGFloat(number)
            //根据索引字号不断变大
            }.bind(to: titleLabel.fontSize).disposed(by: disposeBag)
        
        
        
        //我们也可以直接使用rxswift给我们提供好的扩展属性使用
        let observableOne = Observable<Int>.interval(RxTimeInterval.seconds(Int(0.5)), scheduler: MainScheduler.instance)
        observableOne.map { (number) -> String in
            return "当前索引数：\(number)"
            }.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        
        
        
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        label.backgroundColor = .cyan
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

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { (label, fontSize) in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
