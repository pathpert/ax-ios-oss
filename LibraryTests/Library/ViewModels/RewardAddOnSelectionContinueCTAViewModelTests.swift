import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
@testable import Library
@testable import LibraryTestHelpers
import Prelude
import ReactiveExtensions
import ReactiveExtensions_TestHelpers
import ReactiveSwift
import XCTest

final class RewardAddOnSelectionContinueCTAViewModelTests: TestCase {
  private let vm: RewardAddOnSelectionContinueCTAViewModelType = RewardAddOnSelectionContinueCTAViewModel()

  private let buttonEnabled = TestObserver<Bool, Never>()
  private let buttonTitle = TestObserver<String, Never>()
  private let isLoading = TestObserver<Bool, Never>()

  override func setUp() {
    super.setUp()

    self.vm.outputs.buttonEnabled.observe(self.buttonEnabled.observer)
    self.vm.outputs.buttonTitle.observe(self.buttonTitle.observer)
    self.vm.outputs.isLoading.observe(self.isLoading.observer)
  }

  func testButtonEnabled_Valid() {
    self.buttonEnabled.assertDidNotEmitValue()

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: true,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonEnabled.assertValues([true])
  }

  func testButtonEnabled_Invalid() {
    self.buttonEnabled.assertDidNotEmitValue()

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: false,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonEnabled.assertValues([false])
  }

  func testButtonIsLoading_IsLoading() {
    self.isLoading.assertDidNotEmitValue()

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: true,
      isLoading: true,
      pledgeAmount: nil
    ))

    self.isLoading.assertValues([true])
  }

  func testButtonIsLoading_IsNotLoading() {
    self.isLoading.assertDidNotEmitValue()

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: false,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.isLoading.assertValues([false])
  }

  func testButtonTitle() {
    self.buttonTitle.assertDidNotEmitValue()

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: true,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonTitle.assertValues(["Continue"])

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 2,
      isValid: true,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonTitle.assertValues(["Continue", "Continue with 2 add-ons"])

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 0,
      isValid: true,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonTitle.assertValues(["Continue", "Continue with 2 add-ons", "Continue"])

    self.vm.inputs.configure(with: RewardAddOnSelectionContinueCTAViewData(
      selectedQuantity: 1,
      isValid: true,
      isLoading: false,
      pledgeAmount: nil
    ))

    self.buttonTitle.assertValues([
      "Continue",
      "Continue with 2 add-ons",
      "Continue",
      "Continue with 1 add-on"
    ])
  }
}
