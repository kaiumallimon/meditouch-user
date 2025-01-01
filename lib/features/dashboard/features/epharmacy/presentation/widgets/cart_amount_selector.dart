import 'package:meditouch/app/app_exporter.dart';
import 'package:meditouch/features/dashboard/features/cart/models/cart_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/data/model/medicine_model.dart';
import 'package:meditouch/features/dashboard/features/epharmacy/logics/detailed_medicine_event.dart';
import '../../logics/detailed_medicine_state.dart';

void showQuantityDialog(
    BuildContext context, DetailedMedicineSuccess state, ColorScheme theme) {
  int quantity = 1;

  showDialog(
    context: context,
    barrierColor: theme.onSurface.withOpacity(.5),
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Quantity'),
        content: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Selected Unit: ',
                      style: TextStyle(color: theme.onSurface.withOpacity(.5))),
                  Text(
                    state.medicineDetails.unitPrices[state.selectedUnitIndex]
                        .unit,
                    style: TextStyle(
                        color: theme.primary, fontWeight: FontWeight.w600),
                  ), // This line is not working
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                        ),
                        Text(quantity.toString(),
                            style: TextStyle(
                                color: theme.onSurface,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () async {
              // process the cart

              // process the unitprice:
              final List<UnitPrice> prices = [];

              for (int i = 0;
                  i < state.medicineDetails.unitPrices.length;
                  i++) {
                prices.add(UnitPrice(
                    unit: state.medicineDetails.unitPrices[i].unit,
                    unitSize: state.medicineDetails.unitPrices[i].unitSize,
                    price: double.parse(
                        state.medicineDetails.unitPrices[i].price.toString())));
              }

              // medicine model

              final medicine = Medicine(
                  id: state.medicineDetails.medicineId,
                  medicineName: state.medicineDetails.medicineName,
                  categoryName: state.medicineDetails.categoryName,
                  slug: state.medicineDetails.slug,
                  genericName: state.medicineDetails.genericName,
                  strength: state.medicineDetails.strength,
                  manufacturerName: state.medicineDetails.manufacturerName,
                  discountType: state.medicineDetails.discountType,
                  discountValue: state.medicineDetails.discountValue,
                  isDiscountable: state.medicineDetails.isAvailable,
                  isAvailable: state.medicineDetails.isAvailable,
                  medicineImage: state.medicineDetails.medicineImage,
                  rxRequired: state.medicineDetails.rxRequired,
                  unitPrices: prices);

              // calculate the total price
              final totalPrice = quantity *
                  double.parse(state.medicineDetails
                      .unitPrices[state.selectedUnitIndex].price);

              // calculate the discounted price
              final double discount = state.medicineDetails.discountValue;
              double discountedPrice = totalPrice;

              if (discount > 0) {
                discountedPrice = totalPrice - (totalPrice * discount / 100);
              }

              // get user id from hive repo

              final userInfo = await HiveRepository().getUserInfo();

              // cart model

              final cart = CartModel(
                  cartId: "",
                  userId: userInfo!['id'],
                  medicine: medicine,
                  quantity: quantity,
                  unitIndex: state.selectedUnitIndex,
                  discountedPrice: discountedPrice,
                  createdAt: DateTime.now(),
                  totalPrice: totalPrice);

              context
                  .read<DetailedMedicineBloc>()
                  .add(AddToCartRequested(cart));

              // Close the dialog
              Navigator.of(context).pop(quantity);
            },
          ),
        ],
      );
    },
  );
}
