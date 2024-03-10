import SwiftUI
import HomeKit

class GameMenuViewModel: ObservableObject {
    @Published var home: HomeListItem
    @Published var accesory: HMAccessory

    init(home: HomeListItem, accesory: HMAccessory) {
        self.home = home
        self.accesory = accesory
    }
}
