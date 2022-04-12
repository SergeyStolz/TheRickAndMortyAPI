//
//  FavoritesRealmModel.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import Foundation
import RealmSwift

class FavoritesRealmModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var nameCharacter: String?
    @objc dynamic var statusCharacter: String?
    @objc dynamic var speciesCharacter: String?
    @objc dynamic var typeCharacter: String?
    @objc dynamic var genderCharacter: String?
    @objc dynamic var imageCharacter: Data? = nil
    @objc dynamic var state = false
}
