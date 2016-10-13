<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%
	String managementFlag = CommonUtils.getString(request.getParameter("flag1"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmBuyMultiBorgWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 550px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
/* .jqmOverlay { background-color: #000; } */
/* * html .jqmBuyMultiBorgWindow { */
/*      position: absolute; */
/*      top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px'); */
/* } */
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
    $("#buyMultiBorgSelectButton").click(function(){ //Dialog 선택
        fnJqmSelectBuyMultiBorg();
        $("#buyMultiBorgDialogPop").jqmHide();
        $("#multiBorgDivList").jqGrid("setGridParam",{datatype:"local"}).trigger("reloadGrid");
    });
    $("#srcBuyMultiBorgDivButton").click(function(){
        fnBuyMultiBorgDialogPopSearch();
    });
    $("#srcMultiBorgNmDiv").keydown(function(e){ 
        if(e.keyCode==13) { $("#srcBuyMultiBorgDivButton").click(); } 
    });
    
    // Dialog Button Event
    $('#buyMultiBorgDialogPop').jqm();   //Dialog 초기화
    $("#buyMultiBorgCloseButton").click(function(){  //Dialog 닫기
    	$("#multiBorgDivList").jqGrid("setGridParam",{datatype:"local"}).trigger("reloadGrid");
        $("#buyMultiBorgDialogPop").jqmHide();
        $("#srcMultiBorgTypeDiv").val("");
        $("#srcMultiBorgNmDiv").val("");
        $("#srcWorkDiv").val("");
        fnBuyMultiBorgCallback = "";
    });
    $('#buyMultiBorgDialogPop').jqm().jqDrag('#buyMultiBorgDialogHandle');
    
    fnInitWorkComponent();
});

var fnBuyMultiBorgCallback = "";

function fnBuyMultiborgDialog(borgType, isFixed, borgNm, callbackString) {
    $("#buyMultiBorgDialogPop").jqmShow();
    $("#srcMultiBorgTypeDiv").val(borgType);
    if(isFixed=="1") { $("#srcMultiBorgTypeDiv").attr("disabled","true"); }
    else { $("#srcMultiBorgTypeDiv").removeAttr("disabled"); }
    $("#srcMultiBorgNmDiv").val(borgNm);
    multiBorgDialogDivInit();
}

function fnBuyMultiborgDialogForClientId(borgType, isFixed, borgNm, callbackString, clientId) {
    $("#buyMultiBorgDialogPop").jqmShow();
    $("#srcMultiBorgTypeDiv").val(borgType);
    if(isFixed=="1") { $("#srcMultiBorgTypeDiv").attr("disabled","true"); }
    else { $("#srcMultiBorgTypeDiv").removeAttr("disabled"); }
    $("#srcMultiBorgNmDiv").val(borgNm);
    $("#srcMultiClientIdDiv").val(clientId);
    fnBuyMultiBorgCallback = callbackString;
    multiBorgDialogDivInit();
}


//고객유형,채권이 없는 사업장만 조회할때 사용 (멀티)
function fnBuyMultiborgDialogForWorkInfo(borgType, isFixed, borgNm, isWork, isAcc) {
    $("#buyMultiBorgDialogPop").jqmShow();
    $("#srcMultiBorgTypeDiv").val(borgType);
    if(isWork=="1")	$("#srcMultiIsWorkDiv").val("Y");
    else			$("#srcMultiIsWorkDiv").val("");
    if(isAcc=="1")	$("#srcMultiIsAccDiv").val("Y");
    else			$("#srcMultiIsAccDiv").val("");
    if(isFixed=="1") { $("#srcMultiBorgTypeDiv").attr("disabled","true"); }
    else { $("#srcMultiBorgTypeDiv").removeAttr("disabled"); }
    $("#srcMultiBorgNmDiv").val(borgNm);
    multiBorgDialogDivInit();
}

