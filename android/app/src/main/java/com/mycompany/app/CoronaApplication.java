package com.mycompany.app;

public class CoronaApplication extends android.app.Application {
	@Override
	public void onCreate() {
		super.onCreate();
		// Set up a Corona runtime listener used to add custom APIs to Lua.
		com.ansca.corona.CoronaEnvironment.addRuntimeListener(new CoronaApplication.CoronaRuntimeEventHandler());
	}
	
	private class CoronaRuntimeEventHandler implements com.ansca.corona.CoronaRuntimeListener {
		@Override
		public void onLoaded(com.ansca.corona.CoronaRuntime runtime) {
			com.naef.jnlua.NamedJavaFunction[] luaFunctions;
			
			// Fetch the Lua state from the runtime.
			com.naef.jnlua.LuaState luaState = runtime.getLuaState();
			
			// Add a module named "myTests" to Lua having the following functions.
			luaFunctions = new com.naef.jnlua.NamedJavaFunction[] {
				new SendSMS(),
				new CheckMic(),
                new CheckCamera()
			};
			luaState.register("androidUtils", luaFunctions);
			luaState.pop(1);
		}
		
		@Override
		public void onStarted(com.ansca.corona.CoronaRuntime runtime) {
		}
		
		@Override
		public void onSuspended(com.ansca.corona.CoronaRuntime runtime) {
		}
		

		@Override
		public void onResumed(com.ansca.corona.CoronaRuntime runtime) {
		}
		

		@Override
		public void onExiting(com.ansca.corona.CoronaRuntime runtime) {
		}
	}
}
