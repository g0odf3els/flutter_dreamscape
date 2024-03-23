import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/features/image_list/image_list.dart';
import 'package:flutter_dreamscape/features/login/login.dart';
import 'package:flutter_dreamscape/features/profile/view/profile_screen.dart';
import 'package:flutter_dreamscape/features/upload/upload.dart';
import 'package:flutter_dreamscape/repositories/image/models/get_image_list_params.dart';
import 'package:flutter_dreamscape/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(AuthLoadUserEvent()),
      child: MaterialApp(
        title: 'Dreamscape',
        theme: basicTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const CircularProgressIndicator();
            } else {
              return const Navigation();
            }
          },
        ),
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.photo),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return <Widget>[
              ImageListScreen(params: GetImageListParams()),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is AuthAuthenticatedState) {
                  return const UploadScreen();
                }
                return LoginScreen();
              }),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is AuthAuthenticatedState) {
                  return ProfileScreen(userId: state.user.id);
                }
                return LoginScreen();
              })
            ][index];
          },
        );
      },
    );
  }
}
