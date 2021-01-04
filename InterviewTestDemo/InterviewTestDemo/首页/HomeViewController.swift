//
//  ViewController.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit

class HomeViewController: UIViewController {
    
    var dataSource: [String:String] = [:]
    let tableView = UITableView()
    var timer: Timer?
    var loadHistory = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "数据"
        
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UrlAppearenceTableCell.self, forCellReuseIdentifier: "UrlAppearenceTableCellId")
        
        self.configRightBarButtomItem()
        
        if let list = UserDefaults.standard.array(forKey: "historyRecoder") as? [String] {
            self.loadHistory = list
            let lastDateStr = list.last!
            if let data = UserDefaults.standard.dictionary(forKey: lastDateStr) as? [String:String] {
                self.dataSource = data
                self.tableView.reloadData()
            }
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5)) {
                [weak self] in
                guard let weakSelf = self  else { return }
                weakSelf.loadGithubData()
            }
        }
    }
    func configRightBarButtomItem(){
        let rightItem = UIButton()
        rightItem.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightItem.normalTitle("历史记录").normalTitleColor(black).font(14.plain())
        rightItem.addTarget(self, action: #selector(self.checkoutHistory), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = timer {
            timer?.invalidate()
            timer = nil
        }
    }
    func addTimer(){
        timer = Timer(timeInterval: 5, target: self, selector: #selector(self.loadData), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    @objc func loadData(){
        print("timer:++++")
        loadGithubData()
    }
    @objc func checkoutHistory(){
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    func loadGithubData(){
        HttpTool.instance.getJson(endpoint: endpoint) {[weak self] (json) in
            guard let weakSelf = self else { return }
            if let jsonData = json as? [String:String] {
                weakSelf.setLoadHistoryRecord(jsonData)
                weakSelf.dataSource = jsonData
                weakSelf.tableView.reloadData()
            }
        }
    }
    func setLoadHistoryRecord(_ dict: [String: String]){
        let current = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateStr = fmt.string(for: current) else { return }
        loadHistory.append(dateStr)
        UserDefaults.standard.set(loadHistory, forKey: "historyRecoder")
        UserDefaults.standard.set(dict, forKey: dateStr)
        UserDefaults.standard.synchronize()
    }

}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UrlAppearenceTableCellId", for: indexPath) as? UrlAppearenceTableCell
        let (titles,details) = (Array(dataSource.keys),Array(dataSource.values))
        let (title,detail) = (titles[indexPath.row],details[indexPath.row])
        cell!.update(title: title,detail: detail)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
