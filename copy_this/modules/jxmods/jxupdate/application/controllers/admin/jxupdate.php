<?php

/*
 *    This file is part of the module jxUpdate for OXID eShop Community Edition.
 *
 *    The module jxUpdate for OXID eShop Community Edition is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    The module jxUpdate for OXID eShop Community Edition is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with OXID eShop Community Edition.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @link      https://github.com/job963/jxUpdate
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 * @copyright (C) Joachim Barthel 2013-2016
 *
 */
 
class jxupdate extends oxAdminView
{
    protected $_sThisTemplate = "jxupdate.tpl";

    public function render()
    {
        parent::render();
        
        $myConfig = oxRegistry::get("oxConfig");
        $sDelimiter = $myConfig->getConfigParam('sJxUpdateDelimiter');
        switch ($sDelimiter) {
            case 'comma':
                $sDeliChar = ',';
                break;
            case 'semicolon':
                $sDeliChar = ';';
                break;
            case 'tabulator':
                $sDeliChar = chr(9);
                break;
            default:
                $sDeliChar = ',';
                break;
        }

        $sEnclosure = $myConfig->getConfigParam('sJxUpdateEnclosure');
        switch ($sEnclosure) {
            case 'none':
                $sEncChar = '';
                break;
            case 'quot':
                $sEncChar = '"';
                break;
            case 'apos':
                $sEncChar = '\'';
                break;
            default:
                $sEncChar = '';
                break;
        }

        $sIdField = $myConfig->getConfigParam('sJxUpdateIdField');
//echo '<b>'.$sIdField.'</b>';

        $sCompareMode = $myConfig->getConfigParam('sJxUpdateCompareMode');

        if( $myConfig->getConfigParam('sJxUpdateIgnoreInactive') == True ) {
            $sIgnoreInactive = "";
        } else {
            $sIgnoreInactive = "AND a.oxactive = 1 ";
        }
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );

        if ($_FILES['uploadfile']['tmp_name'] != '') {
            $fh = fopen($_FILES['uploadfile']['tmp_name'],"r");
            
            //get column headers
            if ($sEncChar != '') {
                $aRow = fgetcsv($fh, 1000, $sDeliChar, $sEncChar);
            } else {
                $aRow = fgetcsv($fh, 1000, $sDeliChar);
            }
            $this->_aViewData["aCols"] = $aRow;
            $iCols = count($aRow);
            $this->_aViewData["iCols"] = $iCols;
            $this->_checkTableFields($aRow);

            $sSql = "DROP TEMPORARY TABLE IF EXISTS jxtmparticles";
            $rs = $oDb->Execute($sSql);
            $sSql = "CREATE TEMPORARY TABLE jxtmparticles ( jxsearch VARCHAR(255)";
            for ( $i=1; $i<=$iCols; $i++ ) {
                $sSql .= ", jxvalue{$i} VARCHAR(255)";
            }
            $sSql .= " )";
            $rs = $oDb->Execute($sSql);

            //read data
            $sSql = "INSERT INTO jxtmparticles (jxsearch";
            for ( $i=1; $i<$iCols; $i++ ) {
                $sSql .= ",jxvalue{$i}";
            }
            $sSql .= ") VALUES (";
            $iSearchRows = 0;
            if ($sEncChar != '') {
                $aRow = fgetcsv($fh, 1000, $sDeliChar, $sEncChar);
            } else {
                $aRow = fgetcsv($fh, 1000, $sDeliChar);
            }
            while ($aRow !== FALSE) {
                switch ($sCompareMode) {
                    case 'equal':
                        $sInsert = $sSql . "'{$aRow[0]}'";
                        break;
                    case 'beginswith':
                        $sInsert = $sSql . "'{$aRow[0]}%'";
                        break;
                    case 'endswith':
                        $sInsert = $sSql . "'%{$aRow[0]}'";
                        break;
                    case 'contains':
                        $sInsert = $sSql . "'%{$aRow[0]}%'";
                        break;
                }
                for ( $i=1; $i<$iCols; $i++ ) {
                    $sInsert .= ",'" . $aRow[$i] . "'";
                }
                $sInsert .= ")";
                $rs = $oDb->Execute($sInsert);
//echo '<pre>'.$sInsert.'</pre>';
                $iSearchRows++;
        
                $this->_aViewData["sFilename"] = $_FILES['uploadfile']['name'];
                $this->_aViewData["sDelimiter"] = $sDelimiter;
                $this->_aViewData["sEnclosure"] = $sEnclosure;
                $this->_aViewData["sCompareMode"] = $sCompareMode;
                $this->_aViewData["sIdField"] = $sIdField;

                // retrieve next line
                if ($sEncChar != '') {
                    $aRow = fgetcsv($fh, 1000, $sDeliChar, $sEncChar);
                } else {
                    $aRow = fgetcsv($fh, 1000, $sDeliChar);
                }
            }
            fclose($fh);
        
        
            $sFields = "";
            for ( $i=1; $i<$iCols; $i++ ) {
                $sFields .= ", t.jxvalue{$i}";
            }
            $sFields .= " ";
            $sSql = "SHOW TABLES LIKE 'jxinvarticles' ";
            $rs = $oDb->Execute($sSql);
            if (!$rs) {
                $sSql = "SELECT a.oxid, a.oxactive, a.oxartnum, a.oxmpn, "
                            . "IF(a.oxparentid='',a.oxtitle,(SELECT CONCAT(b.oxtitle,', ',a.oxvarselect) FROM oxarticles b WHERE a.oxparentid=b.oxid)) AS oxtitle, "
                            . "a.oxean, a.oxdistean, a.oxstock, a.oxstockflag, a.oxprice "
                            . $sFields
                        . "FROM oxarticles a, jxtmparticles t "
                        . "WHERE a.{$sIdField} LIKE t.jxsearch "
                        . $sIgnoreInactive
                        . "ORDER BY a.{$sIdField}";
                $this->_aViewData["bJxInvarticles"] = FALSE;
            }
            else {
                $sSql = "SELECT a.oxid, a.oxactive, a.oxartnum, a.oxmpn, "
                            . "IF(a.oxparentid='',a.oxtitle,(SELECT CONCAT(b.oxtitle,', ',a.oxvarselect) FROM oxarticles b WHERE a.oxparentid=b.oxid)) AS oxtitle, "
                            . "a.oxean, a.oxdistean, i.jxinvstock, a.oxstock, a.oxstockflag, a.oxprice "
                            . $sFields
                        . "FROM oxarticles a "
                        . "INNER JOIN jxtmparticles t ON (a.{$sIdField} LIKE t.jxsearch) "
                        . "LEFT JOIN (jxinvarticles i) ON (a.oxid = i.jxartid) "
                        //. "WHERE a.oxactive = 1 ";
                        . "ORDER BY a.{$sIdField} ";
                $this->_aViewData["bJxInvarticles"] = TRUE;
            }

            $aArticles = array();
//echo '<br><b>'.$sSql.'</b>';            
            $rs = $oDb->Execute($sSql);
            if ($rs) {
                while (!$rs->EOF) {
                    array_push($aArticles, $rs->fields);
                    $rs->MoveNext();
                }
            }
            $iFoundRows = count($aArticles);
        }
        
