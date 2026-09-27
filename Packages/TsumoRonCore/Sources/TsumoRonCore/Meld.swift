/// 面子の種類
public enum MeldType: Sendable {
    case shuntsu  // 順子
    case koutsu   // 刻子
}

/// 面子
public struct Meld: Sendable, Hashable {
    public let tiles: [Tile]
    public let type: MeldType

    public init(tiles: [Tile], type: MeldType) {
        self.tiles = tiles
        self.type = type
    }

    /// 順子を作成（同じ種類の連続する3枚）
    public static func shuntsu(_ tile1: Tile, _ tile2: Tile, _ tile3: Tile) -> Meld {
        Meld(tiles: [tile1, tile2, tile3], type: .shuntsu)
    }

    /// 刻子を作成（同じ牌3枚）
    public static func koutsu(_ tile: Tile) -> Meld {
        Meld(tiles: [tile, tile, tile], type: .koutsu)
    }
}
