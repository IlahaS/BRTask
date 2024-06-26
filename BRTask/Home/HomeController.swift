//
//  HomeController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//
import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, TransferDelegate {
    
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let imageEmpty: UIImageView = {
        let image = UIImageView(image: UIImage(named: "noCard"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no active card right now"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add new card", for: .normal)
        button.backgroundColor = .mainColor.withAlphaComponent(0.2)
        button.setTitleColor(.mainColor, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goToCardCreation), for: .touchUpInside)
        return button
    }()
    
    private lazy var transferButton: ReusableButton = {
        let button = ReusableButton(title: "Transfer between cards", color: .mainColor) {
            self.goToTransfer()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCardData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.addSubview(imageEmpty)
        imageEmpty.snp.makeConstraints { make in
            make.centerX.equalTo(emptyView)
            make.centerY.equalTo(emptyView.snp.centerY).offset(-50)
            make.height.width.equalTo(80)
        }
        
        emptyView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emptyView)
            make.top.equalTo(imageEmpty.snp.bottom).offset(20)
        }
        
        emptyView.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.centerX.equalTo(emptyView)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
        
        view.addSubview(transferButton)
        transferButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(tableView.snp.bottom)
        }
    }
    
    private func fetchCardData() {
        viewModel.fetchCardData { [weak self] in
            self?.updateUI()
            self?.tableView.reloadData()
        }
    }
    
    private func updateUI() {
        if viewModel.cards.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
            transferButton.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
            transferButton.isHidden = false
        }
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCardCreation))
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showCardInfo))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = infoButton
    }
    
    func transferCompleted() {
        fetchCardData()
    }
    
    @objc func goToCardCreation() {
        let vc = CardCreateController(viewModel: CardCreateViewModel())
        vc.didAddButtonPressed = { [weak self] in
            self?.fetchCardData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let card = viewModel.cards[indexPath.row]
        cell.textLabel?.text = card.cardNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc private func goToTransfer() {
        let vc = TransferController(viewModel: TransferViewModel())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showCardInfo() {
        var infoString = ""
        for card in viewModel.cards {
            if let cardNumber = card.cardNumber {
                infoString += "Card Number: \(cardNumber)\nBalance: \(card.balance) AZN\n\n"
            } else {
                print("Error: Card number is nil")
            }
        }
        infoString = infoString.trimmingCharacters(in: .whitespacesAndNewlines)
        let alertController = UIAlertController(title: "Card Information", message: infoString, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true) {
            self.fetchCardData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = viewModel.cards[indexPath.row]
        if let cardNumber = card.cardNumber {
            let infoString = "Card Number: \(cardNumber)\nBalance: \(card.balance) AZN\n\n"
            
            let alertController = UIAlertController(title: "Card Information", message: infoString.trimmingCharacters(in: .whitespacesAndNewlines), preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        } else {
            print("Error: Card number is nil")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let deletedCard = viewModel.cards.remove(at: indexPath.row)
                viewModel.deleteCard(card: deletedCard)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
