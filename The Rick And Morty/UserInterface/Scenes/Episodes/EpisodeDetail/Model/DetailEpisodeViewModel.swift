//
//  DetailEpisodeViewModel.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

struct DetailEpisodeViewModel {
    var id: Int
    var name: String
    var image: String
    var status: String
    var species: String
    var type: String
    var gender: String
    
    init(item: CharacterResult) {
        self.id = item.id
        self.name = item.name
        self.image = item.image
        self.status = item.status
        self.species = item.species
        self.type = item.type
        self.gender = item.gender
    }
}
