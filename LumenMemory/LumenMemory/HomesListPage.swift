import SwiftUI
import HomeKit

struct HomesListPage: View {
    
    @ObservedObject var model: HomesListPageModel
    @State private var homeName: String = ""
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
                HStack{
                    Text("Mes Maisons")
                    Spacer()
                    Button{
                        model.handleAddhome()
                    } label: {
                        HStack{
                            Image(systemName: "homekit")
                            Text("Add Home")
                        }
                    }
                }
            }

        }.alert("Entrer le nom de la maison", isPresented: $model.isPresentingAlert) {
            TextField("Entrer le nom de la maison", text: $homeName)
            HStack {
                Button("Annuler", action: {
                    model.isPresentingAlert = false
                })
                Button("OK", action: {
                    model.addHome(homeName: homeName)
                })
            }
        }
    }
}

#Preview {
    HomesListPage(model: HomesListPageModel(HomeKitStorage()))
}
class HomesListPageModel: ObservableObject {
    
    @Published var homes: [HomeListItem] = []
    @Published var isPresentingAlert: Bool = false
    private let homeKitStorage: HomeKitStorage
    
    init(_ homeKitStorage: HomeKitStorage) {
        self.homeKitStorage = homeKitStorage
        manageHomes()
    }
    
    func handleAddhome(){
        isPresentingAlert = true
    }
    
    func addHome(homeName: String) -> Void {
        if homeName.isNameValid(){
            homeKitStorage.addHome(homeName: homeName)
            
        }
        isPresentingAlert = false
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
