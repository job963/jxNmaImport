<?php

/**
 * Metadata version
 */
$sMetadataVersion = '1.1';
 
/**
 * Module information
 */
$aModule = array(
    'id'           => 'jxnmaimport',
    'title'        => 'jxNmaImport - Import of No More Available products',
    'description'  => array(
                        'de'=>'Import und Deaktivierung von nicht mehr lieferbaren Artikeln.',
                        'en'=>'Import and deactivation of no more available products.'
                        ),
    'thumbnail'    => 'jxnmaimport.png',
    'version'      => '0.2',
    'author'       => 'Joachim Barthel',
    'url'          => 'https://github.com/job963/jxNmaImport',
    'email'        => 'jobarthel@gmail.com',
    'extend'       => array(
                        ),
    'files'        => array(
        'jxnmaimport'      => 'jxmods/jxnmaimport/application/controllers/admin/jxnmaimport.php',
                        ),
    'templates'    => array(
        'jxnmaimport.tpl'    => 'jxmods/jxnmaimport/views/admin/tpl/jxnmaimport.tpl',
                        ),
    'events'       => array(
                        ),
    'settings'     => array(
                        array(
                            'group' => 'JXNMAIMPORT_IMPORT', 
                            'name'  => 'sJxNmaImportDelimeter', 
                            'type'  => 'select', 
                            'value' => 'comma',
                            'constrains' => 'comma|semicolon|tabulator', 
                            'position' => 0 
                            ),
                        )
    );

?>