        if ($iFoundRows > $_SERVER['max_input_vars']) {
            echo '<div style="border:2px solid #dd0000;margin:10px;padding:5px;background-color:#ffdddd;font-family:sans-serif;font-size:12px;">';
            echo "{$iFoundRows} rows found, but only {$_SERVER['max_input_vars']} rows supported by your PHP configuration.<br />"
                . "Please contact your administrator and ask him to increase <i>max_input_vars</i>.";
            echo '</div>';
        }
        
        $this->_aViewData["aArticles"] = $aArticles;
        $this->_aViewData["iSearchRows"] = $iSearchRows;
        $this->_aViewData["iFoundRows"] = $iFoundRows;
        
        $oModule = oxNew('oxModule');
        $oModule->load('jxupdate');
        $this->_aViewData["sModuleId"] = $oModule->getId();
        $this->_aViewData["sModuleVersion"] = $oModule->getInfo('version');
        
        return $this->_sThisTemplate;
    }


    
    public function updateArticles ()
    {
        $aSelOxid = $this->getConfig()->getRequestParameter( 'jxupdate_oxid' ); 
        $sAction = $this->getConfig()->getRequestParameter( 'jxupdate_action' ); 
        $iCols = $this->getConfig()->getRequestParameter( 'jxupdate_icols' ); 
        $aCols = explode( ',', 'empty,'.$this->getConfig()->getRequestParameter( 'jxupdate_acols' ) ); 
        array_shift( $aCols );
        $aValueRows = $this->getConfig()->getRequestParameter( 'jxupdate_avalues' ); 
        
        $oDb = oxDb::getDb();
        
        if ($sAction == 'update') {
            $iUpdatedRows = 0;
            foreach ($aSelOxid as $key => $aValueRow) {
                $aValues = explode( ",", $aValueRow );

                $sSql = "UPDATE oxarticles SET ";
                $aSql = array();
                for ($i=2; $i<=$iCols; $i++) {
                    $aSql[] = $aCols[$i] . "= '" . $aValues[$i] . "'";
                }
                $sSql .= implode(', ', $aSql) . " WHERE oxid = '{$aValues[0]}' ";
                //echo $sSql.'<br>';
                $ret = $oDb->Execute($sSql);
                $iUpdatedRows++;
            }
        }
        else {
            $aOxid = array();
            foreach ($aSelOxid as $key => $aValueRow) {
                $aValues = explode( ",", $aValueRow );
                $aOxid[] = $aValues[0];
            }
            $sSql = "UPDATE oxarticles SET oxactive=0 WHERE oxid IN ('" . implode("','", $aOxid) . "') ";
            //echo $sSql.'<br>';
            $ret = $oDb->Execute($sSql);
            $iUpdatedRows = count($aOxid);
        }
        echo '<div style="border:2px solid #00aa00;margin:10px;padding:5px;background-color:#ddffdd;font-family:sans-serif;font-size:12px;">';
        echo "{$iUpdatedRows} rows updated.";
        echo '</div>';

        return;
    }
    
    
    private function _checkTableFields ($aFields) {
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        foreach ($aFields as $key => $sField) {
            if ( !$oDb->getOne( "SHOW COLUMNS FROM oxarticles LIKE '{$sField}'", false, false ) ) {
                echo '<div style="border:2px solid #dd0000;margin:10px;padding:5px;background-color:#ffdddd;font-family:sans-serif;font-size:12px;">';
                echo "Error in import file: Database field <b>{$sField}</b> doesn't exist.";
                echo '</div>';
            }
        }
    }

}
?>