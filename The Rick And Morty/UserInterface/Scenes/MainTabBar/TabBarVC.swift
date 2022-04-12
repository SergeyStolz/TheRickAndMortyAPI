//
//  TabBarVC.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

class TabBarVC: UITabBarController {
    
    // MARK: - Bounce Animation
    private lazy var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .systemGreen
    }
    
    func start(characters: [CharacterResult]?) {
        viewControllers = [
            createNavController(
                for: CharactersConfigurator.create(characters: characters),
                   title: NSLocalizedString("Characters", comment: ""),
                   image: UIImage(systemName: "person.3.fill")!),
            createNavController(
                for: EpisodesConfigurator.create(),
                   title: NSLocalizedString("Episodes", comment: ""),
                   image: UIImage(systemName: "film")!),
            createNavController(
                for: FavoritesConfigurator.create(),
                   title: NSLocalizedString("Favourites", comment: ""),
                   image: UIImage(systemName: "star.fill")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarVC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
