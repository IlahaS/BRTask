//
//  HomeController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//
import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var cards: [Cards] = []
    private let coreData = CoreData(contex: AppDelegate().persistentContainer.viewContext)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no active card right now"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var imageEmpty: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noCard")
        return image
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add new card", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.mainColor, for: .normal)
        button.backgroundColor = UIColor.mainColor.withAlphaComponent(0.2)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goToCardCreation), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        fetchCardData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        fetchCardData()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCardCreation))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupUI() {
        if cards.isEmpty {
            view.addSubview(imageEmpty)
            imageEmpty.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-50)
                make.height.width.equalTo(80)
            }
            
            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageEmpty.snp.bottom).offset(20)
            }
            
            view.addSubview(createButton)
            createButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(32)
                make.width.equalTo(160)
                make.height.equalTo(50)
            }
            
            tableView.isHidden = true
        } else {
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            imageEmpty.removeFromSuperview()
            titleLabel.removeFromSuperview()
            createButton.removeFromSuperview()
        }
    }
    
    
    private func fetchCardData() {
        coreData.fetchCardDatas { [weak self] cards in
            self?.cards = cards
            self?.tableView.reloadData()
        }
    }
    
    @objc func goToCardCreation() {
        let vc = CardCreateController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let card = cards[indexPath.row]
        cell.textLabel?.text = card.cardNumber
        return cell
    }
}
extension HomeController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedCard = cards.remove(at: indexPath.row)
            
            coreData.deleteCardDatas(card: deletedCard)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
