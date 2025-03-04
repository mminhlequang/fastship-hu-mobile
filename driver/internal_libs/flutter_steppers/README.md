<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

<p>
  <a href="https://github.com/namnpse/flutter_steppers">
    <img src="https://img.shields.io/github/stars/namnpse/flutter_steppers?logo=github" />
  </a>
  <img src="https://img.shields.io/github/license/namnpse/flutter_steppers?logo=github" />
  <img src="https://img.shields.io/badge/version-0.0.2-blue.svg" />
  <img src="https://img.shields.io/badge/flutter-v2.8.0-blue.svg" />
  <img src="https://img.shields.io/badge/dart-v2.15.0-blue.svg" />
  <a href="https://github.com/namnpse">
    <img alt="GitHub: Namnpse" src="https://img.shields.io/github/followers/namnpse?label=Follow&style=social" target="_blank" />
  </a>
</p>

Open source Flutter package, bar indicator made of a series of selected and unselected steps.<br>
Made by Nguyen Phuong Nam (namnpse)<br>
Check out the full source code [here](https://github.com/namnpse/flutter_steppers/)

## Features

 - Horizontal Steppers
 - Vertical Steppers
 - Customize Steppers style, indicator color, label max lines, and more ...

## Getting started

Install the package. 
```yaml
dependencies:
  flutter:
    sdk: flutter
  progress_bar_steppers: ^0.0.2
```

Import the package
```yaml
import 'package:progress_bar_steppers/steppers.dart';
```

## Screenshots

#### Horizontal Steppers (Normal)

![Horizontal Steppers](https://github.com/namnpse/flutter_steppers/blob/dev/screenshots/horizontal-steppers-normal.png)

#### Horizontal Steppers (Error)

![Horizontal Steppers Error](https://github.com/namnpse/flutter_steppers/blob/dev/screenshots/horizontal-steppers-error.png)

#### Vertical Steppers (Normal)

![Vertical Steppers](https://github.com/namnpse/flutter_steppers/blob/dev/screenshots/vertical-steppers-normal.png)

## Usage
<b>Horizontal Steppers</b>
```dart
  var currentStep = 1;
  var totalSteps = 0;
  final stepsData = [
    StepperData(
      label: 'Step 1',
    ),
    StepperData(
      label: 'Step 2',
    ),
    StepperData(
      label: 'Step 3',
    ),
    StepperData(
      label: 'Step 4',
    ),
  ];

  @override
  void initState() {
    totalSteps = stepsData.length;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Steppers(
            direction: StepperDirection.horizontal,
            labels: stepsData,
            currentStep: currentStep,
            stepBarStyle: StepperStyle(
                // activeColor: StepperColors.red500,
              maxLineLabel: 2,
                // inactiveColor: StepperColors.ink200s
            ),
          );
  }
```

<b>Vertical Steppers</b>
```dart
var currentStep = 1;
  var totalSteps = 0;
  late List<StepperData> stepsData;

  @override
  void initState() {
    super.initState();
    stepsData = [
      StepperData(
        label: 'Step 1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur risus est, sed consequat libero luctus vitae. Duis ultrices magna quis risus porttitor luctus. Nulla vel tempus nisl, ultricies congue lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
        child: ElevatedButton(
          child: const Text('Button 1'),
          onPressed: () {},
        ),
      ),
      StepperData(
        label: 'Step 2',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur risus est, sed consequat libero luctus vitae. Duis ultrices magna quis risus porttitor luctus. Nulla vel tempus nisl, ultricies congue lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
      ),
      StepperData(
        label: 'Step 3',
      ),
      StepperData(
        label: 'Step 4',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec efficitur risus est, sed consequat libero luctus vitae. Duis ultrices magna quis risus porttitor luctus. Nulla vel tempus nisl, ultricies congue lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
      ),
    ];
    totalSteps = stepsData.length;
  }
  @override
  Widget build(BuildContext context) {
    return Steppers(
          direction: StepperDirection.vertical,
          labels: stepsData,
          currentStep: currentStep,
          stepBarStyle: StepperStyle(
            //   activeColor: DSColors.red500,
            maxLineLabel: 2,
            //   inactiveColor: DSColors.purple100
          ),
        );
  }
```

## License

MIT License, see the [LICENSE.md](https://github.com/namnpse/flutter_steppers/blob/master/LICENSE) file for details.
