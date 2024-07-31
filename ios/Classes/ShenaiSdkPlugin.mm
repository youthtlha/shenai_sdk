#import "ShenaiSdkPlugin.h"
#import "ShenaiSdkView.h"
extern "C" {
#import "pigeon.h"
}

#import <ShenaiSDK/health_risks.h>
#import <ShenaiSDK/shenai_api_cpp.h>
#include <thread>

@interface ShenFlutterApi : NSObject <ShenaiSdkNativeApi>
@end

@implementation ShenFlutterApi

- (nullable InitializeResponse *)initializeApiKey:(nonnull NSString *)apiKey
                                           userId:(nonnull NSString *)userId
                                         settings:(nullable InitializationSettings *)settings
                                            error:(FlutterError *_Nullable *_Nonnull)error {
  shen::initialization_settings settingsCpp;
  if (settings != nil) {
    if (settings.precisionMode != nil) {
      settingsCpp.precisionMode = static_cast<shen::PrecisionMode>(settings.precisionMode.value);
    }
    if (settings.operatingMode != nil) {
      settingsCpp.operatingMode = static_cast<shen::OperatingMode>(settings.operatingMode.value);
    }
    if (settings.measurementPreset != nil) {
      settingsCpp.measurementPreset = static_cast<shen::MeasurementPreset>(settings.measurementPreset.value);
    }
    if (settings.cameraMode != nil) {
      settingsCpp.cameraMode = static_cast<shen::CameraMode>(settings.cameraMode.value);
    }
    if (settings.onboardingMode != nil) {
      settingsCpp.onboardingMode = static_cast<shen::OnboardingMode>(settings.onboardingMode.value);
    }
    if (settings.showUserInterface != nil) {
      settingsCpp.showUserInterface = [settings.showUserInterface boolValue];
    }
    if (settings.showFacePositioningOverlay != nil) {
      settingsCpp.showFacePositioningOverlay = [settings.showFacePositioningOverlay boolValue];
    }
    if (settings.showVisualWarnings != nil) {
      settingsCpp.showVisualWarnings = [settings.showVisualWarnings boolValue];
    }
    if (settings.enableCameraSwap != nil) {
      settingsCpp.enableCameraSwap = [settings.enableCameraSwap boolValue];
    }
    if (settings.showFaceMask != nil) {
      settingsCpp.showFaceMask = [settings.showFaceMask boolValue];
    }
    if (settings.showBloodFlow != nil) {
      settingsCpp.showBloodFlow = [settings.showBloodFlow boolValue];
    }
    if (settings.proVersionLock != nil) {
      settingsCpp.proVersionLock = [settings.proVersionLock boolValue];
    }
    if (settings.hideShenaiLogo != nil) {
      settingsCpp.hideShenaiLogo = [settings.hideShenaiLogo boolValue];
    }
  }

  auto res = shen::Initialize(apiKey.UTF8String, userId.UTF8String, settingsCpp);
  switch (res) {
    case shen::InitializationResult::Success:
      return [InitializeResponse makeWithResult:InitializationResultSuccess];
    case shen::InitializationResult::FailureInvalidApiKey:
      return [InitializeResponse makeWithResult:InitializationResultFailInvalidApiKey];
    case shen::InitializationResult::FailureConnectionError:
      return [InitializeResponse makeWithResult:InitializationResultFailConnectionError];
    case shen::InitializationResult::FailureInternalError:
      return [InitializeResponse makeWithResult:InitializationResultFailInternalError];
  }
  return nil;
}

- (nullable NSNumber *)isInitializedWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::IsInitialized());
}

- (void)deinitializeWithCompletion:(void (^)(FlutterError *_Nullable))completion {
  std::thread([completion]() {
    shen::Deinitialize();
    completion(nil);
  }).detach();
}

