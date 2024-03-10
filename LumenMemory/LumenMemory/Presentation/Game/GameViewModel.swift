import SwiftUI
import Foundation
import HomeKit
import Combine

class GameViewModel: ObservableObject {
    
    @ObservedObject var watchConnector = WatchConnector()
    
    @Published var home: HomeListItem
    @Published var accesory: HMAccessory
    @Published var gameDifficulty: GameDifficulty
    @Published var isShowingColor = false
    @Published var round: Int = 1
    @Published var showedColors: [GameColor] = []
    @Published var isGameStarted = false
    @Published var isGameFinished = false
    @Published var isBestScore = false
    
    var score: Int {
        return (round-1)*10*gameDifficulty.rawValue
    }
    
    var bestScore: Int {
        return UserDefaults.standard.integer(forKey: "Best\(self.gameDifficulty.rawValue)")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var indexColor: Int = 0
    private let homeKitStorage: HomeKitStorage
    
    init(home: HomeListItem, accesory: HMAccessory,difficulty: GameDifficulty, homeKitStorage: HomeKitStorage) {
        self.home = home
        self.accesory = accesory
        self.gameDifficulty = difficulty
        self.homeKitStorage = homeKitStorage
        bind()
    }
    
    func bind(){
        watchConnector.$receivedColor
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { color in
                self.didTapColor(color: color)
            }.store(in: &cancellables)
        
        watchConnector.$restart
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.startGame()
            }.store(in: &cancellables)
    }
    
    func didTapColor(color: GameColor) {
        checkColor(color: color)
    }
    
    func checkColor(color: GameColor) {
        if indexColor < showedColors.count {
            if self.showedColors[safe: indexColor] == color {
                if indexColor + 1 == showedColors.count {
                    indexColor = 0
                    round += 1
                    continueGame()
                } else {
                    indexColor += 1
                }
            } else {
                endGame()
            }
        } else {
            indexColor = 0
            round += 1
            continueGame()
        }
    }
    
    func endGame() {
        DispatchQueue.main.async {
            self.turnOnLight()
            self.indexColor = 0
            let bestScore = UserDefaults.standard.integer(forKey: "Best\(self.gameDifficulty.rawValue)")
            if self.score > bestScore {
                self.isBestScore = true
                UserDefaults.standard.set(self.score, forKey: "Best\(self.gameDifficulty.rawValue)")
            }
            self.watchConnector.sendPlaystate(playState: .gameOver)
            self.watchConnector.sendScore(self.score)
            self.watchConnector.sendBestScore(self.bestScore)
            self.isGameFinished = true
        }
    }
    
    func resetGame() {
        DispatchQueue.main.async {
            self.turnOnLight()
            self.indexColor = 0
            self.round = 1
            self.isGameStarted = false
        }
    }
    
    func initRound() {
        for i in 0..<self.round*self.gameDifficulty.rawValue {
            if self.showedColors[safe: i] == nil {
                self.showedColors.append(GameColor.random())
            }
        }
    }
    
    func endRound() {
        self.isShowingColor = false
        self.turnOnLight()
        self.watchConnector.sendPlaystate(playState: .canPlay)
    }
    
    func beginRound(showingColors: [GameColor]) {
        guard !showingColors.isEmpty else { return }
        var gameColor = showingColors
        if let currentColor = gameColor[safe: 0]{
            self.decreaseBrightness()
            self.changeColor(color: currentColor)
            gameColor.removeFirst()
        }
        self.watchConnector.sendPlaystate(playState: .cannotPlay)
        DispatchQueue.main.asyncAfter(deadline: .now()+(gameColor.isEmpty ? 5 : 5)){
            if !gameColor.isEmpty {
                self.beginRound(showingColors: gameColor)
            } else {
                self.endRound()
            }
        }
    }
    
    func continueGame() {
        isShowingColor = true
        initRound()
        beginRound(showingColors: self.showedColors)
    }
    
