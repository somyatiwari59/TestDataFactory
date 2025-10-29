/**
 * @description Default implementations of resolver interfaces for the Test Data Factory framework.
 *              Provides concrete implementations for resolving Record Types, Queues, and Pricebooks
 *              with caching, and configuration-driven defaults.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * TDF_DefaultResolvers.RecordTypes rtResolver = new TDF_DefaultResolvers.RecordTypes();
 * Id accountRTId = rtResolver.resolve('Account', 'Business');
 */
public with sharing class TDF_DefaultResolvers {
    
    /**
     * @description Default implementation of RecordTypeResolver with caching support.
     *              Attempts to resolve Record Types by DeveloperName first, then by Name.
     */
    public class RecordTypes implements TDF_Resolvers.RecordTypeResolver {
        
        /** @description Cache to store resolved Record Type IDs for performance */
        private Map<String, Id> cache = new Map<String, Id>();
        
        /**
         * @description Resolves a Record Type ID; Uses caching to improve performance for repeated lookups.
         * 
         * @param sObj The SObject API name (e.g., 'Account', 'Opportunity')
         * @param nameOrDev The Record Type Name or DeveloperName to resolve
         * @return Id The Record Type ID
         * @throws IllegalArgumentException if SObject type or Record Type not found
         * 
         * @example
         * RecordTypes resolver = new RecordTypes();
         * Id rtId = resolver.resolve('Account', 'Business_Account');
         */
        public Id resolve(String sObj, String nameOrDev) {
            // Check cache first for performance
            String key = sObj + '#' + nameOrDev;
            if (cache.containsKey(key)) return cache.get(key);

            // Validate SObject type exists
            Schema.SObjectType t = Schema.getGlobalDescribe().get(sObj);
            if (t == null) throw new IllegalArgumentException('Unknown sObject: ' + sObj);

            // Get Record Type information
            Schema.DescribeSObjectResult d = t.getDescribe();
            
            // Try DeveloperName first, then Name
            Schema.RecordTypeInfo rti = d.getRecordTypeInfosByDeveloperName().get(nameOrDev);
            if (rti == null) rti = d.getRecordTypeInfosByName().get(nameOrDev);
            
            // Throw exception if still not found
            if (rti == null) {
                throw new IllegalArgumentException('RecordType not found: ' + sObj + ' → ' + nameOrDev);
            }
            
            // Cache and return the result
            cache.put(key, rti.getRecordTypeId());
            return rti.getRecordTypeId();
        }
    }
    
    /**
     * @description Applies field defaults from Custom Metadata to SObject records.
     *              Supports Record Type-specific defaults and data type conversion.
     * 
     * @param s The SObject record to apply defaults to
     * @param rtDevNameOrNull The Record Type DeveloperName for RT-specific defaults, or null
     * 
     * @example
     * Account acc = new Account();
     * TDF_DefaultResolvers.applyFieldDefaults(acc, 'Business_Account');
     */
    public static void applyFieldDefaults(SObject s, String rtDevNameOrNull) {
        String sObj = String.valueOf(s.getSObjectType());
        
        // Query field defaults from Custom Metadata
        List<TDF_Field_Default__mdt> rows = [
            SELECT FieldApiName__c, Value__c, DataType__c, RecordTypeDevName__c
            FROM TDF_Field_Default__mdt
            WHERE SObject__c = :sObj
              AND (RecordTypeDevName__c = :rtDevNameOrNull OR RecordTypeDevName__c = null)
        ];
        
        // Apply each default value with proper type conversion
        for (TDF_Field_Default__mdt r : rows) {
            Object v = coerce(r.Value__c, r.DataType__c);
            s.put(r.FieldApiName__c, v);
        }
    }

    /**
     * @description Converts string values to appropriate data types based on type name.
     *              Supports common Salesforce field types with proper conversion.
     * 
     * @param val The string value to convert
     * @param typeName The target data type name
     * @return Object The converted value in the appropriate type
     * 
     * @example
     * Object numValue = coerce('100', 'Number'); // Returns Decimal 100
     * Object boolValue = coerce('true', 'Checkbox'); // Returns Boolean true
     */
    private static Object coerce(String val, String typeName) {
        switch on typeName {
            when 'Text'      { return val; }
            when 'Picklist'  { return val; }
            when 'Number'    { return Decimal.valueOf(val); }
            when 'Checkbox'  { return (val == 'true'); }
            when 'Date'      { return Date.valueOf(val); }
            when 'DateTime'  { return DateTime.valueOf(val); }
            when else        { return val; }
        }
    }
}
