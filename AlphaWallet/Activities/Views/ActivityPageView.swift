//
//  ActivitiesPageView.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 12.05.2021.
//

import UIKit
import StatefulViewController

struct ActivityPageViewModel {
    var title: String {
        return R.string.localizable.tokenTabActivity()
    }

    let activitiesViewModel: ActivitiesViewModel

    init(activitiesViewModel: ActivitiesViewModel) {
        self.activitiesViewModel = activitiesViewModel
    }
}

protocol ActivitiesPageViewDelegate: class {
    func didTap(activity: Activity, in view: ActivitiesPageView)
    func didTap(transaction: TransactionInstance, in view: ActivitiesPageView)
}

class ActivitiesPageView: UIView, PageViewType {

    var title: String { viewModel.title }

    private var activitiesView: ActivitiesView
    var viewModel: ActivityPageViewModel
    weak var delegate: ActivitiesPageViewDelegate?
    var rightBarButtonItem: UIBarButtonItem?
    
    init(analyticsCoordinator: AnalyticsCoordinator, keystore: Keystore, wallet: Wallet, viewModel: ActivityPageViewModel, sessions: ServerDictionary<WalletSession>, assetDefinitionStore: AssetDefinitionStore) {
        self.viewModel = viewModel
        activitiesView = ActivitiesView(analyticsCoordinator: analyticsCoordinator, keystore: keystore, wallet: wallet, viewModel: viewModel.activitiesViewModel, sessions: sessions, assetDefinitionStore: assetDefinitionStore)
        super.init(frame: .zero)

        activitiesView.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(activitiesView)

        NSLayoutConstraint.activate([activitiesView.anchorsConstraintSafeArea(to: self)])

        configure(viewModel: viewModel)
    }

    deinit {
        activitiesView.resetStatefulStateToReleaseObjectToAvoidMemoryLeak()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func configure(viewModel: ActivityPageViewModel) {
        self.viewModel = viewModel
        activitiesView.configure(viewModel: viewModel.activitiesViewModel)
        activitiesView.applySearch(keyword: nil)

        activitiesView.endLoading()
    } 
}

extension ActivitiesPageView: ActivitiesViewDelegate {

    func didPressActivity(activity: Activity, in view: ActivitiesView) {
        delegate?.didTap(activity: activity, in: self)
    }

    func didPressTransaction(transaction: TransactionInstance, in view: ActivitiesView) {
        delegate?.didTap(transaction: transaction, in: self)
    }
}
