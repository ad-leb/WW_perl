package Opson;





sub hello 
{ 
	print STDOUT qq(Content-Type: text/plain\r\n\r\n);
	print STDOUT qq(Hello, buddy!\n);
}





1;
