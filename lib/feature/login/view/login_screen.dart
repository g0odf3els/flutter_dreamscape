import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/feature/login/bloc/login_bloc.dart';
import 'package:flutter_dreamscape/feature/register/view/register_screen.dart';
import 'package:flutter_dreamscape/feature/share/widgets/form_error_widget.dart';
import 'package:flutter_dreamscape/feature/share/widgets/success_dialog.dart';
import 'package:flutter_dreamscape/core/error/excetpions/exceptions.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginLoadSuccess) {
                context.read<AuthBloc>().add(
                      AuthAuthenticateEvent(state.user),
                    );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SuccessDialog(
                      title: 'Success',
                      text: 'Your login was successful!',
                      buttonText: 'Continue',
                    );
                  },
                );
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              } else if (state is LoginLoadInProgress) {
                setState(() {
                  _loading = true;
                });
              } else {
                setState(() {
                  _loading = false;
                });
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(title: const Text("Login")),
                body: Builder(
                  builder: (_) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                if (state is LoginLoadFailure &&
                                    state.exception is FormGeneralException)
                                  FormErrorWidget(
                                    (state.exception as FormGeneralException)
                                        .message,
                                  ),
                                FormBuilderTextField(
                                  name: 'username',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'password',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                  ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                  onSubmitted: (_) {
                                    if (!_loading) {
                                      _submitForm(context);
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                            'Login',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                ),
                                MaterialButton(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Register',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value;
      context.read<LoginBloc>().add(
            LoginRequest(
              username: data!['username'],
              password: data['password'],
            ),
          );
    }
  }
}
