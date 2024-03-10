import SwiftUI
import HomeKit

struct HomeListView: View {
    
    @ObservedObject var model: HomeListViewModel
    @State private var homeName: String = ""
    @State private var selectedHome: UUID? = nil
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Button{
                    print("tap add home")
                    model.handleAddhome()
                } label: {
                    Image(systemName: "house")
                    Text("Ajouter une maison")
                }.foregroundStyle(.white)
            }.padding(.horizontal,30)
                .padding(.top, 100)
            Text("Selectionner une Maison")
                .font(.title)
                .foregroundStyle(.white)
                .bold()
                .padding()
            ScrollView {
                VStack {
                        ForEach(model.homes, id: \.id) { home in
                            NavigationLink {
                                HomeDetailView(model: HomeDetailViewModel(home: home,
                                                                          HomeKitStorage()))
                            } label: {
                                GenericCellView(cellType: .home, name: home.name)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                            }
                            
                        }
                }
            }
        }
        .lumenMemoryBG()
        .alert("Entrer le nom de la maison",
               isPresented: $model.isPresentingAlert) {
            TextField("Entrer le nom de la maison",
                      text: $homeName)
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
    HomeListView(model: HomeListViewModel(HomeKitStorage()))
}

struct HomeListItem {
    var id: UUID
    var name: String
}
