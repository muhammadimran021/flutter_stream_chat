import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/audio_session_helper.dart';
import 'core/theme/stream_chat_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/chat/presentation/pages/main_navigation_page.dart';
import 'features/chat/presentation/cubit/navigation_cubit.dart';
import 'features/chat/presentation/bloc/user_search_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Configure audio session for voice recording
  await AudioSessionHelper.configureAudioSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
      ],
      child: MaterialApp(
        title: 'Stream Chat',
        theme: StreamChatAppTheme.lightTheme,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return _buildChatApp(context, state.user);
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const AuthPage();
        }
      },
    );
  }

  Widget _buildChatApp(BuildContext context, user) {
    // Check if client is already registered
    StreamChatClient client;
    try {
      client = di.sl<StreamChatClient>();
    } catch (e) {
      // Client not registered yet, create and register it
      client = StreamChatClient(
        AppConstants.streamApiKey,
        logLevel: Level.INFO,
      );
      di.sl.registerSingleton<StreamChatClient>(client);
    }

    return FutureBuilder<String?>(
      future: _connectUserToStream(client, user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to connect to Stream'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    child: const Text('Go Back to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        return StreamChat(
          client: client,
          child: StreamChatTheme(
            data: StreamChatThemeData(), // Or customize it
            child: MultiBlocProvider(
              providers: [
                BlocProvider<NavigationCubit>(
                  create: (context) => di.sl<NavigationCubit>(),
                ),
                BlocProvider<UserSearchBloc>(
                  create: (context) => di.sl<UserSearchBloc>(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: StreamChatAppTheme.lightTheme,
                home: const MainNavigationPage(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _connectUserToStream(StreamChatClient client, user) async {
    try {
      await client.connectUser(
        User(id: user.id, extraData: {'name': user.username}),
        user.streamToken!,
      );
      return user.streamToken;
    } catch (e) {
      debugPrint('Error connecting to Stream: $e');
      return null;
    }
  }
}
