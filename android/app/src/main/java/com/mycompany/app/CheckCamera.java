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
        int output = 0;
        Camera camera = null;
        try {
            camera = Camera.open();
        } catch (RuntimeException e) {
            output = 1;
        } finally {
            if (camera != null) camera.release();
        }

        luaState.pushNumber(output);
        return 1;
    }
}