- (void)setOperatingModeMode:(OperatingMode)mode error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetOperatingMode(static_cast<shen::OperatingMode>(mode));
}
/// @return `nil` only when `error != nil`.
- (nullable OperatingModeResponse *)getOperatingModeWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetOperatingMode();
  switch (res) {
    case shen::OperatingMode::Measure:
      return [OperatingModeResponse makeWithMode:OperatingModeMeasure];
    case shen::OperatingMode::Positioning:
      return [OperatingModeResponse makeWithMode:OperatingModePositioning];
    case shen::OperatingMode::SystemOverloaded:
      return [OperatingModeResponse makeWithMode:OperatingModeSystemOverloaded];
  }
  return nil;
}
- (void)setPrecisionModeMode:(PrecisionMode)mode error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetPrecisionMode(static_cast<shen::PrecisionMode>(mode));
}
/// @return `nil` only when `error != nil`.
- (nullable PrecisionModeResponse *)getPrecisionModeWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetPrecisionMode();
  switch (res) {
    case shen::PrecisionMode::Strict:
      return [PrecisionModeResponse makeWithMode:PrecisionModeStrict];
    case shen::PrecisionMode::Relaxed:
      return [PrecisionModeResponse makeWithMode:PrecisionModeRelaxed];
  }
  return nil;
}
- (void)setMeasurementPresetPreset:(MeasurementPreset)preset error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetMeasurementPreset(static_cast<shen::MeasurementPreset>(preset));
}
/// @return `nil` only when `error != nil`.
- (nullable MeasurementPresetResponse *)getMeasurementPresetWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetMeasurementPreset();
  switch (res) {
    case shen::MeasurementPreset::OneMinuteHrHrvBr:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetOneMinuteHrHrvBr];
    case shen::MeasurementPreset::OneMinuteBetaMetrics:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetOneMinuteBetaMetrics];
    case shen::MeasurementPreset::InfiniteHr:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetInfiniteHr];
    case shen::MeasurementPreset::InfiniteMetrics:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetInfiniteMetrics];
    case shen::MeasurementPreset::FourtyFiveSecondsUnvalidated:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetFourtyFiveSecondsUnvalidated];
    case shen::MeasurementPreset::ThirtySecondsUnvalidated:
      return [MeasurementPresetResponse makeWithPreset:MeasurementPresetThirtySecondsUnvalidated];
  }
  return nil;
}
- (void)setCameraModeMode:(CameraMode)mode error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetCameraMode(static_cast<shen::CameraMode>(mode));
}
/// @return `nil` only when `error != nil`.
- (nullable CameraModeResponse *)getCameraModeWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetCameraMode();
  switch (res) {
    case shen::CameraMode::Off:
      return [CameraModeResponse makeWithMode:CameraModeOff];
    case shen::CameraMode::FacingUser:
      return [CameraModeResponse makeWithMode:CameraModeFacingUser];
    case shen::CameraMode::FacingEnvironment:
      return [CameraModeResponse makeWithMode:CameraModeFacingEnvironment];
  }
  return nil;
}
- (void)setShowUserInterfaceShow:(NSNumber *)show error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetShowUserInterface([show boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getShowUserInterfaceWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetShowUserInterface());
}
- (void)setShowFacePositioningOverlayShow:(NSNumber *)show error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetShowFacePositioningOverlay([show boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getShowFacePositioningOverlayWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetShowFacePositioningOverlay());
}
- (void)setShowVisualWarningsShow:(NSNumber *)show error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetShowVisualWarnings([show boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getShowVisualWarningsWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetShowVisualWarnings());
}
- (void)setEnableCameraSwapEnable:(NSNumber *)enable error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetEnableCameraSwap([enable boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEnableCameraSwapWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetEnableCameraSwap());
}
- (void)setShowFaceMaskShow:(NSNumber *)show error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetShowFaceMask([show boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getShowFaceMaskWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetShowFaceMask());
}
- (void)setShowBloodFlowShow:(NSNumber *)show error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetShowBloodFlow([show boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getShowBloodFlowWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetShowBloodFlow());
}

- (void)setEnableStartAfterSuccessEnable:(NSNumber *)enable error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetEnableStartAfterSuccess([enable boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getEnableStartAfterSuccessWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetEnableStartAfterSuccess());
}

