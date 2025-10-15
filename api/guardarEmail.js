class Email {
  constructor() {
    this.esseEmail = ""; // valor inicial vazio
  }

  guardar(email) {
    this.esseEmail = email;
  }

  retornar() {
    return this.esseEmail;
  }
}
