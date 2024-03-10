import SwiftUI
import HomeKit

struct GameMenuView: View {
    
    @ObservedObject var model: GameMenuViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Partie")
                    .title2Font()
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
            }.padding(.top,70)
            HStack(spacing: 0) {
                HStack(spacing: 10) {
                    Image(systemName: "homekit")
                        .foregroundStyle(.white)
                    Text(model.home.name)
                    Spacer()
                }
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.max.fill")
                        .foregroundStyle(.yellow)
                    Text(model.accesory.name)
                    Spacer()
                }
            }.bodyFont()
            .foregroundStyle(.white).padding(.top,20)
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



