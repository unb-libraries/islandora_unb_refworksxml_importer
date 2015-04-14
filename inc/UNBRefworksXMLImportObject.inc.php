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
  private $unb_institution_name;
  private $unb_faculty_name;
  private $unb_department_name;
  private $unb_group_name;
  private $unb_scholarship_level;
  private $unb_object_type;
  private $document;

  /**
   * Constructor.
   */
  protected function __construct($source) {
    parent::__construct($source);
    $this->document = $this->source['document'];
    $this->unb_institution_name = $this->source['unb_institution_name'];
    $this->unb_faculty_name = $this->source['unb_faculty_name'];
    $this->unb_department_name = $this->source['unb_department_name'];
    $this->unb_group_name = $this->source['unb_group_name'];
    $this->unb_scholarship_level = $this->source['unb_scholarship_level'];
    $this->unb_object_type = $this->source['unb_object_type'];
  }

  /**
   * Get an item from the source.
   *
   * @see IslandoraImportObject::getOne()
   */
  public static function getOne(&$info) {
    $refworks = new DOMDocument();
    $refworks->load($info['file']->uri);
    $xpath = new DOMXPath($refworks);
    $results = $xpath->query('/refworks/reference');
    $record = array();
    if ($results->length >= 1) {
      // Get Record.
      $child = $results->item(0);
      $record['document'] = '<refworks>' . $refworks->saveXML($child) . '</refworks>';
      array_push(
        $record,
        $info['unb_institution_name'],
        $info['unb_faculty_name'],
        $info['unb_faculty_name'],
        $info['unb_group_name'],
        $info['unb_scholarship_level'],
        $info['unb_object_type']
      );
      // Remove Record.
      $child->parentNode->removeChild($child);
      $refworks->save($info['file']->uri);
      file_save($info['file']);
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
      $path = drupal_get_path('module', 'islandora_unb_refworksxml_importer');
      $refworks = new DOMDocument();
      $refworks->loadXML($this->document);
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
      $transformed_doc = $xslt->transformToDoc($refworks);

      // Inject UNB MODS elements
      $root = $transformed_doc->documentElement;

      // Create new unbfacetInfo element
      $unb_facet_info = $transformed_doc->createElement('mods:unbfacetInfo');

      // This could certainly be a loop.
      $unb_institution_name = $transformed_doc->createElement("mods:unbInstitutionName", $this->unb_institution_name);
      $unb_facet_info->appendChild($unb_institution_name);
      $unb_faculty_name = $transformed_doc->createElement("mods:unbFacultyName", $this->unb_faculty_name);
      $unb_facet_info->appendChild($unb_faculty_name);
      $unb_department_name = $transformed_doc->createElement("mods:unbDepartmentName", $this->unb_department_name);
      $unb_facet_info->appendChild($unb_department_name);
      $unb_group_name = $transformed_doc->createElement("mods:unbGroupName", $this->unb_group_name);
      $unb_facet_info->appendChild($unb_group_name);
      $unb_scholarship_level = $transformed_doc->createElement("mods:unbScholarshipLevel", $this->unb_scholarship_level);
      $unb_facet_info->appendChild($unb_scholarship_level);
      $unb_object_type = $transformed_doc->createElement("mods:unbObjectType", $this->unb_object_type);
      $unb_facet_info->appendChild($unb_object_type);

      // Append new link to root element
      $root->appendChild($unb_facet_info);

      $this->mods = $xslt->transformToXml($transformed_doc);
    }
    return $this->mods;
  }
}
