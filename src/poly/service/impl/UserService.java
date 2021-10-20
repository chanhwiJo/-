package poly.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.BoardDTO;
import poly.dto.KeyDTO;
import poly.dto.MailDTO;
import poly.dto.ManageDTO;
import poly.dto.TxtDTO;
import poly.dto.UserDTO;
import poly.persistance.mapper.UserMapper;
import poly.service.IMailService;
import poly.service.IUserService;
import poly.util.CmmUtil;

@Service("UserService")
public class UserService implements IUserService {

	@Resource(name = "UserMapper")
	private UserMapper userMapper;

	@Resource(name = "MailService")
	private IMailService mailService;

	private Logger log = Logger.getLogger(this.getClass());

	// 회원가입
	@Override
	public int insertJoin(UserDTO uDTO) throws Exception {
		return userMapper.insertJoin(uDTO);
	}

	// 아이디중복체크
	@Override
	public int getUserid(UserDTO uDTO) throws Exception {
		return userMapper.getUserid(uDTO);
	}

	// 이메일 중복 확인
	@Override
	public int getEmail(UserDTO uDTO) throws Exception {
		return userMapper.getEmail(uDTO);
	}

	// 인증키생성
	@Override
	public int insertKey(KeyDTO kDTO) throws Exception {
		return userMapper.insertKey(kDTO);
	}

	// 아이디 찾기
	@Override
	public UserDTO getIdSearch(UserDTO uDTO) throws Exception {
		return userMapper.getIdSearch(uDTO);
	}

	// 이메일 인증
	@Override
	public KeyDTO getEmailKey(KeyDTO kDTO) throws Exception {
		return userMapper.getEmailKey(kDTO);
	}
	
	// 로그인
	@Override
	public UserDTO getUserInfo(UserDTO uDTO) throws Exception {
		return userMapper.getUserInfo(uDTO);
	}

	// 비밀번호 변경
	@Override
	public int updatePassword(UserDTO pDTO) throws Exception {
		return userMapper.updatePassword(pDTO);
	}

	// 비밀번호 정보(아이디, 이메일)
	@Override
	public UserDTO getPassword(UserDTO uDTO) throws Exception {
		return userMapper.getPassword(uDTO);
	}

	// 비밀번호찾기(아이디, 이메일, 전화번호 일치확인)
	@Override
	public int checkPassword(UserDTO pDTO) throws Exception {

		int res = 0;

		UserDTO rDTO = userMapper.checkPassword(pDTO);

		if (rDTO == null) {
			rDTO = new UserDTO();
		}

		log.info("exists_yn : " + rDTO.getExists_yn());

		if (CmmUtil.nvl(rDTO.getExists_yn()).equals("Y")) {
			res = 1;
		} else if (CmmUtil.nvl(rDTO.getExists_yn()).equals("N")) {
			res = 0;
		} else {
			res = 2;
		}

		return res;

	}

	// 랜덤 비밀번호 변경
	@Override
	public int autoPassword(UserDTO pDTO) throws Exception {
		return userMapper.autoPassword(pDTO);
	}

	// 비밀번호 메일 발송
	@Override
	public int pwmail(UserDTO pDTO) throws Exception {
		int res = 0;
		res = userMapper.autoPassword(pDTO);
		log.info("user_password :" + pDTO.getPassword());
		log.info("user_password_temp :" + pDTO.getTemp());
		// 메일발송 로직
		MailDTO mDTO = new MailDTO();

		// 이메일 복호화
		mDTO.setToMail(pDTO.getEmail());
		mDTO.setTitle("산책조아 임시 비밀번호입니다.");
		mDTO.setContents(CmmUtil.nvl(pDTO.getUser_id() + " 님의 비밀번호는[ " + pDTO.getTemp() + " ]입니다."));

		// 메일 발송
		mailService.doSendMail(mDTO);

		return res;
	}