/// @return `nil` only when `error != nil`.
- (nullable FaceStateResponse *)getFaceStateWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetFaceState();
  switch (res) {
    case shen::FaceState::Ok:
      return [FaceStateResponse makeWithState:FaceStateOk];
    case shen::FaceState::TooFar:
      return [FaceStateResponse makeWithState:FaceStateTooFar];
    case shen::FaceState::TooClose:
      return [FaceStateResponse makeWithState:FaceStateTooClose];
    case shen::FaceState::NotCentered:
      return [FaceStateResponse makeWithState:FaceStateNotCentered];
    case shen::FaceState::NotVisible:
      return [FaceStateResponse makeWithState:FaceStateNotVisible];
    case shen::FaceState::Unknown:
      return [FaceStateResponse makeWithState:FaceStateUnknown];
  }

  return [FaceStateResponse makeWithState:FaceStateUnknown];
}
- (nullable NormalizedFaceBbox *)getNormalizedFaceBboxWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetNormalizedFaceBbox();
  if (!res) {
    return nil;
  }
  return [NormalizedFaceBbox makeWithX:@(res->x) y:@(res->y) width:@(res->width) height:@(res->height)];
}
/// @return `nil` only when `error != nil`.
- (nullable MeasurementStateResponse *)getMeasurementStateWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetMeasurementState();
  switch (res) {
    case shen::MeasurementState::NotStarted:
      return [MeasurementStateResponse makeWithState:MeasurementStateNotStarted];
    case shen::MeasurementState::WaitingForFace:
      return [MeasurementStateResponse makeWithState:MeasurementStateWaitingForFace];
    case shen::MeasurementState::RunningSignalShort:
      return [MeasurementStateResponse makeWithState:MeasurementStateRunningSignalShort];
    case shen::MeasurementState::RunningSignalGood:
      return [MeasurementStateResponse makeWithState:MeasurementStateRunningSignalGood];
    case shen::MeasurementState::RunningSignalBad:
      return [MeasurementStateResponse makeWithState:MeasurementStateRunningSignalBad];
    case shen::MeasurementState::RunningSignalBadDeviceUnstable:
      return [MeasurementStateResponse makeWithState:MeasurementStateRunningSignalBadDeviceUnstable];
    case shen::MeasurementState::Finished:
      return [MeasurementStateResponse makeWithState:MeasurementStateFinished];
    case shen::MeasurementState::Failed:
      return [MeasurementStateResponse makeWithState:MeasurementStateFailed];
  }
  return nil;
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getMeasurementProgressPercentageWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetMeasurementProgressPercentage());
}
- (nullable NSNumber *)getHeartRate10sWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto hr = shen::GetHeartRate10s();
  if (!hr) {
    return nil;
  }
  return @(*hr);
}
- (nullable NSNumber *)getHeartRate4sWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto hr = shen::GetHeartRate4s();
  if (!hr) {
    return nil;
  }
  return @(*hr);
}
- (nullable MeasurementResults *)getRealtimeMetricsPeriod_sec:(NSNumber *)period_sec
                                                        error:(FlutterError *_Nullable *_Nonnull)error {
  float period_float = [period_sec floatValue];
  auto res = shen::GetRealtimeMetrics(period_float);
  if (!res) {
    return nil;
  }

  NSMutableArray<Heartbeat *> *heartbeats = [NSMutableArray array];
  for (int i = 0; i < res->heartbeats.size(); i++) {
    const auto &hb = res->heartbeats[i];
    [heartbeats addObject:[Heartbeat makeWithStart_location_sec:@(hb.start_location_sec)
                                               end_location_sec:@(hb.end_location_sec)
                                                    duration_ms:@(hb.duration_ms)]];
  }

  return [MeasurementResults
             makeWithHeart_rate_bpm:@(res->heart_rate_bpm)
                        hrv_sdnn_ms:res->hrv_sdnn_ms ? @(*res->hrv_sdnn_ms) : nil
                     hrv_lnrmssd_ms:res->hrv_lnrmssd_ms ? @(*res->hrv_lnrmssd_ms) : nil
                       stress_index:res->stress_index ? @(*res->stress_index) : nil
                 breathing_rate_bpm:res->breathing_rate_bpm ? @(*res->breathing_rate_bpm) : nil
       systolic_blood_pressure_mmhg:res->systolic_blood_pressure_mmhg ? @(*res->systolic_blood_pressure_mmhg) : nil
      diastolic_blood_pressure_mmhg:res->diastolic_blood_pressure_mmhg ? @(*res->diastolic_blood_pressure_mmhg) : nil
                         heartbeats:heartbeats
             average_signal_quality:@(res->average_signal_quality)];
}
- (nullable MeasurementResults *)getMeasurementResultsWithError:(FlutterError *_Nullable *_Nonnull)error {
  auto res = shen::GetMeasurementResults();
  if (!res) {
    return nil;
  }

  NSMutableArray<Heartbeat *> *heartbeats = [NSMutableArray array];
  for (int i = 0; i < res->heartbeats.size(); i++) {
    const auto &hb = res->heartbeats[i];
    [heartbeats addObject:[Heartbeat makeWithStart_location_sec:@(hb.start_location_sec)
                                               end_location_sec:@(hb.end_location_sec)
                                                    duration_ms:@(hb.duration_ms)]];
  }

  return [MeasurementResults
             makeWithHeart_rate_bpm:@(res->heart_rate_bpm)
                        hrv_sdnn_ms:res->hrv_sdnn_ms ? @(*res->hrv_sdnn_ms) : nil
                     hrv_lnrmssd_ms:res->hrv_lnrmssd_ms ? @(*res->hrv_lnrmssd_ms) : nil
                       stress_index:res->stress_index ? @(*res->stress_index) : nil
                 breathing_rate_bpm:res->breathing_rate_bpm ? @(*res->breathing_rate_bpm) : nil
       systolic_blood_pressure_mmhg:res->systolic_blood_pressure_mmhg ? @(*res->systolic_blood_pressure_mmhg) : nil
      diastolic_blood_pressure_mmhg:res->diastolic_blood_pressure_mmhg ? @(*res->diastolic_blood_pressure_mmhg) : nil
                         heartbeats:heartbeats
             average_signal_quality:@(res->average_signal_quality)];
}
- (void)setRecordingEnabledEnabled:(NSNumber *)enabled error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetRecordingEnabled([enabled boolValue]);
}
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)getRecordingEnabledWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetRecordingEnabled());
}

