// Run all wishlist-related tests
import 'data/models/wishlist_item_model_test.dart' as model_tests;
// import 'data/repositories/wishlist_repository_impl_test.dart' as repo_tests;
import 'domain/entities/wishlist_item_entity_test.dart' as entity_tests;

void main() {
  model_tests.main();
  entity_tests.main();
  // repo_tests.main();
}
