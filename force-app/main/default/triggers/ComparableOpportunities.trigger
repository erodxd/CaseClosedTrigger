trigger ComparableOpportunities on Opportunity (before insert) {

    for (Opportunity myOpp : Trigger.new) {

        String myOpportunityIndustry = myOpp.Account.Industry;
        
        if (myOpp.AccountId != null && myOpp.Name != null){
            List<Opportunity> matchingOpportunities = [SELECT Id, Name
                                                         FROM Opportunity
                                                        WHERE (StageName != null 
                                                          AND StageName = 'Closed Won'
                                                          AND CloseDate = THIS_YEAR)
                                                          AND (Account.Industry = :myOpportunityIndustry)];
                                                    
        System.debug('You have ' + matchingOpportunities.size() + ' in your list.' );
        }
    }
    
}

   //Show comparable opportunities whenever a new opportunitiy is created

    //we know an opportunitiy is comparable if
    // the opportunitiy amount is no more than 10% different
    // their accounts are in the exact same industry
    // and the opportunity is 'Closed Won' within the past year