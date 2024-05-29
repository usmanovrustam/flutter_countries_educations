import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countries_educations/data/model/address/country.dart';
import 'package:flutter_countries_educations/data/model/address/district.dart';
import 'package:flutter_countries_educations/data/model/address/neighborhood.dart';
import 'package:flutter_countries_educations/data/model/address/region.dart';
import 'package:flutter_countries_educations/presentation/bottom_sheet.dart';
import 'package:flutter_countries_educations/src/assets/assets.gen.dart';

class AddressSelector {
  static Future<List<T>> _loadData<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final String jsonString = await rootBundle.loadString(path);
    final jsonList = await Isolate.run(
      () => jsonDecode(jsonString) as List<dynamic>,
    );
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Country>> _loadCountries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final countries = await _loadData(
      AssetsManager.json.countries,
      Country.fromJson,
    );

    return countries;
  }

  static Future<List<Region>> _loadRegions(int? countryId) async {
    final List<Region> regions = await _loadData(
      AssetsManager.json.regions,
      Region.fromJson,
    );

    List<Region> filteredRegions = [];

    if (countryId != null) {
      filteredRegions = regions.where((region) {
        return region.countryId == countryId;
      }).toList();
    }

    return filteredRegions;
  }

  static Future<List<District>> _loadDistricts(int? regionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final districts = await _loadData(
      AssetsManager.json.districts,
      District.fromJson,
    );

    List<District> filteredDistricts = [];

    if (regionId != null) {
      filteredDistricts = districts.where((region) {
        return region.regionId == regionId;
      }).toList();
    }

    return filteredDistricts;
  }

  static Future<List<Neighborhood>> _loadNeighborhoods(int? districtId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final neighborhoods = await _loadData(
      AssetsManager.json.neighborhoods,
      Neighborhood.fromJson,
    );

    List<Neighborhood> filteredNeighborhoods = [];

    if (districtId != null) {
      filteredNeighborhoods = neighborhoods.where((region) {
        return region.districtId == districtId;
      }).toList();
    }

    return filteredNeighborhoods;
  }

  static Widget country({
    required String title,
    required void Function(Country?) onItemSelect,
    required Widget Function(BuildContext) builder,
    Country? selectedCountry,
  }) {
    return BottomSheetBuilder<Country>(
      title: title,
      onItemSelect: onItemSelect,
      builder: builder,
      load: _loadCountries,
      foregroundItemBuilder: (context, item) {
        return ListTile(
          leading: ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: SvgGenImage(item.flagPath).svg(fit: BoxFit.fill),
            ),
          ),
          title: Text(item.name),
          subtitle: Text(item.dialCode),
          trailing: selectedCountry != null && selectedCountry.id == item.id
              ? const Icon(Icons.radio_button_checked, color: Colors.blue)
              : null,
        );
      },
    );
  }

  static Widget region({
    required String title,
    required int? countryId,
    required void Function(Region?) onItemSelect,
    required Widget Function(BuildContext) builder,
    Region? selectedRegion,
  }) {
    return BottomSheetBuilder<Region>(
      title: title,
      onItemSelect: onItemSelect,
      builder: builder,
      load: () => _loadRegions(countryId),
      foregroundItemBuilder: (context, item) {
        return ListTile(
          title: Text(item.name),
          trailing: selectedRegion != null && selectedRegion.id == item.id
              ? const Icon(Icons.radio_button_checked, color: Colors.blue)
              : null,
        );
      },
    );
  }

  static Widget district({
    required String title,
    required int? regionId,
    required void Function(District?) onItemSelect,
    required Widget Function(BuildContext) builder,
    District? selectedDistrict,
  }) {
    return BottomSheetBuilder<District>(
      title: title,
      onItemSelect: onItemSelect,
      builder: builder,
      load: () => _loadDistricts(regionId),
      foregroundItemBuilder: (context, item) {
        return ListTile(
          title: Text(item.name),
          trailing: selectedDistrict != null && selectedDistrict.id == item.id
              ? const Icon(Icons.radio_button_checked, color: Colors.blue)
              : null,
        );
      },
    );
  }

  static Widget neighborhood(
      {required String title,
      required int? districtId,
      required void Function(Neighborhood?) onItemSelect,
      required Widget Function(BuildContext) builder,
      Neighborhood? selectedNeighborhood}) {
    return BottomSheetBuilder<Neighborhood>(
      title: title,
      onItemSelect: onItemSelect,
      builder: builder,
      load: () => _loadNeighborhoods(districtId),
      foregroundItemBuilder: (context, item) {
        return ListTile(
          title: Text(item.name),
          trailing:
              selectedNeighborhood != null && selectedNeighborhood.id == item.id
                  ? const Icon(Icons.radio_button_checked, color: Colors.blue)
                  : null,
        );
      },
    );
  }
}
