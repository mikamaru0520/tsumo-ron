/// 役の詳細情報
public struct YakuDefinition: Sendable {
    public let id: String
    public let name: String
    public let ruby: String?         // ルビ（ふりがな）
    public let menzenHan: Int        // 門前時の翻数
    public let nakiHan: Int?         // 鳴き時の翻数（門前専用役は nil）
    public let description: String   // 役の説明
    public let example: YakuExample? // 牌姿例（状況役は nil）

    public init(
        id: String,
        name: String,
        ruby: String? = nil,
        menzenHan: Int,
        nakiHan: Int? = nil,
        description: String,
        example: YakuExample? = nil
    ) {
        self.id = id
        self.name = name
        self.ruby = ruby
        self.menzenHan = menzenHan
        self.nakiHan = nakiHan
        self.description = description
        self.example = example
    }

    /// 門前専用役かどうか
    public var isMenzenOnly: Bool {
        nakiHan == nil
    }
}

extension YakuDefinition {
    public static let definitions: [String: YakuDefinition] = [
        // 1翻 - 状況役
        "riichi": YakuDefinition(
            id: "riichi",
            name: "立直",
            ruby: "リーチ",
            menzenHan: 1,
            description: "門前でテンパイしたときに、1000点を支払って宣言する役です。リーチ後は手牌を変えられませんが、裏ドラが付くチャンスがあります。"
        ),

        "ippatsu": YakuDefinition(
            id: "ippatsu",
            name: "一発",
            ruby: "イッパツ",
            menzenHan: 1,
            description: "リーチ宣言後、誰にも鳴かれずに1巡以内に和了すると成立します。リーチとセットで付く役です。"
        ),

        "tsumo": YakuDefinition(
            id: "tsumo",
            name: "門前清自摸和",
            ruby: "メンゼンツモ",
            menzenHan: 1,
            description: "鳴かずに門前で手牌を揃え、自分でツモして和了したときに付きます。他家からの放銃ではなく、自分で引いてきた牌で上がることが条件です。"
        ),

        "haitei": YakuDefinition(
            id: "haitei",
            name: "海底摸月",
            ruby: "ハイテイ",
            menzenHan: 1,
            description: "その局の最後の牌をツモって和了すると成立します。山の最後の1枚で上がる偶然役です。"
        ),

        "houtei": YakuDefinition(
            id: "houtei",
            name: "河底撈魚",
            ruby: "ホーテイ",
            menzenHan: 1,
            description: "その局の最後の捨て牌でロン和了すると成立します。誰かが最後に捨てた牌で上がる偶然役です。"
        ),

        "rinshan": YakuDefinition(
            id: "rinshan",
            name: "嶺上開花",
            ruby: "リンシャン",
            menzenHan: 1,
            description: "槓をした直後に引く嶺上牌でツモ和了すると成立します。カンの補充牌で上がる偶然役です。"
        ),

        "chankan": YakuDefinition(
            id: "chankan",
            name: "槍槓",
            ruby: "チャンカン",
            menzenHan: 1,
            description: "他家が加槓した牌でロン和了すると成立します。相手が刻子に1枚追加しようとした瞬間に横取りする形です。"
        ),

        "double_riichi": YakuDefinition(
            id: "double_riichi",
            name: "両立直",
            ruby: "ダブルリーチ",
            menzenHan: 2,
            description: "配牌時点で既にテンパイしており、第一打でリーチをかけると成立します。2翻役で、親なら配牌直後にリーチできます。"
        ),

        // 1翻 - 手役
        "pinfu": YakuDefinition(
            id: "pinfu",
            name: "平和",
            ruby: "ピンフ",
            menzenHan: 1,
            description: "4面子すべてが順子で、雀頭が役牌でなく、両面待ちで和了する役です。基本的な形で最も符が少なくなります。",
            example: YakuExample.examples["pinfu"]
        ),

        "tanyao": YakuDefinition(
            id: "tanyao",
            name: "断么九",
            ruby: "タンヤオ",
            menzenHan: 1,
            nakiHan: 1,
            description: "1・9牌と字牌を一切使わず、2〜8の数牌だけで手を作ります。中張牌のみの手で、鳴いても成立します。",
            example: YakuExample.examples["tanyao"]
        ),

        "iipeikou": YakuDefinition(
            id: "iipeikou",
            name: "一盃口",
            ruby: "イーペーコー",
            menzenHan: 1,
            description: "同じ順子を2組作る役です。門前限定で、例えば234と234の萬子のように、全く同じ順子が2つあることが条件です。",
            example: YakuExample.examples["iipeikou"]
        ),

        // 役牌（1翻）
        "ton": YakuDefinition(
            id: "ton",
            name: "東",
            menzenHan: 1,
            nakiHan: 1,
            description: "東の刻子を作ると成立します。東場の東家、または南場でも場風として東の刻子で1翻です。"
        ),

        "nan": YakuDefinition(
            id: "nan",
            name: "南",
            menzenHan: 1,
            nakiHan: 1,
            description: "南の刻子を作ると成立します。南場の南家、または場風として南の刻子で1翻です。"
        ),

        "sha": YakuDefinition(
            id: "sha",
            name: "西",
            menzenHan: 1,
            nakiHan: 1,
            description: "西の刻子を作ると成立します。西場の西家、または場風として西の刻子で1翻です。"
        ),

        "pei": YakuDefinition(
            id: "pei",
            name: "北",
            menzenHan: 1,
            nakiHan: 1,
            description: "北の刻子を作ると成立します。北場の北家、または場風として北の刻子で1翻です。"
        ),

        "haku": YakuDefinition(
            id: "haku",
            name: "白",
            menzenHan: 1,
            nakiHan: 1,
            description: "白の刻子を作ると成立します。三元牌の1つで、鳴いても門前でも1翻付きます。"
        ),

        "hatsu": YakuDefinition(
            id: "hatsu",
            name: "發",
            menzenHan: 1,
            nakiHan: 1,
            description: "發の刻子を作ると成立します。三元牌の1つで、鳴いても門前でも1翻付きます。"
        ),

        "chun": YakuDefinition(
            id: "chun",
            name: "中",
            menzenHan: 1,
            nakiHan: 1,
            description: "中の刻子を作ると成立します。三元牌の1つで、鳴いても門前でも1翻付きます。"
        ),

        // 2翻
        "chiitoitsu": YakuDefinition(
            id: "chiitoitsu",
            name: "七対子",
            ruby: "チートイツ",
            menzenHan: 2,
            description: "7種類の対子（同じ牌2枚のペア）を集めて和了します。4面子1雀頭ではなく、特殊な形の門前限定役です。",
            example: YakuExample.examples["chiitoitsu"]
        ),

        "toitoi": YakuDefinition(
            id: "toitoi",
            name: "対々和",
            ruby: "トイトイ",
            menzenHan: 2,
            nakiHan: 2,
            description: "4面子すべてを刻子で揃えます。順子を一切使わず、同じ牌3枚の組み合わせだけで手を作ります。",
            example: YakuExample.examples["toitoi"]
        ),

        "sanshoku_doujun": YakuDefinition(
            id: "sanshoku_doujun",
            name: "三色同順",
            ruby: "サンシキ",
            menzenHan: 2,
            nakiHan: 1,
            description: "萬子・筒子・索子で同じ数字の順子を作ります。例えば234の萬・筒・索を揃えると成立します。鳴くと1翻に下がります。",
            example: YakuExample.examples["sanshoku_doujun"]
        ),

        "sanshoku_doukou": YakuDefinition(
            id: "sanshoku_doukou",
            name: "三色同刻",
            ruby: "サンショクドーコー",
            menzenHan: 2,
            nakiHan: 2,
            description: "萬子・筒子・索子で同じ数字の刻子を作ります。例えば666の萬・筒・索を揃えると成立します。",
            example: YakuExample.examples["sanshoku_doukou"]
        ),

        "ittsu": YakuDefinition(
            id: "ittsu",
            name: "一気通貫",
            ruby: "イッキツーカン",
            menzenHan: 2,
            nakiHan: 1,
            description: "同じ種類の牌で123・456・789の3つの順子を作ります。1から9まで一直線に繋がった形です。鳴くと1翻に下がります。",
            example: YakuExample.examples["ittsu"]
        ),

        "chantai": YakuDefinition(
            id: "chantai",
            name: "混全帯么九",
            ruby: "チャンタ",
            menzenHan: 2,
            nakiHan: 1,
            description: "すべての面子と雀頭に1・9牌または字牌を含み、順子が1つ以上あります。鳴くと1翻に下がります。",
            example: YakuExample.examples["chantai"]
        ),

        "sanankou": YakuDefinition(
            id: "sanankou",
            name: "三暗刻",
            ruby: "サンアンコー",
            menzenHan: 2,
            nakiHan: 2,
            description: "暗刻（鳴かずに作った刻子）を3つ揃えます。ポンせずに自力で同じ牌を3枚集めた組が3つあることが条件です。"
        ),

        "sankantsu": YakuDefinition(
            id: "sankantsu",
            name: "三槓子",
            ruby: "サンカンツ",
            menzenHan: 2,
            nakiHan: 2,
            description: "槓を3回行います。明槓でも暗槓でも、とにかく槓を3つ作れば成立する珍しい役です。"
        ),

        "shousangen": YakuDefinition(
            id: "shousangen",
            name: "小三元",
            ruby: "ショウサンゲン",
            menzenHan: 2,
            nakiHan: 2,
            description: "白・發・中の三元牌のうち、2種類の刻子と1種類の雀頭を作ります。役牌2翻と合わせて最低4翻になります。",
            example: YakuExample.examples["shousangen"]
        ),

        "honroutou": YakuDefinition(
            id: "honroutou",
            name: "混老頭",
            ruby: "ホンロートー",
            menzenHan: 2,
            nakiHan: 2,
            description: "1・9牌と字牌だけで手を作ります。刻子のみの形で、すべて端牌で構成されます。",
            example: YakuExample.examples["honroutou"]
        ),

        // 3翻
        "ryanpeikou": YakuDefinition(
            id: "ryanpeikou",
            name: "二盃口",
            ruby: "リャンペーコー",
            menzenHan: 3,
            description: "一盃口が2組ある形です。同じ順子のペアが2つ、計4面子すべてが2種類の順子で構成されます。門前限定です。",
            example: YakuExample.examples["ryanpeikou"]
        ),

        "junchan": YakuDefinition(
            id: "junchan",
            name: "純全帯么九",
            ruby: "ジュンチャン",
            menzenHan: 3,
            nakiHan: 2,
            description: "すべての面子と雀頭に1・9牌を含み、順子が1つ以上あります。チャンタから字牌を除いた形です。鳴くと2翻に下がります。",
            example: YakuExample.examples["junchan"]
        ),

        "honitsu": YakuDefinition(
            id: "honitsu",
            name: "混一色",
            ruby: "ホンイーソー",
            menzenHan: 3,
            nakiHan: 2,
            description: "1種類の数牌と字牌だけで手を作ります。萬子だけ、筒子だけ、索子だけのいずれか+字牌の組み合わせです。鳴くと2翻に下がります。",
            example: YakuExample.examples["honitsu"]
        ),

        // 6翻
        "chinitsu": YakuDefinition(
            id: "chinitsu",
            name: "清一色",
            ruby: "チンイーソー",
            menzenHan: 6,
            nakiHan: 5,
            description: "1種類の数牌だけで手を作ります。萬子だけ、筒子だけ、索子だけのいずれかで、字牌を一切使いません。鳴くと5翻に下がります。",
            example: YakuExample.examples["chinitsu"]
        ),

        // 役満
        "kokushi": YakuDefinition(
            id: "kokushi",
            name: "国士無双",
            ruby: "コクシムソー",
            menzenHan: 13,
            description: "1・9牌と字牌の13種類を1枚ずつ集め、そのうち1種類を雀頭にします。特殊形の門前限定役満です。"
        ),

        "suuankou": YakuDefinition(
            id: "suuankou",
            name: "四暗刻",
            ruby: "スーアンコー",
            menzenHan: 13,
            description: "暗刻を4つ揃えます。一切鳴かずに、すべての面子を自力で刻子にする門前限定役満です。"
        ),

        "daisangen": YakuDefinition(
            id: "daisangen",
            name: "大三元",
            ruby: "ダイサンゲン",
            menzenHan: 13,
            nakiHan: 13,
            description: "白・發・中の三元牌すべての刻子を作ります。三元牌3種をすべて揃える役満です。"
        ),

        "shousuushii": YakuDefinition(
            id: "shousuushii",
            name: "小四喜",
            ruby: "ショウスーシー",
            menzenHan: 13,
            nakiHan: 13,
            description: "東・南・西・北のうち3種類の刻子と1種類の雀頭を作ります。風牌4種のうち3つが刻子の役満です。"
        ),

        "daisuushii": YakuDefinition(
            id: "daisuushii",
            name: "大四喜",
            ruby: "ダイスーシー",
            menzenHan: 26,
            nakiHan: 26,
            description: "東・南・西・北すべての刻子を作ります。風牌4種すべてが刻子のダブル役満です。"
        ),

        "tsuuiisou": YakuDefinition(
            id: "tsuuiisou",
            name: "字一色",
            ruby: "ツーイーソー",
            menzenHan: 13,
            nakiHan: 13,
            description: "字牌だけで手を作ります。東南西北白發中の7種類だけで構成される役満です。"
        ),

        "chinroutou": YakuDefinition(
            id: "chinroutou",
            name: "清老頭",
            ruby: "チンロートー",
            menzenHan: 13,
            nakiHan: 13,
            description: "1・9牌だけで手を作ります。混老頭から字牌を除き、端牌のみの刻子で構成される役満です。"
        ),

        "ryuuiisou": YakuDefinition(
            id: "ryuuiisou",
            name: "緑一色",
            ruby: "リューイーソー",
            menzenHan: 13,
            nakiHan: 13,
            description: "緑色の牌だけで手を作ります。索子の23468と發だけで構成される役満です。"
        ),

        "chuuren": YakuDefinition(
            id: "chuuren",
            name: "九蓮宝燈",
            ruby: "チューレンポートー",
            menzenHan: 13,
            description: "1種類の数牌で1112345678999の形を作り、同種の任意の牌で和了します。門前限定の役満です。"
        ),

        "suukantsu": YakuDefinition(
            id: "suukantsu",
            name: "四槓子",
            ruby: "スーカンツ",
            menzenHan: 13,
            nakiHan: 13,
            description: "槓を4回行います。明槓でも暗槓でも、4つの槓を完成させる非常に珍しい役満です。"
        ),

        "tenhou": YakuDefinition(
            id: "tenhou",
            name: "天和",
            ruby: "テンホー",
            menzenHan: 13,
            description: "親が配牌時点で既に和了している状態です。親の第一ツモ前に成立する門前限定役満です。"
        ),

        "chiihou": YakuDefinition(
            id: "chiihou",
            name: "地和",
            ruby: "チーホー",
            menzenHan: 13,
            description: "子が第一ツモで和了します。親の第一打後、誰にも鳴かれずに第一ツモで上がる門前限定役満です。"
        )
    ]
}
