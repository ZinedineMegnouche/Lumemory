enum PlayState: Int, CaseIterable {
    
    case cannotPlay = 0
    case canPlay = 1
    case gameOver = 2
}

enum PlayStateMapper {
    
    static func map(state: Int) -> PlayState {
        switch state {
        case 0:
            return .cannotPlay
        case 1:
            return .canPlay
        case 2:
            return .gameOver
        default:
            return .cannotPlay
        }
    }
}
