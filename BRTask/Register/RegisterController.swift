//
//  RegisterController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 18.04.24.
//

import UIKit
import SnapKit

class RegisterController: UIViewController, UITextFieldDelegate {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = Array(1...31).map { "\($0)" }
    let monthsNum = Array(1...12).map { String(format: "%02d", $0) }
    
    var viewmodel = RegisterViewModel()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var paragraphLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account so you can explore all the banking features"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nameTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Name"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.grayColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.delegate = self
        return textField
    }()
    
    private lazy var phoneNumberTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Phone Number"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.grayColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.delegate = self
        return textField
    }()
    
    private lazy var dobTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Date of Birth"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.grayColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.inputView = pickerView
        return textField
    }()
    
    private let dobPickerView = UIPickerView()
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(goToMainScreen), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(112)
        }
        
        view.addSubview(paragraphLabel)
        paragraphLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(paragraphLabel.snp.bottom).offset(56)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(dobTextField)
        dobTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(dobTextField.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.mainColor.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.grayColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
    }
    
    @objc func goToMainScreen() {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
              let dobText = dobTextField.text, !dobText.isEmpty else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let dob = dateFormatter.date(from: dobText) else {
            return
        }
        _ = User(name: name, phoneNumber: phoneNumber, dateOfBirth: dob)
        viewmodel.registerUser(name: name, phoneNumber: phoneNumber, dob: dob, onSuccess: {
            let scene = self.sceneDelegate
            scene?.switchToTabViewController()
        }, onFailure: {
            print("Failed to save sensitive data")
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if var text = textField.text, !text.isEmpty {
            text = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            if !text.hasPrefix("994") {
                text = "994" + text
            }
            
            let formattedText = formatPhoneNumber(text)
            textField.text = formattedText
        }
    }
    
    
    func formatPhoneNumber(_ phone: String) -> String {
        let formattedPhone = String.format(with: "XXX XX XXX XX XX", phone: phone)
        return formattedPhone
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return nil }
        return delegate
    }
}

extension RegisterController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 31
        case 1:
            return months.count
        case 2:
            return 100
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return days[row]
        case 1:
            return months[row]
        case 2:
            return "\(1922 + row)"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let day = days[pickerView.selectedRow(inComponent: 0)]
        let month = monthsNum[pickerView.selectedRow(inComponent: 1)]
        let year = 1922 + pickerView.selectedRow(inComponent: 2)
        let dob = "\(day).\(month).\(year)"
        dobTextField.text = dob
    }
    
}

class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
