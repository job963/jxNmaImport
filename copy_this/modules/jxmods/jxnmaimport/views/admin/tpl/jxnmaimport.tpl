
[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"|oxmultilangassign box=" "}]

<script type="text/javascript">
  if(top)
  {
    top.sMenuItem    = "[{ oxmultilang ident="mxuadmin" }]";
    top.sMenuSubItem = "[{ oxmultilang ident="jxnmaimport_menu" }]";
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

    if (!chkbox.length) 
        chkbox.checked = elem.checked; 
    else 
        for(var i = 0; i < chkbox.length; i++) {
            if (chkbox[i].disabled == false) {
                chkbox[i].checked = elem.checked;
                changeColor(elem.checked,i);
            }
        }
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
    } else {
        for (var i = 0; i < aColumns.length; i++) {
            elemName = aColumns[i] + rowNumber;
            document.getElementById(elemName).style.color = "black";
            document.getElementById(elemName).style.fontWeight = "normal";
        }
    }
}

</script>

    <h1>[{ oxmultilang ident="JXNMAIMPORT_TITLE" }]</h1>
    <form name="transfer" id="transfer" action="[{ $shop->selflink }]" method="post">
        [{ $shop->hiddensid }]
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        <input type="hidden" name="cl" value="article" size="40">
        <input type="hidden" name="updatelist" value="1">
    </form>


    <form enctype="multipart/form-data" action="[{ $oViewConf->selflink }]" method="post">
        <input type="hidden" name="MAX_FILE_SIZE" value="100000">
        <input type="file" name="uploadfile" size="40" maxlength="100000">
        <input type="submit" name="Submit" value=" [{ oxmultilang ident="ARTICLE_EXTEND_FILEUPLOAD" }] " />
    </form>    


<form name="jxnmaimport" id="jxnmaimport" action="[{ $oViewConf->selflink }]" method="post">
    <p>
        [{ $oViewConf->hiddensid }]
        <input type="hidden" name="cl" value="jxnmaimport">
        <input type="hidden" name="fnc" value="">
        <input type="hidden" name="oxid" value="[{ $oxid }]">

        [{if $aArticles }]
        <input type="submit" [{*name="Submit" *}]
                onClick="document.forms['jxnmaimport'].elements['fnc'].value = 'deactivateArticles';" 
                value=" [{ oxmultilang ident="JXNMAIMPORT_DEACTIVATE" }] " />[{*</div>*}]
        [{/if}]
    </p>

    <div id="liste">
        <table cellspacing="0" cellpadding="0" border="0" width="99%">
        <tr>
            [{ assign var="headStyle" value="border-bottom:1px solid #C8C8C8; font-weight:bold;" }]
            <td class="listfilter first" style="[{$headStyle}]" height="15" width="30" align="center">
                <div class="r1"><div class="b1">[{ oxmultilang ident="GENERAL_ACTIVTITLE" }]</div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_ARTNUM" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="JXNMAIMPORT_MPN" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_TITLE" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_EAN" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_STOCK_STOCK" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_STOCK_STOCKFLAG" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]"><div class="r1"><div class="b1">[{ oxmultilang ident="ARTICLE_MAIN_PRICE" }]</div></div></td>
            <td class="listfilter" style="[{$headStyle}]" align="center"><div class="r1"><div class="b1"><input type="checkbox" onclick="change_all('jxnmaimport_oxid[]', this)"></div></div></td>
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
                <td valign="top" class="[{$listclass}][{ if $Article.oxactive == 1}] active[{/if}]" height="15">
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
                    <a href="Javascript:editThis('[{$Article.oxid}]','article');" id="jxPrice[{$i}]" style="[{$txtStyle}]}">
                       [{$Article.oxprice|string_format:"%.2f"}]
                    </a>
                </td>
                <td class="[{$listclass}]" align="center">
                    <input type="checkbox" name="jxnmaimport_oxid[]" 
                           onclick="changeColor(this.checked,[{$i}]);" 
                           value="[{$Article.oxid}]"
                            [{if $Article.oxactive == 0}]disabled="disabled"[{/if}]>
                </td>
                [{ assign var="i" value=$i+1 }]
            </tr>
        [{/foreach}]

        </table>
    </div>
</form>
[{*</div>*}]
