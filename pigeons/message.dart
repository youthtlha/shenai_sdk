import 'package:pigeon/pigeon.dart';

enum InitializationResult { success, failInvalidApiKey, failConnectionError, failInternalError }

class InitializeResponse {
   InitializationResult result;
}

enum OperatingMode {
  positioning,
  measure,
  systemOverloaded
}

class OperatingModeResponse {
  OperatingMode mode;
}

enum PrecisionMode {
  strict,
  relaxed
}

class PrecisionModeResponse {
  PrecisionMode mode;
}

enum MeasurementPreset {
  oneMinuteHrHrvBr,
  oneMinuteBetaMetrics,
  infiniteHr,
  infiniteMetrics,
  fourtyFiveSecondsUnvalidated,
  thirtySecondsUnvalidated,
}

class MeasurementPresetResponse {
  MeasurementPreset preset;
}

enum CameraMode {
  off,
  facingUser,
  facingEnvironment
}

class CameraModeResponse {
  CameraMode mode;
}

enum OnboardingMode {
  hidden,
  showOnce,
  showAlways
}

enum FaceState {
  ok,
  tooFar,
  tooClose,
  notCentered,
  notVisible,
  unknown
}

class FaceStateResponse {
  FaceState state;
}

class NormalizedFaceBbox {
  double x;
  double y;
  double width;
  double height;
}

enum MeasurementState {
  notStarted,                     // Measurement has not started yet
  waitingForFace,                 // Waiting for face to be properly positioned in the frame
  runningSignalShort,             // Measurement started: Signal is too short for any conclusions
  runningSignalGood,              // Measurement proceeding: Signal quality is good
  runningSignalBad,               // Measurement stalled due to poor signal quality
  runningSignalBadDeviceUnstable, // Measurement stalled due to poor signal quality (because of unstable device)
  finished,                       // Measurement has finished successfully
  failed,                         // Measurement has failed
}

class MeasurementStateResponse {
  MeasurementState state;
}

class Heartbeat {
  double start_location_sec;
  double end_location_sec;
  double duration_ms;
}

class MeasurementResults {
  double heart_rate_bpm;                   // Heart rate, rounded to 1 BPM   
  double? hrv_sdnn_ms;                     // Heart rate variability, SDNN metric, rounded to 1 ms
  double? hrv_lnrmssd_ms;                  // Heart rate variability, lnRMSSD metric, rounded to 0.1 ms   
  double? stress_index;                    // Cardiac Stress, rounded to 0.1
  double? breathing_rate_bpm;              // Breathing rate, rounded to 1 BPM       
  double? systolic_blood_pressure_mmhg;    // Systolic blood pressure, rounded to 1 mmHg                 
  double? diastolic_blood_pressure_mmhg;   // Diastolic blood pressure, rounded to 1 mmHg                   
  List<Heartbeat?> heartbeats;             // Heartbeat locations       
  double average_signal_quality;           // Average signal quality metric
}

class InitializationSettings {
  PrecisionMode? precisionMode;
  OperatingMode? operatingMode;
  MeasurementPreset? measurementPreset;
  CameraMode? cameraMode;
  OnboardingMode? onboardingMode;

  bool? showUserInterface;
  bool? showFacePositioningOverlay;
  bool? showVisualWarnings;
  bool? enableCameraSwap;
  bool? showFaceMask;
  bool? showBloodFlow;
  bool? proVersionLock;
  bool? hideShenaiLogo;
}

class CustomMeasurementConfig {
  double? durationSeconds;
  bool? infiniteMeasurement;

  bool? showHeartRate;
  bool? showHrvSdnn;
  bool? showBreathingRate;
  bool? showSystolicBloodPressure;
  bool? showDiastolicBloodPressure;
  bool? showCardiacStress;

  double? realtimeHrPeriodSeconds;
  double? realtimeHrvPeriodSeconds;
  double? realtimeCardiacStressPeriodSeconds;
}

