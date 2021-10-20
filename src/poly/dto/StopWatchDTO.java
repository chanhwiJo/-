package poly.dto;

public class StopWatchDTO {

	private String user_no; // 번호
	private String starttime; // 시작 시간
	private String lasttime; // 마무리 시간
	private String walk_day; // 날짜
	private String data; // 차트 데이터
	private String data1; // 차트 데이터

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public String getData1() {
		return data1;
	}

	public void setData1(String data1) {
		this.data1 = data1;
	}

	public String getUser_no() {
		return user_no;
	}

	public void setUser_no(String user_no) {
		this.user_no = user_no;
	}

	public String getStarttime() {
		return starttime;
	}

	public void setStarttime(String starttime) {
		this.starttime = starttime;
	}

	public String getLasttime() {
		return lasttime;
	}

	public void setLasttime(String lasttime) {
		this.lasttime = lasttime;
	}

	public String getWalk_day() {
		return walk_day;
	}

	public void setWalk_day(String walk_day) {
		this.walk_day = walk_day;
	}

}
