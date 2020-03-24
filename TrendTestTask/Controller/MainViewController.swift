//
//  ViewController.swift
//  TrendTestTask
//
//  Created by Nikolay on 11/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//
import Alamofire
import SwiftyJSON
import SDWebImage
import UIKit

class MainViewController: UIViewController, TransferDataToVCDelegate {

    //MARK: - Variables
    private let namings = NamingStrings()
    private var data = PositionsData()
    private var apiService = APIService()

    private var currentSortedType: SortType = SortType.price
    private let priceOptions = DropDownOptionsProvider()

    private var selectedPriceFrom: Int = 0
    private var selectedPriceTo: Int = 0

    private let utils = ActivityIndicator()

    //MARK: - Outlets & Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountOfObjectsLabel: UILabel!
    @IBOutlet weak var priceSortButton: UIButton!
    @IBOutlet weak var regionSortButton: UIButton!
    @IBOutlet weak var subwaySortButton: UIButton!
    @IBOutlet weak var filterStack: UIStackView!
    
    private let priceToButton = DropDownButton()
    private let priceFromButton = DropDownButton()


    override func viewDidLoad() {
        super.viewDidLoad()

        configurateDropDownButtons()
        makeContstraintsForFromDropDownButton()
        makeConstraintsForToDropDownButton()
        makeUnderscore(for: priceSortButton)
        apiService.fetchInitialData(completion: fetchCompletionResolver)
        refreshAmountValue()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        utils.showActivityIndicator(uiView: self.view)
    }

    //MARK: - Networking methods
    @IBAction func sortByPriceButtonAction(_ sender: UIButton) {
        sortAction(by: .price)
        makeUnderscore(for: sender)
    }

    @IBAction func sortByAreaButtonAction(_ sender: UIButton) {
        sortAction(by: .region)
        makeUnderscore(for: sender)
    }

    @IBAction func sortByMetroButtonAction(_ sender: UIButton) {
        sortAction(by: .subway)
        makeUnderscore(for: sender)
    }

    private func sortAction(by sortType: SortType) {
        utils.showActivityIndicator(uiView: self.view)
        currentSortedType = sortType
        clearSelectedState()
        apiService.fetch(sortedBy: currentSortedType, completion: fetchCompletionResolver)
    }

    private func loadMoreButtonWasPressed() {
        utils.showActivityIndicator(uiView: self.view)
        apiService.fetch(sortedBy: currentSortedType, withOffset: data.models.count, completion: fetchMoreCompletionResolver)
    }

    private func fetchCompletionResolver(data: PositionsData) {
        utils.hideActivityIndicator(uiView: self.view)
        self.data = data
        refreshAmountValue()
        collectionView.reloadData()
        scrollCollectionViewToTop()
    }
    
    private func scrollCollectionViewToTop() {
        if data.models.count != 0 {
            collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }

    private func fetchMoreCompletionResolver(data: PositionsData) {
        utils.hideActivityIndicator(uiView: self.view)
        self.data.models.append(contentsOf: data.models)
        self.data.amount = data.amount
        refreshAmountValue()
        collectionView.reloadData()
    }

    internal func dataFromDropDownMenu(price: Int, direction: DropDownButton.Direction) {
        switch direction {
        case .from:
            self.selectedPriceFrom = price
        case .to:
            self.selectedPriceTo = price
        }

        if selectedPriceFrom > selectedPriceTo && selectedPriceTo != 0 {
            createAlert(withTitle: namings.alertTitle, message: namings.alertMessage, cancelText: namings.alertCancelText)
        } else {
            apiService.fetch(sortedBy: currentSortedType, priceFrom: selectedPriceFrom, priceTo: selectedPriceTo, completion: fetchCompletionResolver)
        }
    }
    
    @objc private func loadMoreCells(sender: UIButton) {
        self.loadMoreButtonWasPressed()
    }

    // MARK: - UI
    private func refreshAmountValue() {
        amountOfObjectsLabel.text = "\(data.amount) объектов:"
    }

    private func configurateDropDownButtons() {
        priceFromButton.transferDelegate = self
        priceFromButton.direction = .from
        priceFromButton.setImage(UIImage(named: namings.arrowDownImageName), for: .normal)
        priceFromButton.setTitle(namings.dropDownFromDefaultTitle, for: .normal)
        priceFromButton.defaultTitle = namings.dropDownFromDefaultTitle
        priceFromButton.dropView.dropDownOptions = priceOptions.pricesFrom
        self.view.addSubview(priceFromButton)

        priceToButton.transferDelegate = self
        priceToButton.direction = .to
        priceToButton.setImage(UIImage(named: namings.arrowDownImageName), for: .normal)
        priceToButton.setTitle(namings.dropDownToDefaultTitle, for: .normal)
        priceToButton.defaultTitle = namings.dropDownToDefaultTitle
        priceToButton.dropView.dropDownOptions = priceOptions.pricesTo
        self.view.addSubview(priceToButton)
    }
    
    private func makeContstraintsForFromDropDownButton() {
        priceFromButton.translatesAutoresizingMaskIntoConstraints = false
        priceFromButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        priceFromButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        priceFromButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
        priceFromButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func makeConstraintsForToDropDownButton() {
        priceToButton.translatesAutoresizingMaskIntoConstraints = false
        priceToButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        priceToButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1).isActive = true
        priceToButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
        priceToButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func makeUnderscore(for sender: UIButton) {
        sender.isSelected = true
        sender.addStroke(border: .bottom, color: UIColor.black, width: 2)
        sender.tintColor = UIColor.clear
        sender.setTitleColor(UIColor.black, for: .selected)
    }

    private func clearSelectedState() {
        [priceSortButton, regionSortButton, subwaySortButton].forEach { button in
            button?.isSelected = false
            button?.remove(border: .bottom)
        }
    }
    
    private func createAlert(withTitle title: String, message: String, cancelText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - CollectionView data source section
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: namings.detailCellId, for: indexPath) as! DetailCell

        cell.alpha = 0.2
        cell.fillCell(with: data.models, at: indexPath)
        cell.animateFade()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: namings.footerCellId,
                                                                     for: indexPath) as! FooterCollectionCell
        
        footer.loadMoreButton.addTarget(self, action: #selector(loadMoreCells), for: .touchUpInside)
        footer.isHidden = data.models.isEmpty

        return footer
    }
}

//MARK: - CollectionView delegate section
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width, height: 246)
    }
}

//MARK: - TableView data source section
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableView = tableView as? PricingTableView {
            return tableView.responseModel.minPrices.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: namings.pricingCellId, for: indexPath) as! PricingCell

        if let tableView = tableView as? PricingTableView {
            cell.roomsCountLabel.text = tableView.responseModel.minPrices[indexPath.row].rooms
            cell.priceLabel.text = "от \(tableView.responseModel.minPrices[indexPath.row].minPrices) руб."
        }
        return cell
    }
}

//MARK: - TableView delegate section
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }
}
