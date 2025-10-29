## Apex Test Data Builders (TDF)

Small, fast, fluent builders for Salesforce Apex tests. Create Accounts, Contacts, and Opportunities with one or two lines — with sensible defaults and easy overrides.

### Why use it
- Fluent builder API for readable tests
- Sensible defaults (no need to set every field)
- Relationships made easy (Account → Contact → Opportunity)
- Record Type name-to-Id resolution (via resolvers)
- Customizable defaults via Custom Metadata

### Install
```bash
sf project deploy start
```

### Quick examples
```apex
// Account
Account a = TDF_Factory.generateAccount()
  .add('Industry', 'Technology')
  .insertRecord()
  .getInstance();

// Contact related to Account
Contact c = TDF_Factory.generateContact()
  .withAccount(a)
  .insertRecord()
  .getInstance();

// Opportunity with minimal fields
Opportunity o = TDF_Factory.generateOpportunity()
  .withAccount(a)
  .add('StageName', 'Prospecting')
  .insertRecord()
  .getInstance();
```

### What’s in the box
- Builders: `TDF_AccountBuilder`, `TDF_ContactBuilder`, `TDF_OpportunityBuilder`
- Core: `TDF_BaseBuilder`, `TDF_SObjectBuilder`, `TDF_Factory`, `TDF_Resolvers`, `TDF_DefaultResolvers`
- Tests: `TDF_Examples`
- Custom Metadata: `TDF_Field_Default__mdt` for field defaults

### Configure defaults (Custom Metadata)
Add records to `TDF_Field_Default__mdt`:
- `SObject__c`: e.g., `Account`
- `FieldApiName__c`: e.g., `Industry`
- `Value__c`: e.g., `Technology`
- Optional: `RecordTypeDevName__c`, `DataType__c`

### Record Types
Resolve by name when setting Record Type:
```apex
Id rtId = TDF_Factory.recordTypeId('Opportunity', 'Enterprise_Sale');
```

### Run example tests
```bash
sf apex run test --class-names TDF_Examples
```

---
MIT License • Maintainer: Somya Tiwari