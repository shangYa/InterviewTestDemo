//
//  UrlAppearenceTableCell.swift
//  InterviewTestDemo
//
//  Created by NewApple on 2021/1/4.
//

import UIKit
import SnapKit
class UrlAppearenceTableCell: UITableViewCell {

    let titleLabel = UILabel("")
    let detailLabel = UILabel("",font: 13.plain(),color: gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(10)
            maker.left.equalToSuperview().offset(15)
            maker.centerX.equalToSuperview()
        }
        detailLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(7)
            maker.left.equalTo(titleLabel.snp.left)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-10)
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String,detail: String){
        titleLabel.text = title
        detailLabel.text = detail
    }

}
