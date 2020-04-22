//
//  EditEmployeeSnapKitVC.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 21/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit
import SnapKit

class EditEmployeeSnapKitVC : UIViewController, EditEmployeeVCDelegate {
    
    // EditEmployeeVCDelegate Properties:
    var employeeListVCPresenter: EmployeeListVCPresenter?
    var nameTextFieldText: String? {
        get { return nameTextField.text }
        set { nameTextField.text = newValue }
    }
    var salaryTextFieldText: String? {
        get { return salaryTextField.text }
        set { salaryTextField.text = newValue }
    }
    
    // Private Properties:
    private var presenter = EditEmployeeVCPresenter()
    // - UIVIew:
    private lazy var scrollView = UIScrollView()
    private lazy var profileImageView = UIImageView()
    private lazy var ageLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var salaryTextField = UITextField()
        
    // - External References:
    private weak var coordinator : MainCoordinator?
    
    // Overridden Methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Background Color:
        self.view.backgroundColor = .systemBackground
        // Initial Display Data:
        ageLabel.text = "\(presenter.employee.age) anos"
        nameTextField.text = presenter.employee.name
        salaryTextField.text = FormattingHelper().formatToBRL(value: presenter.employee.salary)
        // Navigation Bar:
        updateNavigationBarTitle(presenter.employee.name)
        navigationItem.largeTitleDisplayMode = .never
        // ScrollView:
        setupScrollView()
        // Profile ImageView:
        setupProfileImageView()
        // Age Label:
        setupAgeLabel()
        // Name TextField:
        setupNameTextField()
        // Salary TextField:
        setupSalaryTextField()        
        // Keyboard/Scrollview ajustment setup:
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // EditEmployeeVCDelegate Methods:
    func updateNavigationBarTitle(_ title: String) {
        self.title = title
    }
    
    func showOkAlert(title: String?, message: String?, completion: (() -> Void)?) {
        self.presentOkAlert(title: title, message: message, completion: completion)
    }
    
    // Public Methods:
    public func initialize(coordinator : MainCoordinator, employee : Employee, employeeListVCPresenter : EmployeeListVCPresenter) {
        self.coordinator = coordinator
        self.employeeListVCPresenter = employeeListVCPresenter
        presenter.initialize(delegate: self, employee: employee)
    }
    
    // Private Methods:
    // - UIView:
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        setupScrollViewConstraints()
    }
    
    private func setupProfileImageView() {
        scrollView.addSubview(profileImageView)
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemBlue
        setupProfileImageViewConstraints()
    }
    
    private func setupAgeLabel() {
        scrollView.addSubview(ageLabel)
        ageLabel.textAlignment = .center
        setupAgeLabelConstraints()
    }
    
    private func setupNameTextField() {
        scrollView.addSubview(nameTextField)
        nameTextField.delegate = self
        nameTextField.borderStyle = .roundedRect
        setupNameTextFieldConstraints()
    }
    
    private func setupSalaryTextField() {
        scrollView.addSubview(salaryTextField)
        salaryTextField.delegate = self
        salaryTextField.borderStyle = .roundedRect
        setupSalaryTextFieldConstraints()
        // Setups the prefix label:
        let label = UILabel()
        label.text = " R$"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        salaryTextField.leftViewMode = .always
        salaryTextField.leftView = label
    }
            
    // - SnapKit:
    private func setupScrollViewConstraints() {
        // ScrollView:
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        // ScrollView's ContentView:        
        scrollView.contentSize.height = 300
    }
    
    private func setupProfileImageViewConstraints() {
        profileImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(16)
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalTo(scrollView)
        }
    }
    
    private func setupAgeLabelConstraints() {
        ageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupNameTextFieldConstraints() {
        nameTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(ageLabel.snp.bottom).offset(8)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.height.equalTo(50)
        }
    }
    
    private func setupSalaryTextFieldConstraints() {
        salaryTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.height.equalTo(50)
        }
    }
    
    // - Keyboard/Scrollview adjustment methods:
    //   These methods are responsible for the auto-scrolling that should happen when the user taps a UITextField (so that the UITextField doesn't become hidden by the keyboard).
    @objc private func keyboardWillShow(notification : NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame : CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset : UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc private func keyboardWillHide() {
        let contentInset : UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
                
}

// UITextFieldDelegate Extension:
extension EditEmployeeSnapKitVC : UITextFieldDelegate {
            
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField == nameTextField ?
            presenter.validateAndSetName(nameTextField.text) :
            presenter.validateAndSetSalary(salaryTextField.text)
    }
                            
}
