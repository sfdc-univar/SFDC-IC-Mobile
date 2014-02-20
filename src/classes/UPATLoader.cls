public with sharing class UPATLoader {
//Pass in the endpoint to be used using the string url  
public String url = 'https://uvf.owex.oliverwyman.com/Distribution';

public String getContent(String url) {

// Instantiate a new http object
    Http h = new Http();

// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');

// Send the request, and return a response
    HttpResponse res = h.send(req);
    System.debug(res.getBody());
    return res.getBody();
  }

}