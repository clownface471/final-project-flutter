class Dessert {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  // Constructor utama sekarang membutuhkan harga.
  Dessert({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  // Factory ini digunakan saat mengambil data dari API TheMealDB.
  // Di sinilah harga yang konsisten dibuat untuk pertama kalinya.
  factory Dessert.fromJson(Map<String, dynamic> json) {
    final id = json['idMeal'];
    return Dessert(
      id: id,
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
      price: _generatePriceFromId(id), // Memanggil generator harga
    );
  }

  // Factory ini digunakan saat memuat data dari database (Firestore).
  // Ini akan membaca harga yang TERSIMPAN, bukan membuat yang baru.
  factory Dessert.fromMap(Map<String, dynamic> map) {
    return Dessert(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      // Ambil harga dari map.
      // Jika karena suatu hal harga tidak ada, buat harga baru sebagai cadangan.
      price: (map['price'] as num? ?? _generatePriceFromId(map['id'])).toDouble(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price, // Menyimpan harga yang sebenarnya ke database
    };
  }

  // Fungsi helper untuk membuat harga yang konsisten berdasarkan ID produk.
  static double _generatePriceFromId(String id) {
    // menggunakan hashCode dari ID produk untuk mendapatkan angka yang unik & konsisten.
    // .abs() memastikan angkanya positif.
    // % 31 akan memberi kita angka antara 0 dan 30.
    // kalikan 1000 untuk mendapatkan kelipatan ribuan.
    // tambah harga dasar 20000.
    // Hasilnya: harga yang konsisten antara Rp 20.000 dan Rp 50.000.
    final priceStep = (id.hashCode.abs() % 31) * 1000;
    return (20000 + priceStep).toDouble();
  }
}
