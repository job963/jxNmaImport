
[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"|oxmultilangassign box=" "}]

<script type="text/javascript">

var rowschecked = 0;
var updateDisplay = true;


    if(top)
  {
    top.sMenuItem    = "[{ oxmultilang ident="mxuadmin" }]";
    top.sMenuSubItem = "[{ oxmultilang ident="jxupdate_menu" }]";
    top.sWorkArea    = "[{$_act}]";
    top.setTitle();
  }

function editThis( sID, sClass )
{
    [{assign var="shMen" value=1}]

    [{foreach from=$menustructure item=menuholder }]
      [{if $shMen && $menuholder->nodeType == XML_ELEMENT_NODE && $menuholder->childNodes->length }]

        [{assign var="shMen" value=0}]
        [{assign var="mn" value=1}]

        [{foreach from=$menuholder->childNodes item=menuitem }]
          [{if $menuitem->nodeType == XML_ELEMENT_NODE && $menuitem->childNodes->length }]
            [{ if $menuitem->getAttribute('id') == 'mxorders' }]

              [{foreach from=$menuitem->childNodes item=submenuitem }]
                [{if $submenuitem->nodeType == XML_ELEMENT_NODE && $submenuitem->getAttribute('cl') == 'admin_order' }]

                    if ( top && top.navigation && top.navigation.adminnav ) {
                        var _sbli = top.navigation.adminnav.document.getElementById( 'nav-1-[{$mn}]-1' );
                        var _sba = _sbli.getElementsByTagName( 'a' );
                        top.navigation.adminnav._navAct( _sba[0] );
                    }

                [{/if}]
              [{/foreach}]

            [{ /if }]
            [{assign var="mn" value=$mn+1}]

          [{/if}]
        [{/foreach}]
      [{/if}]
    [{/foreach}]

    var oTransfer = document.getElementById("transfer");
    oTransfer.oxid.value=sID;
    oTransfer.cl.value=sClass;
    oTransfer.submit();
}

function change_all( name, elem )
{
    if(!elem || !elem.form) 
        return alert("Check Parameters");

    var chkbox = elem.form.elements[name];
    if (!chkbox) 
        return alert(name + " doesn't exist!");

    updateDisplay = false;
    if (!chkbox.length) 
        chkbox.checked = elem.checked; 
    else 
        for(var i = 0; i < chkbox.length; i++) {
            if (chkbox[i].disabled == false) {
                chkbox[i].checked = elem.checked;
                changeColor(elem.checked,i);
            }
        }
    
    updateDisplay = true;
    //document.getElementById('rowschecked').innerHTML = rowschecked;
    /*if ((rowschecked > 0) && (checkRadios()))
        document.getElementById('btnupdate').disabled = false;
    else
        document.getElementById('btnupdate').disabled = true;*/
    checkButton();
}

function changeColor(checkValue,rowNumber)
{
    aColumns = new Array("jxArtNo", "jxMPN", "jxTitle", "jxEAN", "jxStock", "jxStatus", "jxPrice");
    if (checkValue) {
        for (var i = 0; i < aColumns.length; i++) {
            elemName = aColumns[i] + rowNumber;
            document.getElementById(elemName).style.color = "blue";
            document.getElementById(elemName).style.fontWeight = "bold";
        }
        rowschecked++;
    } else {
        for (var i = 0; i < aColumns.length; i++) {
            elemName = aColumns[i] + rowNumber;
            document.getElementById(elemName).style.color = "black";
            document.getElementById(elemName).style.fontWeight = "normal";
        }
        rowschecked--;
    }
    if (rowschecked <= 0) {
        rowschecked = 0;
        //document.getElementById('maincheck').checked = false;
    }
    if (rowschecked > [{$iFoundRows}]) {
        rowschecked = [{$iFoundRows}];
    }
    /*if (updateDisplay) {
        //document.getElementById('rowschecked').innerHTML = rowschecked;
        if ((rowschecked > 0) && (checkRadios()))
            document.getElementById('btnupdate').disabled = false;
        else
            document.getElementById('btnupdate').disabled = true;
    }*/
    checkButton();
}
    
    
function checkRadios()
{
    var elemRadio = document.getElementsByName('jxupdate_action');
    //var ischecked_method = false;
    for ( var i = 0; i < elemRadio.length; i++) {
        if(elemRadio[i].checked) {
            //ischecked_method = true;
            return true;
        }
    }
    return false;
}


function checkButton()
{
    if (updateDisplay) {
        //document.getElementById('rowschecked').innerHTML = rowschecked;
        if ((rowschecked > 0) && (checkRadios()))
            document.getElementById('btnupdate').disabled = false;
        else
            document.getElementById('btnupdate').disabled = true;
    }
}

</script>

[{if ($iFoundRows > $iMaxInputVars) && ($iMaxInputVars != '') }]
    <div style="border:2px solid #dd0000;margin:10px;padding:5px;background-color:#ffdddd;font-family:sans-serif;font-size:12px;width:80%">
        [{ oxmultilang ident="JXUPDATE_MSG_MAXINPUTVARS1" args=$iUpdatedRows }], [{ oxmultilang ident="JXUPDATE_MSG_MAXINPUTVARS2" args=$iUpdatedRows }]<br />
        [{ oxmultilang ident="JXUPDATE_MSG_MAXINPUTVARS3" }]
    </div
[{elseif $sUnknownField != '' }]
    <div style="border:2px solid #dd0000;margin:10px;padding:5px;background-color:#ffdddd;font-family:sans-serif;font-size:12px;width:80%">
        [{ oxmultilang ident="JXUPDATE_MSG_UNKNOWNFIELD" args=$sUnknownField }]
    </div>
[{elseif $iUpdatedRows != '' }]
    <div style="border:2px solid #00aa00;margin:10px;padding:5px;background-color:#ddffdd;font-family:sans-serif;font-size:12px;width:80%">
        [{ oxmultilang ident="JXUPDATE_MSG_UPDATED" args=$iUpdatedRows }][{if $bLogUpdates}], [{ oxmultilang ident="JXUPDATE_MSG_LOGFILEHINT" }][{/if}]
    </div>
[{/if}]

<h1>[{ oxmultilang ident="JXUPDATE_TITLE" }]
    <a href="https://github.com/job963/jxUpdate/blob/master/docs/[{ oxmultilang ident="JXUPDATE_HELPFILE" }]" style="color:white;" target="_blank">
        <div style="margin-left:20px; display:inline-block; border:1px solid darkgray; background-color:darkgray; height:26px; width:26px; border-radius:20px; text-align:center;">?</div>
    </a>
</h1>
    <form name="transfer" id="transfer" action="[{ $shop->selflink }]" method="post">
        [{ $shop->hiddensid }]
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        <input type="hidden" name="cl" value="article" size="40">
        <input type="hidden" name="updatelist" value="1">
    </form>

    <div style="position:absolute;top:4px;right:8px;color:gray;font-size:0.9em;border:1px solid gray;border-radius:3px;">
        &nbsp;[{$sModuleId}]&nbsp;[{$sModuleVersion}]&nbsp;
    </div>

    [{if $iCols == 0}]
    <form enctype="multipart/form-data" action="[{ $oViewConf->selflink }]" method="post">
        <input type="hidden" name="MAX_FILE_SIZE" value="100000">
        <input type="file" name="uploadfile" size="40" maxlength="100000">
        <input type="submit" name="Submit" value=" [{ oxmultilang ident="ARTICLE_EXTEND_FILEUPLOAD" }] " />
    </form>    
    [{/if}]


<form name="jxupdate" id="jxupdate" action="[{ $oViewConf->selflink }]" method="post">
        [{ $oViewConf->hiddensid }]
        <input type="hidden" name="cl" value="jxupdate">
        <input type="hidden" name="fnc" value="">
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        
        <input type="hidden" name="jxupdate_icols" value="[{$iCols}]">
        [{ assign var="jxacols" value="" }]
        [{foreach name=header item=col from=$aCols key=i}]
            [{ assign var="jxacols" value=$jxacols|cat:"," }]
            [{ assign var="jxacols" value=$jxacols|cat:$col }]
        [{/foreach}]
        <input type="hidden" name="jxupdate_acols" value="[{$jxacols}]">
        
        [{if $sFilename != ""}]
        <table><tr><td>
            Filename: <b>[{ $sFilename }]</b>
        </td></tr></table>
        [{/if}]
        
        <br />
        <table>
            <tr>
                <td colspan="10"><span style="font-weight:bold;font-size:1.1em;">[{ oxmultilang ident="SHOP_MODULE_GROUP_JXUPDATE_IMPORT" }]:</span></td>
            </tr>
            <tr>
                <td>[{ oxmultilang ident="SHOP_MODULE_sJxUpdateIdField" }]:</td>
                [{assign var="sTransIdField" value="SHOP_MODULE_sJxUpdateIdField_"|cat:$sIdField }]
                <td><b>[{ oxmultilang ident=$sTransIdField }]</b></td>
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td>[{ oxmultilang ident="SHOP_MODULE_sJxUpdateDelimiter" }]:</td>
                [{assign var="sTransCDelimiter" value="SHOP_MODULE_sJxUpdateDelimiter_"|cat:$sDelimiter }]
                <td><b>[{ oxmultilang ident=$sTransCDelimiter }]</b></td>
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td>[{ oxmultilang ident="SHOP_MODULE_sJxUpdateEnclosure" }]:</td>
                [{assign var="sTransEnclosure" value="SHOP_MODULE_sJxUpdateEnclosure_"|cat:$sEnclosure }]
                <td><b>[{ oxmultilang ident=$sTransEnclosure }]</b></td>
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td>[{ oxmultilang ident="SHOP_MODULE_sJxUpdateCompareMode" }]:</td>
                [{assign var="sTransCompareMode" value="SHOP_MODULE_sJxUpdateCompareMode_"|cat:$sCompareMode }]
                <td><b>[{ oxmultilang ident=$sTransCompareMode }]</b></td>
            </tr>
        </table>
        <br />

        [{if $aArticles }]
            <table>
                <tr><td>
                        [{if $iCols == 0}]
                            [{* nothing to do *}]
                        [{elseif $iCols == 1}]
                            <input type="radio" name="jxupdate_action" id="jxdeactivate" value="deactivate" onclick="checkButton();" /><label for="jxdeactivate">[{ oxmultilang ident="JXUPDATE_OPTION_DEACTIVATE" }]</label>
                        [{else}]
                            <input type="radio" name="jxupdate_action" id="jxoptupdate" value="update" onclick="checkButton();" /> <label for="jxoptupdate">[{ oxmultilang ident="JXUPDATE_OPTION_UPDATE" }]</label><br />
                            <input type="radio" name="jxupdate_action" id="jxoptdeactivate" value="deactivate" onclick="checkButton();" /> <label for="jxoptdeactivate">[{ oxmultilang ident="JXUPDATE_OPTION_DEACTIVATE" }]</label>
                        [{/if}]
                    </td>

                    <td valign="top">
                        &nbsp;&nbsp;&nbsp;<input type="submit" id="btnupdate" [{*name="Submit" *}] disabled="disabled"
                            onClick="document.forms['jxupdate'].elements['fnc'].value = 'updateArticles';" 
                            value=" [{ oxmultilang ident="JXUPDATE_BTN_UPDATE" }] " />[{*</div>*}]
                    </td>
                </tr>
            </table>
        [{/if}]
        <br />

    <div id="liste">
        <table cellspacing="0" cellpadding="0" border="0" width="99%">
        <tr>
            [{ assign var="headStyle" value="border-bottom:1px solid #C8C8C8; font-weight:bold;" }]
            <td class="listfilter first" style="[{$headStyle}]" height="15" width="30" align="center">
                <div class="r1"><div class="b1">[{ oxmultilang ident="GENERAL_ACTIVTITLE" }]</div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_ARTNUM" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="JXUPDATE_OXMPN" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_TITLE" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_EAN" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_STOCK_STOCK" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_STOCK_STOCKFLAG" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_PRICE" }]</div></div></td>
            [{foreach name=header item=col from=$aCols key=i}]
                [{if $i != 0}]
                    [{assign var="upCol" value=$col|upper }]
                    [{assign var="colHeader" value="JXUPDATE_"|cat:$upCol }]
                    <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1"><span style="color:blue;">[{ oxmultilang ident=$colHeader }]</span></div></div></td>
                [{/if}]
            [{/foreach}]
            <td class="listfilter" style="[{$headStyle}]" align="center"><div class="r1"><div class="b1"><input type="checkbox" onclick="change_all('jxupdate_oxid[]', this)"></div></div></td>
        </tr>

        [{ assign var="i" value=0 }]
        [{foreach name=outer item=Article from=$aArticles}]
            <tr>
                [{ cycle values="listitem,listitem2" assign="listclass" }]
                [{if $Article.oxactive == 1}]
                    [{ assign var="txtStyle" value="color:#000000;" }]
                [{else}]
                    [{ assign var="txtStyle" value="color:#a0a0a0;" }]
                [{/if}]
                <td valign="top" class="[{$listclass}][{if $Article.oxactive == 1}] active[{/if}]" height="15">
                    <div class="listitemfloating">&nbsp</a></div>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxArtNo[{$i}]" style="[{$txtStyle}]}">
                       [{$Article.oxartnum}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxMPN[{$i}]" style="[{$txtStyle}]}">
                       [{$Article.oxmpn}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxTitle[{$i}]" style="[{$txtStyle}]}">
                       [{$Article.oxtitle}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxEAN[{$i}]" style="[{$txtStyle}]}">
                       [{$Article.oxean}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxStock[{$i}]" style="[{$txtStyle}]}">
                        [{if bJxInvarticles }]
                            [{$Article.jxinvstock}]&nbsp;&nbsp;([{$Article.oxstock}])
                        [{else}]
                            [{$Article.oxstock}]
                        [{/if}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxStatus[{$i}]" style="[{$txtStyle}]}">
                       [{if $Article.oxstockflag == 1}]
                            [{ oxmultilang ident="GENERAL_STANDARD" }]
                       [{elseif $Article.oxstockflag == 4}]
                            [{ oxmultilang ident="GENERAL_EXTERNALSTOCK" }]
                       [{elseif $Article.oxstockflag == 2}]
                            [{ oxmultilang ident="GENERAL_OFFLINE" }]
                       [{elseif $Article.oxstockflag == 3}]
                            [{ oxmultilang ident="GENERAL_NONORDER" }]
                        [{/if}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxPrice[{$i}]" style="[{$txtStyle}]}" [{if $Article.oxactive == 0}]disabled="disabled"[{/if}]>
                       [{$Article.oxprice|string_format:"%.2f"}]
                    </a>
                </td>
                [{ assign var="jxavalues" value=$Article.oxartnum }]
                [{foreach name=header item=col from=$aCols key=k}]
                    [{if $k != 0}]
                    [{ assign var="jxavalues" value=$jxavalues|cat:"," }]

                <td class="[{$listclass}]">
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxvalue[{$i}]" style="[{$txtStyle}]}"><span style="color:blue;" [{if $Article.oxactive == 0}]disabled="disabled"[{/if}]>
                        [{if $k == 1}]
                            [{$Article.jxvalue1}]
                            [{ assign var="jxavalues" value=$jxavalues|cat:$Article.jxvalue1 }]
                        [{elseif $k == 2}]
                            [{$Article.jxvalue2}]
                            [{ assign var="jxavalues" value=$jxavalues|cat:$Article.jxvalue2 }]
                        [{elseif $k == 3}]
                            [{$Article.jxvalue3}]
                            [{ assign var="jxavalues" value=$jxavalues|cat:$Article.jxvalue3 }]
                        [{elseif $k == 4}]
                            [{$Article.jxvalue4}]
                            [{ assign var="jxavalues" value=$jxavalues|cat:$Article.jxvalue4 }]
                        [{elseif $k == 5}]
                            [{$Article.jxvalue5}]
                            [{ assign var="jxavalues" value=$jxavalues|cat:$Article.jxvalue5 }]
                        [{/if}]
                        </span></a>
                </td>

                    [{/if}]
                [{/foreach}]
                [{*<input type="hidden" name="jxupdate_avalues[]" value="[{$jxavalues}]">*}]
                
                
                <td class="[{$listclass}]" align="center">
                    <input type="checkbox" name="jxupdate_oxid[]" 
                           onclick="changeColor(this.checked,[{$i}]);" 
                           value="[{$Article.oxid}],[{$jxavalues}]"
                            [{*if $Article.oxactive == 0}]disabled="disabled"[{/if*}]>
                </td>
                [{ assign var="i" value=$i+1 }]
            </tr>
        [{/foreach}]

        </table>
    </div>
    <div>
        [{if $iSearchRows > 0}]
            [{$iFoundRows}] [{ oxmultilang ident="JXUPDATE_OF_PRODUCTS_FOUND1" }] [{$iSearchRows}] [{ oxmultilang ident="JXUPDATE_OF_PRODUCTS_FOUND2" }]
        [{/if}]
    </div>
</form>
[{*</div>*}]
