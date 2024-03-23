import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/features/image_list/image_list.dart';
import 'package:flutter_dreamscape/repositories/image/models/get_image_list_params.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ImageSearchParams extends StatefulWidget {
  const ImageSearchParams({super.key, required this.params});

  final GetImageListParams params;

  @override
  State<ImageSearchParams> createState() => _ImageSearchParamsState();
}

class _ImageSearchParamsState extends State<ImageSearchParams> {
  final MultiSelectController aspectController = MultiSelectController();
  final MultiSelectController resoltionsController = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search params'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              MultiSelectDropDown(
                controller: resoltionsController,
                onOptionSelected: (List<ValueItem> selectedOptions) {},
                options: const [
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
                ],
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
                options: const [
                  ValueItem(label: '16x9', value: '1'),
                  ValueItem(label: '4x3', value: '2'),
                  ValueItem(label: '3x2', value: '3'),
                  ValueItem(label: '1x1', value: '4'),
                  ValueItem(label: '21x9', value: '5'),
                ],
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
                  GetImageListParams params = GetImageListParams(
                      resolutions: resoltionsController.selectedOptions
                          .map((e) => e.label)
                          .toList(),
                      aspectRations: aspectController.selectedOptions
                          .map((e) => e.label)
                          .toList());

                  Navigator.push(
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
            ])));
  }
}
