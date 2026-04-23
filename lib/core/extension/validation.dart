extension EmailValidation on String {
  bool emailValid() => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(this);

  bool passwordValid() => RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  ).hasMatch(this);

  bool nameValid() =>
      RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(this);

  bool phoneValid() => RegExp(r'^(?:\+?0?1)?[0-9]{11}$').hasMatch(this);

  bool zipCodeValid() => RegExp(r'^\d{5}(-\d{4})?$').hasMatch(this);
}
