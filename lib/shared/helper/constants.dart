enum Provider {
  email('email/password'),
  google('google.com'),
  facebook('facebook.com');

  final String provider;
  const Provider(this.provider);
}
