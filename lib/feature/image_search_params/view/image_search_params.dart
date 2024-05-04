import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_image_list.dart';
import 'package:flutter_dreamscape/feature/image_list/image_list.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

var resolutionOptions = const [
  ValueItem(label: '1920x1080', value: '1'),
  ValueItem(label: '1600x900', value: '2'),
  ValueItem(label: '1280x720', value: '3'),
  ValueItem(label: '3840x2160', value: '4'),
  ValueItem(label: '2560x1440', value: '5'),
  ValueItem(label: '1440x900', value: '6'),
  ValueItem(label: '1366x768', value: '7'),
  ValueItem(label: '1024x768', value: '8'),
  ValueItem(label: '800x600', value: '9'),
  ValueItem(label: '720x576', value: '10'),
  ValueItem(label: '640x480', value: '11'),
  ValueItem(label: '480x360', value: '12'),
  ValueItem(label: '320x240', value: '13'),
  ValueItem(label: '240x180', value: '14'),
  ValueItem(label: '160x120', value: '15'),
  ValueItem(label: '80x60', value: '16'),
];

var aspectRatioOptions = const [
  ValueItem(label: '16x9', value: '1'),
  ValueItem(label: '4x3', value: '2'),
  ValueItem(label: '3x2', value: '3'),
  ValueItem(label: '1x1', value: '4'),
  ValueItem(label: '21x9', value: '5'),
];

class ImageSearchParams extends StatefulWidget {
  const ImageSearchParams({super.key, required this.params});

  final ParamsGetPagedImageList params;

  @override
  State<ImageSearchParams> createState() => _ImageSearchParamsState();
}

class _ImageSearchParamsState extends State<ImageSearchParams> {
  final MultiSelectController aspectController = MultiSelectController();
  final MultiSelectController resolutionController = MultiSelectController();

  @override
  void initState() {
    super.initState();
    setupControllers();
  }

  void setupControllers() {
    List<ValueItem<String>> selectedAspectRatioOptions = [];
    if (widget.params.aspectRations != null) {
      selectedAspectRatioOptions = widget.params.aspectRations!
          .map((label) => ValueItem(
              label: label, value: label.toLowerCase().replaceAll('x', '')))
          .toList();

      aspectController.selectedOptions.addAll(selectedAspectRatioOptions);
      aspectController.options.addAll(selectedAspectRatioOptions);
    }
    for (var option in aspectRatioOptions) {
      if (!aspectController.selectedOptions
          .any((e) => e.label == option.label)) {
        aspectController.options.add(option);
      }
    }

    List<ValueItem<String>> selectedResolutionOptions = [];
    if (widget.params.resolutions != null) {
      selectedResolutionOptions = widget.params.resolutions!
          .map((label) => ValueItem(
              label: label, value: label.toLowerCase().replaceAll('x', '')))
          .toList();

      resolutionController.selectedOptions.addAll(selectedResolutionOptions);
      resolutionController.options.addAll(selectedResolutionOptions);
    }
    for (var option in resolutionOptions) {
      if (!resolutionController.selectedOptions
          .any((e) => e.label == option.label)) {
        resolutionController.options.add(option);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
        child: Column(children: [
          MultiSelectDropDown(
            controller: resolutionController,
            onOptionSelected: (List<ValueItem> selectedOptions) {},
            options: [],
            borderRadius: 0,
            clearIcon: null,
            selectionType: SelectionType.multi,
            chipConfig: const ChipConfig(
                wrapType: WrapType.wrap,
                radius: 0,
                runSpacing: 0,
                backgroundColor: Colors.black),
            optionTextStyle: const TextStyle(fontSize: 16),
            selectedOptionIcon: const Icon(Icons.check_circle),
            selectedOptionTextColor: Colors.white,
            selectedOptionBackgroundColor: Colors.black,
          ),
          const SizedBox(height: 10),
          MultiSelectDropDown(
            controller: aspectController,
            onOptionSelected: (List<ValueItem> selectedOptions) {},
            options: const [],
            borderRadius: 0,
            clearIcon: null,
            selectionType: SelectionType.multi,
            chipConfig: const ChipConfig(
                wrapType: WrapType.wrap,
                radius: 0,
                runSpacing: 0,
                backgroundColor: Colors.black),
            optionTextStyle: const TextStyle(fontSize: 16),
            selectedOptionIcon: const Icon(Icons.check_circle),
            selectedOptionTextColor: Colors.white,
            selectedOptionBackgroundColor: Colors.black,
          ),
          const SizedBox(height: 10),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              ParamsGetPagedImageList params = ParamsGetPagedImageList(
                  resolutions: resolutionController.selectedOptions
                      .map((e) => e.label)
                      .toList(),
                  aspectRations: aspectController.selectedOptions
                      .map((e) => e.label)
                      .toList());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageListScreen(params: params)),
              );
            },
            child: const SizedBox(
              width: double.infinity,
              child: Text(
                'Search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]));
  }
}
