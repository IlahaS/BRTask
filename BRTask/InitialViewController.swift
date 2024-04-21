//
//  RegisterControllerViewController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 18.04.24.
//

import UIKit
import Lottie
import SnapKit

class InitialViewController: UIViewController {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation")
        view.contentMode = .scaleAspectFit
        view.play()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register to start banking securely"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let paragraphLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete the registration to access all features and services of our bank app."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var registerButton: ReusableButton = {
        let button = ReusableButton(title: "Register", color: .mainColor) {
            self.goToRegister()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        
        [animationView,
         titleLabel,
         paragraphLabel,
         registerButton,
        ].forEach(view.addSubview)
        
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(350)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(animationView.snp.bottom).offset(20)
        }
        
        paragraphLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(paragraphLabel.snp.bottom).offset(60)
        }
    }
    
    @objc func goToRegister() {
        let vc = RegisterController(viewModel: RegisterViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}
