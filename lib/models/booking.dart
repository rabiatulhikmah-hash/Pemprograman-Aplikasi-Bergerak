class Booking {
  final String id;
  final String namaFilm;
  final String jadwal;
  final String studio;
  final String kursi;
  final int harga;
  final String namaPemesan;
  final String noHp;
  final String email;
  final String? userId;

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
    this.userId,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      namaFilm: map['nama_film'] ?? '',
      jadwal: map['jadwal'] ?? '',
      studio: map['studio'] ?? '',
      kursi: map['kursi'] ?? '',
      harga: map['harga'] ?? 0,
      namaPemesan: map['nama_pemesan'] ?? '',
      noHp: map['no_hp'] ?? '',
      email: map['email'] ?? '',
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_film': namaFilm,
      'jadwal': jadwal,
      'studio': studio,
      'kursi': kursi,
      'harga': harga,
      'nama_pemesan': namaPemesan,
      'no_hp': noHp,
      'email': email,
    };
  }
}