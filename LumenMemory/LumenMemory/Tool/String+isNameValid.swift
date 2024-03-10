import Foundation

extension String {
    func isNameValid() -> Bool {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
}
