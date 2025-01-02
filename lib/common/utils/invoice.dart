String generateInvoice() {
  String time = DateTime.now().toString().replaceAll(RegExp(r'[-:.\s]'), '');

  return 'Invoice-$time';
}