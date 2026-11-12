import KDS
import KsApi
import Library
import SwiftUI

/// Filter selection list for choosing a project percent-raised bucket.
public struct PercentRaisedView: View {
  var buckets: [DiscoveryParams.PercentRaisedBucket]
  @Binding var selectedBucket: DiscoveryParams.PercentRaisedBucket?

  /// SwiftUI body rendering the selectable percent-raised radio list.
  public var body: some View {
    VStack(alignment: .leading, spacing: Constants.spacing) {
      ForEach(self.buckets) { bucket in
        Button {
          self.selectedBucket = bucket
        } label: {
          HStack(spacing: Constants.buttonLabelSpacing) {
            RadioButton(isSelected: bucket == self.selectedBucket)
            Text(bucket.title)
              .font(InterFont.bodyLG.swiftUIFont())
              .foregroundStyle(Colors.Text.primary.swiftUIColor())
          }
        }
      }
    }
    .padding(Constants.padding)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  internal enum Constants {
    static let padding = Spacing.unit_06
    static let spacing = Spacing.unit_06
    static let buttonLabelSpacing = Spacing.unit_02
  }
}

extension DiscoveryParams.PercentRaisedBucket: @retroactive Identifiable {
  /// Stable identifier backed by the bucket raw integer value.
  public var id: Int {
    return self.rawValue
  }
}
