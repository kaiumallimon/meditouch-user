// cart_event.dart
abstract class CartEvent {}

class LoadCart extends CartEvent {
  LoadCart();
}

class RemoveFromCart extends CartEvent {
  final List<String> cartIds;
  RemoveFromCart(this.cartIds);
}

class FilterCart extends CartEvent {
  final String sortBy; // "createdAt" or "totalPrice"
  final bool ascending; // true for ascending, false for descending
  FilterCart(this.sortBy, this.ascending);
}

class SelectCartItemsRequested extends CartEvent {
  final List<String> cartIds;
  SelectCartItemsRequested(this.cartIds);
}
