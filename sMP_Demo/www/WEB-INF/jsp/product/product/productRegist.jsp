<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listHeight = 50;
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
});
$(window).bind('resize', function() { 
	$("#list").setGridWidth(<%=listWidth %>);
	$("#list2").setGridWidth(<%=listWidth %>);
	$("#list3").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['진열카테고리명','진열조직','사용여부'],
		colModel:[
			{name:'진열카테고리명',index:'진열카테고리명',width:350,align:"center",search:false,sortable:true, editable:false },
			{name:'진열조직', index:'진열조직',width:400,align:"center",search:false,sortable:true, editable:false },
			{name:'사용여부',index:'사용여부',width:100,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"상품진열정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['공급업체명','공급업체코드','권역','등록일','*매입단가','대표자','연락처','대표이미지등록여부','상세설명등록여부'],
		colModel:[
			{name:'공급업체명',index:'공급업체명',width:160,align:"center",search:false,sortable:true, editable:false },
			{name:'공급업체코드', index:'공급업체코드',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'권역',index:'권역',width:40,align:"center",search:false,sortable:true, editable:false },
			{name:'등록일',index:'등록일',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'매입단가',index:'매입단가',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'대표자',index:'대표자',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'연락처',index:'연락처',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'대표이미지등록여부',index:'대표이미지등록여부',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'상세설명등록여부',index:'상세설명등록여부',width:70,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager2',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"상품 공급업체 정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list2",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['진열조직','판매단가','계약시작일','계약종료일','진열상태'],
		colModel:[
			{name:'진열조직', index:'진열조직',width:300,align:"center",search:false,sortable:true, editable:false },
			{name:'판매단가',index:'판매단가',width:150,align:"center",search:false,sortable:true, editable:false },
			{name:'계약시작일',index:'계약시작일',width:150,align:"center",search:false,sortable:true, editable:false },
			{name:'계약종료일',index:'계약종료일',width:150,align:"center",search:false,sortable:true, editable:false },
			{name:'진열상태',index:'진열상태',width:130,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager3',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"상품 공급업체 정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
		jsonReader : {root: "list3",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
</script>
</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">상품상세</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품카테고리</td>
			</tr>
		</table></td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="2" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품카테고리</td>
				<td colspan="5" class="table_td_contents">
					<input id="srcLoginId14" name="srcLoginId9" type="text" value="" size="" maxlength="50" style="width:400px" class="blue" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_inquiry.gif" style="width:40px;height:18px;" align="middle" class="icon_search" /></td>
			</tr>
			<tr>
				<td colspan="2" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="2" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품진열정보</td>
				<td height="27px" align="right" valign="bottom">
					<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list"></table>
			<div id="pager"></div>
		</div>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품기본정보</td>
				<td align="right" class="stitle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" style="width:15px;height:15px;" /></td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
					<input id="srcUserNm4" name="srcUserNm4" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject" width="100">상품코드</td>
				<td class="table_td_contents">
					<input id="srcUserNm2" name="srcUserNm2" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject" width="100">과세구분</td>
				<td class="table_td_contents">
					<select id="srcIsDefault3" name="srcIsDefault3" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">수탁구분</td>
				<td class="table_td_contents">
					<select id="srcIsDefault" name="srcIsDefault" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject">수탁재고수량</td>
				<td class="table_td_contents">
					<input id="srcUserNm2" name="srcUserNm2" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject">물량배분여부</td>
				<td colspan="3" class="table_td_contents">
					<select id="srcIsDefault2" name="srcIsDefault2" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">판매가산출옵션</td>
				<td class="table_td_contents">
					<label><input type="radio" name="nation" id="local" class="radio" />매익률</label>
					<label><input type="radio" name="nation" id="foreigner" class="radio" />절대매입가</label></td>
				<td class="table_td_subject">기준매익률</td>
				<td class="table_td_contents">
					<input id="srcUserNm3" name="srcUserNm3" type="text" value="" size="20" maxlength="30" />%</td>
				<td class="table_td_subject">절대매입가</td>
				<td class="table_td_contents">
					<input id="srcUserNm5" name="srcUserNm5" type="text" value="" size="20" maxlength="30" /></td>
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
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품 공급업체 정보</td>
				<td height="27px" align="right" valign="bottom">
					<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list2"></table>
			<div id="pager2"></div>
		</div>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">공급업체 상품 이미지 및 상세 설명</td>
				<td align="right" class="stitle">&nbsp;</td>
			</tr>
		</table>
		<!-- 타이틀 시작 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">공급사</td>
				<td class="table_td_contents">
					<input id="srcLoginId11" name="srcLoginId11" type="text" value="" size="" maxlength="50" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;" align="middle" class="icon_search" /></td>
				<td class="table_td_subject" width="100">공급사코드</td>
				<td class="table_td_contents">
					<input id="srcLoginId12" name="srcLoginId12" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject" width="100">권역</td>
				<td class="table_td_contents">
					<input id="srcLoginId13" name="srcLoginId11" type="text" value="" size="" maxlength="50" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표자</td>
				<td class="table_td_contents">
					<input id="srcLoginId13" name="srcLoginId11" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject">연락처</td>
				<td class="table_td_contents">
					<input id="srcLoginId14" name="srcLoginId14" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject">하도급대상여부</td>
				<td class="table_td_contents">
					<select id="srcLoginId18" name="srcLoginId18" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">매입단가</td>
				<td class="table_td_contents">
					<input id="srcLoginId15" name="srcLoginId15" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject">단위</td>
				<td class="table_td_contents">
					<select id="srcLoginId18" name="srcLoginId18" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject">최소주문수량</td>
				<td class="table_td_contents">
					<input id="srcLoginId19" name="srcLoginId19" type="text" value="" size="" maxlength="50" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품규격</td>
				<td colspan="3" class="table_td_contents">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>Φ
								<input id="srcLoginId" name="srcLoginId" type="text" value="" size="5" maxlength="5" /></td>
							<td>W
								<input id="srcLoginId2" name="srcLoginId2" type="text" value="" size="5" maxlength="5" /></td>
							<td>D
								<input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="5" maxlength="5" /></td>
							<td>H
								<input id="srcLoginId6" name="srcLoginId6" type="text" value="" size="5" maxlength="5" /></td>
							<td>L
								<input id="srcLoginId7" name="srcLoginId7" type="text" value="" size="5" maxlength="5" /></td>
							<td>기타
								<input id="srcLoginId8" name="srcLoginId8" type="text" value="" size="5" maxlength="5" /></td>
						</tr>
					</table></td>
				<td class="table_td_subject">납품소요일</td>
				<td class="table_td_contents">
					<input id="srcLoginId17" name="srcLoginId17" type="text" value="" size="" maxlength="50" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">제조사</td>
				<td class="table_td_contents">
					<input id="srcLoginId18" name="srcLoginId18" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject">상품구분</td>
				<td class="table_td_contents">
					<select id="srcLoginId18" name="srcLoginId18" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject">제고수량</td>
				<td colspan="3" class="table_td_contents">
					<input id="srcLoginId18" name="srcLoginId18" type="text" value="" size="" maxlength="50" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">품목이미지</td>
				<td colspan="2" class="table_td_contents">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="25">
								<input id="srcLoginId7" name="srcLoginId" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
							<td width="20" height="25">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;" /></td>
						</tr>
						<tr>
							<td colspan="2" height="25">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;" />
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;" /></td>
						</tr>
					</table></td>
				<td class="table_td_subject">대표품목이미지</td>
				<td colspan="2" class="table_td_contents4">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif" style="width:100px;height:100px;" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif" style="width:70px;height:70px;" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" style="width:50px;height:50px;" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">품목상세내역<br /></td>
				<td colspan="5" class="table_td_contents4">
					<textarea name="textarea2" id="textarea2" cols="45" rows="10" style="width:730px; height:50px"></textarea></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품 동의어</td>
				<td colspan="5" class="table_td_contents">
					<table width="98%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><input id="srcLoginId10" name="srcLoginId5" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
							<td><input id="srcLoginId5" name="srcLoginId3" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
							<td><input id="srcLoginId9" name="srcLoginId4" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
							<td><input id="srcLoginId13" name="srcLoginId6" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
						</tr>
					</table></td>
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
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">현 판가정보</td>
				<td height="27px" align="right" valign="bottom">
					<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list3"></table>
			<div id="pager3"></div>
		</div>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>