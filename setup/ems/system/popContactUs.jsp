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
                <STRONG>Please contact our dealer directly!</STRONG>
                <BR>
            </P>
            <P>
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
