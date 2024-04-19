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
    
    
    private let coreData = CoreData()
    private var cards: [Cards] = []
    
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
    
    private lazy var transferButton: UIButton = {
        let button = UIButton()
        button.setTitle("Transfer", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(transferAmount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchCardData()
        setupUI()
    }
    
    private func fetchCardData() {
        coreData.fetchCardDatas { [weak self] cards in
            self?.cards = cards
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
        
        // Check if the same card is selected on both sides
        guard fromIndex != toIndex else {
            let alert = UIAlertController(title: "Invalid Selection",
                                          message: "You cannot transfer money from and to the same card.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard fromIndex >= 0 && fromIndex < cards.count,
              toIndex >= 0 && toIndex < cards.count,
              let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            return
        }
        
        let fromCard = cards[fromIndex]
        let toCard = cards[toIndex]
        
        if fromCard.balance >= amount {
            fromCard.balance -= amount
            toCard.balance += amount
            
            coreData.updateCardDatas(card: fromCard)
            coreData.updateCardDatas(card: toCard)
            
            delegate?.transferCompleted()
            
            let alert = UIAlertController(title: "Transfer Successful",
                                          message: "The amount has been transferred successfully.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Insufficient Balance",
                                          message: "The selected card does not have sufficient balance.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension TransferController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cards[row].cardNumber
    }
}

extension TransferController: UITextFieldDelegate {
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
