//
//  productViewController.swift
//  A2_iOS_ Nilam_101456610
//
import UIKit
import CoreData

class AddProductViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var providerTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveProduct(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty,
              let priceText = priceTextField.text, let price = Decimal(string: priceText),
              let provider = providerTextField.text, !provider.isEmpty else {
            // Show error message if any field is empty
            print("Please fill in all fields.")
            return
        }

        // Create a new product and save it to Core Data
        let context = PersistenceController.shared.container.viewContext
        let newProduct = Product(context: context)
        newProduct.productName = name
        newProduct.productDescription = description
        newProduct.productPrice = price
        newProduct.productProvider = provider
        newProduct.productID = Int64(Date().timeIntervalSince1970) // Example to generate a unique product ID

        do {
            try context.save()
            navigationController?.popViewController(animated: true)  // Go back to the previous screen
        } catch {
            print("Error saving product: \(error)")
        }
    }
}
