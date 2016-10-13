<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	@SuppressWarnings("unchecked")	
	List<ActivitiesDto> roleList           = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto        userInfoDto        = CommonUtils.getLoginUserDto(request);//사용자 정보
	String              listHeight         = "$(window).height()-350 + Number(gridHeightResizePlus)";
	String              listWidth          = "1500";
	String              menuId             = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId")); 
	String              srcResultFromYear  = "2010";//날짜 세팅
	String              srcResultFromMonth = "01";
	String              srcResultToYear    = CommonUtils.getCustomDay("MONTH",-1).substring(0, 4);
	String              menuTitle          = "매출상세정보";
	boolean             isMng              = CommonUtils.isMngUser(userInfoDto);
	
	if(isMng){
		menuTitle = "업체별 공급현황";
	} 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	//Object Event
	$("#srcButton").click( function() { fnSearch(); });
	$('#srcResultToYear').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcBorgName').keydown(function(e){ if(e.keyCode==13) { $('#btnBuyBorg').click(); }});
	$('#srcBorgName').change(function(e) { $('#srcBorgName').val('');	$('#srcGroupId').val('0'); $('#srcClientId').val('0'); $('#srcBranchId').val('0'); });
	$('#btnBuyBorg').click(function() {	fnBuyBorgSearchOpenPop(); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	//코드값 조회
	fnInitCodeData();
	
	//고객유형 리스트
	workInfoList();
});

