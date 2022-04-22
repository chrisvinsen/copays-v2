//
//  TransactionListViewController.swift
//  copays
//
//  Created by Christianto Vinsen on 21/04/22.
//

import UIKit

class TransactionListViewController: UIViewController {
    var indexTrip:Int?
    var trip: Trip?
    var tripData = TripData(expenseDatas: [])
    var sectionTrxCellData = [SectionTransactionCellData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTotalExpenses: UILabel!
    
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    override func viewWillAppear(_ animated: Bool) {
        guard let _ = indexTrip else {
            navigationController?.popViewController(animated: true)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TransactionHeaderCell", bundle: nil), forCellReuseIdentifier: "transactionHeaderCell")
        tableView.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "transactionCell")
        tableView.register(UINib(nibName: "TransactionMemberCell", bundle: nil), forCellReuseIdentifier: "transactionMemberCell")
        
        navigationItem.largeTitleDisplayMode = .never
        title = trip?.name
        
        let rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTransaction)
        )
        rightBarButtonItem.tintColor = #colorLiteral(red: 0.05490196078, green: 0.662745098, blue: 0.3450980392, alpha: 1)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        getTripDetails()
        generateTripData()
        generateTransactionCellData()
        
        labelTotalExpenses.text = tripData.getTotalTripExpenses().formattedRupiahCurrency
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenDataChanged), name: Notification.Name("ListenerDataChanged"), object: nil)
    }
    
    @objc func listenDataChanged(notification: NSNotification) {
        tripData = TripData(expenseDatas: [])
        sectionTrxCellData = [SectionTransactionCellData]()
        
        getTripDetails()
        generateTripData()
        generateTransactionCellData()

        labelTotalExpenses.text = tripData.getTotalTripExpenses().formattedRupiahCurrency
        
        tableView.reloadData()
    }
    
    func getTripDetails(){
        if let tripListData = defaults.data(forKey: "TripList"){
            do{
                //array of trip
                let tripList = try decoder.decode([Trip].self, from: tripListData)
                //assign trip by index
                trip = tripList[indexTrip!]
                
                guard let _ = trip else {
                    navigationController?.popViewController(animated: true)
                    return
                }
            }
            catch {
                print("[LOG][TransactionListViewController][getTripDetails] Error")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func generateTripData() {
        guard let _ = trip else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        for (trxIdx, transaction) in trip!.transactions.reversed().enumerated() {
            let trxDateString = CDate.toDateString(transaction.date)
            let actualTrxIdx = trip!.transactions.count - 1 - trxIdx
            
            // Populate Expense Data By Date
            var currExpenseIdx = tripData.expenseDatas.firstIndex(where: { $0.date == trxDateString })
            if currExpenseIdx == nil {
                tripData.expenseDatas.append(
                    ExpenseData(
                        date: trxDateString, transactionDatas: []
                    )
                )
                
                currExpenseIdx = tripData.expenseDatas.count - 1
            }
            
            // Insert Transaction to Expense
            var memberDatas = [MemberData]()
            for chosenMemberIndex in transaction.chosenMembersIndex {
                memberDatas.append(
                    MemberData(
                        name: trip!.members[chosenMemberIndex].name,
                        splitedAmount: Int64(transaction.amount / Double(transaction.chosenMembersIndex.count))
                    )
                )
            }
            tripData.expenseDatas[currExpenseIdx!].transactionDatas.append(
                TransactionData(
                    masterTrxIndex: actualTrxIdx,
                    categoryIndex: transaction.categoryIndex,
                    name: transaction.name,
                    totalAmount: Int64(transaction.amount),
                    memberDatas: memberDatas
                )
            )
        }
    }
    
    func generateTransactionCellData() {
        for expense in tripData.expenseDatas {
            var sectionData = SectionTransactionCellData()
            
            for transaction in expense.transactionDatas {
                sectionData.transactionCellData.append(TransactionCellData(
                    masterTrxIndex: transaction.masterTrxIndex,
                    categoryIndex: transaction.categoryIndex,
                    transactionName: transaction.name,
                    totalAmount: transaction.totalAmount.formattedRupiahCurrency,
                    memberName: nil,
                    splitedAmount: nil,
                    cellType: TransactionTableCellType.cellTransaction
                ))
                
                for member in transaction.memberDatas {
                    sectionData.transactionCellData.append(TransactionCellData(
                        masterTrxIndex: transaction.masterTrxIndex,
                        categoryIndex: nil,
                        transactionName: nil,
                        totalAmount: nil,
                        memberName: member.name,
                        splitedAmount: member.splitedAmount.formattedRupiahCurrency,
                        cellType: TransactionTableCellType.cellMember
                    ))
                }
            }
            
            sectionTrxCellData.append(sectionData)
        }
    }
    
    @objc func addNewTransaction() {
        if let viewController = UIStoryboard(name: "AddEditTransactionScreen", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionViewController") as? AddTransactionViewController {
                    
             viewController.indexTrip = indexTrip
             viewController.members = trip!.members
             
             viewController.isEditTransaction = false
            
             let navController = UINavigationController(rootViewController: viewController)
            
             present(navController, animated:true, completion: nil)
         }
    }
}


extension TransactionListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalMember = 0
        for trx in tripData.expenseDatas[section].transactionDatas {
            totalMember += trx.memberDatas.count
        }
        
        return tripData.expenseDatas[section].transactionDatas.count + totalMember
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tripData.expenseDatas.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "transactionHeaderCell") as! TransactionHeaderCell
        
        headerCell.labelDate.text = tripData.expenseDatas[section].getFormattedDate()
        headerCell.labelTotalExpenses.text = tripData.expenseDatas[section].getTotalTransactionExpenses().formattedRupiahCurrency
        headerView.addSubview(headerCell)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellData = sectionTrxCellData[indexPath.section].transactionCellData[indexPath.row]
        
        switch cellData.cellType {
        case .cellTransaction:
            return 60.0
        case .cellMember:
            return 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellData = sectionTrxCellData[indexPath.section].transactionCellData[indexPath.row]
        
        switch cellData.cellType {
        case .cellTransaction:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionCell
            
            cell.labelTrxName.text = cellData.transactionName
            cell.labelTrxAmount.text = cellData.totalAmount
            cell.imgTrxCategory.image = UIImage(named: Constant.transactionCategories[cellData.categoryIndex ?? 0].image)
            
            return cell
        case .cellMember:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionMemberCell") as! TransactionMemberCell
            
            cell.labelName.text = cellData.memberName
            cell.labelAmount.text = cellData.splitedAmount
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let viewController = UIStoryboard(name: "AddEditTransactionScreen", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionViewController") as? AddTransactionViewController {
            
             viewController.indexTrip = indexTrip
             viewController.indexTransaction = sectionTrxCellData[indexPath.section].transactionCellData[indexPath.row].masterTrxIndex
             viewController.members = trip!.members
             
             viewController.isEditTransaction = true
            
             let navController = UINavigationController(rootViewController: viewController)
            
             present(navController, animated:true, completion: nil)
         }
    }
}
