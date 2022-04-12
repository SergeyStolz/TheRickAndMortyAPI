//
//  LocationRequest.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

struct LocationRequest: Dictionariable {
    let id: Int?
    let name: String?
    let type: String?
    let dimension: String?
    let page: Int?
}
