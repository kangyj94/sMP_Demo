<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.WorkInfoDto" %>
<%
    @SuppressWarnings("unchecked")
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");

    // 권역 조회
    @SuppressWarnings("unchecked")
    List<CodesDto> areaTypeList = (List<CodesDto>) request.getAttribute("areaTypeList");
    // 권한 조회
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> smsRoleList = (List<Map<String,Object>>) request.getAttribute("roleList");
    
    // 고객유형
    @SuppressWarnings("unchecked")
    List<Object> workInfoList = (List<Object>) request.getAttribute("workInfoList");
    
    // 발신자 번호 세팅
    LoginUserDto loginUserDto = (LoginUserDto) (request.getSession()).getAttribute(Constances.SESSION_NAME);
    String loginUserMobilNumber = loginUserDto.getMobile() == null ?  "" : loginUserDto.getMobile();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    $("#srcSmsBorgNms").keydown(function(e){ if(e.keyCode==13) { $("#srcSmsSearchButton").click(); } });
    $("#srcSmsUserNm").keydown(function(e){ if(e.keyCode==13) { $("#srcSmsSearchButton").click(); } });
    $("#inputWord").keydown(function(e){ if(e.keyCode==13) { $("#srcSmsSearchButton").click(); }});
    
    $("#srcSmsSearchButton").click(function(){ 
        $("#srcSmsBorgNms").val($.trim($("#srcSmsBorgNms").val()));
        $("#srcSmsUserNm").val($.trim($("#srcSmsUserNm").val()));
        fnSmsUserSearch(); 
    });
    $("#srcSmsSvcTypeNm").val("BUY");
