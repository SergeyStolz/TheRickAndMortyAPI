//
//  FavoritesViewController.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import RealmSwift
import EasyPeasy

class FavoritesViewController: UIViewController {
        
    // MARK: - Properties
    var presenter: FavoritesViewOutput!
    private let realm = try! Realm()
    private lazy var items: Results<FavoritesRealmModel>! = {
        self.realm.objects(FavoritesRealmModel.self)
    }()
    
    // MARK: - Private Views
    private lazy var detailView: DetailCharacterView = {
        let view = DetailCharacterView()
        return view
    }()
    
    private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.rowHeight = 110
        tableView.register(FavoritesTableViewCell.self,
                           forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        tableView.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textAlignment = .center
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAndTabBar()
        view.addSubview(tableView)
        tableView.easy.layout( Edges() )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        detailView.easy.layout(
            Top(view.frame.size.height/5),
            Bottom(view.frame.size.height/5),
            CenterX(),
            Width(350)
        )
        notificationLabel.easy.layout(
            CenterY(),
            CenterX(),
            Height(113),
            Width(view.frame.size.width-100)
        )
    }
    
    private func setupNavBarAndTabBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        navigationController?.navigationBar.addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 0.6,
            shadowOpacity: 0.3
        )
    }
    
    private func setupDetailCharacterView() {
        view.addSubview(detailView)
        detailView.unfadeScaleTransform()
    }
    
    private func deleteFromRealm(item: FavoritesRealmModel) {
        try! self.realm.write {
            self.realm.delete(item)
        }
    }
    private func showNotificationLabel(item: FavoritesRealmModel) {
        view.addSubview(notificationLabel)
        self.notificationLabel.text = "\(item.nameCharacter!) удален из избранного"
        self.notificationLabel.showAnimation()
    }
}

// MARK: - TableViewDataSource
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            setEmptyMessage("You haven't added your favorite characters,\n but you can fix it easily")
        } else {
            setEmptyMessage("")
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier,
                                                 for: indexPath) as! FavoritesTableViewCell
        let item = FavoritesCellViewModel(items[indexPath.row])
        cell.fill(item: item)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 12
        cell.tintColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.item]
            showNotificationLabel(item: item)
            deleteFromRealm(item: item)
            tableView.reloadData()
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteCharacter = FavoritesCellViewModel(items[indexPath.row])
        detailView.character = favoriteCharacter
        setupDetailCharacterView()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - SetEmptyMessage
extension FavoritesViewController {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: view.frame.size.width,
                    height: view.frame.size.width)
            )
        )
        messageLabel.frame = view.bounds
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 19)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
}
