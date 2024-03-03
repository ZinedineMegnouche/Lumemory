import SwiftUI
import HomeKit

struct GameMenuView: View {
    
    @ObservedObject var model: GameMenuViewModel
    
    var body: some View {
        VStack{
            Text("Choisissez un niveau")
                .padding(30)
                .font(.title)
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb")
                    Text(model.accesory.name)
                        .bold()
                    Spacer()
                    
                }
                HStack(spacing: 10) {
                    Image(systemName: "homekit")
                    Text(model.home.name)
                        .bold()
                    Spacer()
                }
            }.frame(maxWidth: .infinity)
            Spacer()
            VStack(spacing: 50){
                NavigationLink {
                    GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .easy, homeKitStorage: HomeKitStorage()))
                } label: {
                    Text("Facile")
                    NavigationLink {
                        GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .medium, homeKitStorage: HomeKitStorage()))
                    } label: {
                        Text("Moyen")
                    }
                    NavigationLink {
                        GameView(model: GameViewModel(home: model.home, accesory: model.accesory, difficulty: .hard, homeKitStorage: HomeKitStorage()))
                    } label: {
                        Text("Difficile")
                    }
                }.padding(.bottom, 100)
            }
            Spacer()
        }.padding()
    }
}

//#Preview {
//    GameMenuView()
//}


class GameMenuViewModel: ObservableObject {
    @Published var home: HomeListItem
    @Published var accesory: HMAccessory
    
    init(home: HomeListItem, accesory: HMAccessory) {
        self.home = home
        self.accesory = accesory
    }
    
    func handleStartGame(){
        
    }
}
