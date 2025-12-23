// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../injection_container.dart';

// /// Defines all route names used in the app
// class AppRoutes {
//   // Prevent instantiation
//   AppRoutes._();

//   // Route names
//   static const String addExpense = '/add-expense';
//   static const String addRecurringExpense = '/add-recurring-expense';
//   static const String manageCategories = '/manage-categories';
//   static const String recurringExpenses = '/recurring-expenses';

//   /// Generate routes with proper BLoC providers
//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case addExpense:
//         final args = settings.arguments as Map<String, dynamic>?;
//         return MaterialPageRoute(
//           builder:
//               (context) => MultiBlocProvider(
//                 providers: [
                  
//                 ],
//                 child: const SizedBox(),
//               ),
//           settings: settings,
//         );

      

//       default:
//         return MaterialPageRoute(
//           builder:
//               (_) => Scaffold(
//                 body: Center(
//                   child: Text('No route defined for ${settings.name}'),
//                 ),
//               ),
//         );
//     }
//   }

//   /// Helper method to navigate to a route with BLoCs from context
//   ///
//   /// Usage:
//   /// ```dart
//   /// AppRoutes.navigateWithBlocs(
//   ///   context,
//   ///   AppRoutes.addExpense,
//   ///   onReturn: () => print('Returned from route'),
//   /// );
//   /// ```
//   static Future<T?> navigateWithBlocs<T>(
//     BuildContext context,
//     String routeName, {
//     VoidCallback? onReturn,
//   }) {
//     // Capture BLoCs from context before navigation
//     final expensesBloc = context.read<ExpensesBloc>();
//     final categoryBloc = context.read<CategoryBloc>();
//     final accountBloc = context.read<AccountBloc>();

//     return Navigator.pushNamed<T>(
//       context,
//       routeName,
//       arguments: {
//         'expensesBloc': expensesBloc,
//         'categoryBloc': categoryBloc,
//         'accountBloc': accountBloc,
//       },
//     ).then((result) {
//       onReturn?.call();
//       return result;
//     });
//   }

//   /// Navigate to a route and reload expenses on return
//   ///
//   /// Usage:
//   /// ```dart
//   /// AppRoutes.navigateAndReload(context, AppRoutes.addExpense);
//   /// ```
//   static Future<T?> navigateAndReload<T>(
//     BuildContext context,
//     String routeName,
//   ) {
//     return navigateWithBlocs<T>(
//       context,
//       routeName,
//       onReturn: () {
//         context.read<ExpensesBloc>().add(LoadExpensesEvent());
//       },
//     );
//   }
// }
