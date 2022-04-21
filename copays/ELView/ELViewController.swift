//
//  ExpenseListViewController.swift
//  copays
//
//  Created by Suherda Dwi Santoso on 09/04/22.
//

import UIKit

class ELViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var expenseListTableView: UITableView!
    @IBOutlet weak var cardViewMain: UIView!
    
    var tripName: String?
    var familyDataSet : FamilyModel!
    var tableDataArr = Array<Any>()
    var indexTrip:Int?
    var trip: Trip?
    
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
        
        getTripDetails()
        
        //self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        self.fetchFamilyData()
        configureCardViewMain()
        title = tripName
        navigationItem.largeTitleDisplayMode = .never
        expenseListTableView.dataSource = self
        expenseListTableView.delegate = self
    }
    
    func getTripDetails(){
        if let tripListData = defaults.data(forKey: "TripList"){
            do{
                //array of trip
                let tripList = try decoder.decode([Trip].self, from: tripListData)
                //assign trip by index
                trip = tripList[indexTrip!]
            }
            catch {
                print("[LOG][ELViewController][getTripDetails] Error")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK:- Other private function
    // Fetching stored data from FamilyData.plist file
    func fetchFamilyData()
    {
        let path = Bundle.main.path(forResource: "Property List", ofType: "plist")
        let contentDict = NSDictionary(contentsOfFile: path!) as? Dictionary<String, Any>
        if contentDict != nil
        {
            familyDataSet = FamilyModel(dataDict: contentDict!)
            tableDataArr = (familyDataSet?.grandParentMArr)!
            expenseListTableView.reloadData()
        }
    }
    
    func configureCardViewMain(){
        cardViewMain.backgroundColor = .white
        cardViewMain.layer.cornerRadius = 10.0
        cardViewMain.layer.shadowColor = UIColor.gray.cgColor
        cardViewMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardViewMain.layer.shadowRadius = 20
        cardViewMain.layer.shadowOpacity = 0.2
        cardViewMain.layer.shadowPath = UIBezierPath(rect: cardViewMain.bounds).cgPath
    }
    
    //MARK:- TableView Data Source Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : ELTableViewCell?
        let member = tableDataArr[indexPath.row]
        if let grandP = member as? GrandParentModel
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Level1") as? ELTableViewCell
            cell?.titlel.text = grandP.grandParentName
            cell?.expEnses.text = grandP.Expense
        }
        else if let parent = member as? ParentModel
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Level2") as? ELTableViewCell
            cell?.titlel.text = parent.parentName
            cell?.expEnses.text = parent.Expenses
        }
        else if let child = member as? ChildModel
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Level3") as? ELTableViewCell
            cell?.titlel.text = child.childName
            cell?.expEnses.text = child.Expensess
        }
        else
        {
             return UITableViewCell()
        }
        return cell!
    }
    
    // MARK:- UITableView Delegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let row = indexPath.row
        let member = tableDataArr[row]
        var ipsArr = Array<IndexPath>()
        if let grandP = member as? GrandParentModel
        {
            if !grandP.isExpanded
            {
                // Insert next level items
                grandP.isExpanded = true
                for (index, value) in grandP.parentMArr.enumerated()
                {
                    self.tableDataArr.insert(value, at: row + index + 1)
                    let ip = IndexPath(row: row + index + 1, section: 0)
                    ipsArr.append(ip)
                }
                tableView.beginUpdates()
                tableView.insertRows(at: ipsArr, with: .left)
                tableView.endUpdates()
            }
            else
            {
                // Delete next level items
                var count = 1
                while row + 1 < tableDataArr.count
                {
                    let element = tableDataArr[row + 1]
                    if !(element is GrandParentModel)
                    {
                        (element as? ParentModel)?.isExpanded = false
                        (element as? ChildModel)?.isExpanded = false
                        self.tableDataArr.remove(at: row + 1)
                        let ip = IndexPath(row: row + count, section: 0)
                        ipsArr.append(ip)
                        count += 1
                        
                    }
                    else if (element is GrandParentModel)
                    {
                        break
                    }
                }
                grandP.isExpanded = false
                tableView.beginUpdates()
                tableView.deleteRows(at: ipsArr, with: .right)
                tableView.endUpdates()
            }
        }
        else if let parent = member as? ParentModel
        {
            if !parent.isExpanded
            {
                parent.isExpanded = true
                for (index, value) in parent.childMArr.enumerated()
                {
                    self.tableDataArr.insert(value, at: row + index + 1)
                    let ip = IndexPath(row: row + index + 1, section: 0)
                    ipsArr.append(ip)
                }
                tableView.beginUpdates()
                tableView.insertRows(at: ipsArr, with: .left)
                tableView.endUpdates()
            }
            else
            {
                // Delete next level items
                var count = 1
                while row + 1 < tableDataArr.count
                {
                    let element = tableDataArr[row + 1]
                    if (element is GrandParentModel) || (element is ParentModel)
                    {
                        break
                    }
                    else if !(element is GrandParentModel)
                    {
                        (element as? ParentModel)?.isExpanded = false
                        (element as? ChildModel)?.isExpanded = false
                        self.tableDataArr.remove(at: row + 1)
                        let ip = IndexPath(row: row + count, section: 0)
                        ipsArr.append(ip)
                        count += 1
                        
                    }
                }
                parent.isExpanded = false
                tableView.beginUpdates()
                tableView.deleteRows(at: ipsArr, with: .right)
                tableView.endUpdates()
            }
        }
        else if member is ChildModel
        {
            // Prompt new View controller
             if let viewController = UIStoryboard(name: "AddEditTransactionScreen", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionViewController") as? AddTransactionViewController {
                
                 viewController.indexTrip = indexTrip
                 viewController.indexTransaction = 0
                 viewController.members = trip!.members
                 
                 viewController.isEditTransaction = true
                
                 let navController = UINavigationController(rootViewController: viewController)
                
                 present(navController, animated:true, completion: nil)
             }
        }
    }
    
    @IBAction func onAddTransactionButtonClicked(_ sender: Any) {
         if let viewController = UIStoryboard(name: "AddEditTransactionScreen", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionViewController") as? AddTransactionViewController {
            
             viewController.indexTrip = indexTrip
             viewController.members = trip!.members
             
             viewController.isEditTransaction = false
            
             let navController = UINavigationController(rootViewController: viewController)
            
             present(navController, animated:true, completion: nil)
         }
    }
    
    @IBAction func onViewSummaryButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "summaryPageSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summaryPageSegue" {
            let summaryPage = segue.destination as! SummaryViewController
            summaryPage.indexTrip = self.indexTrip!
        }
    }
}
