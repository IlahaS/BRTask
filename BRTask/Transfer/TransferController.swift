//
//  TransferController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import UIKit

protocol TransferDelegate: AnyObject {
    func transferCompleted()
}

class TransferController: UIViewController {
    
    weak var delegate: TransferDelegate?
    private let viewModel: TransferViewModel
    
    init(viewModel: TransferViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fromCardPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var toCardPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    private lazy var transferButton: ReusableButton = {
        let button = ReusableButton(title: "Transfer", color: .mainColor) {
            self.transferAmount()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        fetchCardData()
        setupUI()
    }
    
    private func fetchCardData() {
        viewModel.fetchCardData { [weak self] in
            self?.fromCardPicker.reloadAllComponents()
            self?.toCardPicker.reloadAllComponents()
        }
    }
    
    private func setupUI() {
        view.addSubview(fromCardPicker)
        fromCardPicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        view.addSubview(toCardPicker)
        toCardPicker.snp.makeConstraints { make in
            make.top.equalTo(fromCardPicker.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(fromCardPicker)
        }
        
        let fromLabel = UILabel()
        fromLabel.text = "From:"
        fromLabel.textColor = .black
        fromLabel.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.bottom.equalTo(fromCardPicker.snp.top).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        
        let toLabel = UILabel()
        toLabel.text = "To:"
        toLabel.textColor = .black
        toLabel.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.bottom.equalTo(toCardPicker.snp.top).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        
        
        view.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(toCardPicker.snp.bottom).offset(20)
            make.leading.trailing.equalTo(fromCardPicker)
            make.height.equalTo(50)
        }
        
        view.addSubview(transferButton)
        transferButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(fromCardPicker)
            make.height.equalTo(50)
        }
    }
    
    @objc private func transferAmount() {
        let fromIndex = fromCardPicker.selectedRow(inComponent: 0)
        let toIndex = toCardPicker.selectedRow(inComponent: 0)
        
        guard fromIndex != toIndex else {
            let alert = UIAlertController(title: "Invalid Selection",
                                          message: "You cannot transfer money from and to the same card.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard fromIndex >= 0 && fromIndex < viewModel.cards.count,
              toIndex >= 0 && toIndex < viewModel.cards.count,
              let amountText = amountTextField.text,
              !amountText.isEmpty,
              let amount = Double(amountText) else {
            let alert = UIAlertController(title: "Missing Amount",
                                          message: "Please enter the amount you want to transfer.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        viewModel.transferAmount(fromIndex: fromIndex, toIndex: toIndex, amount: amount) { [weak self] success in
            if success {
                self?.delegate?.transferCompleted()
                
                let alert = UIAlertController(title: "Transfer Successful",
                                              message: "The amount has been transferred successfully.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                self?.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Selected amount is more than account balance.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension TransferController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.cards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.cards[row].cardNumber
    }
}

extension TransferController: UITextFieldDelegate {
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
