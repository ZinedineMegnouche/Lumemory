import SwiftUI
import HomeKit

struct HomeDetailView: View {
    
    @ObservedObject var model: HomeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Button(action: {
                    model.addLightAccessory()
                }, label: {
                    HStack{
                        Image(systemName: "arrow.circlepath")
                        Text("Rechercher des accessoires")
                    }
                }).foregroundStyle(.white)
            }.padding(.horizontal,30)
                .padding(.top, 100)
            Text("Selectionner une ampoule")
                .font(.title)
                .foregroundStyle(.white)
                .bold()
                .padding()
            Text("Lumières")
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
                .padding()
            ScrollView{
                VStack {
                        ForEach(model.lightAccessories, id: \.uniqueIdentifier) { accessory in
                            NavigationLink {
                                GameMenuView(model: GameMenuViewModel(home: model.home, accesory: accessory))
                            } label: {
                                GenericCellView(cellType: .lightbulb, name: accessory.name)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                            }
                        }
            }
            if model.newAccessories.count > 0 {
                VStack(alignment: .leading) {
                    Text("Nouveau Accesoire")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .bold()
                        .padding()
                        VStack {
                                ForEach(model.newAccessories, id: \.uniqueIdentifier) { accessory in
                                    Button{
                                        model.addAccesoryToHome(accessory: accessory)
                                    } label: {
                                        GenericCellView(cellType: .unknown, name: accessory.name)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                    }
                                }
                        }
                }
            }
            }
                
        }.lumenMemoryBG()
        .alert(isPresented: $model.isPresentingAlert) {
            Alert(title: Text(""), message: Text(model.textAlert), dismissButton: .default(Text("OK")){
                model.isPresentingAlert = false
            })
        }
    }
}

#Preview {
    HomeDetailView(model: HomeDetailViewModel(home: HomeListItem(id: UUID(), name: "Test"),HomeKitStorage()))
}
