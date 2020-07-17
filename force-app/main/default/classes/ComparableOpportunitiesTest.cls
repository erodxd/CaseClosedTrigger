@isTest
private class ComparableOpportunitiesTest {

    @isTest static void createOpportunity() {
        // impliment test code
        Opportunity opp = new Opportunity();
        opp.Name = 'Big Deal';
        opp.CloseDate = Date.today();
        opp.StageName = 'Closed Won';
        opp.Amount = 100000;
        opp.Account.Industry = 'Food & Beverage';
        insert opp;
    }

    @isTest static void createList() {
        // impliment test code
        Decimal opportunityAmount = opp.Amount;
        Decimal tenpercentup = opportunityAmount * 1.1;
        Decimal tenpercentdown = opportunityAmount * .9;

        List<Opportunity> list = [SELECT Id
                                  FROM Opportunity
                                  WHERE Account.Industry = :opp.Account.Industry
                                  AND Amount <= :tenpercentup
                                  OR Amount >= :tenpercentdown];
    }
}