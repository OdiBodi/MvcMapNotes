import UIKit

@propertyWrapper
struct HexCodableColor: Codable {
    var wrappedValue: UIColor

    init(wrappedValue: UIColor) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)

        guard let color = UIColor(hex: hexString) else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "The value is not a valid hex color")
        }

        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.hex())
    }
}
