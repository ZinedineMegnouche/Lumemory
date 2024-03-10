import SwiftUI
import Foundation
import Combine

class GameWatchViewModel: ObservableObject {
    
    @Published var playState: PlayState?
    @ObservedObject var watchToiOSConnector = WatchToiOSConnector()
    
    var playable: Bool {
        playState == .canPlay
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        watchToiOSConnector.$playState
            .compactMap { $0 }
            .sink { playState in
                self.playState = playState
            }.store(in: &cancellables)
    }
    
    
}