class CustomColorTheme {
  String? themeColor;
  String? textColor;
  String? backgroundColor;
  String? tileColor;
}

enum Gender {
  male,
  female,
  other
}

enum Race {
  white,
  africanAmerican,
  other
}

class RisksFactors {
  int? age;
  double? cholesterol;
  double? cholesterolHdl;
  double? sbp;
  bool? isSmoker;
  bool? hypertensionTreatment;
  bool? hasDiabetes;
  double? bodyHeight; // centimeters
  double? bodyWeight; // kilograms
  Gender? gender;
  String? country; // country name ISO code: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
  Race? race;
}

class HardAndFatalEventsRisks {
  double? coronaryDeathEventRisk;
  double? fatalStrokeEventRisk;
  double? totalCVMortalityRisk;
  double? hardCVEventRisk;
}

class CVDiseasesRisks {
  double? overallRisk;
  double? coronaryHeartDiseaseRisk;
  double? strokeRisk;
  double? heartFailureRisk;
  double? peripheralVascularDiseaseRisk;
}

class RisksFactorsScores {
  int? ageScore;
  int? sbpScore;
  int? smokingScore;
  int? diabetesScore;
  int? bmiScore;
  int? cholesterolScore;
  int? cholesterolHdlScore;
  int? totalScore;
}

class HealthRisks {
  HardAndFatalEventsRisks hardAndFatalEvents;
  CVDiseasesRisks cvDiseases;
  int? vascularAge;
  RisksFactorsScores scores;
}

@HostApi()
abstract class ShenaiSdkNativeApi {
  InitializeResponse initialize(String apiKey, String userId, InitializationSettings? settings);
  bool isInitialized();
  @async
  void deinitialize();

  void setOperatingMode(OperatingMode mode);
  OperatingModeResponse getOperatingMode();

  void setPrecisionMode(PrecisionMode mode);
  PrecisionModeResponse getPrecisionMode();

  void setMeasurementPreset(MeasurementPreset preset);
  MeasurementPresetResponse getMeasurementPreset();
  void setCustomMeasurementConfig(CustomMeasurementConfig config);
  
  void setCustomColorTheme(CustomColorTheme theme);

  void setCameraMode(CameraMode mode);
  CameraModeResponse getCameraMode();

  void setShowUserInterface(bool show);
  bool getShowUserInterface();

  void setShowFacePositioningOverlay(bool show);
  bool getShowFacePositioningOverlay();

  void setShowVisualWarnings(bool show);
  bool getShowVisualWarnings();

  void setEnableCameraSwap(bool enable);
  bool getEnableCameraSwap();

  void setShowFaceMask(bool show);
  bool getShowFaceMask();

  void setShowBloodFlow(bool show);
  bool getShowBloodFlow();

  void setEnableStartAfterSuccess(bool enable);
  bool getEnableStartAfterSuccess();

  FaceStateResponse getFaceState();
  NormalizedFaceBbox? getNormalizedFaceBbox();
  MeasurementStateResponse getMeasurementState();
  double getMeasurementProgressPercentage();

  int? getHeartRate10s();
  int? getHeartRate4s();

  MeasurementResults? getRealtimeMetrics(double period_sec);
  MeasurementResults? getMeasurementResults();

  void setRecordingEnabled(bool enabled);
  bool getRecordingEnabled();  

  double getTotalBadSignalSeconds();
  double getCurrentSignalQualityMetric();

  Uint8List? getSignalQualityMapPng();
  Uint8List? getFaceTexturePng();

  Float64List? getFullPpgSignal();

  String getTraceID();

  void setLanguage(String language);

  HealthRisks computeHealthRisks(RisksFactors healthRisksFactors);
  HealthRisks getMinimalHealthRisks(RisksFactors healthRisksFactors);
  HealthRisks getMaximalHealthRisks(RisksFactors healthRisksFactors);
}
