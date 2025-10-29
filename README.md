# Apex Fluent Test Data Builders

Fluent, composable Apex builders for fast, readable tests — with pluggable resolvers so it works in **any** org.

## Quick start
1) Clone, open in VS Code, and deploy `force-app`.
2) (Optional) Edit `staticresources/tdf_config.resource` to map record types / queues by names your org uses.
3) Use it:

```apex
@isTest
private class MySpec {
  @isTest static void createsOppFast() {
    Account a = TDF_Factory.generateAccount().insertRecord().getInstance();
    Contact c = TDF_Factory.generateContact().withAccount(a).insertRecord().getInstance();
    Opportunity o = TDF_Factory.generateOpportunity()
      .withAccount(a)
      .withContact(c)
      .addCustomFieldValue('StageName', 'Prospecting')
      .insertRecord()
      .getInstance();
    System.assertNotEquals(null, o.Id);
  }
}
