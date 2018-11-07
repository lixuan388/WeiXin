package com.java.web.weixin.system;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

public class Config {

	public Properties properties=null;
	public String ConfigFile=null;
	public Config(String ConfigFile) throws IOException
	{
		this.ConfigFile=ConfigFile;

	}
	
	public void load() throws IOException
	{	
		properties=new Properties();		
		File file =new File(this.ConfigFile);
		if (file.exists())
		{
			InputStream inputStream =new FileInputStream(file);
			properties.load(inputStream);
			inputStream.close();
			
		}
	}

	public void setProperty(String key,String value)
	{
		this.properties.setProperty(key, value);
	}

	public String getProperty(String key)
	{
		return this.properties.getProperty(key);
	}
	
	public String getProperty(String key,String DefaultValue)
	{
		return this.properties.getProperty(key,DefaultValue);
	}
	public void save() throws FileNotFoundException
	{
		OutputStream out=new FileOutputStream(new File(this.ConfigFile));
		properties.save(out, "save");
		try {
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
  
}
