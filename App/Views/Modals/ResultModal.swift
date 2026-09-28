import SwiftUI
import TsumoRonCore

struct ResultModal: View {
    let score: Score
    let onDismiss: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー（計算結果）
            HStack {
                Text("計算結果")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
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
            .padding()

            Divider()

            ScrollView {
                VStack(spacing: 24) {
                    // 点数表示
                    VStack(spacing: 12) {
                        // 点数
                        scoreView
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .foregroundStyle(Color.appPrimary)

                        // 子の支払い / 親の支払い
                        if case .nonDealerTsumo = score.payment {
                            Text("子の支払い / 親の支払い")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.appTextSecondary)
                        }

                        // 合計点数
                        if case .dealerTsumo(let fromEach) = score.payment {
                            Text("合計 \(fromEach * 3)点")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                        } else if case .nonDealerTsumo(let fromDealer, let fromNonDealer) = score.payment {
                            Text("合計 \(fromDealer + fromNonDealer * 2)点")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                        }

                        // 翻数・符のバッジ
                        HStack(spacing: 12) {
                            Text("\(score.hand.totalHan)翻")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.appAccentYellow)
                                )

                            Text("\(score.hand.fu)符")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.appTextSecondary)
                                )
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                    // 役の一覧（内訳）
                    if !score.hand.yaku.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("内訳")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.appTextPrimary)
                                .padding(.horizontal)

                            VStack(spacing: 0) {
                                ForEach(Array(score.hand.yaku.enumerated()), id: \.element.id) { index, yaku in
                                    HStack {
                                        Text(yaku.name)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundStyle(Color.appTextPrimary)

                                        Spacer()

                                        Text("\(yaku.han)翻")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color.appTextPrimary)
                                    }
                                    .padding()
                                    .background(Color.white)

                                    if index < score.hand.yaku.count - 1 {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                        }
                    }

                    // リセットボタン
                    HStack(spacing: 12) {
                        Button {
                            onReset()
                        } label: {
                            Text("リセット")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appTextSecondary)
                                )
                        }

                        Button {
                            onDismiss()
                        } label: {
                            Text("閉じる")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appPrimary)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.vertical)
            }
        }
        .frame(maxWidth: 600)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.appBackground)
        )
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
        Color.gray.opacity(0.3)
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
