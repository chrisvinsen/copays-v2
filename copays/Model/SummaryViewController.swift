//
//  SummaryViewController.swift
//  copays
//
//  Created by Julyo  on 11/04/22.
//

import UIKit


class SummaryViewController: UIViewController {

    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var summaryTableView: UITableView!
    var transactionList = [Transaction]()
    var summaryData = SummaryData(summaryMemberData: [])
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var indexTrip: Int?
    var numOfMembersInTrip: Int?
    var trip: Trip?
    var tripList = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preValidationLoadData()
        title = "Summary"
        generateSummaryData()
        totalExpenseLabel.adjustsFontSizeToFitWidth = true
        totalExpenseLabel.minimumScaleFactor = 0.2
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        totalExpenseLabel.text = "Rp. \(nf.string(from: summaryData.getTotalExpenses() as NSNumber)!)"
    }
    func fetchDataFromUserDefaults() {
        if let tripListData = defaults.data(forKey: "TripList"){
            do {
                let tripListDecoded = try decoder.decode([Trip].self, from: tripListData)
                trip = tripListDecoded[indexTrip!]
                tripList = tripListDecoded
            }
            catch {
                print("[LOG][AddTransactionViewController][fetchDataFromUserDefaults] Error")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    func preValidationLoadData() {
        // Pre Validate Data
        guard let _ = indexTrip else {
            navigationController?.popViewController(animated: true)
            return
        }

        // Pre Load Data
        fetchDataFromUserDefaults()

        guard let _ = trip else {
            navigationController?.popViewController(animated: true)
            return
        }
    }

    func generateSummaryData() {
        guard let _ = trip else {
            navigationController?.popViewController(animated: true)
            return
        }

        for member in trip!.members {
            print("[SEN] Append member \(member.name)")
            summaryData.summaryMemberData.append(SummaryMemberData(memberName: member.name, summaryMemberExpenseData: []))
        }

        for transaction in trip!.transactions {
            print("[SEN] Append Trx \(transaction.name) to \(transaction.chosenMembersIndex.count) member")
            for chosenMemberIndex in transaction.chosenMembersIndex {
                let splitedTrxAmount = Double(transaction.amount / Double(transaction.chosenMembersIndex.count))
                print("[SEN] \(splitedTrxAmount)")
                summaryData.summaryMemberData[chosenMemberIndex].summaryMemberExpenseData.append(SummaryMemberExpenseData(categoryIndex: transaction.categoryIndex, transactionName: transaction.name, transactionAmount: splitedTrxAmount))
            }
        }
        print("[SEN] \(summaryData.summaryMemberData)")
    }

    func expenseIcon(imageView expenseIcon: UIImageView, iconName: String) {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .black, scale: .medium)
        expenseIcon.image = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        expenseIcon.backgroundColor = #colorLiteral(red: 0, green: 0.6650400162, blue: 0.3193207383, alpha: 1)
        expenseIcon.layer.cornerRadius = expenseIcon.bounds.width/2
        expenseIcon.clipsToBounds = true
    }
    
    @IBAction func onEndButtonClicked(_ sender: Any) {
        trip?.isDone = true
        if let encodedTripList = try? encoder.encode(tripList){
            defaults.set(encodedTripList, forKey: "TripList")
        }
        navigationController?.popToRootViewController(animated: true)

    }
    
}
extension SummaryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryData.summaryMemberData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
        cell.summaryCollectionView.tag = indexPath.section
//        if let members = trip?.members{
//            cell.memberLabel.text = members[indexPath.row].name
//        }
        cell.memberLabel.text = summaryData.summaryMemberData[indexPath.row].memberName
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        cell.memberTotalExpenseLabel.text = "Rp. \(nf.string(from: summaryData.summaryMemberData[indexPath.row].getTotalMemberExpenses() as NSNumber)!)"
        cell.detailSummaryData = summaryData.summaryMemberData[indexPath.row].summaryMemberExpenseData
        cell.currentMember = summaryData.summaryMemberData[indexPath.row].summaryMemberExpenseData.count
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(55 + (62 * summaryData.summaryMemberData[indexPath.row].summaryMemberExpenseData.count))
        }
}
