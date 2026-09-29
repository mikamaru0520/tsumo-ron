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
    case kuiTanChanged(Bool)
    case kiriageChanged(Bool)
    case kazoeChanged(Bool)

    // モーダル
    case calculateTapped
    case settingsTapped
    case helpTapped(HelpTarget)
    case modalDismissed

    // その他
    case resetTapped
}
