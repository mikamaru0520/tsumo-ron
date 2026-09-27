import SwiftUI
import TsumoRonCore

struct ResultSheet: View {
    let score: Score
    let onDismiss: () -> Void
    let onReset: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 点数表示
                    VStack(spacing: 12) {
                        // 満貫以上のラベル
                        if let label = limitLabel {
                            Text(label)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appAccent)
                        }

                        // 点数
                        scoreView
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(Color.appPrimary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.appCardBackground)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal)

                    // 翻数・符
                    HStack(spacing: 20) {
                        Label("\(score.hand.totalHan)翻", systemImage: "star.fill")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.appAccentYellow)

                        Label("\(score.hand.fu)符", systemImage: "square.grid.2x2.fill")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appCardBackground)
                    )
                    .padding(.horizontal)

                    // 役の一覧
                    if !score.hand.yaku.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("成立した役")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appPrimary)
                                .padding(.horizontal)

                            VStack(spacing: 8) {
                                ForEach(score.hand.yaku, id: \.id) { yaku in
                                    HStack {
                                        Text(yaku.name)
                                            .font(.system(size: 18, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.appTextPrimary)

                                        Spacer()

                                        Text("\(yaku.han)翻")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.appAccent)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.appCardBackground)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // ボタン
                    VStack(spacing: 12) {
                        Button {
                            onDismiss()
                        } label: {
                            Text("閉じる")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appPrimary)
                                )
                        }

                        Button {
                            onReset()
                        } label: {
                            Text("リセット")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.appTextSecondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.appTextSecondary, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("点数")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appPrimary)
                }
            }
        }
        .presentationDetents([.medium])
    }

    @ViewBuilder
    private var scoreView: some View {
        switch score.payment {
        case .dealerTsumo(let fromEach):
            VStack(spacing: 4) {
                Text("\(fromEach)点")
                Text("∀")
                    .font(.system(size: 32))
                Text("各\(fromEach)点")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundStyle(Color.appTextSecondary)
            }

        case .nonDealerTsumo(let fromDealer, let fromNonDealer):
            VStack(spacing: 4) {
                Text("\(fromDealer)点・\(fromNonDealer)点")
                Text("親\(fromDealer) / 子\(fromNonDealer)")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundStyle(Color.appTextSecondary)
            }

        case .dealerRon(let total), .nonDealerRon(let total):
            Text("\(total)点")
        }
    }

    private var limitLabel: String? {
        let han = score.hand.totalHan

        if han >= 13 {
            let yakumanCount = han / 13
            return yakumanCount == 1 ? "役満" : "\(yakumanCount)倍役満"
        } else if han >= 11 {
            return "数え役満"
        } else if han >= 8 {
            return "三倍満"
        } else if han >= 6 {
            return "倍満"
        } else if han == 5 {
            return "跳満"
        } else if han >= 4 || (han == 3 && score.hand.fu >= 60) {
            return "満貫"
        }

        return nil
    }
}

#Preview {
    ResultSheet(
        score: Score(
            hand: Hand(
                yaku: [
                    Yaku(id: "tanyao", name: "断么九", han: 1),
                    Yaku(id: "pinfu", name: "平和", han: 1),
                    Yaku(id: "dora", name: "ドラ", han: 2)
                ],
                fu: 30,
                playerType: .nonDealer,
                winType: .ron
            ),
            payment: .nonDealerRon(total: 5200)
        ),
        onDismiss: {},
        onReset: {}
    )
}
