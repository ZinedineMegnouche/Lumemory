import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Lumen")
                    .titleFont()
                .shadowTitle(color: .cyan)
                Text("Memory")
                .titleFont()
                .shadowTitle(color: .yellow)
            }
            .padding(.top, 200)
            VStack {
                Spacer()
                NavigationLink {
                    HomeListView(model: HomeListViewModel(HomeKitStorage()))
                } label: {
                    RoundedText(text: "JOUER !")
                        .shadowTitle(color: .green)
                        .foregroundColor(.white)
                }
                Spacer()
            }.padding()
            Spacer()
        }.lumenMemoryBG()
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