//Component Data Bind
function fnInitCodeData() {
	var d = new Date();
	var currentYear = leadingZeros(d.getFullYear(), 4);
	for(var i=currentYear;i><%=srcResultFromYear%>-1;i--) {
		var strYear = i;
		$('#srcResultToYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
	}
	
	$('#srcResultToYear').val('<%=srcResultToYear%>');
	initList();	//그리드 초기화
}

//jqCahrt 효과
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');
</script>

<%
	/**------------------------------------고객사팝업 사용방법---------------------------------
	* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
	* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
	* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
	* borgNm : 찾고자하는 고객사명
	* callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String) 
	*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
/**
 * 고객사 팝업 호출 
 */
function fnBuyBorgSearchOpenPop(){
	var borgNm = $('#srcBorgName').val();	
	fnBuyborgDialog('CLT', '1', borgNm, 'fnCallBackBuyBorg');
}
/**
 * 사업장 콜백
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm) {
	if(groupId=='') groupId = '0';
	if(clientId=='') clientId = '0'; 
	if(branchId=='') branchId = '0'; 

	$('#srcGroupId').val(groupId);
	$('#srcClientId').val(clientId);
	$('#srcBranchId').val(branchId);
	$('#srcBorgName').val(borgNm);
}
</script>
<!--------------------------- Modal Dialog End --------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisSalesListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['업체명','사업자등록번호','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월','합계','업체Id','금액합계','CLIENTID'],
		colModel:[
			{ name:'borgnm',index:'borgnm',width:200,align:"left",search:false,sortable:false,editable:false },//업체명
			{ name:'businessNum',index:'businessNum',width:90,align:"center",search:false,sortable:false,editable:false },//사업자등록번호
			{ name:'m1',index:'m1',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//1월
			{ name:'m2',index:'m2',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//2월
			{ name:'m3',index:'m3',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//3월
			{ name:'m4',index:'m4',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//4월
			{ name:'m5',index:'m5',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//5월
			{ name:'m6',index:'m6',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//6월
			{ name:'m7',index:'m7',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//7월
			{ name:'m8',index:'m8',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//8월
			{ name:'m9',index:'m9',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//9월
			{ name:'m10',index:'m10',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//10월
			{ name:'m11',index:'m11',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//11월
			{ name:'m12',index:'m12',width:85,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//12월
			{ name:'summary_tota_amou',index:'summary_tota_amou',width:95,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//합계
			
			{ name:'borgid',index:'borgid',hidden:true,search:false },//업체Id
			{ name:'sum_sale_prod_amou',index:'sum_sale_prod_amou',width:90,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },
				hidden:true
			},//합계
			{ name:'clientid',index:'clientid',hidden:true,search:false }//법인Id
		],
		postData: {
			srcResultToYear:$('#srcResultToYear').val(),
			srcWorkInfoId:$('#srcWorkInfoId').val()
		},
		rowNum:0,rownumbers:false,
		height:<%=listHeight %>,width:<%=listWidth%>,
		sortname:'',sortorder:'',
		caption:"월별 매출실적(단위:천원)",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			var result = "";
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
 				var borgnm = selrowContent.borgnm;
 				jq("#list").setSelection(top_rowid);
<%
	if(isMng == false){
%>
				for(var i=0;i<rowCnt;i++) {
					var rowid = $("#list").getDataIDs()[i];
					var content = $("#list").jqGrid('getRowData',rowid);
  					jq("#list").setCell(rowid,'borgnm','',{color:'#0000ff'});
  					jq("#list").setCell(rowid,'borgnm','',{cursor:'pointer'});
  					for(var idx=1; idx < 13; idx++){
  						jq("#list").setCell(rowid,'m'+idx,'',{color:'#0000ff'});
  	  					jq("#list").setCell(rowid,'m'+idx,'',{cursor:'pointer'});	
  					}
  					if(i == 0){
  						var totalAmou = fnComma(Number(content.sum_sale_prod_amou));
  						result = " <b> 금액 합계 : "+ totalAmou +" 천원 </b>";
  						$("#totalAmou").html(result);
  					}
 				}
<%
	}
%>
			}
		},
		onSelectRow:function(rowid,iRow,iCol,e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var borgnm = selrowContent.borgnm;
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
<%
	if(isMng == false){
%>
	        var cm = $("#list").jqGrid("getGridParam", "colModel");
	        var colName = cm[iCol];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			
			var resultFromYear = $("#srcResultToYear").val();//해당년도
			var srcResultFromYear = $("#srcResultToYear").val();
			var srcResultFromMonth = "";
			var srcResultToYear = $("#srcResultToYear").val();
			var srcResultToMonth = "";
			if(colName['index'] == "borgnm" && colName['index'] != undefined){
				srcResultFromMonth	= "01";
				srcResultToMonth	= "12";
	        }else if(colName['index'] == "m1" && colName['index'] != undefined){
				srcResultFromMonth	= "01";
				srcResultToMonth	= "01";
	        }else if(colName['index'] == "m2" && colName['index'] != undefined){
				srcResultFromMonth	= "02";
				srcResultToMonth	= "02";
	        }else if(colName['index'] == "m3" && colName['index'] != undefined){
				srcResultFromMonth	= "03";
				srcResultToMonth	= "03";
	        }else if(colName['index'] == "m4" && colName['index'] != undefined){
				srcResultFromMonth	= "04";
				srcResultToMonth	= "04";
	        }else if(colName['index'] == "m5" && colName['index'] != undefined){
				srcResultFromMonth	= "05";
				srcResultToMonth	= "05";
	        }else if(colName['index'] == "m6" && colName['index'] != undefined){
				srcResultFromMonth	= "06";
				srcResultToMonth	= "06";
	        }else if(colName['index'] == "m7" && colName['index'] != undefined){
				srcResultFromMonth	= "07";
				srcResultToMonth	= "07";
	        }else if(colName['index'] == "m8" && colName['index'] != undefined){
				srcResultFromMonth	= "08";
				srcResultToMonth	= "08";
	        }else if(colName['index'] == "m9" && colName['index'] != undefined){
				srcResultFromMonth	= "09";
				srcResultToMonth	= "09";
	        }else if(colName['index'] == "m10" && colName['index'] != undefined){
				srcResultFromMonth	= "10";
				srcResultToMonth	= "10";
	        }else if(colName['index'] == "m11" && colName['index'] != undefined){
				srcResultFromMonth	= "11";
				srcResultToMonth	= "11";
	        }else if(colName['index'] == "m12" && colName['index'] != undefined){
				srcResultFromMonth	= "12";
				srcResultToMonth	= "12";
	        }

			var popurl = "/analysis/analysisCustomerListDetail.sys?clientId="+selrowContent.borgid+"&clientNm="+encodeURIComponent(selrowContent.borgnm)+
			"&srcResultFromYear="+srcResultFromYear+"&srcResultFromMonth="+srcResultFromMonth+"&srcResultToYear="+srcResultToYear+"&srcResultToMonth="+srcResultToMonth;
			window.open(popurl, 'okplazaPop', 'width=1000, height=600, scrollbars=yes, status=no, resizable=no');
<%
	}
%>
		},
		afterInsertRow:function(rowid, aData) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});	
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcResultToYear = $('#srcResultToYear').val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcWorkInfoId = $('#srcWorkInfoId').val();
	jq("#list").jqGrid("setGridParam", { "postData":data });
	jq("#list").trigger("reloadGrid");
}

function fnTotalAmountSum() {
	var rowCnt = jq("#list").getGridParam('reccount');
	var SumTotalamount = [];
	var msg = '';
	if(rowCnt>0) {
		for(var j=1; j<13; j++) {
			var sum = 0 ;
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				var mm = 'm'+j;
				sum += Number(jq("#list").jqGrid('getRowData',rowid)[mm]);
			}
			SumTotalamount.push(sum);
			//msg += '\n ['+j+'] value ['+SumTotalamount[Number(j)-1]+']';
			//alert(msg);
		}
	}
	jq("#list").jqGrid("footerData","set",{ borg_name:'합계'
														,m1:fnComma(SumTotalamount[0]),m2:fnComma(SumTotalamount[1]),m3:fnComma(SumTotalamount[2])
														,m4:fnComma(SumTotalamount[3]),m5:fnComma(SumTotalamount[4]),m6:fnComma(SumTotalamount[5])
														,m7:fnComma(SumTotalamount[6]),m8:fnComma(SumTotalamount[7]),m9:fnComma(SumTotalamount[8])
														,m10:fnComma(SumTotalamount[9]),m11:fnComma(SumTotalamount[10]),m12:fnComma(SumTotalamount[11]) },false);
}
function fnClearTotalAmountSum() {
	jq("#list").jqGrid("footerData","set",{ borgnm:'합계'
														,m1:'0',m2:'0',m3:'0',m4:'0',m5:'0',m6:'0',m7:'0',m8:'0',m9:'0',m10:'0',m11:'0',m12:'0' },false);
}
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)) {
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['업체명','사업자등록번호','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월','합계'];	//출력컬럼명
	var colIds = ['borgnm','businessNum','m1','m2','m3','m4','m5','m6','m7','m8','m9','m10','m11','m12','summary_tota_amou'];	//출력컬럼ID
	var numColIds = ['m1','m2','m3','m4','m5','m6','m7','m8','m9','m10','m11','m12','summary_tota_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "매출상세정보";	//sheet 타이틀
	var excelFileName = "analysisSalesList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/**
 * 고객유형 리스트를 받아오는 펑션
 */
function workInfoList() {
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/analysis/getWorkInfoList.sys',
		function(arg){
			var list = eval('(' + arg + ')').list;
			for(var i=0;i<list.length;i++) {
				$("#srcWorkInfoId").append("<option value='"+list[i].WORKID+"'>"+list[i].WORKNM+"</option>");
			}
		}
	);
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" method="post" onsubmit="return false;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="1500px" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle"><%=menuTitle %></td>
				<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
					<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
				</td>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="1500px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="80">실적년도</td>
				<td class="table_td_contents" width="250">
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select> 년
				</td>
				<td class="table_td_subject" width="80">고객법인</td>
				<td class="table_td_contents">
					<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="50" />
					<input id="srcGroupId" name="srcGroupId" type="hidden" value="0"/>
					<input id="srcClientId" name="srcClientId" type="hidden" value="0"/>
					<input id="srcBranchId" name="srcBranchId" type="hidden" value="0"/>
					<img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;border:0px;vertical-align:middle;cursor:pointer;" />
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr><td height="5"></td></tr>
<tr>
	<td>
		<table width="1500px" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top"></td>
				<td height="27px" align="right" valign="middle">
					<span id="totalAmou"></span>&nbsp;
					<button id='excelButton' class="btn btn-success btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa fa-file-excel-o"></i> 엑셀</button>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list"></table>
		</div>
	</td>
</tr>
<tr><td height="1"></td></tr>

</table>
<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
<form name="analysisCustomerListForm" id="analysisCustomerListForm" method="post" onsubmit="return false;">
	<input type="hidden" id="clientid" name="clientid" value=""/>
	<input type="hidden" id="resultFromYear" name="resultFromYear" value=""/>
	<input type="hidden" id="resultFromMonth" name="resultFromMonth" value=""/>
	<input type="hidden" id="resultToYear" name="resultToYear" value=""/>
	<input type="hidden" id="resultToMonth" name="resultToMonth" value=""/>
</form>
</body>
</html>