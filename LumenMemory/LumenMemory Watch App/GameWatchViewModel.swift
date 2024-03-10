import SwiftUI
import Foundation
import Combine

class GameWatchViewModel: ObservableObject {
    
    @Published var playable = false
    @ObservedObject var watchToiOSConnector = WatchToiOSConnector()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        watchToiOSConnector.$canPlay
            .compactMap { $0 }
            .sink { canPlay in
                self.playable = canPlay
            }.store(in: &cancellables)
    }
}
