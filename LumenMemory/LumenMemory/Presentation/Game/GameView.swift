import SwiftUI
import HomeKit

struct GameView: View {
    
    @ObservedObject var model: GameViewModel
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading,spacing: 10){
                    Text("Round: \(model.round)")
                        .font(.title)
                    Text("🕹️ Score: \(model.score)")
                    Text("🏆 Best score: \(model.bestScore)")
                }.bold()
                .foregroundStyle(.white)
                Spacer()
                if !model.isGameStarted || model.isGameFinished {
                    Button{
                        model.startGame()
                    }label: {
                        RoundedText(text: "Start")
                            .foregroundColor(.white)
                    }
                }
            }.padding(.vertical, 30)
            .padding(.top, 60)
            VStack {
                HStack {
                    Button {
                        model.didTapColor(color: .red)
                    } label: {
                        Rectangle()
                            .fill(Color.red)
                    }
                    .buttonStyle(GameButtonStyle())
                    Button {
                        model.didTapColor(color: .green)
                    } label: {
                        Color.green
                    }
                        .buttonStyle(GameButtonStyle())
                }
                HStack{
                    Button {
                        model.didTapColor(color: .blue)
                    } label: {
                        Rectangle()
                            .fill(Color.blue)
                    }
                        .buttonStyle(GameButtonStyle())
                    Button {
                        model.didTapColor(color: .yellow)
                    } label: {
                        Color.yellow
                    }
                        .buttonStyle(GameButtonStyle())
                }
            }.disabled(!model.isGameStarted || (model.isShowingColor && model.isGameStarted )).overlay {
                model.isShowingColor || model.isGameFinished ? Color.black.opacity(0.8) : nil
            }
            .overlay {
                if model.isShowingColor {
                    Text("Mémorisez les couleurs")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                } else if model.isGameFinished {
                    VStack{
                        Text("Game Over")
                            .font(.title)
                            .bold()
                            
                        Text("Score \(model.score)")
                    }.foregroundStyle(.white)
                }
            }
        }
        .padding()
        .lumenMemoryBG()
    }
}

#Preview {
    GameView(model: GameViewModel(home: HomeListItem(id: UUID(), name: "My Home"),
                                  accesory: HMAccessory(),
                                  difficulty: .easy,
                                  homeKitStorage: HomeKitStorage()))
}

