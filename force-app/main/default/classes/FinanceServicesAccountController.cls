public with sharing class FinanceServicesAccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getFinanceServicesAccounts(String accountNameFilter, String sortBy) {
        String soqlQuery = 'SELECT Name, Owner.Name, Phone, Website, AnnualRevenue FROM Account WHERE Industry = \'Financial Services\'';

        if (String.isNotBlank(accountNameFilter)) {
            soqlQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(accountNameFilter) + '%\'';
        }

        if (sortBy == 'AccountName') {
            soqlQuery += ' ORDER BY Name';
        } else if (sortBy == 'AccountOwner') {
            soqlQuery += ' ORDER BY Owner.Name';
        }

        return Database.query(soqlQuery);
    }
}