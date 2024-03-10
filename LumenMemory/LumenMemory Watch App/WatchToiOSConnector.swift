import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {

    @Published var playState: PlayState?
    @Published var score: Int?
    @Published var bestScore: Int?

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
    }

    func sendColor(_ gameColor: GameColor) {
        if session.isReachable {
            session.sendMessage(["color": gameColor.rawValue], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let playState = message["playState"] as? Int {
                self.playState = PlayStateMapper.map(state: playState)
            }
            if let score = message["score"] as? Int {
                self.score = score
            }
            if let best = message["best"] as? Int {
                self.bestScore = best
            }
        }
    }

    func sendRestart() {
        if session.isReachable {
            session.sendMessage(["restart": true], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }
}
