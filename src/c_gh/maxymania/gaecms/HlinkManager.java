package c_gh.maxymania.gaecms;

import java.util.LinkedList;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Link;
import com.google.appengine.api.datastore.Query;


public class HlinkManager {
	public static final String LHLINK = "LHlink";
	public static final String HLINK = "Hlink";
	private DatastoreService service;
	public HlinkManager(){
		service = DatastoreServiceFactory.getDatastoreService();
	}
	public Iterable<LHlink> getLHLinks(int max,int page,String cat){
		Query query = new Query(LHLINK);
		query.addSort("text",Query.SortDirection.ASCENDING);
		if(cat!=null)
			query.setFilter(new Query.FilterPredicate("cat", Query.FilterOperator.EQUAL, cat));
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		LinkedList<LHlink> cmts = new LinkedList<LHlink>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			LHlink c = new LHlink();
			c.text = (String)e.getProperty("text");
			c.cat = (String)e.getProperty("cat");
			c.href = (String)e.getProperty("href");
			c.__id=KeyFactory.keyToString(e.getKey()); // for administration purposes
			cmts.offerFirst(c);
		}
		}catch(Exception e){}
		return cmts;
	}
	public Iterable<Hlink> getHLinks(int max,int page,String cat){
		Query query = new Query(HLINK);
		query.addSort("text",Query.SortDirection.ASCENDING);
		if(cat!=null)
			query.setFilter(new Query.FilterPredicate("cat", Query.FilterOperator.EQUAL, cat));
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		LinkedList<Hlink> cmts = new LinkedList<Hlink>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			Hlink c = new Hlink();
			c.text = (String)e.getProperty("text");
			c.cat = (String)e.getProperty("cat");
			c.href = (Link)e.getProperty("href");
			c.__id=KeyFactory.keyToString(e.getKey()); // for administration purposes
			cmts.offerFirst(c);
		}
		}catch(Exception e){}
		return cmts;
	}
	public void store(Hlink link){
		Entity e;
		if(link.__id!=null){
			Key k = KeyFactory.stringToKey(link.__id);
			e = new Entity(k);
		}else{
			e = new Entity(HLINK);
		}
		e.setProperty("text", link.text);
		e.setProperty("cat", link.cat);
		e.setProperty("href", link.href);
		service.put(e);
	}
	public void store(LHlink link){
		Entity e;
		if(link.__id!=null){
			Key k = KeyFactory.stringToKey(link.__id);
			e = new Entity(k);
		}else{
			e = new Entity(LHLINK);
		}
		e.setProperty("text", link.text);
		e.setProperty("cat", link.cat);
		e.setProperty("href", link.href);
		service.put(e);
	}
	public void delete(String id){
		Key k = KeyFactory.stringToKey(id);
		if(LHLINK.equals(k.getKind())||HLINK.equals(k.getKind()))
			service.delete(k);
	}
}
