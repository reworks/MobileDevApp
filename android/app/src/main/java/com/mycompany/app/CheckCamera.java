package com.mycompany.app;

import android.hardware.Camera;

class CheckCamera implements com.naef.jnlua.NamedJavaFunction {
    @Override
    public String getName() {
        return "checkCamera";
    }

    // returns 1 if in use.
    // thanks to:
    // https://stackoverflow.com/a/15862644
    @Override
    public int invoke(com.naef.jnlua.LuaState luaState) {
        // Set up variables.
        int output = 0;
        Camera camera = null;

        // Camera.open() throws an exception if the camera is already in use. Using this fact, we can catch the exception and then set our output to 1 to say it is in use.
        try {
            camera = Camera.open();
        } catch (RuntimeException e) {
            output = 1;
        } finally {
            // Ensure we are not using the camera after we finish checking it.
            if (camera != null) camera.release();
        }

        // Return 1 here because we are telling lua that this function will return one variable.
        // in this case we are pushing the variable 'avaliable', which will have a value of 0 if not in use and a value of 1 if in use.
        luaState.pushNumber(output);
        
        return 1;
    }
}