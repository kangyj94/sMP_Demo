<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpBranchsDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
   //그리드의 width와 Height을 정의
   String listHeight = "50";

   @SuppressWarnings("unchecked")   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
   SmpBranchsDto detailDto = (SmpBranchsDto)request.getAttribute("detailInfo");
   
   String file_biz_reg_list = detailDto.getBusinessAttachFileSeq() == null ? "" : detailDto.getBusinessAttachFileSeq();
   String file_app_sal_list = detailDto.getAppraisalAttachFileSeq() == null ? "" : detailDto.getAppraisalAttachFileSeq();
   String file_list1 = detailDto.getEtcFirstSeq() == null ? "" : detailDto.getEtcFirstSeq();
   String file_list2 = detailDto.getEtcSecondSeq() == null ? "" : detailDto.getEtcSecondSeq();
   String file_list3 = detailDto.getEtcThirdSeq() == null ? "" : detailDto.getEtcThirdSeq();
   
   String attach_file_biz_reg_name = detailDto.getBusinessAttachFileNm() == null ? "" : detailDto.getBusinessAttachFileNm();
   String attach_file_app_sal_name = detailDto.getAppraisalAttachFileNm() == null ? "" : detailDto.getAppraisalAttachFileNm();
   String attach_file_name1 = detailDto.getEtcFirstNm() == null ? "" : detailDto.getEtcFirstNm();
   String attach_file_name2 = detailDto.getEtcSecondNm() == null ? "" : detailDto.getEtcSecondNm();
   String attach_file_name3 = detailDto.getEtcThirdNm() == null ? "" : detailDto.getEtcThirdNm();
   
   String attach_file_biz_reg_path = detailDto.getBusinessAttachFilePath() == null ? "" : detailDto.getBusinessAttachFilePath();
   String attach_file_app_sal_path = detailDto.getAppraisalAttachFilePath() == null ? "" : detailDto.getAppraisalAttachFilePath();
   String attach_file_path1 = detailDto.getEtcFirstPath()== null ? "" : detailDto.getEtcFirstPath();
   String attach_file_path2 = detailDto.getEtcSecondPath()== null ? "" : detailDto.getEtcSecondPath();
   String attach_file_path3 = detailDto.getEtcThirdPath()== null ? "" : detailDto.getEtcThirdPath();
   String sharpMail = detailDto.getSharp_mail() == null ? "":detailDto.getSharp_mail();
   LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	boolean roleCd = false;
	for(int i=0; i<userInfoDto.getLoginRoleList().size(); i++){
		if("MRO_ADMIN002".equals(userInfoDto.getLoginRoleList().get(i).getRoleCd()) || "ADM_ACC_MAN".equals(userInfoDto.getLoginRoleList().get(i).getRoleCd())){
			roleCd = true;
		}
	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%-- <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> --%>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />

<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>

<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jqgrid.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("#saveButton").click(function(){
		fnApply(); 
	});
	$("#borgUserExcelButton").click(function(){ exportBorgUserExcel(); });
	
	buyDisabled();
	admDisabled();
	$("#deliveryInfoExcelButton").click(function(){
		deliveryInfoExcel();
	});
});
</script>
<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#addUserButton").click(function(){
		var clientId = "";
		
		if('<%=userInfoDto.getSvcTypeCd()%>' != "ADM"){
			clientId = '<%=detailDto.getClientId()%>';
		}
		
		fnJqmUserInitSearch("", "", "BUY", "fnSelectUserCallback", clientId, '<%=detailDto.getClientNm().substring(0 , detailDto.getClientNm().indexOf("&gt;")).replace("&gt;", "")%>');
	});
	
	$("#delUserButton").click(function(){
		var id = $("#list2").jqGrid('getGridParam', "selrow" );
		
		if(id == null || id == '') {
			alert("삭제할 사용자를 선택해주세요.");
			return;
		}
		
		if(!confirm("해당사용자를 삭제하시겠습니까?")) return;
		var selrowContent = jq("#list2").jqGrid('getRowData',id);
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveBorgsUsers.sys", 
			{
				oper:'del',
				userId:selrowContent.userId,
				borgId:'<%=detailDto.getBranchId()%>'
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
					jq("#list2").trigger("reloadGrid");
				}
			}
		);
	});
});

/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms, mobile) {

   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveBorgsUsers.sys", 
      { oper:'add', loginId:loginId, userId:userId, borgId:'<%=detailDto.getBranchId()%>' ,isDefault:'0' },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list2").trigger("reloadGrid");
         }
      }
   );
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#btnBizRegAttach").click(function(){ fnUploadDialog("사업자등록첨부", $("#file_biz_reg_list").val(), "fnCallBackAttachBizReq"); });
   $("#btnAppSalAttach").click(function(){ fnUploadDialog("신용평가서첨부", $("#file_app_sal_list").val(), "fnCallBackAttachAppSal"); });
   $("#btnAttach1").click(function(){ fnUploadDialog("통장사본첨부", $("#file_list1").val(), "fnCallBackAttach1"); });
   $("#btnAttach2").click(function(){ fnUploadDialog("기타첨부1", $("#file_list2").val(), "fnCallBackAttach2"); });
   $("#btnAttach3").click(function(){ fnUploadDialog("기타첨부2", $("#file_list3").val(), "fnCallBackAttach3"); });
   
   //고객사로 로그인시 주문제한 만기일 감추기
