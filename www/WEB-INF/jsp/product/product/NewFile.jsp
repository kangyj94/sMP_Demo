<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-308 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	//사용자 정보
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	//메뉴Id
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

   
	// 날짜 세팅
	String srcInsertStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcInsertEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	// 코드 데이터 조회 
	
	$("#srcInsertStartDate").val("<%=srcInsertStartDate%>");
	$("#srcInsertEndDate").val("<%=srcInsertEndDate%>");
	
	/*--------------------검색에 대한 처리--------------------*/
	$("#srcButton").click(function() {
		$("#srcCateId").val($.trim($("#srcCateId").val()));
		$("#srcGoodIdenNumb").val($.trim($("#srcGoodIdenNumb").val()));
		$("#srcGoodName").val($.trim($("#srcGoodName").val()));
		$("#srcInsertStartDate").val($.trim($("#srcInsertStartDate").val()));
		$("#srcInsertEndDate").val($.trim($("#srcInsertEndDate").val()));
		$("#srcGoodSpecDesc").val($.trim($("#srcGoodSpecDesc").val()));
		$("#srcGoodSameWord").val($.trim($("#srcGoodSameWord").val()));
		$("#srcGoodClasCode").val($.trim($("#srcGoodClasCode").val()));
		$("#srcGroupId").val($.trim($("#srcGroupId").val()));
		$("#srcClientId").val($.trim($("#srcClientId").val()));
		$("#srcBranchId").val($.trim($("#srcBranchId").val()));
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
	});
	$("#srcButton").click( function() { fnSearch(); });
	$('#btnSearchCategory').click(function() {
	   fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice"); 
   });
	$("#srcMajoCodeName").keydown(function(e) { if(e.keyCode==13) { $("#btnSearchCategory").click(); } });
   $('#btnEraseCategory').click(function() {
	   $("#srcMajoCodeName").val('');
	   $("#srcCateId").val('');
   });
   $("#btnBuyBorg").click(function() {
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
   $("#srcBorgName").keydown(function(e) { if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		$("#srcBorgName").val("");
		$("#srcGroupId").val("0");
		$("#srcClientId").val("0");
		$("#srcBranchId").val("0");
	});
	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e) { if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		$("#srcVendorName").val("");
		$("#srcVendorId").val("");
	});
	$("#modButton").click( function() { editRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
});
//날짜 조회 및 스타일
$(function() {
	$("#srcInsertStartDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcInsertEndDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');


function fnDataInit(){
	$.post(  //조회조건의 신규품목요청상태 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {codeTypeCd:"ORDERGOODSTYPE", isUse:"1"},
         function(arg){
            var codeList = eval('(' + arg + ')').codeList;
            for(var i=0;i<codeList.length;i++) {
               $("#srcGoodClasCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
            }
            initList(); //그리드 초기화
         }
      );	
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품코드','상품명','이미지','카테고리','규격','과세구분','배분여부','진열여부','매입단가','단위','이미지여부','설명여부','상품구분','cate_Id', 'small_Img_Path'],
		colModel:[
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:60,align:"left",search:false,sortable:true,editable:false,key:true,
// 				onSelectCell:function(rowid, celname,value, iRow, iCol){
// 					alert(celname);
// 				},
				classes: 'pointer'
			},//상품코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'good_img', index:'good_img',width:30,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'full_Cate_Name',index:'full_Cate_Name',width:220,align:'left',search:false,sortable:false,editable:false },//카테고리명
			{name:'good_Spec_Desc',index:'good_Spec_Desc',width:60,align:"left",search:false,sortable:false,editable:false },//규격
			{name:'vtax_Clas_Code',index:'vtax_Clas_Code',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:과세10%;20:영세율;30:면세"}
			},//과세구분
			{name:'isDistribute',index:'isDistribute',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:Y;0:N"}
			},//물량배분여부
			{name:'isDispPastGood',index:'isDispPastGood',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:진열;0:미진열"}
			},//과거상품진열여부
			{name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:60,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//매입단가
			{name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//대표이미지여부
			{name:'isSetDesc',index:'isSetDesc',width:60,align:"center",search:false,sortable:false,editable:false },//상품설명여부
			{name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:일반;20:지정;30:수탁"}
			},//상품구분
			{name:'cate_Id',index:'cate_Id',hidden:true,search:false },
			{name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false }
		],
		postData: {
			srcCateId:$('#srcCateId').val(),
			srcGoodIdenNumb:$('#srcGoodIdenNumb').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcInsertStartDate:$('#srcInsertStartDate').val(),
			srcInsertEndDate:$('#srcInsertEndDate').val(),
			srcGoodSpecDesc:$('#srcGoodSpecDesc').val(),
			srcGoodSameWord:$('#srcGoodSameWord').val(),
			srcGoodClasCode:$('#srcGoodClasCode').val(),
			srcGroupId:$('#srcGroupId').val(),
			srcClientId:$('#srcClientId').val(),
			srcBranchId:$('#srcBranchId').val(),
			srcVendorId:$('#srcVendorId').val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,autowidth:true,
		sortname:'good_Name',sortorder:'desc',
		caption:"상품정보",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			
			// 품목 규격 설정 
			var prodSpcNm = new Array();
		   <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
		   <% }                                                                       %>
			
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				// 규격 화면 로드 
				var argArray = selrowContent.good_Spec_Desc.split(" ");
				var prodSpec = "";
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
					if(argArray[jIdx] > ' ') {
				         prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
					}
				}
				jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodSpec});
				
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:30px;height:30px;' />";	
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
				
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
				
				// 상세 링크 
// 				var aTag = "<a href='javascript:editRow("+selrowContent.good_Iden_Numb+");'>"+selrowContent.good_Iden_Numb+"</a>";	
// 				jQuery('#list').jqGrid('setRowData',rowid,{good_Iden_Numb:aTag});
			}
		},
// 		onSelectRow:function(rowid,iRow,iCol,e) {
// 			alert();
// 			var cm = $("#list").jqGrid('getGridParam','colModel');
// 			alert(cm[iCol].name);
// 		},
		
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol].index == 'good_Iden_Numb'){
				editRow(rowid);
			}
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
// 그리드 커서 
function pointercursor(cellvalue, options, rowObject){ 
	var new_formatted_cellvalue = '<span class="pointer">' + cellvalue + '</span>'; 
	return new_formatted_cellvalue; 
}

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCateId = $('#srcCateId').val();
	data.srcGoodIdenNumb = $('#srcGoodIdenNumb').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcInsertStartDate = $('#srcInsertStartDate').val();
	data.srcInsertEndDate = $('#srcInsertEndDate').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	data.srcGoodSameWord = $('#srcGoodSameWord').val();
	data.srcGoodClasCode = $('#srcGoodClasCode').val();
	data.srcGroupId = $('#srcGroupId').val();
	data.srcClientId = $('#srcClientId').val();
	data.srcBranchId = $('#srcBranchId').val();
	data.srcVendorId = $('#srcVendorId').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
	var msg = ""; 
	msg += "\n categortId value ["+categortId+"]"; 
	msg += "\n categortName value ["+categortName+"]";
	msg += "\n categortFullName value ["+categortFullName+"]";
	$('#srcCateId').val(categortId); 
	$('#srcMajoCodeName').val(categortFullName); 
}
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm) {
	if(groupId=="") groupId = "0";
	if(clientId=="") clientId = "0"; 
	if(branchId=="") branchId = "0"; 
	
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorName").val(vendorNm);
}

