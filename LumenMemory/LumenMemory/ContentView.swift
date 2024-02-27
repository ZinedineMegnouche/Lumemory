import SwiftUI

struct ContentView: View {
    
    @ObservedObject var watchConnector = WatchConnector()
    
    var body: some View {
        VStack {
            if let receivedColor = watchConnector.receivedColor {
                Circle()
                    .fill(receivedColor.uiColor())
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
