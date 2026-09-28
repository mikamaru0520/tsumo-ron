import SwiftUI

struct SettingsModal: View {
    @Binding var kuiTan: Bool
    @Binding var kiriage: Bool
    @Binding var kazoe: Bool
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text("設定")
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

            // 設定項目
            VStack(spacing: 0) {
                Toggle(isOn: $kuiTan) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("喰いタンあり")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)

                        Text("鳴いてもタンヤオが成立します")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                .tint(Color.appPrimary)
                .padding(20)

                Divider()
                    .padding(.leading, 20)

                Toggle(isOn: $kiriage) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("切り上げ満貫")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)

                        Text("30符4翻、60符3翻を満貫とします")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                .tint(Color.appPrimary)
                .padding(20)

                Divider()
                    .padding(.leading, 20)

                Toggle(isOn: $kazoe) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("数え役満")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)

                        Text("13翻以上を役満とします")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                .tint(Color.appPrimary)
                .padding(20)
            }

            Spacer()
        }
        .frame(maxWidth: 500, maxHeight: 400)
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
        Color.gray.opacity(0.3)
            .ignoresSafeArea()

        SettingsModal(
            kuiTan: .constant(true),
            kiriage: .constant(false),
            kazoe: .constant(true),
            onDismiss: {}
        )
    }
}
