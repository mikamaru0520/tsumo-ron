/// 点数の結果
public struct Score: Sendable {
    public let hand: Hand
    public let payment: Payment

    public init(hand: Hand, payment: Payment) {
        self.hand = hand
        self.payment = payment
    }
}

/// 支払い情報
public enum Payment: Sendable {
    /// 親がツモった場合（各子が支払う点数）
    case dealerTsumo(fromEach: Int)
    /// 子がツモった場合（親が支払う点数、他の子が支払う点数）
    case nonDealerTsumo(fromDealer: Int, fromNonDealer: Int)
    /// 親がロンした場合（放銃者が支払う点数）
    case dealerRon(total: Int)
    /// 子がロンした場合（放銃者が支払う点数）
    case nonDealerRon(total: Int)

    /// 和了者が得る総点数
    public var totalPoints: Int {
        switch self {
        case .dealerTsumo(let fromEach):
            return fromEach * 3
        case .nonDealerTsumo(let fromDealer, let fromNonDealer):
            return fromDealer + fromNonDealer * 2
        case .dealerRon(let total):
            return total
        case .nonDealerRon(let total):
            return total
        }
    }
}
