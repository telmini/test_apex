global class SubscriptionDateCheck implements Database.Batchable<sObject> {

    private static final String PUB = 'Conformité Pub';
    

    global Database.QueryLocator start(Database.BatchableContext cnx) { 
         String query = 'SELECT Id, EffectiveEndDate__c, SBQQ__RequiredById__c,'+
                  'Souscription_Conforme__c, ComplianceProcess__c  FROM SBQQ__Subscription__c WHERE ComplianceProcess__c = :PUB';
                 
         return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext cnx, List<SBQQ__Subscription__c> scope) {
        try {
            List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
            List<SBQQ__Subscription__c> parentSub = new List<SBQQ__Subscription__c>();
            for(SBQQ__Subscription__c sub : scope) {
               if (sub.EffectiveEndDate__c > Date.today()) {
                    sub.Souscription_Conforme__c = true;
				else {
                    //en cas d'échec du processus de conformité 
					sub.Souscription_Conforme__c = false;
					sub.MissingInformations__c = SubscriptionsUtil.checkMissingInfo(sub);
				}
                subs.add(sub);
                if (sub.SBQQ__RequiredById__c != null) {
                    if (setParentConforme(sub.SBQQ__RequiredById__c, sub.Souscription_Conforme__c))!=null){
                        parentSub.add(setParentConforme(sub.SBQQ__RequiredById__c,sub.Souscription_Conforme__c));
                    }
                }                
            }
            update subs;
            update parentSub;
        } catch(Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }

    
    global void finish(Database.BatchableContext cnx) {
    }
    
    private SBQQ__Subscription__c setParentConforme(String parentId, Boolean subConf) {
        SBQQ__Subscription__c[] parentSub = [SELECT Id, Souscription_Conforme__c FROM SBQQ__Subscription__c WHERE Id = :parentId];
        if (parentSub.size() > 0) {
            parentSub[0].Souscription_Conforme__c = SubConf;
            return parentSub[0];
        }
        return null;
    }


 }