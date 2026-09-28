/// 牌の種類
public enum TileType: Sendable, Hashable {
    case manzu  // 萬子
    case pinzu  // 筒子
    case souzu  // 索子
    case jihai  // 字牌
}

/// 字牌の種類
public enum JihaiType: Sendable, Hashable {
    case ton    // 東
    case nan    // 南
    case sha    // 西
    case pei    // 北
    case haku   // 白
    case hatsu  // 發
    case chun   // 中
}

/// 牌
public enum Tile: Sendable, Hashable {
    case manzu(Int)  // 1-9
    case pinzu(Int)  // 1-9
    case souzu(Int)  // 1-9
    case jihai(JihaiType)

    public var type: TileType {
        switch self {
        case .manzu: return .manzu
        case .pinzu: return .pinzu
        case .souzu: return .souzu
        case .jihai: return .jihai
        }
    }

    public var number: Int? {
        switch self {
        case .manzu(let n), .pinzu(let n), .souzu(let n):
            return n
        case .jihai:
            return nil
        }
    }

    public var jihaiType: JihaiType? {
        if case .jihai(let type) = self {
            return type
        }
        return nil
    }

    /// 么九牌（1・9牌または字牌）かどうか
    public var isTerminalOrHonor: Bool {
        switch self {
        case .manzu(let n), .pinzu(let n), .souzu(let n):
            return n == 1 || n == 9
        case .jihai:
            return true
        }
    }

    /// 中張牌（2-8牌）かどうか
    public var isSimple: Bool {
        !isTerminalOrHonor
    }

    /// 役牌（三元牌）かどうか
    public var isSangenhai: Bool {
        if case .jihai(let type) = self {
            return type == .haku || type == .hatsu || type == .chun
        }
        return false
    }

    /// 牌面に表示する数字（漢数字）
    public var displayNumber: String? {
        guard let n = number else { return nil }
        switch n {
        case 1: return "一"
        case 2: return "二"
        case 3: return "三"
        case 4: return "四"
        case 5: return "五"
        case 6: return "六"
        case 7: return "七"
        case 8: return "八"
        case 9: return "九"
        default: return nil
        }
    }

    /// 牌面に表示する種類（萬・筒・索）
    public var displaySuit: String? {
        switch self {
        case .manzu: return "萬"
        case .pinzu: return "筒"
        case .souzu: return "索"
        case .jihai: return nil
        }
    }

    /// 字牌の文字
    public var displayJihai: String? {
        guard let type = jihaiType else { return nil }
        switch type {
        case .ton: return "東"
        case .nan: return "南"
        case .sha: return "西"
        case .pei: return "北"
        case .haku: return nil  // 白は枠で表現
        case .hatsu: return "發"
        case .chun: return "中"
        }
    }
}
