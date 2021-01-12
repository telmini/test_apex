# test_apex

Description fonctionnelle des différentes classes :

- Batch SubscriptionComplianceCheck -> Batch permettant de vérifier la conformité d'une souscription. Pour une liste de souscriptions (SBQQ__Subscription__c - objet standard CPQ) dont le statut (status)est à 'Éléments manquants' et Souscription_Conforme__c = false, 
vérification de la conformité selon différents processus (critères spécifiques pour chaque processus). 
Si OK, mise à jour de la conformité de la souscription (Souscription_Conforme__c) à true. Si une souscription enfant est mise à jour (SBQQ__RequiredById__c != null),
mise à jour de la conformité (Souscription_Conforme__c) de la souscription parent.

- Classe de test SubscriptionComplianceCheckTest -> Classe permettant de tester le batch SubscriptionComplianceCheck avec les différentes initialisations nécessaires au lancement du batch.

- Trigger ContractEndDateAdapterTrigger -> Trigger déclenché à la création et la mise à jour de souscriptions. Permet de mettre à jour la date de fin (EndDate) des contrats (Contract)
liés à une souscription créée/mise à jour. 
La mise à jour de la date de fin doit prendre en compte toutes les souscriptions liées au contrat (pas uniquement celle qui a déclenchée le trigger).

- Classe Logs -> permet d'insérer les informations de logs dans le Custom Object Logs__c.

- Classes Account_DataFactory et AccesBeneficiaire_DataFactory -> permettent d'initialiser les données pour les classes de test
 


Instructions : 

Les modifications doivent respecter la description fonctionnelle des différentes classes.
Si besoin -> possibilité de créer de nouvelles classes, de modifier la structure du code, de renommer les éléments, d'ajouter des commentaires... 
Attention à prendre en compte des éventuelles problématiques de volumétrie sur les souscriptions.



Exercices à réaliser : 

1. Optimisation et application des bonnes pratiques APEX pour le batch SubscriptionComplianceCheck

2. Optimisation et application des bonnes pratiques APEX pour la classe de test SubscriptionComplianceCheckTest

3. Optimisation et application des bonnes pratiques APEX pour le trigger ContractEndDateAdapterTrigger

4. Expliquer une solution technique et l'implémenter pour le besoin métier suivant : Un nouveau processus de conformité doit être ajouté. Celui-ci concerne les souscriptions dont le processus de conformité (ComplianceProcess__c) est à 
la valeur "Conformité Pub". Pour ces souscriptions, il est nécessaire de valider que la date de fin effective (EffectiveEndDate__c) est supérieure à la date du jour. 
De plus, un champ "MissingInformations__c" a été créé sur les souscriptions. Celui-ci doit être renseigné en cas d'échec du processus de conformité avec les différentes informations vérifiées par le processus de conformité concerné ("Conformité Pub" ou "Conformité Immo neuf"). 
A noter : de nouveaux processus de conformité seront ajoutés ultérieurement.