- (nullable NSNumber *)getTotalBadSignalSecondsWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetTotalBadSignalSeconds());
}

- (nullable NSNumber *)getCurrentSignalQualityMetricWithError:(FlutterError *_Nullable *_Nonnull)error {
  return @(shen::GetCurrentSignalQualityMetric());
}

- (nullable FlutterStandardTypedData *)getSignalQualityMapPngWithError:(FlutterError *_Nullable *_Nonnull)error {
  std::vector<uint8_t> res = shen::GetSignalQualityMapPng();
  if (res.empty()) {
    return nil;
  }
  return [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:res.data() length:res.size()]];
}

- (nullable FlutterStandardTypedData *)getFaceTexturePngWithError:(FlutterError *_Nullable *_Nonnull)error {
  std::vector<uint8_t> res = shen::GetFaceTexturePng();
  if (res.empty()) {
    return nil;
  }
  return [FlutterStandardTypedData typedDataWithBytes:[NSData dataWithBytes:res.data() length:res.size()]];
}

- (nullable FlutterStandardTypedData *)getFullPpgSignalWithError:(FlutterError *_Nullable *_Nonnull)error {
  std::vector<float> res = shen::GetFullPPGSignal();
  if (res.empty()) {
    return nil;
  }

  // Convert std::vector<float> to std::vector<double>
  std::vector<double> resDouble(res.begin(), res.end());

  // Convert std::vector<double> to NSData
  NSData *data = [NSData dataWithBytes:resDouble.data() length:resDouble.size() * sizeof(double)];

  // Then convert NSData to FlutterStandardTypedData
  FlutterStandardTypedData *typedData = [FlutterStandardTypedData typedDataWithFloat64:data];

  return typedData;
}

- (nullable NSString *)getTraceIDWithError:(FlutterError *_Nullable *_Nonnull)error {
  return [NSString stringWithUTF8String:shen::GetTraceID().c_str()];
}

/// GPT-4 generated methods

/// Helper functions to handle optional values
- (nullable NSNumber *)optionalFloatToNSNumber:(const std::optional<float> &)value {
  return value ? @(value.value()) : nil;
}
- (nullable NSNumber *)optionalIntToNSNumber:(const std::optional<int> &)value {
  return value ? @(value.value()) : nil;
}

/// Helper function to convert NSNumber to std::optional<T>
template <typename T>
std::optional<T> NSNumberToOptional(NSNumber *_Nullable value);

template <>
std::optional<int> NSNumberToOptional<int>(NSNumber *_Nullable value) {
  return value == nil ? std::nullopt : std::optional<int>(static_cast<int>([value intValue]));
}

template <>
std::optional<float> NSNumberToOptional<float>(NSNumber *_Nullable value) {
  return value == nil ? std::nullopt : std::optional<float>(static_cast<float>([value floatValue]));
}

