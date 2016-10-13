<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmPostSearchWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 500px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmPostSearchWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var postSearchDivListInitCnt = 0;
$(function(){
	$("#srcPostAddrDiv").keydown(function(e){ 
		if(e.keyCode==13) { $("#srcPostButtonDiv").click(); } 
	});
	
	// Dialog Button Event
	$('#postSearchDialogPop').jqm();	//Dialog 초기화
	$("#postCloseButton").click(function(){	//Dialog 닫기
		$("#postSearchDialogPop").jqmHide();
		fnPostSearchCallback = "";
		postSearchDivListInitCnt = 0;
		$("#postDivList").jqGrid("clearGridData");
	});
	$('#postSelectButton').click(function(){
		fnJqmSelectPostAddr();
	});
	$('#srcPostButtonDiv').click(function(){
		fnPostAddressDialogPopSearch();
	});
	$('#postSearchDialogPop').jqm().jqDrag('#postSearchDialogHandle'); 
	
});

var fnPostSearchCallback = "";
function fnPostSearchDialog(callbackString) {
	$("#postSearchDialogPop").jqmShow();
	$("#srcPostAddrDiv").val("");
	fnPostSearchCallback = callbackString;
	fnPostSearchDivListInit();
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function fnPostSearchDivListInit() {
	if(postSearchDivListInitCnt>0) {
		fnPostAddressDialogPopSearch();
		return;
	}
	jq("#postDivList").jqGrid({
		datatype: 'json', mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/postSearchDivListJQGrid.sys',
		colNames:['우편번호','주소'],
		colModel:[
			{name:'post',index:'post', width:70,align:"center",sortable:false,editable:false},//우편번호
			{name:'postAddress',index:'postAddress', width:300,align:"left",search:false,sortable:false,editable:false}//주소
		],
		postData: {
			srcPostAddrDiv:$("#srcPostAddrDiv").val(),
			srcPostTypeDiv:$("#srcPostTypeDiv").val(),
			srcSido:$("#srcSido").val()
		},
		rowNum:0, rownumbers: true,
		height:200, width:455, 
		sortname: 'postAddress', sortorder: "asc",
		caption:'우편번호검색', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { postSearchDivListInitCnt++; },
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			fnJqmSelectPostAddr();
		},
		loadError : function(xhr, st, str){ $("#borgDivList").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
}

function fnPostAddressDialogPopSearch() {
	$("#srcPostAddrDiv").val($.trim($("#srcPostAddrDiv").val()));
	if($("#srcPostAddrDiv").val().length<2) {
		alert("최소 2글자 이상 입력 하셔야 합니다.");
		return;
	}
	var data = jq("#postDivList").jqGrid("getGridParam", "postData");
	data.srcPostAddrDiv = $("#srcPostAddrDiv").val();
	data.srcPostTypeDiv = $("#srcPostTypeDiv").val();
	data.srcSido = $("#srcSido").val();
	jq("#postDivList").jqGrid("setGridParam", { "postData":data });
	jq("#postDivList").trigger("reloadGrid");
}

function fnJqmSelectPostAddr() {
	var postRow = jq("#postDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( postRow != null ) {
		var selrowContent = jq("#postDivList").jqGrid('getRowData',postRow);
		var rtn_post = selrowContent.post;
		var rtn_postAddress = selrowContent.postAddress;
		eval(fnPostSearchCallback+"('"+rtn_post+"','"+rtn_postAddress+"');");
		$("#postCloseButton").click();
	} else { alert("처리할 데이터을 선택해 주십시오"); }
}

function fnNewPostAddressTd() {
	if($("#srcPostTypeDiv").val()=='OLD') {
		$("#newPostAddressTd").hide();
		$("#newComment").hide();
		$("#oldComment").show();
	} else {
		$("#newPostAddressTd").show();
		$("#newComment").show();
		$("#oldComment").hide();
	}
}
</script>
</head>

<body>
<div class="jqmPostSearchWindow" id="postSearchDialogPop">
	<table width="400"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="postSearchDialogHandle">
					<table id="popup_titlebar_mid" width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
							<td width="21"><img id="popup_titlebar_left" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47"/></td>
							<td width="22"><img id="popup_titlebar_bullet" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px "/></td>
							<td class="popup_title">우편번호검색</td>
		        			<td width="22" align="right">
		        				<a href="#" class="jqmClose">
		        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
		        				</a>
		        			</td>
		        			<td width="10" img id="popup_titlebar_right" src="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
<%-- 							<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td> --%>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td id="oldComment" align="center" bgcolor="#FFFFFF">
							* 주소지의 동/읍/면/리/건물명을 입력하십시오
						</td>
						<td id="newComment" align="center" bgcolor="#FFFFFF" style="display: none;">
							* 시도를 선택하시고 동/읍/면/리/도로명/건물명을 입력하십시오
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="middle" bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr><td class="table_top_line"></td></tr>
								<tr>
									<td>
										<table width="100%">
											<tr>
												<td>
													<select class="select" id="srcPostTypeDiv" name="srcPostTypeDiv" onchange="javascript:fnNewPostAddressTd();">
														<option value="OLD">구주소</option>
														<option value="NEW">신주소</option>
													</select>
												</td>
												<td id="newPostAddressTd" style="display: none;">
													<select class="select" id="srcSido" name="srcSido">
														<option value="서울특별시">서울특별시</option>
														<option value="경기도">경기도</option>
														<option value="인천광역시">인천광역시</option>
														<option value="대전광역시">대전광역시</option>
														<option value="경상남도">경상남도</option>
														<option value="경상북도">경상북도</option>
														<option value="대구광역시">대구광역시</option>
														<option value="부산광역시">부산광역시</option>
														<option value="울산광역시">울산광역시</option>
														<option value="강원도">강원도</option>
														<option value="충청남도">충청남도</option>
														<option value="충청북도">충청북도</option>
														<option value="광주광역시">광주광역시</option>
														<option value="전라남도">전라남도</option>
														<option value="전라북도">전라북도</option>
														<option value="제주특별자치도">제주특별자치도</option>
													</select>
												</td>
												<td>
													<input id="srcPostAddrDiv" name="srcPostAddrDiv" type="text" value="" size="30" maxlength="50" />
												</td>
												<td align="center">
													<a href="#">
								                	<img id="srcPostButtonDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style='border:0;display:'/> 
								                	</a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td class="table_top_line"></td></tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<div id="jqgPostrid">
								<table id="postDivList"></table>
							</div>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#">
										<img id="postSelectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_select.gif" style='border:0;' />
										</a>
										<a href="#">
										<img id="postCloseButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border:0;' />
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
