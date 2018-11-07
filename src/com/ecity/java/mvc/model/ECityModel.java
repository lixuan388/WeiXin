package com.ecity.java.mvc.model;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.commons.beanutils.ConvertUtilsBean;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.beanutils.converters.DateConverter;

import net.sf.json.JSONObject;

public class ECityModel implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4233478304877044619L;
	
	protected String TableName="";
	protected String FieldPrefix="";

	public ECityModel()
	{
		this.TableName="";
		this.FieldPrefix="";
	}

	public HashMap<String ,Field> getFields()
	{
		
		HashMap<String ,Field> f=new HashMap<String ,Field>();
		Field[] fields = this.getClass().getDeclaredFields();
		
		for (int i=0;i<fields.length;i++)
		{
//		System.out.println(Modifier.toString(fields[i].getModifiers())+":"+(fields[i].getModifiers()));
//		System.out.println(Modifier.toString(fields[i].getModifiers()));
//		System.out.println("getName:"+fields[i].getName());
			if (fields[i].getModifiers()==2)
			{
//				System.out.println((fields[i].getModifiers()));
//				System.out.println(Modifier.toString(fields[i].getModifiers()));
				f.put(fields[i].getName(), fields[i]);
			}
		}
		return f;
	}
	

	public JSONObject toJson()
	{
		return this.toJson("");
	}

	public JSONObject toJson(String Prefix)
	{
		JSONObject json=new JSONObject();
		try {
			HashMap<String ,Field>  fields=this.getFields();

			Iterator<String> Property=fields.keySet().iterator();
			while (Property.hasNext())
			{
				String PropertyName=Property.next();
				Object PropertyValue=PropertyUtils.getProperty(this, PropertyName);

				if (PropertyValue!=null)
				{
//					System.out.println(PropertyValue.getClass());
					if (PropertyValue instanceof Date)
					{
						java.text.DateFormat format1 = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String date = format1.format(PropertyValue);
						json.put(Prefix+PropertyName, date);
					}
					else
					{
						json.put(Prefix+PropertyName, ""+PropertyValue);
					}
				}
			}
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	

	
	public void JsonToBean(JSONObject jsonData)
	{
		try{
			ConvertUtilsBean convertUtils = BeanUtilsBean.getInstance().getConvertUtils();
			DateConverter dateConverter = new DateConverter();
			dateConverter.setPattern("yyyy-MM-dd HH:mm:ss");
			convertUtils.register(dateConverter, Date.class);
			
			Iterator<String> keys=jsonData.keys();
			while (keys.hasNext())
			{
				String FieldName=keys.next();
				String FieldValue=jsonData.getString(FieldName);
				String PropertyName=toLowerCaseFirstOne(FieldName);
				PropertyUtils.setProperty(this, PropertyName, FieldValue);
			}
		}catch (Exception e) {
				throw new RuntimeException(e);
		}
	}
	
//	public void DBToBean2(DBTable table,String prefix){
//		try{
//			ConvertUtilsBean convertUtils = BeanUtilsBean.getInstance().getConvertUtils();
//			DateConverter dateConverter = new DateConverter();
//			dateConverter.setPattern("yyyy-MM-dd HH:mm:ss");
//			convertUtils.register(dateConverter, Date.class);
//			
//			int ColumnCount=table.getColumnCount();
////				System.out.println("ColumnCount:"+ColumnCount);
//			for (int i=1;i<=ColumnCount;i++)
//			{
//				String FieldName = table.getColumnLabel(i);
//				Object FieldValue=table.GetValue(FieldName);
//				String PropertyName=toLowerCaseFirstOne(FieldName.replaceAll(prefix, ""));
////					System.out.println("PropertyName:"+PropertyName+"/FieldValue:"+FieldValue);
//
//				PropertyUtils.setProperty(this, PropertyName, FieldValue);
//			}
//		}catch (Exception e) {
//				throw new RuntimeException(e);
//		}
//	}
	
	
	
	public static String toLowerCaseFirstOne(String s){
		if(Character.isLowerCase(s.charAt(0)))
			return s;
		else
			return (new StringBuilder()).append(Character.toLowerCase(s.charAt(0))).append(s.substring(1)).toString();
	}
		
}
