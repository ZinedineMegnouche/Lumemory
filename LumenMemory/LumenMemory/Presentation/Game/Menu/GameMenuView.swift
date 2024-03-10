import SwiftUI
import HomeKit

struct GameMenuView: View {
    
    @ObservedObject var model: GameMenuViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Partie")
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
            }.padding(.top, 80)
            HStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "homekit")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundStyle(.white)
                    Text(model.home.name)
                        .bold()
                        .font(.title3)
                    Spacer()
                }
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.max.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.yellow)
                    Text(model.accesory.name)
                        .bold()
                        .font(.title3)
                    Spacer()
                }
            }.foregroundStyle(.white).padding(.top,20)
            Spacer()
            VStack {
                difficultiesButton.padding(.bottom, 100).foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(20)
        .lumenMemoryBG()
    }
    
    @ViewBuilder
    var difficultiesButton: some View {
        NavigationLink {
            NavigationLazyView(GameView(model: GameViewModel(home: model.home,
                                                             accesory: model.accesory,
                                                             difficulty: .easy,
                                                             homeKitStorage: HomeKitStorage())))
        } label: {
            RoundedText(text: "Facile")
        }
        NavigationLink {
            NavigationLazyView(GameView(model: GameViewModel(home: model.home,
                                                             accesory: model.accesory,
                                                             difficulty: .medium,
                                                             homeKitStorage: HomeKitStorage())))
        } label: {
            RoundedText(text: "Moyen")
        }
        NavigationLink {
            NavigationLazyView(GameView(model: GameViewModel(home: model.home,
                                                             accesory: model.accesory,
                                                             difficulty: .hard,
                                                             homeKitStorage: HomeKitStorage())))
        } label: {
            RoundedText(text: "Difficile")
        }
    }
}

#Preview {
    GameMenuView(model: GameMenuViewModel(home: HomeListItem(id: UUID(), name: "home"),
                                          accesory: HMAccessory()))
}