<%if("BUY".equals(userInfoDto.getSvcTypeCd())){ %>
   $("#expirationDate").hide();
<%}%>
   //계약구분 펑션
   fnContractSpecial();
});

/**
 * 사업자등록첨부 파일관리
 */
function fnCallBackAttachBizReq(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_biz_reg_list").val(rtn_attach_seq);
   $("#attach_file_biz_reg_name").text(rtn_attach_file_name);
   $("#attach_file_biz_reg_path").val(rtn_attach_file_path);
}

/**
 * 사업자등록첨부 파일관리
 */
function fnCallBackAttachAppSal(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_app_sal_list").val(rtn_attach_seq);
   $("#attach_file_app_sal_name").text(rtn_attach_file_name);
   $("#attach_file_app_sal_path").val(rtn_attach_file_path);
}

/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list1").val(rtn_attach_seq);
   $("#attach_file_name1").text(rtn_attach_file_name);
   $("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list2").val(rtn_attach_seq);
   $("#attach_file_name2").text(rtn_attach_file_name);
   $("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list3").val(rtn_attach_seq);
   $("#attach_file_name3").text(rtn_attach_file_name);
   $("#attach_file_path3").val(rtn_attach_file_path);
}

/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
   
   var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
   var data = "attachFilePath="+attach_file_path;
   $.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>
<% //------------------------------------------------------------------------------ %>


