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
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "animation")
        view.contentMode = .scaleAspectFit
        view.play()
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register to start banking securely"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var paragraphLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete the registration to access all features and services of our bank app."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .mainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(350)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(animationView.snp.bottom).offset(20)
        }
        
        view.addSubview(paragraphLabel)
        paragraphLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.top.equalTo(paragraphLabel.snp.bottom).offset(60)
        }
    }
    
    @objc func goToRegister() {
        let vc = RegisterController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
