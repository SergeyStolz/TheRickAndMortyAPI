//
//  SplashScreenViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy
import Alamofire

class SplashScreenViewController: UIViewController {
    
    var presenter: SplashScreenViewOutput!
    private let networkManager = NetworkReachabilityManager()
    
    // MARK: - Private Views
    private lazy var splashScreenimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Launch.png")
        return imageView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.color = .white
        activityView.startAnimating()
        return activityView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.characterFirstLoad(at: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.startListening()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkManager?.stopListening()
        stopActivityView()
    }
    
    private func setupViews() {
        view.addSubview(splashScreenimageView)
        view.addSubview(activityView)
        splashScreenimageView.easy.layout( Edges() )
        activityView.easy.layout( CenterX(), CenterY(170) )
    }
}

// MARK: - SplashScreenViewInput
extension SplashScreenViewController: SplashScreenViewInput {
    func startActivityView() {
        activityView.startAnimating()
    }
    
    func stopActivityView() {
        activityView.stopAnimating()
    }
    
    func removeActivityView() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func showAlert() {
        showConnectionAlert()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func succes(characters: [CharacterResult]?) {
        let tabBarVC = TabBarVC()
        tabBarVC.start(characters: characters)
        tabBarVC.modalTransitionStyle = .crossDissolve
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: false, completion: nil)
    }
}
