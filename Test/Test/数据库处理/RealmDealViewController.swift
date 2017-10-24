//
//  RealmDealViewController.swift
//  Test
//
//  Created by CSX on 2017/10/23.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit
import RealmSwift

class DataModel: NSObject {
    var nameStr = String()
    var priceStr = Double()
    var timeStr = Date()
}


class RealmDealViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
//    保存数组的懒加载
    lazy var dataArr: NSMutableArray = {
        () -> NSMutableArray in
        let tempdata = NSMutableArray()
        return tempdata
    }()

    //使用默认的数据库
    var realm = try! Realm()
    var tableShow = UITableView()
    
    
    //保存从数据库中查询出来的结果集
    var consumeItems:Results<ConsumeItem>?
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        let model:DataModel = dataArr[indexPath.row] as! DataModel
        cell?.textLabel?.text = model.nameStr + " ¥" + String(model.priceStr) + " " + String(describing: model.timeStr)
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.title = "Realm数据库处理"
        
        createView()
    }

    func createView() {
        let arr = NSArray.init(objects: "创建表","增加数据","删除数据","修改数据","查询数据","增加字段","删除整个表")
        for index in 0..<arr.count {
            let button = UIButton.init(type: .system)
            button.frame = CGRect(x:10,y:74+60*index,width:100,height:50)
            button.setTitle(arr[index] as? String, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.setBackgroundImage(ImageClass .imageWithColor(color: UIColor.lightGray), for: .normal)
            button.tag = 100+index
            button.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        
        tableShow = UITableView.init(frame: CGRect(x:120,y:74+60,width:self.view.frame.size.width-130,height:self.view.frame.size.height-74-60), style: UITableViewStyle.plain)
        tableShow.delegate = self;
        tableShow.dataSource = self;
        tableShow.estimatedRowHeight = 0
        tableShow.estimatedSectionFooterHeight = 0
        tableShow.estimatedSectionHeaderHeight = 0
        self.view.addSubview(tableShow)
        tableShow.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cell")
        
    }
    
    @objc func btnClick(sender:UIButton){
        switch sender.tag-100 {
        case 0:
            do{
//                创建表
                //打印出数据库地址
                print(realm.configuration.fileURL ?? "")
            }
        case 1:
            do{
//               增加数据
              AddData()
            }
        case 2:
            do{
//                删除数据
                
            }
        case 3:
            do{
//               修改数据
                
            }
        case 4:
            do{
//               查询数据
//             selectData()
               
            selectByPredicate()
            }
        case 5:
            do{
//                增加字段
                
            }
        case 6:
            do{
//                删除整个表
                
            }
        default:
            break
        }
    }
    
    
    func AddData() {
//        //查询所有的消费记录
//        let items = realm.objects(ConsumeItem.self)
//        //已经有记录的话就不插入了
//        if items.count>0 {
//            return
//        }
        
        //创建两个消费类型
        let type1 = ConsumeType()
        type1.name = "购物"
        let type2 = ConsumeType()
        type2.name = "娱乐"
        
        //创建三个消费记录
        let item1 = ConsumeItem(value: ["买一台电脑",5999.00,Date(),type1]) //可使用数组创建
        
        let item2 = ConsumeItem()
        item2.name = "看一场电影"
        item2.cost = 30.00
        item2.date = Date(timeIntervalSinceNow: -36000)
        item2.type = type2
        
        let item3 = ConsumeItem()
        item3.name = "买一包泡面"
        item3.cost = 2.50
        item3.date = Date(timeIntervalSinceNow: -72000)
        item3.type = type1
        
        // 数据持久化操作（类型记录也会自动添加的）
        try! realm.write {
            realm.add(item1)
            realm.add(item2)
            realm.add(item3)
        }
    }
    
    
    func selectData() {
       dataArr.removeAllObjects()
        //查询所有的消费记录
       consumeItems = realm.objects(ConsumeItem.self)
//        Realm无法直接限制查询数量。所以我们如果想要查出部分数据（比如前5条记录），也是全部查出来后在结果集中捞取。
        /*
         Realm为何无法限制查询数量？
         通常查询数据库数据时，我们可以在sql语句中添加一些限制语句（比如rownum，limit，top等）来限制返回的结果集的行数。
         但我们使用Realm会发现，它没有这种分页功能，感觉不管查什么都是把所有的结果都捞出来。比如我们只要User表的前10条数据，那么做法是先查询出所有的User数据，再从结果集中取出前10条数据。
         有人可能会担心，如果数据库中数据非常多，那每次都这么查不会影响性能吗？
         其实大可放心，由于Realm都是延迟加载的，只有当属性被访问时，才能够读取相应的数据。不像通常数据库，查询后，查询结果是从数据库拷贝一份出来放在内存中的。而Realm的查询结果应该说是数据库数据的引用，就算你查出来，如果不用也不会占用什么内存。
         */
//        查询前N条数据方式：第一种，将arr.count替换为你想筛选的N
        for item in consumeItems! {
            let model = DataModel()
            model.nameStr = item.name
            model.priceStr = item.cost
            model.timeStr = item.date
            dataArr.add(model)
        }
        tableShow.reloadData()
    }
    
    
//  支持断言查询(Predicate)，这样可以通过条件查询特定数据 ,同时可以使用链式查询数据。
    func selectByPredicate() {
         dataArr.removeAllObjects()
        //查询花费超过10元的消费记录(使用断言字符串查询)
        consumeItems = realm.objects(ConsumeItem.self).filter("cost > 10")
        
        //查询花费超过10元的购物记录(使用 NSPredicate 查询)
        let predicate = NSPredicate(format: "type.name = '购物' AND cost > 10")
        consumeItems = realm.objects(ConsumeItem.self).filter(predicate)
        
        //使用链式查询
        consumeItems = realm.objects(ConsumeItem.self).filter("cost > 10").filter("type.name = '购物'")
        
        
        /*
         支持的断言：
         比较操作数(comparison operand)可以是属性名称或者某个常量，但至少有一个操作数必须是属性名称；
         比较操作符 ==、<=、<、>=、>、!=, 以及 BETWEEN 支持 int、long、long long、float、double 以及 NSDate 属性类型的比较，比如说 age == 45；
         相等比较 ==以及!=，比如说Results<Employee>().filter("company == %@", company)
         比较操作符 == and != 支持布尔属性；
         对于 NSString 和 NSData 属性来说，我们支持 ==、!=、BEGINSWITH、CONTAINS 以及 ENDSWITH 操作符，比如说 name CONTAINS ‘Ja’；
         字符串支持忽略大小写的比较方式，比如说 name CONTAINS[c] ‘Ja’ ，注意到其中字符的大小写将被忽略；
         Realm 支持以下复合操作符：“AND”、“OR” 以及 “NOT”。比如说 name BEGINSWITH ‘J’ AND age >= 32；
         包含操作符 IN，比如说 name IN {‘Lisa’, ‘Spike’, ‘Hachi’}；
         ==、!=支持与 nil 比较，比如说 Results<Company>().filter("ceo == nil")。注意到这只适用于有关系的对象，这里 ceo 是 Company 模型的一个属性。
         ANY 比较，比如说 ANY student.age < 21
         注意，虽然我们不支持复合表达式类型(aggregate expression type)，但是我们支持对对象的值使用 BETWEEN 操作符类型。比如说，Results<Person>.filter("age BETWEEN %@", [42, 43]])。
         */
        
        
        
//        ，查询结果的排序
        //查询花费超过10元的消费记录,并按升序排列
        consumeItems = realm.objects(ConsumeItem.self).filter("cost > 10").sorted(byKeyPath: "cost")
        
        for item in consumeItems! {
            let model = DataModel()
            model.nameStr = item.name
            model.priceStr = item.cost
            model.timeStr = item.date
            dataArr.add(model)
        }
        tableShow.reloadData()
    }
    
    
    
    
    
    //MARK:使用List实现一对多关系
   
    func ListForUse() {
    
        let aDog = ["小黑", 5] as [Any]
        let anotherDog = ["旺财", 6] as [Any]
    
        // 这里我们就可以使用已存在的狗狗对象来完成初始化
        let ZhangSan = Person(value: ["李四", 30, [aDog, anotherDog]])
        
        // 还可以使用多重嵌套
        let LiSi = Person(value: ["李四", 30, [["小黑", 5], ["旺财", 6]]])
        
//        可以和之前一样，对 List 属性进行访问和赋值：
        let someDogs = realm.objects(Dog.self).filter("name contains '小白'")
        ZhangSan.dogs.append(objectsIn: someDogs)
        let dahuang = Dog()
        dahuang.name = "大黄"
        ZhangSan.dogs.append(dahuang)
    }
    
    
    
    
    
    
//    修改数据
    func updateDateForNew() {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}







