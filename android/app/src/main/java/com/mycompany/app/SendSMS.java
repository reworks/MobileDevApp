package com.mycompany.app;

import android.telephony.SmsManager;

class SendSMS implements com.naef.jnlua.NamedJavaFunction {
	@Override
	public String getName() {
		return "SendSMS";
	}
	
	@Override
	public int invoke(com.naef.jnlua.LuaState luaState) {
		try 
		{
			// get phone number from lua function arguments
			int phoneNumber = luaState.checkInteger(1);
			String msg = luaState.checkString(2, "empty");

			// send the text message
			SmsManager smsManager = SmsManager.getDefault();
			smsManager.sendTextMessage(Integer.toString(phoneNumber), null, msg, null, null);
		}
		catch (Exception ex)
	    {
			ex.printStackTrace();
		}
		
		return 0;
	}
}
