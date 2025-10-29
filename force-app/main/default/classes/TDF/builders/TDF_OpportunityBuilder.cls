/**
 * @description Builder class for creating Opportunity test data with sensible defaults.
 *              Extends TDF_BaseBuilder to provide Opportunity-specific functionality
 *              including Record Type resolution support.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Simple Opportunity creation
 * Account acc = TDF_TestApi.createAccount();
 * Opportunity opp = TDF_Factory.generateOpportunity()
 *     .withAccount(acc)
 *     .insertRecord()
 *     .getInstance();
 * 
 * // Opportunity with Record Type and Contact
 * Contact con = TDF_TestApi.createContact(acc);
 * Opportunity opp = TDF_Factory.generateOpportunity()
 *     .withAccount(acc)
 *     .withPrimaryContact(con)
 *     .setRecordType('Sales_Opportunity')
 *     .add('Amount', 100000)
 *     .insertRecord()
 *     .getInstance();
 */
public with sharing class TDF_OpportunityBuilder extends TDF_BaseBuilder {
    
    /** @description Record Type resolver for handling Record Type lookups */
    private TDF_DefaultResolvers.RecordTypes rt;

    /**
     * @description Constructs a new Opportunity builder with default field values and Record Type support.
     *              Automatically applies any configured field defaults from Custom Metadata.
     * 
     * @param rt The Record Type resolver instance for Record Type lookups
     * 
     * @example
     * TDF_DefaultResolvers.RecordTypes rtResolver = new TDF_DefaultResolvers.RecordTypes();
     * TDF_OpportunityBuilder builder = new TDF_OpportunityBuilder(rtResolver);
     */
    public TDF_OpportunityBuilder(TDF_DefaultResolvers.RecordTypes rt) {
        this.rt = rt;
        
        // Create Opportunity with sensible defaults
        Opportunity o = new Opportunity();
        o.Name = 'TDF Opp ' + Crypto.getRandomInteger();
        o.StageName = 'Prospecting';
        o.CloseDate = System.today().addDays(30);
        o.Type = 'New Business';
        
        // Initialize the base builder
        init(o);
        
        // Apply any configured field defaults from Custom Metadata
        TDF_DefaultResolvers.applyFieldDefaults(record(), null);
    }

    /**
     * @description Fluent interface method for setting field values on the Opportunity.
     *              Provides a convenient alias to the base set() method.
     * 
     * @param api The API name of the field to set (e.g., 'Name', 'Amount')
     * @param v The value to assign to the field
     * @return TDF_OpportunityBuilder Returns this builder instance for method chaining
     * 
     * @example
     * TDF_OpportunityBuilder builder = new TDF_OpportunityBuilder(resolver)
     *     .add('Name', 'Big Deal')
     *     .add('Amount', 500000)
     *     .add('Probability', 75);
     */
    public TDF_OpportunityBuilder add(String api, Object v) {
        set(api, v);
        return this;
    }

    /**
     * @description Associates the Opportunity with the specified Account.
     *              Sets the AccountId field for the Opportunity relationship.
     * 
     * @param a The Account to associate this Opportunity with
     * @return TDF_OpportunityBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Account acc = TDF_TestApi.createAccount();
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .insertRecord()
     *     .getInstance();
     */
    public TDF_OpportunityBuilder withAccount(Account a) { 
        set('AccountId', a.Id); 
        return this; 
    }
    
    /**
     * @description Associates the Opportunity with the specified primary Contact.
     *              Sets the ContactId field for the Opportunity relationship.
     * 
     * @param c The Contact to set as the primary contact for this Opportunity
     * @return TDF_OpportunityBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Contact con = TDF_TestApi.createContact(acc);
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .withPrimaryContact(con)
     *     .insertRecord()
     *     .getInstance();
     */
    public TDF_OpportunityBuilder withPrimaryContact(Contact c) { 
        set('ContactId', c.Id); 
        return this; 
    }
    
    /**
     * @description Sets the Record Type for the Opportunity using name or developer name.
     *              Uses the configured Record Type resolver with fallback support.
     * 
     * @param nameOrDev The Record Type Name or DeveloperName to resolve
     * @return TDF_OpportunityBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .setRecordType('Sales_Opportunity')
     *     .insertRecord()
     *     .getInstance();
     */
    public TDF_OpportunityBuilder setRecordType(String nameOrDev) { 
        set('RecordTypeId', rt.resolve('Opportunity', nameOrDev)); 
        return this; 
    }

    /**
     * @description Retrieves the built Opportunity instance as a typed object.
     *              Casts the generic SObject from the base builder to an Opportunity.
     * 
     * @return Opportunity The Opportunity instance that has been configured by this builder
     * 
     * @example
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .add('Amount', 100000)
     *     .getInstance();
     */
    public Opportunity getInstance() {
        return (Opportunity) get();
    }
    
    /**
     * @description Convenience method to insert the Opportunity record and continue chaining.
     *              Provides a fluent interface alias for the insertRecord() method.
     * 
     * @return TDF_OpportunityBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .add('Amount', 100000)
     *     .insertRec()
     *     .getInstance();
     */
    public TDF_OpportunityBuilder insertRec() {
        insertRecord();
        return this;
    }
}
