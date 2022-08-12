//
//  HSDeviceMoreOneCell.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/29.
//

import UIKit

class HSDeviceMoreOneCell: UITableViewCell {
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 15, y: contentView.as.height/2-titleLabel.as.height/2, width: contentView.as.width-30, height: titleLabel.as.height)
    }
    // MARK: - Public

    // MARK: - Request

    // MARK: - Action

    // MARK: - Private
    private func setUI(){
        contentView.addSubview(titleLabel)
    }
    // MARK: - setter & getter
    lazy var titleLabel: UILabel = {
        let lab = UILabel.init(title: "重启设备", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 14), alignment: .left)
        return lab
    }()
}
// MARK: - Other Delegate
//extension HSDeviceMoreOneCell : {
//
//}

