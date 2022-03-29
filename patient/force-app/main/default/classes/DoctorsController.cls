public without sharing class DoctorsController {
	
    @AuraEnabled
    public static String createDocUser(String contactId){
        System.debug('contactId : '+contactId);
        String userId = '';
        if(String.isNotBlank(contactId)){
            Profile prof = [ SELECT Id, Name from Profile WHERE NAme= 'Partner Community User' Limit 1];
            Contact cont = [Select id,Name,firstName,profession__c,LastName,Email,AccountId FROM Contact where Id=:contactId];
            System.debug('cont : '+cont);
            User usr = new User();
            usr.firstName= cont.firstName;
            usr.LastName= cont.LastName;
            usr.Email = cont.Email;
            usr.ProfileId = prof.Id;
            usr.Username = cont.Email;
            usr.FederationIdentifier = cont.profession__c+'_'+cont.firstName;
            usr.Alias = generateRandomString(7);
            usr.LanguageLocaleKey = 'en_US';
            usr.TimeZoneSidKey = 'Europe/London';
            usr.LocaleSidKey = 'en_GB';
            usr.EmailEncodingKey= 'UTF-8';
            usr.ContactId = contactId;
            
            //usr.IsPortalEnabled = true;
            usr.IsActive = true;
            usr.CommunityNickname = cont.firstName+' '+cont.LastName;
            insert usr;
             System.debug('usr : '+usr);
            userId = usr.Id;
        }else{
            throw new AuraHandledException('User is not created.'); 
        }
        
        System.debug('userId : '+userId);
        
        PermissionSet prm = [Select id,Name From PermissionSet WHere Name = 'All_Object_Permission' Limit 1];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = prm.Id, AssigneeId = userId);
        insert psa;   
        
        return userId;
    }
    
    @AuraEnabled
    public static Boolean validateDocUser(String emailId){
        System.debug('emailId : '+emailId);
        Boolean isExisting = false;
        if(String.isNotBlank(emailId)){
            List<Contact> contList = [Select id,Name,firstName,LastName,Email FROM Contact where Email=:emailId Limit 1];
            if(!contList.isEmpty()){
                isExisting = true; 
                throw new AuraHandledException('User is already registered.'); 
            }
        }else{
            isExisting = false;
            throw new AuraHandledException('Email is not valid.'); 
        }
        
        System.debug('isExisting : '+isExisting);
        return isExisting;
    }
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    @AuraEnabled
    public static List<Contact> getSearchedRecords(String professionValue, String searchByValue, String searchKeyValue){
        List<Contact> contactList = new List<Contact>();
        System.debug('professionValue : '+professionValue);
        System.debug('searchByValue : '+searchByValue);
        System.debug('searchKeyValue : '+searchKeyValue);
        if(String.isNotBlank(professionValue) && String.isNotBlank(searchByValue)
           && String.isNotBlank(searchKeyValue)){
            String query= 'SELECT Id,FirstName,LastName,Gender__c,License_Number__c,Profession__c,Available_Days__c,Address__c,City__c,Country__c,Middle_Name__c,PPS_Number__c,Doctor_Role__c,DOB__c,Other_Information__c,County__c,Postal_Code__c,Email,Phone  FROM Contact WHERE '+searchByValue;
            String finalQuery = '';
            if(searchByValue == 'Available_Days__c'){
                searchKeyValue = searchKeyValue.replaceAll(';', ',');
                finalQuery = query+' includes (\''+searchKeyValue+'\')';
            }else{
                finalQuery = query+' Like \'%'+searchKeyValue+'%\'';
            }
            System.debug('finalQuery : '+finalQuery);
            if(String.isNotBlank(finalQuery)){
                contactList = Database.query(finalQuery);
                if(contactList.isEmpty()){
                    System.debug('Inside contactList empty');
                    throw new AuraHandledException('No User Records Found.'); 
                }
            }else{
                System.debug('Inside finalQuery empty');
                throw new AuraHandledException('No User Records Found.'); 
            }
        }else{
            System.debug('Inside searchKeyValue empty');
            throw new AuraHandledException('No User Found.'); 
        }
        System.debug('contactList : '+contactList.size());
        return contactList;
    }
}