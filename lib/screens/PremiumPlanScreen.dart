import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumPlanScreen extends StatefulWidget {
  const PremiumPlanScreen({super.key});

  @override
  State<PremiumPlanScreen> createState() => _PremiumPlanScreenState();
}

class _PremiumPlanScreenState extends State<PremiumPlanScreen> {
  String selectedPlan = "Monthly";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Upgrade to Premium", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose a Plan",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ).animate().fade(duration: 500.ms).slideX(),
            const SizedBox(height: 20),
            _buildPlanCard("Monthly", "₹499/month", "Best for short-term usage"),
            _buildPlanCard("Yearly", "₹4999/year", "Save 20% with yearly plan"),
            const SizedBox(height: 30),
            Text(
              "Select Payment Method",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ).animate().fade(duration: 500.ms).slideX(),
            const SizedBox(height: 12),
            _buildPaymentMethod(Icons.credit_card, "Credit/Debit Card"),
            _buildPaymentMethod(Icons.account_balance_wallet, "UPI"),
            _buildPaymentMethod(Icons.paypal, "PayPal"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Proceed to Pay"),
              ).animate().fade(duration: 500.ms).scale(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String plan, String price, String description) {
    bool isSelected = plan == selectedPlan;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.yellow, width: 2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            Text(
              price,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellow),
            ),
          ],
        ),
      ).animate().fade(duration: 600.ms).slideX(),
    );
  }

  Widget _buildPaymentMethod(IconData icon, String method) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.yellow, size: 28),
            const SizedBox(width: 12),
            Text(
              method,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ).animate().fade(duration: 500.ms).slideX(),
    );
  }
}
