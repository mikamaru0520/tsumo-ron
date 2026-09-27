import Foundation
import TsumoRonCore

final class AppReducer {
    private let calculator = ScoreCalculator()

    func reduce(state: AppState, intent: AppIntent) {
        switch intent {
        case .yakuTapped(let yakuId):
            handleYakuTapped(state: state, yakuId: yakuId)

        case .yakuhaiCountChanged(let count):
            state.yakuhaiCount = max(0, min(4, count))

        case .doraCountChanged(let count):
            state.doraCount = max(0, count)

        case .fuChanged(let fu):
            state.fu = fu

        case .playerTypeChanged(let playerType):
            state.playerType = playerType

        case .winTypeChanged(let winType):
            state.winType = winType

        case .nakiToggled:
            state.isNaki.toggle()
            // 鳴きありにした場合、門前専用役を除外
            if state.isNaki {
                state.selectedYaku = state.selectedYaku.filter { yakuId in
                    if let def = YakuDefinition.definitions[yakuId] {
                        return !def.isMenzenOnly
                    }
                    return false
                }
            }

        case .calculateTapped:
            handleCalculate(state: state)

        case .resultDismissed:
            state.isResultPresented = false

        case .helpTapped(let yakuId):
            state.helpYakuId = yakuId

        case .helpDismissed:
            state.helpYakuId = nil

        case .resetTapped:
            state.reset()
        }
    }

    private func handleYakuTapped(state: AppState, yakuId: String) {
        if state.selectedYaku.contains(yakuId) {
            state.selectedYaku.remove(yakuId)
        } else {
            // 相反する役を先に削除
            removeConflictingYaku(state: state, newYakuId: yakuId)

            // その後で選択可能かチェック（鳴きあり時の門前専用役など）
            if state.isSelectable(yakuId) {
                state.selectedYaku.insert(yakuId)
            }
        }
    }

    private func removeConflictingYaku(state: AppState, newYakuId: String) {
        switch newYakuId {
        case "pinfu":
            state.selectedYaku.remove("chiitoitsu")
        case "chiitoitsu":
            state.selectedYaku.remove("pinfu")
        case "ryanpeikou":
            state.selectedYaku.remove("iipeikou")
        case "iipeikou":
            state.selectedYaku.remove("ryanpeikou")
        case "junchan":
            state.selectedYaku.remove("chantai")
        case "chantai":
            state.selectedYaku.remove("junchan")
        case "chinitsu":
            state.selectedYaku.remove("honitsu")
        case "honitsu":
            state.selectedYaku.remove("chinitsu")
        default:
            break
        }
    }

    private func handleCalculate(state: AppState) {
        // 役を構築
        var yaku: [Yaku] = []

        // 選択された役
        for yakuId in state.selectedYaku {
            if let def = YakuDefinition.definitions[yakuId] {
                let han = state.isNaki && def.nakiHan != nil ? def.nakiHan! : def.menzenHan
                yaku.append(Yaku(id: def.id, name: def.name, han: han))
            }
        }

        // 役牌
        if state.yakuhaiCount > 0 {
            yaku.append(Yaku(id: "yakuhai", name: "役牌", han: state.yakuhaiCount))
        }

        // ドラ
        if state.doraCount > 0 {
            yaku.append(Yaku(id: "dora", name: "ドラ", han: state.doraCount))
        }

        let hand = Hand(
            yaku: yaku,
            fu: state.fu,
            playerType: state.playerType,
            winType: state.winType
        )

        state.calculatedScore = calculator.calculate(hand: hand)
        state.isResultPresented = true
    }
}
