 trigger ComparableOpportunities on Opportunity (before insert) {

        for (Opportunity myOpp : Trigger.new) {
            //Query the account for our opportunity
            Opportunity oppAccountIndustry = [SELECT Id,
                                                     Account.Industry   
                                                FROM Opportunity
                                               WHERE Id = :myOpp.Id
                                               LIMIT 1];

            Decimal tenPercentOfOppUp = (myOpp.Amount) * 1.1;
            Decimal tenPercentOfOppDown = (myOpp.Amount) * 0.9;
    
            if (myOpp.AccountId != null && myOpp.Amount != null) {
                // SOQL Query for comparable opportunities
                List<Opportunity> comparableOpportunityList = [SELECT Id
                                                                 FROM Opportunity
                                                                WHERE (StageName != null
                                                                  AND Account.Industry != null
                                                                  AND StageName = 'Closed Won'
                                                                  AND CloseDate >= LAST_N_DAYS:365
                                                                  AND Account.Industry = :oppAccountIndustry.Account.Industry
                                                                  AND Amount <= :tenPercentOfOppUp
                                                                  AND Amount >= :tenPercentOfOppDown
                                                                  AND Id != :myOpp.Id)];
                                                                  
                System.debug('There are ' + comparableOpportunityList.size() + ' comparable opportunities in your list');
                //System.debug('This is the opportunity ' + comparableOpportunityList.get(0));
                //System.debug(comparableOpportunityList.size());
                for (Opportunity comparable : comparableOpportunityList) {
                    Comparable__c jObject = new Comparable__c();
                    jObject.Base_Opportunity__c = myOpp.Id;
                    jObject.Comparable_Opportunity__c = comparable.Id;
                    insert jObject;
                }
            }
        }
    }
    
       //Show comparable opportunities whenever a new opportunitiy is created
    
        //we know an opportunitiy is comparable if
        // the opportunitiy amount is no more than 10% different
        // their accounts are in the exact same industry
        // and the opportunity is 'Closed Won' within the past year