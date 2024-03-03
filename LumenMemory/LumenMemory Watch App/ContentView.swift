import SwiftUI
import Combine

struct GameWatchView: View {
    
    @ObservedObject var model: GameWatchViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    model.watchToiOSConnector.sendColor(.red)
                } label: {
                    Rectangle()
                        .fill(Color.red)
                }.buttonStyle(GameButtonStyle())
                Button {
                    model.watchToiOSConnector.sendColor(.green)
                } label: {
                    Color.green
                }.buttonStyle(GameButtonStyle())
            }
            HStack{
                Button {
                    model.watchToiOSConnector.sendColor(.blue)
                } label: {
                    Rectangle()
                        .fill(Color.blue)
                }.buttonStyle(GameButtonStyle())
                Button {
                    model.watchToiOSConnector.sendColor(.yellow)
                } label: {
                    Color.yellow
                }.buttonStyle(GameButtonStyle())
            }
        }.disabled(!model.playable).overlay {
            !model.playable ? Color.black.opacity(0.8) : nil
        }.ignoresSafeArea()
            
    }
}

#Preview {
    GameWatchView(model: GameWatchViewModel())
}

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
