//
//  EpisodeViewOutput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

protocol EpisodesViewOutput {
    var episodes: [EpisodeResult]? { get set }
    func startListening()
    func episodeFirstLoad(at: Int)
    func loadCharacters(request: EpisodesRequest, completionHendler: @escaping(Result<[EpisodeResult], Error>) -> Void)
}
