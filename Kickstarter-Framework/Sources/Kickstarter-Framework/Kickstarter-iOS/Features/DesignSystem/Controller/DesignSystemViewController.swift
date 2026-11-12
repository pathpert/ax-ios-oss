import Foundation
import KDS
import KsApi
import Library
import PassKit
import Prelude
import UIKit

/// Showcase view controller displaying Kickstarter design system alerts, buttons, icons, controls, and typography.
final class DesignSystemViewController: UIViewController {
  lazy var scrollView = { UIScrollView(frame: .zero) }()
  lazy var rootStackView = { UIStackView(frame: .zero) }()

  // MARK: - Alerts

  let alertsLabel = UILabel()
  let alertsStackView: UIStackView = { UIStackView(frame: .zero) }()
  let errorSnackbarStackView: UIStackView = { UIStackView(frame: .zero) }()
  let errorSnackbarIcon = { UIImageView(frame: .zero) }()
  let errorSnackbarLabel = UILabel()
  let confirmationSnackbarStackView: UIStackView = { UIStackView(frame: .zero) }()
  let confirmationSnackbarIcon = { UIImageView(frame: .zero) }()
  let confirmationSnackbarLabel = UILabel()

  // MARK: - Buttons

  let buttonsLabel = UILabel()
  let buttonsStackView: UIStackView = { UIStackView(frame: .zero) }()

  // MARK: - Icons

  let iconsLabel = UILabel()
  let iconsStackView: UIStackView = { UIStackView(frame: .zero) }()
  let logoIcon = { UIImageView(frame: .zero) }()
  let arrowDownIcon = { UIImageView(frame: .zero) }()
  let bookmarkIcon = { UIImageView(frame: .zero) }()
  let heartIcon = { UIImageView(frame: .zero) }()

  // MARK: - Controls

  let controlsLabel = UILabel()
  let controlsStackView: UIStackView = { UIStackView(frame: .zero) }()
  let switchControlEnabled = UISwitch(frame: .zero)
  let switchControlDisabled = UISwitch(frame: .zero)
  let stepper: UIStepper = { UIStepper(frame: .zero) }()
  let dropdownButton: UIButton = { UIButton(frame: .zero) }()

  // MARK: - Inputs

  let inputsLabel = UILabel()
  let inputsStackView: UIStackView = { UIStackView(frame: .zero) }()
  let emailTextField: UITextField = { UITextField(frame: .zero) }()
  let passwordTextField: UITextField = { UITextField(frame: .zero) }()

  // MARK: - Progress Indicators

  let progressLabel = UILabel()
  let progressStackView: UIStackView = { UIStackView(frame: .zero) }()
  let loadingIndicator = UIActivityIndicatorView()
  let pullToRefreshImageView = UIImageView(image: image(named: "icon--refresh-small"))
  let shimmerLoadingView = DemoShimmerLoadingView(frame: .zero)

  // MARK: - Footers

  let footersLabel = UILabel()
  let footersStackView: UIStackView = { UIStackView(frame: .zero) }()
  lazy var demoCTAContainerView: DemoCTAContainerView = {
    DemoCTAContainerView(frame: .zero)
      |> \.translatesAutoresizingMaskIntoConstraints .~ false
  }()

  // MARK: - Typography

  let typesLabel = UILabel()
  let typeStackView: UIStackView = { UIStackView(frame: .zero) }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    _ = self
      |> \.title .~ "System Design"

    self.dropdownButton.setTitle("United States", for: .normal)

    let emailTextFieldpaddingView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: 15,
      height: self.emailTextField.frame.height
    ))
    let passTextFieldpaddingView = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: 15,
      height: self.passwordTextField.frame.height
    ))
    self.emailTextField.leftView = emailTextFieldpaddingView
    self.emailTextField.leftViewMode = .always
    self.passwordTextField.leftView = passTextFieldpaddingView
    self.passwordTextField.leftViewMode = .always

    self.configureViews()
  }

  // MARK: - Configuration

  private func configureViews() {
    _ = (self.scrollView, self.view)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (self.rootStackView, self.scrollView)
      |> ksr_addSubviewToParent()
      |> ksr_constrainViewToEdgesInParent()

    _ = (
      [
        self.alertsLabel,
        self.alertsStackView,
        self.buttonsLabel,
        self.buttonsStackView,
        self.iconsLabel,
        self.iconsStackView,
        self.controlsLabel,
        self.controlsStackView,
        self.inputsLabel,
        self.inputsStackView,
        self.progressLabel,
        self.progressStackView,
        self.footersLabel,
        self.footersStackView,
        self.typesLabel,
        self.typeStackView
      ], self.rootStackView
    )
      |> ksr_addArrangedSubviewsToStackView()

    self.configureSectionStacks()
    self.configureLayoutConstraints()
  }
}
