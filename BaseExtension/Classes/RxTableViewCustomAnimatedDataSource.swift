//
//  RxTableViewCustomAnimatedDataSource.swift
//  BaseExtension
//
//  Created by wade.hawk on 09/12/2018.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

open class RxTableViewCustomAnimatedDataSource<S: AnimatableSectionModelType>
    : TableViewSectionedDataSource<S>
, RxTableViewDataSourceType {
    public typealias Element = [S]
    public typealias DecideViewTransition = (TableViewSectionedDataSource<S>, UITableView, [Changeset<S>]) -> ViewTransition
    
    /// Animation configuration for data source
    public var animationConfiguration: AnimationConfiguration
    
    /// Calculates view transition depending on type of changes
    public var decideViewTransition: DecideViewTransition
    
    public var reloadedEvent: (() -> Void)? = nil
    
    public init(
        animationConfiguration: AnimationConfiguration = AnimationConfiguration(),
        decideViewTransition: @escaping DecideViewTransition = { _, _, _ in .animated },
        configureCell: @escaping ConfigureCell,
        titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
        ) {
        self.animationConfiguration = animationConfiguration
        self.decideViewTransition = decideViewTransition
        super.init(
            configureCell: configureCell,
            titleForHeaderInSection: titleForHeaderInSection,
            titleForFooterInSection: titleForFooterInSection,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath,
            sectionIndexTitles: sectionIndexTitles,
            sectionForSectionIndexTitle: sectionForSectionIndexTitle
        )
    }
    
    var dataSet = false
    
    open func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, newSections in
            if !self.dataSet {
                self.dataSet = true
                dataSource.setSections(newSections)
                tableView.reloadData()
                self.reloadedEvent?()
            }
            else {
                DispatchQueue.main.async {
                    // if view is not in view hierarchy, performing batch updates will crash the app
                    if tableView.window == nil {
                        dataSource.setSections(newSections)
                        tableView.reloadData()
                        self.reloadedEvent?()
                        return
                    }
                    let oldSections = dataSource.sectionModels
                    do {
                        let differences = try Diff.differencesForSectionedView(initialSections: oldSections, finalSections: newSections)
                        
                        switch self.decideViewTransition(self, tableView, differences) {
                        case .animated:
                            for difference in differences {
                                dataSource.setSections(difference.finalSections)
                                
                                tableView.performBatchUpdates(difference, animationConfiguration: self.animationConfiguration)
                            }
                        case .reload:
                            self.setSections(newSections)
                            tableView.reloadData()
                            self.reloadedEvent?()
                            return
                        }
                    }
                    catch {
                        self.setSections(newSections)
                        tableView.reloadData()
                        self.reloadedEvent?()
                    }
                }
            }
            }.on(observedEvent)
    }
}
