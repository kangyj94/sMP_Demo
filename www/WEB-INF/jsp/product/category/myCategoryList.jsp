<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List" %>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-205 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#myCategoryDelButton").click( function() { fnMyCategoryDel(); });
});

$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/category/myCategoryListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','카테고리명','cate_Id'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter
			},	//선택     
			{name:'full_Cate_Name',index:'full_Cate_Name',width:500,align:"left",search:false,sortable:false, 
				editable:false 
			},	//카테고리명
			{name:'cate_Id',index:'cate_Id' ,hidden:true
			}	//cate_Id
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,
		autowidth: true,
		sortname: 'cate_Id', sortorder: 'desc',
		caption:"마이카테고리", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow:function(rowid, aData) {
			jq("#list").setCell(rowid,'full_Cate_Name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'full_Cate_Name','',{cursor: 'pointer'});  
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iRow, iCol, e) {
			var msg = "";
			msg += "\n rowid ["+rowid+"]";
			msg += "\n iRow  ["+iRow+"]";
//  			alert(msg); 
			
 			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
 			// 고객사 상품 검색  
            $('#prdfrm').attr('action','/product/buyProductSearch.sys');
       	 	$('#prdfrm').attr('Target','_self');
			$('#prdfrm').attr('method','post');
			$('#srcCateId').val(selrowContent.cate_Id);
			$('#srcFullCateName').val(selrowContent.full_Cate_Name);
			$('#prdfrm').submit();
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
	jq("input[type='checkbox']").click(function(){	//헤더의 체크박스을 눌렀을 경우
	});  
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * list 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' offval='no' />";
}
/**
 * 관심품목 삭제 
 */
function fnMyCategoryDel(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt == 0 ) {
		$('#dialogSelectRow').html('<p>조회된 카테고리 정보가 없습니다. \n확인후 이용하사기 바랍니다.</p>');
		$("#dialogSelectRow").dialog();
		return; 
	}
	
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		var cate_Id_Array = new Array();
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				jq('#list').saveRow(rowid);
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    cate_Id_Array[arrRowIdx] =	selrowContent.cate_Id ; 
			    arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq( "#dialogSelectRow" ).dialog();
			return; 
		}
		if(!confirm("선택한 카테고리를 마이카테고리에서 삭제 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/category/delBorgUserCateGoryTranJQ.sys", 
			{ cate_Id_Array:cate_Id_Array }
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//마이카테고리
	header = "마이카테고리";
	manualPath = "/img/manual/branch/myCategory.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<body>
<form id="frm" name="frm">
<!-- 파일 선택시 인크루드된 productSearch 파일을 활용한다.  -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
		<tr>
			<td width="20" valign="middle">
				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
			</td>
			<td height="29" class="ptitle">마이카테고리
				&nbsp;<span id="question" class="questionButton">도움말</span>
			</td>
			<td align="right" valign="bottom"> 
				<img id="myCategoryDelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_categoryDelete.gif" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
			</td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
		<tr>
			<td colspan="3">
				<div id="jqgrid">
					<table id="list"></table>
					<div id="pager"></div>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
	</div>
</form>
</body>
</html>