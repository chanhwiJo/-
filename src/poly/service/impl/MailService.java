package poly.service.impl;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.MailDTO;
import poly.service.IMailService;
import poly.util.CmmUtil;

@Service("MailService")
public class MailService implements IMailService {

	private Logger log = Logger.getLogger(this.getClass());

	final String host = "smtp.gmail.com";// 구글에서 제공하는 SMTP서버
	final String user = "cksgnl42853625@gmail.com"; // 본인 구글 아이디
	final String password = "!cks980514";// 본인 구글 비밀번호

	@Override
	public int doSendMail(MailDTO pDTO) {

		log.info(this.getClass().getName() + ".doSendMail start!!");

		// 메일 발송 성공 여부(발송성공:1/발송실패:0)
		int res = 1;
		// 전달 받은 DTO로부터 데이터 가져오기(DTO객체가 메모리에 올라가지 않아 null이 발생할 수 있기 때문에 if문으로 에러방지함)
		if (pDTO == null) {
			pDTO = new MailDTO();
		}

		String toMail = CmmUtil.nvl(pDTO.getToMail());// 받는사람

		// Properties props = new Properties();
		// props.put("mail.smtp.host", host);// javax 외부 라이브러리에 메일 보내는 사람의 정보 설정
		// props.put("mail.smtp.auth", "true");// javax 외부 라이브러리에 메일 보내는 사람 인증 여부 설정

		Properties props = new Properties();
	    props.put("mail.smtp.host", "smtp.gmail.com"); 
	    props.put("mail.smtp.port", "25"); 
	    props.put("mail.debug", "true"); 
	    props.put("mail.smtp.auth", "true"); 
	    props.put("mail.smtp.starttls.enable","true"); 
	    props.put("mail.smtp.EnableSSL.enable","true");
	    props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");   
	    props.setProperty("mail.smtp.socketFactory.fallback", "false");   
	    props.setProperty("mail.smtp.port", "465");   
	    props.setProperty("mail.smtp.socketFactory.port", "465"); 
		
		// 네이버 SMTP서버 인증 처리 로직
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, password);//네이버에로그인이 될 수 있도록 ID 비밀번호 정보입력해준다.
			}
		});

		try {
			MimeMessage message = new MimeMessage(session);//네이버에 로그인이 된 세션 정보를 가지고 메세지를 생성을 한다.
			message.setFrom(new InternetAddress(user));//보내는사람 네이버에 로그인한 계쩡
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(toMail));//RecipientType.TO => 보내는 사람을 누구로 할거냐? toMail받는사람

			// 메일 제목
			message.setSubject(CmmUtil.nvl(pDTO.getTitle()));
			// 메일 내용
			message.setText(CmmUtil.nvl(pDTO.getContents()));
			// 메일 발송
			Transport.send(message);

		} catch (MessagingException e) { // 메일 전송 관련 에러 다잡기
			res = 0; // 메일 발송이 실패하기 때문에 0으로 변경
			log.info("[ERROR] " + this.getClass().getName() + ".doSendMail : " + e);

		} catch (Exception e) {
			res = 0;
			log.info("[ERROR] " + this.getClass().getName() + ".doSendMail : " + e);
		}

		// 로그 찍기
		log.info(this.getClass().getName() + ".doSendMail end!!");
		return res;
	}

}
