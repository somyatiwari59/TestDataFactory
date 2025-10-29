/**
 * @description Generic SObject builder for creating test data of any SObject type.
 *              Provides a flexible builder pattern for SObject types that don't have
 *              dedicated builder classes in the TDF framework.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Create a custom object record
 * Custom_Object__c customObj = (Custom_Object__c) TDF_Factory.generateSObject('Custom_Object__c')
 *     .add('Name', 'Test Custom Object')
 *     .add('Custom_Field__c', 'Custom Value')
 *     .insertRecord()
 *     .getInstance();
 * 
 * // Create any standard object
 * Task task = (Task) TDF_Factory.generateSObject('Task')
 *     .add('Subject', 'Test Task')
 *     .add('Status', 'Not Started')
 *     .insertRecord()
 *     .getInstance();
 */
public with sharing class TDF_SObjectBuilder extends TDF_BaseBuilder {
    
    /**
     * @description Constructs a generic SObject builder for the specified object type.
     *              Validates that the SObject type exists and initializes a new record instance.
     * 
     * @param objectApiName The API name of the SObject type to create (e.g., 'Account', 'Custom_Object__c')
     * @throws IllegalArgumentException if the SObject type is not found
     * 
     * @example
     * TDF_SObjectBuilder builder = new TDF_SObjectBuilder('Custom_Object__c');
     */
    public TDF_SObjectBuilder(String objectApiName) {
        // Validate that the SObject type exists in the org
        Schema.SObjectType t = Schema.getGlobalDescribe().get(objectApiName);
        if (t == null) {
            throw new IllegalArgumentException('Unknown sObject type: ' + objectApiName);
        }
        
        // Initialize the builder with a new SObject instance
        // The 'true' parameter preserves read-only fields in describe calls
        init(t.newSObject(null, true));
    }

    /**
     * @description Fluent interface method for setting field values on the SObject.
     *              This method provides an alias to the base 'set' method with return type coercion.
     * 
     * @param api The API name of the field to set (e.g., 'Name', 'Custom_Field__c')
     * @param val The value to assign to the field
     * @return TDF_SObjectBuilder Returns this builder instance for method chaining
     * 
     * @example
     * TDF_SObjectBuilder builder = new TDF_SObjectBuilder('Custom_Object__c')
     *     .add('Name', 'Test Object')
     *     .add('Number_Field__c', 100)
     *     .add('Date_Field__c', Date.today());
     */
    public TDF_SObjectBuilder add(String api, Object val) {
        set(api, val);
        return this;
    }

    /**
     * @description Retrieves the built SObject instance.
     *              If insertRecord() was called, the record will be inserted into the database.
     * 
     * @return SObject The built SObject record (inserted if insertRecord() was called)
     * 
     * @example
     * // Get record without inserting
     * SObject obj = builder.getInstance();
     * 
     * // Get record and insert it
     * SObject obj = builder.insertRecord().getInstance();
     * 
     * // Cast to specific type
     * Custom_Object__c customObj = (Custom_Object__c) builder.getInstance();
     */
    public SObject getInstance() {
        return (SObject) get();
    }
}
