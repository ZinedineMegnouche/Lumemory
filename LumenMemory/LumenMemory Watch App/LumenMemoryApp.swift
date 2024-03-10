import SwiftUI
// swiftlint:disable type_name
@main
struct LumenMemory_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            GameWatchView(model: GameWatchViewModel())
        }
    }
}
// swiftlint:enable type_name