<%
/**------------------------------------배송처정보 사용방법---------------------------------
* fnDeliveryAddressDialog(callbackString) 을 호출하여 Div팝업을 Display ===
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(배송지명, 전화번호, 우편번호, 기본주소, 상세주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#regButton").click(function(){
      fnDeliveryAddressDialog("fnCallBackDeliveryAddressSet"); 
   });

   $("#delButton").click(function(){
      fnDeliveryDelete(); 
   });
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressSet(shippingPlace, shippingPhoneNum, shippingPost, shippingAddress, shippingAddressDesc) {
   var shippingAddres = shippingPost+" "+shippingAddress+" "+shippingAddressDesc;
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveDeliveryInfo.sys", 
      { 
           oper:'add'
         , shippingPlace:shippingPlace
         , shippingPhoneNum:shippingPhoneNum
         , shippingAddres:shippingAddres
         , groupId:'<%=detailDto.getGroupId()%>'
         , branchId:'<%=detailDto.getBranchId()%>'
         , clientId:'<%=detailDto.getClientId()%>'
      },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");              
         }
      }
   ); 
   //addRow(shippingPlace, shippingPhoneNum, shippingPost+" "+shippingAddress+" "+shippingAddressDesc);
}

function fnDeliveryDelete() {
   var id = $("#list").jqGrid('getGridParam', "selrow" );  
   var selrowContent = jq("#list").jqGrid('getRowData',id); 
   
   if(id == null) {
      $("#dialog").html("<font size='2'>삭제할 데이터를 선택해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });                  
      return;
   }
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveDeliveryInfo.sys", 
      { oper:'del', deliveryId:selrowContent.deliveryId },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");              
         }
      }
   ); 
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------우편번호검색 사용방법---------------------------------
* fnPostSearchDialog(callbackString) 을 호출하여 Div팝업을 Display ===
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 기본주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/postSearchDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#btnPost").click(function(){
      fnPostSearchDialog("fnCallBackPostAddress"); 
   });
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackPostAddress(post, postAddress) {
   $("#postAddrNum").val(post);
   $("#addres").val(postAddress);
   $("#addresDesc").focus();
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
// $(document).ready(function() {
//    fnStatChange();
// });

//리사이징
// $(window).bind('resize', function() { 
//     $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
//     $("#list2").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/getDeliveryInfoList.sys',
      datatype: 'json',
      mtype: 'POST',
      colNames:['deliveryId', '배송지명', '배송지 전화번호', '배송지 주소'],
      colModel:[
         {name:'deliveryId',index:'deliveryId', width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
         {name:'shippingPlace',index:'shippingPlace', width:150,align:"left",search:false,sortable:true, editable:false },
         {name:'shippingPhoneNum',index:'shippingPhoneNum', width:200,align:"left",search:false,sortable:true, editable:false },
         {name:'shippingAddres',index:'shippingAddres', width:480,align:"left",search:false,sortable:true, editable:false }
      ],
      postData: {branchId:'<%=detailDto.getBranchId()%>'},
      rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      height: <%=listHeight%>,autowidth: true,
      caption:"배송처 정보", 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {},
      onSelectRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){},
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   }); 
});

jq(function() {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organBorgUserJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['borgId', '사용자명', '사용자ID', '상태', '전화번호', '이동전화번호', '등록일','userid', 'roleId'],
		colModel:[
			{name:'borgId',index:'borgId', width:90,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'userNm',index:'userNm', width:90,align:"left",search:false,sortable:true, editable:false },
			{name:'loginId',index:'loginId', width:90,align:"left",search:false,sortable:true, editable:false },
			{name:'isUse',index:'isUse', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'tel',index:'tel', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'mobile',index:'mobile', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'createDate',index:'createDate', width:90,align:"center",search:false,sorttype:"date", editable:false,formatter:"date" },
			{name:'userId',index:'userId', hidden:true, editable:false },
			{name:'roleId',index:'roleId', hidden:true, editable:false }
		],
		postData: {borgId:'<%=detailDto.getBranchId()%>'},
		rowNum:0, rownumbers: false,
		height: 130,autowidth: true,
		caption:"소속사용자", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnStatChange(){
	var isUse = $("#isUse").val();
   
   if(isUse == "1"){
      $("#closeReason").attr("disabled", true);
      $("#closeReason").val("");
   }else if(isUse == "0"){
      $("#closeReason").attr("disabled", false);
   }
}
fnStatChange();
function fnIsValidation(){
    
    var clientNm = $.trim($("#clientNm").val());
    var clientCd = $.trim($("#clientCd").val());
    var businessNum1 = $.trim($("#businessNum1").val());
    var businessNum2 = $.trim($("#businessNum2").val());
    var businessNum3 = $.trim($("#businessNum3").val());
//     var registNum1 = $.trim($("#registNum1").val());
//     var registNum2 = $.trim($("#registNum2").val());
    var branchBusiType = $.trim($("#branchBusiType").val());
    var branchBusiClas = $.trim($("#branchBusiClas").val());
    var pressentNm = $.trim($("#pressentNm").val());
    var phoneNum = $.trim($("#phoneNum").val());
    var eMail = $.trim($("#eMail").val());
    var postAddrNum = $.trim($("#postAddrNum").val());
    var addres = $.trim($("#addres").val());
    var file_biz_reg_list = $.trim($("#file_biz_reg_list").val());
    var areaType = $.trim($("#areaType").val());
    var branchGrad = $.trim($("#branchGrad").val());
    var payBillType = $.trim($("#payBillType").val());
    var payBillDay = $.trim($("#payBillDay").val());
    var accountManageNm = $.trim($("#accountManageNm").val());
    var accountTelNum = $.trim($("#accountTelNum").val());
    
    //var bankCd = $.trim($("#bankCd").val());
    //var recipient = $.trim($("#recipient").val());
    //var accountNum = $.trim($("#accountNum").val());
    
//     var loginId    = $.trim($("#loginId").val());   
//     var pwd        = $.trim($("#pwd").val());       
//     var pwdConfirm = $.trim($("#pwdConfirm").val());
//     var userNm     = $.trim($("#userNm").val());    
//     var tel        = $.trim($("#tel").val());       
//     var mobile     = $.trim($("#mobile").val());    
//     var userEmail  = $.trim($("#userEmail").val());
	var autOrderLimitPeriod = $.trim($("#autOrderLimitPeriod").val());
	
	var srcContractSpecial = $("#srcContractSpecial").val();//물품공급계약구분
	var ebillEmail = $("#ebillEmail").val();//세금계산서이메일
	
// 	var sharpMail = $.trim($("#sharpMail").val());
    
	if(autOrderLimitPeriod == ""){
    	$("#autOrderLimitPeriod").html("<font size='2'>주문제한 만기일을 입력해주세요</font>");
        $("#autOrderLimitPeriod").dialog({
           title: 'Success',modal: true,
           buttons: {"Ok": function(){$(this).dialog("close");} }
        });                
        return false;	
    }
	
    if(clientNm == ""){
      $("#dialog").html("<font size='2'>법인명을 입력해주세요.</font>");
      $("#dialog").dialog({
         title: 'Success',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });                
      return false;
    }

//     if(clientCd == ""){
       
//       $("#dialog").html("<font size='2'>법인코드를 입력해주세요.</font>");
//       $("#dialog").dialog({
//          title: 'Success',modal: true,
//          buttons: {"Ok": function(){$(this).dialog("close");} }
//       });                         
//        return false;
//     }
    
    if(businessNum1 == "" || businessNum2 == "" || businessNum3 == ""){
       $("#dialog").html("<font size='2'>사업자 등록번호를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
//     if(registNum1 == "" || registNum2 == ""){
//        $("#dialog").html("<font size='2'>법인 등록번호를 입력해주세요.</font>");
//        $("#dialog").dialog({
//           title: 'Success',modal: true,
//           buttons: {"Ok": function(){$(this).dialog("close");} }
//        });         
//        return false;
//     }  
    
    if(branchBusiType == ""){
       $("#dialog").html("<font size='2'>업종을 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
   
    if(branchBusiClas == ""){
       $("#dialog").html("<font size='2'>업태를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(pressentNm == ""){
       $("#dialog").html("<font size='2'>대표자명을 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(phoneNum == ""){
       $("#dialog").html("<font size='2'>대표 전화번호를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(eMail == ""){
       $("#dialog").html("<font size='2'>E-MAIL을 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }else{
       email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
       if(!email_regex.test(eMail)){
          $("#dialog").html("<font size='2'>E-MAIL 유형을 확인해주세요.</font>");
          $("#dialog").dialog({
             title: 'Success',modal: true,
             buttons: {"Ok": function(){$(this).dialog("close");} }
          });            
          return false; 
       }
    }
    
    if(postAddrNum == "" || addres == ""){
       $("#dialog").html("<font size='2'>주소를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(file_biz_reg_list == ""){
       
       $("#dialog").html("<font size='2'>사업자등록첨부를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }

    if(areaType == ""){
       $("#dialog").html("<font size='2'>권역을 선택해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }

    if(branchGrad == ""){
       $("#dialog").html("<font size='2'>회원사등급을 선택해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(payBillType == ""){
       $("#dialog").html("<font size='2'>결제조건을 선택해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(accountManageNm == ""){
       $("#dialog").html("<font size='2'>회계담당자명을 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(accountTelNum == ""){
       $("#dialog").html("<font size='2'>회계이동전화번호를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    /*
    if(bankCd == ""){
       $("#dialog").html("<font size='2'>은행코드를 선택해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(recipient == ""){
       $("#dialog").html("<font size='2'>예금주명을 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    
    if(accountNum == ""){
       $("#dialog").html("<font size='2'>계좌번호를 입력해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;
    }
    */
    
    //계약구분 유효성
    if('ADM' == '<%=userInfoDto.getSvcTypeCd()%>'){
    	if(srcContractSpecial == ""){
            $("#dialog").html("<font size='2'>계약구분을 선택해주세요.</font>");
            $("#dialog").dialog({
               title: 'Success',modal: true,
               buttons: {"Ok": function(){$(this).dialog("close");} }
            });         
            return false;
         }
    }
