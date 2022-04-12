//
//  DetailEpisodeViewInput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

protocol DetailEpisodeViewInput {
    func succes()
    func failure(error: Error)
    func setupActivityView()
    func removeActivityView()
    var viewModel: [SearchRespondEpisodCharacter] { get set }
    
}
