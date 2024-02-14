import UIKit
import Combine

class NoteDetailsModel {
    @Published var color: UIColor
    @Published var text: String

    init(color: UIColor, text: String) {
        self.color = color
        self.text = text
    }
}
