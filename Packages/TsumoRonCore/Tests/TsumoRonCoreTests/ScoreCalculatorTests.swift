import Testing
@testable import TsumoRonCore

@Suite("点数計算のテスト")
struct ScoreCalculatorTests {
    let calculator = ScoreCalculator()

    @Test("子 30符1翻 ロン")
    func childRon30Fu1Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 1)],
            fu: 30,
            playerType: .nonDealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerRon(let total) = score.payment {
            #expect(total == 1000)
        } else {
            Issue.record("Expected nonDealerRon payment")
        }
    }

    @Test("子 30符2翻 ロン")
    func childRon30Fu2Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 2)],
            fu: 30,
            playerType: .nonDealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerRon(let total) = score.payment {
            #expect(total == 2000)
        } else {
            Issue.record("Expected nonDealerRon payment")
        }
    }

    @Test("子 30符3翻 ロン")
    func childRon30Fu3Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 3)],
            fu: 30,
            playerType: .nonDealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerRon(let total) = score.payment {
            #expect(total == 3900)
        } else {
            Issue.record("Expected nonDealerRon payment")
        }
    }

    @Test("子 30符4翻 ロン（満貫）")
    func childRon30Fu4Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 4)],
            fu: 30,
            playerType: .nonDealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerRon(let total) = score.payment {
            #expect(total == 8000)
        } else {
            Issue.record("Expected nonDealerRon payment")
        }
    }

    @Test("親 30符1翻 ロン")
    func dealerRon30Fu1Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 1)],
            fu: 30,
            playerType: .dealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .dealerRon(let total) = score.payment {
            #expect(total == 1500)
        } else {
            Issue.record("Expected dealerRon payment")
        }
    }

    @Test("親 30符2翻 ロン")
    func dealerRon30Fu2Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 2)],
            fu: 30,
            playerType: .dealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .dealerRon(let total) = score.payment {
            #expect(total == 2900)
        } else {
            Issue.record("Expected dealerRon payment")
        }
    }

    @Test("子 30符1翻 ツモ")
    func childTsumo30Fu1Han() {
        let hand = Hand(
            yaku: [Yaku(id: "tsumo", name: "門前清自摸和", han: 1)],
            fu: 30,
            playerType: .nonDealer,
            winType: .tsumo
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerTsumo(let fromDealer, let fromNonDealer) = score.payment {
            #expect(fromDealer == 500)
            #expect(fromNonDealer == 300)
        } else {
            Issue.record("Expected nonDealerTsumo payment")
        }
    }

    @Test("親 30符1翻 ツモ")
    func dealerTsumo30Fu1Han() {
        let hand = Hand(
            yaku: [Yaku(id: "test", name: "テスト役", han: 1)],
            fu: 30,
            playerType: .dealer,
            winType: .tsumo
        )
        let score = calculator.calculate(hand: hand)

        if case .dealerTsumo(let fromEach) = score.payment {
            #expect(fromEach == 500)
        } else {
            Issue.record("Expected dealerTsumo payment")
        }
    }

    @Test("役満（子ロン）")
    func yakumanChildRon() {
        let hand = Hand(
            yaku: [Yaku(id: "kokushi", name: "国士無双", han: 13)],
            fu: 30,
            playerType: .nonDealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .nonDealerRon(let total) = score.payment {
            #expect(total == 32000)
        } else {
            Issue.record("Expected nonDealerRon payment")
        }
    }

    @Test("役満（親ロン）")
    func yakumanDealerRon() {
        let hand = Hand(
            yaku: [Yaku(id: "suuankou", name: "四暗刻", han: 13)],
            fu: 30,
            playerType: .dealer,
            winType: .ron
        )
        let score = calculator.calculate(hand: hand)

        if case .dealerRon(let total) = score.payment {
            #expect(total == 48000)
        } else {
            Issue.record("Expected dealerRon payment")
        }
    }
}
