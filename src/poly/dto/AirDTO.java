package poly.dto;

public class AirDTO {

	private double pm10; // 미세먼지
	private double pm25; // 초미세먼지
	private double o3; // 오존층
	private double no2; // 이산화 질소
	private double co; // 이산화 탄소
	private double so2; // 이산화 황
	private String air; // 대기

	private String url;
	private String collect_time; // 수집시간

	public double getPm10() {
		return pm10;
	}

	public void setPm10(double pm10) {
		this.pm10 = pm10;
	}

	public double getPm25() {
		return pm25;
	}

	public void setPm25(double pm25) {
		this.pm25 = pm25;
	}

	public double getO3() {
		return o3;
	}

	public void setO3(double o3) {
		this.o3 = o3;
	}

	public double getNo2() {
		return no2;
	}

	public void setNo2(double no2) {
		this.no2 = no2;
	}

	public double getCo() {
		return co;
	}

	public void setCo(double co) {
		this.co = co;
	}

	public double getSo2() {
		return so2;
	}

	public void setSo2(double so2) {
		this.so2 = so2;
	}

	public String getAir() {
		return air;
	}

	public void setAir(String air) {
		this.air = air;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getCollect_time() {
		return collect_time;
	}

	public void setCollect_time(String collect_time) {
		this.collect_time = collect_time;
	}

}
