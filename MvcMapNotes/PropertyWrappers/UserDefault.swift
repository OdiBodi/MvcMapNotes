import Foundation

@propertyWrapper
struct UserDefault<TypeValue> {
    let key: String
    let defaultValue: TypeValue
    var container: UserDefaults = .standard

    var wrappedValue: TypeValue {
        get {
            container.object(forKey: key) as? TypeValue ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