// 	if(sharpMail == ""){
// 		$("#dialog").html("<font size='2'>SHARP-MAIL을 입력해주세요.</font>");
// 		$("#dialog").dialog({
// 			title: 'Success',modal: true,
// 			buttons: {"Ok": function(){$(this).dialog("close");} }
// 		});			 
// 		return false;
// 	}

//     if(ebillEmail != ""){
//         email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
//         if(!email_regex.test(ebillEmail)){
//            $("#dialog").html("<font size='2'>세금계산서 EMAIL을 유형을 확인해주세요.</font>");
//            $("#dialog").dialog({
//               title: 'Success',modal: true,
//               buttons: {"Ok": function(){$(this).dialog("close");} }
//            });            
//            return false; 
//         }
//      }


	return true;
}


function fnApply(){
	var isValidation = fnIsValidation();
	//var isValidation = true;
	if(isValidation){
		if(!confirm("수정한 내용을 저장하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveBranch.sys", 
			{
				branchId:'<%=detailDto.getBranchId()%>',
				branchNm:$("#branchNm").val(),
				clientId:'<%=detailDto.getClientId()%>',
				registNum1:$("#registNum1").val(),
				registNum2:$("#registNum2").val(),
				branchBusiType:$("#branchBusiType").val(),
				branchBusiClas:$("#branchBusiClas").val(),
				pressentNm:$("#pressentNm").val(),
				phoneNum:$("#phoneNum").val(),
				eMail:$("#eMail").val(),
				homePage:$("#homePage").val(),
				postAddrNum:$("#postAddrNum").val(),
				addres:$("#addres").val(),
				addresDesc:$("#addresDesc").val(),
				faxNum:$("#faxNum").val(),
				refereceDesc:$("#refereceDesc").val(),
				areaType:$("#areaType").val(),
				branchGrad:$("#branchGrad").val(),
				payBillType:$("#payBillType").val(),
				payBillDay:$("#payBillDay").val(),
				prePay:$("#prePay").val(),
				accountManageNm:$("#accountManageNm").val(),
				accountTelNum:$("#accountTelNum").val(),
				bankCd:$("#bankCd").val(),
				recipient:$("#recipient").val(),
				accountNum:$("#accountNum").val(),
				loginAuthType:$("#loginAuthType").val(),
				orderAuthType:$("#orderAuthType").val(),
				isUse:$("#isUse").val(),
				closeReason:$("#closeReason").val(),
				file_biz_reg_list:$("#file_biz_reg_list").val(),
				file_app_sal_list:$("#file_app_sal_list").val(),
				file_list1:$("#file_list1").val(),
				file_list2:$("#file_list2").val(),
				file_list3:$("#file_list3").val(),
				isOrderLimit:$("#isOrderLimit").val(),
				autOrderLimitPeriod:$("#autOrderLimitPeriod").val(),
				srcContractSpecial:$("#srcContractSpecial").val(),
				sharpMail:$("#sharpMail").val(),
				ebillEmail:$("#ebillEmail").val()
			},
			function(arg){ 
				if(fnAjaxTransResult(arg)) {  //성공시
//					var opener = window.dialogArguments;
					window.opener.fnSearch();
					window.close();
				}
			}
		);
	}
}

/**
 * list Excel Export
 */
function exportBorgUserExcel() {
	var colLabels = ['사용자명', '사용자ID', '상태', '전화번호', '이동전화번호', '등록일'];	//출력컬럼명
	var colIds = ['userNm','loginId','isUse','tel','mobile','createDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "소속사용자";	//sheet 타이틀
	var excelFileName = "organUserList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/**
 * list Excel Export2
 */
function deliveryInfoExcel() {
	var colLabels = ['배송지명', '배송지 전화번호', '배송지 주소'];	//출력컬럼명
	var colIds = ['shippingPlace', 'shippingPhoneNum', 'shippingAddres'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "배송처정보";	//sheet 타이틀
	var excelFileName = "deliveryInfoList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//물품공급계약서 구분 셀렉트박스
function fnContractSpecial(){
	$.post(
		'/organ/contractSpecialList.sys',
		function(arg){
			var result = eval("("+arg+")");
			for(var i=0; i<result.list.length; i++){
				$("#srcContractSpecial").append("<option value='"+result.list[i].codeVal1+"'>"+result.list[i].codeNm1+"</option>");
			}
			var contractSpecial = '<%=detailDto.getContractSpecial()%>';
			$("#srcContractSpecial").val(contractSpecial);
		}
	);
}

/**
 * 구매사의 경우 정보수정 안되게
 */
function buyDisabled(){
	var svcType = "<%=userInfoDto.getSvcTypeCd()%>";
	if(svcType == "BUY"){
		$("#branchNm").attr("disabled",true);//사업장명
		$("#registNum1").attr("disabled",true);//법인번호1
		$("#registNum2").attr("disabled",true);//법인번호2
		$("#branchBusiType").attr("disabled",true);//업종
		$("#branchBusiClas").attr("disabled",true);//업태
		$("#pressentNm").attr("disabled",true);//대표자명
		$("#isUse").attr("disabled",true);//상태
		$("#branchGrad").attr("disabled",true);//회원사등급
		$("#areaType").attr("disabled",true);//권역
		$("#btnBizRegAttach").hide();//사업자등록첨부
		$("#btnAttach1").hide();//통장사본첨부
		$("#prePay").attr("disabled",true);//선입금여부
		$("#srcContractSpecial").attr("disabled",true);//계약구분
	}
	
}

/**
 * 운영사의 경우의 회계운영자와 파워운영담당자만 수정가능하게 처리
 */
 
function admDisabled(){
	var role = <%=roleCd%>;
	if(!role){
		$("#branchNm").attr("disabled",true);//사업장명
		$("#registNum1").attr("disabled",true);//법인번호1
		$("#registNum2").attr("disabled",true);//법인번호2
		$("#branchBusiType").attr("disabled",true);//업종
		$("#branchBusiClas").attr("disabled",true);//업태
		$("#pressentNm").attr("disabled",true);//대표자명
		$("#isUse").attr("disabled",true);//상태
		$("#btnBizRegAttach").hide();//사업자등록첨부
		$("#btnAttach1").hide();//통장사본첨부
		$("#isOrderLimit").attr("disabled",true);//주문제한여부
		$("#prePay").attr("disabled",true);//선입금여부
		$("#srcContractSpecial").attr("disabled",true);//계약구분
		$("#autOrderLimitPeriod").attr("disabled",true);//주문제한 만기일
	}
} 
</script>

</head>
<body>
<div style='position:absolute;top:0;left:0;width:920px;height:800px;overflow:auto;'>
<form id="frm" name="frm">
      <table align="center" width="96%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
                     <td height="29" class='ptitle'>사업장 정보</td>
                  </tr>
               </table> <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
                     <td class="stitle">사업장 일반정보</td>
                  </tr>
               </table> <!-- 타이틀 끝 -->
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
                     <td class="table_td_subject9">법인</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="clientNm" name="clientNm" type="text" value="<%=detailDto.getClientNm().substring(0, detailDto.getClientNm().lastIndexOf("&gt;")) %>" size="40" maxlength="50" readonly="readonly" disabled="disabled"/>
                     </td>
                     <td class="table_td_subject9">사업장명</td>
                     <td class="table_td_contents">
                        <input id="branchNm" name="branchNm" type="text" value="<%=detailDto.getBranchNm() %>" size="40" maxlength="50" style="width: 98%"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
					<td class="table_td_subject9" width="100">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td>사업자등록번호</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<input type="button" value="국세청조회" style=cursor:pointer; onClick="window.open('http://www.nts.go.kr/cal/cal_check_02.asp')"></input>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input id="businessNum1" name="businessNum1" type="text" value="<%=detailDto.getBusinessNum().substring(0, 3) %>" size="3" maxlength="3" readonly="readonly" disabled="disabled"/> - 
						<input id="businessNum2" name="businessNum2" type="text" value="<%=detailDto.getBusinessNum().substring(3, 5) %>" size="2" maxlength="2" readonly="readonly" disabled="disabled"/> - 
						<input id="businessNum3" name="businessNum3" type="text" value="<%=detailDto.getBusinessNum().substring(5) %>" size="5" maxlength="5" readonly="readonly" disabled="disabled"/>
					</td>
					<td class="table_td_subject" width="100">법인등록번호</td>
					<td class="table_td_contents">
<%
   String registNum = CommonUtils.getString(detailDto.getRegistNum());
   String registNum1 = "";
   String registNum2 = "";
   if(registNum.length() > 10) {
      registNum = registNum.replace("-", "");    
      registNum1 = registNum.substring(0, 6) ;
      registNum2 = registNum.substring(6) ;
   }
%>                     
                        <input id="registNum1" name="registNum1" type="text" value="<%=registNum1 %>" size="6" maxlength="6" onkeydown="return onlyNumber(event)"/> - 
                        <input id="registNum2" name="registNum2" type="text" value="<%=registNum2 %>" size="7" maxlength="7" onkeydown="return onlyNumber(event)"/>
                     </td>
                     <td class="table_td_subject9" width="100">업종</td>
                     <td class="table_td_contents">
                        <input id="branchBusiType" name="branchBusiType" type="text" value="<%=detailDto.getBranchBusiType() %>" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">업태</td>
                     <td class="table_td_contents">
                        <input id="branchBusiClas" name="branchBusiClas" type="text" value="<%=detailDto.getBranchBusiClas() %>" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject9" width="100">대표자명</td>
                     <td class="table_td_contents">
                        <input id="pressentNm" name="pressentNm" type="text" value="<%=detailDto.getPressentNm() %>" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject9" width="100">대표전화번호</td>
                     <td class="table_td_contents">
                        <input id="phoneNum" name="phoneNum" type="text" value="<%=detailDto.getPhoneNum() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">회사이메일</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="<%=detailDto.getE_mail() %>" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com</td>
                     <td class="table_td_subject" width="100">홈페이지</td>
                     <td class="table_td_contents">
                        <input id="homePage" name="homePage" type="text" value="<%=detailDto.getHomePage() %>" size="20" maxlength="30" style="width: 98%" style="ime-mode: disabled;"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">
                     	<table>
                     		<tr>
                     			<td>회사샵(#)메일</td>
                     		</tr>
                     		<tr>
								<td>
									<input type="button" value="회원가입하기" style=cursor:pointer; onclick="window.open('https://www.docusharp.com/member/join.jsp')"></input>
								</td>
							</tr>
                     	</table>
                     </td>
                     <td colspan="5" class="table_td_contents">
                        <input id="sharpMail" name="sharpMail" type="text" value="<%=sharpMail%>" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)법인사업자 : 대표#unpamsbank.법인, 개인사업자 : 대표#unpamsbank.사업</td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">주소</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="postAddrNum" name="postAddrNum" type="text" value="<%=detailDto.getPostAddrNum() %>" size="10" maxlength="10"/>
                        <a href="#">
                           <img id="btnPost" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px; vertical-align: middle;" /> 
                        </a> 
                        <input id="addres" name="addres" type="text" value="<%=detailDto.getAddres() %>" size="20" maxlength="30" style="width: 50%"/>
                     </td>
                     <td class="table_td_subject" width="100">상세주소</td>
                     <td class="table_td_contents">
                        <input id="addresDesc" name="addresDesc" type="text" value="<%=detailDto.getAddresDesc() %>" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">팩스번호</td>
                     <td class="table_td_contents">
                        <input id="faxNum" name="faxNum" type="text" value="<%=detailDto.getFaxNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                     <td class="table_td_subject9" width="100">상태</td>
                     <td class="table_td_contents">
                        <select class="select" id="isUse" name="isUse" onchange="javaScript:fnStatChange();"> 
                           <option value="1" <%=detailDto.getIsUse().equals("1") ? "selected" : "" %>>정상</option> 
                           <option value="0" <%=detailDto.getIsUse().equals("0") ? "selected" : "" %>>종료</option> 
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">종료사유</td>
                     <td class="table_td_contents">
                        <input id="closeReason" name="closeReason" type="text" value="<%=detailDto.getCloseReason() == null ? "" : detailDto.getCloseReason() %>" size="20" maxlength="30" style="width: 98%" />        
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">회원사등급</td>
                     <td class="table_td_contents">
                        <select class="select" id="branchGrad" name="branchGrad"> 
                           <option value="">선택하세요</option> 
<%
   @SuppressWarnings("unchecked")
   List<CodesDto> mGradeCode = (List<CodesDto>) request.getAttribute("mGradeCode");
   for(CodesDto mGradeCd : mGradeCode){
%>    
                     <option value="<%=mGradeCd.getCodeVal1()%>" <%=CommonUtils.getString(mGradeCd.getCodeVal1()).equals(detailDto.getBranchGrad()) ? "selected" : "" %> ><%=mGradeCd.getCodeNm1() %></option>
<% 
   }                 
%>                            
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">참고사항</td>
                     <td class="table_td_contents">
                        <input id="refereceDesc" name="refereceDesc" type="text" value="<%=detailDto.getRefereceDesc() %>" maxlength="1000"/>
                     </td>
                     <td class="table_td_subject" width="100">최초 계약일</td>
                     <td class="table_td_contents">
                        <input id="firstContractDate" name="firstContractDate" type="text" value="<%=detailDto.getFirstContractDate() %>" disabled="disabled"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">로그인 인증</td>
                     <td class="table_td_contents">
                        <select class="select" id="loginAuthType" name="loginAuthType" <%=(!"ADM".equals(userInfoDto.getSvcTypeCd())) ? "disabled" : "" %>> 
                           <option value="10" <%=detailDto.getLoginAuthType().equals("10") ? "selected" : "" %>>모바일인증</option> 
                           <option value="20" <%=detailDto.getLoginAuthType().equals("20") ? "selected" : "" %>>일반</option> 
                        </select>
                     </td>
                     <td class="table_td_subject9" width="100">주문요청인증</td>
                     <td class="table_td_contents">
                        <select class="select" id="orderAuthType" name="orderAuthType" <%=(!"ADM".equals(userInfoDto.getSvcTypeCd())) ? "disabled" : "" %>> 
                           <option value="10" <%=detailDto.getOrderAuthType().equals("10") ? "selected" : "" %>>공인인증</option> 
                           <option value="20" <%=detailDto.getOrderAuthType().equals("20") ? "selected" : "" %>>일반</option> 
                        </select>
                     </td>
                     <td class="table_td_subject9" width="100">권역</td>
                     <td class="table_td_contents">
                        <select class="select" id="areaType" name="areaType"> 
                           <option value="">선택하세요</option> 
<%
   @SuppressWarnings("unchecked")
   List<CodesDto> areaCode = (List<CodesDto>) request.getAttribute("areaCode");
   for(CodesDto areaCd : areaCode){
	   
	   if(!areaCd.getCodeVal1().equals("99")){
	   
%>    
                     <option value="<%=areaCd.getCodeVal1()%>" <%=CommonUtils.getString(areaCd.getCodeVal1()).equals(detailDto.getAreaType()) ? "selected" : "" %> ><%=areaCd.getCodeNm1() %></option>
<% 
	   }
   }                 
%>    
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">사업자등록첨부
                        <a href="#">
                           <img id="btnBizRegAttach" name="btnBizRegAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>              
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=file_biz_reg_list %>"/>
                        <input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=attach_file_biz_reg_path %>"/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_biz_reg_path').val());">
                        <span id="attach_file_biz_reg_name"><%=attach_file_biz_reg_name %></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="100">신용평가서첨부
                        <a href="#">
                           <img id="btnAppSalAttach" name="btnAppSalAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>                 
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=file_app_sal_list %>"/>
                        <input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=attach_file_app_sal_path %>"/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_app_sal_path').val());">
                        <span id="attach_file_app_sal_name"><%=attach_file_app_sal_name %></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="100">주문제한여부</td>
                     <td class="table_td_contents">
                     	<select id="isOrderLimit" name="isOrderLimit" class="select" <%=(!"ADM".equals(userInfoDto.getSvcTypeCd())) ? "disabled" : "" %>>
                     		<option value="0">아니오</option>
                     		<option value="1" <%=("1".equals(detailDto.getIsOrderLimit())) ? "selected" : "" %>>제한</option>
                     	</select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">통장사본첨부
                        <a href="#">
                           <img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>              
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
                        <input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
                        <span id="attach_file_name1"><%=attach_file_name1 %></span>
                        </a>              
                     </td>
                     <td class="table_td_subject" width="100">기타첨부1
                        <a href="#">
                        <img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>              
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
                        <input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
                        <span id="attach_file_name2"><%=attach_file_name2 %></span>
                        </a>  
                     </td>
                     
                     
					 <td width="80" class="table_td_subject9">채권담당자</td>
					 	<td class="table_td_contents">
		                	<select id="accUser" name="accUser" class="select" style="width: 120px;" disabled="disabled">
                            	<option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<UserDto> admUserList = (List<UserDto>) request.getAttribute("admUserList");

   if(admUserList != null && admUserList.size() > 0){

      for(UserDto userDto : admUserList){
%>                              
                                 <option value="<%=userDto.getUserId()%>" <%=userDto.getUserId().equals(detailDto.getUserId()) ? "selected" : "" %> ><%=userDto.getUserNm()%></option>
<%
      }
   }
%>                              
                    	</select>
				  	</td>	                     
                     
                  </tr>                
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">기타첨부2
                        <a href="#">
                           <img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>                    
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
                        <input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
                        <span id="attach_file_name3"><%=attach_file_name3 %></span>
                        </a>  
                     </td>
                     <td class="table_td_subject9" >선입금여부</td>
                     <td class="table_td_contents" >
                        <select class="select" id="prePay" name="prePay" style="width: 125px;">
                           <option value="0" <%="0".equals(detailDto.getPrePay()) ? "selected" : "" %>>아니요</option> 
                           <option value="1" <%="1".equals(detailDto.getPrePay()) ? "selected" : "" %>>예</option> 
                        </select> 
                      </td>
                     <td class="table_td_subject9" >고객유형</td>
                     <td class="table_td_contents" >
		                	<select id="workId" name="workId" class="select" style="width: 120px;" disabled="disabled">
                            	<option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<WorkInfoDto> workInfoList = (List<WorkInfoDto>) request.getAttribute("workInfoList");

   if(workInfoList != null && workInfoList.size() > 0){

      for(WorkInfoDto workInfoDto : workInfoList){
%>                              
                                 <option value="<%=workInfoDto.getWorkId()%>"  <%=workInfoDto.getWorkId().equals(detailDto.getWorkId()) ? "selected" : "" %>><%=workInfoDto.getWorkNm()%></option>
<%
      }
   }
%>                              
                        	</select>
                      </td>
                  </tr>
<%if("ADM".equals(userInfoDto.getSvcTypeCd())){%>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">기본 계약일</td>
                     <td class="table_td_contents">
                     	<input type="text" id="basicContractDate" name="basicContractDate" value="<%=detailDto.getBasicContractDate()%>" disabled="disabled"/>
                     </td>
                     <td class="table_td_subject" width="100">개인정보 제공 동의일</td>
                     <td class="table_td_contents">
                     	<input type="text" id="individualContractDate" name="individualContractDate" value="<%=detailDto.getIndividualContractDate()%>" disabled="disabled"/>
                     </td>
                     <td class="table_td_subject" width="100">특별 계약일</td>
                     <td class="table_td_contents">
                     	<input type="text" id="specialContractDate" name="specialContractDate" value="<%=detailDto.getSpecialContractDate()%>" disabled="disabled"/>
                     </td>
                  </tr>
<%} %>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">계약 구분</td>
                     <td class="table_td_contents">
                        <select class="select" id="srcContractSpecial" name="srcContractSpecial" onchange="javaScript:fnStatChange();">
                           <option value="">선택하세요</option>
                        </select>
                     </td>
<%if("ADM".equals(userInfoDto.getSvcTypeCd())){%>
                     <td class="table_td_subject" width="100">세금계산서 이메일</td>
                     <td class="table_td_contents" colspan="3">
                        <input type="text" id="ebillEmail" name="" value="<%=detailDto.getEbillEmail()%>"/> ex)admin@unpamsbank.com
                     </td>
                  </tr>
<%} %>
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
               </table> <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">결제정보</td>
                  </tr>
               </table> <!-- 타이틀 끝 -->
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
                     <td class="table_td_subject9" width="100">결제조건</td>
                     <td class="table_td_contents">
                        <select class="select" id="payBillType" name="payBillType" style="width: 125px;"> 
                           <option value="">선택하세요</option> 
<%
   @SuppressWarnings("unchecked")
   List<CodesDto> payCondCode = (List<CodesDto>) request.getAttribute("payCondCode");
   for(CodesDto payCondCd: payCondCode){
%>
                  
                     <option value="<%=payCondCd.getCodeVal1()%>" <%=CommonUtils.getString(payCondCd.getCodeVal1()).equals(detailDto.getPayBilltype()) ? "selected" : "" %>>
                        <%=payCondCd.getCodeNm1()%>
                     </option>
<%       
   }                 
%>                               
                        </select> 
<%--                         <input id="payBillDay" name="payBillDay" type="text" value="<%=detailDto.getPayBillDay() %>" size="20" maxlength="30" style="width: 20px" /> 일 --%>
                     </td> <td class="table_td_subject9" width="100">회계담당자명</td> 
                     <td class="table_td_contents">
                        <input id="accountManageNm" name="accountManageNm" type="text" value="<%=detailDto.getAccountManageNm() %>" size="20" maxlength="30" style="width: 98%" />
                     </td> 
                     <td class="table_td_subject9" width="100">회계이동전화</td> 
                     <td class="table_td_contents">
                        <input id="accountTelNum" name="accountTelNum" type="text" value="<%=detailDto.getAccountTelNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td> 
                  </tr> 
                  <tr> 
                     <td colspan="6" height='1' bgcolor="eaeaea"></td> 
                  </tr> 
                  <tr> 
                     <td class="table_td_subject9" width="100">은행코드</td> 
                     <td class="table_td_contents">
                        <select class="select" id="bankCd" name="bankCd"> 
                           <option value="">선택하세요</option> 
<%
   @SuppressWarnings("unchecked")
   List<CodesDto> bankCode = (List<CodesDto>) request.getAttribute("bankCode");
   for(CodesDto bankCd : bankCode){
%>    
                     <option value="<%=bankCd.getCodeVal1()%>" <%=CommonUtils.getString(bankCd.getCodeVal1()).equals(detailDto.getBankCd()) ? "selected" : "" %> ><%=bankCd.getCodeNm1() %></option>
<% 
   }                 
%>                      
                        </select>
					</td> 
					<td class="table_td_subject9" width="100">예금주명</td> 
					<td class="table_td_contents">
						<input id="recipient" name="recipient" type="text" value="<%=detailDto.getRecipient() %>" size="20" maxlength="30" style="width: 98%" />
					</td> 
					<td class="table_td_subject9" width="100">계좌번호</td> 
					<td class="table_td_contents">
						<input id="accountNum" name="accountNum" type="text" value="<%=detailDto.getAccountNum() %>" size="15" maxlength="20" onkeydown="return onlyNumber(event)"/> (-없이)
					</td> 
				</tr>
				<tr id="expirationDate">
					<td class="table_td_subject9" width="100">주문제한 만기일</td>
					<td class="table_td_contents">
						<input id="autOrderLimitPeriod" type="text" name="autOrderLimitPeriod" value="<%=detailDto.getAutOrderLimitPeriod()%>"/> 일
					</td>
				</tr>
				<tr> 
					<td colspan="6" class="table_top_line"></td> 
				</tr>
				<tr> 
					<td> &nbsp; </td> 
				</tr>
				<tr>
					<td align="center" colspan="6">
						<a href="#"> 
							<img id="saveButton" name="saveButton" src="/img/system/btn_type5_save.gif" width="65" height="23" style="border: 0px; vertical-align: middle;"/> 
						</a>
						<a href="#"> 
							<img id="closeButton" name="closeButton" src="/img/system/btn_type5_close.gif" width="65" height="23" style="border: 0px; vertical-align: middle;" onclick="javaScript:window.close();"/>
						</a>
					</td>
				</tr> 
			</table> <!-- 컨텐츠 끝 --> 
		</td> 
	</tr> 
	<tr> 
		<td>&nbsp;</td> 
	</tr> 
	<tr> 
		<td> <!-- 타이틀 시작 --> 
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top">
						<img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
					</td>
					<td class="stitle">배송처 정보</td>
					<td width="80" class="stitle">
						<a href="#">
							<img id="deliveryInfoExcelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="16" height="16" style='border:0; vertical-align: middle; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
						</a>
						<a href="#">
							<img id="regButton" name="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/> 
						</a>
						<a href="#">
							<img id="delButton" name="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/>
						</a>
					</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
		</td>
	</tr>
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list"></table>
               </div>
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">소속사용자</td>
                     <td class="stitle" align="right" valign="middle">
						<a href="#"><img id="addUserButton" name="addUserButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Boss.gif" width="15" height="15" style="vertical-align:top;"/></a>
						<a href="#"><img id="delUserButton" name="delUserButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
                     	<a href="#"><img id="borgUserExcelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="16" height="16" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
                     </td>
                  </tr>
               </table> <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list2"></table>
               </div>
               <div id="dialog" title="Feature not supported" style="display:none;">
                  <p>That feature is not supported.</p>
               </div>               
            </td>
         </tr>
         <tr><td>&nbsp;</td></tr>
      </table>
   <div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
      <p>처리할 데이터를 선택 하십시오!</p>
   </div>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</div>
</body>
</html>