//
//  DataBaseViewController.swift
//  Test
//
//  Created by CSX on 2017/10/9.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit

class DataBaseViewController: UIViewController {

    var sqlManage = SQLiteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Realm数据库处理"
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        
//        创建基本ui样式布局
        createDataTool()
    }

    func createDataTool() {
        let arr = NSArray.init(objects: "创建表","增加数据","删除数据","修改数据","查询数据","增加字段")
        for index in 0..<arr.count {
            let button = UIButton.init(type: .system)
            button.frame = CGRect(x:10,y:74+60*index,width:100,height:50)
            button.setTitle(arr[index] as? String, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.setBackgroundImage(ImageClass .imageWithColor(color: UIColor.lightGray), for: .normal)
            button.tag = 50+index
            button.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }
    
    
    @objc func btnClick(sender:UIButton) {
        switch sender.tag-50 {
        case 0:
            do{
//                创建表
                createTable()
            }
        case 1:
            do{
//                增加数据
                addTableData()
            }
        case 2:
            do{
//                删除数据
               deleteTableData()
            }
        case 3:
            do{
//                修改数据
                updateTableData()
            }
        case 4:
            do{
//                查询数据
                queryTableData()
            }
        case 5:
            do{
//                增加字段
                addTypeData()
            }
        default:
            break
        }
    }
    
//    创建表
    func createTable() {
        let isSuccess = sqlManage.createTableWithContent(tableName: "CeShi", content: NSDictionary.init(objects: ["name","age"], forKeys: ["text" as NSCopying,"integer" as NSCopying]))
        print("创建表的结果：")
        print(isSuccess)
    }
    
    
//    增加数据
    func addTableData() {
        sqlManage
    }
    
    
//    删除数据
    func deleteTableData() {
        
    }
    
    
//    修改数据
    func updateTableData() {
        
    }
    
    
//    查询数据
    func queryTableData() {
        
    }
    
    
//    增加字段
    func addTypeData() {
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
