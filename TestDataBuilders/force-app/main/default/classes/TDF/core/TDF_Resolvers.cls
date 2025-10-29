/**
 * @description Interface definitions for resolving various types of Salesforce metadata IDs.
 *              These interfaces provide a contract for resolving human-readable names
 *              to Salesforce IDs, enabling flexible and maintainable test data creation.
 * 
 * @author Somya Tiwari
 * @since 1.0
 * 
 * @example
 * // Implement a custom resolver
 * public class CustomRecordTypeResolver implements TDF_Resolvers.RecordTypeResolver {
 *     public Id resolve(String sObj, String nameOrDev) {
 *         // Custom resolution logic
 *         return recordTypeId;
 *     }
 * }
 */
public class TDF_Resolvers {
    
    /**
     * @description Interface for resolving Record Type IDs from SObject type and Record Type name/developer name.
     *              Implementations should handle both Name and DeveloperName lookups with appropriate fallbacks.
     */
    public interface RecordTypeResolver { 
        /**
         * @description Resolves a Record Type ID from SObject type and Record Type identifier.
         * 
         * @param sObj The SObject API name (e.g., 'Account', 'Opportunity')
         * @param nameOrDev The Record Type Name or DeveloperName to resolve
         * @return Id The Record Type ID, or null if not found
         * 
         * @example
         * Id rtId = resolver.resolve('Account', 'Business');
         * Id rtId = resolver.resolve('Opportunity', 'Sales_Opportunity');
         */
        Id resolve(String sObj, String nameOrDev); 
    }
    
    /**
     * @description Interface for resolving Queue IDs from queue names.
     *              Implementations should handle queue name mapping and caching for performance.
     */
    public interface QueueResolver { 
        /**
         * @description Resolves a Queue ID from the queue name.
         * 
         * @param queueName The name of the queue to resolve
         * @return Id The Queue ID (Group.Id where Type = 'Queue')
         * 
         * @example
         * Id queueId = resolver.resolve('Customer Support');
         * Id queueId = resolver.resolve('Sales Team');
         */
        Id resolve(String queueName); 
    }
    
    /**
     * @description Interface for resolving Pricebook IDs from pricebook names.
     *              Implementations should handle standard pricebook detection and custom pricebook lookups.
     */
    public interface PricebookResolver { 
        /**
         * @description Resolves a Pricebook ID from the pricebook name.
         * 
         * @param pricebookName The name of the pricebook to resolve, or null for standard pricebook
         * @return Id The Pricebook2 ID
         * 
         * @example
         * Id stdPricebook = resolver.resolve(null); // Standard pricebook
         * Id customPricebook = resolver.resolve('Enterprise Price Book');
         */
        Id resolve(String pricebookName); 
    }
    
    /**
     * @description Interface for resolving User IDs from usernames or aliases.
     *              Implementations should handle username and alias lookups with appropriate error handling.
     */
    public interface UserResolver { 
        /**
         * @description Resolves a User ID from username or alias.
         * 
         * @param usernameOrAlias The username or alias of the user to resolve
         * @return Id The User ID
         * 
         * @example
         * Id userId = resolver.resolve('admin@company.com');
         * Id userId = resolver.resolve('SalesUser');
         */
        Id resolve(String usernameOrAlias); 
    }
}