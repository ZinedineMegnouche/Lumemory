import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {

    @Published var receivedColor: GameColor?
    @Published var restart: Bool?

    var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print(activationState.rawValue)
        if let error = error {
            print(error)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let color = message["color"] as? Int {
                self.receivedColor = GameColorMapper.map(color: color)
            }
            if let restart = message["restart"] as? Bool {
                self.restart = restart
            }

        }
    }

    func sendPlaystate(playState: PlayState) {
        if session.isReachable {
            session.sendMessage(["playState": playState.rawValue], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }

    func sendScore(_ score: Int) {
        if session.isReachable {
            session.sendMessage(["score": score], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }

    func sendBestScore(_ score: Int) {
        if session.isReachable {
            session.sendMessage(["best": score], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }

}
