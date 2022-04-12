//
//  FavoritesViewController.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import RealmSwift
import EasyPeasy

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var presenter: FavoritesViewOutput!
    let detailView = DetailCharacterView()
    
    private let realm = try! Realm()
    private lazy var items: Results<FavoritesRealmModel>! = {
        self.realm.objects(FavoritesRealmModel.self)
    }()
    
    // MARK: - Views
    private lazy var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.rowHeight = 110
        tableView.register(FavoritesTableViewCell.self,
                           forCellReuseIdentifier: FavoritesTableViewCell.identifier)
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
        view.addSubview(tableView)
        tableView.easy.layout( Edges() )
        configureTapGesture()
        tableView.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
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
    
    private func setupDetailCharacterView() {
        view.addSubview(detailView)
        detailView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        detailView.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.detailView.alpha = 1
            self.detailView.transform = CGAffineTransform.identity
        }
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailCharacterView))
        detailView.addGestureRecognizer(tapGesture)
//        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showDetailCharacterView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.detailView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.detailView.alpha = 0
        }
        ) { (success) in
            self.detailView.removeFromSuperview()
        }
    }
    
    // MARK: - TableViewDataSource
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
//        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 12
        cell.tintColor = .black
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        view.addSubview(notificationLabel)
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        self.notificationLabel.text = "\(item.nameCharacter ?? "") remove from favorites"
            self.notificationLabel.alpha = 0.7
                       },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3, delay: 0.8, animations: {
                            self.notificationLabel.alpha = 0
                        })
                       })
         if editingStyle == .delete {
            try! self.realm.write {
                self.realm.delete(item)
            }
            tableView.reloadData()
            return
        }
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.items[indexPath.item]
        detailView.nameCharacterLabel.text = item.nameCharacter
        detailView.speciesCharacterLabel.text = "Species: \(item.speciesCharacter ?? "")"
        detailView.statusCharacterLabel.text = "Status: \(item.statusCharacter ?? "")"
        detailView.genderCharacterLabel.text = "Gender: \(item.genderCharacter ?? "")"
        detailView.idCharacterLabel.text = "\(item.id)"
        
        if item.statusCharacter == "Alive" {
            detailView.statusCircleLabel.backgroundColor = .green
        } else if item.statusCharacter == "unknown" {
            detailView.statusCircleLabel.backgroundColor = .brown
        }  else if item.statusCharacter == "Dead" {
            detailView.statusCircleLabel.backgroundColor = .red
        }
        
        if item.typeCharacter == "" {
            detailView.typeCharacterLabel.text = "Type: Unknow"
        } else {
            detailView.typeCharacterLabel.text = "Type: \(item.typeCharacter ?? "")"
        }
        
        let image = UIImage(data: item.imageCharacter!)
        detailView.characterImageView.image = image
        
        setupDetailCharacterView()
    }
    
    // MARK: - AccessoryButtonTapped
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = self.items[indexPath.item]
        detailView.nameCharacterLabel.text = item.nameCharacter
        detailView.speciesCharacterLabel.text = "Species: \(item.speciesCharacter ?? "")"
        detailView.statusCharacterLabel.text = "Status: \(item.statusCharacter ?? "")"
        detailView.genderCharacterLabel.text = "Gender: \(item.genderCharacter ?? "")"
        detailView.idCharacterLabel.text = "\(item.id)"
        
        if item.statusCharacter == "Alive" {
            detailView.statusCircleLabel.backgroundColor = .green
        } else if item.statusCharacter == "unknown" {
            detailView.statusCircleLabel.backgroundColor = .brown
        }  else if item.statusCharacter == "Dead" {
            detailView.statusCircleLabel.backgroundColor = .red
        }
        
        if item.typeCharacter == "" {
            detailView.typeCharacterLabel.text = "Type: Unknow"
        } else {
            detailView.typeCharacterLabel.text = "Type: \(item.typeCharacter ?? "")"
        }
        
        let image = UIImage(data: item.imageCharacter!)
        detailView.characterImageView.image = image
        
        setupDetailCharacterView()
    }
}

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
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 19)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
}
