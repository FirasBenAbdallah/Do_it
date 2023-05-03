import Foundation

class LocalizationManager {

    static let shared = LocalizationManager()

    private init() {}

    func setLanguage(language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }

}
