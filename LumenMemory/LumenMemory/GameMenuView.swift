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
                    .padding(.bottom, 40)
                Spacer()
            }
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
            }.foregroundStyle(.white)
            Spacer()
            VStack(spacing: 50) {
                NavigationLink {
                    NavigationLazyView(GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .easy, homeKitStorage: HomeKitStorage())))
                } label: {
                    RoundedText(text: "Facile")
                }
                NavigationLink {
                    NavigationLazyView(GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .medium, homeKitStorage: HomeKitStorage())))
                } label: {
                    RoundedText(text: "Moyen")
                }
                NavigationLink {
                    NavigationLazyView(GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .hard, homeKitStorage: HomeKitStorage())))
                } label: {
                    RoundedText(text: "Difficile")
                }.padding(.bottom, 100)
            }
            Spacer()
        }
        .padding()
        .background(Image("bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea())
    }
}

#Preview {
    GameMenuView(model: GameMenuViewModel(home: HomeListItem(id: UUID(), name: "home"), accesory: HMAccessory()))
}


class GameMenuViewModel: ObservableObject {
    @Published var home: HomeListItem
    @Published var accesory: HMAccessory
    
    init(home: HomeListItem, accesory: HMAccessory) {
        self.home = home
        self.accesory = accesory
    }
}

struct NavigationLazyView<Content: View>: View {

    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