	// 아이디 여부 체크
	@Override
	public int idCheck(UserDTO pDTO) throws Exception {
		return userMapper.idCheck(pDTO);
	}

	// 메인페이지 > 회원
	@Override
	public UserDTO getUserNum() throws Exception {
		return userMapper.getUserNum();
	}

	// 메인페이지 > 게시판
	@Override
	public BoardDTO getBoardNum() throws Exception {
		return userMapper.getBoardNum();
	}

	// 메인페이지 > 동호회
	@Override
	public ManageDTO getManageNum() throws Exception {
		return userMapper.getManageNum();
	}

	// 작성글 리스트
	@Override
	public List<BoardDTO> getRegList(String user_no) throws Exception {
		return userMapper.getRegList(user_no);
	}

	// 총 작성글 개수
	@Override
	public BoardDTO getRegNum(String user_no) throws Exception {
		return userMapper.getRegNum(user_no);
	}

	// 회원 상세
	@Override
	public UserDTO getUserDetail(UserDTO uDTO) throws Exception {
		return userMapper.getUserDetail(uDTO);
	}

	// 팀명 불러오기
	@Override
	public ManageDTO getTeamName(ManageDTO mDTO) throws Exception {
		return userMapper.getTeamName(mDTO);
	}

	// 작성글 검색
	@Override
	public List<BoardDTO> getRegSearch(BoardDTO bDTO) throws Exception {
		return userMapper.getRegSearch(bDTO);
	}

	// 작성글 검색 결과 수
	@Override
	public BoardDTO getRegSearchNum(BoardDTO sDTO) throws Exception {
		return userMapper.getRegSearchNum(sDTO);
	}

	// 작성글 페이징
	@Override
	public List<BoardDTO> getRegSearchPage(BoardDTO uDTO) throws Exception {
		return userMapper.getRegSearchPage(uDTO);
	}

	// 계정 탈퇴
	@Override
	public int deleteUser(UserDTO uDTO) throws Exception {
		return userMapper.deleteUser(uDTO);
	}

	// 계정 수정
	@Override
	public int updateUser(UserDTO uDTO) throws Exception {
		return userMapper.updateUser(uDTO);
	}

	// 글귀 랜덤 출력
	@Override
	public TxtDTO txtPrint(TxtDTO tDTO) throws Exception {
		return userMapper.txtPrint(tDTO);
	}

	// 성별 분석
	@Override
	public List<UserDTO> getGenderData() throws Exception {
		return userMapper.getGenderData();
	}

	// 동호회 가입 여부 분석
	@Override
	public List<UserDTO> getTeamData() throws Exception {
		return userMapper.getTeamData();
	}

	// 나이 분석
	@Override
	public List<UserDTO> getAgeData() throws Exception {
		return userMapper.getAgeData();
	}

	// 지역 분석
	@Override
	public List<UserDTO> getAddrData() throws Exception {
		return userMapper.getAddrData();
	}

	// 월별 회원 가입 비율 분석
	@Override
	public List<UserDTO> getRegData() throws Exception {
		return userMapper.getRegData();
	}

	// 회원 리스트
	@Override
	public List<UserDTO> getUserList() throws Exception {
		return userMapper.getUserList();
	}

	// 회원 리스트 페이징
	@Override
	public List<UserDTO> getUserPaging(UserDTO uDTO) throws Exception {
		return userMapper.getUserPaging(uDTO);
	}

	// 회원 검색 결과 수
	@Override
	public UserDTO getUserSearchNum(UserDTO sDTO) throws Exception {
		return userMapper.getUserSearchNum(sDTO);
	}

	// 회원 검색 결과 페이징
	@Override
	public List<UserDTO> getUserSearchPage(UserDTO uDTO) throws Exception {
		return userMapper.getUserSearchPage(uDTO);
	}

	// 회원 검색
	@Override
	public List<UserDTO> getUserSearch(UserDTO uDTO) throws Exception {
		return userMapper.getUserSearch(uDTO);
	}
	
}
