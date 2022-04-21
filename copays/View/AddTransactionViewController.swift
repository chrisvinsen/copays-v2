//
//  AddTransactionViewController.swift
//  copays
//
//  Created by Christianto Vinsen on 06/04/22.
//

import UIKit

class AddTransactionViewController: UIViewController {
    // UIPickerViewDelegate, UIPickerViewDataSource
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txFieldName: UITextField!
    @IBOutlet weak var txFieldAmount: UITextField!
    @IBOutlet weak var txDate: UIDatePicker!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txFieldCategory: UITextField!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewBtnSplitWith: UIView!
    @IBOutlet weak var btnSplitWith: UIButton!
    @IBOutlet weak var btnDeleteTransaction: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var transaction: Transaction?
    var members : [Member] = []
    var pickerViewCategory = UIPickerView()
    var indexTrip:Int?
    var indexTransaction:Int?
    var tripList = [Trip]()
    var trip: Trip?
    var isEditTransaction: Bool = false
    var summaryData = SummaryData(summaryMemberData: [])


    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
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

        if isEditTransaction {
            guard let _ = indexTransaction else {
                navigationController?.popViewController(animated: true)
                return
            }
            
            transaction = tripList[indexTrip!].transactions[indexTransaction!]
        } else {
            transaction = Transaction(categoryIndex: 0, name: "", amount: 0.0, date: Date(), chosenMembersIndex: [])
        }
    }

    override func viewDidLoad() {
        preValidationLoadData()
        super.viewDidLoad()
        initCustomView()
        
        // Set listener every member chosen
        NotificationCenter.default.addObserver(self, selector: #selector(onMemberChosen), name: Notification.Name("ListenerForChosenMemberIndex"), object: nil)
    }
    
    @objc func btnSaveOnClicked() {
        if !vaidateInputForm() {
            let refreshAlert = UIAlertController(title: "Please fill in all data", message: "All transaction data required", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(refreshAlert, animated: true, completion: nil)
            return
        }
        
        transaction?.categoryIndex = Helper.getTransactionCategoryIndex(name: txFieldCategory.text!)
        transaction?.name = txFieldName.text!
        transaction?.amount = Double(txFieldAmount.text!)!
        transaction?.date = txDate.date
        
        if isEditTransaction {
            tripList[indexTrip!].transactions[indexTransaction!] = transaction!
        } else {
            tripList[indexTrip!].transactions.append(transaction!)
        }
        generateSummaryData()
        saveDataToUserDefaults()
        
        self.dismiss(animated: true, completion: nil)
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
        tripList[indexTrip!].totalExpenses = summaryData.getTotalExpenses()
        print("[ADD TRX] \(summaryData.summaryMemberData)")
    }

    @IBAction func btnSplitWithOnClicked(_ sender: Any) {
        if let viewController = UIStoryboard(name: "SplitMemberScreen", bundle: nil).instantiateViewController(withIdentifier: "AddMemberViewController") as? AddMemberViewController {
            
            viewController.members = members
            viewController.chosenMembersIndex = transaction!.chosenMembersIndex

            let navController = UINavigationController(rootViewController: viewController)
            
            present(navController, animated:true, completion: nil)
        }
    }
    
    @IBAction func btnDeleteTransactionOnClicked(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Are you sure?", message: "This transaction will be permanently deleted from your records", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (action: UIAlertAction!) in
            tripList[indexTrip!].transactions.remove(at: indexTransaction!)
            saveDataToUserDefaults()
            
            self.dismiss(animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func btnCancelOnClicked(_ sender: UIBarItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onMemberChosen (notification: NSNotification){
        if let dict = notification.object as? NSDictionary {
            if let chosenMembersIndex = dict["chosenMembersIndex"] as? [Int]{
                transaction?.chosenMembersIndex = chosenMembersIndex
                collectionView.reloadData()
            }
        }
    }
    
    func fetchDataFromUserDefaults() {
        if let tripListData = defaults.data(forKey: "TripList"){
            do {
                let tripListDecoded = try decoder.decode([Trip].self, from: tripListData)
                tripList = tripListDecoded
                trip = tripListDecoded[indexTrip!]
            }
            catch {
                print("[LOG][AddTransactionViewController][fetchDataFromUserDefaults] Error")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func saveDataToUserDefaults() {
        if let encodedUser = try? encoder.encode(tripList) {
            defaults.set(encodedUser, forKey: "TripList")
        }
    }
    
    func vaidateInputForm() -> Bool {
        if !Helper.isTransactionCategoryExists(name: txFieldCategory.text!) ||
            txFieldName.text == "" ||
            txFieldAmount.text == "" ||
            transaction?.chosenMembersIndex.count == 0
        {
            return false
        }
        
        return true
    }
    
    func prepareViewForEdit() {
        txFieldName.text = transaction!.name
        txFieldAmount.text = String(transaction!.amount)
        txDate.date = transaction!.date
        
        // Need to place before set default index 0 on "initView()"
        txFieldCategory.text = Constant.transactionCategories[transaction!.categoryIndex].name
        imgCategory.image = UIImage(named: Constant.transactionCategories[transaction!.categoryIndex].image)
        
        btnDeleteTransaction.isHidden = false
    }
    
    func initCustomView() {
        /// Navigation Bar
        let rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(btnSaveOnClicked)
        )
        rightBarButtonItem.tintColor = #colorLiteral(red: 0.05490196078, green: 0.662745098, blue: 0.3450980392, alpha: 1)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancelOnClicked))
        leftBarButtonItem.tintColor = .red
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        /// Category
        viewCategory.layer.cornerRadius = 10
        txFieldCategory.text = Constant.transactionCategories[0].name
        imgCategory.image = UIImage(named: Constant.transactionCategories[0].image)
        
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        
        txFieldCategory.inputView = pickerViewCategory
        
        /// Trx Name
        txFieldName.layer.cornerRadius = 10
        
        let imgTrxName = UIImageView(image: UIImage(systemName: "text.alignleft"))
        imgTrxName.tintColor = UIColor(red: 0.61, green: 0.63, blue: 0.67, alpha: 1.00)
        
        let contentView = UIView()
        contentView.addSubview(imgTrxName)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        
        imgTrxName.frame = CGRect(x: 18, y: 13, width: 32, height: 24)
        
        txFieldName.leftView = contentView
        txFieldName.leftViewMode = .always
        txFieldName.clearButtonMode = .always
        
        /// Amount
        viewAmount.layer.cornerRadius = 10
        
        /// Date
        viewDate.layer.cornerRadius = 10
        
        /// Button Split With
        viewBtnSplitWith.layer.cornerRadius = 10
        btnSplitWith.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        collectionView.dataSource = self
        
        if isEditTransaction {
            title = "Edit Transaction"
            prepareViewForEdit()
        } else {
            title = "Add Transaction"
        }
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.transactionCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.transactionCategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txFieldCategory.text = Constant.transactionCategories[row].name
        txFieldCategory.resignFirstResponder()
        
        imgCategory.image = UIImage(named: Constant.transactionCategories[row].image)
    }
}


extension AddTransactionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transaction!.chosenMembersIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.setupActive(member: members[transaction!.chosenMembersIndex[indexPath.row]])
        
        return cell
    }
}
