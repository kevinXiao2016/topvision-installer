<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<HTML><HEAD>
<TITLE></TITLE>
<%@include file="../include/cssStyle.inc"%>
<fmt:setBundle basename="com.topvision.ems.resources.resources" var="resources"/>
<link rel="stylesheet" type="text/css" href="../css/gui.css">
<link rel="stylesheet" type="text/css" href="../css/<%= cssStyleName %>/mytheme.css">
<script type="text/javascript" src="../js/zeta-core.js"></script>
<script>
function cancelClick() {
    window.parent.closeWindow('modalDlg');
}
</script>
</HEAD><BODY class=POPUP_WND style="padding:10px">
    <div class="productmain">
        <div class="productcontent">
            <h4>
                <fmt:message bundle="${resources}" key="COMMON.contactUs" />
            </h4>
        </div>
        <div class="porductIntro" style="padding: 0 10px">
            <P>
                <STRONG>深圳市飞鸿光电子有限公司</STRONG>
            </P>
            <P>
                
                <fmt:message bundle="${resources}" key="COMMON.AfterSalesTel" />：400-666-9302/0755-86051202
                <BR>
                <fmt:message bundle="${resources}" key="COMMON.supportCalls" />：400-666-9302/0755-86051202
                <BR>
                <fmt:message bundle="${resources}" key="COMMON.companyFax" />：0755-86051253
                <BR>
                公司地址：深圳市南山中山园路 1001 号 TCL 科学园区研发楼 D1 栋 5 楼
                <BR>
                <fmt:message bundle="${resources}" key="COMMON.ZipCode" />：518055
                <BR><BR><BR><BR>
            </P>        
        </div>
        <div>
            <button style="margin-left: 380px;" class=BUTTON75 type="button"
                onMouseOver="this.className='BUTTON_OVER75'"
                onmousedown="this.className='BUTTON_PRESSED75'"
                onMouseOut="this.className='BUTTON75'" onclick="cancelClick()">
                <fmt:message bundle="${resources}" key="COMMON.close" />
            </button>
        </div>
    </div>
</BODY></HTML>
