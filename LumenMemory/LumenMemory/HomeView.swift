import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("Button 1")
                } label: {
                    Text("Ajouter un accessoire")
                }.padding()
            }
            Text("LumenMemory").font(.title)
            Spacer()
            VStack{
                NavigationLink("Jouer", destination: HomesListPage(model: HomesListPageModel(HomeKitStorage())))
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack{
        HomeView()
    }
}
