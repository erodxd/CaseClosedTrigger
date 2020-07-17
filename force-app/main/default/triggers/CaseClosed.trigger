trigger CaseClosed on Case (before insert) {

    for (Case myCase :Trigger.new) {
            List<Case> setToClose = new List<Case>();
            // Search for Cases with matching contactId and createdDate.
            List<Case> matchingCases = [SELECT Status
                                          FROM Case
                                         WHERE (ContactId = :myCase.ContactId 
                                           AND CreatedDate <= LAST_N_DAYS:1)];
            System.debug('I found this many matching cases: ' + matchingCases.size());
            System.debug('This is the case that was added to the list: ' + matchingCases.get(0));
            //System.debug('myCase.CreatedDate is: ' + myCase.CreatedDate.date());

            // if more than two cases are found...
            if (matchingCases.size() >= 2) {
                // add cases to new list
                for (Case c : matchingCases) {
                    c = myCase;
                    setToClose.add(c);
                }
                // set case status to closed
                for (Case c : setToClose) {
                    c.Status = 'Closed';
                }
                
             }

            
            
            
            
        }   

        
        // Case caseContact = [SELECT Id,
        //                            ContactId,
        //                            CreatedDate
        //                       FROM Case 
        //                      WHERE Id = :myCase.Id
        //                      LIMIT 1];

        // //SOQL query for our cases
        // List<Case> listOfContactCases = [SELECT Id 
        //                                    FROM Case 
        //                                   WHERE ContactId = :caseContact.ContactId 
        //                                     AND (CreatedDate = :caseContact.CreatedDate AND Id != :myCase.Id)];

        // for (Case caseClosed : listOfContactCases) {
        //     if (listOfContactCases.size() > 2) {
        //         caseClosed.IsClosedOnCreate = true;
        //         insert caseClosed;
        //     } else {
        //         caseClosed.IsClosedOnCreate = false;
        //         insert caseClosed;
        //     }

        // }
}