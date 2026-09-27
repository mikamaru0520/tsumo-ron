/// 役の定義
public struct Yaku: Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let han: Int  // 翻数

    public init(id: String, name: String, han: Int) {
        self.id = id
        self.name = name
        self.han = han
    }
}

extension Yaku {
    /// 一般的な役の定義
    public static let commonYaku: [Yaku] = [
        // 1翻
        Yaku(id: "riichi", name: "立直", han: 1),
        Yaku(id: "ippatsu", name: "一発", han: 1),
        Yaku(id: "tsumo", name: "門前清自摸和", han: 1),
        Yaku(id: "pinfu", name: "平和", han: 1),
        Yaku(id: "tanyao", name: "断么九", han: 1),
        Yaku(id: "iipeikou", name: "一盃口", han: 1),
        Yaku(id: "haitei", name: "海底摸月", han: 1),
        Yaku(id: "houtei", name: "河底撈魚", han: 1),
        Yaku(id: "rinshan", name: "嶺上開花", han: 1),
        Yaku(id: "chankan", name: "槍槓", han: 1),
        Yaku(id: "ton", name: "東", han: 1),
        Yaku(id: "nan", name: "南", han: 1),
        Yaku(id: "sha", name: "西", han: 1),
        Yaku(id: "pei", name: "北", han: 1),
        Yaku(id: "haku", name: "白", han: 1),
        Yaku(id: "hatsu", name: "發", han: 1),
        Yaku(id: "chun", name: "中", han: 1),

        // 2翻
        Yaku(id: "double_riichi", name: "両立直", han: 2),
        Yaku(id: "sanshoku_doujun", name: "三色同順", han: 2),
        Yaku(id: "ittsu", name: "一気通貫", han: 2),
        Yaku(id: "chantai", name: "混全帯么九", han: 2),
        Yaku(id: "chiitoitsu", name: "七対子", han: 2),
        Yaku(id: "toitoi", name: "対々和", han: 2),
        Yaku(id: "sanankou", name: "三暗刻", han: 2),
        Yaku(id: "sankantsu", name: "三槓子", han: 2),
        Yaku(id: "sanshoku_doukou", name: "三色同刻", han: 2),
        Yaku(id: "shousangen", name: "小三元", han: 2),
        Yaku(id: "honroutou", name: "混老頭", han: 2),

        // 3翻
        Yaku(id: "ryanpeikou", name: "二盃口", han: 3),
        Yaku(id: "junchan", name: "純全帯么九", han: 3),
        Yaku(id: "honitsu", name: "混一色", han: 3),

        // 6翻
        Yaku(id: "chinitsu", name: "清一色", han: 6),

        // 役満
        Yaku(id: "kokushi", name: "国士無双", han: 13),
        Yaku(id: "suuankou", name: "四暗刻", han: 13),
        Yaku(id: "daisangen", name: "大三元", han: 13),
        Yaku(id: "shousuushii", name: "小四喜", han: 13),
        Yaku(id: "daisuushii", name: "大四喜", han: 26),
        Yaku(id: "tsuuiisou", name: "字一色", han: 13),
        Yaku(id: "chinroutou", name: "清老頭", han: 13),
        Yaku(id: "ryuuiisou", name: "緑一色", han: 13),
        Yaku(id: "chuuren", name: "九蓮宝燈", han: 13),
        Yaku(id: "suukantsu", name: "四槓子", han: 13),
        Yaku(id: "tenhou", name: "天和", han: 13),
        Yaku(id: "chiihou", name: "地和", han: 13)
    ]
}
