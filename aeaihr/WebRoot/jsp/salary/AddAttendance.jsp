<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.Date" %>
<%@ page import="com.agileai.util.DateUtil" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://www.agileai.com" prefix="aeai"%>
<jsp:useBean id="pageBean" scope="request" class="com.agileai.hotweb.domain.PageBean"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>添加考勤</title>
<%@include file="/jsp/inc/resource.inc.jsp"%>
<script type="text/javascript">
function addDateRow(days,nextDate,week){
	$("#atdDay tbody").append('<tr id="day'+days+'"></tr>');
	$("#atdDay tr:last").append('<th width="100" nowrap="nowrap">第'+(days+1)+'天</th>');
	$("#atdDay tr:last").append('<td width="10" nowrap="nowrap"><input name="EMP_INDUCTION_TIME'+days+'" type="text" class="text" id="EMP_INDUCTION_TIME'+days+'" value="'+nextDate+'" size="16" onchange="changeWeek('+days+')" readonly="readonly" label="日期" /></td>');
	$("#atdDay tr:last").append('<td>&nbsp;&nbsp;<img id="EMP_INDUCTION_TIMEPicker'+days+'" src="images/calendar.gif" width="16" height="16" alt="日期/时间选择框" /></td>');	
	$("#atdDay tr:last").append('<td width="10" nowrap="nowrap"><input name="EMP_INDUCTION_WEEK'+days+'" type="text" class="text" id="EMP_INDUCTION_WEEK'+days+'" value="'+week+'" size="16" readonly="readonly" label="日期" /></td>');
	$("#atdDay tr:last").append('<td>&nbsp;<img id="delImgBtn" style="display: inline;" src="images/delete.gif" width="16" height="16" onclick="deleteDate('+days+')"></td>')
	
	$("#atdDay").append('<input type="hidden" name="attendanceDate'+days+'" id="attendanceDate'+days+'" value="'+nextDate+'" />');
	
	initCalendar('EMP_INDUCTION_TIME'+days,'%Y-%m-%d','EMP_INDUCTION_TIMEPicker'+days);
	datetimeValidators[days].set("yyyy-MM-dd").add("EMP_INDUCTION_TIME"+days);	
}
function addAttendance(){
	var a = ["日", "一", "二", "三", "四", "五", "六"]; 
	var days = $("#atdDay tr").length;
	var lastDate = $("#EMP_INDUCTION_TIME"+(days-1)).val();
	var nextDate = addDay(lastDate);
	var day = new Date(nextDate).getDay();
	var week = "星期"+ a[day];
	addDateRow(days,nextDate,week);
}
function saveAttendance(){
	var days = $("#atdDay tr").length;
	for(var i=0; i<days; i++){
		$("#attendanceDate"+i).val($("#EMP_INDUCTION_TIME"+i).val());
	}
	if($("#atdPlace").val() == null || $("#atdPlace").val() == ""){
		if($("#attendancePlace").val() == null || $("#attendancePlace").val() == ""){
			showMessage('请输入签到地点！');
			return;
		}
		$("#atdPlace").val($("#attendancePlace").val());
	}
	if(checkDate()){
		showMessage('日期重复，请检查！');
		return;
	}
	var addDay = $("#atdDay tr").length;
	var data = 'addDay='+addDay;	
  	jConfirm("确认提交"+days+"条数据？",function(r){
		if(r){
			postRequest('form1',{actionType:'save',data:data,onComplete:function(responseText){
				if (responseText == 'success'){
					window.parent.location.reload();
				}else{
					showMessage('添加考勤出错！');
				}
			}});
		}
	});
}
function checkDate(){
	var days = $("#atdDay tr").length;
	for(var i=0; i<days; i++){
		for(var j=i+1; j<days; j++){
			if($("#attendanceDate"+i).val() == $("#attendanceDate"+j).val()){
				return true;
			}else{
				return false;
			}
		}
	}
}
function addDay(dateStr){
	var date = new Date(dateStr);
	date.setDate(date.getDate()+1);
	var dateVal = date.getDate();
	if(dateVal < 10){
		dateVal = '0'+dateVal;
	}
	var month = date.getMonth()+1;
	if(month < 10){
		month = '0'+month;
	}
	return date.getFullYear()+'-'+month+'-'+dateVal;
}

