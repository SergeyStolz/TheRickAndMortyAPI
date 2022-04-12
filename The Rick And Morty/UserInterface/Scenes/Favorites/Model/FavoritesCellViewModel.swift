//
//  FavoritesCellViewModel.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

struct FavoritesCellViewModel: DetailCharacterProtocol {
    var id: Int = 0
    var image = ""
    var name = ""
    var status = ""
    var species = ""
    var type = ""
    var gender = ""
    var favorite = false
    
    init(_ items: FavoritesRealmModel) {
        let id = items.id
        guard let image = items.imageCharacter,
              let name = items.nameCharacter,
              let status = items.statusCharacter,
              let species = items.speciesCharacter,
              let type = items.typeCharacter,
              let gender = items.genderCharacter
        else {
            return
        }
        self.id = id
        self.image = image
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.favorite = items.state
    }
}
