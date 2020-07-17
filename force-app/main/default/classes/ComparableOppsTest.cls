@isTest
private class ComparableOppsTest {

    @isTest static void noComparableOpps() {
        // Create records
        Account acc = new Account();
        acc.Name = 'winterfell hotels';
        acc.Industry = 'hospitals';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'winterfell hotels';
        opp.AccountId = acc.Id;
        opp.Amount = 100;
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today();
        insert opp;

        // Query latest values
        List<Comparable__c> comparables = [SELECT Id
                                       FROM Comparable__c 
                                      WHERE Base_Opportunity__c = :opp.Id];
        // Assert
        System.assertEquals(0, comparables.size());
    }

    @isTest static void multipleComparableOpps() {
        // create opportunities that seem comparable
        // Create records: we need two comparable opps      
        // find opportunities then create junction object for each one
        Account acc = new Account();
        acc.Name = 'winterfell hotels';
        acc.Industry = 'hospitals';
        insert acc;

        List<Opportunity> compOppsList = new List<Opportunity>();
        Opportunity compOpp1 = new Opportunity();
        opp.Name = 'winterfell hotels';
        opp.AccountId = acc.Id;
        opp.Amount = 105;
        opp.StageName = 'Closed Won';
        opp.CloseDate = Date.today().addDays(-1);
        compOppsList.add(compOpp1);
        
        Opportunity compOpp1 = new Opportunity();
        opp.Name = 'winterfell hotels';
        opp.AccountId = acc.Id;
        opp.Amount = 95;
        opp.StageName = 'Closed Won';
        opp.CloseDate = Date.today().addDays(-100);
        compOppsList.add(compOpp2);
        
        insert compOppsList;

        Opportunity baseOpp = new Opportunity();
        baseOpp.Name = 'winterfell hotels';
        baseOpp.AccountId = acc.Id;
        baseOpp.Amount = 100;
        baseOpp.StageName = 'Prospecting';
        baseOpp.CloseDate = Date.today();
        insert baseOpp;

        // we're expecting our trigger to create two junction objects
        // one for each comparable opportunity
        // they should also be attached to the base opportunity
        // SORT by date to know the order in which your comparable opps appear
        List<Comparable__c> comparable = [SELECT Id,
                                                 Comparable_Opportunity__c 
                                            FROM Comparable__c 
                                            WHERE Base_Opportunity__c = :baseOpp.Id
                                            ORDER BY Comparable_Opportunity__r.CloseDate DESC];

        // Assertions
        System.assertEquals(compOpp1.Id, comparable.get(0).Comparable_Opportunity__c);
        System.assertEquals(compOpp1.Id, comparable.get(1).Comparable_Opportunity__c);
    }
}