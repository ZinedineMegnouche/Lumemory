import Foundation
import SwiftUI
import HomeKit

class HomeListViewModel: ObservableObject {
    
    @Published var homes: [HomeListItem] = []
    @Published var isPresentingAlert: Bool = false
    private let homeKitStorage: HomeKitStorage
    
    init(_ homeKitStorage: HomeKitStorage) {
        self.homeKitStorage = homeKitStorage
        manageHomes()
    }
    
    func handleAddhome(){
        isPresentingAlert = true
    }
    
    func addHome(homeName: String) -> Void {
        if homeName.isNameValid(){
            homeKitStorage.addHome(homeName: homeName)
        }
        isPresentingAlert = false
    }
    
    func manageHomes(){
        homeKitStorage.$homes.map { homes in
            homes.map { home in .init(id: home.uniqueIdentifier, name: home.name)}
        }.assign(to: &$homes)
    }
}
