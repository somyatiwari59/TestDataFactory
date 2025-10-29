/**
 * @description Builder class for creating Contact test data with sensible defaults.
 *              Extends TDF_BaseBuilder to provide Contact-specific functionality
 *              while maintaining the fluent interface pattern.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Simple Contact creation
 * Contact con = TDF_Factory.generateContact()
 *     .insertRecord()
 *     .getInstance();
 * 
 * // Contact with Account relationship
 * Account acc = TDF_TestApi.createAccount();
 * Contact con = TDF_Factory.generateContact()
 *     .withAccount(acc)
 *     .add('Title', 'Senior Manager')
 *     .insertRecord()
 *     .getInstance();
 */
public with sharing class TDF_ContactBuilder extends TDF_BaseBuilder{
    
    /**
     * @description Constructs a new Contact builder with default field values.
     *              Automatically applies any configured field defaults from Custom Metadata.
     * 
     * @example
     * TDF_ContactBuilder builder = new TDF_ContactBuilder();
     */
    public TDF_ContactBuilder() {
        Integer randomNum = Crypto.getRandomInteger();
        
        // Create Contact with sensible defaults
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact ' + randomNum;
        c.Email = 'test.contact' + randomNum + '@example.com';
        c.Phone = '(555) 123-' + String.valueOf(randomNum).substring(0, 4);
        c.Title = 'Test Manager';
        c.Department = 'Sales';
        c.LeadSource = 'Web';
        c.MailingStreet = '456 Contact Ave';
        c.MailingCity = 'San Francisco';
        c.MailingState = 'CA';
        c.MailingPostalCode = '94105';
        c.MailingCountry = 'USA';
        
        // Initialize the base builder
        init(c);
        
        // Apply any configured field defaults from Custom Metadata
        TDF_DefaultResolvers.applyFieldDefaults(record(), null);
    }
    
    /**
     * @description Fluent interface method for setting field values on the Contact.
     *              Provides a convenient alias to the base set() method.
     * 
     * @param api The API name of the field to set (e.g., 'FirstName', 'Email')
     * @param v The value to assign to the field
     * @return TDF_ContactBuilder Returns this builder instance for method chaining
     * 
     * @example
     * TDF_ContactBuilder builder = new TDF_ContactBuilder()
     *     .add('FirstName', 'John')
     *     .add('LastName', 'Doe')
     *     .add('Email', 'john.doe@example.com');
     */
    public TDF_ContactBuilder add(String api, Object v) {
        set(api, v);
        return this;
    }
    
    /**
     * @description Associates the Contact with the specified Account.
     *              Sets the AccountId field for the Contact relationship.
     * 
     * @param account The Account to associate this Contact with
     * @return TDF_ContactBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Account acc = TDF_TestApi.createAccount();
     * Contact con = TDF_Factory.generateContact()
     *     .withAccount(acc)
     *     .insertRecord()
     *     .getInstance();
     */
    public TDF_ContactBuilder withAccount(Account account) {
        set('AccountId', account.Id);
        return this;
    }
    
    public TDF_ContactBuilder withFirstName(String firstName) {
        set('FirstName', firstName);
        return this;
    }
    
    public TDF_ContactBuilder withLastName(String lastName) {
        set('LastName', lastName);
        return this;
    }
    
    public TDF_ContactBuilder withEmail(String email) {
        set('Email', email);
        return this;
    }
    
    public TDF_ContactBuilder withPhone(String phone) {
        set('Phone', phone);
        return this;
    }
    
    public TDF_ContactBuilder withTitle(String title) {
        set('Title', title);
        return this;
    }
    
    public TDF_ContactBuilder withDepartment(String department) {
        set('Department', department);
        return this;
    }
    
    public TDF_ContactBuilder withLeadSource(String leadSource) {
        set('LeadSource', leadSource);
        return this;
    }
    
    public TDF_ContactBuilder withMailingAddress(String street, String city, String state, String postalCode, String country) {
        set('MailingStreet', street);
        set('MailingCity', city);
        set('MailingState', state);
        set('MailingPostalCode', postalCode);
        set('MailingCountry', country);
        return this;
    }
    
    public TDF_ContactBuilder withOtherAddress(String street, String city, String state, String postalCode, String country) {
        set('OtherStreet', street);
        set('OtherCity', city);
        set('OtherState', state);
        set('OtherPostalCode', postalCode);
        set('OtherCountry', country);
        return this;
    }
    
    public TDF_ContactBuilder withBirthdate(Date birthdate) {
        set('Birthdate', birthdate);
        return this;
    }
    
    public TDF_ContactBuilder withReportsTo(Contact manager) {
        set('ReportsToId', manager.Id);
        return this;
    }
    
    public TDF_ContactBuilder withOwner(User owner) {
        set('OwnerId', owner.Id);
        return this;
    }

    /**
     * @description Marks this builder to insert the Contact record when getInstance() is called.
     *              Provides a convenient fluent interface method.
     * 
     * @return TDF_ContactBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Contact con = TDF_Factory.generateContact()
     *     .withAccount(acc)
     *     .insertRec()
     *     .getInstance();
     */
    public TDF_ContactBuilder insertRec() {
        insertRecord();
        return this;
    }

    /**
     * @description Retrieves the built Contact record.
     *              If insertRec() was called, the record will be inserted into the database.
     * 
     * @return Contact The built Contact record (inserted if insertRec() was called)
     * 
     * @example
     * // Get Contact without inserting
     * Contact con = builder.getInstance();
     * 
     * // Get Contact and insert it
     * Contact con = builder.insertRec().getInstance();
     */
    public Contact getInstance() {
        return (Contact) get();
    }
}