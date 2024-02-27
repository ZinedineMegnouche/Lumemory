import Foundation
import SwiftUI

enum GameColor: Int {
    
    case red = 0
    case green = 1
    case blue = 2
    case yellow = 3
    case none = 4
}

extension GameColor{
    
    func random() -> GameColor {
        return GameColor(rawValue: Int.random(in: 0...3))!
    }
    
    func uiColor() -> Color {
        
        switch self{
        case .red:
                .red
        case .green:
                .green
        case .blue:
                .blue
        case .yellow:
                .yellow
        case .none:
                .white
        }
    }
}

enum GameColorMapper {
    
    static func map(color: Int) -> GameColor {
        switch color {
        case 0:
            return .red
        case 1:
            return .green
        case 2:
            return .blue
        case 3:
            return .yellow
        default:
            return .none
        }
    }
}
