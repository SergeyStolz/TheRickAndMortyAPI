//
//  EpisodeViewOutput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

protocol EpisodesViewOutput {
    func getEpisodes(isNew: Bool)
    var episodes: SearchRespondEpisode? { get set }
}
