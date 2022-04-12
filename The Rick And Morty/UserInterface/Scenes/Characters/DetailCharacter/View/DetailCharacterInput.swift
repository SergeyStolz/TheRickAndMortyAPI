//
//  DetailCharacterInput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

protocol DetailCharacterInput {
    func failure(error: Error)
    func succes()
}
