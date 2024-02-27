import HomeKit

class HomeKitStorage: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    @Published var homes: [HMHome] = []
    
    private var manager: HMHomeManager!
    
    override init(){
        super.init()
        load()
    }
    
    func load(){
        if manager == nil {
            manager = .init()
            manager.delegate = self
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager){
        self.homes = self.manager.homes
    }
    
    func addHome(){
        manager.addHome(withName: "NewHome\(UUID())") { [weak self] home, err in
            guard let self = self else { return }
            self.homeManagerDidUpdateHomes(self.manager)
        }
    }
    
    func addAccessory(_ accessory: HMAccessory,to homeID: UUID){
        homes.first { home in home.uniqueIdentifier == homeID}?.addAccessory(accessory, completionHandler: { err in
            print(err ?? "")
            print(accessory)
        })
    }
}
