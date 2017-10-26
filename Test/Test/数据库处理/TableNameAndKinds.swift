//
//  TableNameAndKinds.swift
//  Test
//
//  Created by CSX on 2017/10/23.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import Foundation
import RealmSwift

//本文件创建： New File ------>  Swift File ------->自己命名一个文件名


//消费类型
class ConsumeType:Object {
    //类型名
    @objc dynamic var name = ""
}

//消费条目
class ConsumeItem:Object {
    //条目名
    @objc dynamic var name = ""
    //金额
    @objc dynamic var cost = 0.00
    //时间
    @objc dynamic var date = Date()
    //所属消费类别
    @objc dynamic var type:ConsumeType?
}


 //MARK:使用List实现一对多关系
/*
 使用List实现一对多关系
 List 中可以包含简单类型的 Object，表面上和可变的 Array 非常类似。
 注意：List 只能够包含 Object 类型，不能包含诸如String之类的基础类型。
 如果打算给我们的 Person 数据模型添加一个“dogs”属性，以便能够和多个“dogs”建立关系，也就是表明一个 Person 可以有多个 Dog，那么我们可以声明一个List类型的属性：
 */
class Person: Object {
    //名字
    @objc dynamic var name = ""
    //年龄
    @objc dynamic var age = 0
    //    ... // 其余的属性声明
    let dogs = List<Dog>()
}


//MARK:反向关系(Inverse Relationship)
/*
 反向关系(Inverse Relationship)
 通过反向关系(也被称为反向链接(backlink))，您可以通过一个特定的属性获取和给定对象有关系的所有对象。 Realm 提供了“链接对象 (linking objects)” 属性来表示这些反向关系。借助链接对象属性，您可以通过指定的属性来获取所有链接到指定对象的对象。
 例如，一个 Dog 对象可以拥有一个名为 owners 的链接对象属性，这个属性中包含了某些 Person 对象，而这些 Person 对象在其 dogs 属性中包含了这一个确定的 Dog 对象。您可以将 owners 属性设置为 LinkingObjects 类型，然后指定其关系，说明其当中包含了 Person 对象。
 */
class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0

    // Realm 并不会存储这个属性，因为这个属性只定义了 getter
    // 定义“owners”，和 Person.dogs 建立反向关系
    let owners = LinkingObjects(fromType: Person.self, property: "dogs")
}




//MARK:添加主键(Primary Keys)
/*
 添加主键(Primary Keys)
 重写 Object.primaryKey() 可以设置模型的主键。
 声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性。
 一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
 */
class PersonOne: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}



//MARK:添加索引属性(Indexed Properties)
/*
 添加索引属性(Indexed Properties)
 重写 Object.indexedProperties() 方法可以为数据模型中需要添加索引的属性建立索引：
 */
class Book: Object {
    @objc dynamic var id = 0
    @objc dynamic var price = 0
    @objc dynamic var title = ""
    
    override static func indexedProperties() -> [String] {
        return ["title"]
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}





//MARK:设置忽略属性(Ignored Properties)
/*
 设置忽略属性(Ignored Properties)
 重写 Object.ignoredProperties() 可以防止 Realm 存储数据模型的某个属性。Realm 将不会干涉这些属性的常规操作，它们将由成员变量(var)提供支持，并且您能够轻易重写它们的 setter 和 getter。
 */
class PersonTwo: Object {
    @objc dynamic var tmpID = 0
    var name: String { // 计算属性将被自动忽略
        return "\(firstName) \(lastName)"
    }
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    
    override static func ignoredProperties() -> [String] {
        return ["tmpID"]
    }
}

















