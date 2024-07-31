
import 'pigeon.dart';
import 'dart:developer';

import 'dart:typed_data' show Uint8List, Float64List;

class ShenaiSdk {
  static Future<InitializationResult> initialize(String apiKey, String userId, {InitializationSettings? settings}) async {
    var response = await _api.initialize(apiKey, userId, settings);
    return response.result;
  }

  static Future<bool> isInitialized() async {
    return _api.isInitialized();
  }

  static Future deinitialize() async {
    return _api.deinitialize();
  }

  static Future setOperatingMode(OperatingMode mode) async {
    return _api.setOperatingMode(mode);
  }
  static Future<OperatingMode> getOperatingMode() async {
    var res = await _api.getOperatingMode();
    return res.mode;
  }

  static Future setPrecisionMode(PrecisionMode mode) async {
    return _api.setPrecisionMode(mode);
  }
  static Future<PrecisionMode> getPrecisionMode() async {
    var res = await _api.getPrecisionMode();
    return res.mode;
  }

  static Future setMeasurementPreset(MeasurementPreset preset) async {
    return _api.setMeasurementPreset(preset);
  }
  static Future<MeasurementPreset> getMeasurementPreset() async {
    var res = await _api.getMeasurementPreset();
    return res.preset;
  }
  static Future setCustomMeasurementConfig(CustomMeasurementConfig config) async {
    return _api.setCustomMeasurementConfig(config);
  }
  
  static Future setCustomColorTheme(CustomColorTheme theme) async {
    return _api.setCustomColorTheme(theme);
  }

  static Future<CameraMode> getCameraMode() async {
    var res = await _api.getCameraMode();
    return res.mode;
  }
  static Future setCameraMode(CameraMode mode) async {
    return _api.setCameraMode(mode);
  }

  static Future setShowUserInterface(bool show) async {
    return _api.setShowUserInterface(show);
  }
  static Future<bool> getShowUserInterface() async {
    return _api.getShowUserInterface();
  }

  static Future setShowFacePositioningOverlay(bool show) async {
    return _api.setShowFacePositioningOverlay(show);
  }
  static Future<bool> getShowFacePositioningOverlay() async {
    return _api.getShowFacePositioningOverlay();
  }

  static Future setShowVisualWarnings(bool show) async {
    return _api.setShowVisualWarnings(show);
  }
  static Future<bool> getShowVisualWarnings() async {
    return _api.getShowVisualWarnings();
  }

  static Future setEnableCameraSwap(bool enable) async {
    return _api.setEnableCameraSwap(enable);
  }
  static Future<bool> getEnableCameraSwap() async {
    return _api.getEnableCameraSwap();
  }

  static Future setShowFaceMask(bool show) async {
    return _api.setShowFaceMask(show);
  }
  static Future<bool> getShowFaceMask() async {
    return _api.getShowFaceMask();
  }

  static Future setShowBloodFlow(bool show) async {
    return _api.setShowBloodFlow(show);
  }
  static Future<bool> getShowBloodFlow() async {
    return _api.getShowBloodFlow();
  }

  static Future setEnableStartAfterSuccess(bool enable) async {
    return _api.setEnableStartAfterSuccess(enable);
  }
  static Future<bool> getEnableStartAfterSuccess() async {
    return _api.getEnableStartAfterSuccess();
  }

  static Future<MeasurementState> getMeasurementState() async {
    var res = await _api.getMeasurementState();
    return res.state;
  }

  static Future<FaceState> getFaceState() async {
    var res = await _api.getFaceState();
    return res.state;
  }

  static Future<NormalizedFaceBbox?> getNormalizedFaceBbox() async {
    return _api.getNormalizedFaceBbox();
  }

  static Future<double> getMeasurementProgressPercentage() async {
    return _api.getMeasurementProgressPercentage();
  }

  static Future<int?> getHeartRate10s() async {
    return _api.getHeartRate10s();
  }
  static Future<int?> getHeartRate4s() async {
    return _api.getHeartRate4s();
  }

  static Future<MeasurementResults?> getRealtimeMetrics(double period_sec) async {
    return _api.getRealtimeMetrics(period_sec);
  }
  static Future<MeasurementResults?> getMeasurementResults() async {
    return _api.getMeasurementResults();
  }

  static Future setRecordingEnabled(bool enabled) async {
    return _api.setRecordingEnabled(enabled);
  }
  static Future<bool> getRecordingEnabled() async {
    return _api.getRecordingEnabled();
  }

  static Future<double> getTotalBadSignalSeconds() async {
    return _api.getTotalBadSignalSeconds();
  }

  static Future<double> getCurrentSignalQualityMetric() async {
    return _api.getCurrentSignalQualityMetric();
  }

  static Future<Uint8List?> getFaceTexturePng() async {
    return _api.getFaceTexturePng();
  }

  static Future<Uint8List?> getSignalQualityMapPng() async {
    return _api.getSignalQualityMapPng();
  }

  static Future<Float64List?> getFullPpgSignal() async {
    return _api.getFullPpgSignal();
  }

  static Future<String> getTraceID() async {
    return _api.getTraceID();
  }

  static Future setLanguage(String language) async {
    return _api.setLanguage(language);
  }

  static Future<HealthRisks> computeHealthRisks(RisksFactors healthRisksFactors) async {
    return _api.computeHealthRisks(healthRisksFactors);
  }

  static Future<HealthRisks> getMinimalHealthRisks(RisksFactors healthRisksFactors) async {
    return _api.getMinimalHealthRisks(healthRisksFactors);
  }

  static Future<HealthRisks> getMaximalHealthRisks(RisksFactors healthRisksFactors) async {
    return _api.getMaximalHealthRisks(healthRisksFactors);
  }

  static late ShenaiSdkNativeApi _api = ShenaiSdkNativeApi();
  static ShenaiSdkNativeApi get api => _api;
}