//     $("#srcSmsRoleNm").val("13081");
    
    $("#smsRegiButton").click(function(){ 
		fnSmsReceiveRegi();   	
    });
    
	$("#closeButton").on("click",function(e){
		self.close();
	});
});
</script>
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
jq(function() {
    jq("#smsMemberList").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/smsSvcMemberListJQGrid.sys',
        datatype: 'json', mtype: 'POST',
//         colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'회원사 구분', '업체명', '권역', '권한', '사용자명', '이동전화번호'],
        colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'회원사 구분', '업체명', '권역', '사용자명', '이동전화번호'],
        colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
            {name:'SVCTYPENM',index:'SVCTYPENM', width:65,align:"center",sortable:false,editable:false},          // 회원사 구분
            {name:'BORGNMS',index:'BORGNMS', width:280,align:"left",sortable:false,editable:false},       // 업체명
            {name:'DELI_AREA_CODE_NAME',index:'DELI_AREA_CODE_NAME', width:50,align:"center",sortable:false,editable:false},        // 권역
//             {name:'ROLENM',index:'ROLENM', width:90,align:"center",sortable:false,editable:false},       // 권한 
            {name:'USERNM',index:'USERNM', width:150,align:"left",sortable:false,editable:false},            // 사용자명
            {name:'MOBILE',index:'MOBILE', width:120,align:"left",sortable:false,editable:false}            // 이동전화번호
        ],
        postData: {
            srcSmsSvcTypeNm:$("#srcSmsSvcTypeNm").val(),
//             srcSmsRoleNm:$("#srcSmsRoleNm").val(),
            srcSmsBorgNms:$("#srcSmsBorgNms").val(),
            srcSmsDeliAreaCodeNm:$("#srcSmsDeliAreaCodeNm").val(),
            srcSmsUserNm:$("#srcSmsUserNm").val(),
            srcWorkInfo:$("#srcWorkInfo").val()
        },
        rowNum:500, rownumbers: false, rowList:[15,20,30,50,100,500,1000], pager: '#smsMemberPager',
        height:345, width:750,
        sortname: 'borgNms', sortorder: "asc",
        caption:'사용자조회', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					var mobile = selrowContent.MOBILE;
					mobile = fnSetTelformat(mobile);
					$(this).jqGrid('setRowData',rowid,{MOBILE:mobile});
				}
			}
        },
        afterInsertRow: function(rowid, aData){},
        ondblClickRow: function (rowid, iRow, iCol, e) {
            fnSmsTranSelectUser(rowid);
        },   
        loadError : function(xhr, st, str){ $("#memberList").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    });
});
</script>
<script type="text/javascript">
var smsRegiCnt = 0;
function fnSmsReceiveRegi(){
	var rowCnt = jq("#smsMemberList").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#smsMemberList").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#smsMemberList").jqGrid('getRowData',rowid);
                if(smsRegiCnt == 0){ 
                	chkClear2();
                	smsRegiCnt++;
                    document.getElementById("tonum").value="";
                    document.getElementById("tonum").value=selrowContent.MOBILE;
                }else{
                    var tempTextAreaValue = document.getElementById("tonum").value;
                    tempTextAreaValue += "\n"+selrowContent.MOBILE;
                    document.getElementById("tonum").value=tempTextAreaValue;
                }
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
	}
}
function fnSmsTranSelectUser(rowid){
	var selrowContent = jq("#smsMemberList").jqGrid('getRowData',rowid);
	if(smsRegiCnt == 0){ 
		chkClear2();
		smsRegiCnt++;
        document.getElementById("tonum").value="";
        document.getElementById("tonum").value=selrowContent.MOBILE;
	}else{
        var tempTextAreaValue = document.getElementById("tonum").value;
        tempTextAreaValue += "\n"+selrowContent.MOBILE;
        document.getElementById("tonum").value=tempTextAreaValue;
	}
}
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
   if($("#chkAllOutputField").is(':checked')) {
	   var rowCnt = jq("#smsMemberList").getGridParam('reccount');
	    if(rowCnt>0) {   
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#smsMemberList").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
	        }
	    }
   } else {
	    var rowCnt = jq("#smsMemberList").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#smsMemberList").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
	        }
	    }
   }
}
function popupAutoResize() {
//     var thisX = parseInt(document.body.scrollWidth);
//     var thisY = parseInt(document.body.scrollHeight);
//     var maxThisX = screen.width - 50;
//     var maxThisY = screen.height - 50;
// //     var maxThisY = screen.height - 50;
//     var marginY = 0;
//     alert(thisX + "===" + thisY);
//     alert("임시 브라우저 확인 : " + navigator.userAgent);
//     // 브라우저별 높이 조절. (표준 창 하에서 조절해 주십시오.)
//     if (navigator.userAgent.indexOf("MSIE 6") > 0) marginY = 45;        // IE 6.x
//     else if(navigator.userAgent.indexOf("MSIE 7") > 0) marginY = 75;    // IE 7.x
//     else if(navigator.userAgent.indexOf("Firefox") > 0) marginY = 50;   // FF
//     else if(navigator.userAgent.indexOf("Opera") > 0) marginY = 30;     // Opera
//     else if(navigator.userAgent.indexOf("Netscape") > 0) marginY = -2;  // Netscape

//     if (thisX > maxThisX) {
//         window.document.body.scroll = "yes";
//         thisX = maxThisX;
//     }
//     if (thisY > maxThisY - marginY) {
//         window.document.body.scroll = "yes";
//         thisX += 19;
//         thisY = maxThisY - marginY;
//     }
//     window.resizeTo(thisX+10, thisY+marginY);

    // 센터 정렬
//     var windowX = (screen.width - (thisX+10))/2;
//     var windowY = (screen.height - (thisY+marginY))/2 - 20;
//     window.moveTo(windowX,windowY);
// window.resizeTo(700,590);     
// window.resizeTo(260,590);     
}
// 메세지 처음 입력할 때 초기화 시키는 function 
var cliflag = false;
function clearPhone(){
    if (cliflag==false) {
        document.getElementById("inputsms").value="";
        cliflag=true;
    }
}
//전송할 전화번호 칸 초기화 시키는 function
var cliflag2 = false;
function chkClear2(){
    if (cliflag2==false) {
        document.getElementById("tonum").value="";
        cliflag2=true;
    }
}
// 문자 전송내용 keyUp event 
// byte를 체크한다.
function chksize(t) { 
    chksizeOri(t);
}
function chksizeOri(t) {
    var tempi1=0;
    if (t.value=="") {
        document.getElementById("messagesize").innerText="0/2000 Bytes";
    } else {
        byteIs=0;
        for (var i=0;i<t.value.length;i++) {
            tmp = t.value.charAt(i);
            escChar = escape(tmp);
            if (escChar=='%0D') {
            } else if (escChar.length > 4) {
                byteIs += 2;
            } else {
                byteIs += 1;
            }
            if (byteIs>2000) {break;}
            if (byteIs==1999) {tempi1 = i+1;}
        }
        if (byteIs>2000) {
            alert('2000byte를 초과하실 수 없습니다.');
            tmpval = t.value.substr(0,tempi1);byteIs=80;
            t.value = tmpval;
        }
        document.getElementById("messagesize").innerText=byteIs+"/2000 Bytes";
    }
}
// 문자 전송하기 버튼을 클릭했을때 호출된다.
function chkAddrSend() {
    var tmpTotCnt = 0;              // 정상적으로 전송 될 수신 번호의 갯수
    var tmpSendNumber = "";     // - 등의 특수문자 등을 걸러내기 위한 임시 변수

    var tmpDupCnt = 0; //중복제거된 번호 카운트
    var tmpInvalidCnt = 0; //잘못된 번호 카운트

    var chk = commonchk();      // sms 전송을 위해 기초적인 체크 함수. (전송할 내용이 있는지, 발신 번호가 있는지 여부)
    if (chk == false) {
        document.getElementById("div_dupinfo").style.display = "none";
        return;
    }
    var memdata = document.getElementById('tonum').value;      // 발송대상 번호를 가져온다.
    memdata = memdata.replace(/\r\n*$/, ''); //제일끝 개행 제거
    if (memdata.length < 10) {
        alert('수신번호를 입력해 주십시요');
        document.getElementById("div_dupinfo").style.display = "none";
        return;
    }
    var arrmemdata = memdata.split("\r\n");
    if (memdata.length < 10) {
        //중복제거 안내창 숨김
        alert('수신번호를 입력해 주십시요');
        document.getElementById("div_dupinfo").style.display = "none";
        return;
    }
    arrmemdata = memdata.split("\n");
    for (var i = 0; i < arrmemdata.length; i++) {
        var tempVar = arrmemdata[i];
        tempVar = makeOnlyNum(arrmemdata[i]);
        if(scriptTrim(tempVar) == ""){
            continue;
        }
        var nflag = AddNumber(tempVar);
        if (false == nflag) { // 전화번호를 체크하여 문제가 있을 경우 카운터에 +1 함.
            tmpInvalidCnt++; // 문제 전화번호 건수
        }
        if (nflag && 0 <= tmpSendNumber.indexOf(tempVar + ",")) { //중복번호 있다면 패스
            nflag = false;
            tmpDupCnt++; // 중복 번호 건수
        }
        if (nflag == true) {
            gFlag = "N";
            gCnt = "1";
            gSeq = tempVar;
            tmpTotCnt += parseInt(gCnt);
            if (gFlag == "N") {
                tmpSendNumber += gSeq + ",";
            }
        }
    }
    document.getElementById("tonum").value = tmpSendNumber.split(",").join("\r\n");
    chksize(document.getElementById("inputsms"));
    document.getElementById("div_dupinfo").style.display = "none";
    if (tmpTotCnt < 1) {
        alert('잘못된번호,중복된번호를 ' + (tmpDupCnt + tmpInvalidCnt) + '건 제거하였습니다.\r\n\r\n전송가능한 전화번호가 없습니다.');
        return;
    }
    chk = confirm('잘못된번호,중복된번호를 ' + (tmpDupCnt + tmpInvalidCnt) + '건 제거하였습니다.\r\n\r\n총 [' + insertComma(tmpTotCnt) + '] 건의 메시지를 전송하시겠습니까?');
    if (chk == true) {
        var trans_msg_desc = document.getElementById("inputsms").value;
        var trans_phone_numb = document.getElementById("fromnum").value;
        
        var receive_phone_numb_array = new Array();
        var tempReceiveNum = tmpSendNumber.split(",");
        for(var i = 0; i < tempReceiveNum.length ; i++){
            if(scriptTrim(tempReceiveNum[i])!=""){
                receive_phone_numb_array[i] = tempReceiveNum[i];
            }
        }
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/smsTransmissionMsg.sys", 
            {   
                trans_msg_desc:trans_msg_desc
                ,trans_phone_numb:trans_phone_numb
                ,receive_phone_numb_array:receive_phone_numb_array
            },
            function(arg){
                if(fnAjaxTransResult(arg)) {    
                   alert("문자전송이 성공적으로 완료되었습니다.");
                }else{
                   alert("문자전송이 실패했습니다.");
                }
            }
        );
    }
}
function commonchk() {
    if (document.getElementById("inputsms").value=="") {
        alert('메시지를 입력하셔야 전송이 가능합니다.');
        return false;
    }
    if (document.getElementById("fromnum").value=="") {
        alert('회신번호를 입력해 주십시요.');
        return false;
    }
    if (document.getElementById("fromnum").value.length>15) {
        alert('발신번호를 정확하게 입력하여 주십시요.');
        return false;
    }
    if (!sendnumber_chk(document.getElementById("fromnum").value)) {
        alert('발신번호는 전화 형식에 맞게 입력해 주십시요.');
        return false;
    }
    return true;
}
function sendnumber_chk(word) {
    var str = "1234567890-*#";
    for ( var i = 0; i < word.length; i++) {
        idcheck = word.charAt(i);
        for ( var j = 0; j < str.length; j++) {
            if (idcheck == str.charAt(j)) break;
            if (j + 1 == str.length) {
                return false;
            }
        }
    }
    return true;
}

