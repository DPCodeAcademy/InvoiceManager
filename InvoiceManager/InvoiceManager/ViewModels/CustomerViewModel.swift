import Foundation

class CustomerViewModel {

    private var customers: Set<Customer> = []

    func createNewCustomer(newCustomerInfo: CustomerInformation) -> Customer {
        let uniqueID = self.geranateUniqueID()
        let customer = Customer(id: uniqueID, info: newCustomerInfo)
        customers.insert(customer)
        return customer
    }

    func getCustomerList() -> [Customer] {
		let ret = Array(customers)
		return ret.sorted {
			$0.information.customerName < $1.information.customerName
		}
    }

    func getCustomer(customerID: UInt16) -> Customer? {
        for customer in customers where customer.customerID == customerID {
			return customer
        }
        return nil
    }

    func getCustomer(eMailAddress: String) -> Customer? {
        for customer in customers where customer.information.eMailAddress.caseInsensitiveCompare(eMailAddress) == .orderedSame {
			return customer
        }
        return nil
    }

    func getCustomer(customerName: String) -> [Customer] {
        var ret: [Customer] = []

        for customer in customers where customer.information.customerName == customerName {
			ret.append(customer)
        }
        return ret
    }

    func updateCustomerInfo(customerID: UInt16, information: CustomerInformation) -> Bool {
        guard let existedCustomer = getCustomer(customerID: customerID) else {
            return false
        }
        removeCustomer(customer: existedCustomer)
        let updatedCustomer = Customer(id: customerID, info: information)
        customers.insert(updatedCustomer)
        return true
    }

    func removeCustomer(customerID: UInt16) {
        let customer = Customer(id: customerID, info: CustomerInformation())
        removeCustomer(customer: customer)
    }

    func removeCustomer(customer: Customer) {
        customers.remove(customer)
    }

    private func geranateUniqueID() -> UInt16 {
        repeat {
            let id = UInt16.random(in: 1...UInt16.max)
			var isExistID = false
			for customer in customers where customer.customerID == id {
				isExistID = true
				break
			}
			if !isExistID {
				return id
			}
        }while true
    }
}
