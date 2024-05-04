import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/create_collection.dart';
import 'package:flutter_dreamscape/feature/image/widgets/create_collection/bloc/create_collection_bloc.dart';
import 'package:flutter_dreamscape/feature/share/widgets/form_error_widget.dart';
import 'package:flutter_dreamscape/feature/share/widgets/success_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

class CreateCollectionWidget extends StatefulWidget {
  const CreateCollectionWidget({super.key, required this.fileId});

  final String fileId;

  @override
  State<CreateCollectionWidget> createState() => _CreateCollectionWidgetState();
}

class _CreateCollectionWidgetState extends State<CreateCollectionWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CreateCollectionBloc(createCollection: GetIt.I<CreateCollection>()),
        child: BlocConsumer<CreateCollectionBloc, CreateCollectionState>(
            listener: (context, state) {
          if (state is CreateCollectionSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SuccessDialog(
                  title: 'Success',
                  text: 'Collection have been created',
                  buttonText: 'Continue',
                );
              },
            );
            Navigator.pop(context);
          } else if (state is CreateCollectionLoading) {
            setState(() {
              _loading = true;
            });
          } else {
            setState(() {
              _loading = false;
            });
          }
        }, builder: (context, state) {
          return FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state is CreateCollectionFailure)
                        const FormErrorWidget('Something gone wrong'),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                          name: 'description',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Desription',
                          ),
                          obscureText: true),
                      FormBuilderCheckbox(
                          name: 'isPrivate', title: const Text('Is Private')),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          if (!_loading) {
                            _submitForm(context);
                          }
                        },
                        child: _loading
                            ? const Center(
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Create',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ));
        }));
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value;
      context.read<CreateCollectionBloc>().add(
            CreateCollectionRequest(
              name: data!['name'],
              description: data['description'],
              isPrivate: data['isPrivate'],
              filesId: [widget.fileId],
              accessToken:
                  (context.read<AuthBloc>().state as AuthAuthenticatedState)
                      .user
                      .accessToken,
            ),
          );
    }
  }
}
