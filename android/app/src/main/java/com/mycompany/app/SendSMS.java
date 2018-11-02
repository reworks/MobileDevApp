package com.mycompany.app;

import android.telephony.SmsManager;

class SendSMS implements com.naef.jnlua.NamedJavaFunction {
	@Override
	public String getName() {
		return "sendSMS";
	}

	@Override
	public int invoke(com.naef.jnlua.LuaState luaState) {
		// get phone number from lua function arguments
		String phoneNumber = luaState.checkString(1);
		String msg = luaState.checkString(2);

		// Sends a text message from the provided information from the lua script.
		SmsManager sms = SmsManager.getDefault();
		sms.sendTextMessage(phoneNumber, null, msg, null, null);

		return 0;
	}
}
