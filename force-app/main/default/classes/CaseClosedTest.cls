@isTest
private class CaseClosedTest {

    @isTest static void lessThanTwoCases() {
        // impliment test code
        Account acc = new Account();
        acc.Name = 'winterfell hotels';
        insert acc;

        Contact contact = new Contact();
        contact.Name = 'Jon Snow';
        contact.AccountId = acc.Id;
        insert contact;


        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Origin = 'Web';
        newCase.AccountId = acc.Id;
        newCase.ContactId = contact.Id;
        newCase.isClosedOnCreate = false;
        insert newCase;

        Case updateCase = [SELECT Id,
                                   IsClosedOnCreate
                              FROM Case 
                             WHERE Id = :newCase.Id];

        System.assert(!updateCase.IsClosedOnCreate.isTrue());

    }

    @isTest static void twoCases() {
        // impliment test code

    }

    @isTest static void moreThanTwoCases() {
        // impliment test code

    }

}