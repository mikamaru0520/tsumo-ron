import SwiftUI
import TsumoRonCore

struct ResultModal: View {
    let score: Score
    let onDismiss: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text("計算結果")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appTextPrimary)

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text("閉じる")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.appTextSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.appTextSecondary, lineWidth: 1.5)
                        )
                }
            }
            .padding(20)

            Divider()

            ScrollView {
                VStack(spacing: 24) {
                    // 点数表示
                    VStack(spacing: 16) {
                        // メイン点数
                        scoreView
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.appPrimary, Color.appAccent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        // 説明文
                        if case .nonDealerTsumo = score.payment {
                            Text("子の支払い / 親の支払い")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.appTextSecondary)
                        }

                        // 合計点数
                        if case .dealerTsumo(let fromEach) = score.payment {
                            Text("合計 \(fromEach * 3)点")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                        } else if case .nonDealerTsumo(let fromDealer, let fromNonDealer) = score.payment {
                            Text("合計 \(fromDealer + fromNonDealer * 2)点")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                        }

                        // 翻数・符のバッジ
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                Text("\(score.hand.totalHan)翻")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.appPrimary)
                            )

                            HStack(spacing: 6) {
                                Image(systemName: "square.grid.3x3.fill")
                                    .font(.system(size: 14))
                                Text("\(score.hand.fu)符")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.appAccent)
                            )
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.appBackground.opacity(0.5))
                    )
                    .padding(.horizontal, 20)

                    // 役の一覧（内訳）
                    if !score.hand.yaku.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("内訳")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)

                            VStack(spacing: 0) {
                                ForEach(Array(score.hand.yaku.enumerated()), id: \.element.id) { index, yaku in
                                    HStack {
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.appPrimary.opacity(0.2))
                                                .frame(width: 8, height: 8)

                                            Text(yaku.name)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundStyle(Color.appTextPrimary)
                                        }

                                        Spacer()

                                        Text("\(yaku.han)翻")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color.appPrimary)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)

                                    if index < score.hand.yaku.count - 1 {
                                        Divider()
                                            .padding(.leading, 20)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.5))
                            )
                        }
                        .padding(.horizontal, 20)
                    }

                    // アクションボタン
                    HStack(spacing: 12) {
                        Button {
                            onReset()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("リセット")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.glass)
                        .tint(Color.appTextSecondary)

                        Button {
                            onDismiss()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("完了")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(Color.appAccent)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
        }
        .frame(maxWidth: 600, maxHeight: 700)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .glassEffect()
        .padding(20)
    }

    @ViewBuilder
    private var scoreView: some View {
        switch score.payment {
        case .dealerTsumo(let fromEach):
            Text("\(fromEach)点∀")

        case .nonDealerTsumo(let fromDealer, let fromNonDealer):
            Text("\(fromNonDealer) / \(fromDealer)")

        case .dealerRon(let total), .nonDealerRon(let total):
            Text("\(total)点")
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground
            .ignoresSafeArea()

        ResultModal(
            score: Score(
                hand: Hand(
                    yaku: [
                        Yaku(id: "riichi", name: "リーチ", han: 1),
                        Yaku(id: "tsumo", name: "門前ツモ", han: 1),
                        Yaku(id: "pinfu", name: "平和", han: 1)
                    ],
                    fu: 20,
                    playerType: .nonDealer,
                    winType: .tsumo
                ),
                payment: .nonDealerTsumo(fromDealer: 1300, fromNonDealer: 700)
            ),
            onDismiss: {},
            onReset: {}
        )
    }
}
