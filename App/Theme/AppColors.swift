import SwiftUI

extension Color {
    // Asset Catalog から色を読み込む
    static let appBackground = Color("AppBackground")
    static let appPrimary = Color("AppPrimary")
    static let appPrimaryLight = Color("AppPrimaryLight")
    static let appAccent = Color("AppAccent")
    static let appAccentYellow = Color("AppAccentYellow")
    static let appTextPrimary = Color("AppTextPrimary")
    static let appTextSecondary = Color("AppTextSecondary")
    static let appCardBackground = Color("AppCardBackground")

    // 牌の色（既存の TileView 用、後で改修時に削除または変更）
    static let appManzu = Color(red: 0.8, green: 0.1, blue: 0.1)  // 赤
    static let appPinzu = Color(red: 0.1, green: 0.3, blue: 0.8)  // 青
    static let appSouzu = Color(red: 0.15, green: 0.65, blue: 0.2)  // 緑
    static let appHatsu = Color(red: 0.1, green: 0.7, blue: 0.2)  // 發（緑）
    static let appChun = Color(red: 0.85, green: 0.1, blue: 0.1)  // 中（赤）
}
