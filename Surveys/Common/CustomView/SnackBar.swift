//
//  SnackBar.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/20/21.
//

import Foundation
import UIKit
import SnapKit

class SnackBar: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var detail: String? {
        didSet {
            detailLabel.text = detail
        }
    }
    
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.6)
        
        iconImageView = UIImageView(image: Images.iconNotification)
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: FontName.neuzeitBookHeavy, size: 15)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        
        detailLabel = UILabel()
        detailLabel.textColor = .white
        detailLabel.font = UIFont(name: FontName.neuzeitBookStandard, size: 13)
        addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.greaterThanOrEqualToSuperview().offset(8)
        }
        
        invalidateIntrinsicContentSize()
    }
}
