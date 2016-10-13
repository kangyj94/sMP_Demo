<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int treelistWidth = 300;
	String treelistHeight = "$(window).height()-275 + Number(gridHeightResizePlus)";
	String listHeight = "$(window).height()-380 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;

$(window).bind('resize', function() { 
	$("#treeList").setGridHeight(<%=treelistHeight%>);
	$("#list").setGridHeight(<%=listHeight%>);
//     $("#list").setGridWidth($(window).width()-365 + Number(gridWidthResizePlus));
    $("#list").setGridWidth(1185);
}).trigger('resize');

jq(function() {
    $.ajaxSetup ({
        cache: false
    });
    $('#srcButton').click(function (e) {
        fnSearch();
    });
    $('#frmSearch').search();
	//표준카테고리 Grid
	jq("#treeList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/category/categoryTreeJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['카테고리명','카테고리CD','카테고리설명','진열순서','레벨','treeKey','상위카테고리Seq','level','','','isLeaf'],
		colModel:[
			{name:'majo_Code_Name',index:'majo_Code_Name',width:220,align:'left',search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:'20',maxLength:'30'}
			},//카테고리명
			{name:'cate_Cd',index:'cate_Cd',width:70,align:'left',search:false,sortable:false,
				editable:true,editrules:{custom:true,custom_func:fnCateCdCheck},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:'14',maxLength:'10',dataInit:function(elem) {
					$(elem).css("ime-mode","disabled"); $(elem).css("text-transform","uppercase");}}
			},//카테고리CD
			{name:'mojo_Code_Desc',index:'mojo_Code_Desc',width:70,align:'left',search:false,sortable:false,hidden:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:'20',maxLength:'30'}
			},//카테고리설명
			{name:'ord_Num',index:'ord_Num',width:70,align:'center',search:false,sortable:false,hidden:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{ size:"2",maxLength:"2", dataInit:function(elem) {
					$(elem).numeric();
					$(elem).css("ime-mode", "disabled");
					if($(elem).val()=='') $(elem).val(0);
				}}
			},//진열순서
			{name:'typeName',index:'typeName',width:40,align:'center',search:false,sortable:false,hidden:false,editable:false },//레벨
			
			{name:'treeKey',index:'treeKey',hidden:true,key:true },
			{name:'ref_Cate_Seq',index:'ref_Cate_Seq',hidden:true },//상위카테고리Seq
			{name:'level',index:'level',hidden:true },
            {name:'cate_Id',index:'cate_Id',hidden:true },
            {name:'full_Cate_Name',index:'full_Cate_Name',hidden:true },
			{name:'isLeaf',index:'isLeaf',hidden:true }
		],
		rowNum:0,rownumbers:false,
		treeGridModel:'adjacency',
		height:<%=treelistHeight%>,width:<%=treelistWidth%>,
		treeGrid:true,hoverrows:false,
		ExpandColumn:'majo_Code_Name',ExpandColClick:true,
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		gridComplete: function() {
			var rData = $("#treeList").jqGrid('getGridParam','data');
			if(rData[0]) {
				setTimeout(function() {
					//for(i=0;i<rData.length;i++) {
					for(var i=0;i<1;i++) {
						$("#treeList").jqGrid('expandRow',rData[i]);
						$("#treeList").jqGrid('expandNode',rData[i]);
					}
				}, 0);
			}
		},
		loadComplete:function() {},
		onSelectRow:function (rowid,iRow,iCol,e) {
            var data = $(this).jqGrid('getRowData',rowid);
            $('#srcCateName').val(data.full_Cate_Name);
            $('#srcCateId').val(data.cate_Id);
            fnSearch();
		},
		loadError:function(xhr,st,str){ $("#treeList").html(xhr.responseText); },
		jsonReader:{ root:"treeList",repeatitems:false,cell:"cell" }
	});
	//진열정보 Grid
    $("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectProductList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품코드','구분','유형','상품명','규격','공급사','판매가','매입가','재고량','물량배분','표준 납기일','등록일','담당자',''],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:80,align:'center'},//상품코드
            {name:'GOOD_TYPE_NM',width:40,align:'center'},//구분
            {name:'REPRE_GOOD',width:40,align:'center'},//유형
            {name:'GOOD_NAME',width:160},//상품명
            {name:'GOOD_SPEC',width:120},//규격
            {name:'VENDORNM',width:120},//공급사
            {name:'SELL_PRICE',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매가
            {name:'SALE_UNIT_PRIC',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입가
            {name:'GOOD_INVENTORY_CNT',width:40,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//재고량
            {name:'ISDISTRIBUTENM',width:50,align:'center'},//물량배분
            {name:'DELI_MINI_DAY',width:35,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//표준 납기일
            {name:'INSERT_DATE',width:70,align:'center'},//등록일
            {name:'PRODUCT_MANAGER',width:130},//담당자
            {name:'VENDORID',hidden:true}//VENDORID
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,autowidth:true,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'GOOD_NAME','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GOOD_NAME") {
                var url = '/product/popProductAdm.sys?good_iden_numb=' + selrowContent.GOOD_IDEN_NUMB + '&vendorid=' + selrowContent.VENDORID;
                window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
            }
        }
    })
    .jqGrid("setLabel", "rn", "순번");
});
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnCateCdCheck(value, colname) {
	var oper = $("#textCateState").val();
	var row = jq("#treeList").jqGrid('getGridParam','selrow');
  	if(row != null) {
  		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		if(oper == "add") {
			if(tmpLevel==0) {
				if(value.length != 4) {
					return [false,"대 카테고리CD는 4자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==1) {
				if(value.length != 7) {
					return [false,"중 카테고리CD는 7자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==2) {
				if(value.length != 10) {
					return [false,"소 카테고리CD는 10자리입니다."]; 
				} else {
					return [true,""];
				}
			}
		} else if(oper == "edit") {
			if(tmpLevel==1) {
				if(value.length != 4) {
					return [false,"대 카테고리CD는 4자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==2) {
				if(value.length != 7) {
					return [false,"중 카테고리CD는 7자리입니다."]; 
				} else {
					return [true,""];
				}
			} else if(tmpLevel==3) {
				if(value.length != 10) {
					return [false,"소 카테고리CD는 10자리입니다."]; 
				} else {
					return [true,""];
				}
			}
		}
  	}
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
<tr>
	<td colspan="3">
		<!-- 타이틀 시작 -->
		<table width="1500px" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">카테고리관리</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td width="300" valign="top">
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">표준카테고리정보</td>
				<td>
					<div id="jqgridExcel">
						<table id="treeListExcel"></table>
					</div>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
		<table width="100%" border="0" cellpadding="0" cellspacing="0" id="그리드 영역표시">
			<tr>
				<td valign="top" bgcolor="#CCCCCC">
					<div id="jqgrid">
						<table id="treeList"></table>
					</div>
				</td>
			</tr>
		</table></td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td valign="top">
		<!-- 타이틀 시작 -->
		<table width="1185px" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품조회</td>
                <td align="right" style="vertical-align: bottom;padding-bottom: 1px;">
					<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
			     </td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
		<!-- 컨텐츠 시작 -->
		<form id="frmSearch">
		<table width="1185px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
            <tr>
                <td class="table_td_subject" width="100">카테고리</td>
                <td class="table_td_contents" colspan=3>
                    <input id="srcCateName" name="srcCateName" type="text" style="width:80%;" disabled />
                    <input id="srcCateId" name="srcCateId" type="hidden" />
                </td>
            </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품코드</td>
				<td class="table_td_contents">
					<input type="text" name="srcGoodIdenNumb" style="width:80%;" class="blue" />
				</td>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
                    <input type="text" name="srcGoodName" style="width:80%;" class="blue" />
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
                <tr><td height="10"></td></tr>
		</table>
		</form>
		<!-- 컨텐츠 끝 -->
		<table width="1185px" border="0" cellpadding="0" cellspacing="0" id="그리드 영역표시2">
			<tr>
				<td align="left">
					<div id="jqgrid">
						<table id="list"></table>
                        <div id="pager"></div>
					</div>
				</td>
			</tr>
		</table>

		</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<!-------------------------------- Dialog Div Start -------------------------------->
<%@ include file="/WEB-INF/jsp/product/category/svcDisplayRegistDiv.jsp" %>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>