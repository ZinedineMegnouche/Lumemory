import SwiftUI
import Foundation
import Combine

class GameWatchViewModel: ObservableObject {
    
    @Published var playState: PlayState?
    @Published var score: Int = 0
    @Published var bestScore: Int = 0
    @ObservedObject var watchToiOSConnector = WatchToiOSConnector()
    
    var playable: Bool {
        playState == .canPlay
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        watchToiOSConnector.$playState
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { playState in
                self.playState = playState
            }.store(in: &cancellables)
        
        watchToiOSConnector.$score
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { score in
                self.score = score
            }.store(in: &cancellables)
        
        watchToiOSConnector.$bestScore
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { bestScore in
                self.bestScore = bestScore
            }.store(in: &cancellables)
    }
    
    
}
