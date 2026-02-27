// Data film yang tersedia
const List<String> daftarFilm = [
  'Avengers: Secret Wars',
  'Inception 2',
  'The Dark Knight Returns',
  'Interstellar 2',
  'Spider-Man: Beyond',
];

// Jadwal per film: Map<namaFilm, List<jadwal>>
const Map<String, List<String>> jadwalPerFilm = {
  'Avengers: Secret Wars': [
    'Senin, 2 Jun 2025 - 10:00',
    'Senin, 2 Jun 2025 - 13:00',
    'Selasa, 3 Jun 2025 - 19:00',
  ],
  'Inception 2': [
    'Senin, 2 Jun 2025 - 11:00',
    'Rabu, 4 Jun 2025 - 14:00',
    'Rabu, 4 Jun 2025 - 20:00',
  ],
  'The Dark Knight Returns': [
    'Selasa, 3 Jun 2025 - 10:00',
    'Kamis, 5 Jun 2025 - 15:00',
    'Kamis, 5 Jun 2025 - 21:00',
  ],
  'Interstellar 2': [
    'Rabu, 4 Jun 2025 - 10:00',
    'Jumat, 6 Jun 2025 - 13:00',
    'Jumat, 6 Jun 2025 - 18:00',
  ],
  'Spider-Man: Beyond': [
    'Kamis, 5 Jun 2025 - 11:00',
    'Sabtu, 7 Jun 2025 - 14:00',
    'Sabtu, 7 Jun 2025 - 20:00',
  ],
};

// Studio per jadwal: Map<jadwal, studio>
const Map<String, String> studioPerJadwal = {
  'Senin, 2 Jun 2025 - 10:00': 'Studio 1',
  'Senin, 2 Jun 2025 - 13:00': 'Studio 2',
  'Selasa, 3 Jun 2025 - 19:00': 'Studio IMAX',
  'Senin, 2 Jun 2025 - 11:00': 'Studio VIP',
  'Rabu, 4 Jun 2025 - 14:00': 'Studio 1',
  'Rabu, 4 Jun 2025 - 20:00': 'Studio 2',
  'Selasa, 3 Jun 2025 - 10:00': 'Studio 1',
  'Kamis, 5 Jun 2025 - 15:00': 'Studio VIP',
  'Kamis, 5 Jun 2025 - 21:00': 'Studio IMAX',
  'Rabu, 4 Jun 2025 - 10:00': 'Studio 2',
  'Jumat, 6 Jun 2025 - 13:00': 'Studio 1',
  'Jumat, 6 Jun 2025 - 18:00': 'Studio IMAX',
  'Kamis, 5 Jun 2025 - 11:00': 'Studio VIP',
  'Sabtu, 7 Jun 2025 - 14:00': 'Studio 1',
  'Sabtu, 7 Jun 2025 - 20:00': 'Studio 2',
};

// Kursi per studio
const Map<String, List<String>> kursiPerStudio = {
  'Studio 1': ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3'],
  'Studio 2': ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3'],
  'Studio VIP': ['V1', 'V2', 'V3', 'V4', 'V5', 'V6'],
  'Studio IMAX': ['I1', 'I2', 'I3', 'I4', 'I5', 'I6', 'I7', 'I8'],
};

// Harga berdasarkan tipe studio
int getHarga(String studio) {
  if (studio == 'Studio VIP') return 75000;
  if (studio == 'Studio IMAX') return 95000;
  return 45000; // Studio 1 & 2
}

String formatHarga(int harga) {
  return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}