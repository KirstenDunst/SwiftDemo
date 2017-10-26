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
//               根据断言查询，以及排序
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
//        1.直接更新内容
        // 在一个事务中更新对象
        let consumeItem = ConsumeItem()
        consumeItem.name = "买一包泡面"
        consumeItem.cost = 2.50
        consumeItem.date = Date(timeIntervalSinceNow: -72000)
        consumeItem.type = ConsumeType(value: "购物")
        try! realm.write {
            consumeItem.name = "去北京旅行"
        }
        
        
//        2.通过主键更新
//        如果您的数据模型中设置了主键的话，那么您可以使用 Realm().add(_:update:) 来更新对象（当对象不存在时也会自动插入新的对象。）
        /****** 方式1 ***/
        // 创建一个带有主键的“书籍”对象，作为事先存储的书籍
        let cheeseBook = Book()
        cheeseBook.title = "奶酪食谱"
        cheeseBook.price = 9000
        cheeseBook.id = 1
        
        // 通过 id = 1 更新该书籍
        try! realm.write {
            realm.add(cheeseBook, update: true)
        }
        
        /****** 方式2 ***/
        // 假设带有主键值 `1` 的“书籍”对象已经存在
        try! realm.write {
            realm.create(Book.self, value: ["id": 1, "price": 22], update: true)
            // 这本书的`title`属性不会被改变
        }
        
        
        
//       3.键值编码
//        这个是在运行时才能决定哪个属性需要更新的时候，这个对于大量更新的对象极为有用。
        let persons = realm.objects(Person.self)
        try! realm.write {
            // 更新第一个
            persons.first?.setValue(true, forKeyPath: "isFirst")
            // 将每个人的 planet 属性设置为“地球”
            persons.setValue("地球", forKeyPath: "planet")
        }
        
        
    }
    
   
    
    
