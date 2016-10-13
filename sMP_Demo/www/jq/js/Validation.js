function jsByteLength(str) {
	if (str == "") {
		return	0;
	}

	var len = 0;

	for (var i = 0; i < str.length; i++) {
		if (str.charCodeAt(i) > 128) {
			len++;
		}
		len++;
	}

	return	len;
}

//email 의 형식에 맞는지 체크하는 함수
function is_email( p_email ) {
	var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;

	if (p_email.search(format) != -1) {
        return true; //올바른 포맷 형식
    }
    return false;
}

//핸드폰 형식에 맞는지 체크
function is_cellular(p_phone) {
	var format = /01[016789][1-9]{1}[0-9]{2,3}[0-9]{4}$/g;		
	
	return format.test(p_phone);
}

function is_phone(p_phone) {
	var format = /(02|0[3-9]{1}[0-9]{1})-[1-9]{1}[0-9]{2,3}-[0-9]{4}$/g;
	
	return format.test(p_phone);
}

function is_number(p_num) {
	var format = /[^0-9]/g;
	return !format.test(p_num);
}

/**
 * 특수문자 체크
 * @param str : 비교문자
 * @param exception : 예외문자
 */
function checkString(str , exception) {
	if(exception == null) { exception = "";}	
	var check = "!@#^&*()=+\|/?,.:<>$;%-";
	var rtn = true;
	
	for(var i=0; i < str.length; i++) {
		var checkVal = str.charAt(i);
		if(check.indexOf(checkVal) > -1) {
			if(exception.indexOf(checkVal) > -1) {
				continue;
			}
			rtn = false;
			break;
		}
	}
	return rtn;
}

/**
 * CTN에 대한 Validation 체크
 * 
 * @param midCtnObj
 * @param lastCtnObj
 * @returns {Boolean}
 */
function checkValidationByCtn(midCtnObj, lastCtnObj) {
	if(midCtnObj.value == "") {
		alert ("핸드폰 번호의 가운데 자리를 입력해 주세요.");
		midCtnObj.focus();
		return false;
	}
	
	if(midCtnObj.value.length < 3 || midCtnObj.value.length > 4) {
		alert("핸드폰 번호의 가운데 자리가 형식에 맞지 않습니다.\n\n3자리나 4자리 숫자를 입력해주세요.");
		midCtnObj.focus();
		return false;
	}
	
	if(isNaN(midCtnObj.value) || midCtnObj.value.indexOf("-") >= 0) {
		alert( "핸드폰 번호의 가운데 자리는 숫자만 입력해주세요." );
		midCtnObj.focus();
		return;
	}
	
	if(lastCtnObj.value == "") {
		alert ("핸드폰 번호의 끝 자리를 입력해 주세요.");
		lastCtnObj.focus();
		return false;
	}
	
	if(lastCtnObj.value.length != 4) {
		alert("핸드폰 번호의 끝 자리가 형식에 맞지 않습니다.\n\n4자리 숫자를 입력해주세요.");
		lastCtnObj.focus();
		return false;
	}
	
	if(isNaN(lastCtnObj.value) || lastCtnObj.value.indexOf("-") >= 0) {
		alert( "핸드폰 번호의 끝 자리는 숫자만 입력해주세요." );
		lastCtnObj.focus();
		return false;
	}
	
	return true;
}

/**
 * 주민번호에 대한 Validation 체크
 * 
 * @param prePersObj
 * @param nextPersObj
 * @returns {Boolean}
 */
function checkValidationByPersnalID(prePersObj, nextPersObj) {
	if( prePersObj.value == '' ) {
		alert( "주민번호 앞 6자리를 입력해주세요" );
		prePersObj.focus();
		return false;
	}
	
	if( prePersObj.value.length != 6 ) {
		alert( "주민번호 형식에 맞지 않습니다.\n\n주민번호 앞 6자리를 입력해주세요." );
		prePersObj.focus();
		return false;
	}
	
	if(isNaN(prePersObj.value) || prePersObj.value.indexOf("-") >= 0) {
		alert( "주민번호 앞 6자리는 숫자만 입력해주세요." );
		prePersObj.focus();
		return false;
	}
	
	if( nextPersObj.value == '' ) {
		alert( "주민번호 뒤 7자리를 입력해주세요" );
		nextPersObj.focus();
		return false;
	}
	
	if( nextPersObj.value.length != 7 ) {
		alert( "주민번호 형식에 맞지 않습니다.\n\n주민번호 뒤 7자리를 입력해주세요." );
		nextPersObj.focus();
		return false;
	}
	
	if(isNaN(nextPersObj.value) || nextPersObj.value.indexOf("-") >= 0) {
		alert( "주민번호 뒤 7자리는 숫자만 입력해주세요." );
		nextPersObj.focus();
		return false;
	}
	
	return true;
}

/**
 * 파일 확장자 체크
 * 
 * @param fileName
 * @returns {Boolean}
 */
function isPossibleFileExtension(fileName) {
	var denyExt = "lg|jsp|php|sh|html|js|exe";
	
	var fileExt = fileName.substring(fileName.lastIndexOf(".")+1);
	
	if(denyExt.indexOf(fileExt) >= 0) {
		return false;
	} else {
		return true;
	}
}