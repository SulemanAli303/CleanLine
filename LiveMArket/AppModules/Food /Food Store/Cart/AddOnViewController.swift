//
//  AddOnViewController.swift
//  LiveMArket
//
//  Created by Suleman Ali on 04/05/2024.
//

import UIKit

class AddOnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var addOnTableView: CustomTableView!
    var didTapOnContinueButton:(([String:String])->Void) = {_ in }
    var product_combo:[FoodProductComboElement]!
    var currencyCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addOnTableView.minHeight = 300
        addOnTableView.maxHeight = view.frame.height - 250
        addOnTableView.allowsMultipleSelection = true
        addOnTableView.delegate = self
        addOnTableView.register(UINib(nibName: "ProductComboCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductComboCellTableViewCell")
        addOnTableView.dataSource = self
        addOnTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for (section,combo) in product_combo!.enumerated() {
            for (row,item) in combo.comboItems!.enumerated() {
                if item.isDefault == "1" {
                    addOnTableView.selectRow(at: IndexPath(row: row, section: section), animated: true, scrollPosition: .none)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        var output:[String:String] = [:]
        var isError = false
        var requiredComboTitle = ""
        let indexs = addOnTableView.indexPathsForSelectedRows ?? []
        for (section,combo) in product_combo.enumerated() {
            if combo.isRequired == "1" && !indexs.contains(where: {$0.section == section }) {
                requiredComboTitle = combo.foodHeading!.name
                isError = true
                break
            }
        }
        if !isError {
            for index in indexs {
                if let cell = addOnTableView.cellForRow(at: index) as? ProductComboCellTableViewCell {
                     let item = product_combo![index.section].comboItems![index.row]
                    output["add_ons[\(item.foodProductComboID ?? "")][\(item.id ?? "")]"] = "\(cell.itemCount)"
                }
            }
            didTapOnContinueButton(output)
            UserDefaults.standard.set(output, forKey: "add_ons")
        } else {
            Utilities.showWarningAlert(message: "Minimum one Item required from \(requiredComboTitle)") {
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return product_combo.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_combo![section].comboItems!.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return product_combo![section].foodHeading!.name
    }

//MARK: - for allow or disallow the selection
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

        //MARK: - for allow or disallow the selection
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductComboCellTableViewCell", for: indexPath) as! ProductComboCellTableViewCell
        cell.currencyCode =  currencyCode
        cell.item = product_combo![indexPath.section].comboItems![indexPath.row]
        return cell
    }
}