//    删除数据
    func DeleteData() {
        
        let cheeseBook = Book()  // 存储在 Realm 中的 Book 对象
//        cheeseBook.title = "奶酪食谱"
//        cheeseBook.price = 9000
//        cheeseBook.id = 1
        
        // 在事务中删除一个对象
        try! realm.write {
            realm.delete(cheeseBook)
        }
        
//        也能够删除数据库中的所有数据
        
        // 从 Realm 中删除所有数据
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    
    
    
//    Realm数据库配置
    
    /*
     （1）修改默认的的数据库
     通过调用 Realm() 来初始化以及访问我们的 realm 变量。其指向的是应用的 Documents 文件夹下的一个名为“default.realm”的文件。
     通过对默认配置进行更改，我们可以使用不同的数据库。比如给每个用户帐号创建一个特有的 Realm 文件，通过切换配置，就可以直接使用默认的 Realm 数据库来直接访问各自数据库：
     */
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(username).realm")
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
    
    /*
     (2）打包进项目里的数据库的使用
     如果需要将应用的某些数据（比如配置信息，初始化信息等）打包到一个 Realm 文件中，作为主要 Realm 数据库的扩展，操作如下：
     */
    func localDatabaseForUse() {
        let config = Realm.Configuration(
            // 获取需要打包文件的 URL 路径
            fileURL: Bundle.main.url(forResource: "MyBundledData", withExtension: "realm"),
            // 以只读模式打开文件，因为应用数据包并不可写
            readOnly: true)
        
        // 通过配置打开 Realm 数据库
        let realm = try! Realm(configuration: config)
        
        // 通过配置打开 Realm 数据库
        let results = realm.objects(Dog.self).filter("age > 5")
    }
    
    /*
     （3）内存数据库
     内存数据库在每次程序运行期间都不会保存数据。但是，这不会妨碍到 Realm 的其他功能，包括查询、关系以及线程安全。 假如您需要灵活的数据读写但又不想储存数据的话，那么内存数据库对您来说一定是一个不错的选择。
     */
//    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
    
    
    
    
   
//    加密数据库
    /*
     （1）加密后的 Realm文件不能跨平台使用（因为 NSFileProtection 只有 iOS 才可以使用）
     （2）Realm 文件不能在没有密码保护的 iOS 设备中进行加密。为了避免这些问题（或者您想构建一个 OS X 的应用），可以使用 Realm 提供的加密方法。
     （3）加密过的 Realm 只会带来很少的额外资源占用（通常最多只会比平常慢10%）。
     */
    func encryptionData() {
        /*****   在创建 Realm 数据库时采用64位的密钥对数据库文件进行 AES-256+SHA2 加密   ****/
        // 产生随机密钥
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        
        // 打开加密文件
        let config = Realm.Configuration(encryptionKey: key)
        let realm:Realm
        do {
            realm = try Realm(configuration: config)
        } catch let error as NSError {
            // 如果密钥错误，`error` 会提示数据库不可访问
            fatalError("Error opening realm: \(error)")
        }
        
        // 和往常一样使用 Realm 即可
        let dogs = realm.objects(Book.self).filter("name contains 'Fido'")
    }
    
    
    
    
    
    
//    数据库迁移(Migration)
    /*
     （1）为何要迁移
     
     比如原来有如下 Person 模型：
     class Person: Object {
     @objc dynamic var firstName = ""
     @objc dynamic var lastName = ""
     @objc dynamic var age = 0
     }
     
     假如我们想要更新数据模型，给它添加一个 fullname 属性， 而不是将“姓”和“名”分离开来。
     class Person: Object {
     @objc dynamic var fullName = ""
     @objc dynamic var age = 0
     }
     在这个时候如果您在数据模型更新之前就已经保存了数据的话，那么 Realm 就会注意到代码和硬盘上数据不匹配。 每当这时，您必须进行数据迁移，否则当您试图打开这个文件的话 Realm 就会抛出错误。
     
     */
    
    
    /*
     （2）如何进行数据迁移
     假设我们想要把上面所声明 Person 数据模型进行迁移。如下所示是最简单的数据迁移的必需流程：
     */
    
//    func DataMigration() {
//        // 在(application:didFinishLaunchingWithOptions:)中进行配置
//
//        let config = Realm.Configuration(
//            // 设置新的架构版本。这个版本号必须高于之前所用的版本号
//            // （如果您之前从未设置过架构版本，那么这个版本号设置为 0）
//            schemaVersion: 1,
//
//            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
//            migrationBlock: { migration, oldSchemaVersion in
//                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
//                if (oldSchemaVersion < 1) {
//                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
//                }
//        })
//
//        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
//        Realm.Configuration.defaultConfiguration = config
//
//        // 现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
//        let realm = try! Realm()
//    }
    
    
    /*
     虽然这个迁移操作是最精简的了，但是我们需要让这个闭包能够自行计算新的属性（这里指的是 fullName），这样才有意义。 在迁移闭包中，我们能够调用Migration().enumerateObjects(_:_:) 来枚举特定类型的每个 Object 对象，然后执行必要的迁移逻辑。注意，对枚举中每个已存在的 Object 实例来说，应该是通过访问 oldObject 对象进行访问，而更新之后的实例应该通过 newObject 进行访问：
     */
    
//    // 在 application(application:didFinishLaunchingWithOptions:) 中进行配置
//
//    Realm.Configuration.defaultConfiguration = Realm.Configuration(
//    schemaVersion: 1,
//    migrationBlock: { migration, oldSchemaVersion in
//    if (oldSchemaVersion < 1) {
//    // enumerateObjects(ofType:_:) 方法遍历了存储在 Realm 文件中的每一个“Person”对象
//    migration.enumerateObjects(ofType: Person.className()) { oldObject, newObject in
//    // 将名字进行合并，存放在 fullName 域中
//    let firstName = oldObject!["firstName"] as! String
//    let lastName = oldObject!["lastName"] as! String
//    newObject!["fullName"] = "\(firstName) \(lastName)"
//    }
//    }
//    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    21，使用带有 REST API 功能的 Realm 数据库示例
    
    /*
     我们将从 豆瓣FM的API 那里获取一组 JSON 格式的频道数据，然后将它以 Realm Objects 的形式储存到默认的 Realm 数据库里。
     */
//     （1）json数据格式如下：
    /*
     {
     "channels": [
     {
     "name_en": "Personal Radio",
     "seq_id": 0,
     "abbr_en": "My",
     "name": "私人兆赫",
     "channel_id": 0
     },
     {
     "name": "华语",
     "seq_id": 0,
     "abbr_en": "",
     "channel_id": "1",
     "name_en": ""
     },
     {
     "name": "欧美",
     "seq_id": 1,
     "abbr_en": "",
     "channel_id": "2",
     "name_en": ""
     }
     ]
     }
     */
    
    /*
     （2）我们将直接把 Dictionary 插入到 Realm 中，然后让 Realm 自行快速地将其映射到 Object 上。
     （从 iOS9 起，新特性要求App访问网络请求，要采用 HTTPS 协议。直接请求HTTP数据会报错，解决办法可以参照的我另一篇文章：Swift - 网络请求报App Transport Security has blocked a cleartext错）
     为了确保示例能够成功，我们需要一个所有属性完全匹配 JSON 键结构的 Object 结构体。如果 JSON 的键结构不匹配 Object 结构体属性结构的话，那么就会在插入时被忽略。
     */
    /*
     import UIKit
     import RealmSwift
     
     class ViewController: UIViewController {
     
     override func viewDidLoad() {
     super.viewDidLoad()
     
     // 调用API
     let url = URL(string: "http://www.douban.com/j/app/radio/channels")!
     let response = try! Data(contentsOf: url)
     
     // 对 JSON 的回应数据进行反序列化操作
     let json = try! JSONSerialization.jsonObject(with: response,
     options: .allowFragments) as! [String:Any]
     let channels = json["channels"] as! [[String:Any]]
     
     let realm = try! Realm()
     try! realm.write {
     // 为数组中的每个元素保存一个对象（以及其依赖对象）
     for channel in channels {
     if channel["seq_id"] as! Int == 0 {continue} //第一个频道数据有问题,丢弃掉
     realm.create(DoubanChannel.self, value: channel, update: true)
     }
     }
     
     print(realm.configuration.fileURL ?? "")
     }
     
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     }
     }
     
     //豆瓣频道
     class DoubanChannel:Object {
     //频道id
     @objc dynamic var channel_id = ""
     //频道名称
     @objc dynamic var name = ""
     //频道英文名称
     @objc dynamic var name_en = ""
     //排序
     @objc dynamic var seq_id = 0
     @objc dynamic var abbr_en = ""
     
     //设置主键
     override static func primaryKey() -> String? {
     return "channel_id"
     }
     }
     */
//    （3）可以看到数据已经成功插入到库中了
    
    
    
    
    
    
    
    
    
    /*
     22，当前版本的限制
     Realm 致力于平衡数据库读取的灵活性和性能。为了实现这个目标，在 Realm 中所存储的信息的各个方面都有基本的限制。例如：
     （1）类名称的长度最大只能存储 57 个 UTF8 字符。
     （2）属性名称的长度最大只能支持 63 个 UTF8 字符。
     （3）NSData 以及 String 属性不能保存超过 16 MB 大小的数据。如果要存储大量的数据，可通过将其分解为16MB 大小的块，或者直接存储在文件系统中，然后将文件路径存储在 Realm 中。如果您的应用试图存储一个大于 16MB 的单一属性，系统将在运行时抛出异常。
     （4）对字符串进行排序以及不区分大小写查询只支持“基础拉丁字符集”、“拉丁字符补充集”、“拉丁文扩展字符集 A” 以及”拉丁文扩展字符集 B“（UTF-8 的范围在 0~591 之间）。
     */
    
    
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}







