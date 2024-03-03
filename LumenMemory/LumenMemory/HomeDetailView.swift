import SwiftUI
import HomeKit

struct HomeDetailView: View {
    
    @ObservedObject var model: HomeDetailViewModel
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    model.addLightAccessory()
                }, label: {
                    HStack{
                        Image(systemName: "arrow.circlepath")
                        Text("Rechercher des accessoires")
                    }
                })
            }
            List {
                Section {
                    ForEach(model.lightAccessories, id: \.uniqueIdentifier) { accessory in
                        Text(accessory.name)
                    }
                } header: {
                    Text("Lumières")
                }
            }
            List {
                Section {
                    ForEach(model.newAccessories, id: \.uniqueIdentifier) { accessory in
                        Button{
                            model.addAccesoryToHome(accessory: accessory)
                        } label: {
                            Text(accessory.name)
                            
                        }
                    }
                } header: {
                    Text("Nouveau Accesoire")
                }
            }
        }.alert(isPresented: $model.isPresentingAlert) {
            Alert(title: Text(""), message: Text(model.textAlert), dismissButton: .default(Text("OK")){
                model.isPresentingAlert = false
            })
        }
    }
}

class HomeDetailViewModel: NSObject, ObservableObject {
    
    @Published var home: UUID
    @Published var lightAccessories: [HMAccessory] = []
    @Published var newAccessories: [HMAccessory] = []
    @Published var isPresentingAlert: Bool = false
    @Published var textAlert: String = ""
    
    private var accessoryBrowser: HMAccessoryBrowser!
    
    private let homeKitStorage: HomeKitStorage
    
    init(home: UUID,_ homeKitStorage: HomeKitStorage) {
        print("🔥\(home)")
        self.home = home
        self.homeKitStorage = homeKitStorage
        self.accessoryBrowser = HMAccessoryBrowser()
        super.init()
        accessoryBrowser.delegate = self
        self.fetchData()
    }
    
    func fetchData() {
        homeKitStorage.$homes
            .map { homes in
                homes.first { home in home.uniqueIdentifier == self.home}?.accessories.filter { acc in
                    let isLightbulb = acc.services.contains { service in
                        service.serviceType == HMServiceTypeLightbulb && service.characteristics.contains {
                            $0.characteristicType == HMCharacteristicTypeHue
                        }
                    }
                    return isLightbulb
                } ?? []
            }.assign(to: &$lightAccessories)
    }
    
    func addLightAccessory() {
        accessoryBrowser.startSearchingForNewAccessories()
    }
}

extension HomeDetailViewModel: HMAccessoryBrowserDelegate {
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        newAccessories.append(accessory)
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        self.newAccessories.removeAll { acc in
            return acc.uniqueIdentifier == accessory.uniqueIdentifier
        }
    }
    
    func addAccesoryToHome(accessory: HMAccessory){
        homeKitStorage.homes.first{ $0.uniqueIdentifier == home}?.addAccessory(accessory, completionHandler: { err in
            if let err {
                self.textAlert = "impossible d'ajouter l'accessoire \(err)"
            } else {
                let isLightBulbHue = accessory.services.contains { $0.serviceType == HMServiceTypeLightbulb && $0.characteristics.contains {
                    $0.characteristicType == HMCharacteristicTypeHue
                }}
                self.textAlert = "L'accesoire \(accessory.name) à été ajouté avec succes au domicile"
                if !isLightBulbHue {
                    self.textAlert += " mais n'est pas compatible (l'accessoire n'est pas une ampoule avec couleurs)"
                }
                self.fetchData()
            }
            self.isPresentingAlert = true
        })
    }
}