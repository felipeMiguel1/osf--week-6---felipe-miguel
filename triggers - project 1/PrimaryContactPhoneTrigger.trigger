trigger PrimaryContactPhoneTrigger on Contact (before update, before insert) {

    Set<Id> accountIds = new Set<Id>();
    Map<Id, Contact> primaryContactsMap = new Map<Id, Contact>();
    List<Contact> contactsToUpdate = new List<Contact>();

    

    // Identifies account IDs and maps primary contacts
    for (Contact updatedContact : Trigger.new) {
        if (updatedContact.IsPrimary__c && updatedContact.AccountId != null) {
            accountIds.add(updatedContact.AccountId);
            primaryContactsMap.put(updatedContact.AccountId, updatedContact);
        }
    }

    //map containing the number of contacts marked as primary for each account
    if(accountIds.size() > 0) {
        Map<Id, Integer> primaryCountByAccount = new Map<Id, Integer>();
        for(Contact con : [SELECT Id, AccountId FROM Contact WHERE IsPrimary__c = true AND AccountId IN :accountIds]) {
            if(primaryCountByAccount.containsKey(con.AccountId)) {
                primaryCountByAccount.put(con.AccountId, primaryCountByAccount.get(con.AccountId) + 1);
            } else {
                primaryCountByAccount.put(con.AccountId, 1);
            }
        }
        
        //Validates if there is more than 1 primary contact for each account
        for(Contact con : Trigger.new) {
            if(con.IsPrimary__c && primaryCountByAccount.containsKey(con.AccountId) && primaryCountByAccount.get(con.AccountId) > 0 && (Trigger.isInsert || (Trigger.isUpdate && con.IsPrimary__c != Trigger.oldMap.get(con.Id).IsPrimary__c))) {
                con.addError('Only one contact per account can be marked as primary.');
            }
        }
    }

    // Gets all contacts related to modified accounts
    List<Contact> relatedContacts = [SELECT Id, AccountId, Primary_Contact_Phone__c FROM Contact
                                      WHERE AccountId IN :accountIds AND Id NOT IN :primaryContactsMap.keySet()];


   // Updates the primary contact's phone number for related contacts
   for (Contact relatedContact : relatedContacts) {
       if (primaryContactsMap.containsKey(relatedContact.AccountId)) {
           Contact primaryContact = primaryContactsMap.get(relatedContact.AccountId);
           relatedContact.Primary_Contact_Phone__c = primaryContact.Primary_Contact_Phone__c;
           contactsToUpdate.add(relatedContact);
       }
   }   
   
   // Updates contacts asynchronously and handles error handling
   if (!contactsToUpdate.isEmpty()) {
        Database.SaveResult[] updateResults = Database.update(contactsToUpdate, false);
        for (Database.SaveResult result : updateResults) {
            if (result.isSuccess()) {
                // Success
                System.debug('Contact updated successfully. Contact ID ' + result.getId());
            } else {
                // Error
                for (Database.Error err : result.getErrors()) {
                    System.debug('Error:');
                    System.debug('Status Code: ' + err.getStatusCode() + ', Error Messege: ' + err.getMessage());
                }
            }
        }
    }

}