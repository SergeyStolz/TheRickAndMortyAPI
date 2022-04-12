//
//  DetailEpisodeViewInput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

protocol DetailEpisodeViewInput {
    func succes()
    func failure(error: Error)
    var viewModel: [CharacterResult] { get set }
    
}
