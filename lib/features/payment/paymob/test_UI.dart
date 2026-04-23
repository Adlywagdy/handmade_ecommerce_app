import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/constants.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/paymob_manager/paymob_manager.dart';
import 'payment_webview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  int amount = 10;

  String method = "card"; // 💳 أو 📱
  final TextEditingController phoneController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paymob Integration")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 💰 المبلغ
            Text(
              "$amount EGP",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ➕➖
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decreaseAmount,
                  icon: const Icon(Icons.remove_circle, size: 40),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _increaseAmount,
                  icon: const Icon(Icons.add_circle, size: 40),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 💳📱 اختيار طريقة الدفع
            Row(
              children: [
                Expanded(
                  child: _buildMethodButton(
                    title: "Card",
                    value: "card",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMethodButton(
                    title: "Wallet",
                    value: "wallet",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 📱 رقم الموبايل
            if (method == "wallet")
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "+2010XXXXXXXX",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 30),

            // 💳 زر الدفع
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _pay,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Pay $amount EGP"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton({
    required String title,
    required String value,
  }) {
    final isSelected = method == value;

    return GestureDetector(
      onTap: () => setState(() => method = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _increaseAmount() {
    setState(() => amount += 10);
  }

  void _decreaseAmount() {
    if (amount > 1) {
      setState(() => amount -= 10);
    }
  }

  bool _isValidPhone(String phone) {
    final regex = RegExp(r'^(\+201|01)[0-9]{9}$');
    return regex.hasMatch(phone);
  }

  Future<void> _pay() async {
    setState(() => isLoading = true);

    try {
      final manager = PaymobManager();

      if (method == "card") {
        final paymentKey = await manager.getPaymentKey(
          amount: amount,
          currency: "EGP",
          integrationId: Constants.integrationIdCard,
        );

        final url =
            "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebView(paymentUrl: url),
          ),
        );
      } else {
        final phone = phoneController.text.trim();

        if (phone.isEmpty) {
          throw Exception("Enter phone number");
        }

        if (!_isValidPhone(phone)) {
          throw Exception("Invalid phone number");
        }

        final paymentKey = await manager.getPaymentKey(
          amount: amount,
          currency: "EGP",
          integrationId: Constants.integrationIdWallet,
        );

        final redirectUrl = await manager.payWithWallet(
          paymentKey: paymentKey,
          phone: phone,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PaymentWebView(paymentUrl: redirectUrl),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}