function deleteDate(n){
	var addDays = n;
	var rows = $("#atdDay tr").length;
	var curDate = $("#EMP_INDUCTION_TIME"+n).val();
	if(rows<=1){
		showMessage('当前只有一条记录！');
		return;
	}
	for(n; n<rows; n++){
		$("#day"+n).remove();
		$("#attendanceDate"+n).remove();
	}
	for(addDays; addDays<rows-1; addDays++){
		var curDate = addDay(curDate);
		var a = ["日", "一", "二", "三", "四", "五", "六"]; 
		var day = new Date(curDate).getDay();
		var week = "星期"+ a[day];
		addDateRow(addDays,curDate,week);
	}
}
function changeWeek(n){
	var a = ["日", "一", "二", "三", "四", "五", "六"]; 
	var curDate = $("#EMP_INDUCTION_TIME"+n).val();
	var day = new Date(curDate).getDay();
	var week = "星期"+ a[day];
	$("#EMP_INDUCTION_WEEK"+n).val(week);
}
</script>
</head>
<body>
<form action="<%=pageBean.getHandlerURL()%>" name="form1" id="form1" method="post">
<%@include file="/jsp/inc/message.inc.jsp"%>
<div id="__ParamBar__" style="float: right;">&nbsp;</div>
<div id="__ToolBar__">
<table border="0" cellpadding="0" cellspacing="1">
<tr>
	<aeai:previlege code="add"><td onmouseover="onMover(this);" onmouseout="onMout(this);" class="bartdx" align="center" onclick="addAttendance()" ><input value="&nbsp;" type="button" class="addImgBtn" id="addImgBtn" title="添加" />添加</td></aeai:previlege> 
	<aeai:previlege code="save"><td onmouseover="onMover(this);" onmouseout="onMout(this);" class="bartdx" align="center" onclick="saveAttendance()" ><input value="&nbsp;" type="button" class="saveImgBtn" id="saveImgBtn" title="保存" />保存</td></aeai:previlege>
	<aeai:previlege code="close"><td onmouseover="onMover(this);" onmouseout="onMout(this);" class="bartdx" align="center" onclick="parent.PopupBox.closeCurrent()"><input value="&nbsp;" type="button" class="closeImgBtn" title="关闭" />关闭</td></aeai:previlege>
</tr>
</table>
</div>
<table>
<tr>
	<td width="105" nowrap="nowrap"><strong>签到地点</strong></td>
	<td width="10" nowrap="nowrap"><input name="attendancePlace" type="text" class="text" id="attendancePlace" value="" size="17" label="签到地点" /></td>
</tr>
</table>
<table id="atdDay" cellpadding="0" cellspacing="0" class="detailTable">
  <%
  if(pageBean.getAttribute("dateDiff")!=null){
  	long addDate = (Long)pageBean.getAttribute("dateDiff");
  	Date inductionDate = (Date)pageBean.getAttribute("EMP_INDUCTION_TIME");
  	for(int i = 0; i<addDate; i++){
  		Date nextDate = DateUtil.getDateAdd(inductionDate, 1, i);
  		String nextDay = DateUtil.getDateByType(DateUtil.YYMMDD_HORIZONTAL, nextDate);
  		String nextWeek = DateUtil.getWeekText(nextDate);
  	%>
  	  <tr id="day<%=i%>">
	    <th width="100" nowrap="nowrap">第<%=i+1%>天</th>
	    <td width="10" nowrap="nowrap"><input name="EMP_INDUCTION_TIME<%=i%>" type="text" class="text" id="EMP_INDUCTION_TIME<%=i%>" value="<%=nextDay%>" size="16" onchange="changeWeek(<%=i%>)" readonly="readonly" label="日期" /></td>
	    <td>&nbsp;&nbsp;<img id="EMP_INDUCTION_TIMEPicker<%=i%>" src="images/calendar.gif" width="16" height="16" alt="日期/时间选择框" /></td>
	    <td width="10px" nowrap="nowrap"><input name="EMP_INDUCTION_WEEK<%=i%>" type="text" class="text" id="EMP_INDUCTION_WEEK<%=i%>" value="<%=nextWeek%>" size="16" readonly="readonly" label="日期" /></td>
	    <td>&nbsp;<img id="delImgBtn" style="display: inline;" src="images/delete.gif" width="16" height="16" onclick="deleteDate(<%=i%>)"></td>
	  </tr>
	  <input type="hidden" name="attendanceDate<%=i%>" id="attendanceDate<%=i%>" value="<%=nextDay%>" />
	  <script>
	  	initCalendar('EMP_INDUCTION_TIME<%=i%>','%Y-%m-%d','EMP_INDUCTION_TIMEPicker<%=i%>');
	  	datetimeValidators[<%=i%>].set("yyyy-MM-dd").add("EMP_INDUCTION_TIME<%=i%>");
	  </script>	  
  <%}%>
</table>
<input type="hidden" name="actionType" id="actionType" value=""/>
<input type="hidden" name="inductionDate" id="inductionDate" value="<%=pageBean.inputValue("inductionDate")%>"/>
<input type="hidden" name="salUser" id="salUser" value="<%=pageBean.inputValue("salUser")%>">
<input type="hidden" name="atdPlace" id="atdPlace" value="" />
</form>
<%}%>
</body>
</html>
<%@include file="/jsp/inc/scripts.inc.jsp"%>
