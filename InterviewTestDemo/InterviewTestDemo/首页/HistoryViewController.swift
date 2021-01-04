//
//  HistoryViewController.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let tableView = UITableView()
    var historyRecoder: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "历史记录"
       
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.register(UrlAppearenceTableCell.self, forCellReuseIdentifier: "UrlAppearenceTableCellId")
        self.loadHistoryRecord()
    }

    func loadHistoryRecord(){
        if let list = UserDefaults.standard.array(forKey: "historyRecoder") as? [String] {
            self.historyRecoder = list
            self.tableView.reloadData()
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyRecoder.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UrlAppearenceTableCellId", for: indexPath) as? UrlAppearenceTableCell
        cell!.update(title: "调用数据时间记录",detail: historyRecoder[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


