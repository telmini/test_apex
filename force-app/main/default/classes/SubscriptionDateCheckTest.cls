@isTest
private class SubscriptionDateCheckTest {

    
    
    private static final String PARENT_BUNDLE = 'Conformité Parent Bundle';
    private static final String PUB = 'Conformité Pub ';
    private static final String CONFORME = 'Conforme';
    private static final String CREATED = 'Created';
    private static final String MODE = 'Fashion';
    private static final String SSII = 'JobServiceCompany';
    private static final String MME = 'Ms';
    private static final String MANUEL = 'Manuel';
    
    @isTest
    private static void testConformite() {
        Account compte = Account_DataFactory.createAccount('compte_1', '+33 6 00 00 00 00', '37915832200097');
        compte.Segmentation__c = SSII;
        compte.CompanyIndustry__c = 'Beauty';
        compte.BillingCountry = 'France';
        compte.BillingCity = 'city';
        compte.BillingState = 'Île-de-France';
        compte.BillingPostalCode = '93600';
        compte.BillingStreet = 'street';
        UPDATE compte;

        Acces_beneficiaire__c benef1 = AccesBeneficiaire_DataFactory.createBeneficiaire('benef_1', compte.Id, 'test1@lbc.fr', CREATED);
        benef1.AccessUserId__c = 'OUAH';
        benef1.AccessStoreId__c = 'OUAH';
        benef1.AccessCategory__c = MODE;
        benef1.Segmentation__c = SSII;
        benef1.AccessSalutation__c = MME;
        benef1.AccessFirstname__c = 'Mimmi';
        benef1.AccessLastname__c = 'Montey';
        benef1.AccessAddressStreet__c = '11 nowhere';
        benef1.AccessCategory__c = 'RealEstate';
        benef1.AccessAddressCountry__c = 'FR';
        benef1.AccessAddressCity__c = 'city';
        benef1.AccessAddressZipcode__c = '22000';
        UPDATE benef1;

        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        SBQQ__Subscription__c parent = new SBQQ__Subscription__c(
            SBQQ__Quantity__c = 5, ComplianceProcess__c = PARENT_BUNDLE);
        INSERT parent;


        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, ComplianceProcess__c = PUB, FlowType__c = 'Manuel', EffectiveEndDate__c = date.today().addDays(-3),
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, BeneficiaryAccount__c = compte.Id));

        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, ComplianceProcess__c = PUB, FlowType__c = 'Manuel', EffectiveEndDate__c = date.today().addDays(-3),
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, SBQQ__RequiredById__c = parent.Id, BeneficiaryAccount__c = compte.Id));

        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, ComplianceProcess__c = PUB, FlowType__c = 'Manuel', EffectiveEndDate__c = date.today().addDays(5),
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, BeneficiaryAccount__c = compte.Id));

        subs.add(new SBQQ__Subscription__c(SBQQ__Quantity__c = 5, ComplianceProcess__c = PUB, FlowType__c = 'Manuel',EffectiveEndDate__c = date.today().addDays(5),
                                             ProductWorkflow__c = 'yeah', BeneficiaryAccess__c = benef1.Id, SBQQ__RequiredById__c = parent.Id, BeneficiaryAccount__c = compte.Id));


        INSERT subs;
        
        SubscriptionDateCheck batch = new SubscriptionDateCheck();
        
		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();
        
        //System.assertNotEquals(0,[SELECT Id FROM SBQQ__Subscription__c WHERE Souscription_Conforme__c = true].size());
        System.assert([SELECT Souscription_Conforme__c FROM SBQQ__Subscription__c WHERE Id = :parent.Id ].Souscription_Conforme__c);
    }
}