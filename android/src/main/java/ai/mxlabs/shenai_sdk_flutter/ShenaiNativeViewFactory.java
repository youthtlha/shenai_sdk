package ai.mxlabs.shenai_sdk_flutter;

import android.content.Context;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

class ShenaiNativeViewFactory extends PlatformViewFactory {
  private Lifecycle lifecycle;

  ShenaiNativeViewFactory() {
    super(StandardMessageCodec.INSTANCE);
  }

  public void setLifecycle(Lifecycle lifecycle) {
    this.lifecycle = lifecycle;
  }

  @NonNull
  @Override
  public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
    final Map<String, Object> creationParams = (Map<String, Object>) args;
    return new ShenaiNativeView(context, id, creationParams, lifecycle);
  }
}
