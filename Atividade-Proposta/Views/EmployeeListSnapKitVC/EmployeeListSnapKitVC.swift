//
//  EmployeeListSnapKitVC.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 21/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit
import SnapKit

class EmployeeListSnapKitVC : UIViewController, EmployeeListVCDelegate {
    
    // EmployeeListVCDelegate Properties:
    var coordinator: MainCoordinator? { return _coordinator }
                
    // Private Properties:
    private var presenter = EmployeeListVCPresenter()
    // - UIView:
    private lazy var tableView = UITableView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    // - External References:
    private weak var _coordinator : MainCoordinator?
    
    // Overridden Methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Background Color:
        self.view.backgroundColor = .systemBackground
        // Title:
        self.title = "Funcionários"
        coordinator?.navigationController.navigationBar.prefersLargeTitles = true
        // TableView:
        setupTableView()
        // Activity Indicator:
        setupActivityIndicator()
        // Setups the presenter:
        presenter.initialize(delegate: self)
    }
    
    // EmployeeListVCDelegate Methods:
    func reloadTableViewData() {
        self.tableView.reloadData()
    }
    
    func showActivityIndicator() {
        self.activityIndicator.isHidden = false
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.isHidden = true
    }
    
    // Public Methods:
    public func initialize(coordinator : MainCoordinator) {
        _coordinator = coordinator
    }
    
    // Private Methods:
    private func setupTableView() {
        self.view.addSubview(tableView)        
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewSKConstraints()
        registerTableViewCells()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.style = .large
        setupActivityIndicatorConstraints()
    }
    
    // - SnapKit:
    private func setupTableViewSKConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupActivityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
            make.right.equalTo(view)            
        }
    }
    
}

// UITableViewDelegate & UITableViewDataSource Extension:
extension EmployeeListSnapKitVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = presenter.employees[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeSnapKitTableViewCell.reuseIdentifier) as? EmployeeSnapKitTableViewCell {
            cell.setEmployee(employee: employee)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        presenter.employeeTapped(presenter.employees[indexPath.row], index: indexPath.row)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Private Methods:
    private func registerTableViewCells() {
        tableView.register(EmployeeSnapKitTableViewCell.self, forCellReuseIdentifier: EmployeeSnapKitTableViewCell.reuseIdentifier)
    }
    
}
