import KDS
import Library
import SwiftUI

struct EstimatedShippingCheckoutView: View {
  let estimatedCost: String
  let aboutConversion: String

  private enum Constants {
    /// Default vertical spacing between shipping label and explanatory subtext.
    public static let defaultSpacing = Styles.grid(1)
    /// Outer vertical container padding.
    public static let verticalPadding = Styles.grid(2)
    /// Outer horizontal container padding.
    public static let horizontalPadding = Styles.grid(4)
    /// Shipping heading font point size.
    public static let headerFontSize = 16.0
    /// Explanatory caption font point size.
    public static let subHeaderFontSize = 11.0
    /// Currency conversion subtitle font point size.
    public static let conversionSubHeaderFontSize = 12.0
    /// Font used for the "Estimated Shipping" heading.
    public static let headerFont = Font(UIFont.ksr_subhead(size: Constants.headerFontSize))
    /// Font used for the explanatory subtext.
    public static let subHeaderFont = Font(UIFont.ksr_subhead(size: Constants.subHeaderFontSize))
    /// Font used for the primary formatted shipping cost.
    public static let conversionHeaderFont = Font(UIFont.ksr_subhead())
    /// Font used for the approximate USD/home-currency conversion text.
    public static let conversionSubHeaderFont = Font(
      UIFont
        .ksr_subhead(size: Constants.conversionSubHeaderFontSize)
    )
  }

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: Constants.defaultSpacing) {
        Text(Strings.Estimated_Shipping())
          .font(Constants.headerFont)
          .bold()
        Text(Strings.This_is_meant_to_give_you())
          .font(Constants.subHeaderFont)
          .foregroundStyle(Color(LegacyColors.ksr_support_400.uiColor()))
      }

      VStack(alignment: .trailing, spacing: Constants.defaultSpacing) {
        Text(self.estimatedCost)
          .font(Constants.conversionHeaderFont)
          .bold()
        Text(self.aboutConversion)
          .font(Constants.conversionSubHeaderFont)
          .foregroundStyle(Color(LegacyColors.ksr_support_400.uiColor()))
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, Constants.verticalPadding)
    .padding(.horizontal, Constants.horizontalPadding)
  }
}
