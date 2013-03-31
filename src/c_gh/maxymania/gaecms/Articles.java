package c_gh.maxymania.gaecms;

import java.util.Date;
import java.util.LinkedList;
import java.util.Map;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Email;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Text;

public class Articles {
	public static final String ARTICLE = "Article";
	public static final String COMMENT = "Comment";
	public static final String BLOGENTRY = "Blogentry";
	private DatastoreService service;
	public Articles(){
		service = DatastoreServiceFactory.getDatastoreService();
	}
	public Article getArticle(String id){
		Key k = KeyFactory.createKey(ARTICLE, id);
		Entity art;
		try {
			art = service.get(k);
		} catch (EntityNotFoundException e) {
			return null;
		}
		Article artO=new Article();
		artO.id=id;
		artO.title=(String)art.getProperty("title");
		artO.text=((Text)art.getProperty("text")).getValue();
		return artO;
	}
	public Iterable<Article> getArticles(Iterable<String> ids){
		LinkedList<Key> llk = new LinkedList<Key>();
		for(String id:ids){
			Key k = KeyFactory.createKey(ARTICLE, id);
			llk.add(k);
		}
		Map<Key, Entity> mp;
		try {
			mp = service.get(llk);
		} catch (Exception e) {
			return null;
		}
		LinkedList<Article> artl = new LinkedList<Article>();
		for(Key k:llk){
			Entity e=mp.get(k);
			Article art=new Article();
			art.id=k.getName();
			art.title=(String)e.getProperty("title");
			art.text=((Text)e.getProperty("text")).getValue();
			artl.add(art);
		}
		return artl;
	}
	public Iterable<Article> getArticles2(Iterable<String> ids){
		LinkedList<Article> artl = new LinkedList<Article>();
		for(String id:ids){
			Key k = KeyFactory.createKey(ARTICLE, id);
			Entity e;
			try {
				e = service.get(k);
			} catch (EntityNotFoundException e1) {continue;}
			Article art=new Article();
			art.id=id;
			art.title=(String)e.getProperty("title");
			art.text=((Text)e.getProperty("text")).getValue();
			artl.add(art);
		}
		return artl;
	}
	public Iterable<String> getArticleIds(){
		Query query = new Query(ARTICLE).setKeysOnly();
		query.addSort(Entity.KEY_RESERVED_PROPERTY,Query.SortDirection.DESCENDING);
		LinkedList<String> ids = new LinkedList<String>();
		try{
			for(Entity e:service.prepare(query).asIterable()){
				ids.add(e.getKey().getName());
			}
		}catch(Exception e){}
		return ids;
	}
	public Iterable<String> getArticleIds(int max,int page){
		Query query = new Query(ARTICLE).setKeysOnly();
		query.addSort(Entity.KEY_RESERVED_PROPERTY,Query.SortDirection.DESCENDING);
		LinkedList<String> ids = new LinkedList<String>();
		try{
			for(Entity e:service.prepare(query).asIterable(FetchOptions.Builder.withLimit(max).offset(max*page))){
				ids.add(e.getKey().getName());
			}
		}catch(Exception e){}
		return ids;
	}
	public void storeArticle(Article art){
		Entity art2 = new Entity(ARTICLE,art.id);
		art2.setProperty("title", art.title);
		art2.setProperty("text", new Text(art.text));
		service.put(art2);
	}
	public Iterable<Comment> getComments(String id,int max,int page){
		Key k = KeyFactory.createKey(ARTICLE, id);
		Query query = new Query(COMMENT);
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		query.setAncestor(k);
		query.addSort("pubdate",Query.SortDirection.DESCENDING);
		LinkedList<Comment> cmts = new LinkedList<Comment>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			Comment c = new Comment();
			c.email = ((Email)e.getProperty("email")).getEmail();
			c.name = (String)e.getProperty("name");
			c.text = ((Text)e.getProperty("text")).getValue();
			c.__id=KeyFactory.keyToString(e.getKey()); // for administration purposes
			cmts.offerFirst(c);
		}
		}catch(Exception e){}
		return cmts;
	}
	public Iterable<Comment> getComments(int max,int page){
		Query query = new Query(COMMENT);
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		query.addSort("pubdate",Query.SortDirection.DESCENDING);
		LinkedList<Comment> cmts = new LinkedList<Comment>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			Comment c = new Comment();
			c.email = ((Email)e.getProperty("email")).getEmail();
			c.name = (String)e.getProperty("name");
			c.text = ((Text)e.getProperty("text")).getValue();
			c.__id=KeyFactory.keyToString(e.getKey()); // for administration purposes
			cmts.offerFirst(c);
		}
		}catch(Exception e){}
		return cmts;
	}
	public void addComment(String id,Comment c){
		Key k = KeyFactory.createKey(ARTICLE, id);
		Entity e = new Entity(COMMENT,k);
		e.setProperty("email", new Email(c.email));
		e.setProperty("name", c.name);
		e.setProperty("text", new Text(c.text));
		e.setProperty("pubdate", new Date());
		service.put(e);
	}
	public void deleteComment(String __id) {
		Key k = KeyFactory.stringToKey(__id);
		if(COMMENT.equals(k.getKind()))
				service.delete(k);
	}
	public void blogAdd(String id){
		Entity e = new Entity(BLOGENTRY);
		e.setProperty("articleId", id);
		e.setProperty("pubdate", new Date());
		service.put(e);
	}
	public Iterable<String> blogQuery(int max,int page){
		Query query = new Query(BLOGENTRY);
		query.addSort("pubdate",Query.SortDirection.DESCENDING);
		FetchOptions fo = FetchOptions.Builder.withLimit(max).offset(max*page);
		LinkedList<String> ids = new LinkedList<String>();
		try{
		for(Entity e:service.prepare(query).asIterable(fo)){
			ids.add(""+e.getProperty("articleId"));
		}
		}catch(Exception e){}
		return ids;
	}
}
