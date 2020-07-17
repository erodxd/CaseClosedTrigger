@isTest
private class DedupeLeadTest {

    @isTest static void createLeadNoDupes() {
        String leadOwner = UserInfo.getUserId();
        //create necessary records
        Lead myLead = new Lead();
        myLead.FirstName = 'Robinson';
        myLead.LastName = 'Canoe';
        myLead.Email = 'robinson.caone@yankees.com';
        myLead.Company = 'NY Yankees';
        myLead.Description = 'Champion';
        myLead.OwnerId = leadOwner;
        insert myLead;

       // use soql to find the latest values
        Lead updatedLead = [SELECT OwnerId,
                                    Description
                              FROM Lead 
                             WHERE Id = :myLead.Id];

        // assert that the results are as expected
        System.assertEquals(leadOwner, updatedLead.OwnerId);
        System.assertEquals(myLead.Description, updatedLead.Description);
    }

    @isTest static void createLeadMultipleDupes() {
        String email = 'robinson.canoe@yankees.com';
        //create two dupe contacts
        List<Contact> dupeContacts = new List<Contact>();
        Contact firstDupe = new Contact();
        firstDupe.FirstName = 'Robinson';
        firstDupe.LastName = 'Canoe';
        firstDupe.Email = email;
        dupeContacts.add(firstDupe);

        Contact secondDupe = new Contact();
        secondDupe.FirstName = 'Robinson';
        secondDupe.LastName = 'Canoe';
        secondDupe.Email = email;
        dupeContacts.add(secondDupe);

        insert dupeContacts;

        // create our dupe lead
        Lead myLead = new Lead();
        myLead.FirstName = 'Robinson';
        myLead.LastName = 'Canoe';
        myLead.Email = email;
        myLead.Company = 'NY Yankees';
        myLead.Description = 'Champion';
        myLead.OwnerId = UserInfo.getUserId();
        insert myLead;

        // Use SOQL to get hte latest values of our lead
        Lead updatedLead =[SELECT OwnerId,
                                  Description 
                             FROM Lead
                            WHERE Id = :myLead.Id];

        // Get the data quality queue info
        Group dataQualityQueue = [SELECT Id 
                                    FROM Group 
                                   WHERE DeveloperName = 'Data_Quality'
                                   LIMIT 1];

        // Assertions
        System.assertEquals(dataQualityQueue.Id, updatedLead.OwnerId);
        System.assert(updatedLead.Description.contains(firstDupe.Id));
        System.assert(updatedLead.Description.contains(secondDupe.Id));
    }

}