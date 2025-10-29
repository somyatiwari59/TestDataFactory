/**
 * @description Abstract base class for all Test Data Factory (TDF) builders.
 *              Provides common functionality for creating and manipulating SObject records
 *              in a fluent interface pattern for test data creation.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Extend this class to create specific object builders
 * public class TDF_AccountBuilder extends TDF_BaseBuilder {
 *     public TDF_AccountBuilder() {
 *         Account acc = new Account(Name = 'Test Account');
 *         init(acc);
 *     }
 * }
 */
public abstract with sharing class TDF_BaseBuilder {
    
    /** @description The SObject record being built by this builder instance */
    private SObject rec;
    
    /** @description Flag indicating whether to insert the record when getInstance() is called */
    protected Boolean doInsert = false;
    
    /**
     * @description Initializes the builder with an SObject instance.
     *              This method should be called in the constructor of concrete builder classes.
     * 
     * @param sobj The SObject record to be managed by this builder
     * @return TDF_BaseBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Account acc = new Account(Name = 'Test Account');
     * init(acc);
     */
    protected TDF_BaseBuilder init(SObject sobj) {
        this.rec = sobj;
        return this;
    }
    
    /**
     * @description Provides access to the underlying SObject record.
     *              Used internally by concrete builders when direct record access is needed.
     * 
     * @return SObject The underlying SObject record being built
     */
    protected SObject record() {
        return this.rec;
    }
    
    /**
     * @description Sets a field value on the underlying SObject record using dynamic field assignment.
     *              This is the primary method for setting field values in builder pattern.
     * 
     * @param apiName The API name of the field to set (e.g., 'Name', 'Email__c')
     * @param value The value to assign to the field
     * @return TDF_BaseBuilder Returns this builder instance for method chaining
     * 
     * @example
     * set('Name', 'Acme Corporation');
     * set('Industry', 'Technology');
     */
    public TDF_BaseBuilder set(String apiName, Object value) {
        this.rec.put(apiName, value);
        return this;
    }
    
    /**
     * @description Marks this builder to insert the record when get() is called.
     *              This enables the fluent interface pattern for record creation.
     * 
     * @return TDF_BaseBuilder Returns this builder instance for method chaining
     * 
     * @example
     * Account acc = TDF_Factory.generateAccount()
     *     .set('Name', 'Test Account')
     *     .insertRecord()
     *     .getInstance();
     */
    public TDF_BaseBuilder insertRecord() {
        this.doInsert = true;
        return this;
    }
    
    /**
     * @description Retrieves the built SObject record.
     *              If insertRecord() was called, the record will be inserted into the database.
     *              Otherwise, returns the record without inserting it.
     * 
     * @return SObject The built SObject record (inserted if insertRecord() was called)
     * 
     * @example
     * // Get record without inserting
     * Account acc = builder.get();
     * 
     * // Get record and insert it
     * Account acc = builder.insertRecord().get();
     */
    protected SObject get() {
        if (doInsert) {
            insert this.rec;
        }
        return this.rec;
    }
}
