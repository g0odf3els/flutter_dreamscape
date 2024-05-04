import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/user/get_user.dart';
import 'package:flutter_dreamscape/feature/image/widgets/user_card.dart';
import 'package:flutter_dreamscape/feature/profile/bloc/profile_bloc.dart';
import 'package:flutter_dreamscape/feature/share/widgets/request_error.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final imageBloc = ProfileBloc(getUser: GetIt.I<GetUser>())
      ..add(ProfileLoadRequest(widget.userId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: imageBloc,
            builder: (context, state) {
              if (state is ProfileLoadSuccess) {
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      UserCard(user: state.user),
                      Flexible(
                          child: Container(
                              child: const DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'Uploads'),
                                Tab(text: 'Collections'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
                                    child: Text(
                                        "User does not have any uploads yet",
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
                                    child: Text(
                                      "User does not have any public collections",
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )))
                    ]));
              }
              if (state is ProfileLoadFailure) {
                return RequestError(
                    errorMessage: 'Something went wrong.',
                    onRetry: () {
                      imageBloc.add(ProfileLoadRequest(widget.userId));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
