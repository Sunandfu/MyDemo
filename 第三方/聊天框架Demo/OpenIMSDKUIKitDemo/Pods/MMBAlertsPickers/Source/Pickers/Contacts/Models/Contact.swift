import UIKit
import Contacts

public struct Contact {
    
    public var value: CNContact
    
    public var firstName: String
    
    public var lastName: String
    
    public var company: String
    
    public var image: UIImage?
    
    public var thumbnail: UIImage?
    
    public var birthday: Date?
    
    public var id: String?
    
    public var phones: [(number: String, label: String)] = []
    
    public var emails: [(email: String, label: String )] = []
    
    public var displayName:  String {
        return firstName + " " + lastName
    }
    
    public var initials: String {
        var initials = String()
        if let first = firstName.first { initials.append(first) }
        if let second = lastName.first { initials.append(second) }
        return initials
    }
    
    public init(contact: CNContact) {
        value = contact
        firstName = contact.givenName
        lastName = contact.familyName
        company = contact.organizationName
        id = contact.identifier
        
        if let thumbnailImageData = contact.thumbnailImageData {
            thumbnail = UIImage(data: thumbnailImageData)
        }
        
        if let imageData = contact.imageData {
            image = UIImage(data: imageData)
        }
        
        if let birthdayDate = contact.birthday {
            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
        }
        
        for phoneNumber in contact.phoneNumbers {
            let label = phoneNumber.label ?? "phone"
            let phone = phoneNumber.value.stringValue
            phones.append((phone, label))
        }
        
        for emailAddress in contact.emailAddresses {
            guard let label = emailAddress.label else { continue }
            let email = emailAddress.value as String
            emails.append((email, label))
        }
    }
}
