//
//  CardCreateController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import UIKit
import SnapKit
import CoreData

class CardCreateController: UIViewController, UITextFieldDelegate {
    
    var didAddButtonPressed: (() -> Void)?
    private var viewModel = CardCreateViewModel()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0000 0000 0000 0000"
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(formatCardNumber(_:)), for: .editingChanged)
        return textField
    }()
    
    private let cvvTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "CVV"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var expDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/YY"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(formatExpDate(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Card", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        cvvTextField.delegate = self
        expDateTextField.delegate = self
        
        setupViews()
    }
    
    private func setupViews() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Card Addition:"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mainColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        cardView.addSubview(cardNumberTextField)
        cardNumberTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        cardView.addSubview(cvvTextField)
        cvvTextField.snp.makeConstraints { make in
            make.top.equalTo(cardNumberTextField.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        cardView.addSubview(expDateTextField)
        expDateTextField.snp.makeConstraints { make in
            make.top.equalTo(cardNumberTextField.snp.bottom).offset(36)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardView.snp.bottom).offset(40)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
    
    @objc private func formatCardNumber(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let formattedText = String(text.prefix(19))
        textField.text = String.format(with: "XXXX XXXX XXXX XXXX", phone: formattedText)
    }
    
    @objc private func formatExpDate(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            if text.count == 4 && !text.contains("/") {
                textField.text?.insert("/", at: text.index(text.startIndex, offsetBy: 2))
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cvvTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 3
        } else if textField == expDateTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 4
        }
        return true
    }
    
    @objc private func addCard() {
        guard let cardNumber = cardNumberTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(),
              cardNumber.count == 16,
              let cvvText = cvvTextField.text,
              let cvv = Int(cvvText),
              let expDate = expDateTextField.text else {
            let alert = UIAlertController(title: "Invalid Data", message: "Please enter valid card info", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let cardModel = CardModel(cardNumber: cardNumber, balance: 10, expDate: expDate, cvv: cvv)
        viewModel.saveCard(card: cardModel, completion: { [weak self] in
            self?.didAddButtonPressed?()
            self?.navigationController?.popViewController(animated: true)
        })
    }
}
