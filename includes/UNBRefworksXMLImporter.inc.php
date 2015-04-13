<?php
/**
 * @file
 * Defines UNBRefworksXMLImporter.
 */

class UNBRefworksXMLImporter extends RefworksXMLImporter {
  protected $itemClass = 'RefworksXMLImportObject';

  /**
   * Get the number of items to import from $this->file.
   *
   * @see IslandoraBatchImporter::getNumber()
   */
  public function getNumber() {
    $refworks = new DOMDocument();
    $refworks->load(
      drupal_realpath(
        $this->file->uri
      )
    );
    $xpath = new DOMXPath($refworks);
    $results = $xpath->query('/refworks/reference');
    return $results ? $results->length : 0;
  }

  /**
   * Get the form for this importer.
   *
   * @see IslandoraBatchImporter::getForm()
   */
  public static function getForm(array &$form_state) {
    return array(
      'fs' => array(
        '#type' => 'fieldset',
        '#title' => t('Refworks Batch Importer'),
        'file' => array(
          '#type' => 'managed_file',
          '#title' => t('File of Refworks XML records to import (".xml" extension).'),
          '#upload_validators' => array(
            'file_validate_extensions' => array('xml'),
          ),
        ),
        'submit' => array(
          '#type' => 'submit',
          '#value' => t('Import'),
        ),
      ),
    );
  }

  /**
   * Determine if we're ready to run our batch process.
   *
   * @see IslandoraBatchImporter::readyForBatch()
   */
  public static function readyForBatch(array &$form_state) {
    return !empty($form_state['values']['file']);
  }

  /**
   * Get the required info to pass into the file parameter of the constructor.
   *
   * @see IslandoraBatchImporter::getBatchInfo()
   */
  public static function getBatchInfo(array &$form_state) {
    $file = file_load($form_state['values']['file']);
    return $file;
  }
}
