import Foundation

/// ヘルプモーダルの対象
enum HelpTarget: Equatable, Sendable {
    case yaku(String)  // 役のID
    case yakuhai       // 役牌
}
