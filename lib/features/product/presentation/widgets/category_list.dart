// part of 'widgets.dart';

// class CategoryList extends StatelessWidget {
//   final List<CategoryEntity> categories;
//   final CategoryEntity? selectedCategory;
//   final Function(CategoryEntity) onCategorySelected;
//   final VoidCallback onClearFilter;

//   const CategoryList({
//     Key? key,
//     required this.categories,
//     this.selectedCategory,
//     required this.onCategorySelected,
//     required this.onClearFilter,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[50],
//       child: Column(
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Categories',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 if (selectedCategory != null)
//                   IconButton(
//                     icon: const Icon(Icons.clear, size: 20),
//                     onPressed: onClearFilter,
//                     tooltip: 'Clear filter',
//                   ),
//               ],
//             ),
//           ),

//           // Categories list
//           Expanded(
//             child: ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 final category = categories[index];
//                 final isSelected = category.slug == selectedCategory?.slug;

//                 return ListTile(
//                   title: Text(
//                     category.name, // Use the actual category name
//                     style: TextStyle(
//                       fontWeight: isSelected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       color: isSelected
//                           ? Theme.of(context).primaryColor
//                           : Colors.black,
//                     ),
//                   ),
//                   trailing: isSelected
//                       ? const Icon(Icons.check, size: 16)
//                       : null,
//                   onTap: () => onCategorySelected(category),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