//고객유형를 코드 테이블에서 조회한다. 
function fnInitWorkComponent(){
    $.post(
    	'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getWorkInfo.sys',
    	{},
        function(arg){
            var workList = eval('(' + arg + ')').workList;
            
            $("#srcWorkDiv").html("");
            $("#srcWorkDiv").append("<option value=''>선택</option>");
            for(var i=0;i<workList.length;i++) {
                $("#srcWorkDiv").append("<option value='"+workList[i].workId+"'>"+workList[i].workNm+"</option>");
            }            
        }
    );
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var multiBorgDivInitCnt = 0;
function multiBorgDialogDivInit() {
//조회버튼 클릭 시 다시 재조회되는 부분삭제(추후다시 작업)
//     jq("#multiBorgDivList").clearGridData();
//     if(multiBorgDivInitCnt>0) {
//         fnBuyMultiBorgDialogPopSearch();
//         return;
//     }
    jq("#multiBorgDivList").jqGrid({
		datatype: "local",
        mtype: 'POST', 
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/borgDivListJQGrid.sys',
        colNames:['조직유형','고객사명','권역','조직코드','areaType','groupId','clientId','branchId','borgId'],
        colModel:[
            {name:'borgTypeNm',index:'borgTypeNm', width:60,align:"center",sortable:true,editable:false},//조직유형
            {name:'borgNms',index:'borgNms', width:300,align:"left",search:false,sortable:true,editable:false},//고객사명
            {name:'areaNm',index:'areaNm', width:60,align:"center",search:false,sortable:true,editable:false},//권역
            {name:'borgCd',index:'borgCd', width:80,align:"center",search:false,sortable:true,editable:false},//조직코드
            
            {name:'areaType',index:'areaType', hidden:true},//areaType
            {name:'groupId',index:'groupId', hidden:true},//groupId
            {name:'clientId',index:'clientId', hidden:true},//clientId
            {name:'branchId',index:'branchId', hidden:true},//branchId
            {name:'borgId',index:'borgId', hidden:false, key:true}//borgId
        ],
        postData: {
            srcBorgType:$("#srcMultiBorgTypeDiv").val(),
            srcBorgNm:$("#srcMultiBorgNmDiv").val(),
            srcClientId:$("#srcMultiClientIdDiv").val(),
            isWork:$("#srcMultiIsWorkDiv").val(),
            isAcc:$("#srcMultiIsAccDiv").val(),
            multiSelYN:'Y'
        },
        multiselect: true,
        rowNum:10, rownumbers: false, rowList:[10,20,30,50,100,500,1000], pager: '#multiBorgDivPager',
        height:250, width:510, 
        sortname: 'borgNms', sortorder: "asc",
        caption:'고객사조회', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() { multiBorgDivInitCnt++; },
        afterInsertRow: function(rowid, aData){},
        ondblClickRow: function (rowid, iRow, iCol, e) {},
        loadError : function(xhr, st, str){ $("#multiBorgDivList").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    });
}

/**
 * 조회조건에 따른 조직 조회   123
 */
function fnBuyMultiBorgDialogPopSearch(){
	jq("#multiBorgDivList").jqGrid("setGridParam", {"page":1, "rows":10});
    var data = jq("#multiBorgDivList").jqGrid("getGridParam", "postData");
    data.srcBorgType = $("#srcMultiBorgTypeDiv").val();
    data.srcBorgNm = $("#srcMultiBorgNmDiv").val();
    data.srcClientId = $("#srcMultiClientIdDiv").val();
    data.multiSelYN  = 'Y';
    data.isWork = $("#srcMultiIsWorkDiv").val();
    data.isAcc = $("#srcMultiIsAccDiv").val();
    data.srcWork = $("#srcWorkDiv").val();
    jq("#multiBorgDivList").jqGrid("setGridParam", { "postData": data });
	$("#multiBorgDivList").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

/**
 * 사용자 선택후 Callback 호출
 */
function fnJqmSelectBuyMultiBorg() {
    var buyMultiBorgRow = jq("#multiBorgDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
    var rtnArryObj = new Array();
    
    if( buyMultiBorgRow != null ){
        var selRows = jQuery("#multiBorgDivList").jqGrid('getGridParam','selarrrow');
        
        for (var idx = 0 ; idx < selRows.length ; idx++){
            var selrowContent = jq("#multiBorgDivList").jqGrid('getRowData',selRows[idx] );
            
            rtnArryObj.push(selrowContent);
        }
        
        fnBuyMultiCallBack(rtnArryObj); 
    } else { alert("처리할 데이터을 선택해 주십시오"); }
}
</script>
</head>
<body>
    <div class="jqmBuyMultiBorgWindow" id="buyMultiBorgDialogPop">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <div id="buyMultiBorgDialogHandle">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                            <tr>
                                <td width="21">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                                </td>
                                <td width="22">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                </td>
                                <td class="popup_title">고객사 조회</td>
                                <td width="22" align="right">
                                    <a href="#" class="jqmClose">
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                    </a>
                                </td>
                                <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="right">
                                            <a href="#">
                                                <img id="srcBuyMultiBorgDivButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border: 0;' />
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                                <!-- 조회조건 -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject" width="100">고객사조직유형</td>
                                        <td class="table_td_contents">
                                            <select name="srcMultiBorgTypeDiv" id="srcMultiBorgTypeDiv">
                                                <option value="">전체</option>
                                                <option value="CLT">법인</option>
                                                <option value="BCH">사업장</option>
                                            </select>
                                        </td>
                                        <td class="table_td_subject" width="60">고객사명</td>
                                        <td class="table_td_contents">
                                            <input id="srcMultiBorgNmDiv" name="srcMultiBorgNmDiv" type="text" value="" size="20" maxlength="20" /> 
                                            <input id="srcMultiClientIdDiv" name="srcMultiClientIdDiv" type="hidden" value="" size="20" maxlength="20" />
                                            <input id="srcMultiIsWorkDiv" name="srcMultiIsWorkDiv" type="hidden" value="" size="20" maxlength="20" /> 
                                            <input id="srcMultiIsAccDiv" name="srcMultiIsAccDiv" type="hidden" value="" size="20" maxlength="20" /> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" height="1" bgcolor="eaeaea"></td>
                                    </tr>
                                    <tr>
                                        <td class="table_td_subject" width="100">고객유형</td>
                                        <td colspan="3" class="table_td_contents">
                                            <select name="srcWorkDiv" id="srcWorkDiv">
                                                <option value="">전체</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height='8'></td>
                                    </tr>
                                </table>

                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <div id="jqgrid">
                                                <table id="multiBorgDivList"></table>
                                                <div id="multiBorgDivPager"></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height='8'></td>
                                    </tr>
                                </table>

                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="center">
                                            <a href="#">
                                                <img id="buyMultiBorgSelectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_select.gif" style='border: 0;' />
                                            </a>
                                            <a href="#">
                                                <img id="buyMultiBorgCloseButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border: 0;' />
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