function makeOnlyNum(val) {
    retVal = "";
    for ( var Ni = 0; Ni < val.length; Ni++) {
        tmpVal = val.charAt(Ni);
        if (tmpVal >= '0' && tmpVal <= '9') {
            retVal += tmpVal;
        }
    }
    return retVal;
}
function AddNumber(val) {
    try {
        val = val.split("-").join("");
    } catch (e) { }
    if (val.length<10||val.length>11) { // 휴대폰 자리 숫자가 10자리 미만, 11자리 초과면 실패 처리
        return false;
    }
    if (isNaN(val)) {                       // 휴대폰 번호의 - 을 제외한 숫자열들에 문자열이 있으면 실패처리
        return false;
    }
    if (val.charAt(0) != "0" || val.charAt(1) != "1") { // 휴대폰 번호의 1번째자리가 0 이 아니거나 2번째자리가 1이 아니라면 실패처리 : 01 로 시작해야한다.
        return false;
    }
    return true;
}
function insertComma(str) {
    var txtNumber = '' + str;
    var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
    var arrNumber = txtNumber.split('.');
    arrNumber[0] += '.';
    do {
        arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
    } while (rxSplit.test(arrNumber[0]));
    if (arrNumber.length > 1) {
        return arrNumber.join('');
    } else {
        return arrNumber[0].split('.')[0];
    }
}
function sendMsg() {
    document.getElementById("div_dupinfo").style.display = "block";
    setTimeout(chkAddrSend, 100);
}
function scriptTrim(str){
    return str.replace(/(^\s*)|(\s*$)/gi, ""); 
}

