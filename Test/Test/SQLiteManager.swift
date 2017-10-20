//
//  SQLiteManager.swift
//  Test
//
//  Created by CSX on 2017/10/19.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {

    static let sharInstance:SQLiteManager = SQLiteManager()
    
    func database()->FMDatabase{
        //获取沙盒路径
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        path = path + "/swiftLearn.sqlite"
        //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
        print("数据库user.sqlite 的路径===" + path)
        return FMDatabase.init(path:path)
    }
   
    
    /// 创建表格
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - content: 表字段:表属性   样式的字典
   func createTableWithContent(tableName:String,content:NSDictionary) -> Bool {
        let db = database()
        if db.open() {
            var sql = "CREATE TABLE IF NOT EXISTS " + tableName + "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            
            let arFieldsKey:[String] = content.allKeys as! [String]
            let arFieldsType:[String] = content.allValues as! [String]
            for i in 0..<arFieldsType.count {
                if i != arFieldsType.count-1{
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] + ", "
                }else{
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] +  ")"
                }
            }
            do {
                try db.executeUpdate(sql, values: nil)
                print("数据库创建======" + tableName + "创建成功")
            }catch{
                print(">>>>>>>>>>" + db.lastErrorMessage())
                return false
            }
        }
        db.close()
        
        return true
    }
    
    //MARK: - 添加数据
    /// 插入数据
    ///
    /// - Parameters:
    ///   - tableName: 表名字
    ///   - dicFields: key为表字段，value为对应的字段值
    func HQBInsertDataToTable(tableName:String,dicFields:NSDictionary){
        let db = database()
        if db.open() {
            let arFieldsKeys:[String] = dicFields.allKeys as! [String]
            let arFieldsValues:[Any] = dicFields.allValues
            var sqlUpdatefirst = "INSERT INTO '" + tableName + "' ("
            var sqlUpdateLast = " VALUES("
            for i in 0..<arFieldsKeys.count {
                if i != arFieldsKeys.count-1 {
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ","
                    sqlUpdateLast = sqlUpdateLast + "?,"
                }else{
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ")"
                    sqlUpdateLast = sqlUpdateLast + "?)"
                }
            }
            do{
                try db.executeUpdate(sqlUpdatefirst + sqlUpdateLast, values: arFieldsValues)
                print("数据库操作==== 添加数据成功！")
                
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
    }

    
    //MARK: - 修改数据
    /// 修改数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - dicFields: key为表字段，value为要修改的值
    ///   - ConditionsKey: 过滤筛选的字段
    ///   - ConditionsValue: 过滤筛选字段对应的值
    /// - Returns: 操作结果 true为成功，false为失败
    func HQBModifyToData(tableName:String , dicFields:NSDictionary ,ConditionsKey:String ,ConditionsValue :Int)->(Bool){
        var result:Bool = false
        let arFieldsKey : [String] = dicFields.allKeys as! [String]
        var arFieldsValues:[Any] = dicFields.allValues
        arFieldsValues.append(ConditionsValue)
        var sqlUpdate  = "UPDATE " + tableName +  " SET "
        for i in 0..<dicFields.count {
            if i != arFieldsKey.count - 1 {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?,"
            }else {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?"
            }
            
        }
        sqlUpdate = sqlUpdate + " WHERE " + ConditionsKey + " = ?"
        let db = database()
        if db.open() {
            do{
                try db.executeUpdate(sqlUpdate, values: arFieldsValues)
                print("数据库操作==== 修改数据成功！")
                result = true
            }catch{
                print(db.lastErrorMessage())
            }
        }
        return result
    }
    
    
    //MARK: - 查询数据
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - arFieldsKey: 要查询获取的表字段
    /// - Returns: 返回相应数据
    func HQBSelectFromTable(tableName:String,arFieldsKey:NSArray)->([NSMutableDictionary]){
        let db = database()
        let dicFieldsValue :NSMutableDictionary = [:]
        var arFieldsValue = [NSMutableDictionary]()
        let sql = "SELECT * FROM " + tableName
        if db.open() {
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    for i in 0..<arFieldsKey.count {
                        dicFieldsValue.setObject(rs.string(forColumn: arFieldsKey[i] as! String), forKey: arFieldsKey[i] as! NSCopying)
                    }
                    arFieldsValue.append(dicFieldsValue)
                }
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
        return arFieldsValue
    }
    
    
    
    //MARK: - 删除数据
    /// 删除数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - FieldKey: 过滤的表字段
    ///   - FieldValue: 过滤表字段对应的值
    func HQBDeleteFromTable(tableName:String,FieldKey:String,FieldValue:Any) {
        let db = database()        
        if db.open() {
            let  sql = "DELETE FROM '" + tableName + "' WHERE " + FieldKey + " = ?"
            
            do{
                try db.executeUpdate(sql, values: [FieldValue])
                print("删除成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
    
//    删除整个表格
    func HQBDropTable(tableName:String) {
        let db = database()
        if db.open() {
            let  sql = "DROP TABLE " + tableName
            do{
                try db.executeUpdate(sql, values: nil)
                print("删除表格成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
        
    }
    
   
    

    
    
//    上面是FMDB的基本操作，因为之前有人曾经问过，假如我要改变数据库的结构譬如：在已有的表中添加新字段？我当时的思路是通过创建临时表把旧表的数据导入，接着建新表数据导回去。后面发现这个比较繁琐，其实可以直接加的。
    
//    下面先讲第一种思路：(这里我个人不推荐)
//    /// 新增加表字段
//    ///   原理：
//    ///     修改表名，新建表，将数据从新插入
//    /// - Parameters:
//    ///   - tableName:表名称
//    ///   - newField: 新增表字段
//    ///   - dicFieldsAndType: 新表的全部字段 和字段对应的属性
//    func HQBChangTable(tableName:String,newField:String, arFields:NSArray, arFieldsType:NSArray){
//        let db = database()
//        if db.open() {
//            if !db.columnExists(newField, inTableWithName: tableName) {
//                //修改表明
//                let  sql = "ALTER TABLE '" + tableName + "' RENAME TO 'old_Table'"
//                do{
//                    try db.executeUpdate(sql, values: nil)
//                    //创建表
//                    createTableWithContent(tableName: tableName, content: <#T##NSDictionary#>)
//                    //导入数据数据
//                    HQBImportData(oldTableName: "old_Table", newTableName: tableName)
//                    //删除旧表
//                    HQBDropTable(tableName: "old_Table")
//                }catch{
//                    print(db.lastErrorMessage())
//                }
//            }
//        }
//    }
////     创建表，和删除表的方法上面用，下面是导入数据的方法：
//    /// 导入数据
//    ///
//    /// - Parameters:
//    ///   - oldTableName: 临时表名
//    ///   - newTableName: 原表明（增加字段的表明）
//    func  HQBImportData(oldTableName:String,newTableName:String)  {
//        let  db = database()
//        if db.open() {
//            let sql = "INSERT INTO " + newTableName + " SELECT  id,usedName, date, age, phone, ''  FROM " + oldTableName
//            do{
//                try db.executeUpdate(sql, values: nil)
//            }catch{
//                print(db.lastErrorMessage())
//            }
//        }
//
//    }
    
//    第二种思路：接下来就是我说的直接增加字段就可以了：
    /// 新增加表字段
    ///
    /// - Parameter tableName: 表名
    func HQBChangeTableWay1(tableName:String , addField:String,addFieldType:String)  {
        let db = database()
        if db.open() {
            let sql  = "ALTER TABLE " + tableName + " ADD " + addField + addFieldType
            do{
                try db.executeUpdate(sql, values: nil)
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
