package c_gh.maxymania.gaecms;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class Settings {
	private static final String LIST_PREFIX = "list_";
	public static final String LIST_ADMIN_LHLINK = "admin_LHlink";
	public static final String LIST_ADMIN_HLINK = "admin_Hlink";
	public static final String LIST_SITEBAR_LHLINK = "sitebar_LHlink";
	public static final String LIST_SITEBAR_HLINK = "sitebar_Hlink";
	public static final String LIST_MENU_LHLINK = "menu_LHlink";
	public static final String LIST_ADMIN_FILES_LHLINK = "admin_files_LHlink";
	public static final String LIST_ADMIN_ARTICLES_LHLINK = "admin_articles_LHlink";
	public static final String SETTINGS = "Settings";
	private DatastoreService service;
	public Settings(){
		service = DatastoreServiceFactory.getDatastoreService();
	}
	public class Config{
		Entity entity;
		public void reset(){
			entity.setProperty("wstitle", "GAE Content Management System");
			entity.setProperty("wstitle2", "Yet another subtitle");
			reset2();
		}
		public void reset2(){
			entity.setProperty("defaultAction", "blog");
			entity.setProperty("allowComments", true);
			entity.setProperty(LIST_PREFIX+LIST_ADMIN_LHLINK, "Sites,Wiki,Files");
			entity.setProperty(LIST_PREFIX+LIST_ADMIN_FILES_LHLINK, "Files");
			entity.setProperty(LIST_PREFIX+LIST_ADMIN_ARTICLES_LHLINK, "Sites,Wiki");
			entity.setProperty(LIST_PREFIX+LIST_ADMIN_HLINK, "Blogroll");
			entity.setProperty(LIST_PREFIX+LIST_SITEBAR_LHLINK, "");
			entity.setProperty(LIST_PREFIX+LIST_SITEBAR_HLINK, "Blogroll");
			entity.setProperty(LIST_PREFIX+LIST_MENU_LHLINK, "Sites");
		}
		public void store(){
			service.put(entity);
		}
		public String defaultAction(){
			return (String)entity.getProperty("defaultAction");
		}
		public void defaultAction(String a){
			entity.setProperty("defaultAction", a);
		}
		public void allowComments(boolean b){
			entity.setProperty("allowComments", b);
		}
		public boolean allowComments(){
			Boolean b = (Boolean)entity.getProperty("allowComments");
			if(b==null)b=true;
			return b;
		}
		public String wstitle(){
			return (String)entity.getProperty("wstitle");
		}
		public void wstitle(String a){
			entity.setProperty("wstitle", a);
		}
		public String wstitle2(){
			return (String)entity.getProperty("wstitle2");
		}
		public void wstitle2(String a){
			entity.setProperty("wstitle2", a);
		}
		public String listV(String listname){
			return (String)entity.getProperty(LIST_PREFIX+listname);
		}
		public void listV(String listname,String data){
			entity.setProperty(LIST_PREFIX+listname, data);
		}
		public String[] list(String listname){
			String s = (String)entity.getProperty(LIST_PREFIX+listname);
			if(s==null||"".equals(s))return new String[]{};
			return s.split(",");
		}
	}
	static Key key(){
		return KeyFactory.createKey(SETTINGS, "def");
	}
	
	public Config load(){
		Config cfg = new Config();
		try {
			cfg.entity = service.get(key());
		} catch (EntityNotFoundException e) {
			cfg.entity = new Entity(key());
			cfg.reset();
		}
		return cfg;
	}
}
