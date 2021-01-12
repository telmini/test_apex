trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (after insert, after update) {
     
    Boolean isTerminate;
    Date terminatedDate;
    Date endDate;

   
    // dans une clause d'une requete SOQL on ne peut utiliser Trigger.new qu'avec id IN et non =
    //List<SBQQ__Subscription__c> sub=[SELECT SBQQ__Contract__c,TechAmendmentReason__c FROM SBQQ__Subscription__c where id =:Trigger.new];
     Set<Id> cons = new Set<Id>();
    // pour un besoin optimal on peut utiliser directement Trigger.new sans passer par une requete SOQL
    //for (SBQQ__Subscription__c sub :sub) {
    for (SBQQ__Subscription__c sub : Trigger.new) {
       cons.add(sub.SBQQ__Contract__c);
    }
    try {
        List<Contract> conts = new List<Contract>();
        for (Contract con : [SELECT Id, EndDate, (SELECT Id, SBQQ__EndDate__c, SBQQ__TerminatedDate__c, SBQQ__Contract__c 
                                              FROM SBQQ__Subscriptions__r) FROM Contract WHERE Id IN :cons]) {
            system.debug('contrat on :: '+con)   ; 
            isTerminate = true;
            terminatedDate = con.EndDate;
            endDate = con.EndDate;
              
            for (SBQQ__Subscription__c sub : con.SBQQ__Subscriptions__r) {
                if (sub.SBQQ__TerminatedDate__c == null) {
                    isTerminate = false;
                } else if (terminatedDate < sub.SBQQ__TerminatedDate__c) {
                    terminatedDate = sub.SBQQ__TerminatedDate__c;
                }
                if (sub.SBQQ__EndDate__c != null && endDate < sub.SBQQ__EndDate__c) {
                    endDate = sub.SBQQ__EndDate__c;
                }
            }
            
            if (isTerminate) {
                con.EndDate = terminatedDate;
            } else {
                con.EndDate = endDate;
            }
                                            
                                                  
            conts.add(con);
        }
        
        UPDATE conts;
       
        
    } catch(Exception e) {
            Logs.error('ContractEndDateAdapterTrigger','SBQQ__Subscription__c Trigger insert & update', e);
    }
}