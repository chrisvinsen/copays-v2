//
//  SummaryTableViewCell.swift
//  copays
//
//  Created by Ryan Vieri Kwa on 12/04/22.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var memberTotalExpenseLabel: UILabel!
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    var currentMember = 0
    var memberIndex = [Int]()
    var transactionList = [Transaction]()
    var memberExpenseTotal = [String: Int64]()
    var categoriesTotalExpensePerMember = [[Int64]]()
    var trip: Trip?
    var detailSummaryData = [SummaryMemberExpenseData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        summaryCollectionView.delegate = self
        summaryCollectionView.dataSource = self
        memberTotalExpenseLabel.adjustsFontSizeToFitWidth = true
        memberTotalExpenseLabel.minimumScaleFactor = 0.2

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

extension SummaryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMember
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = summaryCollectionView.dequeueReusableCell(withReuseIdentifier: "summaryCollectionCell", for: indexPath) as! SummaryCollectionViewCell
        let imageName = detailSummaryData[indexPath.row].getCategoryDetails().image
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2

        cell.expenseCategoryImage.image = UIImage(named: imageName)
        cell.expenseName.text = detailSummaryData[indexPath.row].transactionName
        cell.expenseName.adjustsFontSizeToFitWidth = true
        cell.expenseName.minimumScaleFactor = 0.2

        cell.expenseAmount.text = "Rp. \(nf.string(from: detailSummaryData[indexPath.row].transactionAmount as NSNumber)!)"
        cell.expenseAmount.adjustsFontSizeToFitWidth = true
        cell.expenseAmount.minimumScaleFactor = 0.2

        print("[SEN] DETAILL")
        print ("[SEN] \(detailSummaryData)")
        
        return cell
    }
    
    
}
