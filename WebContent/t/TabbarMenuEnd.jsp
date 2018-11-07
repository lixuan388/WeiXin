<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>



            </div>
            <div class="weui-tabbar">
                <a href="/WeiXin/tx/index.jsp" class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_article.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">首页</p>
                </a>
                <a href="/WeiXin/tx/MedicalProjectSelect.jsp" class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_icons.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">预约挂号</p>
                </a>
                <a href="/WeiXin/tx/QueryMemberBookingDate.jsp" class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_cell.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">我的预约</p>
                </a>
                <a href="/WeiXin/tx/MemberInfo.jsp" class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_panel.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">我</p>
                </a>

				<% 	
					String groupid=request.getSession().getAttribute("groupid")==null?"":(String)request.getSession().getAttribute("groupid");
					if (groupid.equals("100"))
					{
						%>

                <a href="/WeiXin/tx/QueryBookingDateList.jsp " class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_search_bar.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">预约管理</p>
                </a>
                <a href="/WeiXin/tx/BackStage/index.jsp" class="weui-tabbar__item">
                    <img src="/css/images/icon_nav_button.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">后台管理</p>
                </a>
						<%
					}
 				%>
            </div>
        </div>
    </div>
</div>