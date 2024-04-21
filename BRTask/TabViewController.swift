//
//  TabViewController.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import UIKit

final class TabViewController: UITabBarController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
        customizeTabBarAppearance()
    }
    
    private func setUpTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house") ?? .image, and: HomeController(viewModel: HomeViewModel()))
        let profile = self.createNav(with: "Profil", and: UIImage(systemName: "person") ?? .image, and: ProfileController(viewModel: ProfileViewModel()))
        self.setViewControllers([home,profile], animated: true)
    }
    
    private func createNav(with name: String, and image: UIImage, and vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = name
        nav.tabBarItem.image = image
        return nav
    }
    
    private func customizeTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.tintColor], for: .selected)
        self.tabBar.tintColor = .mainColor
        self.tabBar.backgroundColor = .white
    }
}
