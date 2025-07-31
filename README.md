# Flutter Stream Chat with Clean Architecture

A Flutter chat application built with Stream Chat SDK using Clean Architecture principles and BLoC for state management.

## Features

- ✅ User Authentication (Login/Signup)
- ✅ Real-time Chat with Stream Chat SDK
- ✅ Clean Architecture Implementation
- ✅ BLoC State Management
- ✅ Dependency Injection with GetIt
- ✅ Local Data Persistence
- ✅ Form Validation
- ✅ Modern UI/UX Design

## Architecture

This project follows Clean Architecture principles with the following layers:

### Domain Layer
- **Entities**: Core business objects (User)
- **Use Cases**: Business logic implementation
- **Repositories**: Abstract interfaces for data access

### Data Layer
- **Models**: Data transfer objects
- **Data Sources**: Remote and local data sources
- **Repository Implementations**: Concrete implementations of repositories

### Presentation Layer
- **BLoC**: State management
- **Pages**: UI screens
- **Widgets**: Reusable UI components

### Core
- **Constants**: App configuration
- **DI**: Dependency injection setup
- **Errors**: Failure handling

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   └── injection_container.dart
│   └── errors/
│       └── failures.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_data_source.dart
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_user_usecase.dart
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_out_usecase.dart
│   │   │       └── sign_up_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   └── auth_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── signup_form.dart
│   └── chat/
│       └── presentation/
│           └── pages/
│               └── chat_home_page.dart
└── main.dart
```

## Setup

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Stream Chat Account
- Supabase Account

### Configuration

1. **Stream Chat Setup**:
   - Create a Stream Chat account
   - Get your API key and secret
   - Update `lib/core/constants/app_constants.dart` with your Stream API key

2. **Supabase Edge Function**:
   - Deploy the provided edge function to your Supabase project
   - Update the Supabase URL in `app_constants.dart`

3. **Environment Variables**:
   Make sure your Supabase edge function has these environment variables:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `STREAM_API_KEY`
   - `STREAM_API_SECRET`

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Usage

### Authentication Flow

1. **Login**: Users can log in with email, password, and username
2. **Signup**: New users can create accounts with the same credentials
3. **Auto-login**: The app checks for existing user sessions on startup
4. **Logout**: Users can log out from the chat screen

### Chat Features

1. **Channel List**: View all channels the user is a member of
2. **Create Channels**: Add new channels with custom names and members
3. **Real-time Messaging**: Send and receive messages in real-time
4. **Message History**: View previous messages in channels

## Edge Function

The authentication is handled by a Supabase Edge Function. Here's the TypeScript code:

```typescript
// functions/stream-auth/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { StreamChat } from 'https://esm.sh/stream-chat@6.3.0';

const supabaseClient = createClient(Deno.env.get('SUPABASE_URL'), Deno.env.get('SUPABASE_ANON_KEY'));
const streamClient = StreamChat.getInstance(Deno.env.get('STREAM_API_KEY'), Deno.env.get('STREAM_API_SECRET'));

serve(async (req) => {
  const { email, password, username } = await req.json();
  
  // 1. Sign in or sign up user with Supabase
  let { data: { user }, error } = await supabaseClient.auth.signInWithPassword({
    email,
    password
  });
  
  if (error && error.message.includes('Invalid login credentials')) {
    // Try to signup if user doesn't exist
    const signup = await supabaseClient.auth.signUp({
      email,
      password
    });
    user = signup.data.user;
    if (!user) return new Response(JSON.stringify({
      error: signup.error?.message
    }), { status: 400 });
  }
  
  if (!user) return new Response(JSON.stringify({
    error: 'Authentication failed'
  }), { status: 401 });
  
  // 2. Create or get Stream user token
  const streamToken = streamClient.createToken(user.id);
  
  return new Response(JSON.stringify({
    user: {
      id: user.id,
      email: user.email,
      username
    },
    streamToken
  }), {
    headers: { 'Content-Type': 'application/json' }
  });
});
```

## Dependencies

### State Management
- `flutter_bloc`: BLoC pattern implementation
- `equatable`: Value equality for objects

### Dependency Injection
- `get_it`: Service locator for dependency injection

### Network & API
- `dio`: HTTP client for API calls
- `http`: HTTP client (legacy, used in some parts)

### Local Storage
- `shared_preferences`: Local data persistence

### Form Validation
- `form_validator`: Form validation utilities

### Functional Programming
- `dartz`: Functional programming utilities (Either type)

### Chat SDK
- `stream_chat_flutter`: Stream Chat Flutter SDK

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
