import SwiftUI

enum AppColors {
    // 背景
    static let background = Color("Background")
    static let cardBackground = Color("CardBackground")

    // メインカラー（麻雀卓の緑）
    static let primary = Color("Primary")
    static let primaryLight = Color("PrimaryLight")
    static let primaryDark = Color("PrimaryDark")

    // アクセント
    static let accent = Color("Accent")        // 朱色
    static let accentYellow = Color("AccentYellow")  // 黄色

    // テキスト
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")

    // 牌の色
    static let manzu = Color("Manzu")    // 萬子（赤）
    static let pinzu = Color("Pinzu")    // 筒子（青）
    static let souzu = Color("Souzu")    // 索子（緑）
    static let hatsu = Color("Hatsu")    // 發（緑）
    static let chun = Color("Chun")      // 中（赤）
}

// カラーアセットの実体定義（extension で代替）
extension Color {
    static let appBackground: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.1, green: 0.12, blue: 0.1, alpha: 1.0)  // ダークモード: 暗い緑
                : UIColor(red: 0.95, green: 0.97, blue: 0.95, alpha: 1.0)  // ライトモード: 明るいグレー
        })
        #else
        return Color(red: 0.95, green: 0.97, blue: 0.95)
        #endif
    }()

    static let appCardBackground: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.15, green: 0.18, blue: 0.15, alpha: 1.0)
                : UIColor.white
        })
        #else
        return Color.white
        #endif
    }()

    static let appPrimary: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0)  // ダークモード: 少し暗い緑
                : UIColor(red: 0.15, green: 0.6, blue: 0.35, alpha: 1.0)  // ライトモード: 麻雀卓の緑
        })
        #else
        return Color(red: 0.15, green: 0.6, blue: 0.35)
        #endif
    }()

    static let appPrimaryLight: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.25, green: 0.55, blue: 0.35, alpha: 1.0)
                : UIColor(red: 0.4, green: 0.75, blue: 0.55, alpha: 1.0)
        })
        #else
        return Color(red: 0.4, green: 0.75, blue: 0.55)
        #endif
    }()

    static let appPrimaryDark: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.1, green: 0.4, blue: 0.2, alpha: 1.0)
                : UIColor(red: 0.1, green: 0.45, blue: 0.25, alpha: 1.0)
        })
        #else
        return Color(red: 0.1, green: 0.45, blue: 0.25)
        #endif
    }()

    static let appAccent: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1.0)
                : UIColor(red: 0.85, green: 0.25, blue: 0.15, alpha: 1.0)  // 朱色
        })
        #else
        return Color(red: 0.85, green: 0.25, blue: 0.15)
        #endif
    }()

    static let appAccentYellow: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1.0)
                : UIColor(red: 0.95, green: 0.75, blue: 0.1, alpha: 1.0)  // 黄色
        })
        #else
        return Color(red: 0.95, green: 0.75, blue: 0.1)
        #endif
    }()

    static let appTextPrimary: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.white
                : UIColor.black
        })
        #else
        return Color.black
        #endif
    }()

    static let appTextSecondary: Color = {
        #if canImport(UIKit)
        return Color(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(white: 0.7, alpha: 1.0)
                : UIColor(white: 0.5, alpha: 1.0)
        })
        #else
        return Color(white: 0.5)
        #endif
    }()

    // 牌の色
    static let appManzu = Color(red: 0.8, green: 0.1, blue: 0.1)  // 赤
    static let appPinzu = Color(red: 0.1, green: 0.3, blue: 0.8)  // 青
    static let appSouzu = Color(red: 0.15, green: 0.65, blue: 0.2)  // 緑
    static let appHatsu = Color(red: 0.1, green: 0.7, blue: 0.2)  // 發（緑）
    static let appChun = Color(red: 0.85, green: 0.1, blue: 0.1)  // 中（赤）
}
