import Foundation
import KsApi
import ReactiveSwift

/// Input actions accepted by `ViewPledgeUseCase`.
public protocol ViewPledgeUseCaseInputs {
  /// Call when the backer taps View Pledge or Manage Pledge.
  func goToPledgeViewTapped()
}

/// Navigation outputs emitted by `ViewPledgeUseCase`.
public protocol ViewPledgeUseCaseOutputs {
  /// Emits parameters to open the native manage-pledge screen.
  var goToNativePledgeView: Signal<ManagePledgeViewParamConfigData, Never> { get }
  /// Emits the route URL string to open web pledge management when the checkout order is complete.
  var goToPledgeManagementPledgeView: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for `ViewPledgeUseCase`.
public protocol ViewPledgeUseCaseType {
  /// Input receiver.
  var inputs: ViewPledgeUseCaseInputs { get }
  /// Navigation outputs.
  var outputs: ViewPledgeUseCaseOutputs { get }
}

/// Determines the correct destination when viewing a pledge—either routing to the pledge
/// management web view or the native pledge view—based on the backing, order state, and
/// whether the pledge follows the net new backer flow.
/// Triggered when the user taps to manage their pledge or go to backing details.
public final class ViewPledgeUseCase: ViewPledgeUseCaseType,
  ViewPledgeUseCaseInputs,
  ViewPledgeUseCaseOutputs {
  /// Initializes navigation routing streams from the project and backing signal.
  public init(with projectAndBacking: Signal<(Project, Backing), Never>) {
    let goToPledgeViewSignal = self.goToPledgeViewTappedProperty.signal

    let shouldGoToPledgeManagementPledgeView = projectAndBacking
      .takeWhen(goToPledgeViewSignal)
      .map { project, backing -> Bool in
        guard let order = backing.order, let isBacking = project.personalization.isBacking,
              isBacking else { return false }

        return order.checkoutState == .complete
      }

    self.goToPledgeManagementPledgeView = projectAndBacking
      .takeWhen(shouldGoToPledgeManagementPledgeView.filter { $0 })
      .compactMap { _, backing in
        backing.backingDetailsPageRoute
      }

    self.goToNativePledgeView = projectAndBacking
      .takeWhen(shouldGoToPledgeManagementPledgeView.filter { !$0 })
      .map { project, backing in
        ManagePledgeViewParamConfigData(
          projectParam: Param.slug(project.slug),
          backingParam: Param.id(backing.id)
        )
      }
  }

  /// Emits native pledge management screen route parameters.
  public let goToNativePledgeView: Signal<ManagePledgeViewParamConfigData, Never>
  /// Emits web pledge management route URLs.
  public let goToPledgeManagementPledgeView: Signal<String, Never>

  /// Concrete input interface.
  public var inputs: ViewPledgeUseCaseInputs { return self }
  /// Concrete output interface.
  public var outputs: ViewPledgeUseCaseOutputs { return self }

  private let goToPledgeViewTappedProperty = MutableProperty(())
  /// Signals that the user tapped the manage-pledge action.
  public func goToPledgeViewTapped() {
    self.goToPledgeViewTappedProperty.value = ()
  }
}
