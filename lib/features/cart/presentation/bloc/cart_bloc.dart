import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartItemCountUseCase getCartItemCountUseCase;
  final CheckItemInCartUseCase checkItemInCartUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartItemQuantityUseCase,
    required this.getCartItemsUseCase,
    required this.clearCartUseCase,
    required this.getCartItemCountUseCase,
    required this.checkItemInCartUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<GetCartItemCountEvent>(_onGetCartItemCount);
    on<ResetCartEvent>(_onResetCart);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());

      final items = await getCartItemsUseCase(event.userId);
      final itemCount = await getCartItemCountUseCase(event.userId);

      // Calculate totals
      final totalItems = items.fold(0, (sum, item) => sum + item.quantity);
      final totalPrice = items.fold(0.0, (sum, item) => sum + item.totalPrice);

      emit(CartLoaded(
        items: items,
        totalItems: totalItems,
        itemCount: itemCount,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addToCartUseCase(
        userId: event.userId,
        productId: event.productId,
        title: event.title,
        thumbnail: event.thumbnail,
        price: event.price,
        discountPercentage: event.discountPercentage,
        quantity: event.quantity,
      );

      emit(const CartItemAdded(message: 'Item added to cart successfully'));

      // Reload cart to get updated state
      add(LoadCartEvent(userId: event.userId));
    } catch (e) {
      emit(CartError(message: 'Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await removeFromCartUseCase(
        userId: event.userId,
        productId: event.productId,
      );

      emit(const CartItemRemoved(
          message: 'Item removed from cart successfully'));

      // Reload cart to get updated state
      add(LoadCartEvent(userId: event.userId));
    } catch (e) {
      emit(CartError(
          message: 'Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await updateCartItemQuantityUseCase(
        userId: event.userId,
        productId: event.productId,
        quantity: event.quantity,
      );

      emit(const CartItemUpdated(message: 'Cart item updated successfully'));

      // Reload cart to get updated state
      add(LoadCartEvent(userId: event.userId));
    } catch (e) {
      emit(CartError(message: 'Failed to update cart item: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await clearCartUseCase(event.userId);

      emit(const CartCleared(message: 'Cart cleared successfully'));

      // Reload cart to show empty state
      add(LoadCartEvent(userId: event.userId));
    } catch (e) {
      emit(CartError(message: 'Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onGetCartItemCount(
    GetCartItemCountEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final count = await getCartItemCountUseCase(event.userId);
      emit(CartItemCount(count: count));
    } catch (e) {
      emit(
          CartError(message: 'Failed to get cart item count: ${e.toString()}'));
    }
  }

  void _onResetCart(
    ResetCartEvent event,
    Emitter<CartState> emit,
  ) {
    emit(CartInitial());
  }
}
