abstract class SignInState{}

class SignInSuccess implements SignInState{}

class SignInError implements SignInState{}

class SignInLoading implements SignInState{}


abstract class SignInAction{}

class SignInSuccessAction extends SignInAction{}

class SignInErrorAction extends SignInAction {}


abstract class ButtonState{}

class ButtonLoading implements ButtonState{}

class ButtonActive implements ButtonState{}
 
class ButtonInactive implements ButtonState{}
