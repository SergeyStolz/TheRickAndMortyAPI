//
//  CharactersViewModel.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import RealmSwift

struct CharactersCellViewModel {
    var id: Int
    var name: String
    var image: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var isFavorite = false
    
    init(_ item: CharacterResult) {
        self.id = item.id
        self.image = item.image
        self.name =  item.name
        self.status = item.status
        self.species = item.species
        self.type = item.type
        self.gender = item.gender
        
        let realm = try? Realm()
        let items = realm?.objects(FavoritesRealmModel.self)
        
        if let searchResults = items?.filter({$0.id == item.id}) {
            self.isFavorite = searchResults.isEmpty ? false : true
        }
    }
}
