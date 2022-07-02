
import Foundation


class CustomerList
{
  private var customers: Set<Customer> = []

  func createNewCustomer(newCustomerInfo: Customer.Information) -> Customer{
    let uniqueID = self.geranateUniqueID()
    let customer = Customer(id: uniqueID, info: newCustomerInfo)
    customers.insert(customer)
    return customer
  }

  func getCustomerList() -> Set<Customer>{
    return customers
  }

  func getCustomer(customerID: UInt16)-> Customer?{
    for customer in customers{
      if customer.customerID == customerID{
        return customer
      }
    }
    return nil
  }
  
  func getCustomer(customerName: String) -> [Customer]{
    var ret:[Customer] = []
    
    for customer in customers {
      if customer.information.customerName == customerName{
        ret.append(customer)
      }
    }
    return ret
  }
  
  func hasCustomerInfo(customerName: String) -> Bool{
    let customerInfo = getCustomer(customerName: customerName)
    return !customerInfo.isEmpty
  }
  
  func hasCustomerInfo(eMailAdress: String) ->Bool{
    for customer in customers {
      if customer.information.eMailAddress.caseInsensitiveCompare(eMailAdress) == .orderedSame{
        return true
      }
    }
    return false
  }

  func updateCustomerInfo(customerID: UInt16, information: Customer.Information)-> Bool{
    guard let existedCustomer = getCustomer(customerID: customerID) else{
      return false
    }
    removeCustomer(customer: existedCustomer)
    let updatedCustomer = Customer(id: customerID, info: information)
    customers.insert(updatedCustomer)
    return true
  }
  
  func removeCustomer(customerID: UInt16) -> Void{
    let customer = Customer(id: customerID, info: Customer.Information())
    removeCustomer(customer: customer)
  }
  
  func removeCustomer(customer: Customer) -> Void{
    customers.remove(customer)
  }

  private func geranateUniqueID()-> UInt16{
    repeat{
      let id = UInt16.random(in: 1...UInt16.max)
      let dummy = Customer(id: id, info: Customer.Information())
      if(!customers.contains(dummy))
      {
        return id
      }
    }while true
  }
}


struct Customer: Hashable{
  let customerID: UInt16
  var information: Information

  struct Information{
    var customerName: String = ""
    var eMailAddress: String = ""
    var isAutoSendInvoice: Bool = true
    var customerRate: Int = 0
  }

  init(id: UInt16, info: Information){
    self.customerID = id
    self.information = info
  }

  func getInformation() ->Information{
    return self.information
  }

  mutating func updateInformation(info: Information){
    self.information = info
  }

  static func == (lhs: Customer, rhs: Customer) -> Bool {
    return lhs.customerID == rhs.customerID
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(customerID)
  }
}

