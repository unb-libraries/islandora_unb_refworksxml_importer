<?php
/**
 * @file
 * Defines UNBRefworksXMLImporter.
 */

class UNBRefworksXMLImporter extends RefworksXMLImporter {
  protected $itemClass = 'UNBRefworksXMLImportObject';

  /**
   * Get the number of items to import from $this->file.
   *
   * @see IslandoraBatchImporter::getNumber()
   */
  public function getNumber() {
    $refworks = new DOMDocument();
    $refworks->load(
      drupal_realpath(
        $this->file['file']->uri
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
    module_load_include('php', 'islandora_unb_refworksxml_importer', 'inc/unb_facet_form_elements.inc');

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
        'unb_institution_name' => _get_unb_institution_name_form_element(),
        'unb_faculty_name' => _get_unb_faculty_name_form_element(),
        'unb_department_name' => _get_unb_department_name_form_element(),
        'unb_group_name' => _get_unb_group_name_form_element(),
        'unb_scholarship_level' => _get_unb_scholarship_level_form_element(),
        'unb_object_type' => _get_unb_object_type_form_element(),
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

    $info = array(
      'file' => $file,
      'unb_institution_name' => $form_state['values']['unb_institution_name'],
      'unb_faculty_name' => $form_state['values']['unb_faculty_name'],
      'unb_department_name' => $form_state['values']['unb_department_name'],
      'unb_group_name' => $form_state['values']['unb_group_name'],
      'unb_scholarship_level' => $form_state['values']['unb_scholarship_level'],
      'unb_object_type' => $form_state['values']['unb_object_type'],
    );
    return $info;
  }

  /**
   * Inherited.
   */
  public function preprocess() {
    $preprocessed = array();
    $item_class = $this->itemClass;

    $total = $this->getNumber();
    for ($i = 0; $i < $total; $i++) {
      $item = $item_class::getOne($this->file);
      if ($item) {
        $this->parameters['namespace'] = $this->getNamespace($item);
        $wrapper = $item->getWrapperClass();
        $preprocessed[] = $object = new $wrapper($this->connection, $item, $this->parameters);
        $object->addRelationships();
        $this->addToDatabase($object, $object->getResources());
      }
    }

    return $preprocessed;
  }
}
