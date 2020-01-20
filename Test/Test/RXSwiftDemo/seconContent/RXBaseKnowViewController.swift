//
//  RXBaseKnowViewController.swift
//  SwiftTest
//
//  Created by 曹世鑫 on 2019/12/20.
//  Copyright © 2019 曹世鑫. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXBaseKnowViewController: UIViewController {
    //这里需要统一使用定义，单独使用的时候实例化会加载不出来
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        loadData()
    }
    
    private func loadData() {
        musicViewModel.data.bind(to: tableView.rx.items) {(table,row,model) -> UITableViewCell in
            let cell = table.dequeueReusableCell(withIdentifier: "musicCell")
            cell?.textLabel?.text = model.name
            cell?.detailTextLabel?.text = model.singer
            return cell!
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { (indexPath) in
            print("itemSelect触发的cell点击\(indexPath)")
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { (music) in
            print("你选中的歌曲信息：\(music)")
        }).disposed(by: disposeBag)
    }
    
    
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        tab.tableFooterView = UIView()
        return tab
    }()
    lazy var musicViewModel: MusicListViewModel = {
        let model = MusicListViewModel()
        return model
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


struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "歌曲1", singer: "陈奕迅"),
        Music(name: "歌曲2", singer: "歌手2"),
        Music(name: "歌曲3", singer: "歌手3"),
        Music(name: "歌曲4", singer: "歌手4")
    ])
}


//歌曲结构体，model
struct Music {
    let name : String //歌名
    let singer : String //演唱者
    
    init(name : String, singer : String) {
        self.name = name
        self.singer = singer
    }
}

//实现CustomStringConvertible协议，方便调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name: \(name) singer: \(singer)"
    }
}

