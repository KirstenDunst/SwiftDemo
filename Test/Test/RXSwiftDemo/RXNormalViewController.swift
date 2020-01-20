//
//  RXNormalViewController.swift
//  Test
//
//  Created by 曹世鑫 on 2020/1/20.
//  Copyright © 2020 宗盛商业. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

class RXNormalViewController: UIViewController {
    private var dataArr : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "RxSwift学习"
        loadData()
        createUI()
    }
    
    private func loadData() {
        let jsonData = NSData(contentsOfFile: Bundle.main.path(forResource: "content", ofType: "json")!)
        let jsonString = NSString(data:jsonData! as Data,encoding: String.Encoding.utf8.rawValue)
        if let mappedObject = JSONDeserializer<TotalModel<ListModel>>.deserializeFrom(json: jsonString as String?) { // 从字符串转换为对象实例
            dataArr = NSArray.init(array: mappedObject.data)
        }
    }
    
    private func createUI() {
        view.addSubview(swiftTabel)
        swiftTabel.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(view)
        }
    }
    
    
    lazy var swiftTabel : UITableView = {
        let tabel = UITableView.init()
        tabel.delegate = self
        tabel.dataSource = self
        tabel.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tabel
    }()
}

extension RXNormalViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = dataArr[indexPath.row] as! ListModel
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row] as! ListModel
        if (model.vcClassStr as NSString).length > 0 {
            let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"]
            let childVcClass : AnyClass = NSClassFromString((nameSpage as! String) + "." + model.vcClassStr)!
            guard let childVcType = childVcClass as? UIViewController.Type else {
                print("没有得到的控制器类型")
                return
            }
            let model = dataArr[indexPath.row] as! ListModel
            let vc = childVcType.init()
            vc.title = model.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