template <>
std::optional<bool> NSNumberToOptional<bool>(NSNumber *_Nullable value) {
  return value == nil ? std::nullopt : std::optional<bool>(static_cast<bool>([value boolValue]));
}

template <class T, class S>
std::optional<T> boxedEnumToOptional(S *boxed) {
  if (boxed == nil) {
    return std::nullopt;
  }
  return std::optional<T>(static_cast<T>(boxed.value));
}

- (mx::health_risks::RisksFactors)convertToRisksFactors:(RisksFactors *)healthRisksFactors {
  return {
      .age = NSNumberToOptional<int>(healthRisksFactors.age),
      .cholesterol = NSNumberToOptional<float>(healthRisksFactors.cholesterol),
      .cholesterol_hdl = NSNumberToOptional<float>(healthRisksFactors.cholesterolHdl),
      .sbp = NSNumberToOptional<float>(healthRisksFactors.sbp),
      .is_smoker = NSNumberToOptional<bool>(healthRisksFactors.isSmoker),
      .hypertension_treatment = NSNumberToOptional<bool>(healthRisksFactors.hypertensionTreatment),
      .has_diabetes = NSNumberToOptional<bool>(healthRisksFactors.hasDiabetes),
      .body_height = NSNumberToOptional<float>(healthRisksFactors.bodyHeight),
      .body_weight = NSNumberToOptional<float>(healthRisksFactors.bodyWeight),
      .gender = boxedEnumToOptional<mx::health_risks::Gender>(healthRisksFactors.gender),
      .country = healthRisksFactors.country == nil ? "" : healthRisksFactors.country.UTF8String,
      .race = boxedEnumToOptional<mx::health_risks::Race>(healthRisksFactors.race),
  };
}

- (HealthRisks *)createHealthRisksFromRisks:(mx::health_risks::HealthRisks)risks {
  HardAndFatalEventsRisks *hardAndFatalEvents = [HardAndFatalEventsRisks
      makeWithCoronaryDeathEventRisk:[self
                                         optionalFloatToNSNumber:risks.hard_and_fatal_events.coronary_death_event_risk]
                fatalStrokeEventRisk:[self optionalFloatToNSNumber:risks.hard_and_fatal_events.fatal_stroke_event_risk]
                totalCVMortalityRisk:[self optionalFloatToNSNumber:risks.hard_and_fatal_events.total_cv_mortality_risk]
                     hardCVEventRisk:[self optionalFloatToNSNumber:risks.hard_and_fatal_events.hard_cv_event_risk]];

  CVDiseasesRisks *cvDiseases = [CVDiseasesRisks
                makeWithOverallRisk:[self optionalFloatToNSNumber:risks.cv_diseases.overall_risk]
           coronaryHeartDiseaseRisk:[self optionalFloatToNSNumber:risks.cv_diseases.coronary_heart_disease_risk]
                         strokeRisk:[self optionalFloatToNSNumber:risks.cv_diseases.stroke_risk]
                   heartFailureRisk:[self optionalFloatToNSNumber:risks.cv_diseases.heart_failure_risk]
      peripheralVascularDiseaseRisk:[self optionalFloatToNSNumber:risks.cv_diseases.peripheral_vascular_disease_risk]];

  RisksFactorsScores *scores =
      [RisksFactorsScores makeWithAgeScore:[self optionalIntToNSNumber:risks.scores.age_score]
                                  sbpScore:[self optionalIntToNSNumber:risks.scores.sbp_score]
                              smokingScore:[self optionalIntToNSNumber:risks.scores.smoking_score]
                             diabetesScore:[self optionalIntToNSNumber:risks.scores.diabetes_score]
                                  bmiScore:[self optionalIntToNSNumber:risks.scores.bmi_score]
                          cholesterolScore:[self optionalIntToNSNumber:risks.scores.cholesterol_score]
                       cholesterolHdlScore:[self optionalIntToNSNumber:risks.scores.cholesterol_hdl_score]
                                totalScore:[self optionalIntToNSNumber:risks.scores.total_score]];

  return [HealthRisks makeWithHardAndFatalEvents:hardAndFatalEvents
                                      cvDiseases:cvDiseases
                                     vascularAge:[self optionalIntToNSNumber:risks.vascular_age]
                                          scores:scores];
}