function editRow(rowid) {
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
		var goodIdenNumb = selrowContent.good_Iden_Numb;
		var popurl = "/product/productDetail.sys?_menuId="+<%=menuId %>+"&goodIdenNumb="+goodIdenNumb;
		var popproperty = "dialogWidth:950px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
		window.showModalDialog(popurl,null,popproperty);
// 		window.open(popurl, 'okplazaPop', 'width=950, height=700, scroll=yes, status=no, resizable=no');
}
function exportExcel() {
	var colLabels = ['상품코드','상품명','카테고리','과세구분','배분여부','진열여부','매입단가','규격','단위','이미지여부','설명여부','상품구분'];	//출력컬럼명
	var colIds = ['good_Iden_Numb','good_Name','full_Cate_Name','vtax_Clas_Code','isDistribute','isDispPastGood','sale_Unit_Pric','good_Spec_Desc','orde_Clas_Code','isSetImage','isSetDesc','good_Clas_Code'];	//출력컬럼ID
	var numColIds = ['sale_Unit_Pric'];	//숫자표현ID
	var sheetTitle = "상품정보";	//sheet 타이틀
	var excelFileName = "GoodList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<body>
   <form id="frm" name="frm" method="post">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     </td>
                     <td height="29" class="ptitle">상품조회</td>
                     <td align="right" class="ptitle">
                        <a href="#">
                           <img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width:65px;height:22px;border:9px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
                        </a>
                     </td>
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
                     <td class="table_td_subject">카테고리</td>
                     <td colspan="5" class="table_td_contents">
                        <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0; return false;}" /> <input
                           id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                        <a href="#">
                           <img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                        <a href="#">
                           <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">상품코드</td>
                     <td class="table_td_contents">
                        <input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="" size="" maxlength="50" />
                     </td>
                     <td class="table_td_subject" width="100">상품명</td>
                     <td class="table_td_contents">
                        <input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" />
                     </td>
                     <td class="table_td_subject" width="100">등록일</td>
                     <td class="table_td_contents">
                        <input id="srcInsertStartDate" name="srcInsertStartDate" type="text" style="width: 75px;" /> ~ <input id="srcInsertEndDate" name="srcInsertEndDate" type="text" style="width: 75px;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">상품규격</td>
                     <td class="table_td_contents">
                        <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" />
                     </td>
                     <td class="table_td_subject">상품동의어</td>
                     <td class="table_td_contents">
                        <input id="srcGoodSameWord" name="srcGoodSameWord" type="text" value="" size="" maxlength="50" />
                     </td>
                     <td class="table_td_subject">상품구분</td>
                     <td class="table_td_contents">
                        <select id="srcGoodClasCode" name="srcGoodClasCode" style="width: 80px;" class="select">
                           <option value="">전체</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">진열조직</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="srcBorgName" name="srcBorgName" type="text" value="" size="" maxlength="50" style="width: 400px;" class="blue" /> <input id="srcGroupId" name="srcGroupId" type="hidden" value="0" /> <input id="srcClientId"
                           name="srcClientId" type="hidden" value="0" /> <input id="srcBranchId" name="srcBranchId" type="hidden" value="0" />
                        <a href="#">
                           <img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" />
                        </a>
                     </td>
                     <td class="table_td_subject">공급사</td>
                     <td class="table_td_contents">
                        <%
                           if ("ADM".equals(userInfoDto.getSvcTypeCd())) {
                        %>
                        <input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" /> <input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
                        <a href="#">
                           <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" <%=CommonUtils.getDisplayRoleButton(roleList,
                  "COMM_SAVE")%>" />
                        </a>
                     </td>
                     <%
                        } else {
                     %>
                     <input id="srcVendorName" name="srcVendorName" type="text" value="<%=userInfoDto.getBorgNm()%>" disabled="disabled" style="border: none;" class="blue" />
                     <input id="srcVendorId" name="srcVendorId" type="hidden" value="<%=userInfoDto.getBorgId()%>" />
                     </td>
                     <%
                        }
                     %>
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
            <td align="right" valign="bottom">
               <a href="#">
                  <img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
               </a>
               <a href="#">
                  <img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
               </a>
               <a href="#">
                  <img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
               </a>
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
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <%
         /**------------------------------------ 표준카테고리 조회 시작 ---------------------------------
          * fnSearchStandardCategoryInfo(isLastChoice,callbackString ) 을 호출하여 Div팝업을 Display ===
          * 
          * choiceCategoryLevel : 선택가능한 카테고리 레벨을 선택 한다. 
          *                        ex) "1" : 1레벨 부터 하위 래벨 선택 가능 
          *                            "2" : 2레벨 부터 하위 레벨 선택 가능 
          *                            "3" : 3레벨 부터 하위 레벨 선택 가능 
          * callbackString : 콜백 메소드 명을 기입 
          *                  파라미터 정보  (1.categoryseq ,2.카테고리명 ,3.풀카테고리명 )  
          */
      %>
      <%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
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
      <%
         /**------------------------------------공급사팝업 사용방법---------------------------------
          * fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
          * borgNm : 찾고자하는 공급사명
          * callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
          */
      %>
      <%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>