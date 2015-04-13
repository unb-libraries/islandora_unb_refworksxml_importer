CONTENTS OF THIS FILE
---------------------

 * summary
 * requirements
 * installation

SUMMARY
-------

UNB Specific Refworks xml Importer

Importer plugin for Refworks xml files, to create citation objects.

REQUIREMENTS
------------
Drupal 7

The following Drupal modules are required:
 * islandora_refworks_xml_import
 * islandora_scholar

INSTALLATION
------------

Enable the module in the admin/modules page.

NOTES
-----

Currently there are several xslts in the xsl directory.  These files are fairly
similar and can probably be merged into one file with some embedded logic.  BUT there
are still some questions regarding the desired output for each genre so it
would be nice to nail this down first.
