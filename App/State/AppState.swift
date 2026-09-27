import Foundation
import TsumoRonCore

@Observable
final class AppState {
    var selectedYaku: Set<String> = []  // 選択された役のID
    var yakuhaiCount: Int = 0           // 役牌の数（0-4）
    var doraCount: Int = 0              // ドラの数
    var fu: Int = 30
    var playerType: PlayerType = .nonDealer
    var winType: WinType = .ron
    var isNaki: Bool = false            // 鳴きありか

    // モーダル表示状態
    var isResultPresented: Bool = false
    var helpYakuId: String? = nil

    // 計算結果
    var calculatedScore: Score? = nil

    init() {}

    /// 選択された役の合計翻数
    var totalHan: Int {
        var han = 0

        // 役の翻数
        for yakuId in selectedYaku {
            if let def = YakuDefinition.definitions[yakuId] {
                han += isNaki && def.nakiHan != nil ? def.nakiHan! : def.menzenHan
            }
        }

        // 役牌
        han += yakuhaiCount

        // ドラ
        han += doraCount

        return han
    }

    /// 役が1つ以上選択されているか（役牌・ドラは除く）
    var hasYaku: Bool {
        !selectedYaku.isEmpty || yakuhaiCount > 0
    }

    /// 指定された役が選択可能かどうか
    func isSelectable(_ yakuId: String) -> Bool {
        guard let def = YakuDefinition.definitions[yakuId] else { return false }

        // 鳴きありの場合、門前専用役は選択不可
        if isNaki && def.isMenzenOnly {
            return false
        }

        // 平和と七対子は同時に選択不可
        if yakuId == "pinfu" && selectedYaku.contains("chiitoitsu") {
            return false
        }
        if yakuId == "chiitoitsu" && selectedYaku.contains("pinfu") {
            return false
        }

        // 一盃口と二盃口は同時に選択不可（二盃口が優先）
        if yakuId == "iipeikou" && selectedYaku.contains("ryanpeikou") {
            return false
        }
        if yakuId == "ryanpeikou" && selectedYaku.contains("iipeikou") {
            return false
        }

        // チャンタと純チャンは同時に選択不可
        if yakuId == "chantai" && selectedYaku.contains("junchan") {
            return false
        }
        if yakuId == "junchan" && selectedYaku.contains("chantai") {
            return false
        }

        // 混一色と清一色は同時に選択不可
        if yakuId == "honitsu" && selectedYaku.contains("chinitsu") {
            return false
        }
        if yakuId == "chinitsu" && selectedYaku.contains("honitsu") {
            return false
        }

        return true
    }

    /// リセット
    func reset() {
        selectedYaku.removeAll()
        yakuhaiCount = 0
        doraCount = 0
        fu = 30
        playerType = .nonDealer
        winType = .ron
        isNaki = false
        isResultPresented = false
        helpYakuId = nil
        calculatedScore = nil
    }
}
