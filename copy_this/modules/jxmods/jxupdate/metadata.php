<?php

/**
 * Metadata version
 */
$sMetadataVersion = '1.1';
 
/**
 * Module information
 */
$aModule = array(
    'id'           => 'jxupdate',
    'title'        => 'jxUpdate - Update of Articles by Imports',
    'description'  => array(
                        'de'=>'Import und Deaktivierung von nicht mehr lieferbaren Artikeln.',
                        'en'=>'Import and deactivation of no more available products.'
                        ),
    'thumbnail'    => 'jxupdate.png',
    'version'      => '0.2',
    'author'       => 'Joachim Barthel',
    'url'          => 'https://github.com/job963/jxUpdate',
    'email'        => 'jobarthel@gmail.com',
    'extend'       => array(
                        ),
    'files'        => array(
        'jxupdate'      => 'jxmods/jxupdate/application/controllers/admin/jxupdate.php',
                        ),
    'templates'    => array(
        'jxupdate.tpl'    => 'jxmods/jxupdate/application/views/admin/tpl/jxupdate.tpl',
                        ),
    'events'       => array(
                        ),
    'settings'     => array(
                        array(
                            'group' => 'JXUPDATE_IMPORT', 
                            'name'  => 'sJxUpdateDelimeter', 
                            'type'  => 'select', 
                            'value' => 'comma',
                            'constrains' => 'comma|semicolon|tabulator', 
                            'position' => 0 
                            ),
                        )
    );

?>