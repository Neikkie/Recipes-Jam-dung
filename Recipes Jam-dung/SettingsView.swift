import SwiftUI

struct SettingsView: View {
    private let supportEmail = "support.chaniiapps@gmail.com"

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                appHeader
                supportSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - App Header

    private var appHeader: some View {
        Section {
            VStack(spacing: 12) {
                if let icon = UIImage(named: "AppIcon") {
                    Image(uiImage: icon)
                        .resizable()
                        .frame(width: 74, height: 74)
                        .cornerRadius(17)
                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
                }
                VStack(spacing: 3) {
                    Text("Jam-dung 🇯🇲")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Authentic Jamaican Recipes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }

    // MARK: - Support Section

    private var supportSection: some View {
        Section {
            Button {
                emailSupport()
            } label: {
                HStack(spacing: 14) {
                    settingsIcon(systemImage: "envelope.fill", color: .blue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Contact Support")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
                        Text(supportEmail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Button {
                emailFeedback()
            } label: {
                HStack(spacing: 14) {
                    settingsIcon(systemImage: "star.fill", color: .orange)
                    Text("Send Feedback")
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } header: {
            Text("Support & Feedback")
        } footer: {
            Text("We'd love to hear from you. Tap above to reach us at \(supportEmail)")
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section("About") {
            HStack(spacing: 14) {
                settingsIcon(systemImage: "info.circle.fill", color: .green)
                Text("Version")
                    .fontWeight(.medium)
                Spacer()
                Text(appVersion)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 14) {
                settingsIcon(systemImage: "globe", color: .indigo)
                Text("Data provided by")
                    .fontWeight(.medium)
                Spacer()
                Text("TheMealDB")
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 14) {
                settingsIcon(systemImage: "flag.fill", color: Color(red: 0, green: 0.61, blue: 0.23))
                Text("Cuisine")
                    .fontWeight(.medium)
                Spacer()
                Text("🇯🇲 Jamaican")
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private func settingsIcon(systemImage: String, color: Color) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .background(color)
            .cornerRadius(7)
    }

    private func emailSupport() {
        let subject = "Support Request – Jam-dung App"
        let body = "Hi,\n\nI need help with...\n\n---\nApp Version: \(appVersion)"
        openMail(subject: subject, body: body)
    }

    private func emailFeedback() {
        let subject = "Feedback – Jam-dung App"
        let body = "Hi,\n\nI'd like to share some feedback...\n\n---\nApp Version: \(appVersion)"
        openMail(subject: subject, body: body)
    }

    private func openMail(subject: String, body: String) {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingsView()
}
