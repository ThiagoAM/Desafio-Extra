//
//  EmployeeSnapKitTableViewCell.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 22/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit
import SnapKit

class EmployeeSnapKitTableViewCell : UITableViewCell {
    
    // Public Static Properties:
    public static var reuseIdentifier = "employeeSnapKitTableViewCell"
    
    // Private Properties:
    private let formattingHelper = FormattingHelper()
    // - UIViews:
    private lazy var profileImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var ageLabel = UILabel()
    private lazy var salaryLabel = UILabel()
    
    // Initialization:
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMainView()
        setupProfileImageView()
        setupNameLabel()
        setupAgeLabel()
        setupSalaryLabel()
    }
                
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public Methods:
    public func setEmployee(employee : Employee) {
        nameLabel.text = employee.name
        ageLabel.text = "\(employee.age) anos"
        salaryLabel.text = formattingHelper.formatToBRL(value: employee.salary, hasPrefix: true)
    }
    
    // Private Methods:
    private func setupMainView() {
        self.frame.size = CGSize(width: 100, height: 100)
    }
    
    private func setupProfileImageView() {
        self.addSubview(profileImageView)
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        setupProfileImageViewConstraints()
    }
    
    private func setupNameLabel() {
        self.addSubview(nameLabel)
        setupNameLabelConstraints()
    }
    
    private func setupAgeLabel() {
        self.addSubview(ageLabel)
        setupAgeLabelConstraints()
    }
    
    private func setupSalaryLabel() {
        self.addSubview(salaryLabel)
        salaryLabel.textAlignment = .right
        setupSalaryLabelConstraints()
    }
    
    // - SnapKit:
    private func setupProfileImageViewConstraints() {
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.left.equalTo(8)
            make.width.equalTo(54)
            make.height.equalTo(54)
        }
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(12)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalTo(self.snp.right).offset(-8)
        }
    }
    
    private func setupAgeLabelConstraints() {
        ageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.width.equalTo(80)
        }
    }
    
    private func setupSalaryLabelConstraints() {
        salaryLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(ageLabel.snp.right).offset(8)
            make.right.equalTo(self).offset(-8)
        }
    }
    
}

