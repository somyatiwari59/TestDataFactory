/**
 * @description Central factory class for creating Test Data Factory (TDF) builders.
 *              Provides a single entry point for generating test data builders for various SObject types.
 *              Manages shared resolver instances and exposes utility methods for metadata resolution.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Create test data using fluent interface
 * Account acc = TDF_Factory.generateAccount()
 *     .set('Name', 'Test Account')
 *     .insertRecord()
 *     .getInstance();
 * 
 * // Create related records
 * Opportunity opp = TDF_Factory.generateOpportunity()
 *     .withAccount(acc)
 *     .insertRecord()
 *     .getInstance();
 */
public with sharing class TDF_Factory {
    
    /** @description Shared Record Type resolver instance for efficient caching across builders */
    private static TDF_DefaultResolvers.RecordTypes rt = new TDF_DefaultResolvers.RecordTypes();

    /**
     * @description Creates a new Account builder with sensible defaults.
     * 
     * @return TDF_AccountBuilder A new Account builder instance
     * 
     * @example
     * Account acc = TDF_Factory.generateAccount()
     *     .set('Industry', 'Technology')
     *     .insertRecord()
     *     .getInstance();
     */
    public static TDF_AccountBuilder generateAccount() { 
        return new TDF_AccountBuilder(); 
    }
    
    /**
     * @description Creates a new Contact builder with sensible defaults.
     * 
     * @return TDF_ContactBuilder A new Contact builder instance
     * 
     * @example
     * Contact con = TDF_Factory.generateContact()
     *     .withAccount(acc)
     *     .set('Email', 'test@example.com')
     *     .insertRecord()
     *     .getInstance();
     */
    public static TDF_ContactBuilder generateContact() { 
        return new TDF_ContactBuilder(); 
    }
    
    /**
     * @description Creates a new Opportunity builder with Record Type resolution support.
     * 
     * @return TDF_OpportunityBuilder A new Opportunity builder instance with resolver support
     * 
     * @example
     * Opportunity opp = TDF_Factory.generateOpportunity()
     *     .withAccount(acc)
     *     .setRecordType('Sales_Opportunity')
     *     .insertRecord()
     *     .getInstance();
     */
    public static TDF_OpportunityBuilder generateOpportunity() { 
        return new TDF_OpportunityBuilder(rt); 
    }
    
    /**
     * @description Creates a generic SObject builder for any SObject type.
     *              Useful for creating records of types not covered by specific builders.
     * 
     * @param api The SObject API name (e.g., 'Custom_Object__c')
     * @return TDF_SObjectBuilder A generic SObject builder instance
     * 
     * @example
     * SObject customObj = TDF_Factory.generateSObject('Custom_Object__c')
     *     .set('Name', 'Test Custom Object')
     *     .insertRecord()
     *     .getInstance();
     */
    public static TDF_SObjectBuilder generateSObject(String api) { 
        return new TDF_SObjectBuilder(api); 
    }

    /**
     * @description Utility method to resolve Record Type IDs directly.
     *              Useful when you need Record Type IDs outside of the builder pattern.
     * 
     * @param sObj The SObject API name (e.g., 'Account', 'Opportunity')
     * @param nameOrDev The Record Type Name or DeveloperName to resolve
     * @return Id The Record Type ID
     * 
     * @example
     * Id accountRTId = TDF_Factory.recordTypeId('Account', 'Business');
     * Id oppRTId = TDF_Factory.recordTypeId('Opportunity', 'Sales_Opportunity');
     */
    public static Id recordTypeId(String sObj, String nameOrDev) { 
        return rt.resolve(sObj, nameOrDev); 
    }
}
