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
        // Creates audio object with default settings.
        AudioRecord recorder = new AudioRecord(MediaRecorder.AudioSource.MIC, 44100, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_DEFAULT, 44100);
        
        // Since startRecording throws an exception if in use, we use a try-catch to catch that exception, that way we know the mic is in use.
        try
        {
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
        	// Makes sure the mic is released after checking if its in use.
            recorder.release();
            recorder = null;
        }

        // Return 1 here because we are telling lua that this function will return one variable.
        // in this case we are pushing the variable 'avaliable', which will have a value of 0 if not in use and a value of 1 if in use.
        luaState.pushNumber(available);
        return 1;
    }
}