import Testing
@testable import TsumoRonCore

@Suite("牌姿例の妥当性テスト")
struct ExampleHandTests {

    // MARK: - 基本検証

    @Test("すべての牌姿例が14枚である")
    func allExamplesHave14Tiles() throws {
        for (yakuId, example) in YakuExample.examples {
            let tileCount = example.allTiles.count
            #expect(tileCount == 14, "\(yakuId): 牌数が\(tileCount)枚（14枚であるべき）")
        }
    }

    @Test("同じ牌は4枚まで")
    func noMoreThan4OfSameTile() throws {
        for (yakuId, example) in YakuExample.examples {
            let tileCounts = Dictionary(grouping: example.allTiles, by: { $0 })
                .mapValues { $0.count }

            for (tile, count) in tileCounts {
                #expect(count <= 4, "\(yakuId): \(tile) が\(count)枚（4枚まで）")
            }
        }
    }

    @Test("4面子1雀頭または七対子の形")
    func validMeldStructure() throws {
        for (yakuId, example) in YakuExample.examples {
            if yakuId == "chiitoitsu" {
                // 七対子: 7種類の対子
                #expect(example.pair.count == 14, "\(yakuId): 七対子は14枚すべてが対子")
                #expect(example.melds.isEmpty, "\(yakuId): 七対子は面子なし")

                let pairs = stride(from: 0, to: example.pair.count, by: 2).map {
                    Array(example.pair[$0..<min($0+2, example.pair.count)])
                }
                #expect(pairs.count == 7, "\(yakuId): 7つの対子")

                for pair in pairs {
                    if pair.count == 2 {
                        #expect(pair[0] == pair[1], "\(yakuId): 各ペアは同じ牌2枚")
                    }
                }

                let uniqueTiles = Set(pairs.compactMap { $0.first })
                #expect(uniqueTiles.count == 7, "\(yakuId): 7種類の異なる牌")
            } else {
                // 通常: 4面子1雀頭
                #expect(example.melds.count == 4, "\(yakuId): 4面子")
                #expect(example.pair.count == 2, "\(yakuId): 雀頭は2枚")
                #expect(example.pair[0] == example.pair[1], "\(yakuId): 雀頭は同じ牌2枚")

                for meld in example.melds {
                    #expect(meld.tiles.count == 3, "\(yakuId): 各面子は3枚")
                }
            }
        }
    }

    // MARK: - 役ごとの条件チェック

    @Test("タンヤオ: 1・9牌と字牌を含まない")
    func tanyaoNoTerminalsOrHonors() throws {
        guard let example = YakuExample.examples["tanyao"] else {
            Issue.record("tanyao の例が見つかりません")
            return
        }

        for tile in example.allTiles {
            #expect(!tile.isTerminalOrHonor, "タンヤオ: \(tile) は中張牌であるべき")
        }
    }

    @Test("混一色: 数牌が1種類のみ＋字牌を含む")
    func honitsuOneSuitPlusHonors() throws {
        guard let example = YakuExample.examples["honitsu"] else {
            Issue.record("honitsu の例が見つかりません")
            return
        }

        let suits = Set(example.allTiles.compactMap { tile -> TileType? in
            switch tile {
            case .manzu, .pinzu, .souzu:
                return tile.type
            case .jihai:
                return nil
            }
        })

        #expect(suits.count == 1, "混一色: 数牌は1種類のみ")

        let hasJihai = example.allTiles.contains { tile in
            if case .jihai = tile { return true }
            return false
        }
        #expect(hasJihai, "混一色: 字牌を含む")
    }

    @Test("清一色: 数牌が1種類のみ、字牌なし")
    func chinitsuOneSuitOnly() throws {
        guard let example = YakuExample.examples["chinitsu"] else {
            Issue.record("chinitsu の例が見つかりません")
            return
        }

        let types = Set(example.allTiles.map { $0.type })
        #expect(types.count == 1, "清一色: 1種類の牌のみ")
        #expect(!types.contains(.jihai), "清一色: 字牌なし")
    }

