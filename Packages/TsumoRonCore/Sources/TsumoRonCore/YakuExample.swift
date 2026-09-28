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
    /// 指定された牌姿: 平和 123m 456m 345p 78[9]s 22s 等
    public static let examples: [String: YakuExample] = [
        // 1翻
        "pinfu": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(4), .manzu(5), .manzu(6)),
                .shuntsu(.pinzu(3), .pinzu(4), .pinzu(5)),
                .shuntsu(.souzu(7), .souzu(8), .souzu(9))
            ],
            pair: [.souzu(2), .souzu(2)],
            winningTile: .souzu(9)
        ),

        "tanyao": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .koutsu(.pinzu(6)),
                .shuntsu(.souzu(4), .souzu(5), .souzu(6)),
                .shuntsu(.souzu(6), .souzu(7), .souzu(8))
            ],
            pair: [.manzu(8), .manzu(8)],
            winningTile: .souzu(8)
        ),

        "iipeikou": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.pinzu(5), .pinzu(6), .pinzu(7)),
                .shuntsu(.souzu(7), .souzu(8), .souzu(9))
            ],
            pair: [.pinzu(9), .pinzu(9)],
            winningTile: .pinzu(7)
        ),

        "yakuhai": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.pinzu(5), .pinzu(6), .pinzu(7)),
                .shuntsu(.souzu(3), .souzu(4), .souzu(5)),
                .koutsu(.jihai(.chun))
            ],
            pair: [.souzu(8), .souzu(8)],
            winningTile: .jihai(.chun)
        ),

        // 2翻
        "sanshoku_doujun": YakuExample(
            melds: [
                .shuntsu(.manzu(3), .manzu(4), .manzu(5)),
                .shuntsu(.pinzu(3), .pinzu(4), .pinzu(5)),
                .shuntsu(.souzu(3), .souzu(4), .souzu(5)),
                .shuntsu(.manzu(7), .manzu(8), .manzu(9))
            ],
            pair: [.pinzu(2), .pinzu(2)],
            winningTile: .souzu(5)
        ),

        "ittsu": YakuExample(
            melds: [
                .shuntsu(.pinzu(1), .pinzu(2), .pinzu(3)),
                .shuntsu(.pinzu(4), .pinzu(5), .pinzu(6)),
                .shuntsu(.pinzu(7), .pinzu(8), .pinzu(9)),
                .shuntsu(.souzu(2), .souzu(3), .souzu(4))
            ],
            pair: [.manzu(5), .manzu(5)],
            winningTile: .pinzu(9)
        ),

        "chantai": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.pinzu(7), .pinzu(8), .pinzu(9)),
                .koutsu(.jihai(.ton)),
                .shuntsu(.souzu(7), .souzu(8), .souzu(9))
            ],
            pair: [.manzu(9), .manzu(9)],
            winningTile: .souzu(7)
        ),

        "toitoi": YakuExample(
            melds: [
                .koutsu(.manzu(4)),
                .koutsu(.pinzu(5)),
                .koutsu(.souzu(9)),
                .koutsu(.souzu(2))
            ],
            pair: [.pinzu(7), .pinzu(7)],
            winningTile: .pinzu(7)
        ),

        "sanankou": YakuExample(
            melds: [
                .koutsu(.manzu(2)),
                .shuntsu(.manzu(3), .manzu(4), .manzu(5)),
                .koutsu(.pinzu(7)),
                .koutsu(.souzu(4))
            ],
            pair: [.souzu(8), .souzu(8)],
            winningTile: .manzu(5)
        ),

        "chiitoitsu": YakuExample.chiitoitsu(
            pairs: [
                [.manzu(1), .manzu(1)],
                [.manzu(5), .manzu(5)],
                [.pinzu(3), .pinzu(3)],
                [.pinzu(9), .pinzu(9)],
                [.souzu(2), .souzu(2)],
                [.souzu(8), .souzu(8)],
                [.jihai(.ton), .jihai(.ton)]
            ],
            winningTile: .jihai(.ton)
        ),

        "sanshoku_doukou": YakuExample(
            melds: [
                .koutsu(.manzu(3)),
                .shuntsu(.manzu(5), .manzu(6), .manzu(7)),
                .koutsu(.pinzu(3)),
                .koutsu(.souzu(3))
            ],
            pair: [.pinzu(7), .pinzu(7)],
            winningTile: .manzu(7)
        ),

        "shousangen": YakuExample(
            melds: [
                .koutsu(.jihai(.haku)),
                .koutsu(.jihai(.hatsu)),
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.pinzu(6), .pinzu(7), .pinzu(8))
            ],
            pair: [.jihai(.chun), .jihai(.chun)],
            winningTile: .jihai(.chun)
        ),

        "honroutou": YakuExample(
            melds: [
                .koutsu(.manzu(1)),
                .koutsu(.pinzu(9)),
                .koutsu(.souzu(9)),
                .koutsu(.jihai(.ton))
            ],
            pair: [.jihai(.pei), .jihai(.pei)],
            winningTile: .jihai(.pei)
        ),

        // 3翻
        "honitsu": YakuExample(
            melds: [
                .shuntsu(.manzu(2), .manzu(3), .manzu(4)),
                .shuntsu(.manzu(5), .manzu(6), .manzu(7)),
                .koutsu(.manzu(9)),
                .koutsu(.jihai(.ton))
            ],
            pair: [.jihai(.haku), .jihai(.haku)],
            winningTile: .manzu(7)
        ),

        "junchan": YakuExample(
            melds: [
                .shuntsu(.manzu(1), .manzu(2), .manzu(3)),
                .shuntsu(.manzu(7), .manzu(8), .manzu(9)),
                .shuntsu(.pinzu(1), .pinzu(2), .pinzu(3)),
                .koutsu(.souzu(9))
            ],
            pair: [.souzu(1), .souzu(1)],
            winningTile: .pinzu(3)
        ),

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

        // 6翻
        "chinitsu": YakuExample(
            melds: [
                .shuntsu(.pinzu(1), .pinzu(2), .pinzu(3)),
                .shuntsu(.pinzu(3), .pinzu(4), .pinzu(5)),
                .shuntsu(.pinzu(6), .pinzu(7), .pinzu(8)),
                .koutsu(.pinzu(9))
            ],
            pair: [.pinzu(5), .pinzu(5)],
            winningTile: .pinzu(5)
        )
    ]
}
