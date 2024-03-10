import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var canPlay: Bool?
    
    var session: WCSession
    
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sendColor(_ gameColor: GameColor){
        if session.isReachable {
            session.sendMessage(["color": gameColor.rawValue], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let canPlay = message["canPlay"] as? Bool {
                self.canPlay = canPlay
            }
        }
    }
}