function chgSrcSmsSvcTypeNm(){
	if($("#srcSmsSvcTypeNm").val() == "ADM"){
    	$("#srcSmsDeliAreaCodeNm").val("");
	}
    $.post( 
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getRoleInfoListBySmsSvcTypeNm.sys',
        {srcSmsSvcTypeNm:$("#srcSmsSvcTypeNm").val()},
        function(arg){
//             $("#srcSmsRoleNm").html("");
//             var smsRoleList = eval('(' + arg + ')').smsRoleList;
//             $("#srcSmsRoleNm").append("<option value=''>전체</option>");
//             for(var i=0;i<smsRoleList.length;i++) {
//                 $("#srcSmsRoleNm").append("<option value='"+smsRoleList[i].ROLEID+"'>"+smsRoleList[i].ROLENM+"</option>");
//             }   
        }
	);
}
function fnSmsUserSearch() {
	if($("#searchType1").prop("checked") && ($.trim($("#inputWord").val()) != '')) {
		$("#prevWord").val( $("#prevWord").val()+"‡"+"＋"+$.trim($("#inputWord").val()) );
	} else if($("#searchType2").prop("checked") && ($.trim($("#inputWord").val()) != '')) {
		$("#prevWord").val( $("#prevWord").val()+"‡"+"－"+$.trim($("#inputWord").val()) );
	} else if(($("#searchType1").prop("checked")==false && $("#searchType2").prop("checked")==false) && ($.trim($("#inputWord").val()) != '')) {
		$("#prevWord").val( "＋"+$.trim($("#inputWord").val()) );
	} else if(($("#searchType1").prop("checked")==false && $("#searchType2").prop("checked")==false)) {
		$("#prevWord").val('');
	}
	
	jq("#smsMemberList").jqGrid("setGridParam", {"page":1});
    var data = jq("#smsMemberList").jqGrid("getGridParam", "postData");
    data.srcSmsSvcTypeNm= $("#srcSmsSvcTypeNm").val();
//     data.srcSmsRoleNm= $("#srcSmsRoleNm").val();
    data.srcSmsBorgNms= $("#srcSmsBorgNms").val();
    data.srcSmsDeliAreaCodeNm= $("#srcSmsDeliAreaCodeNm").val();
    data.srcSmsUserNm= $("#srcSmsUserNm").val();
    data.srcWorkInfo= $("#srcWorkInfo").val();
    data.srcWorkInfo= $("#srcWorkInfo").val();
    data.srcWorkInfo= $("#srcWorkInfo").val();
    data.prevWord = $("#prevWord").val();
    jq("#smsMemberList").jqGrid("setGridParam", { "postData": data });
    jq("#smsMemberList").trigger("reloadGrid");
    $("#inputWord").val('');
    fnSetWord(-1);
}

