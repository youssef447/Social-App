
abstract class loginStates{}

class LoginInitialState extends loginStates {}

class LoginLoadingState extends loginStates {}

class LoginSuccessState extends loginStates
{
 /*  final Emp loginModel;

  LoginSuccessState(this.loginModel); */
}

class LoginErrorState extends loginStates
{
  final String error;

  LoginErrorState(this.error);
}