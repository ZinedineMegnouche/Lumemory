import SwiftUI

struct ContentView: View {
    
    @StateObject var watchConnectivity = WatchToiOSConnector()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    watchConnectivity.sendColor(.red)
                } label: {
                    Rectangle()
                        .fill(Color.red)
                }.background(Color.red)
                Button {
                    watchConnectivity.sendColor(.green)
                } label: {
                    Color.green
                }.background(Color.green)
            }
            HStack{
                Button {
                    watchConnectivity.sendColor(.blue)
                } label: {
                    Rectangle()
                        .fill(Color.blue)
                }.background(Color.blue)
                Button {
                    watchConnectivity.sendColor(.yellow)
                } label: {
                    Color.yellow
                }.background(Color.yellow)
                
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
