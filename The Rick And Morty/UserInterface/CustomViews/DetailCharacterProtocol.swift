//
//  DetailCharacterProtocol.swift
//  The Rick And Morty
//
//  Created by mac on 11.04.2022.
//

import UIKit

protocol DetailCharacterProtocol {
    var id: Int  { get set }
    var image: String { get set }
    var name: String { get set }
    var status: String { get set }
    var species: String { get set }
    var type: String { get set }
    var gender: String { get set }
}
