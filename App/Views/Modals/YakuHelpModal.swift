import SwiftUI
import TsumoRonCore

struct YakuHelpModal: View {
    let yakuId: String
    let onDismiss: () -> Void

    private var definition: YakuDefinition? {
        YakuDefinition.definitions[yakuId]
    }

    var body: some View {
        VStack(spacing: 0) {
            if let def = definition {
                // ヘッダー（役名）
                HStack {
                    Text(def.name)
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
                .padding()

                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 翻数バッジ
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                Text("門前 \(def.menzenHan)翻")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.appPrimary)
                            )

                            if let nakiHan = def.nakiHan {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 14))
                                    Text("鳴き \(nakiHan)翻")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.appAccent)
                                )
                            } else {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 14))
                                    Text("鳴き 不可")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.appTextSecondary)
                                )
                            }
                        }
                        .padding(.horizontal)

                        // 説明文
                        Text(def.description)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .lineSpacing(6)
                            .padding(.horizontal)

                        // 牌姿例
                        if let example = def.example {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("牌姿の例")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.appTextPrimary)

                                HandView(example: example)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.5))
                                    )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            } else {
                Text("役の情報が見つかりません")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color.appTextSecondary)
                    .padding()
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
}

#Preview {
    ZStack {
        Color.appBackground
            .ignoresSafeArea()

        YakuHelpModal(yakuId: "pinfu") {}
    }
}

#Preview("清一色") {
    ZStack {
        Color.appBackground
            .ignoresSafeArea()

        YakuHelpModal(yakuId: "chinitsu") {}
    }
}
