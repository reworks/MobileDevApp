package com.mycompany.app;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;

class CheckMic implements com.naef.jnlua.NamedJavaFunction {
    @Override
    public String getName() {
        return "checkMic";
    }

    // returns 1 if in use.
    // thanks to:
    // https://stackoverflow.com/a/35637498
    @Override
    public int invoke(com.naef.jnlua.LuaState luaState) {
        int available = 0;
        AudioRecord recorder =
                new AudioRecord(MediaRecorder.AudioSource.MIC, 44100,
                        AudioFormat.CHANNEL_IN_MONO,
                        AudioFormat.ENCODING_DEFAULT, 44100);
        try{
            if(recorder.getRecordingState() != AudioRecord.RECORDSTATE_STOPPED ){
                available = 1;

            }

            recorder.startRecording();
            if(recorder.getRecordingState() != AudioRecord.RECORDSTATE_RECORDING){
                recorder.stop();
                available = 1;

            }
            recorder.stop();
        } finally{
            recorder.release();
            recorder = null;
        }

        luaState.pushNumber(available);
        return 1;
    }
}