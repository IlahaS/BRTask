//
//  ProfileController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//
import UIKit
import SnapKit

class ProfileController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var exitButton: ReusableButton = {
        let button = ReusableButton(title: "Log Out", color: .mainColor) {
            self.logout()
        }
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
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func fetchUserDetails() {
        viewModel.fetchUserDetails { [weak self] user in
            self?.addLabelsToStackView(with: user)
        }
    }
    
    private func addLabelsToStackView(with user: User?) {
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
            make.height.equalTo(50)
        }
    }
    
    @objc private func logout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.viewModel.logout()
            self.navigateToInitialScreen()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToInitialScreen() {
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
