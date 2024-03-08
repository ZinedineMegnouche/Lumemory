import SwiftUI

struct HomeView: View {
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
                    HomesListPage(model: HomesListPageModel(HomeKitStorage()))
                } label: {
                   RoundedText(text: "JOUER !")
                }
                Spacer()
            }.padding()
            Spacer()
        }.background(Image("bg")
            .resizable()
            .scaledToFill())
        .ignoresSafeArea()
    }
    
}

#Preview {
    NavigationStack{
        HomeView()
    }
}

struct RoundedText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .bold()
            .font(.title)
            .padding()
//            .modifier(CustomTextStyle())
            .tint(.white).overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6).tint(.white)
            }
    }
}
