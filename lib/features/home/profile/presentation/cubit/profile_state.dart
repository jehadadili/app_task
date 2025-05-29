
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userProfileData; 

  ProfileLoaded({required this.userProfileData});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileLoggedOut extends ProfileState {}

