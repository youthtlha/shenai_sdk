#!/bin/bash

flutter pub run pigeon \
--input pigeons/message.dart \
--dart_out lib/pigeon.dart \
--objc_header_out ios/Classes/pigeon.h \
--objc_source_out ios/Classes/pigeon.m \
--java_out ./android/src/main/java/ai/mxlabs/shenai_sdk_flutter/Pigeon.java \
--java_package "ai.mxlabs.shenai_sdk_flutter"