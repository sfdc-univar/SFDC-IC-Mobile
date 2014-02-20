global with sharing class FindNearby {

    public FindNearby(ApexPages.StandardSetController controller) { }

    @RemoteAction
    // Find accounts nearest a geolocation
    global static List<Account> getNearby(String lat, String lon) {

        // If geolocation isn't set, use San Francisco
        if(lat == null || lon == null || lat.equals('') || lon.equals('')) {
            lat = '37.77493';
            lon = '-122.419416';
        }

        // SOQL query to get the nearest warehouses
        String queryString =
            'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, SalesOfficeName__c, Industry, LastActivityDate, ' +
            	'Total_Count_Opportunities__c, Rolling12MonthSales__c, ' +
                'ShippingStreet , ShippingPhone__c, ShippingCity, RecordType.DeveloperName, OwnerLink__r.Id , OwnerLink__r.Name ' +
            'FROM Account ' +
            'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 200 ' +
            'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
            'LIMIT 1000';

        // Run and return the query results
   
        return(database.Query(queryString));
    }
}