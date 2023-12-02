
abstract class signupStates{}

class signupInitialState extends signupStates {}

class signupLoadingState extends signupStates {}

class signupSuccessState extends signupStates
{
/*   final Emp signupModel;

  signupSuccessState(this.signupModel); */
}

class signupErrorState extends signupStates
{
  final dynamic error;

  signupErrorState(this.error);
}
class pickedImageErrorState extends signupStates
{
  final String error;

  pickedImageErrorState(this.error);
}

class pickedImageSuccessState extends signupStates {}
class updatedCurrentStep extends signupStates{}

