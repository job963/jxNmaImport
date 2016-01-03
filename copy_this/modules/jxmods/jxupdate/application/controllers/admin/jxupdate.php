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
        /*$oSmarty = oxUtilsView::getInstance()->getSmarty();
        $oSmarty->assign( "oViewConf", $this->_aViewData["oViewConf"]);
        $oSmarty->assign( "shop", $this->_aViewData["shop"]);*/
        
        $myConfig = oxRegistry::get("oxConfig");
        $sDelimeter = $myConfig->getConfigParam('sJxUpdateDelimeter');
        switch ($sDelimeter) {
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

        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );

        if ($_FILES["uploadfile"]["tmp_name"] != '') {
            $fh = fopen($_FILES["uploadfile"]["tmp_name"],"r");
            
            //get column headers
            $aRow = fgetcsv($fh, 1000, $sDeliChar);
            //--$aRow = explode( $sDeliChar, fgets($fh) );
            $this->_aViewData["aCols"] = $aRow;
            $iCols = count($aRow);
            $this->_aViewData["iCols"] = $iCols;
            $sSql = "DROP TEMPORARY TABLE IF EXISTS jxtmparticles";
            $rs = $oDb->Execute($sSql);
            $sSql = "CREATE TEMPORARY TABLE jxtmparticles ( jxartnum VARCHAR(255)";
            for ( $i=1; $i<=$iCols; $i++ ) {
                $sSql .= ", jxvalue{$i} VARCHAR(255)";
            }
            $sSql .= " )";
            //jxvalue1 VARCHAR(255), jxvalue2 VARCHAR(255), jxvalue3 VARCHAR(255), jxvalue4 VARCHAR(255), jxvalue5 VARCHAR(255) )";
            $rs = $oDb->Execute($sSql);

            //read data
            $sSql = "INSERT INTO jxtmparticles (jxartnum";
            for ( $i=1; $i<=$iCols; $i++ ) {
                $sSql .= ",jxvalue{$i}";
            }
            $sSql .= ") VALUES (";
            while (($aRow = fgetcsv($fh, 1000, $sDeliChar)) !== FALSE) {
                /*$sArtnum = $aRow[0];
                if(isset($aRow[1])) {
                    $sValue = $aRow[1];
                }
                else {
                    $sValue = '';
                }*/
                $sInsert = $sSql . "'%{$aRow[0]}%'";
                for ( $i=1; $i<=$iCols; $i++ ) {
                    $sInsert .= ",'" . $aRow[$i] . "'";
                }
                $sInsert .= ")";
                //$sSql = "INSERT INTO jxtmparticles (jxartnum,jxvalue) VALUES ('%{$aRow[0]}%','{$aRow[1]}') ";
                $rs = $oDb->Execute($sInsert);
            }
            fclose($fh);
        
        
            $sFields = "";
            for ( $i=1; $i<=$iCols; $i++ ) {
                $sFields .= ", t.jxvalue{$i}";
            }
            $sFields .= " ";
            $sSql = "SHOW TABLES LIKE 'jxinvarticles' ";
            $rs = $oDb->Execute($sSql);
            if (!$rs) {
                $sSql = "SELECT a.oxid, a.oxactive, a.oxartnum, a.oxmpn, "
                            . "IF(a.oxparentid='',a.oxtitle,(SELECT CONCAT(b.oxtitle,', ',a.oxvarselect) FROM oxarticles b WHERE a.oxparentid=b.oxid)) AS oxtitle, "
                            . "a.oxean, a.oxstock, a.oxstockflag, a.oxprice "
                            . $sFields
                        . "FROM oxarticles a, jxtmparticles t "
                        . "WHERE (a.oxartnum LIKE t.jxartnum OR a.oxmpn LIKE t.jxartnum) "  //AND a.oxactive = 1 "
                        . "ORDER BY a.oxartnum";
                //$oSmarty->assign("bJxInvarticles",FALSE);
                $this->_aViewData["bJxInvarticles"] = FALSE;
            }
            else {
                $sSql = "SELECT a.oxid, a.oxactive, a.oxartnum, a.oxmpn, "
                            . "IF(a.oxparentid='',a.oxtitle,(SELECT CONCAT(b.oxtitle,', ',a.oxvarselect) FROM oxarticles b WHERE a.oxparentid=b.oxid)) AS oxtitle, "
                            . "a.oxean, i.jxinvstock, a.oxstock, a.oxstockflag, a.oxprice "
                            . $sFields
                        . "FROM oxarticles a "
                        . "INNER JOIN jxtmparticles t ON (a.oxartnum LIKE t.jxartnum OR a.oxmpn LIKE t.jxartnum) "
                        . "LEFT JOIN (jxinvarticles i) ON (a.oxid = i.jxartid) "
                        //. "WHERE a.oxactive = 1 ";
                        . "ORDER BY a.oxartnum ";
                //$oSmarty->assign("bJxInvarticles",TRUE);
                $this->_aViewData["bJxInvarticles"] = TRUE;
            }

            $aArticles = array();
            $rs = $oDb->Execute($sSql);
            while (!$rs->EOF) {
                array_push($aArticles, $rs->fields);
                $rs->MoveNext();
            }
        }
        
        //$oSmarty->assign("aArticles",$aArticles);
        $this->_aViewData["aArticles"] = $aArticles;

        return $this->_sThisTemplate;
    }


    
    public function deactivateArticles ()
    {
        $aSelOxid = $this->getConfig()->getRequestParameter( 'jxupdate_oxid' ); 
        $sAction = $this->getConfig()->getRequestParameter( 'jxupdate_action' ); 
        $iCols = $this->getConfig()->getRequestParameter( 'jxupdate_icols' ); 
        $aCols = explode( ',', $this->getConfig()->getRequestParameter( 'jxupdate_acols' ) ); 
        array_shift( $aCols );
        $aValueRows = $this->getConfig()->getRequestParameter( 'jxupdate_avalues' ); 
        /*echo '<pre>';
        print_r($aCols);
        echo '</pre>';*/
        
        $oDb = oxDb::getDb();
        
        if ($sAction == 'update') {
            foreach ($aSelOxid as $key => $Oxid) {
                $aValues = explode( ",", $aValueRows[$key] );
            /*echo '<pre>';
            print_r($aValues);
            echo '</pre>';*/
                $sSql = "UPDATE oxarticles SET ";
                $aSql = array();
                for ($i=1; $i<$iCols; $i++) {
                    $aSql[] = $aCols[$i] . "= '" . $aValues[$i] . "' ";
                }
                $sSql .= implode(',', $aSql) . "WHERE oxid = '{$Oxid}' ";
                //echo $sSql.'<br>';
                $ret = $oDb->Execute($sSql);
            }
        }
        else {
            $sSql = "UPDATE oxarticles SET oxactive=0 WHERE oxid IN ('" . implode("','", $aSelOxid) . "') ";
            //echo $sSql.'<br>';
            $ret = $oDb->Execute($sSql);
        }

        return;
    }

}
?>