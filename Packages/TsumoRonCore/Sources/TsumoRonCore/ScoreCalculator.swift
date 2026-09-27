/// 点数計算ロジック
public struct ScoreCalculator: Sendable {
    public init() {}

    /// 点数を計算する
    public func calculate(hand: Hand) -> Score {
        let han = hand.totalHan
        let fu = hand.fu

        let payment: Payment

        // 役満以上（13翻以上）
        if han >= 13 {
            let yakumanCount = han / 13
            payment = calculateYakuman(
                yakumanCount: yakumanCount,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 数え役満（11翻、12翻）
        else if han >= 11 {
            payment = calculateYakuman(
                yakumanCount: 1,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 三倍満（10翻）
        else if han >= 8 {
            payment = calculateLimit(
                basePoints: hand.playerType == .dealer ? 12000 : 8000,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 倍満（6-7翻）
        else if han >= 6 {
            payment = calculateLimit(
                basePoints: hand.playerType == .dealer ? 6000 : 4000,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 跳満（5翻）
        else if han == 5 {
            payment = calculateLimit(
                basePoints: hand.playerType == .dealer ? 3000 : 2000,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 満貫（4翻、3翻60符以上、4翻30符）
        else if han == 4 || (han == 3 && fu >= 60) {
            payment = calculateLimit(
                basePoints: 2000,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }
        // 通常計算
        else {
            let basePoints = fu * (1 << (2 + han))
            payment = calculateNormal(
                basePoints: basePoints,
                playerType: hand.playerType,
                winType: hand.winType
            )
        }

        return Score(hand: hand, payment: payment)
    }

    // MARK: - Private

    /// 役満の点数計算
    private func calculateYakuman(
        yakumanCount: Int,
        playerType: PlayerType,
        winType: WinType
    ) -> Payment {
        let basePoints = 8000 * yakumanCount
        return calculateLimit(
            basePoints: basePoints,
            playerType: playerType,
            winType: winType
        )
    }

    /// 満貫以上の点数計算
    private func calculateLimit(
        basePoints: Int,
        playerType: PlayerType,
        winType: WinType
    ) -> Payment {
        switch (playerType, winType) {
        case (.dealer, .tsumo):
            return .dealerTsumo(fromEach: roundUp(basePoints * 2))
        case (.dealer, .ron):
            return .dealerRon(total: roundUp(basePoints * 6))
        case (.nonDealer, .tsumo):
            return .nonDealerTsumo(
                fromDealer: roundUp(basePoints * 2),
                fromNonDealer: roundUp(basePoints)
            )
        case (.nonDealer, .ron):
            return .nonDealerRon(total: roundUp(basePoints * 4))
        }
    }

    /// 通常計算（満貫未満）
    private func calculateNormal(
        basePoints: Int,
        playerType: PlayerType,
        winType: WinType
    ) -> Payment {
        switch (playerType, winType) {
        case (.dealer, .tsumo):
            return .dealerTsumo(fromEach: roundUp(basePoints * 2))
        case (.dealer, .ron):
            return .dealerRon(total: roundUp(basePoints * 6))
        case (.nonDealer, .tsumo):
            return .nonDealerTsumo(
                fromDealer: roundUp(basePoints * 2),
                fromNonDealer: roundUp(basePoints)
            )
        case (.nonDealer, .ron):
            return .nonDealerRon(total: roundUp(basePoints * 4))
        }
    }

    /// 100点単位に切り上げ
    private func roundUp(_ points: Int) -> Int {
        ((points + 99) / 100) * 100
    }
}
