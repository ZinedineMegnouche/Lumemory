import SwiftUI
import HomeKit

struct HomesListPage: View {
    
    @ObservedObject var model: HomesListPageModel
    
    @State private var selectedHome: UUID? = nil
    var body: some View {
        List{
            Section {
                ForEach(model.homes, id: \.id) { home in
                    NavigationLink {
                        HomeDetailView(model: HomeDetailViewModel(home: home.id, HomeKitStorage()))
                    } label: {
                        Text(home.name)
                    }
                }
            } header: {
                Text("Mes Maisons")
                Button{
                    model.addHome()
                } label: {
                    Text("Add Home")
                }
            }

        }
    }
}

#Preview {
    HomesListPage(model: HomesListPageModel(HomeKitStorage()))
}
class HomesListPageModel: ObservableObject {
    
    @Published var homes: [HomeListItem] = []
    private let homeKitStorage: HomeKitStorage
    
    init(_ homeKitStorage: HomeKitStorage) {
        self.homeKitStorage = homeKitStorage
        manageHomes()
    }
    
    func addHome(){
        homeKitStorage.addHome()
    }
    
    func manageHomes(){
        homeKitStorage.$homes.map { homes in
            homes.map { home in .init(id: home.uniqueIdentifier, name: home.name)}
        }.assign(to: &$homes)
    }
}


struct HomeListItem {
    var id: UUID
    var name: String
}
