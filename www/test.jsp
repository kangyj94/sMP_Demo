<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<script>

//콤마찍기
function fnInputComma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
//콤마풀기
function fnInputUncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}
function fnInputCommaFormat(obj) {
    obj.value = fnInputComma(fnInputUncomma(obj.value));
}

</script>
실시간 콤마 : <input type="text" name="cma_test" id="cma_test" onkeyup="fnInputCommaFormat(this);" onchange="fnInputCommaFormat(this);" /><br />
 
 
 
콤마제거 : <input type="text" name="cma_test2" id="cma_test2" readonly="readonly" />
<input type="button" value="콤마제거"
onclick="document.getElementById('cma_test2').value = removeComma(document.getElementById('cma_test').value)" /><br />
 
 
 
콤마삽입 : <input type="text" name="cma_test3" id="cma_test3" readonly="readonly" />
<input type="button" value="콤마삽입"
onclick="document.getElementById('cma_test3').value = commaSplit(document.getElementById('cma_test2').value)" />
 
 </html>