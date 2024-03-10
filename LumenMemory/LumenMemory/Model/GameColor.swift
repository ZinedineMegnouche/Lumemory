import Foundation
import SwiftUI

enum GameColor: Int, CaseIterable {
    
    case red = 0
    case green = 1
    case blue = 2
    case yellow = 3
    
    static func random() -> GameColor {
        return GameColor(rawValue: Int.random(in: 0...GameColor.allCases.count-1))!
    }
}

extension GameColor{
    
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
        }
    }
    
    func getHueColor() -> CGFloat {
        switch self{
        case .red:
            return 0
        case .green:
            return 120
        case .blue:
            return 240
        case .yellow:
            return 60
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
            return .red
        }
    }
}
