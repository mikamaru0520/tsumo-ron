import SwiftUI

struct YakuhaiHelpModal: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text("役牌")
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
                VStack(alignment: .leading, spacing: 20) {
                    // 翻数バッジ
                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                            Text("1翻/種")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.appPrimary)
                        )

                        HStack(spacing: 6) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 14))
                            Text("鳴き 可")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.appAccent)
                        )
                    }
                    .padding(.horizontal)

                    // 説明文
                    VStack(alignment: .leading, spacing: 12) {
                        Text("役牌とは、三元牌（白・發・中）や場風牌・自風牌を刻子（同じ牌3枚）で揃えた時に成立する役です。")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .lineSpacing(6)

                        Text("各役牌ごとに1翻が加算されます。複数の役牌を揃えれば、その分だけ翻数が増えます。")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .lineSpacing(6)
                    }
                    .padding(.horizontal)

                    // 役牌の種類
                    VStack(alignment: .leading, spacing: 16) {
                        Text("役牌の種類")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)

                        VStack(spacing: 0) {
                            yakuhaiRow(title: "三元牌", items: ["白（ハク）", "發（ハツ）", "中（チュン）"])

                            Divider()
                                .padding(.leading, 20)

                            yakuhaiRow(title: "場風牌", items: ["現在の場の風（東場なら東、南場なら南）"])

                            Divider()
                                .padding(.leading, 20)

                            yakuhaiRow(title: "自風牌", items: ["自分の座っている風（東家なら東、南家なら南など）"])
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.5))
                        )
                    }
                    .padding(.horizontal)

                    // 補足説明
                    VStack(alignment: .leading, spacing: 8) {
                        Text("💡 ポイント")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundStyle(Color.appPrimary)
                                Text("役牌は鳴いても成立します")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(Color.appTextSecondary)
                            }

                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundStyle(Color.appPrimary)
                                Text("自風牌と場風牌が同じ場合（東場の東家など）は2翻になります")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(Color.appTextSecondary)
                            }

                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundStyle(Color.appPrimary)
                                Text("役牌を複数揃えることで、小三元や大三元といった上位役も狙えます")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(Color.appTextSecondary)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appAccentYellow.opacity(0.15))
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
            }
        }
        .frame(maxWidth: 600)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .glassEffect()
        .padding(20)
    }

    @ViewBuilder
    private func yakuhaiRow(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            ForEach(items, id: \.self) { item in
                Text("・\(item)")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
    }
}

#Preview {
    ZStack {
        Color.appBackground
            .ignoresSafeArea()

        YakuhaiHelpModal {}
    }
}
