/// 役の和了例
public struct YakuExample: Sendable {
    public let melds: [Meld]        // 面子
    public let pair: [Tile]         // 雀頭（2枚）
    public let winningTile: Tile    // 和了牌

    public init(melds: [Meld], pair: [Tile], winningTile: Tile) {
        self.melds = melds
        self.pair = pair
        self.winningTile = winningTile
    }

    /// 全ての牌（14枚）
    /// 和了牌は既に面子または雀頭に含まれている
    public var allTiles: [Tile] {
        melds.flatMap(\.tiles) + pair
    }

    /// 七対子の例を作成
    public static func chiitoitsu(pairs: [[Tile]], winningTile: Tile) -> YakuExample {
        YakuExample(melds: [], pair: pairs.flatMap { $0 }, winningTile: winningTile)
    }
}

extension YakuExample {
    /// 役ごとの牌姿例
    public static let examples: [String: YakuExample] = [
        // 1翻
        "pinfu": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(4), .manzu(5), .manzu(6)),
                .shuntsu(.pinzu(2), .pinzu(3), .pinzu(4)),
                .shuntsu(.souzu(5), .souzu(6), .souzu(7))
            ],
            pair: [.manzu(8), .manzu(8)],
            winningTile: .souzu(7)
        ),

        "tanyao": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(5), .manzu(6), .manzu(7)),
                .koutsu(.pinzu(3)),
                .shuntsu(.souzu(3), .souzu(4), .souzu(5))
            ],
            pair: [.pinzu(6), .pinzu(6)],
            winningTile: .souzu(5)
        ),

        "iipeikou": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.pinzu(5), .pinzu(6), .pinzu(7)),
                .koutsu(.souzu(8))
            ],
            pair: [.jihai(.ton), .jihai(.ton)],
            winningTile: .souzu(8)
        ),

        // 2翻
        "chiitoitsu": YakuExample.chiitoitsu(
            pairs: [
                [.manzu(2), .manzu(2)],
                [.manzu(4), .manzu(4)],
                [.pinzu(3), .pinzu(3)],
                [.pinzu(6), .pinzu(6)],
                [.souzu(5), .souzu(5)],
                [.souzu(7), .souzu(7)],
                [.jihai(.haku), .jihai(.haku)]
            ],
            winningTile: .jihai(.haku)
        ),

        "toitoi": YakuExample(
            melds: [
                .koutsu(.manzu(3)),
                .koutsu(.pinzu(5)),
                .koutsu(.souzu(7)),
                .koutsu(.jihai(.ton))
            ],
            pair: [.manzu(9), .manzu(9)],
            winningTile: .jihai(.ton)
        ),

        "sanshoku_doujun": YakuExample(
            melds: [
                .shuntsu(.manzu(3), .manzu(4), .manzu(5)),
                .shuntsu(.pinzu(3), .pinzu(4), .pinzu(5)),
                .shuntsu(.souzu(3), .souzu(4), .souzu(5)),
                .koutsu(.jihai(.hatsu))
            ],
            pair: [.manzu(1), .manzu(1)],
            winningTile: .souzu(5)
        ),

        "sanshoku_doukou": YakuExample(
            melds: [
                .koutsu(.manzu(6)),
                .koutsu(.pinzu(6)),
                .koutsu(.souzu(6)),
                .shuntsu(.manzu(1), .manzu(2), .manzu(3))
            ],
            pair: [.jihai(.nan), .jihai(.nan)],
            winningTile: .souzu(6)
        ),

        "ittsu": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(4), .manzu(5), .manzu(6)),
                .shuntsu(.manzu(7), .manzu(8), .manzu(9)),
                .koutsu(.pinzu(5))
            ],
            pair: [.souzu(2), .souzu(2)],
            winningTile: .manzu(9)
        ),

        "chantai": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(7), .manzu(8), .manzu(9)),
                .shuntsu(.pinzu(1), .pinzu(2), .pinzu(3)),
                .koutsu(.jihai(.ton))
            ],
            pair: [.jihai(.haku), .jihai(.haku)],
            winningTile: .jihai(.ton)
        ),

        "shousangen": YakuExample(
            melds: [
                .koutsu(.jihai(.haku)),
                .koutsu(.jihai(.hatsu)),
                .koutsu(.manzu(3)),
                .shuntsu(.souzu(4), .souzu(5), .souzu(6))
            ],
            pair: [.jihai(.chun), .jihai(.chun)],
            winningTile: .souzu(6)
        ),

        "honroutou": YakuExample(
            melds: [
                .koutsu(.manzu(1)),
                .koutsu(.manzu(9)),
                .koutsu(.pinzu(1)),
                .koutsu(.jihai(.ton))
            ],
            pair: [.jihai(.haku), .jihai(.haku)],
            winningTile: .jihai(.ton)
        ),

        // 3翻
        "ryanpeikou": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.pinzu(6), .pinzu(7), .pinzu(8)),
                .shuntsu(.pinzu(6), .pinzu(7), .pinzu(8))
            ],
            pair: [.souzu(5), .souzu(5)],
            winningTile: .pinzu(8)
        ),

        "junchan": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(7), .manzu(8), .manzu(9)),
                .shuntsu(.pinzu(1), .pinzu(2), .pinzu(3)),
                .shuntsu(.souzu(7), .souzu(8), .souzu(9))
            ],
            pair: [.pinzu(9), .pinzu(9)],
            winningTile: .souzu(9)
        ),

        "honitsu": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(5), .manzu(6), .manzu(7)),
                .koutsu(.manzu(8)),
                .koutsu(.jihai(.hatsu))
            ],
            pair: [.jihai(.chun), .jihai(.chun)],
            winningTile: .manzu(8)
        ),

        // 6翻
        "chinitsu": YakuExample(
            melds: [
                .shuntsu(.souzu(1), .souzu(2), .souzu(3)),
                .shuntsu(.souzu(4), .souzu(5), .souzu(6)),
                .shuntsu(.souzu(6), .souzu(7), .souzu(8)),
                .koutsu(.souzu(9))
            ],
            pair: [.souzu(2), .souzu(2)],
            winningTile: .souzu(9)
        )
    ]
}
