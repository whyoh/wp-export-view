wp-export-view
==============

XSLT to present WordPress export file as a single page of HTML.

Usage
=====

1. use the WordPress export function to output an XML file. save the file somewhere.
2. save the XSLT file in the same place.
3. edit the XML file to include a reference to the XSLT file. you need to add the following line immediately under the first line:

  ```xml
  <?xml-stylesheet href="wp-posts.xsl" type="text/xsl"?>
  ```
  
4. open the XML file in a web browser.
the web browser should apply the rules in the XSLT file and output a relatively nicely formatted list of snippets.
