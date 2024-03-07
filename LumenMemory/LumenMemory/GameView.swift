import SwiftUI
import HomeKit
import Combine

struct GameView: View {
    
    @ObservedObject var model: GameViewModel
    
    var body: some View {
        VStack{
            HStack{
                Text("Round \(model.round)")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
                if !model.isGameStarted || model.isGameFinished {
                    Button{
                        model.startGame()
                    }label: {
                        Text("Start")
                    }
                }
            }
            VStack {
                HStack {
                    Button {
                        model.didTapColor(color: .red)
                    } label: {
                        Rectangle()
                            .fill(Color.red)
                    }
                    .buttonStyle(GameButtonStyle())
                    Button {
                        model.didTapColor(color: .green)
                    } label: {
                        Color.green
                    }
                        .buttonStyle(GameButtonStyle())
                }
                HStack{
                    Button {
                        model.didTapColor(color: .blue)
                    } label: {
                        Rectangle()
                            .fill(Color.blue)
                    }
                        .buttonStyle(GameButtonStyle())
                    Button {
                        model.didTapColor(color: .yellow)
                    } label: {
                        Color.yellow
                    }
                        .buttonStyle(GameButtonStyle())
                }
            }.disabled(!model.isGameStarted || (model.isShowingColor && model.isGameStarted )).overlay {
                model.isShowingColor || model.isGameFinished ? Color.black.opacity(0.8) : nil
            }
            .overlay {
                if model.isShowingColor {
                    Text("Mémorisez les couleurs")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                } else if model.isGameFinished {
                    Text("GAME OVER")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    GameView(model: GameViewModel(home: HomeListItem(id: UUID(), 
                                                     name: "My Home"),
                                  accesory: HMAccessory(),
                                  difficulty: .easy,
                                  homeKitStorage: HomeKitStorage()))
}

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
    
    private var cancellables = Set<AnyCancellable>()
    
    var indexColor: Int = 0
    private let homeKitStorage: HomeKitStorage
    
    init(home: HomeListItem, accesory: HMAccessory,difficulty: GameDifficulty, homeKitStorage: HomeKitStorage) {
        self.home = home
        self.accesory = accesory
        self.gameDifficulty = difficulty
        self.homeKitStorage = homeKitStorage
        watchConnector.$receivedColor
            .compactMap { $0 }
            .sink { color in
                self.didTapColor(color: color)
            }.store(in: &cancellables)
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
    
    func didTapColor(color: GameColor) {
        print("👌tap :\(color)")
        checkColor(color: color)
    }
    
    func checkColor(color: GameColor) {
        print("showed Color: ",showedColors)
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
    
    
    func waitingColor(){
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
    
    func endGame() {
        DispatchQueue.main.async {
            self.turnOnLight()
            self.indexColor = 0
            self.round = 1
            self.isGameFinished = true
            self.watchConnector.sendIsPlaying(canPlay: false)
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
    
    func continueGame() {
        DispatchQueue.global().async {
            self.isShowingColor = true
            self.watchConnector.sendIsPlaying(canPlay: false)
            for i in 0..<self.round*self.gameDifficulty.rawValue {
                if self.showedColors[safe: i] == nil {
                    self.showedColors.append(GameColor.random())
                }
                DispatchQueue.main.async {
                    self.decreaseBrightness()
                    self.changeColor(color: self.showedColors[i])
                }
                Thread.sleep(forTimeInterval: 5)
            }
            DispatchQueue.main.async {
                self.isShowingColor = false
                print("🔥\(self.showedColors)")
                self.turnOnLight()
                self.watchConnector.sendIsPlaying(canPlay: true)
            }
        }
    }
    
    func startGame() {
        DispatchQueue.main.async {
            self.isGameFinished = false
            self.isGameStarted = true
            self.showedColors = []
            self.isShowingColor = true
            self.turnOnLight()
            self.continueGame()
        }
    }
}

enum GameDifficulty: Int {
    case easy = 1
    case medium = 2
    case hard = 3
}
