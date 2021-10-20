package poly.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.RemoteEndpoint.Basic;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@ServerEndpoint(value = "/echo.do") 
public class chatController {
	private static final List<Session> sessionList = new ArrayList<>();
	private static final Logger log = LoggerFactory.getLogger(chatController.class);

	// 채팅 아이디 입력 페이지
	@RequestMapping(value="/chatId")
	public String chatId() {
		log.info(getClass()  + "chatId start!!!");
		log.info(getClass()  + "chatId end!!!");
		return "/home/chatId";
	}
	
	public chatController() {
		System.out.println("웹소켓 서버 객체 생성");
	}

	@RequestMapping(value = "/chat.do")
	public ModelAndView getChatViewPage(ModelAndView mav, HttpServletRequest request,HttpSession session) {
		session.setAttribute("session_user_id", request.getParameter("chatId"));
		log.info("session_user_id : " + request.getParameter("chatId"));
		mav.setViewName("/chat");
		return mav;
	}

	@OnOpen
	public void onOpen(Session session) {
		log.info("Open session id:" + session.getId());
		try {
			final Basic basic = session.getBasicRemote();
			basic.sendText("Chat Open");
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		sessionList.add(session);
	}
	
	/*
     * 모든 사용자에게 메시지를 전달한다.
     * @param self
     * @param message
     */
	private void sendAllsessionToMessage(Session self, String message) {
		try {
			for (Session session : chatController.sessionList) {
				if (!self.getId().equals(session.getId())) {
					session.getBasicRemote().sendText(message);
				}
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	@OnMessage
	public void onMessage(String message, Session session) {
		log.info(message);
		try {
			final Basic basic = session.getBasicRemote();
			basic.sendText(message);	
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		sendAllsessionToMessage(session, message);
	}

	@OnError
	public void onError(Throwable e, Session session) {

	}

	@OnClose
	public void onClose(Session session) {
		log.info("session " + session.getId() + " has ended");
		sessionList.remove(session);
	}

}