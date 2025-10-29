/**
 * @description Builder class for creating Account test data with sensible defaults.
 *              Extends TDF_BaseBuilder to provide Account-specific functionality
 *              while maintaining the fluent interface pattern.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Simple Account creation
 * Account acc = TDF_Factory.generateAccount()
 *     .insertRec()
 *     .getInstance();
 * 
 * // Account with custom values
 * Account acc = TDF_Factory.generateAccount()
 *     .add('Name', 'Acme Corporation')
 *     .add('Industry', 'Technology')
 *     .add('AnnualRevenue', 1000000)
 *     .insertRec()
 *     .getInstance();
 */
public with sharing class TDF_AccountBuilder extends TDF_BaseBuilder {
    
    /**
     * @description Constructs a new Account builder with default field values.
     *              Automatically applies any configured field defaults from Custom Metadata.
     * 
     * @example
     * TDF_AccountBuilder builder = new TDF_AccountBuilder();
     */
    public TDF_AccountBuilder() {
        // Create Account with sensible defaults
        Account a = new Account();
        a.Name = 'TDF Acc ' + String.valueOf(Crypto.getRandomInteger());
        a.Type = 'Prospect';
        
        // Initialize the base builder
        init(a);
        
        // Apply any configured field defaults from Custom Metadata
        TDF_DefaultResolvers.applyFieldDefaults(record(), null);
    }

    /**
     * @description Fluent interface method for setting field values on the Account.
     *              Provides a convenient alias to the base set() method.
     * 
     * @param api The API name of the field to set (e.g., 'Name', 'Industry')
     * @param v The value to assign to the field
     * @return TDF_AccountBuilder Returns this builder instance for method chaining
     * 
     * @example
     * TDF_AccountBuilder builder = new TDF_AccountBuilder()
     *     .add('Name', 'Test Company')
     *     .add('Phone', '(555) 123-4567')
     *     .add('Website', 'https://example.com');
     */
    public TDF_AccountBuilder add(String api, Object v) {
        set(api, v);
        return this;
    }

    /**
     * @description Marks this builder to insert the Account record when getInstance() is called.
     *              Provides a convenient fluent interface method.
     * 
     * @return TDF_AccountBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Account acc = TDF_Factory.generateAccount()
     *     .add('Name', 'Test Account')
     *     .insertRec()
     *     .getInstance();
     */
    public TDF_AccountBuilder insertRec() {
        insertRecord();
        return this;
    }

    /**
     * @description Retrieves the built Account record.
     *              If insertRec() was called, the record will be inserted into the database.
     * 
     * @return Account The built Account record (inserted if insertRec() was called)
     * 
     * @example
     * // Get Account without inserting
     * Account acc = builder.getInstance();
     * 
     * // Get Account and insert it
     * Account acc = builder.insertRec().getInstance();
     */
    public Account getInstance() {
        SObject s = get();
        return (Account) s;
    }
}
