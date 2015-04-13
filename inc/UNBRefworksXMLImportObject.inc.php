<?php
/**
 * @file
 * Defines UNBRefworksXMLImportObject.
 */

/**
 * RIS import object.
 *
 * Actually does the heavy-lifting during the import.
 * @author adam
 */
class UNBRefworksXMLImportObject extends RefworksXMLImportObject {
  protected $mods;

  /**
   * Get an item from the source.
   *
   * @see IslandoraImportObject::getOne()
   */
  public static function getOne(&$file) {
    $record = '';

    $refworks = new DOMDocument();
    $refworks->load($file->uri);
    $xpath = new DOMXPath($refworks);
    $results = $xpath->query('/refworks/reference');
    $documents = array();
    if ($results->length >= 1) {
      // Get Record.
      $child = $results->item(0);
      $record = '<refworks>' . $refworks->saveXML($child) . '</refworks>';
      // Remove Record.
      $child->parentNode->removeChild($child);
      $refworks->save($file->uri);
      file_save($file);
    }
    return (empty($record) ? FALSE : new self($record));
  }

  /**
   * Generates a MODS document repersenting the imported data.
   *
   * @see IslandoraImportObject::getMODS()
   */
  public function getMODS() {
    if ($this->mods === NULL) {
      $path = drupal_get_path('module', 'islandora_refworksxml_importer');
      $refworks = new DOMDocument();
      $refworks->loadXML($this->source);
      $genre = $refworks->getElementsByTagName('rt');
      $genre_string = $genre->item(0)->nodeValue;
      if (empty($genre)) {
        return FALSE;
      }
      switch ($genre_string) {
        case 'Book, Whole':
          $xsl_path = $path . '/xsl/refworks_to_mods_book.xsl';
          $genre->item(0)->nodeValue = 'book';
          break;

        case 'Book, Section':
        case 'Book, Chapter':
          $xsl_path = $path . '/xsl/refworks_to_mods_book_section.xsl';
          $genre->item(0)->nodeValue = 'chapter';
          break;

        case 'Conference Proceedings':
          $xsl_path = $path . '/xsl/refworks_to_mods_conf.xsl';
          $genre->item(0)->nodeValue = 'Conference Proceeding';
          break;

        case 'Journal Article':
          $xsl_path = $path . '/xsl/refworks_to_mods_journal.xsl';
          $genre->item(0)->nodeValue = 'Journal Article';
          break;

        case 'Web Page':
          $xsl_path = $path . '/xsl/refworks_to_mods_journal.xsl';
          $genre->item(0)->nodeValue = 'Web Page';
          break;

        default:
          $xsl_path = $path . '/xsl/refworks_to_mods_journal.xsl';
          $genre->item(0)->nodeValue = 'Journal Article';
      }
      $xslt = new XSLTProcessor();
      $xsl_doc = new DomDocument();
      $xsl_doc->load($xsl_path);
      $xslt->importStylesheet($xsl_doc);
      $this->mods = $xslt->transformToXml($refworks);
    }
    return $this->mods;
  }
}