/**
 * 결과내재검색/검색어 제외 체크박스
 */
function fnSearchType(kind){
	if(kind == '1'){
		$("#searchType2").prop("checked", false);
	}else if(kind == '2'){
		$("#searchType1").prop("checked", false);
	}
}
/**
 * 검색결과 문자열 세팅
 */
function fnSetWord(index) {
	var sSearchWordTxt = "";
	var eSearchWordTxt = "";
	var sPrefix = "";
	var ePrefix = "";
	var eCnt = 0;
	var sCnt = 0;
	
    var prevWordArray = $.trim($("#prevWord").val()).split("‡");
    for(var i = 0 ; i < prevWordArray.length ; i++){
    	if(i!=index) {
			if(prevWordArray[i].indexOf('＋') > -1){
				if(sCnt != 0) sPrefix = ",";
				if(prevWordArray[i].substring(1) != ''){
					sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
					sCnt++;
				}else{
					sSearchWordTxt += '';
				}
			} else if(prevWordArray[i].indexOf('－') > -1){
				if(eCnt != 0) ePrefix = ",";
				if(prevWordArray[i].substring(1) != ''){
					eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
					eCnt++;
				}else{
					eSearchWordTxt += '';
				}
			}
    	}
    }
	var resultTxt = "";
	if(sCnt > 0){
		if(eCnt == 0) 	resultTxt = "<strong style='color: red;'>"+sSearchWordTxt + "</strong> 의 검색결과";
		else			resultTxt = "<strong style='color: red;'>"+sSearchWordTxt + "</strong> 중 <strong style='color: red;'>" + eSearchWordTxt + "</strong> 을(를) 제외한 검색결과";
	}else{
		resultTxt = "&nbsp;";
	}
	$("#searchWordTxt").html(resultTxt);
}
/**
 * 검색결과 제거검색
 */
