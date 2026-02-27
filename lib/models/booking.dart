class Booking {
  final String id;
  String namaFilm;
  String jadwal;
  String studio;
  String kursi;
  int harga;
  String namaPemesan;
  String noHp;
  String email;

  Booking({
    required this.id,
    required this.namaFilm,
    required this.jadwal,
    required this.studio,
    required this.kursi,
    required this.harga,
    required this.namaPemesan,
    required this.noHp,
    required this.email,
  });
}