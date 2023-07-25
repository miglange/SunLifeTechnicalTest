/**
 *Salesforce Technical test
 *Company: SunLife
 *Author: Miglange Fogaing
 *FinanceServicesAccountController apex class that query account with industry ="Financial Services"
 * filter the result by account name and sort it by account owner
 */

public with sharing class FinanceServicesAccountController {
    @AuraEnabled
    public static List<Account> getFinanceServicesAccounts(String accountNameFilter, String sortBy) {
        String vListAcct = 'SELECT Name, Owner.Name, Phone, Website, AnnualRevenue FROM Account WHERE Industry = \'Financial Services\'';

        if (String.isNotBlank(accountNameFilter)) {
            vListAcct += ' AND Name LIKE \'%' + String.escapeSingleQuotes(accountNameFilter) + '%\'';
        }

        if (sortBy == 'AccountName') {
            vListAcct += ' ORDER BY Name';
        } else if (sortBy == 'AccountOwner') {
            vListAcct += ' ORDER BY Owner.Name';
        }

        return Database.query(vListAcct);
    }
    
    // method used to update Account field
    @AuraEnabled
    public static void updateAccountField(String recordId, String fieldName, String fieldValue) {
        // Get the SObjectType of the Account
        SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        // Get the fields map for the Account
        Map<String, SObjectField> accountFieldsMap = accountType.getDescribe().fields.getMap();

        // Check if the field is editable for the user
        if (accountFieldsMap.containsKey(fieldName) && accountFieldsMap.get(fieldName).getDescribe().isUpdateable()) {
            Account accountToUpdate = new Account(Id = recordId);
            accountToUpdate.put(fieldName, fieldValue);
            update accountToUpdate;
        } else {
            throw new AuraHandledException('No permission to edit this field.');
        }
    }
}