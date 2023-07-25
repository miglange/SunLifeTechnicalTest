import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFinanceServicesAccount from '@salesforce/apex/FinanceServicesAccountController.getFinanceServicesAccounts';

export default class FinancialServicesAccountList extends NavigationMixin(LightningElement) {

    @api recordId;
    @track accountList = [];
    @track accountNameFilter = '';
    @track sortBy = 'AccountName';
    sortOptions = [
        { label: 'Account Name', value: 'AccountName' },
        { label: 'Account Owner', value: 'AccountOwner' }
    ];

    // Fetch Account records on component initialization
    connectedCallback() {
        this.fetchAccounts();
    }

    // Fetch Account records based on the filter and sorting options
    fetchAccounts() {
        getFinanceServicesAccount({ accountNameFilter: this.accountNameFilter, sortBy: this.sortBy })
            .then(result => {
                this.accountList = result;
            })
            .catch(error => {
                // Handle error or display a toast message
            });
    }

    // Handle filter change
    handleFilterChange(event) {
        this.accountNameFilter = event.target.value;
        this.fetchAccounts();
    }

    // Handle sort change
    handleSortChange(event) {
        this.sortBy = event.detail.value;
        this.fetchAccounts();
    }

    // Handle sorting by Account Name
    handleSortByAccountName() {
        this.sortBy = 'AccountName';
        this.fetchAccounts();
    }

    // Handle sorting by Account Owner
    handleSortByAccountOwner() {
        this.sortBy = 'AccountOwner';
        this.fetchAccounts();
    }

    // Handle Account Name click to navigate to the detail record page
    handleAccountClick(event) {
        event.stopPropagation();
        const accountId = event.target.closest('tr').dataset.accountId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                actionName: 'view'
            }
        }, { target: '_blank' });
    }
}