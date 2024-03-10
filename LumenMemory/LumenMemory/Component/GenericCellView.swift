import SwiftUI

struct GenericCellView: View {

    var cellType: CellType
    var name: String

    var body: some View {

        HStack {
            cellImage
            Text(name)
            Spacer()
        }
        .cellFont()
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .foregroundStyle(.black)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.white)
                .shadowLarge()
        }
    }

    @ViewBuilder
    var cellImage: some View {
        if cellType == .lightbulb {
            Image(systemName: "lightbulb")
        } else if cellType == .home {
            Image(systemName: "house")
        }
    }
}

#Preview {
    Group {
        GenericCellView(cellType: .home, name: "House Name")
        GenericCellView(cellType: .lightbulb, name: "Accessory Name")
        GenericCellView(cellType: .unknown, name: "Accessory Name")
    }
}

enum CellType {

    case home
    case lightbulb
    case unknown
}
