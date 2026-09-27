/// 和了の情報
public struct Hand: Sendable {
    public let yaku: [Yaku]  // 役のリスト
    public let fu: Int       // 符
    public let playerType: PlayerType
    public let winType: WinType

    public init(yaku: [Yaku], fu: Int, playerType: PlayerType, winType: WinType) {
        self.yaku = yaku
        self.fu = fu
        self.playerType = playerType
        self.winType = winType
    }

    /// 合計翻数
    public var totalHan: Int {
        yaku.reduce(0) { $0 + $1.han }
    }
}
