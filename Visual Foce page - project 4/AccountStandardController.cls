public class AccountStandardController {
    public String contactName { get; set; }
    public List<Contact> filteredContacts { get; set; }
    public Account Account { get; private set; }
    public Id selectedContactId { get; set; }

    public AccountStandardController(ApexPages.StandardController controller) {
        Account = (Account)controller.getRecord();
        contactName = '';
        filteredContacts = [SELECT Id, Name, Title, Phone, IsPrimary__c FROM Contact WHERE AccountId = :Account.Id];
    }

    //search the contacts by name
    public void searchContacts() {
        if (String.isNotBlank(contactName)) {
            filteredContacts = [SELECT Id, Name, Title, Phone, IsPrimary__c FROM Contact WHERE AccountId = :account.Id AND Name LIKE :('%' + contactName + '%')];
        } else {
            filteredContacts = [SELECT Id, Name, Title, Phone, IsPrimary__c FROM Contact WHERE AccountId = :account.Id];
        }
    }

    public void setPrimaryContact() {
        if (selectedContactId != null) {
            // Set all contacts as not primary
            List<Contact> contactsToUpdate = new List<Contact>();
            for (Contact contact : filteredContacts) {
                contact.IsPrimary__c = false;
                contactsToUpdate.add(contact);
            }
            update contactsToUpdate;

            // Set the select contact as primary contact
            Contact primaryContact = [SELECT Id, IsPrimary__c FROM Contact WHERE Id = :selectedContactId];
            if (primaryContact != null) {
                primaryContact.IsPrimary__c = true;
                update primaryContact;
            }

            // refresh the contact list with the new peimary contact
            filteredContacts = [SELECT Id, Name, Title, Phone, IsPrimary__c FROM Contact WHERE AccountId = :Account.Id];
        }
    }
}
