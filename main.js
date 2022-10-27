var http = require("http");

http.createServer(function (request, response) {
    // Send the HTTP header 
    // HTTP Status: 200 : OK
    // Content Type: text/plain
    response.writeHead(200, {'Content-Type': 'text/html'});
    
    // Send the response body as "Hello World"
    response.end('<!DOCTYPE html>\n\<html lang="en"><style>h1 { text-align: center; }</style><head></head><body><h1>Hello World</h1>\n</body></html>');
 }).listen(8081);
 
 // Console will print the message
 console.log('Server running at http://127.0.0.1:8081/');