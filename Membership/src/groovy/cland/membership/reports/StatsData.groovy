package cland.membership.reports;

public class StatsData {
	//** PARENTS/clients
	public int num_new_clients=0;
	public int num_clients = 0;
	
	//** Children
	public int num_new_children = 0;
	public int num_children = 0;
	public int num_promo_children=0
	
	//** VISITS
	public int num_new_visits =0;
	public int num_visits =0;
	
	//** Notifications
	public int num_notifications =0
	
	//** BOOKINGS
	public int num_bookings = 0;
	
	//** COUPONS
	public int num_coupons = 0;
	public int num_new_coupons= 0

	@Override
	public String toString() {
		return "StatsData [num_new_clients=" + num_new_clients
				+ ", num_clients=" + num_clients + ", num_new_children=" + num_new_children
				+ ", num_children=" + num_children + ", num_visits="
				+ num_visits + ", num_new_visits="
				+ num_new_visits + ", num_coupons=" + num_coupons + ", num_bookings=" + num_bookings + "]";
	}
	
}
