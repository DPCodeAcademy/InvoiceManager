import Foundation


class CustomerViewModel {
    
    private var customers: Set<Customer> = []
    
    func createNewCustomer(newCustomerInfo: CustomerInformation) -> Customer {
        let uniqueID = self.geranateUniqueID()
        let customer = Customer(id: uniqueID, info: newCustomerInfo)
        customers.insert(customer)
        return customer
    }
    
    func getCustomerList() -> Set<Customer> {
        return customers
    }
    
    func getCustomer(customerID: UInt16)-> Customer? {
        for customer in customers{
            if customer.customerID == customerID{
                return customer
            }
        }
        return nil
    }
    
    func getCustomer(eMailAddress: String)-> Customer? {
        for customer in customers{
            if customer.information.eMailAddress.caseInsensitiveCompare(eMailAddress) == .orderedSame {
                return customer
            }
        }
        return nil
    }
    
    func getCustomer(customerName: String) -> [Customer] {
        var ret:[Customer] = []
        
        for customer in customers {
            if customer.information.customerName == customerName {
                ret.append(customer)
            }
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
    
    func removeCustomer(customerID: UInt16) -> Void {
        let customer = Customer(id: customerID, info: CustomerInformation())
        removeCustomer(customer: customer)
    }
    
    func removeCustomer(customer: Customer) -> Void {
        customers.remove(customer)
    }
    
    private func geranateUniqueID()-> UInt16 {
        repeat{
            let id = UInt16.random(in: 1...UInt16.max)
            let dummy = Customer(id: id, info: CustomerInformation())
            if(!customers.contains(dummy))
            {
                return id
            }
        }while true
    }
}
