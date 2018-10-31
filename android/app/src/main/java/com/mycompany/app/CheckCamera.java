package com.mycompany.app;

import android.hardware.Camera;

class CheckCamera implements com.naef.jnlua.NamedJavaFunction {
    @Override
    public String getName() {
        return "CheckCamera";
    }

    // returns 1 if in use.
    // thanks to:
    // https://stackoverflow.com/a/15862644
    @Override
    public int invoke(com.naef.jnlua.LuaState luaState) {
        Camera camera = null;
        try {
            camera = Camera.open();
        } catch (RuntimeException e) {
            return 1;
        } finally {
            if (camera != null) camera.release();
        }

        return 0;
    }
}
