//
//  ProfileController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//
import UIKit
import SnapKit

class ProfileController: UIViewController {
    
    private var user: User?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(goToInitialScreen), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Personal Info"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.mainColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .bold)
        ]
        setupStackView()
        fetchUserDetails()
        addButton()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func fetchUserDetails() {
        user = KeychainService.loadSensitiveData()
        addLabelsToStackView()
    }
    
    private func addLabelsToStackView() {
        if let user = user {
            addLabel(withText: "Name: \(user.name)")
            addLabel(withText: "Phone Number: \(user.phoneNumber)")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            addLabel(withText: "Date of Birth: \(dateFormatter.string(from: user.dateOfBirth))")
        }
    }
    
    private func addLabel(withText text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        stackView.addArrangedSubview(label)
    }
    
    private func addButton(){
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(56)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
    
    @objc func goToInitialScreen() {
        KeychainService.clearSensitiveData()
        UserDefaultsService.clearUserData()
        let initialViewController = InitialViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            let navigationController = UINavigationController(rootViewController: initialViewController)
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }, completion: nil)
        }
    }
}
