import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CleaningViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Clean Mac Memory")
                    .font(.system(size: 28, weight: .bold))
                Text("RAM & Cache Cleaner")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 24)
            
            // Usage Gauges
            HStack(spacing: 20) {
                UsageGauge(
                    title: "RAM Usage",
                    percentage: viewModel.ramUsagePercentage,
                    size: Int(viewModel.ramUsageGB),
                    unit: "GB"
                )
                
                UsageGauge(
                    title: "Cache Size",
                    percentage: viewModel.cachePercentage,
                    size: Int(viewModel.cacheSizeMB),
                    unit: "MB"
                )
            }
            .padding(.horizontal, 24)
            
            // Clean Button
            Button(action: {
                viewModel.initiateCleaningProcess()
            }) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Clean Now")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .disabled(viewModel.isCleaningInProgress)
            
            // Activity Log
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent Activity")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 24)
                
                if viewModel.activityLog.isEmpty {
                    Text("No cleaning activity yet")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.activityLog.prefix(5), id: \.self) { log in
                            Text(log)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 24)
        .frame(minWidth: 500, minHeight: 600)
        .onAppear {
            viewModel.updateUsageMetrics()
        }
    }
}

struct UsageGauge: View {
    let title: String
    let percentage: Double
    let size: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: percentage / 100)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: percentage)
                
                VStack(spacing: 4) {
                    Text("\(Int(percentage))%")
                        .font(.system(size: 18, weight: .bold))
                    Text("\(size) \(unit)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }
            .frame(height: 100)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
