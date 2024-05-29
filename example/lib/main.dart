// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_countries_educations/flutter_countries_educations.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Country? _country;
  Region? _region;
  District? _district;
  Neighborhood? _neighborhood;
  EducationType? _educationType;
  Region? _educationRegion;
  District? _educationDistrict;
  School? _school;
  University? _university;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Address"),
              AddressSelector.country(
                title: 'Select Country',
                onItemSelect: (country) {
                  setState(() {
                    _country = country;
                  });
                },
                selectedCountry: _country,
                builder: (context) => const ElevatedButton(
                  onPressed: null,
                  child: Text('Select Country'),
                ),
              ),
              if (_country != null)
                AddressSelector.region(
                  title: 'Select Region',
                  countryId: _country?.id,
                  onItemSelect: (region) {
                    setState(() {
                      _region = region;
                    });
                  },
                  builder: (context) => const ElevatedButton(
                    onPressed: null,
                    child: Text('Select Region'),
                  ),
                ),
              if (_region != null)
                AddressSelector.district(
                  regionId: _region?.id,
                  title: 'Select District',
                  onItemSelect: (district) {
                    setState(() {
                      _district = district;
                    });
                  },
                  builder: (context) => const ElevatedButton(
                    onPressed: null,
                    child: Text('Select District'),
                  ),
                ),
              if (_district != null)
                AddressSelector.neighborhood(
                  districtId: _district?.id,
                  title: 'Select Neighborhood',
                  onItemSelect: (neighborhood) {
                    setState(() {
                      _neighborhood = neighborhood;
                    });
                  },
                  builder: (context) => const ElevatedButton(
                    onPressed: null,
                    child: Text('Select Neighborhood'),
                  ),
                ),
              const SizedBox(height: 20),
              const Text("Education"),
              EducationSelector.educationType(
                title: 'Select Education Type',
                selectedType: _educationType,
                onTypeSelect: (educationType) {
                  setState(() {
                    _educationType = educationType;
                  });
                },
                builder: (context) => const ElevatedButton(
                  onPressed: null,
                  child: Text('Select Education Type'),
                ),
              ),
              if (_educationType != null)
                AddressSelector.region(
                  title: 'Select Region',
                  countryId: _country?.id,
                  onItemSelect: (region) {
                    setState(() {
                      _educationRegion = region;
                    });
                  },
                  builder: (context) => const ElevatedButton(
                    onPressed: null,
                    child: Text('Select Region'),
                  ),
                ),
              if (!(_educationType?.isUniversity ?? false) &&
                  _educationRegion != null)
                AddressSelector.district(
                  regionId: _region?.id,
                  title: 'Select District',
                  onItemSelect: (district) {
                    setState(() {
                      _district = district;
                    });
                  },
                  builder: (context) => const ElevatedButton(
                    onPressed: null,
                    child: Text('Select District'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
