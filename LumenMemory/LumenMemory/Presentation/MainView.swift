import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Lumen")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                .bold()
                
                Text("Memory")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                .bold()
                
            }
            .padding(.top, 200)
            VStack{
                Spacer()
                NavigationLink {
                    HomeListView(model: HomeListViewModel(HomeKitStorage()))
                } label: {
                    RoundedText(text: "JOUER !")
                        .foregroundColor(.white)
                }
                Spacer()
            }.padding()
            Spacer()
        }.lumenMemoryBG()
    }
    
}

#Preview {
    NavigationStack{
        MainView()
    }
}
