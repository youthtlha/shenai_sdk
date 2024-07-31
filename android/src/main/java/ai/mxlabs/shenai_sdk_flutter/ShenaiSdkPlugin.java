package ai.mxlabs.shenai_sdk_flutter;

import android.app.Activity;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import android.util.Log;
import java.util.ArrayList;
import java.util.Optional;

import ai.mxlabs.shenai_sdk.ShenAIAndroidSDK;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;

/** ShenaiSdkPlugin */
public class ShenaiSdkPlugin implements FlutterPlugin, Pigeon.ShenaiSdkNativeApi, ActivityAware {

  private static final String TAG = "ShenaiSdkPlugin";  
  private Activity activity;
  private ShenAIAndroidSDK shenai_sdk = new ShenAIAndroidSDK();
  
  private ShenaiNativeViewFactory viewFactory;

  public ShenaiSdkPlugin() {
    Log.d("mxlib", "ShenaiSdkPlugin: constructor");
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {      
    Log.d("mxlib", "Attaching to activity...");
    this.activity = activityPluginBinding.getActivity();
    viewFactory.setLifecycle(FlutterLifecycleAdapter.getActivityLifecycle(activityPluginBinding));
  }

  @Override
  public void onDetachedFromActivity() {
      this.activity = null;
      viewFactory.setLifecycle(null);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
      this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
      this.activity = activityPluginBinding.getActivity();
      viewFactory.setLifecycle(FlutterLifecycleAdapter.getActivityLifecycle(activityPluginBinding));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    viewFactory = new ShenaiNativeViewFactory();
    flutterPluginBinding
      .getPlatformViewRegistry()
      .registerViewFactory("ShenaiSdkView", viewFactory);

    Log.d("mxlib", "Attached to engine");

    Pigeon.ShenaiSdkNativeApi.setup(flutterPluginBinding.getBinaryMessenger(), this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {    
    Pigeon.ShenaiSdkNativeApi.setup(binding.getBinaryMessenger(), null);
  }

  @Override
  public Pigeon.InitializeResponse initialize(@NonNull String apiKey, @NonNull String userId, @Nullable Pigeon.InitializationSettings settings) {
    ShenAIAndroidSDK.InitializationSettings shenai_settings = shenai_sdk.getDefaultInitializationSettings();
    
    if(settings != null) {
      if (settings.getShowUserInterface() != null) {
          shenai_settings.showUserInterface = settings.getShowUserInterface();
      }      
      if (settings.getProVersionLock() != null) {
          shenai_settings.proVersionLock = settings.getProVersionLock();
      }
      if (settings.getHideShenaiLogo() != null) {
          shenai_settings.hideShenaiLogo = settings.getHideShenaiLogo();
      }
      if (settings.getPrecisionMode() != null) {
          shenai_settings.precisionMode = ShenAIAndroidSDK.PrecisionMode.values()[settings.getPrecisionMode().index];
      }
      if (settings.getOperatingMode() != null) {
          shenai_settings.operatingMode = ShenAIAndroidSDK.OperatingMode.values()[settings.getOperatingMode().index];
      }
      if (settings.getMeasurementPreset() != null) {
          shenai_settings.measurementPreset = ShenAIAndroidSDK.MeasurementPreset.values()[settings.getMeasurementPreset().index];
      }
      if (settings.getCameraMode() != null) {
          shenai_settings.cameraMode = ShenAIAndroidSDK.CameraMode.values()[settings.getCameraMode().index];
      }
      if (settings.getOnboardingMode() != null) {
          shenai_settings.onboardingMode = ShenAIAndroidSDK.OnboardingMode.values()[settings.getOnboardingMode().index];
      }
      if (settings.getShowFacePositioningOverlay() != null) {
          shenai_settings.showFacePositioningOverlay = settings.getShowFacePositioningOverlay();
      }
      if (settings.getShowVisualWarnings() != null) {
          shenai_settings.showVisualWarnings = settings.getShowVisualWarnings();
      }
      if (settings.getEnableCameraSwap() != null) {
          shenai_settings.enableCameraSwap = settings.getEnableCameraSwap();
      }
      if (settings.getShowFaceMask() != null) {
          shenai_settings.showFaceMask = settings.getShowFaceMask();
      }
      if (settings.getShowBloodFlow() != null) {
          shenai_settings.showBloodFlow = settings.getShowBloodFlow();
      }
    }

    ShenAIAndroidSDK.InitializationResult res = shenai_sdk.initialize(this.activity, apiKey, userId, shenai_settings);
    Pigeon.InitializeResponse.Builder builder = new Pigeon.InitializeResponse.Builder();
    switch(res) {
      case OK:
        builder.setResult(Pigeon.InitializationResult.SUCCESS);
        break;
      case INVALID_API_KEY:
        builder.setResult(Pigeon.InitializationResult.FAIL_INVALID_API_KEY);
        break;
      case CONNECTION_ERROR:
        builder.setResult(Pigeon.InitializationResult.FAIL_CONNECTION_ERROR);
        break;
      case INVALID:
        builder.setResult(Pigeon.InitializationResult.FAIL_INTERNAL_ERROR);
        break;
    }
    return builder.build();
  }


  @Override
  public Boolean isInitialized() {
    return shenai_sdk.isInitialized();
  }

  @Override
  public void deinitialize(Pigeon.Result<Void> result) {
    new Thread(() -> {
      shenai_sdk.deinitialize();
      result.success(null);
    }).start();    
  }

  @Override
  public void setOperatingMode(@NonNull Pigeon.OperatingMode mode) {
    switch(mode) {
      case POSITIONING:
        shenai_sdk.setOperatingMode(ShenAIAndroidSDK.OperatingMode.POSITIONING);
        break;
      case MEASURE:
        shenai_sdk.setOperatingMode(ShenAIAndroidSDK.OperatingMode.MEASURE);
        break;
      case SYSTEM_OVERLOADED:
        shenai_sdk.setOperatingMode(ShenAIAndroidSDK.OperatingMode.SYSTEM_OVERLOADED);
        break;
    }
  }

  @Override
  public Pigeon.OperatingModeResponse getOperatingMode() {
    ShenAIAndroidSDK.OperatingMode mode = shenai_sdk.getOperatingMode();
    Pigeon.OperatingModeResponse.Builder builder = new Pigeon.OperatingModeResponse.Builder();
    switch(mode) {
      case POSITIONING:
        builder.setMode(Pigeon.OperatingMode.POSITIONING);
        break;
      case MEASURE:
        builder.setMode(Pigeon.OperatingMode.MEASURE);
        break;
      case SYSTEM_OVERLOADED:
        builder.setMode(Pigeon.OperatingMode.SYSTEM_OVERLOADED);
        break;
    }
    return builder.build();
  }

  @Override
  public void setPrecisionMode(@NonNull Pigeon.PrecisionMode mode) {
    switch(mode) {
      case STRICT:
        shenai_sdk.setPrecisionMode(ShenAIAndroidSDK.PrecisionMode.STRICT);
        break;
      case RELAXED:
        shenai_sdk.setPrecisionMode(ShenAIAndroidSDK.PrecisionMode.RELAXED);
        break;
    }
  }

  @Override
  public Pigeon.PrecisionModeResponse getPrecisionMode() {
    ShenAIAndroidSDK.PrecisionMode mode = shenai_sdk.getPrecisionMode();
    Pigeon.PrecisionModeResponse.Builder builder = new Pigeon.PrecisionModeResponse.Builder();
    switch(mode) {
      case STRICT:
        builder.setMode(Pigeon.PrecisionMode.STRICT);
        break;
      case RELAXED:
        builder.setMode(Pigeon.PrecisionMode.RELAXED);
        break;
    }
    return builder.build();
  }

  @Override
  public void setMeasurementPreset(@NonNull Pigeon.MeasurementPreset preset) {
    switch(preset) {
      case ONE_MINUTE_HR_HRV_BR:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.ONE_MINUTE_HR_HRV_BR);
        break;
      case ONE_MINUTE_BETA_METRICS:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.ONE_MINUTE_BETA_METRICS);
        break;
      case INFINITE_HR:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.INFINITE_HR);
        break;
      case INFINITE_METRICS:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.INFINITE_METRICS);
        break;
      case FOURTY_FIVE_SECONDS_UNVALIDATED:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.FOURTY_FIVE_SECONDS_UNVALIDATED);
        break;
      case THIRTY_SECONDS_UNVALIDATED:
        shenai_sdk.setMeasurementPreset(ShenAIAndroidSDK.MeasurementPreset.THIRTY_SECONDS_UNVALIDATED);
        break;
    }
  }

  @Override
  public Pigeon.MeasurementPresetResponse getMeasurementPreset() {
    ShenAIAndroidSDK.MeasurementPreset preset = shenai_sdk.getMeasurementPreset();
    Pigeon.MeasurementPresetResponse.Builder builder = new Pigeon.MeasurementPresetResponse.Builder();
    switch(preset) {
      case ONE_MINUTE_HR_HRV_BR:
        builder.setPreset(Pigeon.MeasurementPreset.ONE_MINUTE_HR_HRV_BR);
        break;
      case ONE_MINUTE_BETA_METRICS:
        builder.setPreset(Pigeon.MeasurementPreset.ONE_MINUTE_BETA_METRICS);
        break;
      case INFINITE_HR:
        builder.setPreset(Pigeon.MeasurementPreset.INFINITE_HR);
        break;
      case INFINITE_METRICS:
        builder.setPreset(Pigeon.MeasurementPreset.INFINITE_METRICS);
        break;
      case FOURTY_FIVE_SECONDS_UNVALIDATED:
        builder.setPreset(Pigeon.MeasurementPreset.FOURTY_FIVE_SECONDS_UNVALIDATED);
        break;
      case THIRTY_SECONDS_UNVALIDATED:
        builder.setPreset(Pigeon.MeasurementPreset.THIRTY_SECONDS_UNVALIDATED);
        break;
    }
    return builder.build();
  }

  @Override
  public void setCameraMode(@NonNull Pigeon.CameraMode mode) {
    switch(mode) {
      case OFF:
        shenai_sdk.setCameraMode(ShenAIAndroidSDK.CameraMode.OFF);
        break;
      case FACING_USER:
        shenai_sdk.setCameraMode(ShenAIAndroidSDK.CameraMode.FACING_USER);
        break;
      case FACING_ENVIRONMENT:
        shenai_sdk.setCameraMode(ShenAIAndroidSDK.CameraMode.FACING_ENVIRONMENT);
        break;
    }
  }

  @Override
  public Pigeon.CameraModeResponse getCameraMode() {
    ShenAIAndroidSDK.CameraMode mode = shenai_sdk.getCameraMode();
    Pigeon.CameraModeResponse.Builder builder = new Pigeon.CameraModeResponse.Builder();
    switch(mode) {
      case OFF:
        builder.setMode(Pigeon.CameraMode.OFF);
        break;
      case FACING_USER:
        builder.setMode(Pigeon.CameraMode.FACING_USER);
        break;
      case FACING_ENVIRONMENT:
        builder.setMode(Pigeon.CameraMode.FACING_ENVIRONMENT);
        break;
    }
    return builder.build();
  }

  @Override
  public void setShowUserInterface(@NonNull Boolean show) {
    shenai_sdk.setShowUserInterface(show);
  }

  @Override
  public Boolean getShowUserInterface() {
    return shenai_sdk.getShowUserInterface();
  }

  @Override
  public void setShowFacePositioningOverlay(@NonNull Boolean show) {
    shenai_sdk.setShowFacePositioningOverlay(show);
  }

  @Override
  public Boolean getShowFacePositioningOverlay() {
    return shenai_sdk.getShowFacePositioningOverlay();
  }

  @Override
  public void setShowVisualWarnings(@NonNull Boolean show) {
    shenai_sdk.setShowVisualWarnings(show);
  }

  @Override
  public Boolean getShowVisualWarnings() {
    return shenai_sdk.getShowVisualWarnings();
  }

  @Override
  public void setEnableCameraSwap(@NonNull Boolean enable) {
    shenai_sdk.setEnableCameraSwap(enable);
  }

  @Override
  public Boolean getEnableCameraSwap() {
    return shenai_sdk.getEnableCameraSwap();
  }

  @Override
  public void setShowFaceMask(@NonNull Boolean show) {
    shenai_sdk.setShowFaceMask(show);
  }

  @Override
  public Boolean getShowFaceMask() {
    return shenai_sdk.getShowFaceMask();
  }

  @Override
  public void setShowBloodFlow(@NonNull Boolean show) {
    shenai_sdk.setShowBloodFlow(show);
  }

  @Override
  public Boolean getShowBloodFlow() {
    return shenai_sdk.getShowBloodFlow();
  }

  @Override
  public void setEnableStartAfterSuccess(@NonNull Boolean enable) {
    shenai_sdk.setEnableStartAfterSuccess(enable);
  }

  @Override
  public Boolean getEnableStartAfterSuccess() {
    return shenai_sdk.getEnableStartAfterSuccess();
  }

  @Override
  public Pigeon.FaceStateResponse getFaceState() {
    ShenAIAndroidSDK.FaceState state = shenai_sdk.getFaceState();
    Pigeon.FaceStateResponse.Builder builder = new Pigeon.FaceStateResponse.Builder();
    switch(state) {
      case OK:
        builder.setState(Pigeon.FaceState.OK);
        break;
      case TOO_FAR:
        builder.setState(Pigeon.FaceState.TOO_FAR);
        break;
      case TOO_CLOSE:
        builder.setState(Pigeon.FaceState.TOO_CLOSE);
        break;
      case NOT_CENTERED:
        builder.setState(Pigeon.FaceState.NOT_CENTERED);
        break;
      case NOT_VISIBLE:
        builder.setState(Pigeon.FaceState.NOT_VISIBLE);
        break;
      case UNKNOWN:
        builder.setState(Pigeon.FaceState.UNKNOWN);
        break;
    }
    return builder.build();           
  }

  @Override
  public Pigeon.NormalizedFaceBbox getNormalizedFaceBbox() {
    ShenAIAndroidSDK.NormalizedFaceBbox bbox = shenai_sdk.getNormalizedFaceBbox();
    if (bbox != null) {
      Pigeon.NormalizedFaceBbox.Builder builder = new Pigeon.NormalizedFaceBbox.Builder();
      builder.setX(new Double(bbox.x));
      builder.setY(new Double(bbox.y));
      builder.setWidth(new Double(bbox.width));
      builder.setHeight(new Double(bbox.height));
      return builder.build();
    } else {
      return null;
    }
  } 

  @Override
  public Pigeon.MeasurementStateResponse getMeasurementState() {
    ShenAIAndroidSDK.MeasurementState state = shenai_sdk.getMeasurementState();
    Pigeon.MeasurementStateResponse.Builder builder = new Pigeon.MeasurementStateResponse.Builder();
    switch(state) {
      case NOT_STARTED:
        builder.setState(Pigeon.MeasurementState.NOT_STARTED);
        break;
      case WAITING_FOR_FACE:
        builder.setState(Pigeon.MeasurementState.WAITING_FOR_FACE);
        break;      
      case RUNNING_SIGNAL_SHORT:
        builder.setState(Pigeon.MeasurementState.RUNNING_SIGNAL_SHORT);
        break;
      case RUNNING_SIGNAL_GOOD:
        builder.setState(Pigeon.MeasurementState.RUNNING_SIGNAL_GOOD);
        break;
      case RUNNING_SIGNAL_BAD:
        builder.setState(Pigeon.MeasurementState.RUNNING_SIGNAL_BAD);
        break;
      case RUNNING_SIGNAL_BAD_DEVICE_UNSTABLE:
        builder.setState(Pigeon.MeasurementState.RUNNING_SIGNAL_BAD_DEVICE_UNSTABLE);
        break;
      case FINISHED:
        builder.setState(Pigeon.MeasurementState.FINISHED);
        break;
      case FAILED:
        builder.setState(Pigeon.MeasurementState.FAILED);
        break;
    }
    return builder.build();
  }

  @Override
  public Double getMeasurementProgressPercentage() {
    return new Double(shenai_sdk.getMeasurementProgressPercentage());
  }

  @Override 
  public Long getHeartRate10s() {
    return new Long(shenai_sdk.getHeartRate10s());
  }

  @Override 
  public Long getHeartRate4s() {
    return new Long(shenai_sdk.getHeartRate4s());
  }

  private Pigeon.MeasurementResults constructMeasurementResults(@NonNull ShenAIAndroidSDK.MeasurementResults results) {
    if (results == null) {
      return null;
    }

    Pigeon.MeasurementResults.Builder builder = new Pigeon.MeasurementResults.Builder();

    builder.setHeart_rate_bpm(new Double(results.hrBpm));
    if (results.hrvSdnnMs.isPresent()) {
      builder.setHrv_sdnn_ms(new Double(results.hrvSdnnMs.get()));
    }
    if (results.hrvLnrmssdMs.isPresent()) {
      builder.setHrv_lnrmssd_ms(new Double(results.hrvLnrmssdMs.get()));
    }
    if (results.stressIndex.isPresent()) {
      builder.setStress_index(new Double(results.stressIndex.get()));
    }
    if (results.brBpm.isPresent()) {
      builder.setBreathing_rate_bpm(new Double(results.brBpm.get()));
    }
    if (results.systolicBloodPressureMmhg.isPresent()) {
      builder.setSystolic_blood_pressure_mmhg(new Double(results.systolicBloodPressureMmhg.get()));
    }
    if (results.diastolicBloodPressureMmhg.isPresent()) {
      builder.setDiastolic_blood_pressure_mmhg(new Double(results.diastolicBloodPressureMmhg.get()));
    }
    builder.setAverage_signal_quality(new Double(results.averageSignalQuality));
 
    ArrayList<Pigeon.Heartbeat> beats = new ArrayList<Pigeon.Heartbeat>();
    for (ShenAIAndroidSDK.Heartbeat sourceItem : results.heartbeats) {
      Pigeon.Heartbeat destinationItem = new Pigeon.Heartbeat.Builder()
        .setStart_location_sec((double) sourceItem.startLocationSec)
        .setEnd_location_sec((double) sourceItem.endLocationSec)
        .setDuration_ms((double) sourceItem.durationMs)
        .build();
      beats.add(destinationItem);
    }

    builder.setHeartbeats(beats);

    return builder.build();
  }

  @Override 
  public Pigeon.MeasurementResults getRealtimeMetrics(@NonNull Double periodSec) {
    return constructMeasurementResults(shenai_sdk.getRealtimeMetrics(periodSec.floatValue()));
  }

  @Override 
  public Pigeon.MeasurementResults getMeasurementResults() {
    return constructMeasurementResults(shenai_sdk.getMeasurementResults());
  }

  @Override
  public void setRecordingEnabled(@NonNull Boolean enabled) {
    shenai_sdk.setRecordingEnabled(enabled);
  }

  @Override
  public Boolean getRecordingEnabled() {
    return shenai_sdk.getRecordingEnabled();
  }

  @Override 
  public Double getTotalBadSignalSeconds() {
    return new Double(shenai_sdk.getTotalBadSignalSeconds());
  }

  @Override
  public Double getCurrentSignalQualityMetric() {
    return new Double(shenai_sdk.getCurrentSignalQualityMetric());
  }

  @Override 
  public byte[] getSignalQualityMapPng() {
    return shenai_sdk.getSignalQualityMapPng();
  }

  @Override
  public byte[] getFaceTexturePng() {
    return shenai_sdk.getFaceTexturePng();
  }

  @Override
  public double[] getFullPpgSignal() {
    return shenai_sdk.getFullPpgSignal();
  }

  @Override 
  public String getTraceID() {
    return shenai_sdk.getTraceID();
  }

  @Override
  public void setCustomMeasurementConfig(@NonNull Pigeon.CustomMeasurementConfig config) {
    ShenAIAndroidSDK.CustomMeasurementConfig sdkConfig = shenai_sdk.new CustomMeasurementConfig();
    
    if (config.getDurationSeconds() != null) {
      sdkConfig.durationSeconds = Optional.of(config.getDurationSeconds().floatValue());
    }
    if (config.getInfiniteMeasurement() != null) {
      sdkConfig.infiniteMeasurement = Optional.of(config.getInfiniteMeasurement());
    }
    if (config.getShowHeartRate() != null) {
      sdkConfig.showHeartRate = Optional.of(config.getShowHeartRate());
    }
    if (config.getShowHrvSdnn() != null) {
      sdkConfig.showHrvSdnn = Optional.of(config.getShowHrvSdnn());
    }
    if (config.getShowBreathingRate() != null) {
      sdkConfig.showBreathingRate = Optional.of(config.getShowBreathingRate());
    }
    if (config.getShowSystolicBloodPressure() != null) {
      sdkConfig.showSystolicBloodPressure = Optional.of(config.getShowSystolicBloodPressure());
    }
    if (config.getShowDiastolicBloodPressure() != null) {
      sdkConfig.showDiastolicBloodPressure = Optional.of(config.getShowDiastolicBloodPressure());
    }
    if (config.getShowCardiacStress() != null) {
      sdkConfig.showCardiacStress = Optional.of(config.getShowCardiacStress());
    }
    if (config.getRealtimeHrPeriodSeconds() != null) {
      sdkConfig.realtimeHrPeriodSeconds = Optional.of(config.getRealtimeHrPeriodSeconds().floatValue());
    }
    if (config.getRealtimeHrvPeriodSeconds() != null) {
      sdkConfig.realtimeHrvPeriodSeconds = Optional.of(config.getRealtimeHrvPeriodSeconds().floatValue());
    }
    if (config.getRealtimeCardiacStressPeriodSeconds() != null) {
      sdkConfig.realtimeCardiacStressPeriodSeconds = Optional.of(config.getRealtimeCardiacStressPeriodSeconds().floatValue());
    }

    shenai_sdk.setCustomMeasurementConfig(sdkConfig);
  }


  @Override
  public void setCustomColorTheme(@NonNull Pigeon.CustomColorTheme theme) {
    ShenAIAndroidSDK.CustomColorTheme sdkTheme = shenai_sdk.new CustomColorTheme();
    
    if (theme.getThemeColor() != null) {
      sdkTheme.themeColor = theme.getThemeColor();
    }
    if (theme.getTextColor() != null) {
      sdkTheme.textColor = theme.getTextColor();
    }
    if (theme.getBackgroundColor() != null) {
      sdkTheme.backgroundColor = theme.getBackgroundColor();
    }
    if (theme.getTileColor() != null) {
      sdkTheme.tileColor = theme.getTileColor();
    }
    
    shenai_sdk.setCustomColorTheme(sdkTheme);
  }

  @Override
  public void setLanguage(@NonNull String language) {
    shenai_sdk.setLanguage(language);
  }



  private ShenAIAndroidSDK.RisksFactors constructRisksFactors(@NonNull Pigeon.RisksFactors healthRisksFactors) {
    ShenAIAndroidSDK.RisksFactors risksFactors = shenai_sdk.new RisksFactors();
    risksFactors.age = Optional.ofNullable(healthRisksFactors.getAge() == null ?
                                           null : healthRisksFactors.getAge().intValue());

    risksFactors.cholesterol = Optional.ofNullable(healthRisksFactors.getCholesterol() == null ?
                                           null : healthRisksFactors.getCholesterol().floatValue());

    risksFactors.cholesterolHdl = Optional.ofNullable(healthRisksFactors.getCholesterolHdl() == null ?
                                            null : healthRisksFactors.getCholesterolHdl().floatValue());

    risksFactors.sbp = Optional.ofNullable(healthRisksFactors.getSbp() == null ?
                                               null : healthRisksFactors.getSbp().floatValue());

    risksFactors.isSmoker = Optional.ofNullable(healthRisksFactors.getIsSmoker());

    risksFactors.hypertensionTreatment = Optional.ofNullable(healthRisksFactors.getHypertensionTreatment());

    risksFactors.hasDiabetes = Optional.ofNullable(healthRisksFactors.getHasDiabetes());

    risksFactors.bodyHeight = Optional.ofNullable(healthRisksFactors.getBodyHeight() == null ?
                                               null : healthRisksFactors.getBodyHeight().floatValue());

    risksFactors.bodyWeight = Optional.ofNullable(healthRisksFactors.getBodyWeight() == null ?
                                               null : healthRisksFactors.getBodyWeight().floatValue());

    if (healthRisksFactors.getGender() == null) {
      risksFactors.gender = Optional.empty();
    } else {
      switch (healthRisksFactors.getGender()) {
        case MALE:
          risksFactors.gender = Optional.of(ShenAIAndroidSDK.Gender.MALE);
          break;
        case FEMALE:
          risksFactors.gender = Optional.of(ShenAIAndroidSDK.Gender.FEMALE);
          break;
        case OTHER:
          risksFactors.gender = Optional.of(ShenAIAndroidSDK.Gender.OTHER);
          break;
      }
    }

    risksFactors.country = healthRisksFactors.getCountry() == null ? "" : healthRisksFactors.getCountry();

    if (healthRisksFactors.getRace() == null) {
      risksFactors.race = Optional.empty();
    } else {
      switch (healthRisksFactors.getRace()) {
        case WHITE:
          risksFactors.race = Optional.of(ShenAIAndroidSDK.Race.WHITE);
          break;
        case AFRICAN_AMERICAN:
          risksFactors.race = Optional.of(ShenAIAndroidSDK.Race.AFRICAN_AMERICAN);
          break;
        case OTHER:
          risksFactors.race = Optional.of(ShenAIAndroidSDK.Race.OTHER);
          break;
      }
    }

    return risksFactors;
  }

  private Pigeon.HealthRisks constructHealthRisks(@NonNull ShenAIAndroidSDK.HealthRisks healthRisksResult) {
    Pigeon.HardAndFatalEventsRisks.Builder hardAndFatalBuilder = new Pigeon.HardAndFatalEventsRisks.Builder();
    hardAndFatalBuilder.setCoronaryDeathEventRisk(healthRisksResult.hardAndFatalEvents.coronaryDeathEventRisk.isPresent() ?
                                                  healthRisksResult.hardAndFatalEvents.coronaryDeathEventRisk.get().doubleValue() : null);
    hardAndFatalBuilder.setFatalStrokeEventRisk(healthRisksResult.hardAndFatalEvents.fatalStrokeEventRisk.isPresent() ?
                                                      healthRisksResult.hardAndFatalEvents.fatalStrokeEventRisk.get().doubleValue() : null);
    hardAndFatalBuilder.setTotalCVMortalityRisk(healthRisksResult.hardAndFatalEvents.totalCVMortalityRisk.isPresent() ?
                                                      healthRisksResult.hardAndFatalEvents.totalCVMortalityRisk.get().doubleValue() : null);
    hardAndFatalBuilder.setHardCVEventRisk(healthRisksResult.hardAndFatalEvents.hardCVEventRisk.isPresent() ?
                                                      healthRisksResult.hardAndFatalEvents.hardCVEventRisk.get().doubleValue() : null);

    Pigeon.CVDiseasesRisks.Builder cvDiseasesBuilder = new Pigeon.CVDiseasesRisks.Builder();
    cvDiseasesBuilder.setOverallRisk(healthRisksResult.cvDiseases.overallRisk.isPresent() ?
                                                      healthRisksResult.cvDiseases.overallRisk.get().doubleValue() : null);
    cvDiseasesBuilder.setCoronaryHeartDiseaseRisk(healthRisksResult.cvDiseases.coronaryHeartDiseaseRisk.isPresent() ?
                                                          healthRisksResult.cvDiseases.coronaryHeartDiseaseRisk.get().doubleValue() : null);
    cvDiseasesBuilder.setStrokeRisk(healthRisksResult.cvDiseases.strokeRisk.isPresent() ?
                                                          healthRisksResult.cvDiseases.strokeRisk.get().doubleValue() : null);
    cvDiseasesBuilder.setHeartFailureRisk(healthRisksResult.cvDiseases.heartFailureRisk.isPresent() ?
                                                          healthRisksResult.cvDiseases.heartFailureRisk.get().doubleValue() : null);
    cvDiseasesBuilder.setPeripheralVascularDiseaseRisk(healthRisksResult.cvDiseases.peripheralVascularDiseaseRisk.isPresent() ?
                                                          healthRisksResult.cvDiseases.peripheralVascularDiseaseRisk.get().doubleValue() : null);

    Pigeon.RisksFactorsScores.Builder scoresBuilder = new Pigeon.RisksFactorsScores.Builder();
    scoresBuilder.setAgeScore(healthRisksResult.scores.ageScore.isPresent() ?
                              healthRisksResult.scores.ageScore.get().longValue() : null);
    scoresBuilder.setSbpScore(healthRisksResult.scores.sbpScore.isPresent() ?
                              healthRisksResult.scores.sbpScore.get().longValue() : null);
    scoresBuilder.setSmokingScore(healthRisksResult.scores.smokingScore.isPresent() ?
                                  healthRisksResult.scores.smokingScore.get().longValue() : null);
    scoresBuilder.setDiabetesScore(healthRisksResult.scores.diabetesScore.isPresent() ?
                                      healthRisksResult.scores.diabetesScore.get().longValue() : null);
    scoresBuilder.setBmiScore(healthRisksResult.scores.bmiScore.isPresent() ?
                                      healthRisksResult.scores.bmiScore.get().longValue() : null);
    scoresBuilder.setCholesterolScore(healthRisksResult.scores.cholesterolScore.isPresent() ?
                                      healthRisksResult.scores.cholesterolScore.get().longValue() : null);
    scoresBuilder.setCholesterolHdlScore(healthRisksResult.scores.cholesterolHdlScore.isPresent() ?
                                      healthRisksResult.scores.cholesterolHdlScore.get().longValue() : null);
    scoresBuilder.setTotalScore(healthRisksResult.scores.totalScore.isPresent() ?
                                      healthRisksResult.scores.totalScore.get().longValue() : null);

    Pigeon.HealthRisks.Builder risksBuilder = new Pigeon.HealthRisks.Builder();
    risksBuilder.setHardAndFatalEvents(hardAndFatalBuilder.build());
    risksBuilder.setCvDiseases(cvDiseasesBuilder.build());
    risksBuilder.setVascularAge(healthRisksResult.vascularAge.isPresent() ?
                                healthRisksResult.vascularAge.get().longValue() : null);
    risksBuilder.setScores(scoresBuilder.build());

    return risksBuilder.build();
  }

  @Override
  public Pigeon.HealthRisks computeHealthRisks(@NonNull Pigeon.RisksFactors healthRisksFactors) {
    ShenAIAndroidSDK.RisksFactors risksFactors = constructRisksFactors(healthRisksFactors);
    ShenAIAndroidSDK.HealthRisks healthRisksResult = shenai_sdk.computeHealthRisks(risksFactors);
    return constructHealthRisks(healthRisksResult);
  }

  @Override
  public Pigeon.HealthRisks getMinimalHealthRisks(@NonNull Pigeon.RisksFactors healthRisksFactors) {
    ShenAIAndroidSDK.RisksFactors risksFactors = constructRisksFactors(healthRisksFactors);
    ShenAIAndroidSDK.HealthRisks healthRisksResult = shenai_sdk.getMinimalHealthRisks(risksFactors);
    return constructHealthRisks(healthRisksResult);
  }

  @Override
  public Pigeon.HealthRisks getMaximalHealthRisks(@NonNull Pigeon.RisksFactors healthRisksFactors) {
    ShenAIAndroidSDK.RisksFactors risksFactors = constructRisksFactors(healthRisksFactors);
    ShenAIAndroidSDK.HealthRisks healthRisksResult = shenai_sdk.getMaximalHealthRisks(risksFactors);
    return constructHealthRisks(healthRisksResult);
  }

}
