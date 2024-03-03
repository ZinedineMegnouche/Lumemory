import SwiftUI

@main
struct LumenMemory_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            GameWatchView(model: GameWatchViewModel())
        }
    }
}
