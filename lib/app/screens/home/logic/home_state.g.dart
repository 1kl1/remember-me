// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeStateImpl _$$HomeStateImplFromJson(Map<String, dynamic> json) =>
    _$HomeStateImpl(
      recordedFilePath: json['recordedFilePath'] as String?,
      isUploading: json['isUploading'] as bool? ?? false,
      selectedTab:
          $enumDecodeNullable(_$HomeTabsEnumMap, json['selectedTab']) ??
          HomeTabs.record,
    );

Map<String, dynamic> _$$HomeStateImplToJson(_$HomeStateImpl instance) =>
    <String, dynamic>{
      'recordedFilePath': instance.recordedFilePath,
      'isUploading': instance.isUploading,
      'selectedTab': _$HomeTabsEnumMap[instance.selectedTab]!,
    };

const _$HomeTabsEnumMap = {
  HomeTabs.record: 'record',
  HomeTabs.answer: 'answer',
};