function fnSrcWordDel(index){
	fnSetWord(index);
	var prevWordArray = $.trim($("#prevWord").val()).split("‡");
	var wordString = "";
	for(var i = 0 ; i < prevWordArray.length ; i++){
		if(i!=index) {
			if(wordString=="") wordString = prevWordArray[i];
			else wordString = wordString + "‡" + prevWordArray[i];
		}
	}
	$("#prevWord").val(wordString);
	fnSmsUserSearch();
}
</script>
</head>
<body onload="javascript:popupAutoResize();">
<table  width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td style="width: 207px">
            <table width="207" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="229" valign="top"  style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_topmms_tbg.gif');">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="70"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="70%" style="height: 130px" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td height="20">
                                                <font color="3C476E" ><textarea name="textarea" cols="30" class="sms1" style="background-color: transparent; width: 135px; height: 115px; border: 0; OVERFLOW: scroll-y" id='inputsms' onkeyup="javascript:chksize(this);" onchange="javascript:chksize(this);" onfocus='javascript:clearPhone();'>메세지를 입력해 주세요.</textarea></font>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="27" align="center">
                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="81%" align="center">
                                                <div id='messagesize' style='color: 3C476E'>0/2000 Bytes</div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height="299" valign="top"  style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_topmms_bbg.gif');">
                        <table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td height="7"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td width="59%" height="18"> </td>
                                            <td width="41%"> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="12" ></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="94%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_txt01.gif" width="32" style="height: 11px"/> </td>
                                        </tr>
                                        <tr>
                                            <td height="4"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <textarea id="tonum" name="tonum" rows="5" style="width:163px; height:150px;" onfocus="javascript:chkClear2();">이곳을 클릭후 수신번호를 입력해주세요. 
        
수신번호는 숫자 및 붙임표(-)로 입력하며 2개이상 입력 시에는 줄바꿈(enter)하여 입력바랍니다.</textarea>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="7"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="94%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="25%"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_txt02.gif" width="32" height="11"/> </td>
                                            <td width="75%"> <input id="fromnum" name="fromnum" type="text" style="width: 117px" value="<%=loginUserMobilNumber%>"/> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="12"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="50%"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_btn_send.gif" width="86" height="37" border="0" style='cursor: hand' onclick="javascript:sendMsg();"/> </td>
                                            <td width="50%" align="right"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/sms/hp_btn_cancel.gif" width="86" height="37" border="0" style='cursor: hand' onclick="document.getElementById('inputsms').value='';"/> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td> 
                </tr>
            </table>
        </td>
        <td style="width: 100px">&nbsp;
        </td>
        <td>
    		<table width="100%" border="0" cellspacing="0" cellpadding="0">
    			<tr>
    				<td>
    					<table width="100%" border="0" cellspacing="0" cellpadding="0">
    						<tr valign="top">
    							<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
    							<td height="29" class='ptitle'>이동전화번호 조회</td>
								<td align="center" class="table_td_contents" style="vertical-align: middle;">
									<input type="checkbox" 	id="searchType1"	name="searchType1" 	onclick="javascript:fnSearchType('1');" style="vertical-align: middle;"/>&nbsp;결과내재검색&nbsp;&nbsp;
									<input type="checkbox" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');" style="vertical-align: middle;"/>&nbsp;검색어 제외&nbsp;&nbsp;
									<input type="hidden" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');" style="vertical-align: middle;"/>
									<input type="text" 		id="inputWord" 		name="inputWord" 	placeholder="검색어를 입력하세요" size="30" style="height: 20px;" />
									<input type="hidden" 	id="prevWord" 		name="prevWord"  	value=""/>
								</td>    							
								<td align="right" class='ptitle'>
                                	<img id="smsRegiButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_smsRegi.jpg" width="155" height="22" style="cursor:pointer;"/>
                                    <img id="srcSmsSearchButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" width="65" height="22" style="cursor:pointer;"/>
								</td>
    						</tr>
    					</table> 
    				</td>
    			</tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" width="100">회원사구분</td>
                                <td class="table_td_contents">
