@IsTest
private class TDF_Examples {
  @IsTest static void minimal_flow() {
    Account a = TDF_Factory.generateAccount().insertRec().getInstance();
    Opportunity o = TDF_Factory.generateOpportunity().withAccount(a).insertRec().getInstance();
    System.assertNotEquals(null, o.Id);
  }

  @IsTest static void override_recordtype_via_config() {
    Opportunity o = TDF_Factory.generateOpportunity()
      .setRecordType('DoesNotExistButWillFallback')
      .insertRec()
      .getInstance();
  }
}
