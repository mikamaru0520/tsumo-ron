import Testing
@testable import TsumoRon
import TsumoRonCore

@Suite("Reducer のテスト")
struct ReducerTests {
    let reducer = AppReducer()

    @Test("役のトグル")
    func yakuToggle() {
        let state = AppState()

        // 役を選択
        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        #expect(state.selectedYaku.contains("tanyao"))

        // 再度選択で解除
        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        #expect(!state.selectedYaku.contains("tanyao"))
    }

    @Test("鳴きトグルで門前専用役が除外される")
    func nakiToggleRemovesMenzenOnlyYaku() {
        let state = AppState()

        // 平和（門前専用）を選択
        reducer.reduce(state: state, intent: .yakuTapped("pinfu"))
        #expect(state.selectedYaku.contains("pinfu"))

        // 鳴きありにする
        reducer.reduce(state: state, intent: .nakiToggled)
        #expect(state.isNaki)
        #expect(!state.selectedYaku.contains("pinfu"))
    }

    @Test("門前専用役は鳴きありの時選択不可")
    func menzenOnlyYakuNotSelectableWhenNaki() {
        let state = AppState()
        state.isNaki = true

        // 平和は選択できない
        #expect(!state.isSelectable("pinfu"))

        // タンヤオは選択できる
        #expect(state.isSelectable("tanyao"))
    }

    @Test("平和と七対子は同時に選択不可")
    func pinfuAndChiitoitsuMutuallyExclusive() {
        let state = AppState()

        // 平和を選択
        reducer.reduce(state: state, intent: .yakuTapped("pinfu"))
        #expect(state.selectedYaku.contains("pinfu"))

        // 七対子を選択すると平和が解除される
        reducer.reduce(state: state, intent: .yakuTapped("chiitoitsu"))
        #expect(state.selectedYaku.contains("chiitoitsu"))
        #expect(!state.selectedYaku.contains("pinfu"))
    }

    @Test("一盃口と二盃口は同時に選択不可")
    func iipeikouAndRyanpeikouMutuallyExclusive() {
        let state = AppState()

        // 一盃口を選択
        reducer.reduce(state: state, intent: .yakuTapped("iipeikou"))
        #expect(state.selectedYaku.contains("iipeikou"))

        // 二盃口を選択すると一盃口が解除される
        reducer.reduce(state: state, intent: .yakuTapped("ryanpeikou"))
        #expect(state.selectedYaku.contains("ryanpeikou"))
        #expect(!state.selectedYaku.contains("iipeikou"))
    }

    @Test("役牌の数を変更")
    func changeYakuhaiCount() {
        let state = AppState()

        reducer.reduce(state: state, intent: .yakuhaiCountChanged(2))
        #expect(state.yakuhaiCount == 2)

        // 範囲外は制限される
        reducer.reduce(state: state, intent: .yakuhaiCountChanged(-1))
        #expect(state.yakuhaiCount == 0)

        reducer.reduce(state: state, intent: .yakuhaiCountChanged(5))
        #expect(state.yakuhaiCount == 4)
    }

    @Test("ドラの数を変更")
    func changeDoraCount() {
        let state = AppState()

        reducer.reduce(state: state, intent: .doraCountChanged(3))
        #expect(state.doraCount == 3)

        // マイナスは0に制限
        reducer.reduce(state: state, intent: .doraCountChanged(-1))
        #expect(state.doraCount == 0)
    }

    @Test("符を変更")
    func changeFu() {
        let state = AppState()

        reducer.reduce(state: state, intent: .fuChanged(40))
        #expect(state.fu == 40)
    }

    @Test("親/子を変更")
    func changePlayerType() {
        let state = AppState()

        reducer.reduce(state: state, intent: .playerTypeChanged(.dealer))
        #expect(state.playerType == .dealer)

        reducer.reduce(state: state, intent: .playerTypeChanged(.nonDealer))
        #expect(state.playerType == .nonDealer)
    }

    @Test("ツモ/ロンを変更")
    func changeWinType() {
        let state = AppState()

        reducer.reduce(state: state, intent: .winTypeChanged(.tsumo))
        #expect(state.winType == .tsumo)

        reducer.reduce(state: state, intent: .winTypeChanged(.ron))
        #expect(state.winType == .ron)
    }

    @Test("計算ボタンで結果が計算される")
    func calculateScore() {
        let state = AppState()

        // タンヤオを選択
        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        reducer.reduce(state: state, intent: .calculateTapped)

        #expect(state.isResultPresented)
        #expect(state.calculatedScore != nil)
        #expect(state.calculatedScore?.hand.totalHan == 1)
    }

    @Test("役牌とドラを含めて計算")
    func calculateWithYakuhaiAndDora() {
        let state = AppState()

        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        reducer.reduce(state: state, intent: .yakuhaiCountChanged(1))
        reducer.reduce(state: state, intent: .doraCountChanged(2))
        reducer.reduce(state: state, intent: .calculateTapped)

        #expect(state.calculatedScore?.hand.totalHan == 4)  // 1 + 1 + 2
    }

    @Test("結果モーダルを閉じる")
    func dismissResult() {
        let state = AppState()
        state.isResultPresented = true

        reducer.reduce(state: state, intent: .resultDismissed)
        #expect(!state.isResultPresented)
    }

    @Test("ヘルプモーダルを開く・閉じる")
    func helpModal() {
        let state = AppState()

        // ヘルプを開く
        reducer.reduce(state: state, intent: .helpTapped("tanyao"))
        #expect(state.helpYakuId == "tanyao")

        // ヘルプを閉じる
        reducer.reduce(state: state, intent: .helpDismissed)
        #expect(state.helpYakuId == nil)
    }

    @Test("リセット")
    func reset() {
        let state = AppState()

        // 状態を変更
        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        reducer.reduce(state: state, intent: .yakuhaiCountChanged(2))
        reducer.reduce(state: state, intent: .doraCountChanged(1))
        reducer.reduce(state: state, intent: .fuChanged(40))
        reducer.reduce(state: state, intent: .nakiToggled)

        // リセット
        reducer.reduce(state: state, intent: .resetTapped)

        #expect(state.selectedYaku.isEmpty)
        #expect(state.yakuhaiCount == 0)
        #expect(state.doraCount == 0)
        #expect(state.fu == 30)
        #expect(!state.isNaki)
        #expect(!state.isResultPresented)
        #expect(state.helpYakuId == nil)
    }

    @Test("翻数の合計計算")
    func totalHanCalculation() {
        let state = AppState()

        // タンヤオ（1翻）+ 役牌（2翻）+ ドラ（3翻）
        reducer.reduce(state: state, intent: .yakuTapped("tanyao"))
        reducer.reduce(state: state, intent: .yakuhaiCountChanged(2))
        reducer.reduce(state: state, intent: .doraCountChanged(3))

        #expect(state.totalHan == 6)
    }

    @Test("鳴き時の翻数計算")
    func nakiHanCalculation() {
        let state = AppState()

        // 三色同順（門前2翻、鳴き1翻）
        reducer.reduce(state: state, intent: .yakuTapped("sanshoku_doujun"))

        // 門前
        #expect(state.totalHan == 2)

        // 鳴きあり
        reducer.reduce(state: state, intent: .nakiToggled)
        #expect(state.totalHan == 1)
    }
}