/// @return `nil` only when `error != nil`.
- (nullable HealthRisks *)computeHealthRisksHealthRisksFactors:(RisksFactors *)healthRisksFactors
                                                         error:(FlutterError *_Nullable *_Nonnull)error {
  mx::health_risks::RisksFactors factors = [self convertToRisksFactors:healthRisksFactors];
  auto risks = mx::health_risks::computeHealthRisks(factors);

  return [self createHealthRisksFromRisks:risks];
}

/// @return `nil` only when `error != nil`.
- (nullable HealthRisks *)getMinimalHealthRisksHealthRisksFactors:(RisksFactors *)healthRisksFactors
                                                            error:(FlutterError *_Nullable *_Nonnull)error {
  mx::health_risks::RisksFactors factors = [self convertToRisksFactors:healthRisksFactors];
  auto risks = mx::health_risks::getMinimalRisks(factors);

  return [self createHealthRisksFromRisks:risks];
}
/// @return `nil` only when `error != nil`.
- (nullable HealthRisks *)getMaximalHealthRisksHealthRisksFactors:(RisksFactors *)healthRisksFactors
                                                            error:(FlutterError *_Nullable *_Nonnull)error {
  mx::health_risks::RisksFactors factors = [self convertToRisksFactors:healthRisksFactors];
  auto risks = mx::health_risks::getMaximalRisks(factors);

  return [self createHealthRisksFromRisks:risks];
}

- (void)setCustomMeasurementConfigConfig:(CustomMeasurementConfig *)config
                                   error:(FlutterError *_Nullable *_Nonnull)error {
  shen::custom_measurement_config cppConfig;

  if (config.durationSeconds != nil) {
    cppConfig.duration_seconds = [config.durationSeconds floatValue];
  }
  cppConfig.infinite_measurement = config.infiniteMeasurement ? [config.infiniteMeasurement boolValue] : false;
  cppConfig.show_heart_rate = config.showHeartRate ? [config.showHeartRate boolValue] : false;
  cppConfig.show_hrv_sdnn = config.showHrvSdnn ? [config.showHrvSdnn boolValue] : false;
  cppConfig.show_breathing_rate = config.showBreathingRate ? [config.showBreathingRate boolValue] : false;
  cppConfig.show_systolic_blood_pressure =
      config.showSystolicBloodPressure ? [config.showSystolicBloodPressure boolValue] : false;
  cppConfig.show_diastolic_blood_pressure =
      config.showDiastolicBloodPressure ? [config.showDiastolicBloodPressure boolValue] : false;
  cppConfig.show_cardiac_stress = config.showCardiacStress ? [config.showCardiacStress boolValue] : false;
  if (config.realtimeHrPeriodSeconds != nil) {
    cppConfig.realtime_hr_period_seconds = [config.realtimeHrPeriodSeconds floatValue];
  }
  if (config.realtimeHrvPeriodSeconds != nil) {
    cppConfig.realtime_hrv_period_seconds = [config.realtimeHrvPeriodSeconds floatValue];
  }
  if (config.realtimeCardiacStressPeriodSeconds != nil) {
    cppConfig.realtime_cardiac_stress_period_seconds = [config.realtimeCardiacStressPeriodSeconds floatValue];
  }

  shen::SetCustomMeasurementConfig(cppConfig);
}

- (void)setCustomColorThemeTheme:(CustomColorTheme *)theme error:(FlutterError *_Nullable *_Nonnull)error {
  shen::custom_color_theme cppTheme;

  if (theme.themeColor != nil) {
    cppTheme.theme_color = [theme.themeColor UTF8String];
  }
  if (theme.textColor != nil) {
    cppTheme.text_color = [theme.textColor UTF8String];
  }
  if (theme.backgroundColor != nil) {
    cppTheme.background_color = [theme.backgroundColor UTF8String];
  }
  if (theme.tileColor != nil) {
    cppTheme.tile_color = [theme.tileColor UTF8String];
  }

  shen::SetCustomColorTheme(cppTheme);
}

- (void)setLanguageLanguage:(NSString *)language error:(FlutterError *_Nullable *_Nonnull)error {
  shen::SetLanguage([language UTF8String]);
}

@end

@implementation ShenaiSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  ShenFlutterApi *api = [[ShenFlutterApi alloc] init];
  ShenaiSdkNativeApiSetup([registrar messenger], api);

  ShenaiSdkViewFactory *factory = [[ShenaiSdkViewFactory alloc] initWithMessenger:[registrar messenger]];
  [registrar registerViewFactory:factory withId:@"ShenaiSdkView"];
}

@end
