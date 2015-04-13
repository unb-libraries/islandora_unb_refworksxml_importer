<?php
/**
 * @file
 * Functions for including UNB Libraries Facet values in citation forms.
 */

/**
 * Helper : Provides an Institution Name form element.
 */
function _get_unb_institution_name_form_element() {
  $options = array(
    'University of New Brunswick (Fredericton)',
    'University of New Brunswick (Saint John)',
  );
  return array(
    '#type' => 'select',
    '#title' => t('Institution Name'),
    '#options' => drupal_map_assoc($options),
    '#default_value' => 'University of New Brunswick (Fredericton)',
  );
}

/**
 * Helper : Provides an Faculty Name form element.
 */
function _get_unb_faculty_name_form_element() {
  return array(
    '#type' => 'textfield',
    '#title' => t('Faculty Name'),
    '#description' => 'Verbatim name of faculty, regardless of campus.',
  );
}

/**
 * Helper : Provides an Department Name form element.
 */
function _get_unb_department_name_form_element() {
  return array(
    '#type' => 'textfield',
    '#title' => t('Department Name'),
    '#description' => 'Verbatim name of department, regardless of campus.',
  );
}

/**
 * Helper : Provides an Group Name form element.
 */
function _get_unb_group_name_form_element() {
  return array(
    '#type' => 'textfield',
    '#title' => t('Group Name'),
    '#description' => 'Group name is specific to research institutes or other unique collections groupings (ie: <em>Second Language Research Institute</em> or <em>Canadian Rivers Institute</em>. Skip unless you are certain this document was a product of that group.',
  );
}

/**
 * Helper : Provides an Discipline Name form element.
 */
function _get_unb_discipline_name_form_element() {
  return array(
    '#type' => 'textfield',
    '#title' => t('Discipline Name'),
    '#description' => 'Should match the <strong>Discipline</strong> entry under the <strong>Degree</strong> field..',
  );
}

/**
 * Helper : Provides an Scholarship Level form element.
 */
function _get_unb_scholarship_level_form_element() {
  $options = array(
    'Faculty / Staff',
    'Undergraduate',
    'Graduate',
  );
  return array(
    '#type' => 'select',
    '#title' => t('Level of Scholarship'),
    '#options' => drupal_map_assoc($options),
    '#default_value' => 'Faculty / Staff',
  );
}

/**
 * Helper : Provides an Object Type form element.
 */
function _get_unb_object_type_form_element() {
  $options = array(
    'Article',
  );
  return array(
    '#type' => 'select',
    '#title' => t('Level of Scholarship'),
    '#options' => drupal_map_assoc($options),
    '#default_value' => 'Article',
  );
}