    @Test("対々和: 4面子すべて刻子")
    func toitoiAllKoutsu() throws {
        guard let example = YakuExample.examples["toitoi"] else {
            Issue.record("toitoi の例が見つかりません")
            return
        }

        for meld in example.melds {
            #expect(meld.type == .koutsu, "対々和: すべて刻子")
            #expect(
                meld.tiles[0] == meld.tiles[1] && meld.tiles[1] == meld.tiles[2],
                "対々和: 刻子は同じ牌3枚"
            )
        }
    }

    @Test("七対子: 異なる7種類の対子")
    func chiitoitsu7DifferentPairs() throws {
        guard let example = YakuExample.examples["chiitoitsu"] else {
            Issue.record("chiitoitsu の例が見つかりません")
            return
        }

        let pairs = stride(from: 0, to: example.pair.count, by: 2).map {
            Array(example.pair[$0..<min($0+2, example.pair.count)])
        }

        let uniqueTiles = Set(pairs.compactMap { $0.first })
        #expect(uniqueTiles.count == 7, "七対子: 7種類の異なる対子")
    }

    @Test("平和: 4面子すべて順子、雀頭が役牌でない")
    func pinfuAllShuntsuNonYakuhaiPair() throws {
        guard let example = YakuExample.examples["pinfu"] else {
            Issue.record("pinfu の例が見つかりません")
            return
        }

        for meld in example.melds {
            #expect(meld.type == .shuntsu, "平和: すべて順子")
        }

        let pairTile = example.pair[0]
        #expect(!pairTile.isSangenhai, "平和: 雀頭は役牌でない（三元牌チェック）")
    }

    @Test("一気通貫: 同じ種類の123・456・789の順子を含む")
    func ittsuHas123456789() throws {
        guard let example = YakuExample.examples["ittsu"] else {
            Issue.record("ittsu の例が見つかりません")
            return
        }

        // 順子を抽出
        let shuntsu = example.melds.filter { $0.type == .shuntsu }

        // 各順子の開始数字を取得
        let starts = shuntsu.compactMap { meld -> (TileType, Int)? in
            guard let first = meld.tiles.first,
                  let number = first.number else { return nil }
            return (first.type, number)
        }

        // 同じ種類で1,4,7始まりの順子があるかチェック
        let grouped = Dictionary(grouping: starts, by: { $0.0 })
        var found = false

        for (_, values) in grouped {
            let numbers = Set(values.map { $0.1 })
            if numbers.contains(1) && numbers.contains(4) && numbers.contains(7) {
                found = true
                break
            }
        }

        #expect(found, "一気通貫: 同じ種類の123・456・789を含む")
    }

    @Test("三色同順: 同じ数字の順子が萬・筒・索すべてにある")
    func sanshokuDoujunSameNumberAllSuits() throws {
        guard let example = YakuExample.examples["sanshoku_doujun"] else {
            Issue.record("sanshoku_doujun の例が見つかりません")
            return
        }

        // 順子を抽出
        let shuntsu = example.melds.filter { $0.type == .shuntsu }

        // 各順子の開始数字を取得
        let starts = shuntsu.compactMap { meld -> (TileType, Int)? in
            guard let first = meld.tiles.first,
                  let number = first.number else { return nil }
            return (first.type, number)
        }

        // 同じ数字で始まる順子が3種類あるかチェック
        let byNumber = Dictionary(grouping: starts, by: { $0.1 })
        var found = false

        for (_, values) in byNumber {
            let types = Set(values.map { $0.0 })
            if types.count == 3 && types.contains(.manzu) && types.contains(.pinzu) && types.contains(.souzu) {
                found = true
                break
            }
        }

        #expect(found, "三色同順: 同じ数字の順子が萬・筒・索すべてにある")
    }

    @Test("三色同刻: 同じ数字の刻子が萬・筒・索すべてにある")
    func sanshokuDoukouSameNumberAllSuits() throws {
        guard let example = YakuExample.examples["sanshoku_doukou"] else {
            Issue.record("sanshoku_doukou の例が見つかりません")
            return
        }

        // 刻子を抽出
        let koutsu = example.melds.filter { $0.type == .koutsu }

        // 各刻子の数字を取得
        let numbers = koutsu.compactMap { meld -> (TileType, Int)? in
            guard let first = meld.tiles.first,
                  let number = first.number else { return nil }
            return (first.type, number)
        }

        // 同じ数字の刻子が3種類あるかチェック
        let byNumber = Dictionary(grouping: numbers, by: { $0.1 })
        var found = false

        for (_, values) in byNumber {
            let types = Set(values.map { $0.0 })
            if types.count == 3 && types.contains(.manzu) && types.contains(.pinzu) && types.contains(.souzu) {
                found = true
                break
            }
        }

        #expect(found, "三色同刻: 同じ数字の刻子が萬・筒・索すべてにある")
    }

    @Test("一盃口: 同じ順子が2つ以上ある")
    func iipeikouHasDuplicateShuntsu() throws {
        guard let example = YakuExample.examples["iipeikou"] else {
            Issue.record("iipeikou の例が見つかりません")
            return
        }

        // 順子を抽出
        let shuntsu = example.melds.filter { $0.type == .shuntsu }

        // 順子を正規化して比較
        let normalized = shuntsu.map { $0.tiles.sorted(by: { "\($0)" < "\($1)" }) }
        let grouped = Dictionary(grouping: normalized, by: { $0 })

        let hasDuplicate = grouped.values.contains { $0.count >= 2 }
        #expect(hasDuplicate, "一盃口: 同じ順子が2つ以上ある")
    }

    @Test("二盃口: 同じ順子の組が2組ある")
    func ryanpeikouHasTwoPairs() throws {
        guard let example = YakuExample.examples["ryanpeikou"] else {
            Issue.record("ryanpeikou の例が見つかりません")
            return
        }

        // 順子を抽出
        let shuntsu = example.melds.filter { $0.type == .shuntsu }
        #expect(shuntsu.count == 4, "二盃口: 4面子すべて順子")

        // 順子を正規化して比較
        let normalized = shuntsu.map { $0.tiles.sorted(by: { "\($0)" < "\($1)" }) }
        let grouped = Dictionary(grouping: normalized, by: { $0 })

        let pairCount = grouped.values.filter { $0.count == 2 }.count
        #expect(pairCount == 2, "二盃口: 同じ順子のペアが2組")
    }

    @Test("小三元: 三元牌の刻子が2つ、三元牌の雀頭が1つ")
    func shousangenTwoKoutsuOnePair() throws {
        guard let example = YakuExample.examples["shousangen"] else {
            Issue.record("shousangen の例が見つかりません")
            return
        }

        // 三元牌の刻子をカウント
        let sangenKoutsu = example.melds.filter { meld in
            meld.type == .koutsu && meld.tiles[0].isSangenhai
        }
        #expect(sangenKoutsu.count == 2, "小三元: 三元牌の刻子が2つ")

        // 雀頭が三元牌かチェック
        #expect(example.pair[0].isSangenhai, "小三元: 雀頭は三元牌")
    }

    @Test("チャンタ: すべての面子と雀頭に1・9牌か字牌を含み、順子を1つ以上含み、字牌を含む")
    func chantaiAllSetsHaveTerminalsOrHonors() throws {
        guard let example = YakuExample.examples["chantai"] else {
            Issue.record("chantai の例が見つかりません")
            return
        }

        // 各面子が1・9牌または字牌を含むかチェック
        for meld in example.melds {
            let hasTerminalOrHonor = meld.tiles.contains { $0.isTerminalOrHonor }
            #expect(hasTerminalOrHonor, "チャンタ: 各面子に1・9牌または字牌を含む")
        }

        // 雀頭が1・9牌または字牌かチェック
        #expect(example.pair[0].isTerminalOrHonor, "チャンタ: 雀頭は1・9牌または字牌")

        // 順子を1つ以上含むかチェック
        let hasShuntsu = example.melds.contains { $0.type == .shuntsu }
        #expect(hasShuntsu, "チャンタ: 順子を1つ以上含む")

        // 字牌を含むかチェック
        let hasJihai = example.allTiles.contains { tile in
            if case .jihai = tile { return true }
            return false
        }
        #expect(hasJihai, "チャンタ: 字牌を含む")
    }

    @Test("純チャン: すべての面子と雀頭に1・9牌を含み、順子を1つ以上含み、字牌を含まない")
    func junchanAllSetsHaveTerminals() throws {
        guard let example = YakuExample.examples["junchan"] else {
            Issue.record("junchan の例が見つかりません")
            return
        }

        // 各面子が1・9牌を含むかチェック
        for meld in example.melds {
            let hasTerminal = meld.tiles.contains { tile in
                if let number = tile.number {
                    return number == 1 || number == 9
                }
                return false
            }
            #expect(hasTerminal, "純チャン: 各面子に1・9牌を含む")
        }

        // 雀頭が1・9牌かチェック
        if let number = example.pair[0].number {
            #expect(number == 1 || number == 9, "純チャン: 雀頭は1・9牌")
        }

        // 順子を1つ以上含むかチェック
        let hasShuntsu = example.melds.contains { $0.type == .shuntsu }
        #expect(hasShuntsu, "純チャン: 順子を1つ以上含む")

        // 字牌を含まないかチェック
        let hasJihai = example.allTiles.contains { tile in
            if case .jihai = tile { return true }
            return false
        }
        #expect(!hasJihai, "純チャン: 字牌を含まない")
    }

    @Test("混老頭: すべて1・9牌と字牌のみ")
    func honroutouOnlyTerminalsAndHonors() throws {
        guard let example = YakuExample.examples["honroutou"] else {
            Issue.record("honroutou の例が見つかりません")
            return
        }

        for tile in example.allTiles {
            #expect(tile.isTerminalOrHonor, "混老頭: すべて1・9牌または字牌")
        }
    }
}
