class Kamus {
  
  String kosakata;
  String artinya;

  Kamus({this.kosakata, this.artinya});

  factory Kamus.fromJson(Map<String, dynamic> json) {
    return Kamus(
      
      kosakata: json["kata"] as String,
      artinya: json["arti"] as String,
    );
  }
}
