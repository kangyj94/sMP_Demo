<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.product.dto.CategoryDto"%>

<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-308 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");           //화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);  //사용자 정보
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="StyleSheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.css" type="text/css"/>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	$('#productCateSave').click(function() { 
		var goods_array = new Array(); 
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			var arrRowIdx = 0 ;
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				if (jq("#isCheck_"+rowid).attr("checked")) {
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					goods_array[arrRowIdx] = selrowContent;
					arrRowIdx++;
				}
			}
			if (arrRowIdx == 0 ) {
				alert("선택한 상품이 없습니다.");
				return; 
			}
			window.opener.fnProdSearchCallBack(goods_array);
			window.close();
		}
	});
	$('#btnSearch').click(function() { fnSearch(); });
	$(window).bind('resize', function() {
		$("#list").setGridHeight(<%=listHeight %>);
		$("#list").setGridWidth(<%=listWidth %>);
	}).trigger('resize');
});

// 조회 버튼 클릭시 발생 이벤트 
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGoodIdenNumb = $('#srcGoodIdenNumb').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}


</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
//url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
var jq = jQuery;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/newCate/productListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:["key","<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'상품코드','상품명','이미지','공급사코드','공급사명','규격','과세구분','배분여부','진열여부','절대판매가','매입단가','단위','이미지여부','설명여부','상품구분','cate_Id', 'small_Img_Path'],
		colModel:[
			{name:'prod_key',index:'prod_key',width:60,align:"left",search:false,sortable:true,editable:false,key:true,hidden:true },//키
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:60,align:"left",search:false,sortable:true,editable:false },//상품코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'good_img', index:'good_img',width:30,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'vendorId',index:'vendorId',width:80,align:"left",search:false,sortable:false,editable:false },//공급사코드
			{name:'vendorNm',index:'vendorNm',width:80,align:"left",search:false,sortable:false,editable:false },//공급사명
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
			{name:'stan_buying_money',index:'stan_buying_money',width:60,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//매입단가
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
			srcGoodIdenNumb:$('#srcGoodIdenNumb').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcGoodSpecDesc:$('#srcGoodSpecDesc').val()
		},
		multiselect:true,
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,autowidth:true,
		sortname:'good_Name',sortorder:'desc',
		caption:"상품정보",
		multiselect:false,
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	
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
			}
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) { },
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
});
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
   if($("#chkAllOutputField").is(':checked')) {
	   var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
	        }
	    }
   } else {
	    var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
	        }
	    }
   }
}
</script>

</head>
<body>
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td colspan="3">
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr valign="top">
                  <td width="20" valign="middle">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                  </td>
                  <td height="29" class='ptitle'>상품검색</td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
         </td>
      </tr>
      <tr>
         <td style="vertical-align: middle;">
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
               <tr style="height: 22px">
                  <td width="20" valign="top">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                  </td>
                  <td class="stitle">상품 검색조건</td>
                  <td align="right" class="stitle">
                     <span class="ptitle">
                        <img id="btnSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" width="65" height="22" />
                     </span>
                  </td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
            <!-- 컨텐츠 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td colspan="2" class="table_top_line"></td>
               </tr>
               <tr>
                  <td class="table_td_subject" style="width: 200px;">상품코드</td>
                  <td class="table_td_contents">
                     <input id="srcGoodIdenNumb" name="srcGoodName" type="text" value="" size="" maxlength="50" style="width: 350px ; width: 90%" />
                  </td>
               </tr>
               <tr>
                  <td colspan="2" height='1' bgcolor="eaeaea"></td>
               </tr>
               <tr>
                  <td class="table_td_subject">상품명</td>
                  <td class="table_td_contents">
                     <input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" style="width: 350px ; width: 90%" />
                  </td>
               </tr>
               <tr>
                  <td colspan="2" height='1' bgcolor="eaeaea"></td>
               </tr>
               <tr>
                  <td class="table_td_subject">상품규격</td>
                  <td class="table_td_contents">
                     <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" style="width: 350px ; width: 90%"/>
                  </td>
               </tr>
               <tr>
                  <td colspan="2" class="table_top_line"></td>
               </tr>
               <tr>
                  <td colspan="2" style="height: 8px;"></td>
               </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td>
                     <div id="jqgrid">
                        <table id="list"></table>
                        <div id="pager"></div>
                     </div>
                  </td>
               </tr>
            </table>
         </td>
      </tr>
      <tr>
      	<td>&nbsp;</td>
      </tr>
      <tr>
      	<td align="center">
      		<input type="button" value="선택" id="productCateSave"/>
      		<input type="button" value="닫기" onclick="javascript:window.close();"/>
      	</td>
      </tr>
   </table>
</body>
</html>