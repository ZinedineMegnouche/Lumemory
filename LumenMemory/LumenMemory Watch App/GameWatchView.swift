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
            }
            .disabled(!model.playable)
            .overlay {
                !model.playable ? Color.black.opacity(0.8) : nil
            }.overlay {
                if model.playState == .gameOver {
                    VStack {
                        Text("Game Over")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        Text("Score: \(model.score)")
                        Button{
                            model.watchToiOSConnector.sendRestart()
                        } label: {
                            Text("Rejouer")
                        }
                        
                    }
                }
            }
            .ignoresSafeArea()
    }
}

#Preview {
    GameWatchView(model: GameWatchViewModel())
}