    func startGame() {
        DispatchQueue.main.async {
            self.isBestScore = false
            self.round = 1
            self.isGameFinished = false
            self.isGameStarted = true
            self.showedColors = []
            self.isShowingColor = true
            self.turnOnLight()
            self.continueGame()
        }
    }
}

// MARK: HOMEKit

extension GameViewModel {
    
    func decreaseBrightness() {
        let totalTime: TimeInterval = 5
        let interval: TimeInterval = 0.1
        let steps = Int(totalTime / interval)
        let brightnessStep = 100 / steps
        
        for i in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (interval * TimeInterval(i))) {
                self.adjustBrightness(100 - (brightnessStep * (i + 1)))
            }
        }
    }
    
    func adjustBrightness(_ brightness: Int) {
        homeKitStorage.homes
            .first { $0.uniqueIdentifier == home.id }?
            .accessories
            .first { $0.uniqueIdentifier == accesory.uniqueIdentifier }?
            .services
            .first { $0.serviceType == HMServiceTypeLightbulb }?
            .characteristics
            .first { $0.characteristicType == HMCharacteristicTypeBrightness }?
            .writeValue(brightness) { error in
                if let error = error {
                    print("Error adjusting brightness: \(error)")
                }
            }
    }
    
    func turnOnLight(){
        homeKitStorage.homes
            .first{$0.uniqueIdentifier == home.id}?
            .accessories
            .first{$0.uniqueIdentifier == accesory.uniqueIdentifier}?
            .services
            .first{$0.serviceType == HMServiceTypeLightbulb}?
            .characteristics
            .first{$0.characteristicType == HMCharacteristicTypePowerState}?
            .writeValue(true) { error in
                if let error = error {
                    print("Error writing value: \(error)")
                }
            }
        saturationMin()
        brightnessMax()
    }
    
    func saturationMin(){
        homeKitStorage.homes
            .first{$0.uniqueIdentifier == home.id}?
            .accessories
            .first{$0.uniqueIdentifier == accesory.uniqueIdentifier}?
            .services
            .first{$0.serviceType == HMServiceTypeLightbulb}?
            .characteristics
            .first{$0.characteristicType == HMCharacteristicTypeSaturation}?
            .writeValue(0) { error in
                if let error = error {
                    print("Error writing value: \(error)")
                }
            }
    }
    func saturationMax(){
        homeKitStorage.homes
            .first{$0.uniqueIdentifier == home.id}?
            .accessories
            .first{$0.uniqueIdentifier == accesory.uniqueIdentifier}?
            .services
            .first{$0.serviceType == HMServiceTypeLightbulb}?
            .characteristics
            .first{$0.characteristicType == HMCharacteristicTypeSaturation}?
            .writeValue(100) { error in
                if let error = error {
                    print("Error writing value: \(error)")
                }
            }
    }
    
    func brightnessMax(){
        homeKitStorage.homes
            .first{$0.uniqueIdentifier == home.id}?
            .accessories
            .first{$0.uniqueIdentifier == accesory.uniqueIdentifier}?
            .services
            .first{$0.serviceType == HMServiceTypeLightbulb}?
            .characteristics
            .first{$0.characteristicType == HMCharacteristicTypeBrightness}?
            .writeValue(100) { error in
                if let error = error {
                    print("Error writing value: \(error)")
                }
            }
    }
    
    func changeColor(color: GameColor){
        saturationMax()
        homeKitStorage.homes
            .first{$0.uniqueIdentifier == home.id}?
            .accessories
            .first{$0.uniqueIdentifier == accesory.uniqueIdentifier}?
            .services
            .first{$0.serviceType == HMServiceTypeLightbulb}?
            .characteristics
            .first{$0.characteristicType == HMCharacteristicTypeHue}?
            .writeValue(color.getHueColor()) { error in
                if let error = error {
                    print("Error writing value: \(error)")
                }
            }
    }
}