<!--                                     <select id="srcSmsSvcTypeNm" name="srcSmsSvcTypeNm" class="select" onchange="javascript:chgSrcSmsSvcTypeNm();" > -->
                                    <select id="srcSmsSvcTypeNm" name="srcSmsSvcTypeNm" class="select">
                                        <option value ="">전체</option>
                                        <option value ="ADM">운영사</option>
                                        <option value ="BUY" selected="selected">고객사</option>
                                        <option value ="VEN">공급사</option>
                                    </select>
                                </td>
<!--                                 <td class="table_td_subject" width="100">권한구분</td> -->
<!--                                 <td class="table_td_contents"> -->
<!--                                     <select id="srcSmsRoleNm" name="srcSmsRoleNm" class="select" > -->
<!-- 										<option value ="">전체</option> -->
<%-- <% --%>
<!--  if(smsRoleList.size() > 0){  -->
<!--      for(Map<String,Object> mpso : smsRoleList){ -->
<%-- %>                                         --%>
										
<%-- 										<option value ="<%=mpso.get("ROLEID")%>"><%=mpso.get("ROLENM")%></option> --%>
<%-- <% --%>
<!--      } -->
<!--  } -->
<%-- %> --%>
<!--                                     </select> -->
<!--                                 </td> -->
                                <td class="table_td_subject" width="100">업체명</td>
                                <td class="table_td_contents" colspan="3">
                                    <input id="srcSmsBorgNms" name="srcSmsBorgNms" type="text" value="" size="" maxlength="50" style="width: 200px" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" width="100">권역</td>
                                <td class="table_td_contents">
                                    <select id="srcSmsDeliAreaCodeNm" name="srcSmsDeliAreaCodeNm" class="select" >
                                        <option value ="">전체</option>
<%
if(areaTypeList.size() > 0){ 
    for(CodesDto cd  : areaTypeList){
%>                                        
                                        <option value ="<%=cd.getCodeVal1()%>"><%=cd.getCodeNm1()%></option>
<%
    }
}
%>
                                    </select>
                                </td>
                                <td class="table_td_subject" width="100">사용자명</td>
                                <td class="table_td_contents" >
                                    <input id="srcSmsUserNm" name="srcSmsUserNm" type="text" value="" size="" maxlength="50" style="width: 100px" />
                                </td>
                                <td class="table_td_subject" width="100">고객유형</td>
                                <td class="table_td_contents">
                                    <select class="select" id="srcWorkInfo" name="srcWorkInfo">
                                    	<option value="">전체</option>
<%
if(workInfoList.size() > 0){ 
    for(Object obj  : workInfoList){
		WorkInfoDto wid = (WorkInfoDto) obj;
%>                                        
                                        <option value ="<%=wid.getWorkId()%>"><%=wid.getWorkNm()%></option>
<%
    }
}
%>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
					<td align="left" valign="middle" style="padding-left: 20px;">
                		<img src="/img/contents/bullet_01.gif" />
                		<span id="searchWordTxt" style="font-size: 10pt;"></span>
                	</td>
                </tr>
                <tr>  
                    <td style="height:20px ;vertical-align:bottom ;">* 이동전화번호가 공백이거나 형식에 맞지 않는 번호일 경우 좌측 하단의 [전송하기] 버튼을 클릭시 정리가 됩니다.</td>
                </tr>
                
                
    			<tr>
    				<td align="left">
                        <div id="jqgrid">
                            <table id="smsMemberList"></table>
                            <div id="smsMemberPager"></div>
                        </div>
    				</td>
    			</tr>
    		</table>
        </td>
    </tr>
    <tr>
    	<td colspan="3">&nbsp;</td>
    </tr>
    <tr>
    	<td colspan="3" align="center">
    		<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    	</td>
    </tr>
</table>
<div id="div_dupinfo" style="display: none; position: absolute; left: 12px; top: 200px; width: 180px; height: 72px; color: red; background-color: #EEEEEE; padding: 10px; border: 1px solid #777777;"><font style="font-size: 12px;">전화번호 중복 제거중입니다.<br/><br/>전화번호가 많을 때에는<br/>작업이 오래 소요될 수 있으니<br/>잠시만 기다려 주시기 바랍니다.</font></div>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</body>
</html>