
public with sharing class SubscriptionsUtil {
		
    public static string checkMissingInfo (SBQQ__Subscription__c sub) {
        
        String result ='/';
        Set<String> fieldNames = new Set<String>('PromoterDescription__c','FlowType__c','ContractEmail__c','ProductWorkflow__c',
                                'CompanySiret__c','CompanyName__c',',CompanyAddressStreet__c',
                                'CompanyAddressZipcode__c','CompanyAddressCity__c','CompanyPhone__c',
                                'ContactGender__c','ContactFirstName__c','ContactLastName__c','LeadPhone__c');
		
		if(sub.ComplianceProcess__c == 'Conformité Pub'){
			result+=sub.EffectiveEndDate__c.getDescribe().getLabel();
		} else if((sub.ComplianceProcess__c =='Conformité Immo neuf'){
            for (string fieldName : fieldNames) {
                result+=getLabelField(sub,fieldName);
            }
        }
        return result;
    }
	
    public static string getLabelField (SBQQ__Subscription__c sub, string fieldName) {
        
        if(sub.string.valueof(fieldName) == null){
				 return sub.string.valueof(fieldName).getDescribe().getLabel()+'/';
			 }
        return '';
    }
	
}