import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:e_commerce/features/wishlist/domain/entities/entities.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/usecases.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetUserWishlistUseCase getUserWishlistUseCase;
  final GetWishlistWithProductsUseCase getWishlistWithProductsUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;
  final ClearUserWishlistUseCase clearUserWishlistUseCase;
  final IsInWishlistUseCase isInWishlistUseCase;

  WishlistBloc({
    required this.getUserWishlistUseCase,
    required this.getWishlistWithProductsUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
    required this.toggleWishlistUseCase,
    required this.clearUserWishlistUseCase,
    required this.isInWishlistUseCase,
  }) : super(WishlistInitial()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<ClearWishlistEvent>(_onClearWishlist);
    on<CheckWishlistStatusEvent>(_onCheckWishlistStatus);
    on<ResetWishlistEvent>(_onResetWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());

      final wishlistProducts =
          await getWishlistWithProductsUseCase.call(event.userId);

      // Create wishlist status map for quick lookups
      final wishlistStatus = <int, bool>{};
      for (final wishlistProduct in wishlistProducts) {
        wishlistStatus[wishlistProduct.wishlistItem.productId] = true;
      }

      emit(WishlistLoaded(
        wishlistProducts: wishlistProducts,
        wishlistStatus: wishlistStatus,
      ));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      await addToWishlistUseCase.call(
        productId: event.productId,
        userId: event.userId,
      );

      // Reload the wishlist to get updated state with product details
      final wishlistProducts =
          await getWishlistWithProductsUseCase.call(event.userId);
      final wishlistStatus = <int, bool>{};
      for (final wishlistProduct in wishlistProducts) {
        wishlistStatus[wishlistProduct.wishlistItem.productId] = true;
      }

      emit(WishlistItemAdded(
        productId: event.productId,
        wishlistProducts: wishlistProducts,
        wishlistStatus: wishlistStatus,
      ));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      await removeFromWishlistUseCase.call(
        productId: event.productId,
        userId: event.userId,
      );

      // Reload the wishlist to get updated state with product details
      final wishlistProducts =
          await getWishlistWithProductsUseCase.call(event.userId);
      final wishlistStatus = <int, bool>{};
      for (final wishlistProduct in wishlistProducts) {
        wishlistStatus[wishlistProduct.wishlistItem.productId] = true;
      }

      emit(WishlistItemRemoved(
        productId: event.productId,
        wishlistProducts: wishlistProducts,
        wishlistStatus: wishlistStatus,
      ));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final wasAdded = await toggleWishlistUseCase.call(
        productId: event.productId,
        userId: event.userId,
      );

      // Reload the wishlist to get updated state with product details
      final wishlistProducts =
          await getWishlistWithProductsUseCase.call(event.userId);
      final wishlistStatus = <int, bool>{};
      for (final wishlistProduct in wishlistProducts) {
        wishlistStatus[wishlistProduct.wishlistItem.productId] = true;
      }

      if (wasAdded) {
        emit(WishlistItemAdded(
          productId: event.productId,
          wishlistProducts: wishlistProducts,
          wishlistStatus: wishlistStatus,
        ));
      } else {
        emit(WishlistItemRemoved(
          productId: event.productId,
          wishlistProducts: wishlistProducts,
          wishlistStatus: wishlistStatus,
        ));
      }
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onClearWishlist(
    ClearWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      await clearUserWishlistUseCase.call(event.userId);
      emit(WishlistCleared(userId: event.userId));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onCheckWishlistStatus(
    CheckWishlistStatusEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final isInWishlist = await isInWishlistUseCase.call(
        productId: event.productId,
        userId: event.userId,
      );

      // Update the current state with the new status
      if (state is WishlistLoaded) {
        final currentState = state as WishlistLoaded;
        final updatedStatus = Map<int, bool>.from(currentState.wishlistStatus);
        updatedStatus[event.productId] = isInWishlist;

        emit(currentState.copyWith(wishlistStatus: updatedStatus));
      }
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  void _onResetWishlist(
    ResetWishlistEvent event,
    Emitter<WishlistState> emit,
  ) {
    emit(WishlistInitial());
  }
}
