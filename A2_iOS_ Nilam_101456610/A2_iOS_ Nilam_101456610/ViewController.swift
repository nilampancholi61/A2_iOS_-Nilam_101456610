//
//  ViewController.swift
//  A2_iOS_ Nilam_101456610
//

//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    // MARK: - Properties
    var fetchedResultsController: NSFetchedResultsController<Product>!
    var searchController: UISearchController!
    var isSearching = false
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self

        // Fetch products
        fetchProducts()
    }

    // MARK: - Core Data Fetching
    func fetchProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "productName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let context = PersistenceController.shared.container.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch products: \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.fetchedObjects?.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = product.productName
        cell.detailTextLabel?.text = product.productDescription
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Optionally, you can add code to show product details or allow editing
    }

    // MARK: - Search Bar Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            fetchProducts()
            return
        }

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@", searchText, searchText)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "productName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let context = PersistenceController.shared.container.viewContext
        do {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: context,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Failed to fetch filtered products: \(error)")
        }
    }

    // MARK: - Navigation
    @IBAction func addProductTapped(_ sender: UIBarButtonItem) {
        // Navigate to the AddProductViewController to add a new product
        let addProductVC = storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        navigationController?.pushViewController(addProductVC, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            break
        }
    }
}

