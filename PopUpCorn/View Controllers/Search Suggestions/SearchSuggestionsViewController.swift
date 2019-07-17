//
//  SearchSuggestionsViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 16/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

/// a view controller that shows the suggestions list
class SearchSuggestionsViewController: UIViewController {
    @IBOutlet weak var suggestionsTableView: UITableView! {
        didSet {
            suggestionsTableView.separatorStyle = .none
        }
    }

    weak var delegate: SearchSuggestionsViewContorllerDelegate?

    private var suggestionsController = SuggestionsController.init()
    private var searchResults: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        view.backgroundColor = UIColor.black

        registerCells()
    }

    private func registerCells() {
        suggestionsTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: Constants.suggestionCellIdentifier
        )
    }

    func add(suggestion: String) {
        suggestionsController.add(suggestion: suggestion)
    }

    func saveSuggestions() {
        suggestionsController.saveSuggestions()
    }

    func setParamenter(text: String) {
        self.searchResults = suggestionsController.searchOnSuggestions(text: text)
        self.reloadData()
    }

    func removeParamenter() {
        self.searchResults = nil
        self.reloadData()
    }

    func reloadData() {
        suggestionsTableView.reloadData()
    }
}

extension SearchSuggestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = self.searchResults, searchResults.count > 0 {
            return searchResults.count
        }

        return suggestionsController.numberOfSuggestions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.suggestionCellIdentifier, for: indexPath)

        var suggestion = suggestionsController.suggestionAt(position: indexPath.row)

        if let searchResults = self.searchResults, searchResults.count > 0 {
            suggestion = searchResults[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = suggestion

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var suggestion = suggestionsController.suggestionAt(position: indexPath.row)

        if let searchResults = self.searchResults, searchResults.count > 0 {
            suggestion = searchResults[indexPath.row]
        }

        delegate?.userDidSelectSuggestion(self, suggestion: suggestion)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.row)
    }
}

private enum Constants {
    static let suggestionCellIdentifier = "suggestion_cell_identifier"
}
