 trigger ComparableOpportunities on Opportunity (before insert) {

        for (Opportunity myOpp : Trigger.new) {


            //Decimal myOppIndustry = myOpp.Amount;
            Decimal tenPercentOfOppUp = (myOpp.Amount) * 1.1;
            Decimal tenPercentOfOppDown = (myOpp.Amount) / 1.1;
    
            if (myOpp.AccountId != null && myOpp.Name != null) {
    
                List<Opportunity> comparableOpportunityList = [SELECT Id, Name 
                                                                 FROM Opportunity
                                                                WHERE (StageName != null
                                                                  AND StageName = 'Closed Won'
                                                                  AND CloseDate = LAST_N_MONTHS:12)];
                                                                  //AND (Account.Industry != null
                                                                  //AND Account.Industry = :myOppIndustry)];
                                                                  //AND (Amount >= :tenPercentOfOppDown OR Amount <= :tenPercentOfOppUp)];
    
    
                System.debug('There are ' + comparableOpportunityList.size() + ' comparable opportunities in your list');
                //System.debug('This is the opportunity ' + comparableOpportunityList.get(0));
                //System.debug(comparableOpportunityList.size());
            }
    
    
        }
        
    }
    
       //Show comparable opportunities whenever a new opportunitiy is created
    
        //we know an opportunitiy is comparable if
        // the opportunitiy amount is no more than 10% different
        // their accounts are in the exact same industry
        // and the opportunity is 'Closed Won' within the past year