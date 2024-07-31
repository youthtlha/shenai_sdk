package ai.mxlabs.shenai_sdk_flutter;

import ai.mxlabs.shenai_sdk.ShenAIView;

import android.util.Log;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

class ShenaiNativeView implements PlatformView {
   @NonNull private final ShenAIView shenaiView;

   ShenaiNativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, @Nullable Lifecycle lifecycle) {
        shenaiView = new ShenAIView(context);
        if (lifecycle != null) {
            shenaiView.setLifecycleOwner(lifecycle);
        }
    }

    @NonNull
    @Override
    public View getView() {
        return shenaiView;
    }

    @Override
    public void dispose() {     
        Log.d("ShenaiNativeView", "dispose");   
        shenaiView.activityPaused();      
    }
}
