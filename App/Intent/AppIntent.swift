import Foundation
import TsumoRonCore

enum AppIntent {
    // 役の選択
    case yakuTapped(String)

    // 設定変更
    case yakuhaiCountChanged(Int)
    case doraCountChanged(Int)
    case fuChanged(Int)
    case playerTypeChanged(PlayerType)
    case winTypeChanged(WinType)
    case nakiToggled

    // モーダル
    case calculateTapped
    case resultDismissed
    case helpTapped(String)
    case helpDismissed

    // その他
    case resetTapped
}
