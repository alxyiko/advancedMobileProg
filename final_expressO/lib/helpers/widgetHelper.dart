 Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Color(0x19B8B8B8), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(
              color: Color(0x16B8B8B8), blurRadius: 4, offset: Offset(0, 4)),
          BoxShadow(
              color: Color(0x0CB8B8B8), blurRadius: 5, offset: Offset(0, 8)),
          BoxShadow(
              color: Color(0x02B8B8B8), blurRadius: 6, offset: Offset(0, 14)),
          BoxShadow(
              color: Color(0x00B8B8B8), blurRadius: 6, offset: Offset(0, 22)),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFFD4D0C2),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFD4D0C2),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }