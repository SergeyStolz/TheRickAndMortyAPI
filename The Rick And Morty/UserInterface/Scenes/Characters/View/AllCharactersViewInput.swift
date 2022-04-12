//
//  CharacterViewInput.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

protocol CharacterViewInput {
    func reloadData()
    func failure(error: Error)
    func showAlert()

}
